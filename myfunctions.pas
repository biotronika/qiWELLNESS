unit myFunctions;
// Module for definitions, REST interface, converters and physical models
// Copyleft 2020 by Chris Czoba krzysiek@biotronika.pl. See: biotronics.eu

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Forms, LCLIntf, HTTPSend, fphttpclient, fpjson, jsonparser, URLMon, Windows;

//Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
//Grids, HTTPSend, fphttpclient, fpjson, jsonparser, Windows, LCLIntf, myFunctions;

const
  SOFTWARE_VERSION = '2020-05-26 (beta)';

  ATLAS_FOLDER ='AtlasDB';               //Subfolder (exe file place) for pictures and indexed database text files
  ATLAS_POINTS_FILE = 'points.db';       //Text file name of ordered alphabetical list of all point names and numbers of pictures
  ATLAS_PICTURES_FILE ='pictures.db';    //Text file name of numbered pictures list
  MY_DELIMETER = ',';

  PROFILES : array[0..6] of string = ( 'User', 'Common', 'Stimulation', 'Sedation', 'DC-', 'DC+', 'DC change');



type TEAPPoint = record
     Point : string[20];
     Side : string [20];
     Profile : integer;
     Time : integer;
     Elapsed : integer;
end;

type TEAPPoints = array of TEAPPoint;


type TEAPTherapy = record
     Name : string;
     Description : string;
     StrPoints : string;
     Points : TEAPPoints;
end;

type TEAPTherapies = array of TEAPTherapy;


type
    TList = record
    Title,  FileName: string[50];
    Url : string [255];
    RestURL : string [255];
    FieldCount : integer;
    FieldNames : array[1..10] of string[50];
    FieldJsonPath : array[1..10] of string[50];
end;

const
   //Types of lists
   LIST_ION_SUBSTANCES = 1;
   LIST_EAV_PATHS = 2;
   LIST_EAP_THERAPY = 3;
   LIST_ATLAS = 4;  // atlas catalog with pictures

   DEFAULT_EAP_THERAPY_TIME = 120;  //120seconds;



   LISTS_DEF : array[1..4] of TList = (
         (
          Title : 'Iontophoresis substances'; FileName : 'iontophoresis.txt';
          Url : 'https://biotronics.eu/iontophoresis-substances';
          RestURL :'https://biotronics.eu/iontophoresis-substances/rest?_format=json';
          FieldCount : 4;
          FieldNames :    ('Substance','Active electrode','Molar mass','Valence','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_active_electrode[0].value','field_mol_mass[0].value','field_valence[0].value','','','','','','')
          ),

          (Title : 'Volls Electroacupuncture points'; FileName : 'eav.txt';
          Url : 'https://biotronics.eu/xxx';
          RestURL :'https://biotronics.eu/xxx/rest?_format=json';
          FieldCount : 1;
          FieldNames :    ('Substance','Active electrode','Molar mass','Valence','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_active_electrode[0].value','field_mol_mass[0].value','field_valence[0].value','','','','','','')
          ),

          (Title : 'EAP therapies'; FileName : 'EAPtherapies.txt';
          Url : 'https://biotronics.eu/eap-therapies';
          RestURL :'https://biotronics.eu/eap-therapies/rest?_format=json';
          FieldCount : 3;
          FieldNames :    ('EAP therapy name','BAPs','Description','','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_baps[0].value','.body[0].propossed','','','','','','','')
          ),

          (Title : 'Atlas'; FileName : 'Atlas.txt';
          Url : 'https://biotronics.eu/atlas';
          RestURL :'https://biotronics.eu/atlas/rest?_format=json';
          FieldCount : 4;
          FieldNames :    ('Points','Meridian','Picture Link','Synonyms','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_meridians[0].value','.field_picture[0].url','.field_synonyms[0].value','','','','','','')
          )

   ) ;

  TEMPORARY_FILE = '~temp.txt';


  var
    AtlasPointsDB : array of string;   // Ordered alphabetical list of all point names and numbers of pictures
    AtlasPicturesDB : array of string;  // List of numbered pictures




function calculateMass( mollMass : Double; z : Double; Q : Double (*mAh*)) : Double;
function StringToEAPTherapy(s : string) : TEAPPoints;
function AtlasCreatePicturesIndex(AtlasSitePicturesList : string) : integer; //Return number of pictures
function SearchBAP(BAP : string; PictureFilesList : TStringList) : integer; //Return number of pictures
procedure CreateDllLibraries();
function GetContentFromREST(var Content : string; RestURL : string; ExtraFilters : string = '') : integer; //Return number of items
function GetEAPTherapiesFromContent( Content : string; var EAPTherapies : TEAPTherapies) : integer;


implementation
uses Dialogs, unitUpdateList;



//ATLAS
function HexToInt(HexStr: String): Int64;
var RetVar : Int64;
    i : byte;
begin
  HexStr := UpperCase(HexStr);
  if HexStr[length(HexStr)] = 'H' then
     Delete(HexStr,length(HexStr),1);
  RetVar := 0;

  for i := 1 to length(HexStr) do begin
      RetVar := RetVar shl 4;
      if HexStr[i] in ['0'..'9'] then
         RetVar := RetVar + (byte(HexStr[i]) - 48)
      else
         if HexStr[i] in ['A'..'F'] then
            RetVar := RetVar + (byte(HexStr[i]) - 55)
         else begin
            Retvar := 0;
            break;
         end;
  end;

  Result := RetVar;
end;

function UrlDecode(const EncodedStr: String): String;
var
  I: Integer;
begin
  result := '';
  if Length(EncodedStr) > 0 then
  begin
    I := 1;
    while I <= Length(EncodedStr) do
    begin
      if EncodedStr[I] = '%' then
        begin
          result := result + Chr(HexToInt(EncodedStr[I+1]
                                       + EncodedStr[I+2]));
          I := Succ(Succ(I));
        end
      else if EncodedStr[I] = '+' then
        result := result + ' '
      else
        result := result + EncodedStr[I];

      I := Succ(I);
    end;
  end;
end;

function DownLoadInternetFile(SourceFile, DestinationFile : String): Boolean;
begin
  try
    result := URLDownloadToFile(nil,PChar(SourceFile),PChar(DestinationFile),0,nil) = 0
  except
    result := False;
  end;
end;



function GetURLFilename(const FilePath:String; Const Delimiter:String='/'):String;
    var I: Integer;
begin
    I := LastDelimiter(Delimiter, FILEPATH);
    Result := Copy(FILEPATH, I + 1, MaxInt);
    Result := UrlDecode(Result);
end;

function SearchBAP(BAP : string; PictureFilesList : TStringList) : integer; //Return number of pictures
var i,j : integer;
   // s :  string;
    appFolder, sourceFile, destinationFile: string;

    JSONData : TJSONData; //Do not use create
    content : string;

begin

  result:=0;
  PictureFilesList.Clear;

  //Create Atlas Database directory
  appFolder := ExtractFilePath(Application.ExeName);
  if not FileExists(appFolder + ATLAS_FOLDER) then  CreateDir( appFolder + ATLAS_FOLDER);


  // REST/JSON interface

     j := GetContentFromREST(content, LISTS_DEF[4].RestURL, 'field_synonyms_value=' + trim(BAP)+ '+');
     if j < 0 then Exit;

     try

       JSONData:=GetJSON(content);

       for i := 0 to JSONData.Count - 1 do begin
//TODO Progress bar with downloaded pictures

         sourceFile := JSONData.FindPath('['+IntToStr(i)+']'+'.field_picture[0].url').AsString;
         destinationFile := AppFolder + ATLAS_FOLDER + '\' +GetURLFilename(sourceFile) ;

         if not FileExists(destinationFile) then
            if not DownLoadInternetFile(sourceFile, destinationFile) then continue;

         PictureFilesList.Add(destinationFile);

       end;

       result:=PictureFilesList.Count;

     finally
       JSONData.Free;
     end;


end;

function GetContentFromREST(var Content : string; RestURL : string ; ExtraFilters : string = '') : integer;
(* KC 2020-05-25

REST/JSON interface. Can connect http and https.
  RestURL - e.g.: https://biotronics.eu/eap-therapies/rest?_format=json
  ExtraFilters - e.g.: &title=anorexia
  Content - JSON content data
  result - Length of Content, -1=error

*)
var
    HTTPClient: TFPHttpClient;

begin

  result := -1; //error

//TODO: Exeptions
  try

     HTTPClient:=TFPHttpClient.Create(Nil);
     CreateDllLibraries(); //Create Openssl libraries

     HTTPClient.AddHeader('User-Agent','qiwellness');  //For GITHUB only
     Content:=HTTPClient.Get( RestURL + '&' + trim(ExtraFilters)  );

     result:= Content.Length;

  finally
     HTTPClient.Free;
  end;

end;

function GetEAPTherapiesFromContent( Content : string; var EAPTherapies : TEAPTherapies) : integer;
const LIST_TYPE = LIST_EAP_THERAPY;
var
    i,j : integer;
    s : string;
    JSONData : TJSONData; //Do not use create

begin

     result:=0;

     SetLength(EAPTherapies,0);


     try

        JSONData:=GetJSON(content);

        j:= JSONData.Count;

        SetLength(EAPTherapies, j);

        for i := 0 to j - 1 do begin


          s:= '['+IntToStr(i)+']' + LISTS_DEF[LIST_TYPE].FieldJsonPath[1];
          EAPTherapies[i].Name         := JSONData.FindPath( s ).AsString;
          //EAPTherapies[i].Description  := JSONData.FindPath( '['+IntToStr(i)+']' + LISTS_DEF[LIST_TYPE].FieldJsonPath[3] ).AsString;
          s                            := JSONData.FindPath( '['+IntToStr(i)+']' + LISTS_DEF[LIST_TYPE].FieldJsonPath[2] ).AsString;
          EAPTherapies[i].Points       := StringToEAPTherapy( s );
          EAPTherapies[i].StrPoints    := s;

        end;

     finally
          JSONData.Free;
     end;

end;


function AtlasCreatePicturesIndex(AtlasSitePicturesList : string) : integer;  //return count of pictures;
var txtIN,txtOUT : textFile;
    txtOutFileName : string;
    txtInIOResult : Word;
    s,sPictureLink,sPoints : string;
    PointsStringList, LinksStringList : TStringList;
    count,i : integer;
begin
  result:= -1;
  try
    PointsStringList := TStringList.Create;
    LinksStringList  := TStringList.Create;

    count := 0;


    //Create folder
    txtOutFileName := ExtractFilePath(Application.ExeName) + ATLAS_FOLDER;
    if not DirectoryExists(txtOutFileName ) then CreateDir(txtOutFileName);

    txtOutFileName+= '\' + ATLAS_PICTURES_FILE;

    AssignFile(txtIN,AtlasSitePicturesList);
    AssignFile(txtOUT,txtOutFileName);

    {$I-}
    Reset(txtIN);
    {$I+}

    if IOResult<>0 then begin
//TODO : Error handling
      ShowMessage( 'Error: Cannot process atlas index file: '+ AtlasSitePicturesList);
      Exit;
    end;


    while not Eof(txtIn) do begin

      readln(txtIn,s);
      inc(count);

      //First line contains titles
      if count=1 then Continue;

      i:= Pos(MY_DELIMETER,s);
      sPoints:=LeftBStr(s,i-1);

      //Picture links index
      sPictureLink:=Trim(RightBStr(s,Length(s)-i));
      LinksStringList.Add(sPictureLink);


   end;

     LinksStringList.SaveToFile(txtOutFileName);




  finally
    PointsStringList.Free;
    LinksStringList.Free;
    CloseFile(txtIn);
  end;

  result:=count;

end;




function StringToEAPTherapy(s : string) : TEAPPoints;
//Converts strings like "CV24[240] GV26[240]" to array of points

var OnePointString : string;
  i,l,n:integer;
  Points : TEAPPoints;

  //Internal function
  function GetTimeFromOnePointString(var OnePointString: string) : integer;
  var s : string;
      i,j : integer;
  begin
       result:= DEFAULT_EAP_THERAPY_TIME;

       i:= Pos('[',OnePointString);
       j:= Pos(']',OnePointString);
       if (i>1) and (j>0) then begin
          s:= trim(copy(OnePointString,i+1,j-i-1));
          result:=StrToIntDef(s,DEFAULT_EAP_THERAPY_TIME);
          OnePointString:=copy(OnePointString,1,i-1) + copy(OnePointString, j+1, OnePointString.Length-1 );
       end;
  end;

  function GetSideFromOnePointString(var OnePointString: string) : string;
  var s : string;
      i,j : integer;
  begin
       result:= ''; //NA

       i:= Pos('(',OnePointString);
       j:= Pos(')',OnePointString);
       if (i>1) and (j>0) then begin
          s:= UpperCase( trim(   copy(OnePointString,i+1,j-i-1)   ) );

          if  (s='B') or (s='R,L') or (s='RL') or (s='LR') or (s='L,R') then

              result:='Right, Left'

          else if s='R' then

               result := 'Right'

          else if s='L' then

               result := 'Left';

          OnePointString:=copy(OnePointString,1,i-1);
       end;
  end;


begin
  i:=0;
  s:=trim(s)+' ';

  SetLength(Points,0);

  if trim(s)<>'' then begin

    repeat

     l:= PosEx(' ',s,i+1)-i;

     if l>2 then begin
       OnePointString:= Trim(copy(s,i,l));

       SetLength(Points, Length(Points)+1);
       n:= Length(Points)-1;

       //Important is an order
       Points[n].Time := GetTimeFromOnePointString(OnePointString);
       Points[n].Side := GetSideFromOnePointString(OnePointString);
       Points[n].Point := OnePointString;

       Points[n].Profile:= 0;   //Profile User


       //ShowMessage(OnePointString);


     end;
     i:=i+l;

    until i>=Length(s)-1;

  end;

  result:= Points;

end;

procedure CreateDllLibraries();
(* KC 2020-05-25
Create Openssl DLLs from qiWELLNESS.exe resource if is not available


*)
var
  AppFolder: string;
  ResourceStream: TResourceStream;

begin
  //Create OpenSSL libraries from exe resource

  AppFolder := ExtractFilePath(Application.ExeName);

  if not FileExists(AppFolder + 'libeay32.dll') then begin
    try
      ResourceStream := TResourceStream.Create(HInstance, 'LIBEAY32', RT_RCDATA);
      ResourceStream.Position := 0;
      ResourceStream.SaveToFile( AppFolder + 'libeay32.dll' );

    finally
      ResourceStream.Free;
    end;
end;

  if not FileExists(AppFolder + 'ssleay32.dll') then begin
    try
      ResourceStream := TResourceStream.Create(HInstance, 'SSLEAY32', RT_RCDATA);
      ResourceStream.Position := 0;
      ResourceStream.SaveToFile( AppFolder + 'ssleay32.dll' );

    finally
      ResourceStream.Free;
    end;
  end;

end;


function calculateMass( mollMass : Double; z : Double; Q : Double (*mAh*)) : Double;
(* Calculate the mass of drug deposited during iontophoresis

    mollMass - Moll mass [g/moll]- depends on substance
    z - valence electron - depends on substance
    Q - charge [C]=[A*s], Q =  I*t  = {integr. 0-t} Idt
    k - electrochemical equivalent, k = M/(z*F)
    F - Faraday constant, 96500 [C/mol]
    m - mass, m = k * Q
*)

var
  k,m : Double;
begin
  k := mollMass / (z*96500);  // [g / C]  = [g / (A*s)]
  m := k*Q; // [ mA * 3600s * g / (A*s) ] = [3.6g]
  m := 3.6 * m; // [g]
  calculateMass := m;

end;

end.


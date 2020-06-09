unit myFunctions;
(* elektros: 2020-06-07
 * Module for definitions, REST interface, converters and physical models
//TODO: Divide unit to three: constans definitions,  REST interface and physical models
 *
 *   Copyleft 2020 by elektros230, Chris Czoba krzysiek@biotronika.pl.
 *   See: biotronics.eu
 *)

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Forms, LCLIntf, (*HTTPSend,*) fphttpclient, fpjson, jsonparser, unitDownload;

const
  SOFTWARE_VERSION = '2020-06-09 (alpha)';

  PAGE_URL_REST = 'http://biotronics.eu';
  PAGE_URL_EN   = 'https://biotronics.eu';
  PAGE_URL_PL   = 'https://biotronika.pl';

  ATLAS_FOLDER ='AtlasDB';               //Subfolder (exe file place) for pictures and indexed database text files

  PROFILES : array[0..6] of string = ( 'User', 'Common', 'Stimulation', 'Sedation', 'DC-', 'DC+', 'DC change');

//MULTIPLATFORM DEFINITIONS
  VK_RETURN = 13;
  MY_DELIMETER = ',';


//EAP therapy
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
     Url : string;
     Langcode : string;
end;

type TEAPTherapies = array of TEAPTherapy;


//Bioresonance therapy
type TBioresonanceTherapy = record
     Name : string;
     Description : string;
     TherapyScript : string;
     Devices : string;   //freePEMF, multiZAP etc.
     Url : string;
     Langcode : string;
end;

type TBioresonanceTherapies = array of TBioresonanceTherapy;

//REST list
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
   //Types of REST lists
   LIST_ION_SUBSTANCES       = 1;
   LIST_EAV_PATHS            = 2;
   LIST_EAP_THERAPY          = 3;
   LIST_ATLAS                = 4;  // atlas catalog with pictures
   LIST_BIORESONANCE_THERAPY = 5;  // freePEMF and multiZAP

   DEFAULT_EAP_THERAPY_TIME = 120; // 120 seconds



   LISTS_DEF : array[1..5] of TList = (
         (
          Title         : 'Iontophoresis substances'; FileName : 'iontophoresis.txt';
          Url           : PAGE_URL_EN + '/iontophoresis-substances';
          RestURL       : PAGE_URL_REST + '/iontophoresis-substances/rest?_format=json';
          FieldCount    : 4;
          FieldNames    : ('Substance','Active electrode','Molar mass','Valence','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_active_electrode[0].value','field_mol_mass[0].value','field_valence[0].value','','','','','','')
          ),

          (Title        : 'Volls Electroacupuncture points'; FileName : 'eav.txt';
          Url           : PAGE_URL_EN + '/???';
          RestURL       : PAGE_URL_REST + '/???/rest?_format=json';
          FieldCount    : 1;
          FieldNames    : ('Substance','Active electrode','Molar mass','Valence','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_active_electrode[0].value','field_mol_mass[0].value','field_valence[0].value','','','','','','')
          ),

          (Title        : 'EAP therapies'; FileName : 'EAPtherapies.txt';
          Url           : PAGE_URL_EN + '/eap-therapies';
          RestURL       : PAGE_URL_REST + '/eap-therapies/rest?_format=json';
          FieldCount    : 3;
          FieldNames    : ('EAP therapy name','BAPs','Description','','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_baps[0].value','.body[0].processed','','','','','','','')
          ),

          (Title        : 'Atlas'; FileName : 'Atlas.txt';
          Url           : PAGE_URL_EN + '/atlas';
          RestURL       : PAGE_URL_REST + '/atlas/rest?_format=json';
          FieldCount    : 4;
          FieldNames    : ('Points','Meridian','Picture Link','Synonyms','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_meridians[0].value','.field_picture[0].url','.field_synonyms[0].value','','','','','','')
          ),

          (Title        : 'Bioresonance Therapy'; FileName : 'bioresonance-therapy.txt';
          Url           : PAGE_URL_EN + '/bioresonance-therapies';
          RestURL       : PAGE_URL_REST + '/bioresonance-therapies/rest?_format=json';
          FieldCount    : 5;
          FieldNames    : ('Name','+Devices','Therapy script','Node','Description','','','','','');
          FieldJsonPath : ('.title[0].value','.field_urzadzenie[%d].value','.field_skrypt[0].value','.nid[0].value','.body[0].value','','','','','')
          )

   ) ;

  TEMPORARY_FILE = '~temp.txt';

  const
         MODE_UNK =-1; //unknown
         MODE_EAP = 0;
         MODE_EAV = 1;
         MODE_VEG = 2;
         MODE_RYO = 3; //Ryodoraku
         MODE_ION = 4; //Ionophoreses & zapper


  var
    AtlasPointsDB : array of string;   // Ordered alphabetical list of all point names and numbers of pictures
    AtlasPicturesDB : array of string;  // List of numbered pictures




function calculateMass( mollMass : Double; z : Double; Q : Double (*mAh*)) : Double;
function StringToEAPTherapy(s : string) : TEAPPoints;

function SearchBAP(BAP : string; PictureFilesList : TStringList) : integer; //Return number of pictures
function GetContentFromREST(var Content : string; RestURL : string; ExtraFilters : string = '') : integer; //Return number of items
function GetEAPTherapiesFromContent( Content : string; var EAPTherapies : TEAPTherapies) : integer;
function GetBioresonanceTherapiesFromContent( Content : string; var BioresonanceTherapies : TBioresonanceTherapies) : integer;
function HTML2PlainText(S: string): string;


implementation
uses Dialogs;

function HTML2PlainText(S: string): string;
(* 2020-06-01
 * Source: http://www.festra.com/eng/snip12.htm
 * Original name: StripHTML
 *)
var
  TagBegin, TagEnd, TagLength: integer;
begin
  TagBegin := Pos( '<', S);

  while (TagBegin > 0) do begin
    TagEnd := Pos('>', S);
    TagLength := TagEnd - TagBegin + 1;
    Delete(S, TagBegin, TagLength);
    TagBegin:= Pos( '<', S);
  end;

  result := S;
end;


function DownLoadInternetFile(Source, Dest : string): Boolean;
begin
  try
     Application.ProcessMessages;
     result := DownloadFrInternet.DownloadInternetFile (Source, Dest);
  except
    result := False;
  end;
end;



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
  i: Integer;
begin
  result := '';
  if Length(EncodedStr) > 0 then
  begin
    i := 1;
    while i <= Length(EncodedStr) do
    begin
      if EncodedStr[i] = '%' then
        begin
          result := result + Chr(HexToInt(EncodedStr[i+1]
                                       + EncodedStr[i+2]));
          i := Succ(Succ(i));
        end
      else if EncodedStr[i] = '+' then
        result := result + ' '
      else
        result := result + EncodedStr[i];

      i := Succ(i);
    end;
  end;
end;




function GetURLFilename(const FilePath : string; Const Delimiter: string='/'): string;
var i: Integer;
begin
    i := LastDelimiter(Delimiter, FILEPATH);
    Result := Copy(FILEPATH, i + 1, MaxInt);
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
(* elektros 2020-05-25
 *
 * REST/JSON interface. Can connect http and https.
 *   RestURL - e.g.: https://biotronics.eu/eap-therapies/rest?_format=json
 *   ExtraFilters - e.g.: &title=anorexia
 *   Content - JSON content data
 *   result - Length of Content, -1=error
 *)
var
    HTTPClient: TFPHttpClient;

begin

  result := -1; //error

//TODO: Exeptions handling
  try

     HTTPClient:=TFPHttpClient.Create(Nil);

     HTTPClient.AllowRedirect := false; //true; //If status 301, but there is no SSL support

     //HTTPClient.AddHeader('User-Agent','qiwellness');
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
          EAPTherapies[i].Description  := JSONData.FindPath( '['+IntToStr(i)+']' + LISTS_DEF[LIST_TYPE].FieldJsonPath[3] ).AsString;
          s                            := JSONData.FindPath( '['+IntToStr(i)+']' + LISTS_DEF[LIST_TYPE].FieldJsonPath[2] ).AsString;
          EAPTherapies[i].Points       := StringToEAPTherapy( s );
          EAPTherapies[i].StrPoints    := s;

        end;

     finally
          JSONData.Free;
     end;

end;

//////
function GetBioresonanceTherapiesFromContent( Content : string; var BioresonanceTherapies : TBioresonanceTherapies) : integer;
const LIST_TYPE = LIST_BIORESONANCE_THERAPY;
var
    i,count,j : integer;
    s,pageUrl : string;
    JSONData : TJSONData; //Do not use create

begin

     result:=0;
     SetLength(BioresonanceTherapies,0);

     try

        JSONData:=GetJSON(content);

        count:= JSONData.Count;

        SetLength(BioresonanceTherapies, count);

        for i := 0 to count - 1 do begin

          BioresonanceTherapies[i].Name         := JSONData.FindPath( '['+IntToStr(i)+'].title[0].value'        ).AsString;
          BioresonanceTherapies[i].TherapyScript:= JSONData.FindPath( '['+IntToStr(i)+'].field_skrypt[0].value' ).AsString;
          BioresonanceTherapies[i].Description  := JSONData.FindPath( '['+IntToStr(i)+'].body[0].value'         ).AsString;
          BioresonanceTherapies[i].Langcode     := JSONData.FindPath( '['+IntToStr(i)+'].langcode[0].value'     ).AsString;

          if UpperCase(BioresonanceTherapies[i].Langcode ) = 'PL' then
             pageURL := PAGE_URL_PL
          else
             pageUrl := PAGE_URL_REST;

          BioresonanceTherapies[i].Url := pageUrl + '/node/' + JSONData.FindPath( '['+IntToStr(i)+'].nid[0].value' ).AsString;

          for j:= 0 to JSONData.FindPath('['+IntToStr(i)+']'+'.field_urzadzenie').Count-1 do begin

            s  := format('['+IntToStr(i)+'].field_urzadzenie[%d].value', [j] );
            BioresonanceTherapies[i].Devices      := trim( BioresonanceTherapies[i].Devices + ' '+JSONData.FindPath( s ).AsString);

          end;

        end;

     finally
          JSONData.Free;
     end;

end;


/////

(*
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
*)




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


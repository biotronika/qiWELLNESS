unit bioREST;
(* elektros: 2020-06-10
 *   Module for REST/JSON interface and web
 *   Multiplatform module, works with REST/JSON on hhtp protocol only (does not support SSL)
 *
 *   Copyleft 2020 by elektros, Chris Czoba krzysiek@biotronika.pl.
 *   See: biotronics.eu
 *)

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, StrUtils, Forms, LCLIntf, fphttpclient, fpjson, jsonparser, Dialogs, bioFunctions;

const
  PAGE_URL_REST   = 'http://biotronics.eu';
  PAGE_URL_EN     = 'https://biotronics.eu';
  PAGE_URL_PL     = 'https://biotronika.pl';

  ATLAS_SUBFOLDER = 'atlas';   // Subfolder of exe file where be placed pictures

  USER_AGENT      = 'qiwellness';

   //Types of REST lists
   LIST_ION_SUBSTANCES       = 1;
   LIST_EAV_PATHS            = 2;
   LIST_EAP_THERAPY          = 3;
   LIST_ATLAS                = 4;  // atlas catalog with pictures
   LIST_BIORESONANCE_THERAPY = 5;  // freePEMF and multiZAP

   LIST_REST_URLS : array[1..5] of string = (
     PAGE_URL_REST + '/iontophoresis-substances/rest?_format=json',
     PAGE_URL_REST + '/???/rest?_format=json',
     PAGE_URL_REST + '/eap-therapies/rest?_format=json',
     PAGE_URL_REST + '/atlas/rest?_format=json',
     PAGE_URL_REST + '/bioresonance-therapies/rest?_format=json'
   );


// EAP therapy
type TEAPPoint = record
     Point : string[20];
     Side : string [20];
     Profile : integer;
     Time : integer;
     Elapsed : integer;
end;

type TEAPPoints = array of TEAPPoint;


type TEAPTherapy = record
     Name            : string;
     Description     : string;
     StrPoints       : string;
     Points          : TEAPPoints;
     Url             : string;
     Langcode        : string;
end;

type TEAPTherapies = array of TEAPTherapy;


// Bioresonance therapy
type TBioresonanceTherapy = record
     Name            : string;
     Description     : string;
     TherapyScript   : string;
     Devices         : string;   //freePEMF, multiZAP etc.
     Url             : string;
     Langcode        : string;
end;

type TBioresonanceTherapies = array of TBioresonanceTherapy;

// Iontophoresis substances
type TIONSubstance = record
     Name            : string;
     ActiveElectrode : string;
     Valence         : integer;
     MolarMass       : double;
end;

type TIONSubstances = array of TIONSubstance;


  // Auxilary functions
  function HTML2PlainText(s: string): string;
  function HexToInt(HexStr: string): Int64;
  function UrlDecode(const EncodedStr: string): string;


  function StringToEAPTherapy(s : string) : TEAPPoints;
  function SearchBAP(BAP : string; PictureFilesList : TStringList) : integer; //Return picture URLs if PictureFilesList

  function GetContentFromREST(var Content : string; RestURL : string; ExtraFilters : string = '') : integer; //Return string Content with JSON

  function GetEAPTherapiesFromContent( Content : string; var EAPTherapies : TEAPTherapies) : integer;
  function GetBioresonanceTherapiesFromContent( Content : string; var BioresonanceTherapies : TBioresonanceTherapies) : integer;
  function GetIONSubstancesFromContent( Content : string; var IONSubstances : TIONSubstances) : integer;


implementation


function HTML2PlainText(s: string): string;
(* 2020-06-01
 * Source: http://www.festra.com/eng/snip12.htm
 * Original name: StripHTML
 *)
var
  TagBegin, TagEnd, TagLength: integer;
begin

  TagBegin := Pos( '<', s);

  while (TagBegin > 0) do begin
    TagEnd := Pos('>', s);
    TagLength := TagEnd - TagBegin + 1;
    Delete(s, TagBegin, TagLength);
    TagBegin:= Pos( '<', s);
  end;

  result := s;

end;

//ATLAS
function HexToInt(HexStr: string): Int64;
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

  result := RetVar;
end;

function UrlDecode(const EncodedStr: string): string;
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


function DownLoadInternetFile(Source, Dest : string): Boolean;
var
  HTTPClient: TFPHttpClient;
begin
  Result := False;
  HTTPClient := TFPHTTPClient.Create(nil);
  try

    HTTPClient.AllowRedirect := True;  // Status 301 supports
    HTTPClient.AddHeader('User-Agent',USER_AGENT);

    try
      HTTPClient.Get(Source, Dest);
      Result := True;
    except
      on E: Exception do
        ShowMessage(E.Message)
    end;
  finally
     HTTPClient.Free;
  end;
end;

function SearchBAP(BAP : string; PictureFilesList : TStringList) : integer; //Return number of pictures
var i,j,fSize : integer;
    appFolder, sourceFile, destinationFile: string;
    JSONData : TJSONData; //Do not use create
    content : string;
    F : file;

begin

  result := 0;
  PictureFilesList.Clear;

  //Create Atlas Database directory
  appFolder := ExtractFilePath(Application.ExeName);
  if not FileExists(appFolder + ATLAS_SUBFOLDER) then  CreateDir( appFolder + ATLAS_SUBFOLDER);


  // REST/JSON interface

     j := GetContentFromREST(content, LIST_REST_URLS[LIST_ATLAS] , 'field_synonyms_value=' + trim(BAP)+ '+');
     if j < 0 then Exit;

     try

       JSONData:=GetJSON(content);

       for i := 0 to JSONData.Count - 1 do begin

         sourceFile := JSONData.FindPath('['+IntToStr(i)+']'+'.field_picture[0].url').AsString;
         destinationFile := AppFolder + ATLAS_SUBFOLDER + BIO_FOLDER_DELIMETER +GetURLFilename(sourceFile) ;

//TODO: Download also file if exists but its size is 0B
         if not FileExists(destinationFile) then begin
            if not DownLoadInternetFile(sourceFile, destinationFile) then continue;
         end else begin
             Assign (F,destinationFile);
             {$I-}
             Reset (F);
             {$I+}
             fSize := FileSize( F );
             Close (F);
           if fSize = 0 then
             if not DownLoadInternetFile(sourceFile, destinationFile) then continue;

         end;


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

  result := -1;

  try

     HTTPClient:=TFPHttpClient.Create(Nil);

     HTTPClient.AllowRedirect := true; //If status 301
     HTTPClient.AddHeader('User-Agent', USER_AGENT);

     try
        Content:=HTTPClient.Get( RestURL + '&' + trim(ExtraFilters)  );
        result:= Content.Length;
     except
       on E: Exception do
         ShowMessage(E.Message)
     end;
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

          EAPTherapies[i].Name         := JSONData.FindPath( '['+IntToStr(i)+']' + '.title[0].value'      ).AsString;
          EAPTherapies[i].Description  := JSONData.FindPath( '['+IntToStr(i)+']' + '.body[0].processed'   ).AsString;
          s                            := JSONData.FindPath( '['+IntToStr(i)+']' + '.field_baps[0].value' ).AsString;
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

function GetIONSubstancesFromContent( Content : string; var IONSubstances : TIONSubstances) : integer;
const LIST_TYPE = LIST_ION_SUBSTANCES;
var
    i,count : integer;
    JSONData : TJSONData; //Do not use create

begin

     result:=0;
     SetLength(IONSubstances,0);

     try

        JSONData:=GetJSON(content);

        count:= JSONData.Count;

        SetLength(IONSubstances, count);

        for i := 0 to count - 1 do begin

          IONSubstances[i].Name            := JSONData.FindPath( '['+IntToStr(i)+'].title[0].value'                  ).AsString;
          IONSubstances[i].ActiveElectrode := JSONData.FindPath( '['+IntToStr(i)+'].field_active_electrode[0].value' ).AsString;
          IONSubstances[i].MolarMass       := JSONData.FindPath( '['+IntToStr(i)+'].field_mol_mass[0].value'         ).AsFloat;
          IONSubstances[i].Valence         := JSONData.FindPath( '['+IntToStr(i)+'].field_valence[0].value'          ).AsInteger;

        end;

     finally
          JSONData.Free;
     end;

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


end.


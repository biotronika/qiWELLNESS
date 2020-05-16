unit myFunctions;
// Module for definitions, REST interface, converters and physical models
// Copyleft 2020 by Chris Czoba krzysiek@biotronika.pl. See: biotronics.eu

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Forms;

const
  SOFTWARE_VERSION = '2020-05-16_1 (beta)';

  ATLAS_FOLDER ='AtlasDB';                 //Subfolder (exe file place) for pictures and indexed database text files
  ATLAS_POINTS_FILE = 'points.db';       //Text file name of ordered alphabetical list of all point names and numbers of pictures
  ATLAS_PICTURES_FILE ='pictures.db';    //Text file name of numbered pictures list
  MY_DELIMETER = ',';



type TEAPPoint = record
     Point : string[10];
     Meridian : string [50];
     Profile : integer;
     Time : integer;
     Elapsed : integer;
end;


type TEAPTherapy = array of TEAPPoint;


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
   LIST_EAP_PATHS = 3;
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
          FieldCount : 2;
          FieldNames :    ('EAP therapy name','BAPs','','','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_baps[0].value','','','','','','','','')
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
function StringToEAPTherapy(s : string) : TEAPTherapy;

function AtlasCreatePicturesIndex(AtlasSitePicturesList : string) : integer; //Return number of pictures

implementation
uses Dialogs;

//ATLAS
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




function StringToEAPTherapy(s : string) : TEAPTherapy;
//Converts strings like "CV24[240] GV26[240]" to structurized records

var OnePointString : string;
  i,l,n:integer;
  EAPTherapy : TEAPTherapy;

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
          OnePointString:=copy(OnePointString,1,i-1);
       end;
  end;


begin
  i:=0;
  s:=trim(s)+' ';

  SetLength(EAPTherapy,0);

  if trim(s)<>'' then begin

    repeat

     l:= PosEx(' ',s,i+1)-i;

     if l>2 then begin
       OnePointString:= Trim(copy(s,i,l));

       SetLength(EAPTherapy, Length(EAPTherapy)+1);
       n:= Length(EAPTherapy)-1;
       EAPTherapy[n].Time := GetTimeFromOnePointString(OnePointString);
       EAPTherapy[n].Point := OnePointString;
       EAPTherapy[n].Meridian:='';
       EAPTherapy[n].Profile:=1;


       //ShowMessage(OnePointString);


     end;
     i:=i+l;

    until i>=Length(s)-1;

  end;

  result:= EAPTherapy;

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


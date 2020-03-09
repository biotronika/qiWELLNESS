unit myFunctions;
// Module for converters and physical models & definitions of REST interface
// Copyleft by Chris Czoba 2020

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils;

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
   LIST_CATALOG = 4;

   DEFAULT_EAP_THERAPY_TIME = 120;  //120seconds;



  LISTS_DEF : array[1..3] of TList = (
         (
          Title : 'Iontophoresis substances'; FileName : 'iontophoresis.txt';
          Url : 'https://biotronics.eu/iontophoresis-substances';
          RestURL :'https://biotronics.eu/iontophoresis-substances/rest?_format=json';
          FieldCount : 4;
          FieldNames :    ('Substance','Active electrode','Molar mass','Valence','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_active_electrode[0].value','field_mol_mass[0].value','field_valence[0].value','','','','','','')
          ),

          (Title : 'xxx'; FileName : 'xxx.txt';
          Url : 'https://biotronics.eu/iontophoresis-substances';
          RestURL :'https://biotronics.eu/iontophoresis-substances/rest?_format=json';
          FieldCount : 1;
          FieldNames :    ('Substance','Active electrode','Molar mass','Valence','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_active_electrode[0].value','field_mol_mass[0].value','field_valence[0].value','','','','','','')
          ),

          (Title : 'EAP therapies'; FileName : 'EAPtherapies.txt';
          Url : 'https://biotronics.eu/eap-therapies';
          RestURL :'https://biotronics.eu/eap-therapies/rest?_format=json';
          FieldCount : 2;
          FieldNames :    ('EAP therapy name','BAPs','Link','','','','','','','');
          FieldJsonPath : ('.title[0].value','.field_baps[0].value','','field_valence[0].value','','','','','','')
          )

   ) ;

  TEMPORARY_FILE = '~temp.txt';



function calculateMass( mollMass : Double; z : Double; Q : Double (*mAh*)) : Double;
function StringToEAPTherapy(s : string) : TEAPTherapy;

implementation
uses Dialogs;


function StringToEAPTherapy(s : string) : TEAPTherapy;
//Converts strings like "CV24[240] GV26[240]" to structurized records

var OnePointString : string;
  i,l,n:integer;
  EAPTherapy : TEAPTherapy;

function GetTimeFromOnePointString(OnePointString: string) : integer;
//Internal function.
begin


  result:= DEFAULT_EAP_THERAPY_TIME;
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


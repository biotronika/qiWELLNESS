unit bioFunctions;
(* elektros: 2020-06-10
 * Module for definitions and converters physical models
 *
 *   Copyleft 2020 by elektros, Chris Czoba krzysiek@biotronika.pl.
 *   See: biotronics.eu
 *)

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Forms, LCLIntf, fphttpclient, fpjson, jsonparser;

const
  SOFTWARE_VERSION = '2020-06-11_1 (alpha)';



// MULTIPLATFORM DEFINITIONS
  VK_RETURN = 13;
  BIO_DELIMETER = ',';

  {$IFDEF DARWIN}
    OS_VERSION           = 'Mac OS;
    BIO_FOLDER_DELIMETER = '/';
    FIRST_SERIAL_PORT    = '/dev/tty0';
  {$ELSE}


  {$IFDEF Linux}
    OS_VERSION           = 'Linux';
    BIO_FOLDER_DELIMETER = '/';
    FIRST_SERIAL_PORT    = '/dev/ttyS1';
  {$ELSE}


  {$IFDEF UNIX}
    OS_VERSION           = 'Unix';
    BIO_FOLDER_DELIMETER = '/';
    FIRST_SERIAL_PORT    = '/dev/tty0';
  {$ELSE}


  {$IFDEF WINDOWS}
  {$IFDEF WIN32}
    OS_VERSION           = 'Windows 32bit';
  {$ELSE}
  {$IFDEF WIN64}
    OS_VERSION           = 'Windows 64bit';
  {$ENDIF}
  {$ENDIF}

    BIO_FOLDER_DELIMETER = '\';
    FIRST_SERIAL_PORT    = 'COM1';
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}


   DEFAULT_EAP_THERAPY_TIME = 120; // 120 seconds
   PROFILES : array[0..6] of string = ( 'User', 'Common', 'Stimulation', 'Sedation', 'DC-', 'DC+', 'DC change');


(* DEPRECATED

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
*)

  TEMPORARY_FILE = '~temp.txt';

  const
         MODE_UNK =-1; //unknown
         MODE_EAP = 0;
         MODE_EAV = 1;
         MODE_VEG = 2;
         MODE_RYO = 3; //Ryodoraku
         MODE_ION = 4; //Ionophoreses & zapper





function calculateMass( mollMass : Double; z : Double; Q : Double (*mAh*)) : Double;



implementation


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


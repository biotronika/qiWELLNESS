unit bioFunctions;
(* elektros: 2020-06-23
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



// MULTIPLATFORM DEFINITIONS
    VK_RETURN = 13;
    BIO_DELIMETER = ',';

  {$IFDEF DARWIN}
    OS_VERSION             = 'Mac OS';
    BIO_FOLDER_DELIMETER   = '/';
    BIO_HIDDEN_FILE_PREFIX = '.';
    FIRST_SERIAL_PORT      = '/dev/cu.*';
  {$ELSE}


  {$IFDEF Linux}
    OS_VERSION             = 'Linux';
    BIO_FOLDER_DELIMETER   = '/';
    BIO_HIDDEN_FILE_PREFIX = '.';
    FIRST_SERIAL_PORT      = '/dev/ttyS1';
  {$ELSE}


  {$IFDEF UNIX}
    OS_VERSION             = 'Unix';
    BIO_FOLDER_DELIMETER   = '/';
    BIO_HIDDEN_FILE_PREFIX = '.';
    FIRST_SERIAL_PORT      = '/dev/tty0';
  {$ELSE}


  {$IFDEF WINDOWS}
  {$IFDEF WIN32}
    OS_VERSION             = 'Windows 32bit';
  {$ELSE}
  {$IFDEF WIN64}
    OS_VERSION             = 'Windows 64bit';
  {$ENDIF}
  {$ENDIF}

    BIO_FOLDER_DELIMETER   = '\';
    FIRST_SERIAL_PORT      = 'COM1';
    BIO_HIDDEN_FILE_PREFIX = '';
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}


     DEFAULT_EAP_THERAPY_TIME = 120; // 120 seconds
     PROFILES : array[0..6] of string = ( 'User', 'Common', 'Stimulation', 'Sedation', 'DC-', 'DC+', 'DC change');




     INFOBOX_BACKGROUND_COLOR   = $0080FF80;
     //INFOBOX_FONT_COLOR         = clGreen;
     CLICKBOX_BACKGROUND_COLOR  = $00E9AE7A;
     CLICKBOX_FONT_COLOR        = $007D5500;



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


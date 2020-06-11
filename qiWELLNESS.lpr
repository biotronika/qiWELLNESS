program qiWELLNESS;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LazSerialPort, tachartlazaruspkg, unitMain, unitVegatestSelector,
  unitUpdateList, unitChooseEAPTherapy, bioREST;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TFormVegatestSelector, FormVegatestSelector);
  Application.CreateForm(TFormUpdateList, FormUpdateList);
  Application.CreateForm(TFormChooseEAPTherapy, FormChooseEAPTherapy);
  Application.Run;
end.

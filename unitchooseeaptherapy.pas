unit unitChooseEAPTherapy;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, myFunctions;

type

  { TFormChooseEAPTherapy }

  TFormChooseEAPTherapy = class(TForm)
    ButtonChoose: TButton;
    ButtonUpdate: TButton;
    Panel1: TPanel;
    StringGrid: TStringGrid;

    procedure ButtonChooseClick(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    function Choose() : integer;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure LoadEAPTherapiesFromFile;
    procedure StringGridSelection(Sender: TObject; aCol, aRow: Integer);
  private
   fEAPTherapyIdx : integer;
   fEAPTherapyString : string;

  public
    property EAPTherapyIdx : integer read fEAPTherapyIdx;
    property EAPTherapyString : string read fEAPTherapyString;

  end;

var
  FormChooseEAPTherapy: TFormChooseEAPTherapy;

implementation

{$R *.lfm}

uses unitUpdateList;

{ TFormChooseEAPTherapy }

procedure TFormChooseEAPTherapy.LoadEAPTherapiesFromFile;
var DestinationListFile : string;
begin

  StringGrid.Clean;
  StringGrid.Cells[0,0]:='Click Update to download EAP therapies!';


  Self.Caption := LISTS_DEF[LIST_EAP_PATHS].Title;
  //StringGrid.LoadFromCSVFile(TFormUpdat);     //LIST_EAP_PATHS

  DestinationListFile := ExtractFilePath(Application.ExeName) + LISTS_DEF[LIST_EAP_PATHS].FileName;

  if SysUtils.FileExists(DestinationListFile) then begin
     StringGrid.LoadFromCSVFile(DestinationListFile);
     StringGrid.AutoSizeColumns;
  end
  else begin ;
    //StringGrid.

  end;


end;

procedure TFormChooseEAPTherapy.StringGridSelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  //fEAPTherapyIdx:=aRow;
end;

function TFormChooseEAPTherapy.Choose() : integer;

begin
  fEAPTherapyIdx:=0;

  Self.LoadEAPTherapiesFromFile;
  Self.ShowModal;



  result:= fEAPTherapyIdx;


end;

procedure TFormChooseEAPTherapy.FormActivate(Sender: TObject);
begin
  //LoadEAPTherapiesFromFile;
end;

procedure TFormChooseEAPTherapy.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin

end;



procedure TFormChooseEAPTherapy.ButtonUpdateClick(Sender: TObject);
begin
  FormUpdateList.OpenWindowUpdateList(LIST_EAP_PATHS);
  Self.LoadEAPTherapiesFromFile;
end;

procedure TFormChooseEAPTherapy.ButtonChooseClick(Sender: TObject);
begin
  fEAPTherapyIdx:=StringGrid.Row;
  if fEAPTherapyIdx =0 then
     fEAPTherapyString :=''
  else
      fEAPTherapyString:=StringGrid.Cells[1,fEAPTherapyIdx];
  Close;
end;

end.


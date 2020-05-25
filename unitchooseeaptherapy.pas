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
    ButtonSearch: TButton;
    ButtonUpdate: TButton;
    Edit1: TEdit;
    Panel1: TPanel;
    StringGrid: TStringGrid;

    procedure ButtonChooseClick(Sender: TObject);
    procedure ButtonSearchClick(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    //function Choose() : integer;
    //procedure FormActivate(Sender: TObject);
    //procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure LoadEAPTherapiesFromFile;
    //procedure StringGridSelection(Sender: TObject; aCol, aRow: Integer);
    function Choose(SearchString: string):TEAPTherapy;
  private
   fEAPTherapy : TEAPTherapy;
   //fEAPTherapyString : string;
   fEAPTerapiesCollection : TEAPTerapies;

  public
    //property EAPTherapyLength : integer read Length(fEAPTherapy.Points);
    //property EAPTherapyName : string read fEAPTherapy.Name;

  end;

var
  FormChooseEAPTherapy: TFormChooseEAPTherapy;

implementation

{$R *.lfm}

uses unitUpdateList;

{ TFormChooseEAPTherapy }

function  TFormChooseEAPTherapy.Choose(SearchString: string):TEAPTherapy;
(* KC 2020-05-25

Open choose window to select an EAP therapy from portal (via REST/JSON)
   SearchString - Search text contained in title
   result - comlex chosen therapy

*)
begin

  setlength(fEAPTherapy.Points,0);
  fEAPTherapy.Name:='Unknow';
  fEAPTherapy.Description:='';



  //EAPTherapy:=StringToEAPTherapy(FormChooseEAPTherapy.EAPTherapyString);

  Self.LoadEAPTherapiesFromFile;
  Self.ShowModal;



  result:= fEAPTherapy;

end;

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




procedure TFormChooseEAPTherapy.ButtonUpdateClick(Sender: TObject);
begin
  FormUpdateList.OpenWindowUpdateList(LIST_EAP_PATHS);
  Self.LoadEAPTherapiesFromFile;
end;



procedure TFormChooseEAPTherapy.ButtonChooseClick(Sender: TObject);
begin
  //fEAPTherapyIdx:=StringGrid.Row;
  //if fEAPTherapyIdx =0 then
     //fEAPTherapyString :=''
 // else
     // fEAPTherapyString:=StringGrid.Cells[1,fEAPTherapyIdx];


  Close;
end;

procedure TFormChooseEAPTherapy.ButtonSearchClick(Sender: TObject);
begin
  FormUpdateList.OpenWindowUpdateList( LIST_EAP_PATHS,'title=example');
end;

end.


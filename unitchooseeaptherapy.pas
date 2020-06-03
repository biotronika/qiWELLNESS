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
    EditSearchString: TEdit;
    ImageBack: TImage;
    ImageNext: TImage;
    Label1: TLabel;
    LabelPage: TLabel;
    Label24: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Shape3: TShape;
    StringGrid: TStringGrid;

    procedure ButtonChooseClick(Sender: TObject);
    procedure ButtonSearchClick(Sender: TObject);
    procedure EditSearchStringChange(Sender: TObject);
    procedure EditSearchStringKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure ImageBackClick(Sender: TObject);
    procedure ImageNextClick(Sender: TObject);

    procedure LoadEAPTherapiesFromFile;

    function Choose(SearchString: string):TEAPTherapy;
    procedure FillGridOfTherapies(EAPTherapies:TEAPTherapies);
    procedure Search (SearchString : string);
  private
    F_EAPTherapy : TEAPTherapy;
    F_EAPTherapies : TEAPTherapies;
    F_Page : integer;

  public

  end;

var
  FormChooseEAPTherapy: TFormChooseEAPTherapy;

implementation

{$R *.lfm}

uses unitUpdateList;

{ TFormChooseEAPTherapy }

procedure TFormChooseEAPTherapy.FillGridOfTherapies(EAPTherapies:TEAPTherapies);
var i : integer;
begin

  StringGrid.RowCount:= 1; //Clear fields, but not change grid size
  StringGrid.RowCount:=Length(EAPTherapies)+1;

  for i:= 0 to Length(EAPTherapies)-1 do
    with StringGrid do begin
        Cells[0,i+1]     := EAPTherapies[i].Name;
        Cells[1,i+1]     := EAPTherapies[i].StrPoints;
        Cells[2,i+1]     := EAPTherapies[i].Description;
    end;

end;

procedure TFormChooseEAPTherapy.Search (SearchString : string);
var content : string;
          s : string;
begin

  F_EAPTherapy.Name:='Unknow';
  setlength(F_EAPTherapy.Points,0);
  F_EAPTherapy.StrPoints:='';
  F_EAPTherapy.Description:='';

  s := 'title=' + trim(SearchString) ;
  if F_Page > 0 then s := s + '&page=' + IntToStr(F_Page);

  GetContentFromREST(content,  LISTS_DEF[LIST_EAP_THERAPY].RestURL , s );
  GetEAPTherapiesFromContent( content, F_EAPTherapies);
  FillGridOfTherapies(F_EAPTherapies);


end;

function  TFormChooseEAPTherapy.Choose(SearchString: string):TEAPTherapy;
(* KC 2020-05-25

Open choose window to select an EAP therapy from portal (via REST/JSON)
   SearchString - Search text contained in title
   result - comlex chosen therapy

*)


begin

  F_Page := 0;

  Search(EditSearchString.Text);

  Self.ShowModal;

  result:= F_EAPTherapy;

end;

procedure TFormChooseEAPTherapy.LoadEAPTherapiesFromFile;
var DestinationListFile : string;
begin

  StringGrid.Clean;
  StringGrid.Cells[0,0]:='Click Update to download EAP therapies!';


  Self.Caption := LISTS_DEF[LIST_EAP_THERAPY].Title;
  //StringGrid.LoadFromCSVFile(TFormUpdat);     //LIST_EAP_THERAPY

  DestinationListFile := ExtractFilePath(Application.ExeName) + LISTS_DEF[LIST_EAP_THERAPY].FileName;

  if SysUtils.FileExists(DestinationListFile) then begin
     StringGrid.LoadFromCSVFile(DestinationListFile);
     StringGrid.AutoSizeColumns;
  end
  else begin ;
    //StringGrid.

  end;


end;



procedure TFormChooseEAPTherapy.ButtonChooseClick(Sender: TObject);
var idx : integer;
begin
  idx := StringGrid.Row;
  if idx >0 then F_EAPTherapy:=F_EAPTherapies[idx-1];


  Close;
end;

procedure TFormChooseEAPTherapy.ButtonSearchClick(Sender: TObject);
begin
  Search(EditSearchString.Text);
end;

procedure TFormChooseEAPTherapy.EditSearchStringChange(Sender: TObject);
begin
  F_Page := 0;
  LabelPage.Caption := IntToStr(F_Page);
end;

procedure TFormChooseEAPTherapy.EditSearchStringKeyPress(Sender: TObject;
  var Key: char);
begin
  if ord(Key) = ord(chr(13)) then begin
     Key := #0;
     ButtonSearchClick(Sender);
  end;
end;

procedure TFormChooseEAPTherapy.FormShow(Sender: TObject);
begin
  EditSearchString.SetFocus;
end;

procedure TFormChooseEAPTherapy.ImageBackClick(Sender: TObject);
begin
  F_Page := F_Page -1;
  if F_Page <0 then F_Page :=0;
  LabelPage.Caption := IntToStr(F_Page);
  Search(EditSearchString.Text);
end;

procedure TFormChooseEAPTherapy.ImageNextClick(Sender: TObject);
begin
  F_Page := F_Page +1;
  LabelPage.Caption := IntToStr(F_Page);
  Search(EditSearchString.Text);

end;

end.


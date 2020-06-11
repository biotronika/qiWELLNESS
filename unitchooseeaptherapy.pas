unit unitChooseEAPTherapy;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, bioFunctions, bioREST;

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

    function  ChooseEAPTherapy(SearchString: string)  :TEAPTherapy;
    function  ChooseIONSubstance(SearchString: string) : TIonSubstance;

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


  with StringGrid do begin

    Clear;
    RowCount   := 1;

    Columns[0].Width := 350;
    Columns[1].Width := 350;
    Columns[2].Width := 600;

    Columns[0].Title.Caption := 'EAP therapy name';
    Columns[1].Title.Caption := 'BAP(s)';
    Columns[2].Title.Caption := 'Description';

  end;

  StringGrid.RowCount := Length(EAPTherapies) + 1;

  for i:= 0 to Length(EAPTherapies)-1 do
    with StringGrid do begin
        Cells[0,i+1] := EAPTherapies[i].Name;
        Cells[1,i+1] := EAPTherapies[i].StrPoints;
        Cells[2,i+1] := EAPTherapies[i].Description;
    end;

end;


procedure TFormChooseEAPTherapy.Search (SearchString : string);
var content : string;
          s : string;
begin

  F_EAPTherapy.Name:='';
  setlength(F_EAPTherapy.Points,0);
  F_EAPTherapy.StrPoints:='';
  F_EAPTherapy.Description:='';

  s := 'title=' + trim(SearchString) ;
  if F_Page > 0 then s := s + '&page=' + IntToStr(F_Page);

  GetContentFromREST( content,  LIST_REST_URLS[LIST_EAP_THERAPY] , s );
  GetEAPTherapiesFromContent( content, F_EAPTherapies);
  FillGridOfTherapies(F_EAPTherapies);

end;


function  TFormChooseEAPTherapy.ChooseEAPTherapy(SearchString: string):TEAPTherapy;
(* elektros 2020-05-25
 * Open choose window to select an EAP therapy from portal (via REST/JSON)
 *   SearchString - Search text contained in title
 *   result - comlex chosen therapy
 *)
begin

  F_Page := 0;
  Search(EditSearchString.Text);
  Self.ShowModal;

  result:= F_EAPTherapy;

end;

function  TFormChooseEAPTherapy.ChooseIONSubstance(SearchString: string) : TIonSubstance;
begin

  F_Page := 0;
  Search(EditSearchString.Text);
  Self.ShowModal;

  //result:= F_EAPTherapy;


end;

procedure TFormChooseEAPTherapy.ButtonChooseClick(Sender: TObject);
var idx : integer;
begin

  idx := StringGrid.Row;
  if idx >0 then F_EAPTherapy:=F_EAPTherapies[idx-1];

  Self.Close;

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

  if ord(Key) = VK_RETURN then begin
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

  F_Page := F_Page - 1;

  if F_Page < 0 then F_Page := 0;
  LabelPage.Caption := IntToStr(F_Page);

  Search(EditSearchString.Text);

end;


procedure TFormChooseEAPTherapy.ImageNextClick(Sender: TObject);
begin

  F_Page := F_Page + 1;

  LabelPage.Caption := IntToStr(F_Page);

  Search(EditSearchString.Text);

end;

end.


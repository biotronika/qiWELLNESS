unit unitChooseList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, bioFunctions, bioREST;

type

  { TFormChooseList }

  TFormChooseList = class(TForm)
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
    procedure FillGridOfTherapies(IONSubstances:TIONSubstances);
    procedure Search (SearchString : string; ListType : integer);

  private

    F_EAPTherapy   : TEAPTherapy;
    F_EAPTherapies : TEAPTherapies;

    F_IONSubstance : TIONSubstance;
    F_IONSubstances : TIONSubstances;

    F_CurrentList  : integer;
    F_Page : integer;

  public

  end;

var
  FormChooseList: TFormChooseList;

implementation

{$R *.lfm}

uses unitUpdateList;

{ TFormChooseList }


procedure TFormChooseList.FillGridOfTherapies(EAPTherapies:TEAPTherapies);
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

procedure TFormChooseList.FillGridOfTherapies(IONSubstances:TIONSubstances);
var i : integer;
begin


  with StringGrid do begin

    Clear;
    RowCount   := 1;

    Columns[0].Width := 400;
    Columns[1].Width := 150;
    Columns[2].Width := 150;

    Columns[0].Title.Caption := 'Substance';
    Columns[1].Title.Caption := 'Active electrode';
    Columns[2].Title.Caption := 'Molar mass';

  end;

  StringGrid.RowCount := Length(IONSubstances) + 1;

  for i:= 0 to Length(IONSubstances)-1 do
    with StringGrid do begin
        Cells[0,i+1] := IONSubstances[i].Name;
        Cells[1,i+1] := IONSubstances[i].ActiveElectrode;
        Cells[2,i+1] := format( '%0.2f',[IONSubstances[i].MolarMass]);
    end;

end;


procedure TFormChooseList.Search (SearchString : string; ListType : integer);
var content : string;
          s : string;
begin

  case ListType of
      LIST_EAP_THERAPY : begin
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

       LIST_ION_SUBSTANCES : begin
          F_IONSubstance.Name:='';


          s := 'title=' + trim(SearchString) ;
          if F_Page > 0 then s := s + '&page=' + IntToStr(F_Page);

          GetContentFromREST( content,  LIST_REST_URLS[LIST_ION_SUBSTANCES] , s );
          GetIONSubstancesFromContent( content, F_IONSubstances);
          FillGridOfTherapies(F_IONSubstances);
      end;

  end;

end;


function  TFormChooseList.ChooseEAPTherapy(SearchString: string):TEAPTherapy;
(* elektros 2020-05-25
 * Open choose window to select an EAP therapy from portal (via REST/JSON)
 *   SearchString - Search text contained in title
 *   result - comlex chosen therapy
 *)
begin

  F_CurrentList := LIST_EAP_THERAPY;

  Caption := 'Search electroacupuncture therapy';

  F_Page := 0;
  Search(EditSearchString.Text, F_CurrentList);
  Self.ShowModal;

  result:= F_EAPTherapy;

end;

function  TFormChooseList.ChooseIONSubstance(SearchString: string) : TIONSubstance;
begin

  F_CurrentList := LIST_ION_SUBSTANCES;

  Caption := 'Search ionotophoresis substance';

  F_Page := 0;
  Search(EditSearchString.Text, F_CurrentList);
  Self.ShowModal;

  result:= F_IONSubstance;


end;

procedure TFormChooseList.ButtonChooseClick(Sender: TObject);
var idx : integer;
begin

  idx := StringGrid.Row;

  if idx >0 then
     case F_CurrentList of

          LIST_EAP_THERAPY:    F_EAPTherapy   := F_EAPTherapies[idx-1];
          LIST_ION_SUBSTANCES: F_IONSubstance := F_IONSubstances[idx-1];

     end;


  Self.Close;

end;


procedure TFormChooseList.ButtonSearchClick(Sender: TObject);
begin

  Search(EditSearchString.Text, F_CurrentList);

end;


procedure TFormChooseList.EditSearchStringChange(Sender: TObject);
begin

  F_Page := 0;
  LabelPage.Caption := IntToStr(F_Page);

end;


procedure TFormChooseList.EditSearchStringKeyPress(Sender: TObject;
var Key: char);
begin

  if ord(Key) = VK_RETURN then begin
     Key := #0;
     ButtonSearchClick(Sender);
  end;

end;


procedure TFormChooseList.FormShow(Sender: TObject);
begin

  EditSearchString.SetFocus;

end;


procedure TFormChooseList.ImageBackClick(Sender: TObject);
begin

  F_Page := F_Page - 1;

  if F_Page < 0 then F_Page := 0;
  LabelPage.Caption := IntToStr(F_Page);

  Search(EditSearchString.Text, F_CurrentList);

end;


procedure TFormChooseList.ImageNextClick(Sender: TObject);
begin

  F_Page := F_Page + 1;

  LabelPage.Caption := IntToStr(F_Page);

  Search(EditSearchString.Text, F_CurrentList);

end;

end.


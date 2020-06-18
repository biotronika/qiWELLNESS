unit unitChooseList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, bioFunctions, bioREST, LCLIntf;

type

  { TFormChooseList }

  TFormChooseList = class(TForm)
    ButtonChoose: TButton;
    ButtonSearch: TButton;
    EditSearchString: TEdit;
    ImageBack: TImage;
    ImageNext: TImage;
    Label1: TLabel;
    LabelClick: TLabel;
    LabelPage: TLabel;
    LabelInfo: TLabel;
    Panel1: TPanel;
    PanelInfo: TPanel;
    PanelClick: TPanel;
    RadioButtonShowMeLiked: TRadioButton;
    RadioButtonShowAll: TRadioButton;
    ShapeInfo: TShape;
    ShapeClick: TShape;
    StringGrid: TStringGrid;

    procedure ButtonChooseClick(Sender: TObject);
    procedure ButtonSearchClick(Sender: TObject);
    procedure EditSearchStringChange(Sender: TObject);
    procedure EditSearchStringKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImageBackClick(Sender: TObject);
    procedure ImageNextClick(Sender: TObject);

    //function  ChooseEAPTherapy(SearchString: string)  :TEAPTherapy;
    //function  ChooseIONSubstance(SearchString: string) : TIonSubstance;

    function  GetItemFromList( var EAPTherapy   : TEAPTherapy;   SearchString: string = '' ) : boolean ; overload;
    function  GetItemFromList( var IonSubstance : TIonSubstance; SearchString: string = '' ) : boolean ; overload;
    function  GetItemFromList( var EAVPath      : TEAVPath;      SearchString: string = '' ) : boolean ; overload;

    procedure FillGridOfTherapies( EAPTherapies  : TEAPTherapies  );
    procedure FillGridOfTherapies( IONSubstances : TIONSubstances );
    procedure FillGridOfTherapies( EAVPaths      : TEAVPaths      );
    procedure LabelClickClick(Sender: TObject);
    procedure RadioButtonShowAllChange(Sender: TObject);
    procedure RadioButtonShowMeLikedChange(Sender: TObject);
    procedure Search (SearchString : string; OnlyLiked : boolean = true);
    procedure StringGridCheckboxToggled(sender: TObject; aCol, aRow: Integer;
      aState: TCheckboxState);

  private

    F_EAPTherapy   : TEAPTherapy;
    F_EAPTherapies : TEAPTherapies;

    F_IONSubstance : TIONSubstance;
    F_IONSubstances : TIONSubstances;

    F_EAVPath : TEAVPath;
    F_EAVPaths : TEAVPaths;

    F_CurrentListType  : integer;
    F_Page : integer;

    F_idx : integer;
    F_LikedStr : string;

  public

  end;

var
  FormChooseList: TFormChooseList;

implementation

{$R *.lfm}

//uses unitUpdateList;

{ TFormChooseList }

procedure TFormChooseList.FillGridOfTherapies(EAVPaths : TEAVPaths);
var i : integer;
begin


  with StringGrid do begin

    Clear;
    RowCount   := 1;

    Columns[1].Width := 350;
    Columns[2].Width := 450;
    Columns[3].Width := 600;

    Columns[1].Title.Caption := 'EAV path';
    Columns[2].Title.Caption := 'BAP(s)';
    Columns[3].Title.Caption := 'Description';

  end;

  StringGrid.RowCount := Length(EAVPaths) + 1;

  for i:= 0 to Length(EAVPaths)-1 do
    with StringGrid do begin
        Cells[0,i+1] := EAVPaths[i].Liked;
        Cells[1,i+1] := EAVPaths[i].Name;
        Cells[2,i+1] := EAVPaths[i].StrBAPs;
        Cells[3,i+1] := EAVPaths[i].Description;
    end;

end;

procedure TFormChooseList.LabelClickClick(Sender: TObject);
begin
  OpenURL('https://biotronics.eu/add-new');
end;

procedure TFormChooseList.RadioButtonShowAllChange(Sender: TObject);
begin
  F_page := 0;
  LabelPage.Caption := IntToStr(F_Page);
  Search(EditSearchString.Text, RadioButtonShowMeLiked.Checked);
end;

procedure TFormChooseList.RadioButtonShowMeLikedChange(Sender: TObject);
begin
  PanelClick.Visible := RadioButtonShowMeLiked.Checked;
  PanelInfo.Visible  := RadioButtonShowAll.Checked;
end;


procedure TFormChooseList.FillGridOfTherapies(EAPTherapies:TEAPTherapies);
var i : integer;
begin


  with StringGrid do begin

    Clear;
    RowCount   := 1;

    Columns[1].Width := 350;
    Columns[2].Width := 350;
    Columns[3].Width := 600;

    Columns[1].Title.Caption := 'EAP therapy name';
    Columns[2].Title.Caption := 'BAP(s)';
    Columns[3].Title.Caption := 'Description';

  end;

  StringGrid.RowCount := Length(EAPTherapies) + 1;

  for i:= 0 to Length(EAPTherapies)-1 do
    with StringGrid do begin
        Cells[0,i+1] := EAPTherapies[i].Liked;
        Cells[1,i+1] := EAPTherapies[i].Name;
        Cells[2,i+1] := EAPTherapies[i].StrPoints;
        Cells[3,i+1] := EAPTherapies[i].Description;
    end;

end;

procedure TFormChooseList.FillGridOfTherapies(IONSubstances:TIONSubstances);
var i : integer;
begin


  with StringGrid do begin

    Clear;
    RowCount   := 1;

    Columns[1].Width := 400;
    Columns[2].Width := 150;
    Columns[3].Width := 150;

    Columns[1].Title.Caption := 'Substance';
    Columns[2].Title.Caption := 'Active electrode';
    Columns[3].Title.Caption := 'Molar mass';

  end;

  StringGrid.RowCount := Length(IONSubstances) + 1;

  for i:= 0 to Length(IONSubstances)-1 do
    with StringGrid do begin
        Cells[0,i+1] := IONSubstances[i].Liked;
        Cells[1,i+1] := IONSubstances[i].Name;
        Cells[2,i+1] := IONSubstances[i].ActiveElectrode;
        Cells[3,i+1] := format( '%0.2f',[IONSubstances[i].MolarMass]);
    end;

end;


procedure TFormChooseList.Search (SearchString : string; OnlyLiked : boolean = true);
var content : string;
          s : string;
   likedStr : string;

begin


  s := 'title=' + trim(SearchString) ;
  if F_Page > 0 then s := s + '&page=' + IntToStr(F_Page);

  F_LikedStr :=  GetLikedItems( F_CurrentListType );

  if OnlyLiked then likedStr := F_likedStr else likedStr := '';
  GetContentFromREST( content,  LIST_REST_URLS[F_CurrentListType]  , s ,  likedStr  );

  case F_CurrentListType of
      LIST_EAP_THERAPY : begin
          F_EAPTherapy.Name:='';
          setlength(F_EAPTherapy.Points,0);
          F_EAPTherapy.StrPoints:='';
          F_EAPTherapy.Description:='';

          GetEAPTherapiesFromContent( content, F_EAPTherapies, F_LikedStr);
          FillGridOfTherapies(F_EAPTherapies);
      end;

       LIST_ION_SUBSTANCES : begin
          F_IONSubstance.Name:='';

          GetIONSubstancesFromContent( content, F_IONSubstances, F_LikedStr);
          FillGridOfTherapies(F_IONSubstances);
      end;

       LIST_EAV_PATHS : begin
          F_EAVPath.Name:='';

          GetEAVPathsFromContent( content, F_EAVPaths, F_LikedStr);
          FillGridOfTherapies(F_EAVPaths);

       end;

  end;

end;


procedure TFormChooseList.StringGridCheckboxToggled(sender: TObject; aCol,
  aRow: Integer; aState: TCheckboxState);
var state : string;
begin
  F_idx := aRow -1;

  if aState = cbChecked then state := LIKED_YES else state := LIKED_NO;

  if F_idx >=0 then
     case F_CurrentListType of

          LIST_EAP_THERAPY:   begin
             F_EAPTherapies[F_idx].Liked := state;
             ModifyLikedStr (F_LikedStr, F_CurrentListType, F_EAPTherapies[F_idx].nid, state);

          end;
          LIST_ION_SUBSTANCES: begin
             F_IONSubstances[F_idx].Liked := state;
             ModifyLikedStr (F_LikedStr, F_CurrentListType, F_IONSubstances[F_idx].nid, state);

          end;
          LIST_EAV_PATHS:      begin
             F_EAVPaths[F_idx].Liked := state;
             ModifyLikedStr (F_LikedStr, F_CurrentListType, F_EAVPaths[F_idx].nid, state);

          end;

     end;



end;



function  TFormChooseList.GetItemFromList(var EAPTherapy: TEAPTherapy; SearchString: string ='' ) : boolean ; overload;
(* elektros 2020-06-14
 * Open choose window to select an EAP therapy from portal (via REST/JSON)
 *   SearchString - Search text contained in title
 *   result - true=was choosen
 *)
begin
  result := false;
  F_CurrentListType := LIST_EAP_THERAPY;

  Caption := 'Search electroacupuncture therapy';

  F_Page := 0;

  F_LikedStr:=GetLikedItems( F_CurrentListType );

  //Select right case of radio buttons
  RadioButtonShowAll.Checked := (F_LikedStr = '');
  RadioButtonShowMeLiked.Checked := not (F_LikedStr = '');

  Search(EditSearchString.Text, RadioButtonShowMeLiked.Checked);

  Self.ShowModal;

  EAPTherapy:= F_EAPTherapy;
  result := ( EAPTherapy.Name <> '' );

end;

function  TFormChooseList.GetItemFromList(var IonSubstance: TIonSubstance; SearchString: string ='') : boolean ; overload;
(* elektros 2020-06-14
 * Open choose window to select an ION substance from portal (via REST/JSON)
 *   SearchString - Search text contained in title
 *   result - true=was choosen
 *)
begin

  result:= false;
  F_CurrentListType := LIST_ION_SUBSTANCES;

  Caption := 'Search ionotophoresis substance';

  F_Page := 0;

  F_LikedStr:=GetLikedItems( F_CurrentListType );

  //Select right case of radio buttons
  RadioButtonShowAll.Checked := (F_LikedStr = '');
  RadioButtonShowMeLiked.Checked := not (F_LikedStr = '');

  Search(EditSearchString.Text, RadioButtonShowMeLiked.Checked);
  Self.ShowModal;

  IonSubstance:= F_IONSubstance;
  result := ( IonSubstance.Name <> '' );

end;

function  TFormChooseList.GetItemFromList(var EAVPath : TEAVPath; SearchString: string ='') : boolean ; overload;
(* elektros 2020-06-14
 * Open choose window to select an EAV Paths from portal (via REST/JSON)
 *   SearchString - Search text contained in title
 *   result - true=was choosen
 *)
begin

  result:= false;
  F_CurrentListType := LIST_EAV_PATHS;

  Caption := 'Search EAV Paths';

  F_Page := 0;

  F_LikedStr:=GetLikedItems( F_CurrentListType );

  //Select right case of radio buttons
  RadioButtonShowAll.Checked := (F_LikedStr = '');
  RadioButtonShowMeLiked.Checked := not (F_LikedStr = '');

  Search(EditSearchString.Text, RadioButtonShowMeLiked.Checked);
  Self.ShowModal;

  EAVPath := F_EAVPath;
  result := ( EAVPath.Name <> '' );

end;


procedure TFormChooseList.ButtonChooseClick(Sender: TObject);

begin

  F_idx := StringGrid.Row-1;

  if F_idx >=0 then
     case F_CurrentListType of

          LIST_EAP_THERAPY:    F_EAPTherapy   := F_EAPTherapies[F_idx];
          LIST_ION_SUBSTANCES: F_IONSubstance := F_IONSubstances[F_idx];
          LIST_EAV_PATHS:      F_EAVPath      := F_EAVPaths[F_idx];

     end;


  Self.Close;

end;


procedure TFormChooseList.ButtonSearchClick(Sender: TObject);
begin

  //if RadioButtonShowAll.Checked then F_LikedStr := '' else GetLikedItems( F_CurrentListType );

  Search(EditSearchString.Text, RadioButtonShowMeLiked.Checked);

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

procedure TFormChooseList.FormCreate(Sender: TObject);
begin
 F_idx := 0;
 F_LikedStr := '';
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

  Search(EditSearchString.Text, RadioButtonShowMeLiked.Checked);

end;


procedure TFormChooseList.ImageNextClick(Sender: TObject);
begin

  F_Page := F_Page + 1;

  LabelPage.Caption := IntToStr(F_Page);

  Search(EditSearchString.Text,RadioButtonShowMeLiked.Checked);

end;

end.


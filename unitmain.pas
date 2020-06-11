unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, CheckLst, Grids, ColorBox, LazSerial, TAGraph, TASeries,
  TALegendPanel, TASources,(* TAChartCombos, *) Types , LCLType,  lclintf, Spin, bioREST,fileutil;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnClose: TButton;
    btnConnect: TButton;
    btnDeleteAll: TButton;
    btnDelete: TButton;
    btnSaveAs: TButton;
    ButtonChooseEAPTherapy: TButton;
    ButtonIonOn: TButton;
    ButtonIonOff: TButton;
    ButtonUpdate: TButton;
    ButtonIon: TButton;
    ButtonVegatestSaveAs1: TButton;
    ButtonSavePath: TButton;
    ButtonLoadPath: TButton;
    ButtonSaveReading: TButton;
    ButtonEap: TButton;
    ButtonVeg: TButton;
    ButtonEav: TButton;
    ButtonCalibrate: TButton;
    ButtonVegatestEdit: TButton;
    ButtonSaveReport: TButton;
    btnConsoleExecute: TButton;
    ButtonRyodorakuAnalize: TButton;
    ButtonRyodorakuSendToEAP: TButton;
    cboxSeries: TComboBox;
    chartCurrent: TChart;
    chartRMS: TChart;
    chartRMSBarSeries1: TBarSeries;
    chartRMS_ION: TChart;
    chartRMS_IONBarSeries1: TBarSeries;
    chartRyodoraku: TChart;
    chartRyodorakuRightSeries: TBarSeries;
    chartRyodorakuNormal: TLineSeries;
    chartRyodorakuLeftSeries: TBarSeries;
    ChartMeasure: TChart;
    ChartMeasureCurrentLineSeries: TLineSeries;
    cboxChangeDirections: TCheckBox;
    chartSeriesCurrent: TBarSeries;
    chartSourceRMS_ION: TListChartSource;
    CheckBoxAutoTrack: TCheckBox;
    EditSubstance_ION: TEdit;
    EditActiveElectrode_ION: TEdit;
    EditMolarMass_ION: TEdit;
    EditValence_ION: TEdit;
    edtDutyCycle: TFloatSpinEdit;
    edtFreq: TFloatSpinEdit;
    edtFreq_ION: TFloatSpinEdit;
    edtSeconds: TEdit;
    edtConsoleCommand: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ImageCloseAtlas: TImage;
    ImageBack: TImage;
    ImageNext: TImage;
    ImageMaximumScreen: TImage;
    ImageAtlas: TImage;
    Image3: TImage;
    ImageLogo: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    LabelEAPName: TLabel;
    LabelLiteratureURL: TLabel;
    Label9: TLabel;
    LabelCharge: TLabel;
    LabelMass: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    chartSourceRMS: TListChartSource;
    chartSourceCurrent: TListChartSource;
    MemoDescription: TMemo;
    OpenDialog: TOpenDialog;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel2: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    PanelEAPTherapyName: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    RadioBtnCurrentImpulse: TRadioButton;
    RadioBtnCurrentRMS: TRadioButton;
    rbDutyCycle50_ION: TRadioButton;
    rbDutyCycle90_ION: TRadioButton;
    RadioGroup4: TRadioGroup;
    RadioGroup5: TRadioGroup;
    rbDirect_ION: TRadioButton;
    rbEavLeft: TRadioButton;
    rbEavRight: TRadioButton;
    rbNegativeElectrode_ION: TRadioButton;
    rbPositiveElectrode_ION: TRadioButton;
    rbPulse_ION: TRadioButton;
    ryodorakuLeftSource: TListChartSource;
    Panel1: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel9: TPanel;
    rbNegativeElectrode: TRadioButton;
    rbDCpositive: TRadioButton;
    rbDCchangeDirections: TRadioButton;
    rbPositiveElectrode: TRadioButton;
    rbDirect: TRadioButton;
    rbPulse: TRadioButton;
    rbUsers: TRadioButton;
    rbCommon: TRadioButton;
    rbStimulation: TRadioButton;
    rbSedation: TRadioButton;
    rbDCnegative: TRadioButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    ryodorakuRightSource: TListChartSource;
    ryodorakuNormalSource: TListChartSource;
    Panel6: TPanel;
    Panel7: TPanel;
    memoConsole: TMemo;
    PageControl2: TPageControl;
    pageRight: TPageControl;
    Panel3: TPanel;
    PanelButtons: TPanel;
    PanelPicture: TPanel;
    PanelRight: TPanel;
    rbRyodorakuLeft: TRadioButton;
    rbRyodorakuRight: TRadioButton;
    SaveDialog: TSaveDialog;
    SaveDialogForm: TSaveDialog;
    Serial: TLazSerial;
    PanelLeft: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    statusBar: TStatusBar;
    gridRyodoraku: TStringGrid;
    StringGridEAPTherapy: TStringGrid;
    StringGridIonTherapy: TStringGrid;
    StringGridEAV: TStringGrid;
    tabConsole: TTabSheet;
    tabRyodoraku: TTabSheet;
    tabEAV: TTabSheet;
    tabElectropunture: TTabSheet;
    RightHand: TTabSheet;
    LeftFoot: TTabSheet;
    tabIonophorese: TTabSheet;
    LeftHand: TTabSheet;
    Chart: TTabSheet;
    RightFoot: TTabSheet;
    tabVegatest: TTabSheet;
    timerChangeDirection: TTimer;
    ToggleBoxEdit: TToggleBox;
    TreeViewSelector: TTreeView;
    procedure btnConsoleExecuteClick(Sender: TObject);
    procedure btnDeleteAllClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure ButtonChooseEAPTherapyClick(Sender: TObject);

    procedure btnEapSaveClick(Sender: TObject);
    //procedure btnVegatestDeleteClick(Sender: TObject);
    //procedure btnVegatestNewClick(Sender: TObject);
    //procedure btnVegatestNewGroupClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure ButtonHideAtlasClick(Sender: TObject);
    procedure ButtonIonOnClick(Sender: TObject);
    procedure ButtonIonOffClick(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure ButtonCalibrateClick(Sender: TObject);

    procedure ButtonEapClick(Sender: TObject);
    procedure ButtonEavClick(Sender: TObject);
    procedure ButtonIonClick(Sender: TObject);
    procedure ButtonLoadPathClick(Sender: TObject);
    procedure ButtonSavePathClick(Sender: TObject);
    procedure ButtonSaveReadingClick(Sender: TObject);
    //procedure btnVegatestSaveClick(Sender: TObject);
    //procedure ButtonSaveReportClick(Sender: TObject);
    procedure ButtonVegatestEditClick(Sender: TObject);
    procedure ButtonVegatestSaveAs1Click(Sender: TObject);
    procedure ButtonVegClick(Sender: TObject);
    procedure cbEAVOnChange(Sender: TObject);
    procedure cbElectropunctueOnChange(Sender: TObject);
    procedure cboxChangeDirectionsChange(Sender: TObject);
    procedure cboxSeriesChange(Sender: TObject);

    procedure edtConsoleCommandKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtFreqChange(Sender: TObject);
    procedure edtSecondsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure FormShow(Sender: TObject);

    procedure gridRyodorakuDblClick(Sender: TObject);
    procedure gridRyodorakuDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure gridRyodorakuEnter(Sender: TObject);
    procedure gridRyodorakuKeyPress(Sender: TObject; var Key: char);

    procedure gridRyodorakuSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure gridRyodorakuSelection(Sender: TObject; aCol, aRow: Integer);


    procedure ImageControllClick(Sender: TObject);
    procedure LabelLiteratureURLClick(Sender: TObject);
    procedure RadioBtnCurrentImpulseChange(Sender: TObject);

    procedure rbCommonChange(Sender: TObject);

    procedure rbRyodorakuLeftChange(Sender: TObject);

    procedure SerialRxData(Sender: TObject);

    procedure ShapeLeftMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure ShapeRightMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGridEAPTherapyDblClick(Sender: TObject);
    procedure StringGridEAPTherapySelectCell(Sender: TObject; aCol,
      aRow: Integer; var CanSelect: Boolean);
    procedure StringGridEAVDblClick(Sender: TObject);
    procedure StringGridIonTherapySelection(Sender: TObject; aCol, aRow: Integer
      );
    //procedure serialStatus(Sender: TObject; Reason: THookSerialReason;
    //const Value: string);
    procedure tabEAVShow(Sender: TObject);
    procedure tabElectropuntureShow(Sender: TObject);
    procedure tabIonophoreseShow(Sender: TObject);
    procedure tabRyodorakuShow(Sender: TObject);
    procedure tabVegatestShow(Sender: TObject);
    procedure timerChangeDirectionTimer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBoxEditChange(Sender: TObject);

    procedure TreeViewSelectorSelectionChanged(Sender: TObject);
    procedure setIonParameters(Sender: TObject);

    procedure ChangeMode(mode : integer);

    procedure RyodorakuClear;
    procedure SaveRyodoraku;

    procedure SaveEav;
    procedure SaveVeg;

    procedure EAPClear;
    procedure SelectorLoad;

    procedure SetPictureBlock( view : integer);

    procedure AtlasSearchBAP(pointSymbol: string);

  private
    (*
    const
         MODE_UNK = -1; //unknown
         MODE_EAP = 0;
         MODE_EAV = 1;
         MODE_VEG = 2;
         MODE_RYO = 3; //Ryodoraku
         MODE_ION = 4; //Ionophoreses & zapper
    *)

    const
      MAX_SERIES_NUMBER = 50;
      MAX_EAP_POINTS_NUMBER = 50;
      //RYODORAKU_NORMAL_MIN = 75;
      //RYODORAKU_NORMAL_MAX = 100;
      RYODORAKU_FACTOR = 1.54;
      // MINIVOLL_READ_VALUE_PERIOD = 0.05; //seconds

      EAP_POINT_GRID_COL = 0;
      EAP_SIDE_GRID_COL = 1;
      EAP_PROFILE_GRID_COL = 2;
      EAP_TIME_GRID_COL = 3;
      EAP_ELAPSED_GRID_COL = 4;
      EAP_PROGRESS_GRID_COL = 5;
      //EAP_PRECENTAGE_GRID_COL = 6;

      VIEW_LOGO = 0;
      VIEW_ATLAS = 1;
      VIEW_ATLAS_FULL = 2;


    var
      CurrentMode : integer;
      FLastCol : integer;
      FLastLeftSide : boolean;
      FCurrentPointName : string;
      FRyodorakuChart : integer;
      FReadBuffer : string;  //Buufer for incoming stream
      //step : Cardinal;
      startTime : Double;
      mySeries : TLineSeries;
      seriesArray : array[1..MAX_SERIES_NUMBER] of TLineSeries; //No dynamic array of all used series
      //EAPDoneTimeArray : array[1..MAX_EAP_POINTS_NUMBER] of Double;


      EAPProgressTime : Double;
      myTime : Double;
      FElapsedTimeDbl : Double;
      firstTime_ION : boolean;
      Charge_ION : Double;
      GridRyodorakuLastClickedRow : integer;

      atlasPicturesFilesList :TStringList;

      EAPProgressGridRow : integer;
      F_EAPProgressGridRow : integer;


  public
     var
        ryodorakuPoint : array[0..11,0..1] of Double; //[0..23]


  end;

var
  frmMain: TfrmMain;

implementation

uses unitVegatestSelector, bioFunctions, unitUpdateList, unitChooseEAPTherapy;

var
  atlasPictureCurrent : integer = 0;
  atlasPictureMax : integer = 0;


{$R *.lfm}

{ TfrmMain }


procedure TfrmMain.SetPictureBlock( view : integer);
begin

  case view of
    VIEW_ATLAS:
                begin
                ChartMeasure.Align:= alBottom;
                ChartMeasure.Height:= 250;
                PanelPicture.Align:= alClient;
                //ButtonHideAtlas.Visible:= true;
                ImageAtlas.Visible:= true;
                //ImageAtlas.Stretch:= true;
                //ImageAtlas.Center:= true;
                ImageLogo.Visible:= false;
                //TrackBarAtlas.Visible:= false;
                //ShapeLeft.Visible:= true;
                //ShapeRight.Visible:= true;
                PanelButtons.Visible:= false;

                //buttons
                ImageCloseAtlas.Visible:= true;
                ImageBack.Visible:= true;
                ImageNext.Visible:= true;
                ImageMaximumScreen.Visible:= true;


                ChartMeasure.Visible:= true;
                statusBar.Visible:= false;
                PanelRight.Visible:= true;

                end;

     VIEW_ATLAS_FULL:
                begin
                ChartMeasure.Align:= alBottom;
                ChartMeasure.Height:= 250;
                PanelPicture.Align:= alClient;
                //ButtonHideAtlas.Visible:= true;
                ImageAtlas.Visible:= true;
                //ImageAtlas.Stretch:= true;
                //ImageAtlas.Center:= true;
                ImageLogo.Visible:= false;
                //TrackBarAtlas.Visible:= false;
                //ShapeLeft.Visible:= true;
                //ShapeRight.Visible:= true;
                PanelButtons.Visible:= false;

                //buttons
                ImageCloseAtlas.Visible:= true;
                ImageBack.Visible:= true;
                ImageNext.Visible:= true;
                ImageMaximumScreen.Visible:= false;


                ChartMeasure.Visible:= false;
                statusBar.Visible:= false;
                PanelRight.Visible:= false;


                end;

    else
     (*VIEW_LOGO*)
                ChartMeasure.Align:= alClient;
                PanelPicture.Align:= alTop;
                PanelPicture.Height:= 128;
                //ButtonHideAtlas.Visible:=false;
                ImageAtlas.Visible:= false;
                //ImageAtlas.Stretch:= false;
                //ImageAtlas.Center:= true;
                ImageLogo.Visible:= true;

                //ShapeLeft.Visible:= false;
                //ShapeRight.Visible:= false;
                PanelButtons.Visible:= true;

                //buttons
                ImageCloseAtlas.Visible:= false;
                ImageBack.Visible:= false;
                ImageNext.Visible:= false;
                ImageMaximumScreen.Visible:= false;


                ChartMeasure.Visible:= true;
                statusBar.Visible:= true;
                PanelRight.Visible:= true;


  end;




end;

procedure TfrmMain.ChangeMode(mode : integer);

begin
  CurrentMode := mode;

  if (Serial.Active) then begin

    case mode of
      MODE_UNK: ;

      MODE_EAP: begin

                     Serial.WriteData('eap'+#13#10);

                     sleep(200);

                     if rbPulse.Checked then
                        Serial.WriteData('freq '+ IntToStr(trunc(StrToFloatDef(edtFreq.Text,10)*100)) +' '+edtDutyCycle.Text+#13#10)
                     else
                         Serial.WriteData('freq 100 100'#13#10);   //DC current

                     sleep(200);

                     //Polarization of electrode
                     if rbNegativeElectrode.Checked then
                        Serial.WriteData('chp 0'#13#10)
                     else
                         Serial.WriteData('chp 1'#13#10);

                end;

      MODE_ION: begin


                     Serial.WriteData('ion'+#13#10);

                     sleep(200);

                     if rbPulse_ION.Checked then begin
                        if rbDutyCycle50_ION.Checked then
                           Serial.WriteData('freq '+ IntToStr(trunc(StrToFloatDef(edtFreq_ION.Text,10)*100)) +' 50'#13#10)
                        else
                           Serial.WriteData('freq '+ IntToStr(trunc(StrToFloatDef(edtFreq_ION.Text,10)*100)) +' 90'#13#10);
                     end else
                         Serial.WriteData('dc'#13#10);   //DC current

                     sleep(200);

                     //Polarization of electrode
                     if rbNegativeElectrode_ION.Checked then
                        Serial.WriteData('chp 0'#13#10)
                     else
                         Serial.WriteData('chp 1'#13#10);

                end;

      MODE_EAV: begin
                     Serial.WriteData('eav'+#13#10);

                end;

      MODE_VEG: begin
                    Serial.WriteData('veg'+#13#10);
                end;

      MODE_RYO: begin
                    Serial.WriteData('eav'+#13#10);

                end;

    end;

  end;



end;

procedure TfrmMain.btnDeleteAllClick(Sender: TObject);
var i : integer;
begin
   Charge_ION := 0;

   for i:=1 to High(seriesArray) do begin
       cboxSeries.Items.Delete(1);
       seriesArray[i].Clear;
       seriesArray[i].LinePen.Style:=psDash;
       seriesArray[i].SeriesColor:=clWhite; //clGray;
       seriesArray[i].Title:='';
   end;
   ChartMeasureCurrentLineSeries.Clear;
   //step:=0;
end;

procedure TfrmMain.btnConsoleExecuteClick(Sender: TObject);
begin
    if (Serial.Active) then begin

    Serial.WriteData(edtConsoleCommand.Text+#13#10);

  end;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var i,a : integer;
begin
  Charge_ION := 0;

  if cboxSeries.Items.Count>1 then  begin
    i:= cboxSeries.ItemIndex;

    for a:=i to cboxSeries.Items.Count-1 do begin
        seriesArray[a].ListSource.CopyFrom(seriesArray[a+1].ListSource);
        seriesArray[a].Title:=seriesArray[a+1].Title;
        seriesArray[a].SeriesColor:=seriesArray[a+1].SeriesColor;
        seriesArray[a].LinePen:=seriesArray[a+1].LinePen;

    end;

    cboxSeries.Items.Delete(i);
    if i<= cboxSeries.ItemIndex then
       cboxSeries.ItemIndex:=i
    else
       cboxSeries.ItemIndex:=0;


  end else begin
      //step:=0;
      //ShowMessage('Can not delete working chart');
  end;

end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  if Serial.Active then begin
    Serial.Close;
    statusBar.SimpleText:='Serial connection was closed';
  end;
end;



procedure TfrmMain.ButtonChooseEAPTherapyClick(Sender: TObject);
var //TherapyIdx : integer;
    EAPTherapy: TEAPTherapy;
    i : integer;
begin

  //Open Choose window
  EAPTherapy := FormChooseEAPTherapy.ChooseEAPTherapy('');

  if EAPTherapy.Name <>'' then begin;

    StringGridEAPTherapy.RowCount  := 1; //Clear fields, but not change grid size
    StringGridEAPTherapy.RowCount  := Length(EAPTherapy.Points)+1;
    MemoDescription.Lines.Clear;
    MemoDescription.Lines.Add(        HTML2PlainText( EAPTherapy.Description )    );
    LabelEAPName.Caption           := EAPTherapy.Name;

    for i:= 1 to Length(EAPTherapy.Points) do begin
        with StringGridEAPTherapy do begin

            Cells[EAP_POINT_GRID_COL,i]   := EAPTherapy.Points[i-1].Point;
            Cells[EAP_SIDE_GRID_COL,i]    := EAPTherapy.Points[i-1].Side;
            Cells[EAP_PROFILE_GRID_COL,i] := PROFILES[EAPTherapy.Points[i-1].Profile];
            Cells[EAP_TIME_GRID_COL,i]    := IntToStr( EAPTherapy.Points[i-1].Time);

        end;
    end;

    //Collumn names
    with StringGridEAPTherapy do begin

            Cells[EAP_POINT_GRID_COL,0]   := 'BAP(s)';
            Cells[EAP_SIDE_GRID_COL,0]    := 'Side';
            Cells[EAP_PROFILE_GRID_COL,0] := 'Profile';
            Cells[EAP_TIME_GRID_COL,0]    := 'Time [s]';
            Cells[EAP_ELAPSED_GRID_COL,0] := 'Elapsed';
            Cells[EAP_PROGRESS_GRID_COL,0]:= 'Progress';
    end;

    PanelEAPTherapyName.Height:= 100;

  end else begin

    LabelEAPName.Caption           := '...';
    PanelEAPTherapyName.Height     := 28;
    StringGridEAPTherapy.RowCount  := 1; //Clear fields, but not change grid size
    MemoDescription.Lines.Clear;

  end;

end;



procedure TfrmMain.btnEapSaveClick(Sender: TObject);
begin

end;






procedure TfrmMain.btnResetClick(Sender: TObject);
begin
  memoConsole.Lines.Clear;

  Sleep(2);

  if Serial.Active then begin
     //DTR line is in Arduino boartds the reset of an ucontroller
     Serial.SetDTR(false);
     Sleep(2);
     Serial.SetDTR(true);
  end;

end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
var f : textFile;
    s: string;
begin
     memoConsole.Clear;
      s := ExtractFileNameWithoutExt(Application.ExeName) + '.port';

      AssignFile(f,s);
      {$I-}
      Reset(f);
      {$I+}
      if IOResult=0 then  begin
         readln(f,s);
         Serial.Device:=s;
      //CloseFile(f);
      end;

      Serial.ShowSetupDialog;
      Serial.Open;

      if Serial.Active then  begin
           Rewrite(f);
           {$I-}
           Writeln(f,Serial.Device);
           {$I+}
           statusBar.SimpleText:='Serial port: ' + Serial.Device + ' is open.';

      end;
      CloseFile(f);

      sleep(2000);

      frmMain.ChangeMode(CurrentMode);

  //step := 1;
end;

procedure TfrmMain.btnSaveAsClick(Sender: TObject);
begin
   frmMain.SaveEav;
end;

procedure TfrmMain.ButtonHideAtlasClick(Sender: TObject);
begin

end;

procedure TfrmMain.ButtonIonOnClick(Sender: TObject);
begin
   Serial.WriteData('act 1'+#13#10);
   sleep(200);
   //setIonParameters(Sender);
end;

procedure TfrmMain.ButtonIonOffClick(Sender: TObject);
begin
   Serial.WriteData('act 0'+#13#10);
   sleep(200);
end;

procedure TfrmMain.ButtonUpdateClick(Sender: TObject);
var DestinationListFile : string;
begin
 (*
  DestinationListFile := ExtractFilePath(Application.ExeName) + LISTS_DEF[LIST_ION_SUBSTANCES].FileName;

  if SysUtils.FileExists(DestinationListFile) then
     StringGridIonTherapy.LoadFromCSVFile(DestinationListFile)
  else
     StringGridIonTherapy.SaveToCSVFile(DestinationListFile);

    FormUpdateList.OpenWindowUpdateList( LIST_ION_SUBSTANCES );

  if SysUtils.FileExists(DestinationListFile) then
     StringGridIonTherapy.LoadFromCSVFile(DestinationListFile);
  *)
end;

procedure TfrmMain.ButtonCalibrateClick(Sender: TObject);
begin
    if (Serial.Active) then begin

      if messagedlg('Short the electrodes in diagnose circuit and press OK. Wait for two long voice signals. '#10#13#10#13'To abort press Cancel button!',mtWarning, mbOKCancel, 0, mbCancel ) = mrOK then begin
          Serial.WriteData('eav'+#13#10);
          sleep(200);
          Serial.WriteData('calib'+#13#10);
      end;

      frmMain.ChangeMode(CurrentMode);

    end;
end;


procedure TfrmMain.ButtonEapClick(Sender: TObject);
begin
    frmMain.ChangeMode(MODE_EAP);
end;

procedure TfrmMain.ButtonEavClick(Sender: TObject);
begin
  frmMain.ChangeMode(MODE_EAV);
end;

procedure TfrmMain.ButtonIonClick(Sender: TObject);
begin
  frmMain.ChangeMode(MODE_ION);
end;

procedure TfrmMain.ButtonLoadPathClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    StringGridEAV.LoadFromCSVFile(OpenDialog.FileName);
end;

procedure TfrmMain.ButtonSavePathClick(Sender: TObject);
begin
  if SaveDialog.Execute then
     StringGridEAV.SaveToCSVFile(SaveDialog.FileName);

end;


procedure TfrmMain.SaveRyodoraku;
var s : string;
    i,j,count : integer;
    sum,d : Double;
    chartIndex: integer;
    rightChartIndex : integer;
    currentPointName : string;
begin

  if CurrentMode=MODE_RYO then begin

   chartIndex      := -1;
   rightChartIndex := -1;

   //Check numbers of seriers on chart
   if cboxSeries.Items.Count>MAX_SERIES_NUMBER then exit;

   if ChartMeasureCurrentLineSeries.Count < 50 then begin
         ShowMessage('Take a longer sample! Minimum is 1 second.');
         CheckBoxAutoTrack.Checked:=false;
         Exit;
   end;

   // Setup point name
   if gridRyodoraku.col>0  then begin

     //Ryodoraku bar chart index - left side
     FRyodorakuChart:=(gridRyodoraku.col-1)*2;

     if rbRyodorakuLeft.Checked then begin
        currentPointName:=gridRyodoraku.Cells[gridRyodoraku.col,0]+' Left';
     end else begin
        currentPointName:=gridRyodoraku.Cells[gridRyodoraku.col,0]+' Right';

        //Ryodoraku bar chart index - change left to right side
        FRyodorakuChart+=1;
     end;
  end;

   s:=currentPointName;

   //chartIndex := FRyodorakuChart;
   chartIndex := FRyodorakuChart div 2;
   rightChartIndex :=  FRyodorakuChart mod 2;




   i:= cboxSeries.Items.Add(s);

   with seriesArray[i] do begin
      SeriesColor:=clGray;
      LinePen.Color:=clGray;
      LinePen.Style:=psSolid;
      LinePen.Width:=3;
      ListSource.CopyFrom(ChartMeasureCurrentLineSeries.Source);
      Title:=s;
   end;

   ChartMeasureCurrentLineSeries.Clear;


 //RYODORAKU
   if  chartIndex<>-1  then begin

 //TODO: Calculate current equivalent  - check!
     if seriesArray[i].Count >= 50 then
        //Get sample at: 0.8, 0.9 and 1 sec.
        d:= RYODORAKU_FACTOR * (seriesArray[i].GetYValue(40)+seriesArray[i].GetYValue(45)+seriesArray[i].GetYValue(50)) / 3;


     //Save value
     ryodorakuPoint[chartIndex,rightChartIndex]:= d;
     if rightChartIndex=0 then
       ryodorakuLeftSource.SetYValue(chartIndex,d)
     else
       ryodorakuRightSource.SetYValue(chartIndex,d);



     //Calculate normal range:  +/-15[uA]

     sum:=0;
     count:=0;

     for i:= 0 to 11 do
        for j:= 0 to 1 do begin

          if ryodorakuPoint[i,j]>0 then begin

            sum := sum + ryodorakuPoint[i,j];
            count := count+1;

          end;

        end;


     //Set normal line range on ryododraku chart

     if count>0 then begin
       sum := round(sum/count);
       ryodorakuNormalSource.SetYValue(0,sum);
       ryodorakuNormalSource.SetYValue(1,sum);
     end;


     //Set colors of ryodoraku charts

     for i:= 0 to 11 do
       for j:=0 to 1 do begin

         if ryodorakuPoint[i,j]< sum-15 then begin

            if j=0 then
              ryodorakuLeftSource.SetColor(i,$800000)  //navy
            else
              ryodorakuRightSource.SetColor(i,$800000);

         end else if ryodorakuPoint[i,j]> sum+15 then begin

            if j=0 then
              ryodorakuLeftSource.SetColor(i,$0000FF)  //red
            else
              ryodorakuRightSource.SetColor(i,$0000FF);

         end else begin

           if j=0 then
             ryodorakuLeftSource.SetColor(i,$008000)  //green
           else
             ryodorakuRightSource.SetColor(i,$008000);

         end;
       end;



   end;


  end;

end;

procedure TfrmMain.SaveVeg;
//Save reading in EAV mode
var
    currentPointName: string;
    i : integer;

begin

  if CurrentMode=MODE_VEG then begin

      //Check numbers of seriers on chart
   if cboxSeries.Items.Count>MAX_SERIES_NUMBER then exit;

   if ChartMeasureCurrentLineSeries.Count < 50 then begin
         ShowMessage('Take a longer sample! Minimum is 1 second.');
         Exit;
   end;

   // Setup EAV point name
   if FCurrentPointName<>'' then begin
        currentPointName:= FCurrentPointName;
     end else begin
        currentPointName:=InputBox('Vegatest sample name', 'Name of that sample', 'New ' + IntToStr(cboxSeries.Items.Count));
     end;


   //ShowMessage( currentPointName);

     i:= cboxSeries.Items.Add(currentPointName);

  with seriesArray[i] do begin
     SeriesColor:=clGray;
     LinePen.Color:=clGray;
     LinePen.Style:=psSolid;
     LinePen.Width:=3;
     ListSource.CopyFrom(ChartMeasureCurrentLineSeries.Source);
     Title:=currentPointName;
  end;

  ChartMeasureCurrentLineSeries.Clear;
  end;
end;


procedure TfrmMain.SaveEav;
//Save reading in EAV mode
var
    currentPointName: string;
    i : integer;

begin

  if CurrentMode=MODE_EAV then begin

      //Check numbers of seriers on chart
   if cboxSeries.Items.Count>MAX_SERIES_NUMBER then exit;

   if ChartMeasureCurrentLineSeries.Count < 50 then begin
         ShowMessage('Take a longer sample! Minimum is 1 second.');
         Exit;
   end;

   // Setup EAV point name
   if StringGridEAV.row>0  then begin

     if rbEavLeft.Checked then begin
        currentPointName:=StringGridEAV.Cells[0, StringGridEAV.row]+' Left';
     end else begin
        currentPointName:=StringGridEAV.Cells[0, StringGridEAV.row]+' Right';
     end;

   end else Exit;

   //ShowMessage( currentPointName);

     i:= cboxSeries.Items.Add(currentPointName);

  with seriesArray[i] do begin
     SeriesColor:=clGray;
     LinePen.Color:=clGray;
     LinePen.Style:=psSolid;
     LinePen.Width:=3;
     ListSource.CopyFrom(ChartMeasureCurrentLineSeries.Source);
     Title:=currentPointName;
  end;

  ChartMeasureCurrentLineSeries.Clear;
  end;
end;

procedure TfrmMain.ButtonSaveReadingClick(Sender: TObject);

begin

  if gridRyodoraku.col > 0 then begin;

     // Before save point remember last point
     FLastCol:=gridRyodoraku.col;
     FLastLeftSide := rbRyodorakuLeft.Checked;

     //Show ryodoraku chart
     PageControl2.TabIndex:=0;

     //Save point
     frmMain.SaveRyodoraku;
     Application.ProcessMessages;

     // Auto check next point
     if CheckBoxAutoTrack.Checked then begin
        sleep(2000);

        case FLastCol of
          1,2,3,4,5: gridRyodoraku.col:=FlastCol+1;
          6: if FLastLeftSide then begin
             gridRyodoraku.col:=FlastCol+1;
             rbRyodorakuLeft.Checked :=false;
             rbRyodorakuRight.Checked :=true;
          end else begin
             gridRyodoraku.col:=1;
             FLastLeftSide:=false;
             rbRyodorakuLeft.Checked :=true;
             rbRyodorakuRight.Checked :=false;
          end;
          7,8,9,10,11: gridRyodoraku.col:=FlastCol+1;
          12: if FLastLeftSide then begin
             CheckBoxAutoTrack.Checked:=false;
          end else begin
             gridRyodoraku.col:=7;
             FLastLeftSide:=false;
             rbRyodorakuLeft.Checked :=true;
             rbRyodorakuRight.Checked :=false;
          end;
        end;



     end;


  end;



end;


procedure TfrmMain.ButtonVegatestEditClick(Sender: TObject);
begin
  FormVegatestSelector.ShowModal;
end;

procedure TfrmMain.ButtonVegatestSaveAs1Click(Sender: TObject);
begin
  frmMain.SaveVeg;
end;

procedure TfrmMain.ButtonVegClick(Sender: TObject);
begin
  frmMain.ChangeMode(MODE_VEG);
end;

procedure TfrmMain.cbEAVOnChange(Sender: TObject);
begin

end;

procedure TfrmMain.cbElectropunctueOnChange(Sender: TObject);
//var b : boolean;
begin
  //b := cbElectropunctueOn.Checked;
  //timerCurrent.Enabled:=b;
  if CurrentMode=MODE_EAP then begin
    //ChartMeasure.LeftAxis.Range.Max:=1000;
    frmMain.edtFreqChange(Sender);

  end else begin
    ChartMeasure.LeftAxis.Range.Max:=100;
  end;
end;

procedure TfrmMain.cboxChangeDirectionsChange(Sender: TObject);
begin
  timerChangeDirection.Enabled:=cboxChangeDirections.Checked;
end;


procedure TfrmMain.cboxSeriesChange(Sender: TObject);
var i:integer;
begin
   for i:=1 to High(seriesArray) do begin
       //seriesArray[i].LinePen.Style:=psDash;
       if seriesArray[i].Title ='' then
          seriesArray[i].SeriesColor:=clWhite
       else
          seriesArray[i].SeriesColor:=clGray;
   end;

   if cboxSeries.ItemIndex>0 then
      with seriesArray[cboxSeries.ItemIndex] do begin
           //LinePen.Style:=psSolid;
           SeriesColor:=clBlue;
      end;

end;


procedure TfrmMain.edtConsoleCommandKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    frmMain.btnConsoleExecuteClick(Sender);
  end;
end;

procedure TfrmMain.edtFreqChange(Sender: TObject);
begin
  if Serial.Active then begin

    //Type of current (pulse or DC)
    if rbPulse.Checked then
      Serial.WriteData('freq '+ IntToStr(trunc(StrToFloatDef(edtFreq.Text,10)*100)) +' '+edtDutyCycle.Text+#13#10)
    else
      Serial.WriteData('dc');   //DC current

    sleep(200);

    //Polarization of electrode
    if rbNegativeElectrode.Checked then
      Serial.WriteData('chp 0'#13#10)
    else
       Serial.WriteData('chp 1'#13#10);

  end;

end;

procedure TfrmMain.edtSecondsChange(Sender: TObject);
var i : integer;
begin
  i := StrToIntDef(edtSeconds.Text,0);
  if i>=2 then timerChangeDirection.Interval:=i*1000;
end;



procedure TfrmMain.FormCreate(Sender: TObject);
var i : integer;
  DestinationListFile : string;
begin
  atlasPicturesFilesList := TStringList.Create;

  Caption                := 'qiWELLNESS';
  statusBar.SimpleText   := 'Software ver.: ' + SOFTWARE_VERSION + '   Compilation: ' + OS_VERSION;

  DefaultFormatSettings.DecimalSeparator := '.';

  for i:=1 to MAX_SERIES_NUMBER do begin;
    seriesArray[i]             := TLineSeries.Create(Self);
    seriesArray[i].SeriesColor := clWhite;
    seriesArray[i].Title       := '';
    ChartMeasure.AddSeries(  seriesArray[i]  );
  end;

  mySeries             := ChartMeasureCurrentLineSeries;

  startTime            := 0;
  FElapsedTimeDbl      := 0;

  EAPProgressGridRow   := 0;
  F_EAPProgressGridRow := 0;

  FLastCol             := 0;
  firstTime_ION        := True;


  //Iontophoresis tab
  DestinationListFile  := ExtractFilePath(Application.ExeName) + 'iontophoresis.txt'; // LISTS_DEF[LIST_ION_SUBSTANCES].FileName;

  if SysUtils.FileExists(DestinationListFile) then
     StringGridIonTherapy.LoadFromCSVFile(DestinationListFile);

  Serial.Device := FIRST_SERIAL_PORT;


end;


procedure TfrmMain.SelectorLoad;
var s: string;
begin
   //Load user veagtest selector
  s:= ExtractFilePath(Application.ExeName)+'qiWELLNESS.sel';
  if FileExists(s)then
     TreeViewSelector.LoadFromFile(s);

end;

procedure TfrmMain.RyodorakuClear;
var
    i : integer;
begin
//Clear Ryodoraku chart
  for i:= 0 to 11 do begin
      chartRyodorakuLeftSeries.SetYValue(i,0);
      chartRyodorakuRightSeries.SetYValue(i,0); //do not use Clear method
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);

begin
  // With windows taskbar on down side
  // size is 40pixels *  scaling (e.g. 100%, 150%, 200%)

     //Self.Height := 850;
     //Self.Width := 1600;

  pageRight.TabIndex:=0;
  CurrentMode := MODE_UNK;

  //Load user veagtest selector
  SelectorLoad;

  RyodorakuClear;

  EAPClear;

  Charge_ION := 0;

end;

procedure TfrmMain.AtlasSearchBAP(pointSymbol:string);
(* elektros 2020-06-04
 * Open Atlas and load pictures from url or file
 *)

begin
  SetPictureBlock(VIEW_ATLAS);

  Screen.Cursor := crHourGlass;

  try

      if SearchBAP( pointSymbol, atlasPicturesFilesList ) >0 then begin

         atlasPictureMax     := atlasPicturesFilesList.Count-1;
         atlasPictureCurrent := 0;
//TODO: Show first file with the shorter name (contains that certain point, no much more)
         ImageAtlas.Picture.LoadFromFile( atlasPicturesFilesList.Strings[0] );

      end else begin

         ShowMessage('No such point in atlas or cannot connect to biotronics web portal');
         SetPictureBlock(VIEW_LOGO);

      end;

  finally
      Screen.Cursor := crDefault;
  end;



end;

procedure TfrmMain.gridRyodorakuDblClick(Sender: TObject);
var strGrid: string;

begin
  strGrid:=gridRyodoraku.Cells[gridRyodoraku.Col, gridRyodoraku.Row (*GridRyodorakuLastClickedRow*)];

  AtlasSearchBAP(strGrid);

end;

procedure TfrmMain.EAPClear;
var i: integer;
begin
  //Clear all EAP counters
  // EAP_TIME_GRID_COL = 3;
  // EAP_ELAPSED_GRID_COL = 4;
  // EAP_PROGRESS_GRID_COL = 5;
  // EAP_PRECENTAGE_GRID_COL = 6;
  StringGridEAPTherapy.RowCount:=1;
  for i:= 1 to StringGridEAPTherapy.RowCount-1 do begin

      StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,i]:='';
      StringGridEAPTherapy.Cells[EAP_PROGRESS_GRID_COL,i]:='';
      //StringGridEAPTherapy.Cells[EAP_PRECENTAGE_GRID_COL,i]:='0%';
  end;

  //Clear all electropuncture current charts
  chartSourceCurrent.SetYValue(0,0);
  chartSourceRMS.SetYValue(0,0);
  //ProgressBarTime.Position:=0;

  chartSourceRMS_ION.SetYValue(0,0);
end;


procedure TfrmMain.gridRyodorakuDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  (*
  if (ACol = 0) and (ARow = 0) then
    with TStringGrid(Sender) do begin
      //Paint the background
      Canvas.Brush.Color := clBtnFace;
      Canvas.FillRect(aRect);
      Canvas.TextOut(aRect.Left+2,aRect.Top+2,Cells[ACol, ARow]);
    end;
    *)

end;

procedure TfrmMain.gridRyodorakuEnter(Sender: TObject);
begin

end;

procedure TfrmMain.gridRyodorakuKeyPress(Sender: TObject; var Key: char);
begin

 if UpperCase(Key) = ' ' then begin
    frmMain.ButtonSaveReadingClick(Sender);
    //frmMain.SaveRyodoraku;
 end;

end;



procedure TfrmMain.gridRyodorakuSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  (*
  if gridRyodoraku.Cells[aCol,0]<>'' then begin

     //Ryodoraku bar chart index - left side
     FRyodorakuChart:=(aCol-1)*2;

     if rbRyodorakuLeft.Checked then begin
        FCurrentPointName:=gridRyodoraku.Cells[aCol,0]+' Left';
     end else begin
        FCurrentPointName:=gridRyodoraku.Cells[aCol,0]+' Right';

        //Ryodoraku bar chart index - change left to right side
        FRyodorakuChart+=1;
     end;
  end;
  *)

end;

procedure TfrmMain.gridRyodorakuSelection(Sender: TObject; aCol, aRow: Integer);

begin

  GridRyodorakuLastClickedRow:=gridRyodoraku.Row;

  //Select main Ryodoracu point
  if aRow < 3 then
     gridRyodoraku.Row := 0;

  if aCol> 0 then FLastCol := aCol;


  if aRow=0 then begin
    if (aCol >= 1) and (aCol <= 6) then begin

      if rbRyodorakuRight.Checked then
         PageControl2.TabIndex:=1
      else
         PageControl2.TabIndex:=2;
    end;

    if (aCol >= 7) and (aCol <= 12) then begin
      if rbRyodorakuRight.Checked then
         PageControl2.TabIndex:=3
      else
         PageControl2.TabIndex:=4;
    end;

  end;

end;





procedure TfrmMain.ImageControllClick(Sender: TObject);
//atlasPictureCurrent

begin
  if Sender=ImageNext then begin

        atlasPictureCurrent := atlasPictureCurrent + 1;
        if atlasPictureCurrent > atlasPictureMax then atlasPictureCurrent := atlasPictureMax;
        ImageAtlas.Picture.LoadFromFile(atlasPicturesFilesList.Strings[atlasPictureCurrent]);

  end else if Sender=ImageBack then begin

        atlasPictureCurrent := atlasPictureCurrent - 1;
        if atlasPictureCurrent < 0 then atlasPictureCurrent := 0;
        ImageAtlas.Picture.LoadFromFile(atlasPicturesFilesList.Strings[atlasPictureCurrent]);

  end else if Sender = ImageMaximumScreen then begin;

        SetPictureBlock(VIEW_ATLAS_FULL);

  end else if Sender = ImageCloseAtlas then begin

        SetPictureBlock( VIEW_LOGO);

  end;


end;

procedure TfrmMain.LabelLiteratureURLClick(Sender: TObject);
begin
  OpenURL('https://biotronics.eu/literature');
end;

procedure TfrmMain.RadioBtnCurrentImpulseChange(Sender: TObject);
begin
  chartCurrent.Visible := RadioBtnCurrentImpulse.Checked;
  chartRMS.Visible     := RadioBtnCurrentRMS.Checked;
end;



procedure TfrmMain.rbCommonChange(Sender: TObject);
begin
  if rbUsers.Checked then begin
    RadioGroup1.Enabled:=true;
    RadioGroup2.Enabled:=true;
    GroupBox1.Enabled:=true;
    GroupBox2.Enabled:=true;

  end else begin
    RadioGroup1.Enabled:=false;
    RadioGroup2.Enabled:=false;
    GroupBox1.Enabled:=false;
    GroupBox2.Enabled:=false;

    if rbCommon.Checked then begin;
      rbPulse.Checked:=true;
      edtFreq.Text:='10.00';
      edtDutyCycle.Text:='5.0';
      rbNegativeElectrode.Checked:=true;
      cboxChangeDirections.Checked:=false;

    end else if rbStimulation.Checked then begin
      rbPulse.Checked:=true;
      edtFreq.Text:='10.00';
      edtDutyCycle.Text:='5.0';
      rbNegativeElectrode.Checked:=true;
      cboxChangeDirections.Checked:=true;
      edtSeconds.Text:='5';

    end else if rbSedation.Checked then begin
      rbPulse.Checked:=true;
      //rbDirect.Checked:=true;
      edtFreq.Text:='100.00';
      edtDutyCycle.Text:='1.0';
      rbNegativeElectrode.Checked:=true;
      RadioGroup1.Enabled:=true;
      cboxChangeDirections.Checked:=false;
      //edtSeconds.Text:='5';
    end else if rbDCnegative.Checked then begin
      //rbPulse.Checked:=true;
      rbDirect.Checked:=true;
      rbNegativeElectrode.Checked:=true;
      cboxChangeDirections.Checked:=false;
      //edtSeconds.Text:='5';
    end else if rbDCpositive.Checked then begin
      //rbPulse.Checked:=true;
      rbDirect.Checked:=true;
      rbPositiveElectrode.Checked:=true;
      cboxChangeDirections.Checked:=false;
      //edtSeconds.Text:='5';
    end else if rbDCchangeDirections.Checked then begin
      //rbPulse.Checked:=true;
      rbDirect.Checked:=true;
      rbNegativeElectrode.Checked:=true;
      cboxChangeDirections.Checked:=true;
      GroupBox2.Enabled:=true;;
      edtSeconds.Text:='5';
    end;
  end;
end;






procedure TfrmMain.setIonParameters(Sender: TObject);
begin
  ChangeMode(MODE_ION);

end;



procedure TfrmMain.rbRyodorakuLeftChange(Sender: TObject);

var i : integer;
begin

  // Show proper points chart
  i:= PageControl2.TabIndex;

//TODO : remove it
  if i=0 then i:= 1 + FLastCol div 3;

  case i of
    1,2: if rbRyodorakuRight.Checked then
             PageControl2.TabIndex := 1
          else
             PageControl2.TabIndex := 2;


    3,4: if rbRyodorakuRight.Checked then
             PageControl2.TabIndex := 3
         else
             PageControl2.TabIndex :=4 ;

  end;

end;






procedure TfrmMain.SerialRxData(Sender: TObject);
(* elektros 2020-06-01
 * Main serial communiation function
 * React of any event (started with collon) from device
 *)

var bufferCmd,eventCmd,valueCmd  : string;
    i,j,l,p,x: integer;
    elapsedTimeSec,therapyTimeSec : integer;
    d : Double;
    valueDbl,dutyCycleDbl : Double ;


begin

  bufferCmd := Serial.ReadData;

  //Find end of line in incomming stream or add char to FReadBuffer
  for i:=1 to Length(bufferCmd) do

    if bufferCmd[i]<> #10  then
      FReadBuffer := FReadBuffer + bufferCmd[i] //Add char to FReadBuffer

    else begin

       eventCmd := trim(FReadBuffer);   //Execute incoming event
       FReadBuffer:='';

       if copy(eventCmd,1,2)<> ':i' then  memoConsole.Lines.Add(eventCmd);  //Add an extra line in ionotoporesies

       //Main case procedure for events
       if (eventCmd=':vstart') then begin

          // Vegatest starts
          CurrentMode := MODE_VEG;

          mySeries.Clear;
          ChartMeasure.BottomAxis.Range.Max  := 7;         // 7 sec.
          ChartMeasure.LeftAxis.Range.Max    := 100;       // 100%
          ChartMeasure.LeftAxis.Range.UseMax := True;
          mySeries.SeriesColor               := $000080FF;
          mySeries.AddXY( 0.03,0 );                        // Add first point

          startTime:=Now()-0.03/(24*60*60);


        end else if (eventCmd=':estart') then begin

          // EAV starts
          CurrentMode := MODE_EAV;

          mySeries.Clear;
          ChartMeasure.BottomAxis.Range.Max   := 7;        // 7 sec.
          ChartMeasure.LeftAxis.Range.Max     := 100;      // 100%
          ChartMeasure.LeftAxis.Range.UseMax  := True;
          mySeries.SeriesColor                := clRed;
          mySeries.AddXY( 0.03,0 );                        // Add first point

          startTime:=Now()-0.03/(24*60*60);


        end else if (eventCmd=':cstart') then begin

          // EAP therapy starts
          CurrentMode := MODE_EAP;
          F_EAPProgressGridRow := EAPProgressGridRow;

          mySeries.Clear;
          ChartMeasure.LeftAxis.Range.Max      := 500;     // 500uA
          mySeries.SeriesColor                 := clGreen;
          ChartMeasure.LeftAxis.Range.UseMax   := True;
          ChartMeasure.BottomAxis.Range.Max    := 30;      // 30sec. or more
          mySeries.AddXY( 0.03,0 );                        // Add first point

          startTime:=Now()-0.03/(24*60*60);

          //Elapsed time from last therapy of that point
          if F_EAPProgressGridRow > 0 then
             FElapsedTimeDbl := StrToFloatDef( StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL, F_EAPProgressGridRow], 0);


        end else if eventCmd = ':istart'  then begin

          // Ionotophoresis starts
          CurrentMode := MODE_ION;

          memoConsole.Lines.Add(trim(FReadBuffer));

          if firstTime_ION then begin

            mySeries.Clear;
            firstTime_ION := False;

            ChartMeasure.LeftAxis.Range.Max    := 12;        // 12mA
            mySeries.SeriesColor               := clGreen;
            ChartMeasure.LeftAxis.Range.UseMax := True;
            ChartMeasure.BottomAxis.Range.Max  := 120;       // 2min. or more
            mySeries.AddXY( 0.03,0 );                        // Add first point

            startTime:=Now()-0.03/(24*60*60);


          end else begin

            myTime := ( Now() - startTime )*(24*60*60);
            if myTime > 120 then ChartMeasure.LeftAxis.Range.UseMax := False;

            mySeries.AddXY( myTime ,0);                      // Add first point in the end of last chart

          end;


        end else if eventCmd = ':stop' then begin

          // Stops all modes

          case CurrentMode of
            MODE_ION : begin

                         mySeries.AddXY( myTime ,0);
                         chartSourceRMS_ION.SetYValue(0,0);

                       end;
            MODE_EAP : begin
                         F_EAPProgressGridRow := 0;

                         chartSourceCurrent.SetYValue(0,0);
                         chartSourceRMS.SetYValue(0,0);
                       end;

          end;  // case


        end else if copy(eventCmd,1,2) = ':c' then begin

           // Add new point to eap current series
           valueCmd := copy( eventCmd, 3 , Length(eventCmd) );

           myTime:= (Now()- startTime)*(24*60*60);


           //Rescale chart when time is longer than 30s
           if myTime >= 120 then
              ChartMeasure.BottomAxis.Range.Max  :=  300   // 2 min.
           else if myTime >= 30 then
              ChartMeasure.BottomAxis.Range.Max  :=  120;  // 5 min.


           p := Pos(' ',valueCmd); // Space separate current and duty cycle

           if p = 0 then begin
              //For devices without comming dutycycle
               valueDbl     := StrToIntDef(valueCmd,0);
               dutyCycleDbl := StrToFloatDef(edtDutyCycle.Text,0);

           end else begin
              //For devices with dutycycle parameters
               valueDbl     := StrToIntDef  ( Trim( Copy( valueCmd, 1, p) ), 0);
               dutyCycleDbl := StrToFloatDef( Trim( Copy( valueCmd, p, Length(valueCmd) - p) ), 0);
           end;

           //Set graphic components
           mySeries.AddXY( myTime, valueDbl * dutyCycleDbl / 100);
           chartSourceCurrent.SetYValue(0, valueDbl / 1000);
           chartSourceRMS.SetYValue(0, valueDbl * dutyCycleDbl / 100);

           //Set EAP therapy progress of the point on grid
           if F_EAPProgressGridRow > 0 then begin

             elapsedTimeSec := round( myTime + FElapsedTimeDbl);
             therapyTimeSec := StrToIntDef( StringGridEAPTherapy.Cells[ EAP_TIME_GRID_COL,  F_EAPProgressGridRow], 0);

             StringGridEAPTherapy.Cells[ EAP_ELAPSED_GRID_COL,  F_EAPProgressGridRow] := IntToStr(elapsedTimeSec);
             StringGridEAPTherapy.Cells[ EAP_PROGRESS_GRID_COL, F_EAPProgressGridRow] := StringOfChar(
                                                                                         char('|'),
                                                                                         round( 100 * elapsedTimeSec /therapyTimeSec ) //100 lines equal to 100%
                                                                                       );
           end;



        end else if copy(eventCmd,1,2)= ':i' then begin
        // Add to eap current series new point
           eventCmd:=copy(eventCmd,3,Length(eventCmd));
           myTime:= (Now()- startTime)*(24*60*60);
           //myTime:= (Now()- startTime)*(24*60*60);

           //Rescale chart to 2 minutes
           if myTime >= 600 then
              ChartMeasure.BottomAxis.Range.Max:=1200
           else if myTime >= 120 then
              ChartMeasure.BottomAxis.Range.Max:=600
           else
              ChartMeasure.BottomAxis.Range.Max:=120;

           p := Pos(' ',eventCmd);

           if p=0 then begin

               j:= StrToIntDef(eventCmd,0);
               d:= StrToFloatDef(edtDutyCycle.Text,0);

           end else begin
               j := StrToIntDef( Trim( Copy(eventCmd,1,p) ),0);
               d := StrToFloatDef( Trim( Copy(eventCmd,p,Length(eventCmd)-p) ),0);
           end;

           if myTime >= (FElapsedTimeDbl + 0.25) then begin

              memoConsole.Lines.Add(trim(FReadBuffer));

              mySeries.AddXY( myTime ,j*d/100000);
              Charge_ION := Charge_ION + abs((j*d/100000) (*mA*) * (myTime - FElapsedTimeDbl) (*s*) / 3600);
              LabelCharge.Caption := FormatFloat('0.000',Charge_ION);
              LabelMass.Caption:= FormatFloat('0.000', calculateMass( StrToFloat(EditMolarMass_ION.Caption), StrToFloat(EditValence_ION.Caption), Charge_ION(*mAh*)));

              FElapsedTimeDbl :=myTime;
           end;

           chartSourceRMS_ION.SetYValue(0,j*d/100000);

           // : Double;
           //FElapsedTimeDbl := myTime;


        end else  if( copy(eventCmd,1,2)= ':v') or (copy(eventCmd,1,2)= ':e') then begin // Veagtest and  EAV have the same scale
            eventCmd:=copy(eventCmd,3,Length(eventCmd));
            myTime:= (Now()- startTime)*(24*60*60);

            mySeries.AddXY( myTime ,StrToIntDef(eventCmd,0)/10.0  );

        end;


     end;


end;



procedure TfrmMain.ShapeLeftMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;


procedure TfrmMain.ShapeRightMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TfrmMain.StringGridEAPTherapyDblClick(Sender: TObject);
var strGrid: string;
begin
  strGrid:=StringGridEAPTherapy.Cells[0, StringGridEAPTherapy.Row ];
  AtlasSearchBAP(strGrid);

end;

procedure TfrmMain.StringGridEAPTherapySelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  EAPProgressGridRow := aRow;

end;

procedure TfrmMain.StringGridEAVDblClick(Sender: TObject);
var strGrid: string;
begin
  strGrid:=StringGridEAV.Cells[0, StringGridEAV.Row ];
  AtlasSearchBAP(strGrid);
end;

procedure TfrmMain.StringGridIonTherapySelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  EditSubstance_ION.Text       := StringGridIonTherapy.Cells[0,aRow];
  EditActiveElectrode_ION.Text := StringGridIonTherapy.Cells[1,aRow];
  EditMolarMass_ION.Text       := StringGridIonTherapy.Cells[2,aRow];
  EditValence_ION.Text         := StringGridIonTherapy.Cells[3,aRow];
end;


procedure TfrmMain.tabEAVShow(Sender: TObject);
begin
  frmMain.ChangeMode(MODE_EAV);
end;


procedure TfrmMain.tabElectropuntureShow(Sender: TObject);
begin
  frmMain.ChangeMode(MODE_EAP);
end;

procedure TfrmMain.tabIonophoreseShow(Sender: TObject);
begin
  frmMain.ChangeMode(MODE_ION);
end;


procedure TfrmMain.tabRyodorakuShow(Sender: TObject);
begin
  frmMain.ChangeMode(MODE_RYO);
end;


procedure TfrmMain.tabVegatestShow(Sender: TObject);
begin
  frmMain.ChangeMode(MODE_VEG);
end;

procedure TfrmMain.timerChangeDirectionTimer(Sender: TObject);
begin
  if rbNegativeElectrode.Checked then begin

    rbNegativeElectrode.Checked := false;
    rbPositiveElectrode.Checked := true;

  end else begin

      rbNegativeElectrode.Checked := true;
      rbPositiveElectrode.Checked := false;

  end;

end;

procedure TfrmMain.ToggleBox1Change(Sender: TObject);
begin


end;

procedure TfrmMain.ToggleBoxEditChange(Sender: TObject);
begin
  if ToggleBoxEdit.Checked then
     StringGridEAV.Options:= StringGridEAV.Options + [goEditing]
  else
     StringGridEAV.Options:= StringGridEAV.Options - [goEditing];
end;



procedure TfrmMain.TreeViewSelectorSelectionChanged(Sender: TObject);
begin
  FCurrentPointName:=TreeViewSelector.Selected.Text;

end;



end.


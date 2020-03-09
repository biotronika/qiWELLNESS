unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, CheckLst, Grids, ColorBox, LazSerial, TAGraph, TASeries,
  TALegendPanel, TASources, TAChartCombos,  Types , LCLType,  lclintf, Spin;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnDeleteAll: TButton;
    btnConnect: TButton;
    btnDelete: TButton;
    ButtonChooseEAPTherapy: TButton;
    btnSaveAs: TButton;
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
    btnClose: TButton;
    ButtonRyodorakuAnalize: TButton;
    ButtonRyodorakuSendToEAP: TButton;
    cboxSeries: TComboBox;
    chartRMS_ION: TChart;
    chartRMS_IONBarSeries1: TBarSeries;
    chartRyodoraku: TChart;
    chartRyodorakuRightSeries: TBarSeries;
    chartRMS: TChart;
    chartRMSBarSeries1: TBarSeries;
    chartSeriesCurrent: TBarSeries;
    chartCurrent: TChart;
    chartRyodorakuNormal: TLineSeries;
    chartRyodorakuLeftSeries: TBarSeries;
    chartMain: TChart;
    chartMainCurrentLineSeries: TLineSeries;
    cboxChangeDirections: TCheckBox;
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
    Image1: TImage;
    Image3: TImage;
    Image4: TImage;
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
    Label8: TLabel;
    Label9: TLabel;
    LabelCharge: TLabel;
    LabelMass: TLabel;
    LabelTime: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    chartSourceRMS: TListChartSource;
    chartSourceCurrent: TListChartSource;
    OpenDialog: TOpenDialog;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
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
    ProgressBarTime: TProgressBar;
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
    panelButtons: TPanel;
    panelLogo: TPanel;
    panelRight: TPanel;
    rbRyodorakuLeft: TRadioButton;
    rbRyodorakuRight: TRadioButton;
    SaveDialog: TSaveDialog;
    SaveDialogForm: TSaveDialog;
    ScrollBox1: TScrollBox;
    Serial: TLazSerial;
    Panel2: TPanel;
    statusBar: TStatusBar;
    gridRyodoraku: TStringGrid;
    StringGridEAPTherapy: TStringGrid;
    StringGridIonTherapy: TStringGrid;
    StringGridEAV: TStringGrid;
    tabConsole: TTabSheet;
    TabControl1: TTabControl;
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
    procedure ButtonSaveReportClick(Sender: TObject);
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
    procedure gridRyodorakuDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure gridRyodorakuKeyPress(Sender: TObject; var Key: char);
    procedure gridRyodorakuSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure gridRyodorakuSelection(Sender: TObject; aCol, aRow: Integer);

    procedure Label8Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);

    procedure rbCommonChange(Sender: TObject);

    procedure rbRyodorakuLeftChange(Sender: TObject);

    procedure SerialRxData(Sender: TObject);
    procedure StringGridEAPTherapySelectCell(Sender: TObject; aCol,
      aRow: Integer; var CanSelect: Boolean);
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

  private
    const
         MODE_UNK = -1; //unknown
         MODE_EAP = 0;
         MODE_EAV = 1;
         MODE_VEG = 2;
         MODE_RYO = 3; //Ryodoraku
         MODE_ION = 4; //Ionophoreses & zapper

      MAX_SERIES_NUMBER = 50;
      MAX_EAP_POINTS_NUMBER = 50;
      //RYODORAKU_NORMAL_MIN = 75;
      //RYODORAKU_NORMAL_MAX = 100;
      RYODORAKU_FACTOR = 1.54;
      // MINIVOLL_READ_VALUE_PERIOD = 0.05; //seconds

      EAP_TIME_GRID_COL = 3;
      EAP_ELAPSED_GRID_COL = 4;
      EAP_PROGRESS_GRID_COL = 5;
      EAP_PRECENTAGE_GRID_COL = 6;


    var
      CurrentMode : integer;
      FLastCol : integer;
      FLastLeftSide : boolean;
      FCurrentPointName : string;
      FRyodorakuChart : integer;
      fReadBuffer : string;
      //step : Cardinal;
      startTime : Double;
      mySeries : TLineSeries;
      seriesArray : array[1..MAX_SERIES_NUMBER] of TLineSeries; //No dynamic array of all used series
      //EAPDoneTimeArray : array[1..MAX_EAP_POINTS_NUMBER] of Double;
      EAPProgressGridRow : integer;
      EAPProgressTime : Double;
      myTime : Double;
      lastMyTime : Double;
      firstTime_ION : boolean;
      Charge_ION : Double;





  public
     const

     var
     ryodorakuPoint : array[0..11,0..1] of Double; //[0..23]


  end;

var
  frmMain: TfrmMain;

implementation

uses unitVegatestSelector, myFunctions, unitUpdateList, unitChooseEAPTherapy;


{$R *.lfm}

{ TfrmMain }


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
                     Charge_ION := 0;

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
   for i:=1 to High(seriesArray) do begin
       cboxSeries.Items.Delete(1);
       seriesArray[i].Clear;
       seriesArray[i].LinePen.Style:=psDash;
       seriesArray[i].SeriesColor:=clWhite; //clGray;
       seriesArray[i].Title:='';
   end;
   chartMainCurrentLineSeries.Clear;
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

procedure LoadEAPFromFile(idx:integer);
begin


end;

procedure TfrmMain.ButtonChooseEAPTherapyClick(Sender: TObject);
var TherapyIdx : integer;
    EAPTherapy: TEAPTherapy;
    i : integer;
begin
  TherapyIdx:=0; //Nothing was chosen
  TherapyIdx := FormChooseEAPTherapy.Choose;

  //ShowMessage(FormChooseEAPTherapy.EAPTherapyString);
  EAPTherapy:=StringToEAPTherapy(FormChooseEAPTherapy.EAPTherapyString);

  StringGridEAPTherapy.RowCount:=1;
  StringGridEAPTherapy.RowCount:=Length(EAPTherapy)+1;
  for i:= 1 to Length(EAPTherapy) do begin
      with StringGridEAPTherapy do begin
          Cells[0,i]:=EAPTherapy[i-1].Point;          //Point name
          Cells[1,i]:=EAPTherapy[i-1].Meridian;       //Meridian name
//TODO
          Cells[2,i]:='User'; //EAPTherapy[i-1].Profile;        //Profile name
          Cells[3,i]:=IntToStr( EAPTherapy[i-1].Time);//Therapy time
      end;

  end;






  //ShowMessage(IntToStr(TherapyIdx));





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
      s:=ExtractFilePath(Application.ExeName)+'\qiWELLNESS.port';

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
           statusBar.SimpleText:='Serial port: '+ Serial.Device+' is open.';

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

procedure TfrmMain.ButtonIonOnClick(Sender: TObject);
begin
   Serial.WriteData('act 1'+#13#10);
   sleep(200);
   setIonParameters(Sender);
end;

procedure TfrmMain.ButtonIonOffClick(Sender: TObject);
begin
   Serial.WriteData('act 0'+#13#10);
   sleep(200);
end;

procedure TfrmMain.ButtonUpdateClick(Sender: TObject);
var DestinationListFile : string;
begin

  DestinationListFile := ExtractFilePath(Application.ExeName) + LISTS_DEF[LIST_ION_SUBSTANCES].FileName;

  if SysUtils.FileExists(DestinationListFile) then
     StringGridIonTherapy.LoadFromCSVFile(DestinationListFile)
  else
     StringGridIonTherapy.SaveToCSVFile(DestinationListFile);

    FormUpdateList.OpenWindowUpdateList( LIST_ION_SUBSTANCES );

  if SysUtils.FileExists(DestinationListFile) then
     StringGridIonTherapy.LoadFromCSVFile(DestinationListFile);

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

   if chartMainCurrentLineSeries.Count < 50 then begin
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
      ListSource.CopyFrom(chartMainCurrentLineSeries.Source);
      Title:=s;
   end;

   chartMainCurrentLineSeries.Clear;


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

   if chartMainCurrentLineSeries.Count < 50 then begin
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
     ListSource.CopyFrom(chartMainCurrentLineSeries.Source);
     Title:=currentPointName;
  end;

  chartMainCurrentLineSeries.Clear;
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

   if chartMainCurrentLineSeries.Count < 50 then begin
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
     ListSource.CopyFrom(chartMainCurrentLineSeries.Source);
     Title:=currentPointName;
  end;

  chartMainCurrentLineSeries.Clear;
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




procedure TfrmMain.ButtonSaveReportClick(Sender: TObject);
var
  bmp: TBitmap;

begin
  //FormUpdateList.Show;
  FormUpdateList.OpenWindowUpdateList( LIST_EAP_PATHS );

  (*
  statusBar.SimpleText:=FormatDateTime('yyyy-MM-DD hh:nn',Now());

  if SaveDialogForm.Execute then begin

    bmp := TBitmap.Create;
    try
      //Application.ProcessMessages;
      bmp.Canvas.Changed;
      bmp := frmMain.GetFormImage;
      bmp.SaveToFile(SaveDialogForm.FileName);
    finally
      bmp.Free;
    end;

  end;
  *)
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
    //chartMain.LeftAxis.Range.Max:=1000;
    frmMain.edtFreqChange(Sender);

  end else begin
    chartMain.LeftAxis.Range.Max:=100;
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

  Caption := 'qiWELLNESS   ' +SOFTWARE_VERSION;

  memoConsole.Lines.Add ('Software version: ' +SOFTWARE_VERSION);

  DefaultFormatSettings.DecimalSeparator:='.';

  for i:=1 to MAX_SERIES_NUMBER do begin;
    seriesArray[i] := TLineSeries.Create(Self);
    chartMain.AddSeries(seriesArray[i]);
    seriesArray[i].SeriesColor:=clWhite;
    seriesArray[i].Title:='';
  end;

  mySeries:=chartMainCurrentLineSeries;

  startTime := 0;
  lastMyTime := 0;
  EAPProgressGridRow := 0;
  FLastCol := 0;
  firstTime_ION := True;


  //Iontophoresis tab
  DestinationListFile := ExtractFilePath(Application.ExeName) + LISTS_DEF[LIST_ION_SUBSTANCES].FileName;

  if SysUtils.FileExists(DestinationListFile) then
     StringGridIonTherapy.LoadFromCSVFile(DestinationListFile);





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

     Self.Height := 850;
     Self.Width := 1600;

  pageRight.TabIndex:=0;
  CurrentMode := MODE_UNK;

  //Load user veagtest selector
  SelectorLoad;

  RyodorakuClear;

  EAPClear;

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
  ProgressBarTime.Position:=0;

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



procedure TfrmMain.Label8Click(Sender: TObject);
begin
  OpenUrl('https://biotronics.eu/literature');
end;

procedure TfrmMain.Label9Click(Sender: TObject);
begin

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
var s,ss : string;
    i,j,l,p: integer;
    d : Double;


begin

  s:= Serial.ReadData;

  for i:=1 to Length(s) do
     if (s[i]= #10)  then begin

       memoConsole.Lines.Add(trim(fReadBuffer));
       ss:=trim(fReadBuffer);

        if (ss= ':btn' ) then begin //TODO: check
          // Save series
          //Do nothing
          //frmMain.btnSaveAs.SetFocus;
          //frmMain.btnSaveAsClick (Sender);
          //mySeries.Clear;
          //mySeries.AddXY( 0.0,0 );
          //startTime:=Now();
          //step:=1;

        end else if (ss=':vstart') then begin
          // Clear series

          mySeries.Clear;
          chartMain.BottomAxis.Range.Max:=7;  // 7 sec.
          chartMain.LeftAxis.Range.Max:=100;  // 100%
          chartMain.LeftAxis.Range.UseMax:= True;
          mySeries.SeriesColor:= $000080FF;
          startTime:=Now()-0.03/(24*60*60);


          mySeries.AddXY( 0.03,0 );

         end else if (ss=':estart') then begin
          // Clear series

          mySeries.Clear;
          chartMain.BottomAxis.Range.Max:=7;  // 7 sec.
          chartMain.LeftAxis.Range.Max:=100;  // 100%
          chartMain.LeftAxis.Range.UseMax:= True;
          mySeries.SeriesColor:= clRed;
          startTime:=Now()-0.03/(24*60*60);


          mySeries.AddXY( 0.03,0 );


        end else if (ss=':cstart') then begin
          // Clear series

          CurrentMode := MODE_EAP;

          mySeries.Clear;
          chartMain.LeftAxis.Range.Max:=500;  // 500uA
          mySeries.SeriesColor:= clGreen;

          chartMain.LeftAxis.Range.UseMax:= True;
          chartMain.BottomAxis.Range.Max:=30; // 30sec. or more

          ProgressBarTime.Max:=StrToIntDef(StringGridEAPTherapy.Cells[EAP_TIME_GRID_COL,EAPProgressGridRow],0);
          ProgressBarTime.Position := StrToIntDef(StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,EAPProgressGridRow],0);
          //ProgressBarTime.Color:=clGreen;

          startTime:=Now()-0.03/(24*60*60);

          mySeries.AddXY( 0.03,0 );




        end else if (ss=':istart') then begin

          CurrentMode := MODE_ION;


          if firstTime_ION then begin

            mySeries.Clear;
            firstTime_ION := False;

            chartMain.LeftAxis.Range.Max:=12;  // 12mA
            mySeries.SeriesColor:= clGreen;
            chartMain.LeftAxis.Range.UseMax:= True;
            chartMain.BottomAxis.Range.Max:=120; // 2min. or more

            startTime:=Now()-0.03/(24*60*60);
            mySeries.AddXY( 0.03,0 );

          end else begin

            myTime:= (Now()- startTime)*(24*60*60);
            if myTime > 120 then chartMain.LeftAxis.Range.UseMax:= False;

            mySeries.AddXY( myTime ,0);

          end;




        end else if ss=':stop' then begin

          case CurrentMode of
            MODE_ION : begin

                         mySeries.AddXY( myTime ,0);
                         chartSourceRMS_ION.SetYValue(0,0);

            end;


            MODE_EAP : begin

                         myTime:= (Now()- startTime)*(24*60*60);

                         StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,EAPProgressGridRow]:=
                           IntToStr(
                             StrToIntDef(StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,EAPProgressGridRow],0)+
                               Round(myTime)
                           );

                         chartSourceCurrent.SetYValue(0,0);
                         chartSourceRMS.SetYValue(0,0);
            end;

          end;  // case





        end else if copy(ss,1,2)= ':c' then begin
        // Add to eap current series new point
           ss:=copy(ss,3,Length(ss));
           myTime:= (Now()- startTime)*(24*60*60);

           //Rescale chart to 2 minutes
           if myTime >= 30 then begin
              chartMain.BottomAxis.Range.Max:=120;
              ProgressBarTime.Max:=120;
              ProgressBarTime.Color:=clYellow;
           end;

           p := Pos(' ',ss);

           if p=0 then begin

               j:= StrToIntDef(ss,0);
               d:= StrToFloatDef(edtDutyCycle.Text,0);

           end else begin
               j := StrToIntDef( Trim( Copy(ss,1,p) ),0);
               d := StrToFloatDef( Trim( Copy(ss,p,Length(ss)-p) ),0);
           end;

           mySeries.AddXY( myTime ,j*d/100);

           chartSourceCurrent.SetYValue(0,j/1000);
           chartSourceRMS.SetYValue(0,j*d/100); //chartSourceRMS.SetYValue(0,j*StrToFloatDef(edtDutyCycle.Text,0)/100);


             l:= StrToIntDef(StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,EAPProgressGridRow],0)+
             Round(myTime);
           ProgressBarTime.Position:= l;
           //if l > 30 then ProgressBarTime.Max:=120 else ProgressBarTime.Max:=30;
//TODO           StringGridEAPTherapy.Cells[EAP_PRECENTAGE_GRID_COL,EAPProgressGridRow]:= IntToStr(l)+'%';


           //Set EAP therapy progress of the point
           if EAPProgressGridRow > 0 then begin

             StringGridEAPTherapy.Cells[EAP_PROGRESS_GRID_COL,EAPProgressGridRow]:= StringOfChar(char('|'),
               Trunc(StrToIntDef(StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,EAPProgressGridRow],0)+myTime/3));

           end;



        end else if copy(ss,1,2)= ':i' then begin
        // Add to eap current series new point
           ss:=copy(ss,3,Length(ss));
           myTime:= (Now()- startTime)*(24*60*60);
           //myTime:= (Now()- startTime)*(24*60*60);

           //Rescale chart to 2 minutes
           if myTime >= 120 then begin
              chartMain.BottomAxis.Range.Max:=600;
              //ProgressBarTime.Max:=120;
              //ProgressBarTime.Color:=clYellow;
           end;

           p := Pos(' ',ss);

           if p=0 then begin

               j:= StrToIntDef(ss,0);
               d:= StrToFloatDef(edtDutyCycle.Text,0);

           end else begin
               j := StrToIntDef( Trim( Copy(ss,1,p) ),0);
               d := StrToFloatDef( Trim( Copy(ss,p,Length(ss)-p) ),0);
           end;

           mySeries.AddXY( myTime ,j*d/100000);

           chartSourceRMS_ION.SetYValue(0,j*d/100000);
           Charge_ION := Charge_ION + (j*d/100000) (*mA*) * (myTime - lastMyTime) (*s*) / 3600;
           LabelCharge.Caption := FormatFloat('0.000',Charge_ION);
           LabelMass.Caption:= FormatFloat('0.000', calculateMass( StrToFloat(EditMolarMass_ION.Caption), StrToFloat(EditValence_ION.Caption), Charge_ION(*mAh*)));
           // : Double;
           lastMyTime := myTime;


        end else  if( copy(ss,1,2)= ':v') or (copy(ss,1,2)= ':e') then begin // Veagtest and  EAV have the same scale
            ss:=copy(ss,3,Length(ss));
            myTime:= (Now()- startTime)*(24*60*60);

            mySeries.AddXY( myTime ,StrToIntDef(ss,0)/10.0  );

        end;


       fReadBuffer:='';
     end else
       fReadBuffer:=fReadBuffer+s[i];


end;

procedure TfrmMain.StringGridEAPTherapySelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  EAPProgressGridRow := aRow;
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


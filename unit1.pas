unit Unit1;

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
    btnSaveAs: TButton;
    btnDelete: TButton;
    ButtonVegatestEdit: TButton;
    ButtonSaveReport: TButton;
    btnConsoleExecute: TButton;
    btnClose: TButton;
    btnEapSave: TButton;
    btnEapLoad: TButton;
    btnEapLoadFromWebside: TButton;
    ButtonRyodorakuAnalize: TButton;
    ButtonRyodorakuSendToEAP: TButton;
    cboxSeries: TComboBox;
    cbRyodorakuOn: TCheckBox;
    cbEAVOn: TCheckBox;
    cbElectropunctueOn: TCheckBox;
    cbVegatestOn: TCheckBox;
    chartRyodoraku: TChart;
    chartRyodorakuRightSeries: TBarSeries;
    chartRMS: TChart;
    chartRMSBarSeries1: TBarSeries;
    chartSeriesCurrent: TBarSeries;
    chartCurrent: TChart;
    chartRyodorakuNormal: TLineSeries;
    ChartComboBox1: TChartComboBox;
    ChartLegendPanel1: TChartLegendPanel;
    chartRyodorakuLeftSeries: TBarSeries;
    chartMain: TChart;
    chartMainCurrentLineSeries: TLineSeries;
    cboxChangeDirections: TCheckBox;
    edtDutyCycle: TFloatSpinEdit;
    edtFreq: TFloatSpinEdit;
    edtSeconds: TEdit;
    edtConsoleCommand: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label1: TLabel;
    LabelTime: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    chartSourceRMS: TListChartSource;
    chartSourceCurrent: TListChartSource;
    OpenDialog: TOpenDialog;
    Panel4: TPanel;
    ryodorakuLeftSource: TListChartSource;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
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
    PageControl1: TPageControl;
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
    Serial: TLazSerial;
    Panel2: TPanel;
    statusBar: TStatusBar;
    gridRyodoraku: TStringGrid;
    StringGridEAPTherapy: TStringGrid;
    tabConsole: TTabSheet;
    TabControl1: TTabControl;
    tabRyodoraku: TTabSheet;
    tabEAV: TTabSheet;
    tabElectropunture: TTabSheet;
    tabAuriculotherapy: TTabSheet;
    TabSheet2: TTabSheet;
    Hand: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    tabVegatest: TTabSheet;
    timerChangeDirection: TTimer;
    TreeViewSelector: TTreeView;
    procedure btnConsoleExecuteClick(Sender: TObject);
    procedure btnDeleteAllClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEapLoadClick(Sender: TObject);
    procedure btnEapSaveClick(Sender: TObject);
    //procedure btnVegatestDeleteClick(Sender: TObject);
    //procedure btnVegatestNewClick(Sender: TObject);
    //procedure btnVegatestNewGroupClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    //procedure btnVegatestSaveClick(Sender: TObject);
    procedure ButtonSaveReportClick(Sender: TObject);
    procedure ButtonVegatestEditClick(Sender: TObject);
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
    procedure gridRyodorakuSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure Image2Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure rbCommonChange(Sender: TObject);

    procedure SerialRxData(Sender: TObject);
    procedure StringGridEAPTherapySelectCell(Sender: TObject; aCol,
      aRow: Integer; var CanSelect: Boolean);
    //procedure serialStatus(Sender: TObject; Reason: THookSerialReason;
    //const Value: string);
    procedure tabEAVShow(Sender: TObject);
    procedure tabElectropuntureShow(Sender: TObject);
    procedure tabRyodorakuShow(Sender: TObject);
    procedure tabVegatestShow(Sender: TObject);
    procedure timerChangeDirectionTimer(Sender: TObject);
    procedure TreeViewSelectorSelectionChanged(Sender: TObject);
    procedure SelectorLoad();

  private
    const
      MAX_SERIES_NUMBER = 30;
      MAX_EAP_POINTS_NUMBER = 30;
      //RYODORAKU_NORMAL_MIN = 75;
      //RYODORAKU_NORMAL_MAX = 100;
      RYODORAKU_FACTOR = 1.54;
      // MINIVOLL_READ_VALUE_PERIOD = 0.05; //seconds

      EAP_TIME_GRID_COL = 3;
      EAP_ELAPSED_GRID_COL = 4;
      EAP_PROGRESS_GRID_COL = 5;
      EAP_PRECENTAGE_GRID_COL = 6;


    var
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

      procedure ClearEAP;

  public
     ryodorakuPoint : array[0..11,0..1] of Double; //[0..23]

  end;

var
  frmMain: TfrmMain;

implementation

uses unitVegatestSelector;


{$R *.lfm}

{ TfrmMain }


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

procedure TfrmMain.btnEapLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    StringGridEAPTherapy.LoadFromCSVFile(OpenDialog.FileName);
end;

procedure TfrmMain.btnEapSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then;
     StringGridEAPTherapy.SaveToCSVFile(SaveDialog.FileName);
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

  //step := 1;
end;

procedure TfrmMain.btnSaveAsClick(Sender: TObject);
var s : string;
    i,j,count : integer;
    sum,d : Double;
    chartIndex: integer;
    rightChartIndex : integer;
begin
  chartIndex      := -1;
  rightChartIndex := -1;

  //Check numbers of seriers on chart
  if cboxSeries.Items.Count>MAX_SERIES_NUMBER then exit;

  //Check if is set series name
  if FCurrentPointName='' then begin

     //Auto name series
     FCurrentPointName := 'New ' + IntToStr(cboxSeries.Items.Count);
     repeat
           s := InputBox('Active Point', 'Write name of chart.', FCurrentPointName);
     until s <> '';

  end else begin

     s:=FCurrentPointName;

     if cbRyodorakuOn.Checked then begin
        //chartIndex := FRyodorakuChart;
       chartIndex := FRyodorakuChart div 2;
       rightChartIndex :=  FRyodorakuChart mod 2;
     end;

  end;

  FCurrentPointName:='';


  i:= cboxSeries.Items.Add(s);

  with seriesArray[i] do begin
     SeriesColor:=clGray;
     LinePen.Color:=clGray;
     LinePen.Style:=ChartComboBox1.PenStyle;
     LinePen.Width:=3;
     ListSource.CopyFrom(chartMainCurrentLineSeries.Source);
     Title:=s;
  end;

  chartMainCurrentLineSeries.Clear;

//RYODORAKU
  if (chartIndex<>-1) and (cbRyodorakuOn.Checked) then begin

//TODO: Calculate current equivalent  - check!
    if seriesArray[i].Count > 50 then
       d:= seriesArray[i].GetYValue(40) (*MaxYValue*) * RYODORAKU_FACTOR    //Get sample at 0.8sec.
    else  begin
        ShowMessage('Take a longer sample! Minimum is 1 second.');
        Exit;
    end;

    //Save value
    ryodorakuPoint[chartIndex,rightChartIndex]:= d;
    if rightChartIndex=0 then
      ryodorakuLeftSource.SetYValue(chartIndex,d)
    else
      ryodorakuRightSource.SetYValue(chartIndex,d);



    //Calculate normal value  (+/- 15[uA])

    sum:=0;
    count:=0;

    for i:= 0 to 11 do
       for j:= 0 to 1 do begin

         if ryodorakuPoint[i,j]>0 then begin

           sum := sum + ryodorakuPoint[i,j];
           count := count+1;

         end;

       end;


    //Set normal line on ryododraku chart

    if count>0 then begin
      sum := round(sum/count);
      ryodorakuNormalSource.SetYValue(0,sum);
      ryodorakuNormalSource.SetYValue(1,sum);
    end;


    //Set color of ryodoraku charts

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



procedure TfrmMain.ButtonSaveReportClick(Sender: TObject);
var
  bmp: TBitmap;

begin
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

end;

procedure TfrmMain.ButtonVegatestEditClick(Sender: TObject);
begin
  FormVegatestSelector.ShowModal;
end;

procedure TfrmMain.cbElectropunctueOnChange(Sender: TObject);
var b : boolean;
begin
  b := cbElectropunctueOn.Checked;
  //timerCurrent.Enabled:=b;
  if b then begin
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
      Serial.WriteData('freq 100 100'#13#10);   //DC current

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
begin
  DefaultFormatSettings.DecimalSeparator:='.';

  for i:=1 to MAX_SERIES_NUMBER do begin;
    seriesArray[i] := TLineSeries.Create(Self);
    chartMain.AddSeries(seriesArray[i]);
    seriesArray[i].SeriesColor:=clWhite;
    seriesArray[i].Title:='';
  end;

  mySeries:=chartMainCurrentLineSeries;

  startTime := 0;
  EAPProgressGridRow := 0;

end;

procedure TfrmMain.SelectorLoad();
var s: string;
begin
   //Load user veagtest selector
  s:= ExtractFilePath(Application.ExeName)+'qiWELLNESS.sel';
  if FileExists(s)then
     TreeViewSelector.LoadFromFile(s);

end;

procedure TfrmMain.FormShow(Sender: TObject);
var
    i : integer;
begin

  //Load user veagtest selector
  SelectorLoad();

  //Clear Ryodoraku chart
  for i:= 0 to 11 do begin
      chartRyodorakuLeftSeries.SetYValue(i,0);
      chartRyodorakuRightSeries.SetYValue(i,0); //do not use Clear method
  end;

  ClearEAP;

end;

procedure TfrmMain.ClearEAP;
var i: integer;
begin
  //Clear all EAP counters
  // EAP_TIME_GRID_COL = 3;
  // EAP_ELAPSED_GRID_COL = 4;
  // EAP_PROGRESS_GRID_COL = 5;
  // EAP_PRECENTAGE_GRID_COL = 6;
  for i:= 1 to StringGridEAPTherapy.RowCount-1 do begin

      StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,i]:='';
      StringGridEAPTherapy.Cells[EAP_PROGRESS_GRID_COL,i]:='';
      //StringGridEAPTherapy.Cells[EAP_PRECENTAGE_GRID_COL,i]:='0%';
  end;

  //Clear all electropuncture current charts
  chartSourceCurrent.SetYValue(0,0);
  chartSourceRMS.SetYValue(0,0);
  ProgressBarTime.Position:=0;
end;


procedure TfrmMain.gridRyodorakuDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin

  if (ACol = 0) and (ARow = 0) then
    with TStringGrid(Sender) do begin
      //Paint the background
      Canvas.Brush.Color := clBtnFace;
      Canvas.FillRect(aRect);
      Canvas.TextOut(aRect.Left+2,aRect.Top+2,Cells[ACol, ARow]);
    end;

end;


procedure TfrmMain.gridRyodorakuSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
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

end;

procedure TfrmMain.Image2Click(Sender: TObject);
begin

end;


procedure TfrmMain.Label8Click(Sender: TObject);
begin
  OpenUrl('https://biotronics.eu/literature');
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





procedure TfrmMain.SerialRxData(Sender: TObject);
var s,ss : string;
    i,j,l,p: integer;
    myTime,d : Double;

begin

  s:= Serial.ReadData;

  for i:=1 to Length(s) do
     if (s[i]= #10)  then begin

       memoConsole.Lines.Add(trim(fReadBuffer));
       ss:=trim(fReadBuffer);

        if (ss= ':btn' ) then begin //TODO: check
          // Save series

          frmMain.btnSaveAs.SetFocus;
          frmMain.btnSaveAsClick (Sender);
          mySeries.Clear;
          mySeries.AddXY( 0.0,0 );
          startTime:=Now();
          //step:=1;

        end else if (ss=':vstart') then begin
          // Clear series

          mySeries.Clear;
          chartMain.BottomAxis.Range.Max:=7;  // 7 sec.
          chartMain.LeftAxis.Range.Max:=100;  // 100%
          mySeries.SeriesColor:= $000080FF;
          startTime:=Now()-0.03/(24*60*60);


          mySeries.AddXY( 0.03,0 );

         end else if (ss=':estart') then begin
          // Clear series

          mySeries.Clear;
          chartMain.BottomAxis.Range.Max:=7;  // 7 sec.
          chartMain.LeftAxis.Range.Max:=100;  // 100%
          mySeries.SeriesColor:= clRed;
          startTime:=Now()-0.03/(24*60*60);


          mySeries.AddXY( 0.03,0 );


        end else if (ss=':cstart') then begin
          // Clear series

          mySeries.Clear;
          chartMain.LeftAxis.Range.Max:=500;  // 500uA
          chartMain.BottomAxis.Range.Max:=30; // 30sec. or more
          mySeries.SeriesColor:= clGreen;

          ProgressBarTime.Max:=StrToIntDef(StringGridEAPTherapy.Cells[EAP_TIME_GRID_COL,EAPProgressGridRow],0);
          ProgressBarTime.Position := StrToIntDef(StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,EAPProgressGridRow],0);
          //ProgressBarTime.Color:=clGreen;


          startTime:=Now()-0.03/(24*60*60);

          mySeries.AddXY( 0.03,0 );

        end else if ss=':stop' then begin
// :stop
           myTime:= (Now()- startTime)*(24*60*60);

           StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,EAPProgressGridRow]:=
             IntToStr(
               StrToIntDef(StringGridEAPTherapy.Cells[EAP_ELAPSED_GRID_COL,EAPProgressGridRow],0)+
               Round(myTime)
             );

           chartSourceCurrent.SetYValue(0,0);
           chartSourceRMS.SetYValue(0,0);

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


procedure TfrmMain.tabEAVShow(Sender: TObject);
begin
  cbEAVOn.Checked:=frmMain.tabEAV.Visible;

  if (Serial.Active) and (cbEAVOn.Checked) then begin

    Serial.WriteData('eav'#13#10);

  end;
end;


procedure TfrmMain.tabElectropuntureShow(Sender: TObject);
begin

  cbElectropunctueOn.Checked:=frmMain.tabElectropunture.Visible;

  if (Serial.Active) and (cbElectropunctueOn.Checked) then
    Serial.WriteData('eap'#13#10);

end;


procedure TfrmMain.tabRyodorakuShow(Sender: TObject);
begin

  cbRyodorakuOn.Checked:=frmMain.tabRyodoraku.Visible;

  if (Serial.Active) and (cbRyodorakuOn.Checked) then
    Serial.WriteData('eav'#13#10); //Ryodoraku is measured with the same parameter as EAV
end;


procedure TfrmMain.tabVegatestShow(Sender: TObject);
begin

  cbVegatestOn.Checked:=frmMain.tabVegatest.Visible;

  //Send to miniVOLL commmand: vegatest
  if (Serial.Active) and (cbVegatestOn.Checked) then
    Serial.WriteData('veg'#13#10);

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



procedure TfrmMain.TreeViewSelectorSelectionChanged(Sender: TObject);
begin
  FCurrentPointName:=TreeViewSelector.Selected.Text;

end;


end.


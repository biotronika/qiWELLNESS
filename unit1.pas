unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, CheckLst, Grids, ColorBox, LazSerial, TAGraph, TASeries,
  TALegendPanel, TASources, TAChartCombos,  Types , LCLType,  lclintf;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnDeleteAll: TButton;
    btnConnect: TButton;
    btnReset: TButton;
    btnSaveAs: TButton;
    btnDelete: TButton;
    btnVegatestDelete: TButton;
    btnVegatestNew: TButton;
    btnVegatestNewGroup: TButton;
    btnVegatestSave: TButton;
    btnConsoleExecute: TButton;
    btnClose: TButton;
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
    edtDutyCycle: TEdit;
    edtSeconds: TEdit;
    edtFreq: TEdit;
    edtConsoleCommand: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label1: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    chartSourceRMS: TListChartSource;
    chartSourceCurrent: TListChartSource;
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
    pbarTimer: TProgressBar;
    rbNegativeElectrode: TRadioButton;
    rbDCpositive: TRadioButton;
    rbDCchangeDirections: TRadioButton;
    rbPositiveElectrode: TRadioButton;
    rbDirect: TRadioButton;
    rbPulse: TRadioButton;
    rbUsers: TRadioButton;
    rbCommon: TRadioButton;
    rbStimulation: TRadioButton;
    rbsedation: TRadioButton;
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
    serial: TLazSerial;
    Panel2: TPanel;
    statusBar: TStatusBar;
    gridRyodoraku: TStringGrid;
    tabConsole: TTabSheet;
    TabControl1: TTabControl;
    tabRyodoraku: TTabSheet;
    tabEAV: TTabSheet;
    tabElectropunture: TTabSheet;
    tabAuriculotherapy: TTabSheet;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Hand: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    tabVegatest: TTabSheet;
    timerCurrent: TTimer;
    timerChangeDirection: TTimer;
    treeviewSelector: TTreeView;
    procedure btnConsoleExecuteClick(Sender: TObject);
    procedure btnDeleteAllClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnVegatestDeleteClick(Sender: TObject);
    procedure btnVegatestNewClick(Sender: TObject);
    procedure btnVegatestNewGroupClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnVegatestSaveClick(Sender: TObject);
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
    procedure Label8Click(Sender: TObject);
    procedure pageRightChange(Sender: TObject);
    procedure serialRxData(Sender: TObject);
    //procedure serialStatus(Sender: TObject; Reason: THookSerialReason;
    //const Value: string);
    procedure tabEAVShow(Sender: TObject);
    procedure tabElectropuntureShow(Sender: TObject);
    procedure tabRyodorakuShow(Sender: TObject);
    procedure tabVegatestShow(Sender: TObject);
    procedure timerChangeDirectionTimer(Sender: TObject);
    procedure timerCurrentTimer(Sender: TObject);
    procedure treeviewSelectorSelectionChanged(Sender: TObject);

  private
    const
      MAX_SERIES_NUMBER =30;
      //RYODORAKU_NORMAL_MIN = 75;
      //RYODORAKU_NORMAL_MAX = 100;
      RYODORAKU_FACTOR = 1.54;
      MINIVOLL_READ_VALUE_PERIOD = 0.05; //seconds

    var
      FCurrentPointName : string;
      FRyodorakuChart : integer;
      fReadBuffer : string;
      step : Cardinal;
      mySeries : TLineSeries;
      seriesArray : array[1..MAX_SERIES_NUMBER] of TLineSeries; //No dynamic array of all used series

  public
     ryodorakuPoint : array[0..11,0..1] of Double; //[0..23]

  end;

var
  frmMain: TfrmMain;

implementation


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
   step:=0;
end;

procedure TfrmMain.btnConsoleExecuteClick(Sender: TObject);
begin
    if (serial.Active) then begin

    serial.WriteData(edtConsoleCommand.Text+#13#10);

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
      step:=0;
      //ShowMessage('Can not delete working chart');
  end;

end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  if serial.Active then begin
    serial.Close;
    statusBar.SimpleText:='Serial connection was closed';
  end;
end;

procedure TfrmMain.btnVegatestDeleteClick(Sender: TObject);

    //Procedure to recursively delete nodes
    procedure DeleteNode(Node:TTreeNode);
    begin
         while Node.HasChildren do
               DeleteNode(node.GetLastChild);
         treeviewSelector.Items.Delete(Node) ;
    end;

begin
     if treeviewSelector.Selected = nil then  exit;

     //If selected node has child nodes, first ask for confirmation
     if treeviewSelector.Selected.HasChildren then
        if messagedlg( 'Delete selected group and all children?',mtConfirmation, [mbYes,mbNo],0 ) <> mrYes then
           exit;
        DeleteNode(treeviewSelector.Selected);
end;

procedure TfrmMain.btnVegatestNewClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  // Set up a simple text for each new node - Node1 , Node2 etc
  i := treeviewSelector.Items.Count;
  s := 'New ' + inttostr(i);
  //Add a new node to the currently selected node
  if treeviewSelector.Selected <> nil then begin
    treeviewSelector.Items.AddChild(treeviewSelector.Selected ,s);
    treeviewSelector.Selected.Expand(true);
  end;

end;


procedure TfrmMain.btnVegatestNewGroupClick(Sender: TObject);
begin
  treeviewSelector.Items.Add(nil,'New group');
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
begin
  memoConsole.Lines.Clear;

  Sleep(2);

  if serial.Active then begin
     //DTR line is in Arduino boartds the reset of an ucontroller
     serial.SetDTR(false);
     Sleep(2);
     serial.SetDTR(true);
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
         serial.Device:=s;
      //CloseFile(f);
      end;

      serial.ShowSetupDialog;
      serial.Open;

      if serial.Active then  begin
           Rewrite(f);
           {$I-}
           Writeln(f,serial.Device);
           {$I+}
           statusBar.SimpleText:='Serial port: '+ serial.Device+' is open.';

      end;
      CloseFile(f);

  step := 1;
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

  if (chartIndex<>-1) and (cbRyodorakuOn.Checked) then begin

//TODO: Calculate current equivalent  - check!
    d:= seriesArray[i].MaxYValue * RYODORAKU_FACTOR;

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

procedure TfrmMain.btnVegatestSaveClick(Sender: TObject);
begin
  //Showmessage();
  treeviewSelector.SaveToFile(ExtractFilePath(Application.ExeName)+'selector.txt');
  //ExtractFilePath(Application.ExeName)
end;

procedure TfrmMain.cbElectropunctueOnChange(Sender: TObject);
var b : boolean;
begin
  b := cbElectropunctueOn.Checked;
  timerCurrent.Enabled:=b;
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
  if serial.Active then begin

    //Type of current (pulse or DC)
    if rbPulse.Checked then
      serial.WriteData('freq '+ IntToStr(trunc(StrToFloatDef(edtFreq.Text,10)*100)) +' '+edtDutyCycle.Text+#13#10)
    else
      serial.WriteData('freq 100 100'#13#10);   //DC current

    sleep(200);

    //Polarization of electrode
    if rbNegativeElectrode.Checked then
      serial.WriteData('chp 0'#13#10)
    else
       serial.WriteData('chp 1'#13#10);

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

end;

procedure TfrmMain.FormShow(Sender: TObject);
var s: string;
    i : integer;
begin

  //Load user veagtest selector
  s:= ExtractFilePath(Application.ExeName)+'selector.txt';
  if FileExists(s)then
     treeviewSelector.LoadFromFile(s);

  //Clear Ryodoraku chart
  for i:= 0 to 11 do begin
      chartRyodorakuLeftSeries.SetYValue(i,0);
      chartRyodorakuRightSeries.SetYValue(i,0); //do not use Clear method
  end;

  //Clear all electropuncture current charts
  chartSourceCurrent.SetYValue(0,0);
  chartSourceRMS.SetYValue(0,0);
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


procedure TfrmMain.Label8Click(Sender: TObject);
begin
  OpenUrl('https://biotronics.eu/literature');
end;

procedure TfrmMain.pageRightChange(Sender: TObject);
begin

end;




procedure TfrmMain.serialRxData(Sender: TObject);
var s,ss : string;
    i,j: integer;

begin
//Read data from serial port
  //sleep (100);

  s:= serial.ReadData;

  for i:=1 to Length(s) do
     if (s[i]= #10)  then begin
       //if (s[i-1]<> #13) then ss := ss + #13#10 else ss:=ss+#10;
       memoConsole.Lines.Add(trim(fReadBuffer));
       ss:=trim(fReadBuffer);

        if (ss= ':btn') and (step>0) then begin
          // Save series

          frmMain.btnSaveAs.SetFocus;
          frmMain.btnSaveAsClick (Sender);
          mySeries.Clear;
          mySeries.AddXY( 0.03,0 );
          step:=1;

        end else if (ss=':start') then begin
          // Clear series

          mySeries.Clear;
          mySeries.AddXY( 0.03,0 );
          step:=1;

        end else if (ss<>':btn') and (StrToIntDef(ss,0)<>0) then begin
          // Add to existing series new point

          if cbElectropunctueOn.Checked then begin

            j:= StrToIntDef(ss,0);
            if j>3 then begin
               chartMain.LeftAxis.Range.Max:=500;
               chartMain.BottomAxis.Range.Max:=30;


               mySeries.AddXY( step * 0.1 ,j*StrToFloatDef(edtDutyCycle.Text,0)/100);
               mySeries.SeriesColor:= clGreen;

               chartSourceCurrent.SetYValue(0,j/1000);

               chartSourceRMS.SetYValue(0,j*StrToFloatDef(edtDutyCycle.Text,0)/100); //StrToFloatDef(edtDutyCycle.Text,0)/100);
               pbarTimer.Position:=Round(step/10);

            end;

          end else begin
            chartMain.BottomAxis.Range.Max:=7;
            chartMain.LeftAxis.Range.Max:=100;

            mySeries.AddXY( step * MINIVOLL_READ_VALUE_PERIOD ,StrToIntDef(ss,0)/10.0  );
            mySeries.SeriesColor:= clRed;

          end;

          step:=step+1;

        end;



       fReadBuffer:='';
     end else
       fReadBuffer:=fReadBuffer+s[i];


  //s:= trim(serial.ReadData);

  //memoConsole.Lines.Add(s);



end;


procedure TfrmMain.tabEAVShow(Sender: TObject);
begin
  cbEAVOn.Checked:=frmMain.tabEAV.Visible;

  if (serial.Active) and (cbEAVOn.Checked) then begin

    serial.WriteData('eav'#13#10);

  end;
end;


procedure TfrmMain.tabElectropuntureShow(Sender: TObject);
begin

  cbElectropunctueOn.Checked:=frmMain.tabVegatest.Visible;

  if (serial.Active) and (cbElectropunctueOn.Checked) then
    serial.WriteData('eap'#13#10);

end;


procedure TfrmMain.tabRyodorakuShow(Sender: TObject);
begin

  cbRyodorakuOn.Checked:=frmMain.tabRyodoraku.Visible;

  if (serial.Active) and (cbRyodorakuOn.Checked) then
    serial.WriteData('eav'#13#10); //Ryodoraku is measured with the same parameter as EAV
end;


procedure TfrmMain.tabVegatestShow(Sender: TObject);
begin

  cbVegatestOn.Checked:=frmMain.tabVegatest.Visible;

  //Send to miniVOLL commmand: vegatest
  if (serial.Active) and (cbVegatestOn.Checked) then
    serial.WriteData('vegatest'#13#10);

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
  //rbNegativeElectrode.Checked := not rbNegativeElectrode.Checked;
  //rbPositiveElectrode.Checked := not rbPositiveElectrode.Checked;
  //ShowMessage('aa');

end;

procedure TfrmMain.timerCurrentTimer(Sender: TObject);
begin
  if serial.Active then begin
    serial.WriteData('curr'#13#10);
  end;
end;

procedure TfrmMain.treeviewSelectorSelectionChanged(Sender: TObject);
begin
  FCurrentPointName:=treeviewSelector.Selected.Text;

end;


end.


unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, CheckLst, Grids, ColorBox, LazSerial, TAGraph, TASeries,
  TALegendPanel, TASources, TAChartCombos, LazSynaSer;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnDeleteAll: TButton;
    btnConnect: TButton;
    btnReset: TButton;
    btnSaveAs: TButton;
    btnDelete: TButton;
    Chart1: TChart;
    ChartComboBox1: TChartComboBox;
    chartRyodorakuSeries: TBarSeries;
    ChartLegendPanel1: TChartLegendPanel;
    chartMain: TChart;
    chartMainCurrentLineSeries: TLineSeries;
    cboxSeries: TComboBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    ryodorakuSource: TListChartSource;
    memoConsole: TMemo;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    pageRight: TPageControl;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
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
    procedure btnDeleteAllClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure cboxSeriesChange(Sender: TObject);
    procedure ChartComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gridRyodorakuSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure serialRxData(Sender: TObject);
    procedure serialStatus(Sender: TObject; Reason: THookSerialReason;
    const Value: string);

  private
    const  FSeriesCount =30;
           RYODORAKU_NORMAL_MIN = 75;
           RYODORAKU_NORMAL_MAX = 100;
           RYODORAKU_FACTOR = 1.54;
           MINIVOLL_READ_VALUE_PERIOD = 0.05; //seconds

    var
     FCurrentPointName : string;
     FRyodorakuChart : integer;
     step : Cardinal;
     mySeries : TLineSeries;
     seriesArray : array[1..FSeriesCount] of TLineSeries; //No dynamic array of all used series

  public

  end;

var
  Form1: TForm1;

implementation
uses Unit2;

{$R *.lfm}

{ TForm1 }


procedure TForm1.btnDeleteAllClick(Sender: TObject);
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
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
var i,a : integer;
begin

  if cboxSeries.Items.Count>0 then  begin
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
      ShowMessage('Can not delete working chart');
  end;

end;

procedure TForm1.btnResetClick(Sender: TObject);
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

procedure TForm1.btnConnectClick(Sender: TObject);
begin

  serial.ShowSetupDialog;
  serial.Open;
  if serial.Active then  statusBar.SimpleText:='Serial port: '+ serial.Device+' is open.';

  step:=0;
end;

procedure TForm1.btnSaveAsClick(Sender: TObject);
var s : string;
    i : integer;
    d : Double;
    chartIndex: integer;
begin
  chartIndex:=-1;

  if cboxSeries.Items.Count<FSeriesCount then begin
    if FCurrentPointName='' then begin
       repeat
             s := InputBox('Active Point', 'Name of active point?', FCurrentPointName);
       until s <> '';
    end else begin
       s:=FCurrentPointName;
       chartIndex := FRyodorakuChart;
    end;
    FCurrentPointName:='';

    i:= cboxSeries.Items.Add(s);

    with seriesArray[i] do begin
       SeriesColor:=clGray;
       LinePen.Color:=clGray;
       LinePen.Style:=psDash;
       LinePen.Width:=3;
       ListSource.CopyFrom(chartMainCurrentLineSeries.Source);
       Title:=s;
    end;
    if chartIndex<>-1 then begin

//TODO: Calculate current equivalent  - check!
      d:= seriesArray[i].MaxYValue * RYODORAKU_FACTOR;

      ryodorakuSource.SetYValue(chartIndex,d);
      if d<RYODORAKU_NORMAL_MIN then begin
         ryodorakuSource.SetColor(chartIndex,$800000);  //navy
      end else if d>RYODORAKU_NORMAL_MAX then begin
         ryodorakuSource.SetColor(chartIndex,$0000FF);  //red
      end else begin
         ryodorakuSource.SetColor(chartIndex,$008000);  //green
      end;

    end;

  end;
end;


procedure TForm1.cboxSeriesChange(Sender: TObject);
var i:integer;
begin
   for i:=1 to High(seriesArray) do begin
       seriesArray[i].LinePen.Style:=psDash;
       if seriesArray[i].Title ='' then
          seriesArray[i].SeriesColor:=clWhite
       else
          seriesArray[i].SeriesColor:=clGray;
   end;

   if cboxSeries.ItemIndex>0 then
      with seriesArray[cboxSeries.ItemIndex] do begin
           LinePen.Style:=psSolid;
           SeriesColor:=clBlue;
      end;

end;

procedure TForm1.ChartComboBox1Change(Sender: TObject);
begin
  mySeries.LinePen.Style:=ChartComboBox1.Style;
end;



procedure TForm1.FormCreate(Sender: TObject);
var i : integer;
begin

  for i:=1 to FSeriesCount do begin;
    seriesArray[i] := TLineSeries.Create(Self);
    chartMain.AddSeries(seriesArray[i]);
    seriesArray[i].SeriesColor:=clWhite;
    seriesArray[i].Title:='';
  end;

  mySeries:=chartMainCurrentLineSeries;

end;


procedure TForm1.gridRyodorakuSelectCell(Sender: TObject; aCol, aRow: Integer;
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

procedure TForm1.serialRxData(Sender: TObject);
var s: string;

begin
  //Read data from serial port
  step:=step+1;
  s:= serial.ReadData;

  //ss:=IntToStr(step) + ': ' + s;
  memoConsole.Lines.Add(s);

  if (s=':start') or (s= ':button') then begin
    mySeries.Clear;
    mySeries.AddXY( 0,0 );
    step:=0;
  end else begin
    mySeries.AddXY( step * MINIVOLL_READ_VALUE_PERIOD ,StrToIntDef(s,0)/10.0  );
  end;

end;

procedure TForm1.serialStatus(Sender: TObject; Reason: THookSerialReason;
  const Value: string);
begin
  statusBar.SimpleText:='Serial status: '+Value;
end;


end.


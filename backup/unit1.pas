unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, CheckLst, Grids, ColorBox, LazSerial, TAGraph, TASeries,
  TALegendPanel, TASources, TAChartCombos, LazSynaSer;

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
    cboxSeries: TComboBox;
    cbRyodorakuOn: TCheckBox;
    cbEAVOn: TCheckBox;
    cbVegatestOn: TCheckBox;
    Chart1: TChart;
    chartRyodorakuNormal: TLineSeries;
    ChartComboBox1: TChartComboBox;
    ChartLegendPanel1: TChartLegendPanel;
    chartRyodorakuSeries: TBarSeries;
    chartMain: TChart;
    chartMainCurrentLineSeries: TLineSeries;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    ryodorakuNormalSource: TListChartSource;
    Panel6: TPanel;
    Panel7: TPanel;
    ryodorakuSource: TListChartSource;
    memoConsole: TMemo;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    pageRight: TPageControl;
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
    treeviewSelector: TTreeView;
    procedure btnDeleteAllClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnVegatestDeleteClick(Sender: TObject);
    procedure btnVegatestNewClick(Sender: TObject);
    procedure btnVegatestNewGroupClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnVegatestSaveClick(Sender: TObject);
    procedure cboxSeriesChange(Sender: TObject);
    procedure ChartComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridRyodorakuSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure serialRxData(Sender: TObject);
    procedure serialStatus(Sender: TObject; Reason: THookSerialReason;
    const Value: string);
    procedure tabEAVShow(Sender: TObject);

    procedure tabRyodorakuShow(Sender: TObject);
    procedure tabVegatestShow(Sender: TObject);
    procedure treeviewSelectorSelectionChanged(Sender: TObject);

  private
    const  MAX_SERIES_NUMBER =30;
           RYODORAKU_NORMAL_MIN = 75;
           RYODORAKU_NORMAL_MAX = 100;
           RYODORAKU_FACTOR = 1.54;
           MINIVOLL_READ_VALUE_PERIOD = 0.05; //seconds

    var
     FCurrentPointName : string;
     FRyodorakuChart : integer;
     step : Cardinal;
     mySeries : TLineSeries;
     seriesArray : array[1..MAX_SERIES_NUMBER] of TLineSeries; //No dynamic array of all used series

  public
     ryodorakuPoint : array[0..23] of Double;

  end;

var
  frmMain: TfrmMain;

implementation
uses Unit2;

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
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
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
begin

  serial.ShowSetupDialog;
  serial.Open;
  if serial.Active then  statusBar.SimpleText:='Serial port: '+ serial.Device+' is open.';

  step:=0;
end;

procedure TfrmMain.btnSaveAsClick(Sender: TObject);
var s : string;
    i,j : integer;
    d : Double;
    chartIndex: integer;
begin
  chartIndex:=-1;

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
        chartIndex := FRyodorakuChart;
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
    ryodorakuPoint[chartIndex]:= d;
    ryodorakuSource.SetYValue(chartIndex,d);

    //Calculate normal value  (+/- 15[uA])
    d:=0;
    j:=0;
    for i:= 0 to 23 do begin
         if ryodorakuPoint[i]>0 then begin
           d:=d+ryodorakuPoint[i];
           j:=j+1;
         end;
    end;

    //Set normal line on ryododraku chart
    if j>0 then begin
      d := round(d/j);
      ryodorakuNormalSource.SetYValue(0,d);
      ryodorakuNormalSource.SetYValue(1,d);
    end;

    //Set color of ryodoraku charts
    for i:= 0 to 23 do begin

        if ryodorakuPoint[i]< d-15 then begin

           ryodorakuSource.SetColor(chartIndex,$800000);  //navy

        end else if ryodorakuPoint[i]> d+15 then begin

            ryodorakuSource.SetColor(chartIndex,$0000FF);  //red

        end else begin

            ryodorakuSource.SetColor(chartIndex,$008000);  //green

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

procedure TfrmMain.ChartComboBox1Change(Sender: TObject);
begin

end;



procedure TfrmMain.FormCreate(Sender: TObject);
var i : integer;
begin

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
begin
  s:= ExtractFilePath(Application.ExeName)+'selector.txt';
  if FileExists(s)then
     treeviewSelector.LoadFromFile(s);
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



procedure TfrmMain.serialRxData(Sender: TObject);
var s: string;

begin
//Read data from serial port
  s:= serial.ReadData;

  memoConsole.Lines.Add(s);

  if (s= ':btn') and (step>0) then begin
    // Save series

    frmMain.btnSaveAs.SetFocus;
    frmMain.btnSaveAsClick (Sender);
    mySeries.Clear;
    mySeries.AddXY( 0,0 );
    step:=0;

  end else if (s=':start') then begin
    // Clear series

    mySeries.Clear;
    mySeries.AddXY( 0,0 );
    step:=0;

  end else if (s<>':btn') then begin
    // Add to existing series new point

    mySeries.AddXY( step * MINIVOLL_READ_VALUE_PERIOD ,StrToIntDef(s,0)/10.0  );
    step:=step+1;

  end;


end;

procedure TfrmMain.serialStatus(Sender: TObject; Reason: THookSerialReason;
  const Value: string);
begin
  statusBar.SimpleText:='Serial status: '+Value;
end;

procedure TfrmMain.tabEAVShow(Sender: TObject);
begin
  cbEAVOn.Checked:=frmMain.tabEAV.Visible;
end;


procedure TfrmMain.tabRyodorakuShow(Sender: TObject);
begin
  cbRyodorakuOn.Checked:=frmMain.tabRyodoraku.Visible;
end;


procedure TfrmMain.tabVegatestShow(Sender: TObject);
begin

  cbVegatestOn.Checked:=frmMain.tabVegatest.Visible;
  //Ssend to miniVOLL commmand: vegatest
  if (serial.Active) and (cbVegatestOn.Checked) then begin

    serial.WriteData('vegatest'#13#10);

  end;
end;

procedure TfrmMain.treeviewSelectorSelectionChanged(Sender: TObject);
begin
  FCurrentPointName:=treeviewSelector.Selected.Text;

end;


end.


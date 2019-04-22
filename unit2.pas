unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, TAGraph, TASources, TASeries, TALegendPanel;

type

  { TForm2 }

  TForm2 = class(TForm)
    Chart1: TChart;
    Chart1BarSeries1: TBarSeries;
    ChartLegendPanel1: TChartLegendPanel;
    ListChartSource1: TListChartSource;
    Panel1: TPanel;
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

end.


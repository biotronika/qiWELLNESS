unit bioReadings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TASeries;

const

     MODE_UNK =-1; //unknown
     MODE_EAP = 0;
     MODE_EAV = 1;
     MODE_VEG = 2;
     MODE_RYO = 3; //Ryodoraku
     MODE_ION = 4; //Ionophoreses & zapper




type TReadings = array of double;


TReadPoint = class
private

  function ReadCount : integer ;
  function ReadLastValue : double;

published

  property   Count      : integer read ReadCount;
  property   LastValue  : double  read ReadLastValue;

public

    PointName    : string;
    Side         : string;
    Readings     : TReadings;
    Interval     : Double;
    TimeStamp    : Double;

    EAVvalue    : Double;
    EAVIndicatorDrop: Double;
    Mode         : integer;
    //If you add new field remember develop methods: TReadPointsCollection.Add, TReadPoint.Clear etc

  function Add( value : Double ) : integer; overload;
  function Add( value : double; _TimeStamp : double ) : integer;  overload;
  function Add( value : double; var Series : TLineSeries ) : integer;  overload;
  function Add( cmd   : string; var Series : TLineSeries ) : integer;  overload;

  function Remove ( NumberOfReadings : integer = 1) : integer;
  procedure Clear (InitMode : integer = MODE_UNK);

  procedure ToSeries(var Series : TLineSeries );
  procedure AddLastPointToSeries(var Series : TLineSeries );

  constructor Create (InitMode : integer = MODE_UNK);
  destructor Destroy; override;
end;


type TReadPointsCollection = class

private

  function ReadCount : integer ;

published

  property   Count      : integer read ReadCount;

public

  ReadPoints : array of TReadPoint;

  function Add() : integer; overload;
  function Add( aMode : integer) : integer; overload;
  function Add( aReadPoint : TReadPoint) : integer; overload;

  function FindLastReadByName( aPointName : string ) : integer;

  constructor Create;
  destructor Destroy; override;
end;



var  CurrentReadPoint  : TReadPoint;
     CurrentReadPoints : TReadPointsCollection;


implementation

function TReadPointsCollection.ReadCount : integer;
begin

  result := Length( ReadPoints );

end;

function TReadPointsCollection.FindLastReadByName(aPointName : string) : integer;
var n : integer;
    s : string;
begin
  result := -1;
  s := trim(UpperCase( aPointName ));

  for n := (Count-1) downto 0 do
    if trim(UpperCase( ReadPoints[n].PointName )) = s then begin
       result := n;
       BREAK;
    end;

end;

function TReadPointsCollection.Add( aMode : integer) : integer; overload;
var n : integer;
begin

  n := Length(ReadPoints);
  SetLength(ReadPoints,n+1);

  ReadPoints[n] := TReadPoint.Create(aMode);

  result := n;

end;

function TReadPointsCollection.Add( aReadPoint : TReadPoint) : integer; overload;
var n,i : integer;
begin

  n := Self.Add( aReadPoint.Mode);

  Self.ReadPoints[n].PointName    := aReadPoint.PointName;
  Self.ReadPoints[n].Side         := aReadPoint.Side;
  Self.ReadPoints[n].Interval     := aReadPoint.Interval;
  Self.ReadPoints[n].TimeStamp    := aReadPoint.TimeStamp;
  Self.ReadPoints[n].EAVvalue     := aReadPoint.EAVvalue;
  Self.ReadPoints[n].EAVIndicatorDrop:= aReadPoint.EAVIndicatorDrop;

  SetLength( Self.ReadPoints[n].Readings, aReadPoint.Count );
  for i:= 0 to aReadPoint.Count-1 do begin
     Self.ReadPoints[n].Readings[i] := aReadPoint.Readings[i] ;
  end;

  result := n;

end;

function TReadPointsCollection.Add() : integer; overload;
begin

  result := Self.Add(MODE_UNK);

end;

destructor TReadPointsCollection.Destroy;
begin
  SetLength(ReadPoints,0);
  inherited;
end;

constructor TReadPointsCollection.Create;
begin
  SetLength(ReadPoints,0);
end;

//////////////////////////////////////////////////////////////////
/////////////////////   TReadPoint   /////////////////////////////
//////////////////////////////////////////////////////////////////

destructor TReadPoint.Destroy;
begin
  SetLength(Readings,0);
  inherited;
end;

constructor TReadPoint.Create (InitMode : integer = MODE_UNK) ;
begin
  Clear (InitMode);
end;

function TReadPoint.ReadCount : integer;
begin
  result := Length(Readings);
end;

function TReadPoint.ReadLastValue() : double;
var i : integer;
begin
  i := Self.Count -1;
  if i >= 0 then
     result := Readings[i]
  else
    result := 0;
end;

procedure TReadPoint.Clear(InitMode : integer = MODE_UNK);
begin
  SetLength(Readings,0);

       PointName    := '';
       Side         := '';
       Interval     := 0;
       TimeStamp    := 0;
       EAVvalue    := 0;
       EAVIndicatorDrop:= 0;
       Mode         := InitMode;
end;


function TReadPoint.Add (  value : double) : integer;  overload;
var i : integer;
begin

  result := Add(value, Now());

end;

function TReadPoint.Add (  value : double; var Series : TLineSeries ) : integer;  overload;
var i : integer;
begin

  result := Add(value, Now());
  AddLastPointToSeries(Series);

end;

function TReadPoint.Add( value : double; _TimeStamp : double ) : integer; overload;
var i : integer;
begin

  i := Length( Readings ) + 1;
  SetLength( Readings, i );
  Readings[i-1] := value;
  result := i;

  if value > EAVvalue then EAVvalue := value;

  if i = 1 then
     TimeStamp := _TimeStamp
  else
     Interval := 24 * 60 * 60 * ( _TimeStamp - TimeStamp ) / (i-1); //seconds


end;

function  TReadPoint.Add( cmd   : string; var Series : TLineSeries ) : integer;  overload;
var s : string;
begin

  result := -1;  //error

  if copy(cmd,1,2) = ':e' then begin

    //Mode   := MODE_EAV;
    result := Add( StrToIntDef(copy(cmd,3,Length(cmd)),0)/10.0, Series);

  end else if copy(cmd,1,2) = ':v' then begin

    Mode   := MODE_VEG;
    result := Add( StrToIntDef( copy(cmd,3,Length(cmd)), 0 )  / 10.0, Series );

  end;

end;

function TReadPoint.Remove ( NumberOfReadings : integer = 1) : integer;
var i : integer;
begin

    i := Length(Readings) - NumberOfReadings;
    if i < 0 then i := 0;
    SetLength( Readings, i );
    result := i;

end;

procedure TReadPoint.ToSeries(var Series : TLineSeries );
var i : integer;
begin
    Series.Clear;
    for i:=0 to Length(Readings)-1 do begin
        Series.AddxY(Interval * i, Readings[i]);
    end;

end;

procedure TReadPoint.AddLastPointToSeries(var Series : TLineSeries );
begin

  if Count > 0 then
     Series.AddxY( Interval * (Count - 1), LastValue);

end;



end.


unit UScale;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Controls, math,Dialogs, Graphics;
type
  TDoublePoint = record
    x, y: Double;
  end;

  TDoubleRect = record
    Top, Bottom: TDoublePoint;
  end;

  RBrushStyle = record
    Style: TBrushStyle;
    Index: integer;
  end;

  RPenStyle = record
    Style: TPenStyle;
    Index: integer;
  end;

  TScale = class
  end;

  function DoublePoint(AX, AY: double): TDoublePoint;
  function DoubleRect(DPA, DPB: TDoublePoint):TDoubleRect;
  function Canvas2Wrld(APoint: TPoint): TDoublePoint;
  function Wrld2Canvas(ADoublePoint:TDoublePoint):TPoint;
  procedure SetScale(AZoom: Double);
const
  ZOOM_MIN = 0.01;
  ZOOM_MAX = 15.00;
var
  Offset:TPoint;
  Zoom: double;
  LastZoom: double;
  PenColor: TColor;
  BrushColor: Tcolor;
  BrushStyle: RBrushStyle;
  PenStyle: RPenStyle;
  PenWidthInt: integer;

  RoundX: integer;
  RoundY: integer;


implementation

  function DoublePoint(AX, AY: double): TDoublePoint;
  begin
    Result.x:=AX;
    Result.y:=AY;
  end;

  function DoubleRect(DPA, DPB: TDoublePoint):TDoubleRect;
  begin
    Result.Top :=  DPA;
    Result.Bottom:=DPB;
  end;

  function Canvas2Wrld(APoint: TPoint): TDoublePoint;
  begin
    Result.x:= APoint.x / Zoom - Offset.x;
    Result.y:= APoint.y / Zoom - Offset.y;
  end;

  function Wrld2Canvas(ADoublePoint: TDoublePoint): TPoint;
  begin
    Result.x:= round((ADoublePoint.x + Offset.x) * Zoom);
    Result.y:= round((ADoublePoint.y + Offset.y) * Zoom);
  end;

  procedure SetScale(AZoom:double);
  begin
    if AZoom <= ZOOM_MIN then
      Zoom:= ZOOM_MIN
    else if AZoom >= ZOOM_MAX then
      Zoom:= ZOOM_MAX
    else
      Zoom:= AZoom;
  end;

  initialization

end.


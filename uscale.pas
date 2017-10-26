unit UScale;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Controls, math,Dialogs;
type
  TDoublePoint = record
    x, y: Double;
  end;

  function DoublePoint(AX, AY: double): TDoublePoint;

  function Canvas2Wrld(APoint: TPoint): TDoublePoint;
  //function Wrld2Canvas(AX, AY: double): TPoint;
  function Wrld2Canvas(ADoublePoint:TDoublePoint):TPoint;
  procedure SetScale(AZoom: Double);
  procedure SetOffset(ADoublePoint: TDoublePoint);
  procedure SetMinMaxDoublePoints(ADoublePoint:TDoublePoint);
const
  ZOOM_MIN = 0.01;
  ZOOM_MAX = 15.00;
var
  Offset:TDoublePoint;
  Zoom: double;
  MaxPoint, MinPoint:TDoublePoint;
implementation
  function DoublePoint(AX, AY: double): TDoublePoint;
  begin
    Result.x:=AX;
    Result.y:=AY;
  end;

  function Canvas2Wrld(APoint: TPoint): TDoublePoint;
  begin
    Result.x:= APoint.x / Zoom + Offset.x;
    Result.y:= APoint.y / Zoom + Offset.y;
  end;

  {function Wrld2Canvas(ADoublePoint: TDoublePoint): TPoint;
  begin
    Result:= Wrld2Canvas(ADoublePoint);
  end;}

  function Wrld2Canvas(ADoublePoint: TDoublePoint): TPoint;
  begin
    Result.x:= round((ADoublePoint.x - Offset.x) * Zoom);
    Result.y:= round((ADoublePoint.y - Offset.y) * Zoom);
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

  procedure SetMinMaxDoublePoints(ADoublePoint:TDoublePoint);
  begin
    if(ADoublePoint.x > MaxPoint.x) then
      MaxPoint.x:=ADoublePoint.x;
    if(ADoublePoint.x < MinPoint.x) then
      MinPoint.x:=ADoublePoint.x;
    if(ADoublePoint.y > MaxPoint.y) then
      MaxPoint.y:=ADoublePoint.y;
    if(ADoublePoint.y < MinPoint.y) then
      MinPoint.y:=ADoublePoint.y;
  end;

  procedure SetOffset(ADoublePoint: TDoublePoint);
  begin
    Offset:= ADoublePoint;
  end;

  initialization
  Zoom:= 1.0;
  Offset:= DoublePoint(0,0);
end.


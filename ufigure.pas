unit UFigure;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics,Dialogs,UScale, Math;

type
  TFigure = class
  public
    PColor: TColor;
    BColor: TColor;
    BStyle: TBrushStyle;
    PStyle: TPenStyle;
    RoundedX: integer;
    RoundedY: integer;
    PWhidth: integer;
    MinPoint,MaxPoint:TDoublePoint;
    DPoints:Array of TDoublePoint;
    procedure Draw(ACanvas:TCanvas);virtual;
    constructor Create;virtual;
  end;

  TFigureClass = class of TFigure;

  TPolyLine = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
 end;

  TRectangle = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
  end;

  TEllipse = class(TFIgure)
    procedure Draw(ACanvas:TCanvas); override;
  end;

  TRoundRect = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
  end;

var
  Figures: Array of TFigure;
  REDOFigures: Array of TFigure;
  AFirstPoint:TPoint;


implementation

procedure TFigure.Draw(ACanvas: TCanvas);
begin
  ACanvas.Pen.Color:=PColor;
  ACanvas.Brush.Color:=BColor;
  ACanvas.Pen.Width:=PWhidth;
  ACanvas.Brush.Style:=BStyle;
  ACanvas.Pen.Style:=PStyle;
end;

constructor TFigure.Create;
begin
  RoundedX:=RoundX;
  RoundedY:=RoundY;
  PColor:=PenColor;
  BColor:=BrushColor;
  BStyle:=BrushStyle.Style;
  PStyle:=PenStyle.Style;
  PWhidth:=PenWidthInt;
end;

procedure TPolyLine.Draw(ACanvas:TCanvas);
var
  i:integer;
begin
  inherited Draw(ACanvas);
  for i := 1 to High(DPoints) do
    ACanvas.Line(Wrld2Canvas(DPoints[i-1]), Wrld2Canvas(DPoints[i]));

  for i:=Low(DPoints) to high(DPoints) do begin
    MinPoint.x:=min(round(minPoint.x),round(DPoints[i].x));
    MinPoint.y:=min(round(minPoint.y),round(DPoints[i].y));
    MaxPoint.x:=max(round(maxPoint.x),round(DPoints[i].x));
    MaxPoint.y:=max(round(maxPoint.y),round(DPoints[i].y));
  end;
end;


procedure TRectangle.Draw(ACanvas:TCanvas);
begin
  inherited Draw(ACanvas);
  ACanvas.Rectangle((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[HIgh(DPoints)])).y);

    if DPoints[1].x > DPoints[0].x then  begin
      MaxPoint.x:=DPoints[1].x;
      MinPoint.x:=DPoints[0].x;
    end
    else begin
      MaxPoint.x:=DPoints[0].x;
      MinPoint.x:=DPoints[1].x;
    end;

    if DPoints[1].y > DPoints[0].y then  begin
      MaxPoint.y:=DPoints[1].y;
      MinPoint.y:=DPoints[0].y;
    end
    else begin
      MaxPoint.y:=DPoints[0].y;
      MinPoint.y:=DPoints[1].y;
    end;
end;

procedure TRoundRect.Draw(ACanvas:TCanvas);
begin
  inherited Draw(ACanvas);
  ACanvas.RoundRect((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[HIgh(DPoints)])).y,RoundedX,RoundedY);

    if DPoints[1].x > DPoints[0].x then  begin
      MaxPoint.x:=DPoints[1].x;
      MinPoint.x:=DPoints[0].x;
    end
    else begin
      MaxPoint.x:=DPoints[0].x;
      MinPoint.x:=DPoints[1].x;
    end;

    if DPoints[1].y > DPoints[0].y then  begin
      MaxPoint.y:=DPoints[1].y;
      MinPoint.y:=DPoints[0].y;
    end
    else begin
      MaxPoint.y:=DPoints[0].y;
      MinPoint.y:=DPoints[1].y;
    end;
end;

procedure TEllipse.Draw(ACanvas:TCanvas);
begin
  inherited Draw(ACanvas);
  ACanvas.Ellipse((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[HIgh(DPoints)])).y);

  if DPoints[1].x > DPoints[0].x then  begin
      MaxPoint.x:=DPoints[1].x;
      MinPoint.x:=DPoints[0].x;
    end
    else begin
      MaxPoint.x:=DPoints[0].x;
      MinPoint.x:=DPoints[1].x;
    end;

    if DPoints[1].y > DPoints[0].y then  begin
      MaxPoint.y:=DPoints[1].y;
      MinPoint.y:=DPoints[0].y;
    end
    else begin
      MaxPoint.y:=DPoints[0].y;
      MinPoint.y:=DPoints[1].y;
    end;
end;


end.


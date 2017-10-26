unit UFigure;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics,Dialogs,UScale;

type
  TFigure = class
    Points:Array of TPoint;
    DPoints:Array of TDoublePoint;
    procedure Draw(ACanvas:TCanvas);virtual;abstract;
    procedure AddPoint(ADoublePoint:TDoublePoint);

  end;
  TFigureClass = class of TFigure;
  TLines = class(TFigure)
    PenWidth:Integer;
    PenColor:TColor;

  end;

  TFigures = class(TLines)
    PenBrushColor:TColor;
  end;

  THand = class(TFigure)

  end;

  TPolyLine = class(TLines)
    procedure Draw(ACanvas:TCanvas); override;

  end;

  TLine = class(TLines)
    procedure Draw(ACanvas:TCanvas); override;

  end;

  TRectangle = class(TFigures)
    procedure Draw(ACanvas:TCanvas); override;

  end;

  TEllipse = class(TFIgures)
   procedure Draw(ACanvas:TCanvas); override;

  end;

var
  Figures: Array of TFigure;
  REDOFigures: Array of TFigure;
implementation

procedure TFigure.AddPoint(ADoublePoint : TDoublePoint);
begin
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High(DPoints)]:=ADoublePoint;
  SetMinMaxDoublePoints(ADoublePoint);
end;



procedure TPolyLine.Draw(ACanvas:TCanvas);
var
  i:integer;
begin
  PenColor:=clBlack;
  PenWidth:=6;
  ACanvas.Pen.Color:=PenColor;
  ACanvas.Pen.Width:=PenWidth;
  for i := 1 to High(DPoints) do
    ACanvas.Line(Wrld2Canvas(DPoints[i-1]), Wrld2Canvas(DPoints[i]));
end;

procedure TLine.Draw(ACanvas:TCanvas);

begin
  PenColor:=clBlack;
  PenWidth:=6;
  ACanvas.Pen.Color:=PenColor;
  ACanvas.Pen.Width:=PenWidth;
  ACanvas.Line(Wrld2Canvas(DPoints[0]), Wrld2Canvas(DPoints[High(DPoints)]));
end;

procedure TRectangle.Draw(ACanvas:TCanvas);
begin
  PenColor:=clBlack;
  PenWidth:=6;
  ACanvas.Brush.Style:=bsClear;
  ACanvas.Pen.Color:=PenColor;
  ACanvas.Pen.Width:=PenWidth;
  ACanvas.Rectangle((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[HIgh(DPoints)])).y);
end;

procedure TEllipse.Draw(ACanvas:TCanvas);
begin
  PenColor:=clBlack;
  PenWidth:=6;
  PenBrushColor:=clGreen;
  ACanvas.Brush.Style:=bsClear;
  ACanvas.Pen.Color:=PenColor;
  ACanvas.Pen.Width:=PenWidth;
  ACanvas.Ellipse((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[HIgh(DPoints)])).y);
end;



end.


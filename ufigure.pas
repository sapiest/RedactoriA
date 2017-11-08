unit UFigure;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics,Dialogs,UScale, Math;

type
  TFigure = class
  public
    minPoint,maxPoint:TDoublePoint;
    DPoints:Array of TDoublePoint;
    procedure Draw(ACanvas:TCanvas);virtual;abstract;
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

  TRectangleMagnifier = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
  end;

var
  Figures: Array of TFigure;
  REDOFigures: Array of TFigure;
  AFirstPoint:TPoint;

implementation

procedure TPolyLine.Draw(ACanvas:TCanvas);
var
  i:integer;
begin
  for i := 1 to High(DPoints) do
    ACanvas.Line(Wrld2Canvas(DPoints[i-1]), Wrld2Canvas(DPoints[i]));

  for i:=Low(DPoints) to high(DPoints) do begin
    minPoint.x:=min(round(minPoint.x),round(DPoints[i].x));
    minPoint.y:=min(round(minPoint.y),round(DPoints[i].y));
    maxPoint.x:=max(round(maxPoint.x),round(DPoints[i].x));
    maxPoint.y:=max(round(maxPoint.y),round(DPoints[i].y));
  end;
end;


procedure TRectangle.Draw(ACanvas:TCanvas);
begin
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

procedure TEllipse.Draw(ACanvas:TCanvas);
begin
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

procedure TRectangleMagnifier.Draw(ACanvas:TCanvas);
begin
  ACanvas.Frame((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[HIgh(DPoints)])).y);
end;

end.


unit UFigure;

{$mode objfpc}{$H+}

interface

uses
<<<<<<< HEAD
  Classes, SysUtils,Graphics,Dialogs,UScale, Math,ExtCtrls, UParams ;

type


=======
  Classes, SysUtils,Graphics,Dialogs,UScale, Math;

type
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
  TFigure = class
  public
    PColor: TColor;
    BColor: TColor;
    BStyle: TBrushStyle;
    PStyle: TPenStyle;
    RoundedX: integer;
    RoundedY: integer;
    PWhidth: integer;
<<<<<<< HEAD

=======
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    MinPoint,MaxPoint:TDoublePoint;
    DPoints:Array of TDoublePoint;
    procedure Draw(ACanvas:TCanvas);virtual;
    constructor Create;virtual;
<<<<<<< HEAD
  protected
    AWidthInt: integer;
    APenStyle: TPenStyle;
    APenColor: TColor;
=======
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
  end;

  TFigureClass = class of TFigure;

<<<<<<< HEAD
  TLine = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
 end;

  TFillFigures = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
  strict protected
    ABrushStyle: TBrushStyle;
    ABrushColor: TColor;
  end;

  TRectangle = class(TFillFigures)
    procedure Draw(ACanvas:TCanvas); override;
  end;

  TEllipse = class(TFillFigures)
    procedure Draw(ACanvas:TCanvas); override;
  end;

  TRoundRect = class(TFillFigures)
    procedure Draw(ACanvas:TCanvas); override;
  strict protected
    ARadius: integer;
=======
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
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
  end;

var
  Figures: Array of TFigure;
  REDOFigures: Array of TFigure;
  AFirstPoint:TPoint;
<<<<<<< HEAD
  AParam:TParam;
=======

>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2

implementation

procedure TFigure.Draw(ACanvas: TCanvas);
begin
  ACanvas.Pen.Color:=PColor;
<<<<<<< HEAD
  ACanvas.Pen.Style:=PStyle;
  ACanvas.Pen.Width:=PWhidth;
end;

procedure TFillFigures.Draw(ACanvas: TCanvas);
begin
  inherited;
  ACanvas.Brush.Style:=BStyle;
  ACanvas.Brush.Color:=BColor;
=======
  ACanvas.Brush.Color:=BColor;
  ACanvas.Pen.Width:=PWhidth;
  ACanvas.Brush.Style:=BStyle;
  ACanvas.Pen.Style:=PStyle;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
end;

constructor TFigure.Create;
begin
<<<<<<< HEAD
  PColor:=PenColor;
  PStyle:=PenStyle.Style;
  PWhidth:=PenWidthInt;
  RoundedX:=RoundX;
  RoundedY:=RoundY;
  BColor:=BrushColor;
  BStyle:=BrushStyle.Style;
end;

procedure TLine.Draw(ACanvas:TCanvas);
var
  i:integer;
begin
  inherited;
=======
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
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
  for i := 1 to High(DPoints) do
    ACanvas.Line(Wrld2Canvas(DPoints[i-1]), Wrld2Canvas(DPoints[i]));

  for i:=Low(DPoints) to high(DPoints) do begin
    MinPoint.x:=min(round(minPoint.x),round(DPoints[i].x));
    MinPoint.y:=min(round(minPoint.y),round(DPoints[i].y));
    MaxPoint.x:=max(round(maxPoint.x),round(DPoints[i].x));
    MaxPoint.y:=max(round(maxPoint.y),round(DPoints[i].y));
  end;
end;

<<<<<<< HEAD
procedure TRectangle.Draw(ACanvas:TCanvas);
begin
  inherited;
=======

procedure TRectangle.Draw(ACanvas:TCanvas);
begin
  inherited Draw(ACanvas);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
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
<<<<<<< HEAD
  inherited;
=======
  inherited Draw(ACanvas);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
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
<<<<<<< HEAD
  inherited;
=======
  inherited Draw(ACanvas);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
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

<<<<<<< HEAD
=======

>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
end.


unit UFigure;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics,Dialogs,UScale,ExtCtrls, Math,fpjson, superobject, Clipbrd, StdCtrls;

type
  URList = record
    Data:TStringList;
    Head,Tail,Current:integer;
  end;

  TFigure = class
  public
    PColor: TColor;
    BColor: TColor;
    BStyle: TBrushStyle;
    PStyle: TPenStyle;
    RoundedX: integer;
    RoundedY: integer;
    PWidth: integer;
    PStyleInd:integer;
    BStyleInd:integer;
    Selected: boolean;
    LTop,RBottom:TDoublePoint;
    MinPoint,MaxPoint:TDoublePoint;
    DPoints:Array of TDoublePoint;
    procedure Draw(ACanvas:TCanvas);virtual;
    procedure CheckPtIn(APoint:TPoint);virtual;
    procedure CheckRect(FirstPoint, LastPoint:TPoint);virtual;
    function CheckPen(CoordA,CoordB,APoint:TPoint):boolean;
    function CheckLine(CoordA,CoordB,APoint:TPoint):boolean;
    function CheckRectangle(TL, BR, APoint: TPoint): boolean;
    function CheckEllipse(TL, BR, APoint: TPoint): boolean;
    procedure DrawOutline(Point1,Point2: TDoublePoint; Canvas: TCanvas); virtual;
    procedure GetParams(GTFigure:TFigure;GPColor:TColor;GPStyle:TPenStyle;GPWidth:integer;GRoundedX:integer;GRoundedY:integer;GBColor:TColor;GBStyle:TBrushStyle);
    procedure FindCorners(var TL, BR: TPoint);
    procedure DrawAnchors(ACanvas:TCanvas);
    constructor Create;virtual;
  end;

  TFigureClass = class of TFigure;

  TPenLine = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
    procedure CheckPtIn(APoint:TPoint);override;
  end;

  TLine = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
    procedure CheckPtIn(APoint:TPoint); override;
 end;

  TFillFigures = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
  strict protected
    ABrushStyle: TBrushStyle;
    ABrushColor: TColor;
  end;

  TRectangle = class(TFillFigures)
    PRectWidth: integer;
    procedure Draw(ACanvas:TCanvas); override;
    procedure CheckPtIn(APoint:TPoint); override;
  end;

  TEllipse = class(TFillFigures)
    procedure Draw(ACanvas:TCanvas); override;
    procedure CheckPtIn(APoint:TPoint); override;
  end;

  TRoundRect = class(TFillFigures)
    procedure Draw(ACanvas:TCanvas); override;
    procedure CheckPtIn(APoint:TPoint);override;
  strict protected
    ARadius: integer;
  end;

  TSelect = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
  end;

  TText = class(TFigure)
    procedure Draw(ACanvas:TCanvas); override;
  end;

  function Push(var List:URList;S:String):integer;
  function Undo(var List:URList):string;
  function Redo(var List:URList):string;
  function isEmpty(List:URList):boolean;
  function SaveFile:string;
  procedure SaveFigure(iFigure:TFigure;jObject:TJSONObject);
const
  MAXUNDOREDO = 20;
var
  Figures: Array of TFigure;
  UndoRedoL:URList;

implementation

procedure SaveFigure(iFigure:TFigure;jObject:TJSONObject);
var
  jFigure:TJSONObject;
  j:integer;
begin
    jFigure:=TJSONObject.Create;
    with iFigure do begin
      jFigure.Add('name', ClassName);
      jFigure.Add('coord',TJSONArray.Create);
      for j := 0 to high(Dpoints) do begin
           jFigure.Arrays['coord'].Add(Dpoints[j].x);
           jFigure.Arrays['coord'].Add(Dpoints[j].y);
      end;
      jFigure.Add('PenColor', PColor);
      jFigure.Add('PenStyleInd', PStyleInd);
      jFigure.Add('PenWidth',PWidth);
      jFigure.Add('BrushColor', BColor);
      jFigure.Add('BrushStyleInd', BStyleInd);
      jFigure.Add('RoundedX',RoundedX);
      jFigure.Add('RoundedY',RoundedY);
  end;
  jObject.Arrays['TFigures'].Add(jFigure);
end;

function SaveFile:String;
var
  i:integer;
  jObject: TJSONObject;
begin
  jObject := TJSONObject.Create;
  jObject.Add('TFigures', TJSONArray.Create);
  for i:= 0 to High(Figures) do
  begin
    SaveFigure(Figures[i],jObject);
  end;
  Result:=jObject.FormatJSON;
end;

function isEmpty(List:URList):boolean;
begin
  Result:=List.Data.Count=0;
end;

function Push(var List:URList;S:String):integer;
begin
  if List.Data.Count <= MAXUNDOREDO then begin
    List.Tail:=List.Data.Add(S);
  end
  else begin
    List.Head:=0;
    List.Data.Delete(List.Head);
    List.Tail:=List.Data.Add(S);
  end;
  list.Current:=List.Tail;
  Result:=List.Tail;
end;

function Redo(var List:URList):string;
var
  index:integer;
begin
  if (List.Current >= 0) and (List.Current < List.Tail) then begin
    index:=List.Current+1;
    List.Current:=index;
    Result:=List.Data[index];
  end
  else
    result:=List.Data[List.Current];
end;

function Undo(var List:URList):string;
var
  index:integer;
begin
  if (List.Current > 0)  then begin
    index:=List.Current-1;
    List.Current:=index;
    Result:=List.Data[index];
  end
  else
    result:=List.Data[List.Current];
end;

procedure TFigure.DrawOutline(Point1,Point2: TDoublePoint; Canvas: TCanvas);
var
  a:TDoublepoint;
begin
  if (Point1.X>Point2.X) then
    begin
      a.X:=Point1.X;
      Point1.X:=Point2.X;
      Point2.X:=a.X;
    end;
  if (Point1.Y>Point2.Y) then
    begin
      a.Y:=Point1.Y;
      Point1.Y:=Point2.Y;
      Point2.Y:=a.Y;
    end;
  Canvas.Pen.Color := clGray;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Style := psDash;
  Canvas.Frame (Wrld2Canvas(Point1).x-5-PWidth div 2,Wrld2Canvas(Point1).y-5-PWidth div 2,
      Wrld2Canvas(Point2).x+5+PWidth div 2,Wrld2Canvas(Point2).y+5+PWidth div 2);
  Canvas.Pen.Color := clPurple;
  Canvas.Pen.Width :=2;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style:=bsSolid;
  Canvas.Brush.Color:=Canvas.Pen.Color;
  if Selected then
    DrawAnchors(Canvas);
end;

procedure TFigure.DrawAnchors(ACanvas:TCanvas);
const
  k=5;
var
  i: integer;
begin
  for i := 0 to high(DPoints) do begin
      ACanvas.Rectangle(Rect(Wrld2Canvas(DPoints[i]).x-k-PWidth div 2,Wrld2Canvas(DPoints[i]).y-k-PWidth div 2,Wrld2Canvas(DPoints[i]).x+k+PWidth div 2,Wrld2Canvas(DPoints[i]).y+k+PWidth div 2));
  end;
end;

procedure TFigure.Draw(ACanvas: TCanvas);
begin
  ACanvas.Pen.Color:=PColor;
  ACanvas.Pen.Style:=PStyle;
  ACanvas.Pen.Width:=PWidth;
end;

procedure TFillFigures.Draw(ACanvas: TCanvas);
begin
  inherited;
  ACanvas.Brush.Style:=BStyle;
  ACanvas.Brush.Color:=BColor;
end;

constructor TFigure.Create;
begin
  PColor:=PenColor;
  PStyle:=PenStyle.Style;
  PStyleInd:=PenStyle.Index;
  PWidth:=PenWidthInt;
  RoundedX:=RoundX;
  RoundedY:=RoundY;
  BColor:=BrushColor;
  BStyle:=BrushStyle.Style;
  BStyleInd:=BrushStyle.Index;
end;

procedure TText.Draw(ACanvas:TCanvas);
begin
  inherited;
end;

function TFigure.CheckPen(CoordA,CoordB,APoint:TPoint):boolean;
var
  a, b: TPoint;
  i: integer;
const
  Margin=4;
begin
  a:=CoordA;
  b:=CoordB;
  if(((-Margin - PWidth div 2 + A.x <= APoint.x) and
     (Margin + PWidth div 2 + B.x >= APoint.x)) or
    ((Margin + PWidth  div 2 + A.x >= APoint.x) and
     (-Margin - PWidth  div 2 + B.x <= APoint.x))) and
   (((-Margin - PWidth  div 2 + A.y <= APoint.y) and
     (Margin + PWidth  div 2 + B.y >= APoint.y)) or
    ((Margin + PWidth  div 2 + A.y >= APoint.y) and
     (-Margin - PWidth  div 2 + B.y <= APoint.y)))then
          Result := true

end;

function TFigure.CheckLine(CoordA,CoordB,APoint:TPoint):boolean;
const
  Indent=4;
var
  kx,ky: double;
begin
  if ((sqr(CoordB.x-CoordA.x)+sqr(CoordB.y-CoordA.y)) <> 0) then begin
    kx:=((CoordB.y-CoordA.y) * (Indent + (PWidth div 2)))/sqrt(sqr(CoordB.x-CoordA.x)+sqr(CoordB.y-CoordA.y));
    ky:=((CoordB.x-CoordA.x)*(Indent+(PWidth div 2)))/sqrt(sqr(CoordB.x-CoordA.x)+sqr(CoordB.y-CoordA.y));
    if ((((((((APoint.y-(CoordA.y-ky))*((CoordB.x+kx)-(CoordA.x+kx)))-((Apoint.x-(CoordA.x+kx))*((CoordB.y-ky)-(CoordA.y-ky))))<=0) and ((((APoint.y-(CoordA.y+ky))*((CoordB.x-kx)-(CoordA.x-kx)))-((Apoint.x-(CoordA.x-kx))*((CoordB.y+ky)-(CoordA.y+ky))))>=0)) or
    (((((Apoint.y-(CoordA.y-ky))*((CoordB.x+kx)-(CoordA.x+kx)))-((Apoint.x-(CoordA.x+kx))*((CoordB.y-ky)-(CoordA.y-ky))))>=0) and ((((Apoint.y-(CoordA.y+ky))*((CoordB.x-kx)-(CoordA.x-kx)))-((Apoint.x-(CoordA.x-kx))*((CoordB.y+ky)-(CoordA.y+ky))))<=0))) and
    ((((CoordA.x-abs(kx) <= Apoint.x) and (Apoint.x <= CoordB.x+abs(kx))) or ((CoordB.x-abs(kx) <= Apoint.x) and (Apoint.x <= CoordA.x+abs(kx)))) and
    (((CoordA.y-abs(ky) <= Apoint.y) and (Apoint.y <= CoordB.y+abs(ky))) or ((CoordB.y-abs(ky) <= Apoint.y) and (Apoint.y <= CoordA.y+abs(ky)))))) or
    CheckEllipse(Point(CoordA.x-(Indent+(PWidth div 2)), CoordA.y-(Indent+(PWidth div 2))), Point(CoordA.x+(Indent+(PWidth div 2)), CoordA.y+(Indent+(PWidth div 2))), Apoint) or
    CheckEllipse(Point(CoordB.x-(Indent+(PWidth div 2)), CoordB.y-(Indent+(PWidth div 2))), Point(CoordB.x+(Indent+(PWidth div 2)), CoordB.y+(Indent+(PWidth div 2))), Apoint)) then
      Result:=true;
  end
  else
    Result:=false;
end;

function TFigure.CheckRectangle(TL, BR, APoint: TPoint): boolean;
var
  a, b: TPoint;
begin
  a:=Point(TL.x, TL.y);
  b:=Point(BR.x, BR.y);;
  if (CheckEllipse(Point(a.x-(PWidth div 2), a.y+(RoundY div 2)), Point(b.x+(PWidth div 2), b.y-(RoundY div 2)), APoint)) or
    (CheckEllipse(Point(a.x+(RoundX div 2), a.y-(PWidth div 2)), Point(b.x-(RoundX div 2), b.y+(PWidth div 2)), APoint)) or
    (CheckEllipse(Point(a.x-(PWidth div 2), a.y-(PWidth div 2)), Point(a.x+2*(RoundX div 2)+(PWidth div 2), a.y+2*(RoundY div 2)+(PWidth div 2)), APoint)) or
    (CheckEllipse(Point(b.x-2*(RoundX div 2)-(PWidth div 2), b.y-2*(RoundY div 2)-(PWidth div 2)),Point(b.x+(PWidth div 2), b.y+(PWidth div 2)), APoint)) or
    (CheckEllipse(Point(b.x-2*(RoundX div 2)-(PWidth div 2), a.y-(PWidth div 2)), Point(b.x+(PWidth div 2), a.y+(PWidth div 2)+2*(RoundY div 2)), APoint)) or
    (CheckEllipse(Point(a.x-(PWidth div 2), b.y-(PWidth div 2)-2*(RoundY div 2)), Point(a.x+(PWidth div 2)+2*(RoundX div 2), b.y+(PWidth div 2)), APoint)) then begin
    result:=true;
  end else
    result:=false;
end;

function TFigure.CheckEllipse(TL, BR, APoint: TPoint): boolean;
var
  a, b: double;
begin
  a:=(Br.x-TL.x)/2;
  b:=(BR.y-TL.y)/2;
  if (a <> 0) and (b <>0) then begin
    if ((((sqr(APoint.x-TL.x-a)/(a*a))+(sqr(APoint.y-TL.y-b)/(b*b))))<=1) then
      result:=true
    else
     result:=false;
  end else
    result:=false;

end;

procedure TFigure.FindCorners(var TL, BR: TPoint);
begin
  TL.x := Min(Wrld2Canvas(DPoints[0]).x, Wrld2Canvas(DPoints[1]).x);
  TL.y := Min(Wrld2Canvas(DPoints[0]).y, Wrld2Canvas(DPoints[1]).y);
  BR.x := Max(Wrld2Canvas(DPoints[0]).x, Wrld2Canvas(DPoints[1]).x);
  BR.y := Max(Wrld2Canvas(DPoints[0]).y, Wrld2Canvas(DPoints[1]).y);
end;

procedure TLine.Draw(ACanvas:TCanvas);
var
  i:integer;
begin
  inherited;
    ACanvas.Line(Wrld2Canvas(DPoints[0]), Wrld2Canvas(DPoints[1]));

  if Selected then begin
    LTop:=DPoints[0];
    RBottom:=DPoints[1];
    DrawOutline(LTop,RBottom,ACanvas);
  end;
  for i:=Low(DPoints) to high(DPoints) do begin
    MinPoint.x:=min(round(minPoint.x),round(DPoints[i].x));
    MinPoint.y:=min(round(minPoint.y),round(DPoints[i].y));
    MaxPoint.x:=max(round(maxPoint.x),round(DPoints[i].x));
    MaxPoint.y:=max(round(maxPoint.y),round(DPoints[i].y));
  end;
end;

procedure TFigure.GetParams(GTFigure:TFigure;GPColor:TColor;GPStyle:TPenStyle;GPWidth:integer;GRoundedX:integer;GRoundedY:integer;GBColor:TColor;GBStyle:TBrushStyle);
begin
  GPColor:= GTFigure.PColor;
  GPStyle:=GTFigure.PStyle;
  GPWidth:=GTFigure.PWidth;
  GRoundedX:=GTFigure.RoundedX;
  GRoundedY:=GTFigure.RoundedY;
  GBColor:=GTFigure.BColor;
  GBStyle:=GTFigure.BStyle;
end;

procedure TPenLine.Draw(ACanvas:TCanvas);
var
  i:integer;
begin
  inherited;

  for i := 1 to High(DPoints) do begin
    ACanvas.Line(Wrld2Canvas(DPoints[i-1]), Wrld2Canvas(DPoints[i]));
  end;


    LTop.x:=Min(round(DPoints[0].x), round(Dpoints[1].x));
    LTop.y:=Min(round(DPoints[0].y), round(Dpoints[1].y));
    RBottom.x:=Max(round(DPoints[0].x), round(Dpoints[1].x));
    RBottom.y:=Max(round(DPoints[0].y), round(Dpoints[1].y));

  for i:=Low(DPoints) to high(DPoints) do begin
    MinPoint.x:=min(round(minPoint.x),round(DPoints[i].x));
    MinPoint.y:=min(round(minPoint.y),round(DPoints[i].y));
    MaxPoint.x:=max(round(maxPoint.x),round(DPoints[i].x));
    MaxPoint.y:=max(round(maxPoint.y),round(DPoints[i].y));

    LTop.x:=min(LTop.x,DPoints[i].x);
    LTop.y:=min(LTop.y,DPoints[i].y);
    RBottom.x:=max(RBottom.x,DPoints[i].x);
    RBottom.y:=max(RBottom.y,DPoints[i].y);
  end;
  if (Selected = true) then
    DrawOutline(RBottom,LTop,ACanvas);
end;

procedure TRectangle.Draw(ACanvas:TCanvas);
begin
  inherited;
  ACanvas.Rectangle((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[HIgh(DPoints)])).y);

   if (Selected = true) then begin
     LTop:=DPoints[0];
     RBottom:=DPoints[1];
     DrawOutline(LTop,RBottom,ACanvas);
   end;

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
  inherited;
  ACanvas.RoundRect((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[HIgh(DPoints)])).y,RoundedX,RoundedY);

  if (Selected = true) then begin
    LTop:=DPoints[0];
    RBottom:=DPoints[1];
    DrawOutline(LTop,RBottom,ACanvas);
  end;

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
  inherited;
  ACanvas.Ellipse((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[High(DPoints)])).y);

  if (Selected = true) then begin
    LTop:=DPoints[0];
    RBottom:=DPoints[1];
    DrawOutline(LTop,RBottom,ACanvas);
  end;
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

procedure TSelect.Draw(ACanvas:Tcanvas);
begin
  ACanvas.Pen.Style:=psDot;
  ACanvas.Pen.Color:=clBlack;
  ACanvas.Pen.Width:=1;
  ACanvas.Brush.Style:=bsClear;
  ACanvas.Rectangle((Wrld2Canvas(DPoints[Low(DPoints)])).x ,(Wrld2Canvas(DPoints[Low(DPoints)])).y,
  (Wrld2Canvas(DPoints[High(DPoints)])).x,(Wrld2Canvas(DPoints[High(DPoints)])).y);
end;

procedure TLine.CheckPtIn(APoint: TPoint);
begin
  if (CheckLine(Wrld2Canvas(DPoints[0]), Wrld2Canvas(DPoints[1]), APoint)) then
    Selected := not Selected;
end;

procedure TPenLine.CheckPtIn(APoint: TPoint);
var
  i: integer;
begin
  for i := 0 to high(DPoints) - 1 do
    if (CheckPen(Wrld2Canvas(DPoints[i]),Wrld2Canvas(DPoints[i+1]),APoint)) then begin
      Selected := not Selected;
    end;
end;

procedure TRectangle.CheckPtIn(APoint: TPoint);
var
  TL, BR: TPoint;
begin
  FindCorners(TL, BR);
  if (CheckRectangle(TL, BR, APoint)) then
    Selected := not Selected;
end;

procedure TEllipse.CheckPtIn(APoint: TPoint);
var
  TL, BR: TPoint;
begin
  FindCorners(TL, BR);
  if (CheckEllipse(Point(TL.x - PWidth div 2, TL.y - PWidth div 2), Point(BR.x + PWidth div 2, BR.y + PWidth div 2), APoint)) then
    Selected := not Selected;
end;

procedure TRoundRect.CheckPtIn(APoint: TPoint);
var
  TL, BR: TPoint;
begin
  FindCorners(TL, BR);
  if (CheckRectangle(TL, BR, APoint)) then
    Selected := not Selected;
end;

procedure TFigure.CheckRect(FirstPoint, LastPoint: TPoint);
var
  AreaTL, AreaBR, FigureTL, FigureBR: TPoint;
begin
  FindCorners(FigureTL, FigureBR);

  AreaTL.x := Min(FirstPoint.x, LastPoint.x);
  AreaTL.y := Min(FirstPoint.y, LastPoint.y);
  AreaBR.x := Max(FirstPoint.x, LastPoint.x);
  AreaBR.y := Max(FirstPoint.y, LastPoint.y);

  if (AreaTL.x <= FigureTL.x) and (FigureTL.x <= AreaBR.x) and
     (AreaTL.y <= FigureTL.y) and (FigureTL.y <= AreaBR.y) and
     (AreaTL.x <= FigureBR.x) and (FigureBR.x <= AreaBR.x) and
     (AreaTL.y <= FigureBR.y) and (FigureBR.y <= AreaBR.y) then
    Selected := true;
end;

procedure TFigure.CheckPtIn(APoint:TPoint);
begin

end;

end.


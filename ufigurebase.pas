unit UFigureBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics,UFigure,Dialogs, ExtCtrls, UScale;
type

  //исправить бесконечно удлиняющиеся массивы в mouseDown
  TTool = class
    FigureClass:TFigureClass;
    Name,Pic:string;

    procedure MouseDown(APoint:TPoint);virtual;abstract;
    procedure MouseMove(APoint:TPoint);virtual;abstract;
    procedure MouseUp();virtual;abstract;

    procedure CleanREDOFigures;
    procedure WriteUNDOFigures;
    procedure WriteREDOFigures;
    procedure FiguresDraw(pb:TPaintBox);

  end;

  THandTool = class(TTool)
    FirstP:TPoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp();override;
  end;

  TMagnifierTool = class(TTool)
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp();override;
  end;

  TPolyLineTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp();override;
  end;

  TLineTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp();override;
  end;

  TRectangleTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp();override;
  end;

  TEllipseTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp();override;
  end;

var
  Tools:array of TTool;
  ArrPoints:Array of TDoublePoint;

implementation

uses Main;

procedure THandTool.MouseDown(APoint:TPoint);
begin
  FirstP:=APoint;
end;

procedure THandTool.MouseMove(APoint:TPoint);
begin
  Offset.x += round((APoint.x - FirstP.x)/Zoom);
  Offset.y += round((APoint.y - FirstP.y)/Zoom);
  FirstP:=APoint;
end;

procedure THandTool.MouseUp();
begin

end;

procedure TLineTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TPolyLine.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;

end;

procedure TLineTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TLineTool.MouseUp();
var
  S:String;
begin
  S:=IntToStr(Length(Figures[High(Figures)].DPoints));
  ShowMessage(S);
end;

procedure TPolyLineTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TPolyLine.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TPolyLineTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TPolyLineTool.MouseUp();
begin
end;

procedure TRectangleTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TRectangle.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TRectangleTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TRectangleTool.MouseUp();
begin

end;

procedure TEllipseTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TEllipse.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TEllipseTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TEllipseTool.MouseUp();
begin

end;

procedure TMagnifierTool.MouseDown(APoint:TPoint);
begin

end;

procedure TMagnifierTool.MouseMove(APoint:TPoint);
begin

end;

procedure TMagnifierTool.MouseUp();
begin

end;

procedure TTool.CleanREDOFigures;
begin
  SetLength(REDOFigures,0);
end;

procedure TTool.writeUNDOFigures;
begin
  if Length(Figures) > 0 then begin
    SetLength(REDOFigures,Length(REDOFigures)+1);
    REDOFigures[High(REDOFigures)]:=Figures[High(Figures)];
    SetLength(Figures,High(Figures));
  end;
end;

procedure TTool.WriteREDOFigures;
begin
  if Length(REDOFigures)>0 then begin
     SetLength(Figures,Length(Figures)+1);
     Figures[High(Figures)]:=REDOFigures[High(REDOFigures)];
     SetLength(REDOFigures,High(REDOFigures));
  end;
end;

procedure TTool.FiguresDraw(pb:TPaintBox);
var
  i:integer;
  AFigure:TFigure;
begin
  for i:=0 to High(Figures) do begin
    AFigure:=Figures[i];
      AFigure.Draw(pb.Canvas);
  end;
end;

procedure RegisterTool(Tool: TTool; AFigureClass: TFigureClass;AName:String;APicName:String);
begin
  SetLength(Tools, Length(Tools) + 1);
  Tools[High(Tools)] := Tool;
  Tools[High(Tools)].FigureClass := AFigureClass;
  Tools[High(Tools)].Name:=AName;
  Tools[High(Tools)].Pic:=APicName;
end;



initialization
  RegisterTool(TLineTool.Create, TPolyline,'Line','line.bmp');
  RegisterTool(TRectangleTool.Create, TRectangle,'Rectangle','rectangle.bmp');
  RegisterTool(TEllipseTool.Create, TEllipse,'Ellipse','ellipse.bmp');
  RegisterTool(TPolylineTool.Create, TPolyline,'Polyline','pencil.bmp');
  RegisterTool(THandTool.Create, nil ,'Hand', 'pencil.bmp');
  RegisterTool(TMagnifierTool.Create, nil ,'Magnifier','pencil.bmp');
end.


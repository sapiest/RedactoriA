unit UFigureBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics,UFigure,Dialogs, ExtCtrls, UScale;
type

  TTool = class
    FigureClass:TFigureClass;
    Name,Pic:string;
    procedure FigureCreate(X,Y: double);virtual;abstract;
    procedure RaiseLFigure(X,Y: double);
    procedure CleanREDOFigures;
    procedure WriteUNDOFigures;
    procedure WriteREDOFigures;

    procedure FiguresDraw(pb:TPaintBox);

  end;


  TPolyLineTool = class(TTool)
    procedure FigureCreate(X,Y: double); override;
  end;

  TLineTool = class(TTool)
    procedure FigureCreate(X,Y: double); override;
  end;

  TRectangleTool = class(TTool)
    procedure FigureCreate(X,Y: double); override;
  end;

  TEllipseTool = class(TTool)
    procedure FigureCreate(X,Y: double); override;
  end;

var
  Tools:array of TTool;


implementation

uses Main;

procedure TTool.RaiseLFigure(X,Y:double);
begin
  Figures[High(Figures)].AddPoint(DoublePoint(X,Y));
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


procedure TPolyLineTool.FigureCreate(X,Y: double);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TPolyline.Create;
  isDrawing := true;
  Figures[High(Figures)].AddPoint(DoublePoint(X,Y));
  SetMinMaxDoublePoints(DoublePoint(X,Y));
end;


procedure TLineTool.FigureCreate(X,Y: double);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TLine.Create;
  isDrawing := true;
  Figures[High(Figures)].AddPoint(DoublePoint(X,Y));
  SetMinMaxDoublePoints(DoublePoint(X,Y));
end;


procedure TRectangleTool.FigureCreate(X,Y: double);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TRectangle.Create;
  isDrawing := true;
  Figures[High(Figures)].AddPoint(DoublePoint(X,Y));
  SetMinMaxDoublePoints(DoublePoint(X,Y));
end;


procedure TEllipseTool.FigureCreate(X,Y: double);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TEllipse.Create;
  isDrawing := true;
  Figures[High(Figures)].AddPoint(DoublePoint(X,Y));
  SetMinMaxDoublePoints(DoublePoint(X,Y));
end;

initialization
  RegisterTool(TLineTool.Create, TLine,'Line','line.bmp');
  RegisterTool(TRectangleTool.Create, TRectangle,'Rectangle','rectangle.bmp');
  RegisterTool(TEllipseTool.Create, TEllipse,'Ellipse','ellipse.bmp');
  RegisterTool(TPolylineTool.Create, TPolyline,'Polyline','pencil.bmp');


end.


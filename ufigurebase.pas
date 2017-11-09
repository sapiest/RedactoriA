unit UFigureBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics,UFigure,Dialogs, ExtCtrls, UScale, Controls, Spin, StdCtrls, Buttons;
type

  TComboBoxName = array of string;

  TStyleBrushArray = array of TBrushStyle;
  RBrushStyle = record
    Name: TComboBoxName;
    Style: TStyleBrushArray;
  end;

  TStylePenArray = array of TPenStyle;
  RPenStyle = record
    Name: TComboBoxName;
    Style: TStylePenArray;
  end;

  TTool = class
    FigureClass:TFigureClass;
    Names,Pic:string;

    procedure MouseDown(APoint:TPoint);virtual;abstract;
    procedure MouseMove(APoint:TPoint);virtual;abstract;
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);virtual;abstract;
    procedure PPanelCreate(APanel:TPanel);virtual;abstract;
    procedure PenColorButtonChanged(Sender: TObject);
    procedure PenWhidthChange(Sender: TObject);
    procedure BrushColorButtonChanged(Sender: TObject);
    procedure BrushStyleChange(Sender: TObject);
    procedure PenStyleChange(Sender: TObject);
    procedure RoundXChange(Sender: TObject);
    procedure RoundYChange(Sender: TObject);
    procedure CreateColorButton(APanel: TPanel; Name: string; LastColor: TColor; AProcedure: TNotifyEvent);
    procedure CreateSpinEdit(APanel: TPanel; Name: string; LastWidth: integer; AProcedure: TNotifyEvent);
    procedure CreateComboBox(APanel: TPanel; Name: string; NameBrushStyle: TComboBoxName; Index: integer; AProcedure: TNotifyEvent);

    procedure CleanREDOFigures;
    procedure WriteUNDOFigures;
    procedure WriteREDOFigures;
    procedure FiguresDraw(pb:TPaintBox);

  end;

  THandTool = class(TTool)
    FirstP:TPoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TMagnifierTool = class(TTool)
    FirstP:TPoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TPolyLineTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TLineTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TRectangleTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TRoundRectTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TEllipseTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
    procedure PPanelCreate(APanel:TPanel);override;
  end;

var
  Tools:array of TTool;
  ArrPoints:Array of TDoublePoint;
  TypeBrushStyle: RBrushStyle;
  TypePenStyle: RPenStyle;

implementation

uses Main;

procedure TTool.PenColorButtonChanged(Sender: TObject);
begin
  PenColor:=(Sender as TColorButton).ButtonColor;
end;

procedure TTool.BrushColorButtonChanged(Sender: TObject);
begin
  BrushColor:=(Sender as TColorButton).ButtonColor;
end;

procedure TTool.PenWhidthChange(Sender: TObject);
begin
  PenWidthInt:=(Sender as TSpinEdit).Value;
end;

procedure TTool.BrushStyleChange(Sender: TObject);
begin
  BrushStyle.Index:=(Sender as TComboBox).ItemIndex;
  BrushStyle.Style:=TypeBrushStyle.Style[BrushStyle.Index];
end;

procedure TTool.PenStyleChange(Sender: TObject);
begin
  PenStyle.Index:=(Sender as TComboBox).ItemIndex;
  PenStyle.Style:=TypePenStyle.Style[PenStyle.Index];
end;

procedure TTool.RoundXChange(Sender: TObject);
begin
  RoundX:=(Sender as TSpinEdit).Value;
end;

procedure TTool.RoundYChange(Sender: TObject);
begin
  RoundY:=(Sender as TSpinEdit).Value;
end;

procedure TTool.CreateColorButton(APanel: TPanel; Name: string; LastColor: TColor; AProcedure: TNotifyEvent);
var
  PenColorButton: TColorButton;
begin
  PenColorButton:=TColorButton.Create(APanel);
  PenColorButton.Align:=alTop;
  PenColorButton.Layout:=blGlyphBottom;
  PenColorButton.Caption:=Name;
  PenColorButton.Height:=40;
  PenColorButton.Parent:=APanel;
  PenColorButton.ButtonColor:=LastColor;
  PenColorButton.OnColorChanged:=AProcedure;
end;

procedure TTool.CreateSpinEdit(APanel: TPanel; Name: string; LastWidth: integer; AProcedure: TNotifyEvent);
var
  Panel: TPanel;
  Lab: TLabel;
  SpinEdit: TSpinEdit;
begin
  Panel:=TPanel.Create(APanel);
  Panel.Parent:=APanel;
  Panel.Align:=alTop;
  Panel.Height:=40;
  Lab:=TLabel.Create(Panel);
  Lab.Parent:=Panel;
  Lab.Align:=alTop;
  Lab.Caption:=Name;
  SpinEdit:=TSpinEdit.Create(Panel);
  SpinEdit.Align:=alBottom;
  SpinEdit.Parent:=Panel;
  SpinEdit.Value:=LastWidth;
  SpinEdit.OnChange:=AProcedure;
end;

procedure TTool.CreateComboBox(APanel: TPanel; Name: string; NameBrushStyle: TComboBoxName; Index: integer; AProcedure: TNotifyEvent);
var
  Panel: TPanel;
  Lab: TLabel;
  ComboBox: TComboBox;
  i: Integer;
begin
  Panel:=TPanel.Create(APanel);
  Panel.Parent:=APanel;
  Panel.Align:=alTop;
  Panel.Height:=40;
  Lab:=TLabel.Create(Panel);
  Lab.Parent:=Panel;
  Lab.Align:=alTop;
  Lab.Caption:=Name;
  ComboBox:=TComboBox.Create(Panel);
  ComboBox.Align:=alBottom;
  ComboBox.Parent:=Panel;

  for i:=0 to High(NameBrushStyle) do
    ComboBox.Items[i]:=NameBrushStyle[i];
  ComboBox.ItemIndex:=Index;
  ComboBox.OnChange:=AProcedure;
end;

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

procedure THandTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
begin

end;

procedure THandTool.PPanelCreate(APanel: TPanel);
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

procedure TLineTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
begin

end;

procedure TLineTool.PPanelCreate(APanel: TPanel);
begin
  CreateColorButton(APanel, 'Pen Color', PenColor,@PenColorButtonChanged);
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @PenStyleChange);
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

procedure TPolyLineTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
begin

end;

procedure TPolyLineTool.PPanelCreate(APanel: TPanel);
begin
  CreateColorButton(APanel, 'Pen Color', PenColor,@PenColorButtonChanged);
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
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

procedure TRectangleTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
begin

end;

procedure TRectangleTool.PPanelCreate (APanel: TPanel);
begin
  CreateColorButton(APanel, 'Brush Color', BrushColor, @BrushColorButtonChanged);
  CreateColorButton(APanel, 'Pen Color', PenColor, @PenColorButtonChanged);
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @BrushStyleChange);
  CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @PenStyleChange);
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

procedure TEllipseTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
begin

end;

procedure TEllipseTool.PPanelCreate(APanel: TPanel);
begin
  CreateColorButton(APanel, 'Brush Color', BrushColor, @BrushColorButtonChanged);
  CreateColorButton(APanel, 'Pen Color', PenColor,@PenColorButtonChanged);
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @BrushStyleChange);
  CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @PenStyleChange);
end;

procedure TRoundRectTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TRoundRect.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TRoundRectTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TRoundRectTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
begin

end;

procedure TRoundRectTool.PPanelCreate(APanel: TPanel);
begin
  CreateSpinEdit(APanel, 'Round Y', RoundY, @RoundYChange);
  CreateSpinEdit(APanel, 'Round X', RoundX, @RoundXChange);
  CreateColorButton(APanel, 'Brush Color', BrushColor, @BrushColorButtonChanged);
  CreateColorButton(APanel, 'Pen Color', PenColor, @PenColorButtonChanged);
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @BrushStyleChange);
  CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @PenStyleChange);
end;

procedure TMagnifierTool.MouseDown(APoint:TPoint);
begin
  //FirstP:=APoint;
end;

procedure TMagnifierTool.MouseMove(APoint:TPoint);
begin

end;

procedure TMagnifierTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);
const
  ZoomStep=1;
begin
  {if (Button = mbLeft) then begin
    if Zoom=FloatSpinZoom.Value then
      if FloatSpinZoom.Value < ZoomStep then
        FloatSpinZoom.Value:=FloatSpinZoom.Value+(ZoomStep div 10)
      else
        FloatSpinZoom.Value:=FloatSpinZoom.Value+(ZoomStep);
    Zoom:=FloatSpinZoom.Value;
    Offset.x:=round(((Offset.x-x)*Zoom/LastZoom)+x);
    Offset.y:=round(((Offset.y-y)*Zoom/LastZoom)+y);
    LastZoom:=Zoom;
  end else if (Button = mbRight)then begin
    if Zoom=FloatSpinZoom.Value then
      if FloatSpinZoom.Value <= ZoomStep then
        FloatSpinZoom.Value:=FloatSpinZoom.Value-(ZoomStep div 10)
      else
        FloatSpinZoom.Value:=FloatSpinZoom.Value-(ZoomStep);
    Zoom:=FloatSpinZoom.Value;
    Offset.x:=round(((Offset.x-x)*Zoom/LastZoom)+x);
    Offset.y:=round(((Offset.y-y)*Zoom/LastZoom)+y);
    LastZoom:=Zoom;
  end;  }
end;

procedure TMagnifierTool.PPanelCreate(APanel: TPanel);
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
  Tools[High(Tools)].Names:=AName;
  Tools[High(Tools)].Pic:=APicName;
end;

procedure RegisterBrushSt(AStyle: TBrushStyle; AName: string);
begin
  SetLength(TypeBrushStyle.Name, Length(TypeBrushStyle.Name)+1);
  SetLength(TypeBrushStyle.Style, Length(TypeBrushStyle.Style)+1);
  TypeBrushStyle.Name[High(TypeBrushStyle.Name)]:=AName;
  TypeBrushStyle.Style[High(TypeBrushStyle.Style)]:=AStyle;
end;

procedure RegisterPenSt(AStyle: TPenStyle; AName: string);
begin
  SetLength(TypePenStyle.Name, Length(TypePenStyle.Name)+1);
  SetLength(TypePenStyle.Style, Length(TypePenStyle.Style)+1);
  TypePenStyle.Name[High(TypePenStyle.Name)]:=AName;
  TypePenStyle.Style[High(TypePenStyle.Style)]:=AStyle;
end;

initialization
  RegisterTool(TLineTool.Create, TPolyline,'Line','line.bmp');
  RegisterTool(TRectangleTool.Create, TRectangle,'Rectangle','rectangle.bmp');
  RegisterTool(TEllipseTool.Create, TEllipse,'Ellipse','ellipse.bmp');
  RegisterTool(TPolylineTool.Create, TPolyline,'Polyline','pencil.bmp');
  RegisterTool(THandTool.Create, nil ,'Hand', 'hand.bmp');
  //RegisterTool(TMagnifierTool.Create, nil ,'Magnifier','pencil.bmp');
  RegisterTool(TRoundRectTool.Create, TRoundRect,'RoundRect','roundrect.bmp');

  RegisterBrushSt(bsClear, 'Clear');
  RegisterBrushSt(bsBDiagonal, 'BDiagonal');
  RegisterBrushSt(bsFDiagonal, 'FDiagonal');
  RegisterBrushSt(bsCross, 'Cross');
  RegisterBrushSt(bsDiagCross, 'Diag Cross');
  RegisterBrushSt(bsHorizontal, 'Horizontal');
  RegisterBrushSt(bsVertical, 'Vertical');
  RegisterBrushSt(bsSolid, 'Solid');

  RegisterPenSt(psClear, 'Clear');
  RegisterPenSt(psDash, 'Dash');
  RegisterPenSt(psDashDot, 'Dash-Dot');
  RegisterPenSt(psDashDotDot, 'Dash-Dot-Dot');
  RegisterPenSt(psDot, 'Dot');
  RegisterPenSt(psInsideframe, 'Inside Frame');
  RegisterPenSt(psSolid, 'Solid');
end.


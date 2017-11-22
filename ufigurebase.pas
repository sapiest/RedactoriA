unit UFigureBase;

{$mode objfpc}{$H+}

interface

uses
<<<<<<< HEAD
  Classes, SysUtils,Graphics,UFigure,Dialogs, ExtCtrls, UScale, Controls, Spin, StdCtrls, Buttons, UParams;
type

=======
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



>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
  TTool = class
    FigureClass:TFigureClass;
    Names,Pic:string;

    Poligon: TDoubleRect;
    PSize: TDoublePoint;
    WTop, WBottom: TDoublePoint;
    delta: integer;
    LastScrollBarHor, LastScrollBarVert: integer;
    procedure Scrolling(pb:TPaintBox;ScrollBarHor: TScrollBar;
    ScrollBarVert: TScrollBar);

    procedure MouseDown(APoint:TPoint);virtual;abstract;
    procedure MouseMove(APoint:TPoint);virtual;abstract;
<<<<<<< HEAD
    procedure MouseUp();virtual;abstract;

    procedure PPanelCreate(APanel:TPanel);virtual;
    {procedure PenColorButtonChanged(Sender: TObject);
=======
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);virtual;abstract;
    procedure PPanelCreate(APanel:TPanel);virtual;abstract;
    procedure PenColorButtonChanged(Sender: TObject);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure PenWhidthChange(Sender: TObject);
    procedure BrushColorButtonChanged(Sender: TObject);
    procedure BrushStyleChange(Sender: TObject);
    procedure PenStyleChange(Sender: TObject);
    procedure RoundXChange(Sender: TObject);
    procedure RoundYChange(Sender: TObject);
    procedure CreateColorButton(APanel: TPanel; Name: string; LastColor: TColor; AProcedure: TNotifyEvent);
    procedure CreateSpinEdit(APanel: TPanel; Name: string; LastWidth: integer; AProcedure: TNotifyEvent);
<<<<<<< HEAD
    procedure CreateComboBox(APanel: TPanel; Name: string; NameBrushStyle: TComboBoxName; Index: integer; AProcedure: TNotifyEvent);  }
=======
    procedure CreateComboBox(APanel: TPanel; Name: string; NameBrushStyle: TComboBoxName; Index: integer; AProcedure: TNotifyEvent);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure MinMaxPoints;
    procedure CleanREDOFigures;
    procedure WriteUNDOFigures;
    procedure WriteREDOFigures;
    procedure FiguresDraw(pb:TPaintBox);

  end;

  THandTool = class(TTool)
    FirstP:TPoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
<<<<<<< HEAD
    procedure MouseUp();override;
=======
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TMagnifierTool = class(TTool)
    FirstP:TPoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
<<<<<<< HEAD
    procedure MouseUp();override;
=======
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TPolyLineTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
<<<<<<< HEAD
    procedure MouseUp();override;
=======
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TLineTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
<<<<<<< HEAD
    procedure MouseUp();override;
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TPenTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
    procedure MouseUp();override;
=======
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TRectangleTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
<<<<<<< HEAD
    procedure MouseUp();override;
=======
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TRoundRectTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
<<<<<<< HEAD
    procedure MouseUp();override;
=======
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure PPanelCreate(APanel:TPanel);override;
  end;

  TEllipseTool = class(TTool)
    ADoublePoint:TDoublePoint;
    procedure MouseDown(APoint:TPoint);override;
    procedure MouseMove(APoint:TPoint);override;
<<<<<<< HEAD
    procedure MouseUp();override;
=======
    procedure MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);override;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
    procedure PPanelCreate(APanel:TPanel);override;
  end;

var
  Tools:array of TTool;
  ArrPoints:Array of TDoublePoint;
<<<<<<< HEAD
  AParam: TParam;
  MaxPoint, MinPoint:TDoublePoint;
  writePL:boolean;
=======
  TypeBrushStyle: RBrushStyle;
  TypePenStyle: RPenStyle;
  MaxPoint, MinPoint:TDoublePoint;

>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
implementation

uses Main;

<<<<<<< HEAD
procedure TTool.PPanelCreate(APanel:TPanel);
begin
  AParam.CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @AParam.PenWhidthChange);
  AParam.CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @AParam.PenStyleChange);
  AParam.CreateColorButton(APanel, 'Pen Color', PenColor, @AParam.PenColorButtonChanged);
end;
=======
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2

procedure TTool.Scrolling(pb:TPaintBox;ScrollBarHor: TScrollBar;
    ScrollBarVert: TScrollBar);
begin
  Poligon :=DoubleRect(MinPoint, MaxPoint);

  WTop := Canvas2Wrld(Point(0, 0));
  if Poligon.Top.X > WTop.x then
     Poligon.Top.x := WTop.x;
  if Poligon.Top.y > WTop.y then
     Poligon.Top.y := WTop.y;
  WBottom := Canvas2Wrld(Point(pb.Width, pb.Height));
  if Poligon.Bottom.x < WBottom.x then
     Poligon.Bottom.x := WBottom.x;
  if Poligon.Bottom.y < WBottom.y then
     Poligon.Bottom.y := WBottom.y;
  PSize.X := Poligon.Bottom.x - Poligon.Top.x;
  PSize.Y := Poligon.Bottom.y - Poligon.Top.y;
  if PSize.x * PSize.y = 0 then exit;

  delta := ScrollBarHor.Max - ScrollBarHor.Min;
  ScrollBarHor.PageSize := round(pb.Width / (PSize.X * Zoom) * delta);
  ScrollBarHor.Visible := ScrollBarHor.PageSize < delta;
  if ScrollBarHor.PageSize < delta then
  begin
    if (LastScrollBarHor = ScrollBarHor.Position) then
      ScrollBarHor.Position := round(((-1) * (offset.x + Poligon.Top.x)) / PSize.X * delta)
    else
      offset.x := (-1) * round(ScrollBarHor.Position / delta * PSize.x + Poligon.Top.x);
    LastScrollBarHor := ScrollBarHor.Position;
  end;

  delta := ScrollBarVert.Max - ScrollBarVert.Min;
  ScrollBarVert.PageSize := round(pb.Height / (PSize.y * Zoom) * delta);
  ScrollBarVert.Visible := ScrollBarVert.PageSize < delta;
  if ScrollBarVert.PageSize < delta then
  begin
    if (LastScrollBarVert = ScrollBarVert.Position) then
      ScrollBarVert.Position := round(((-1) * (offset.y + Poligon.Top.y)) / PSize.Y * delta)
    else
      offset.y := (-1) * round(ScrollBarVert.Position / delta * PSize.y + Poligon.Top.y);
    LastScrollBarVert := ScrollBarVert.Position;
  end;
end;

procedure TTool.MinMaxPoints;
var
  i:TFigure;
begin
  if Length(Figures)>0 then begin
  MaxPoint.x:=Figures[0].maxPoint.x;
  MinPoint.x:=Figures[0].minPoint.x;
  MaxPoint.y:=Figures[0].maxPoint.y;
  MinPoint.y:=Figures[0].minPoint.y;
  end;
  for i in Figures do begin
    if(i.maxPoint.x > MaxPoint.x) then
      MaxPoint.x:=i.maxPoint.x;
    if(i.minPoint.x < MinPoint.x) then
      MinPoint.x:=i.minPoint.x;
    if(i.maxPoint.y > MaxPoint.y) then
      MaxPoint.y:=i.maxPoint.y;
    if(i.minPoint.y < MinPoint.y) then
      MinPoint.y:=i.minPoint.y;
  end;
end;

<<<<<<< HEAD
=======
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

>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
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

<<<<<<< HEAD
procedure THandTool.MouseUp();
=======
procedure THandTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
begin

end;

procedure THandTool.PPanelCreate(APanel: TPanel);
begin

end;

procedure TLineTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
<<<<<<< HEAD
  Figures[High(Figures)] := TLine.Create;
=======
  Figures[High(Figures)] := TPolyLine.Create;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TLineTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
<<<<<<< HEAD
  Figures[High(Figures)].DPoints[High(Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TLineTool.MouseUp();
=======
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TLineTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
begin

end;

procedure TLineTool.PPanelCreate(APanel: TPanel);
begin
<<<<<<< HEAD
  inherited;
=======
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateColorButton(APanel, 'Pen Color', PenColor,@PenColorButtonChanged);
  CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @PenStyleChange);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
end;

procedure TPolyLineTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
<<<<<<< HEAD
  Figures[High(Figures)] := TLine.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High(Figures[High(Figures)].DPoints)]:=ADoublePoint;
  writePL:=true;
=======
  Figures[High(Figures)] := TPolyLine.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
end;

procedure TPolyLineTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
<<<<<<< HEAD
  Figures[High(Figures)].DPoints[High(Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TPolyLineTool.MouseUp();
=======
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TPolyLineTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
begin

end;

procedure TPolyLineTool.PPanelCreate(APanel: TPanel);
begin
<<<<<<< HEAD
  inherited;
end;

procedure TPenTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TLine.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High(Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TPenTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High(Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TPenTool.MouseUp();
begin

end;

procedure TPenTool.PPanelCreate(APanel:TPanel);
begin
  inherited;
end;


=======
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateColorButton(APanel, 'Pen Color', PenColor,@PenColorButtonChanged);
end;

>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
procedure TRectangleTool.MouseDown(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TRectangle.Create;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
<<<<<<< HEAD
  Figures[High(Figures)].DPoints[High(Figures[High(Figures)].DPoints)]:=ADoublePoint;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High(Figures[High(Figures)].DPoints)]:=ADoublePoint;
=======
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
  SetLength(Figures[High(Figures)].DPoints, length(Figures[High(Figures)].DPoints)+1);
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
end;

procedure TRectangleTool.MouseMove(APoint:TPoint);
begin
  ADoublePoint:=Canvas2Wrld(APoint);
<<<<<<< HEAD
  Figures[High(Figures)].DPoints[High(Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TRectangleTool.MouseUp();
=======
  Figures[High(Figures)].DPoints[High( Figures[High(Figures)].DPoints)]:=ADoublePoint;
end;

procedure TRectangleTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
begin

end;

procedure TRectangleTool.PPanelCreate (APanel: TPanel);
begin
<<<<<<< HEAD
  AParam.CreateColorButton(APanel, 'Brush Color', BrushColor, @AParam.BrushColorButtonChanged);
  AParam.CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @AParam.BrushStyleChange);
  inherited;
=======

  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @BrushStyleChange);
  CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @PenStyleChange);
  CreateColorButton(APanel, 'Brush Color', BrushColor, @BrushColorButtonChanged);
  CreateColorButton(APanel, 'Pen Color', PenColor, @PenColorButtonChanged);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
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

<<<<<<< HEAD
procedure TEllipseTool.MouseUp();
=======
procedure TEllipseTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
begin

end;

procedure TEllipseTool.PPanelCreate(APanel: TPanel);
begin
<<<<<<< HEAD
  AParam.CreateColorButton(APanel, 'Brush Color', BrushColor, @AParam.BrushColorButtonChanged);
  AParam.CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @AParam.BrushStyleChange);
  inherited;
=======
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @BrushStyleChange);
  CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @PenStyleChange);
  CreateColorButton(APanel, 'Brush Color', BrushColor, @BrushColorButtonChanged);
  CreateColorButton(APanel, 'Pen Color', PenColor,@PenColorButtonChanged);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
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

<<<<<<< HEAD
procedure TRoundRectTool.MouseUp();
=======
procedure TRoundRectTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton;FLoatSpinZoom: TFloatSpinEdit);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
begin

end;

procedure TRoundRectTool.PPanelCreate(APanel: TPanel);
begin
<<<<<<< HEAD
  AParam.CreateColorButton(APanel, 'Brush Color', BrushColor, @AParam.BrushColorButtonChanged);
  AParam.CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @AParam.BrushStyleChange);
  AParam.CreateSpinEdit(APanel, 'Round Y', RoundY, @AParam.RoundYChange);
  AParam.CreateSpinEdit(APanel, 'Round X', RoundX, @AParam.RoundXChange);
  inherited;
=======
  CreateSpinEdit(APanel, 'Pen Width', PenWidthInt, @PenWhidthChange);
  CreateComboBox(APanel, 'Brush Style', TypeBrushStyle.Name, BrushStyle.Index, @BrushStyleChange);
  CreateComboBox(APanel, 'Pen Style', TypePenStyle.Name, PenStyle.Index, @PenStyleChange);
  CreateSpinEdit(APanel, 'Round Y', RoundY, @RoundYChange);
  CreateSpinEdit(APanel, 'Round X', RoundX, @RoundXChange);
  CreateColorButton(APanel, 'Brush Color', BrushColor, @BrushColorButtonChanged);
  CreateColorButton(APanel, 'Pen Color', PenColor, @PenColorButtonChanged);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
end;

procedure TMagnifierTool.MouseDown(APoint:TPoint);
begin
  //FirstP:=APoint;
end;

procedure TMagnifierTool.MouseMove(APoint:TPoint);
begin

end;

<<<<<<< HEAD
procedure TMagnifierTool.MouseUp();
=======
procedure TMagnifierTool.MouseUp(Shift: TShiftState; X, Y: Integer; Button: TMouseButton; FLoatSpinZoom: TFloatSpinEdit);
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
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
<<<<<<< HEAD
  RegisterTool(TLineTool.Create, TLine,'Line','line.bmp');
  RegisterTool(TRectangleTool.Create, TRectangle,'Rectangle','rectangle.bmp');
  RegisterTool(TEllipseTool.Create, TEllipse,'Ellipse','ellipse.bmp');
  RegisterTool(TPolylineTool.Create, TLine,'Polyline','lines.bmp');
  RegisterTool(THandTool.Create, nil ,'Hand', 'hand.bmp');
  RegisterTool(TPenTool.Create, TLine,'Pen', 'pencil.bmp');
  RegisterTool(TRoundRectTool.Create, TRoundRect,'RoundRect','roundrect.bmp');
  //RegisterTool(TMagnifierTool.Create, nil ,'Magnifier','pencil.bmp');
=======
  RegisterTool(TLineTool.Create, TPolyline,'Line','line.bmp');
  RegisterTool(TRectangleTool.Create, TRectangle,'Rectangle','rectangle.bmp');
  RegisterTool(TEllipseTool.Create, TEllipse,'Ellipse','ellipse.bmp');
  RegisterTool(TPolylineTool.Create, TPolyline,'Polyline','pencil.bmp');
  RegisterTool(THandTool.Create, nil ,'Hand', 'hand.bmp');
  //RegisterTool(TMagnifierTool.Create, nil ,'Magnifier','pencil.bmp');
  RegisterTool(TRoundRectTool.Create, TRoundRect,'RoundRect','roundrect.bmp');
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2

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


unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,LCLType,
  Menus,Buttons, PairSplitter, ColorBox, StdCtrls, Spin,UFigureBase, UScale, UFigure;



type



  { TMainForm }

  TMainForm = class(TForm)
    FLoatSpinZoom: TFloatSpinEdit;
    MainMenu: TMainMenu;
    MenuExit: TMenuItem;
    MenuAbout: TMenuItem;
    MenuFile: TMenuItem;
    MenuF1: TMenuItem;
    ScrollBarHor: TScrollBar;
    ScrollBarVert: TScrollBar;
    ToolsPanel: TPanel;
    Pb: TPaintBox;
    procedure BitUNDOClick(Sender: TObject);
    procedure BitREDOClick(Sender: TObject);
    procedure FLoatSpinZoomChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Scroll;
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure ScrollBarChange(Sender: TObject);
    //procedure ScrollBarHorChange(Sender: TObject);
    procedure ScrollBarHorScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollBarVertScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ToolsButtonClick(Sender : TObject);
    procedure PbMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PbMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PbPaint(Sender: TObject);


  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  isDrawing:boolean;
  ATool: TTool;
  TPenColor:TColor;
  TBrushColor:TColor;
  TPenWidth:Integer;
  CWidth,CHeight:Integer;
  LastScrollBarHor, LastScrollBarVert: integer;

  MaxPoint, MinPoint:TDoublePoint;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MenuExitClick(Sender: TObject);
begin
  close();
end;

procedure TMainForm.ScrollBarChange(Sender: TObject);
begin
  //Offset:=Point(ScrollBarHor.Position,ScrollBarVert.Position);
  //pb.Invalidate;
end;


procedure TMainForm.ScrollBarHorScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  pb.Invalidate;
end;

procedure TMainForm.ScrollBarVertScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  pb.Invalidate;
end;

procedure TMainForm.MenuAboutClick(Sender: TObject);
begin
  ShowMessage('The vector Editor «RedactoriA» for FEFU hometask'+#10+
  'The development was started in 09.10.17 and finished ____'+ #10+#10+
  'Anton Mikhailenko, 2017, Telegram: @toxaxab');
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=Ord('Z')) and (ssCtrl in Shift) and (isDrawing=false)then begin
     ATool.WriteUNDOFigures;
     pb.Invalidate;
  end;
  if (key=Ord('Y')) and (ssCtrl in Shift) and (isDrawing=false)then begin
     ATool.WriteREDOFigures;
     pb.Invalidate;
  end;
  if (key=VK_ADD)      or (key=VK_OEM_PLUS)  then
    FLoatSpinZoom.Value := FLoatSpinZoom.Value + 10;
  if (key=VK_SUBTRACT) or (key=VK_OEM_MINUS) then
    FLoatSpinZoom.Value := FLoatSpinZoom.Value - 1;

end;


procedure TMainForm.FormCreate(Sender: TObject);
var
  AButton: TBitBtn;
  i: integer;
begin
  isDrawing:=false;
  AButton:=TBitBtn.Create(Self);
  AButton.Caption:='UNDO';
  AButton.Width := ToolsPanel.Width div 2;
  AButton.Height := 50;
  AButton.Top := 0;
  AButton.Parent := ToolsPanel;
  AButton.onClick := @BitUNDOClick;

  AButton:=TBitBtn.Create(Self);
  AButton.Caption:='REDO';
  AButton.Width := ToolsPanel.Width div 2;
  AButton.Left := ToolsPanel.Width div 2;
  AButton.Height := 50;
  AButton.Top := 0;
  AButton.Parent := ToolsPanel;
  AButton.onClick := @BitREDOClick;

  for i:=0 to High(Tools) do
  begin
    AButton := TBitBtn.Create(ToolsPanel);
    AButton.Glyph.LoadFromFile(Tools[i].Pic);
    AButton.Caption := Tools[i].Name;
    AButton.Margin:=10;
    AButton.Spacing:=-1;
    AButton.Width := ToolsPanel.Width;
    AButton.Height := 50;
    AButton.Top := (i+1)*50;
    AButton.Tag := i;
    AButton.Parent := ToolsPanel;
    AButton.onClick := @ToolsButtonClick;
  end;
  ScrollBarHor.PageSize:=300;
  ScrollBarVert.PageSize:=300;
  FLoatSpinZoom.MinValue := ZOOM_MIN * 100;
  FLoatSpinZoom.MaxValue := ZOOM_MAX * 100;

end;

procedure TMainForm.BitUNDOClick(Sender: TObject);
begin
    ATool.WriteUNDOFigures;
  pb.Invalidate;
end;

procedure TMainForm.BitREDOClick(Sender: TObject);
begin
    ATool.WriteREDOFigures;
  pb.Invalidate;
end;

procedure TMainForm.FLoatSpinZoomChange(Sender: TObject);
begin
  SetScale(FLoatSpinZoom.Value / 100);
  pb.Invalidate;
end;

procedure TMainform.ToolsButtonClick(Sender : TObject);
begin
  ATool := Tools[(Sender as TBitBtn).tag];
end;

procedure TMainForm.PbMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ATool.CleanREDOFigures;
  if ssLeft in Shift then begin
    isDrawing := true;
    ATool.MouseDown(Point(X,Y));
  end;
    pb.Invalidate;
end;

procedure TMainForm.PbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
begin
  if (isDrawing) then  begin
    ATool.MouseMove(Point(X,Y));
  end;
    pb.Invalidate;
end;

procedure TMainForm.PbMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ATool.MouseUp();
  isDrawing:=false;
end;

procedure TMainForm.PbPaint(Sender: TObject);
var
   i:TFigure;
begin
  FLoatSpinZoom.Value := Zoom * 100;
  pb.Canvas.Brush.Color:=clWhite;
  pb.Canvas.FillRect(0,0,Width,Height);
  ATool.FiguresDraw(pb);
  pb.Canvas.Brush.Style:=bsClear;

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


  Scroll;

end;

procedure TMainForm.Scroll;
var
  Poligon: TDoubleRect;
  PSize: TDoublePoint;
  WTop, WBottom: TDoublePoint;
  delta: integer;
begin


  Poligon := DoubleRect(MinPoint, MaxPoint);

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

initialization
  Atool:=Tools[0];
end.


unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,LCLType,
  Menus,Buttons, StdCtrls, Spin,UFigureBase,UScale;



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
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure PanelCreate;
    procedure PanelDelete;
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
  ParameterTool: TPanel;
  CWidth,CHeight:Integer;
  Toolbar: TPanel;


implementation

{$R *.lfm}


{ TMainForm }

procedure TMainForm.PanelCreate;
var
  PPanel:TPanel;
begin
  PPanel:=TPanel.Create(MainForm);
  PPanel.Parent:=MainForm;
  PPanel.Anchors:=[akTop,akLeft];
  PPanel.Name:='PPanel';
  PPanel.Caption:='';
  PPanel.Width:=100;
  PPanel.Height:=300;
  PPanel.Top:=200;
  PPanel.Left:=0;
  ATool.PPanelCreate(PPanel);
end;

procedure TMainForm.PanelDelete;
begin
  if FindComponent('PPanel') <> nil then
    FindComponent('PPanel').Free;
end;

procedure TMainForm.MenuExitClick(Sender: TObject);
begin
  close();
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
  LastZoom:=Zoom;
  Zoom:= 1.0;
  Offset:= Point(0,0);
  isDrawing:=false;
  PenWidthInt:=1;
  RoundX:=10;
  RoundY:=10;
  BrushColor:=clWhite;
  BrushStyle.Style:=bsClear;

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
    AButton.Top:=50+(i div 2)*50+10;
    if (i mod 2) = 0 then
      AButton.Left:=10
    else
      AButton.Left:=50;
    AButton.Height:=40;
    AButton.Width:=40;
    AButton.Tag := i;
    AButton.Parent := ToolsPanel;
    AButton.onClick := @ToolsButtonClick;
  end;
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
  PanelDelete;
  PanelCreate;
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
  ATool.MouseUp(Shift,X, Y, Button, FLoatSpinZoom);
  isDrawing:=false;
end;

procedure TMainForm.PbPaint(Sender: TObject);
begin
  FLoatSpinZoom.Value := Zoom * 100;
  pb.Canvas.Brush.Color:=clWhite;
  pb.Canvas.FillRect(0,0,Width,Height);
  ATool.FiguresDraw(pb);
  ATool.MinMaxPoints;
  ATool.Scrolling(pb,ScrollBarHor,ScrollBarVert);

end;

initialization
  Atool:=Tools[0];
end.


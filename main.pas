unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,LCLType,
  Menus,Buttons, PairSplitter, ColorBox, StdCtrls, Spin,UFigureBase, UScale;



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

    //прописать изменение scrollbar
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure PbResize(Sender: TObject);


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

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MenuExitClick(Sender: TObject);
begin
  close();
end;

procedure TMainForm.PbResize(Sender: TObject);
begin
  CWidth:=pb.Width;
  CHeight:=pb.Height;
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
  {if (key=VK_SUBTRACT) or (key=VK_OEM_MINUS) then
    FLoatSpinZoom.Value := FLoatSpinZoom.Value - 1; }

end;


procedure TMainForm.FormCreate(Sender: TObject);
var
  AButton: TBitBtn;
  i: integer;
begin
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
var
  WorldCoord:TDoublePoint;
begin
  ATool.CleanREDOFigures;
  if ssLeft in Shift then begin
    WorldCoord := Canvas2Wrld(Point(X,Y));
    ATool.FigureCreate(WorldCoord.x, WorldCoord.y);
  end;
    pb.Invalidate;
end;

procedure TMainForm.PbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var
   WorldCoord:TDoublePoint;
begin
  if (isDrawing) then  begin
    WorldCoord := Canvas2Wrld(Point(X,Y));
    ATool.RaiseLFigure(WorldCoord.x, WorldCoord.y);
    ScrollBarHor.Position := Round(Offset.x);
    ScrollBarVert.Position := Round(Offset.y);
  end;
    pb.Invalidate;
end;

procedure TMainForm.PbMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isDrawing:=false;
end;

procedure TMainForm.PbPaint(Sender: TObject);
var
  i:integer;
begin
  FLoatSpinZoom.Value := Zoom * 100;
  pb.Canvas.Brush.Color:=clWhite;
  pb.Canvas.FillRect(0,0,Width,Height);
  ATool.FiguresDraw(pb);
end;


initialization
  Atool:=Tools[0];
end.


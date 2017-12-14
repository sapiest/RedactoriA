unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,LCLType,
  Menus,Buttons, StdCtrls, Spin, UFigureBase, UScale, UParams, superobject,UFigure;



type

{ TMainForm }

  TMainForm = class(TForm)

    FLoatSpinZoom: TFloatSpinEdit;
    MainMenu: TMainMenu;
    MenuExit: TMenuItem;
    MenuAbout: TMenuItem;
    MenuFile: TMenuItem;
    MenuF1: TMenuItem;
    MenuItemLoad: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItemUp: TMenuItem;
    MenuItemDown: TMenuItem;
    OpenD: TOpenDialog;
    SaveD: TSaveDialog;
    ScrollBarHor: TScrollBar;
    ScrollBarVert: TScrollBar;
    ToolsPanel: TPanel;
    Pb: TPaintBox;

    procedure BtnUndoCreate;
    procedure BtnRedoCreate;
    procedure BitUNDOClick(Sender: TObject);
    procedure BitREDOClick(Sender: TObject);
    procedure FLoatSpinZoomChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure MenuFileClick(Sender: TObject);
    procedure MenuItemLoadClick(Sender: TObject);
    procedure MenuItemSaveClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItemUpClick(Sender: TObject);
    procedure MenuItemDownClick(Sender: TObject);
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
     panelchange:boolean;
     isDrawing:boolean;
    { private declarations }
  public

    { public declarations }
  end;
const
  FiguresName: Array[0..4] of TFigureClass = (TRectangle,TLine,TPenLine,TRoundRect,TEllipse);
var
  MainForm: TMainForm;
  ATool: TTool;

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
  PPanel.Height:=330;
  PPanel.Top:=250;
  PPanel.Left:=0;
  ATool.WritePL:=false;
  ATool.AfterConstruction;
  ATool.ParPanel:=PPanel;
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

procedure TMainForm.MenuFileClick(Sender: TObject);
begin

end;

procedure TMainForm.MenuItemLoadClick(Sender: TObject);
var
 JS: ISuperObject;
 JSA,JSA1:TSuperArray;
 load:TextFile;
 S,S1,S2,buf:String;
 i,j,k:integer;
begin
  if OpenD.Execute then begin
    AssignFile(load,OpenD.FileName);
    Reset(load);
    Read(load,S2);
    while not EOF(load) do begin
      Readln(load,buf);
      S:=S+buf;
      JS:=SO(S);
    end;
    closefile(load);
    if S2='RedactoriA@1.0' then begin
      SetLength(Figures,0);
      FreeAndNil(Figures);
      JSA:=(JS.A['TFigures.Figure']);
      for i:=0 to JSA.Length-1 do begin
        SetLength(Figures,Length(Figures)+1);
        S1:= SO(JSA.S[i]).S['name'];
        for j:=0 to Length(FiguresName)-1 do begin
          if FiguresName[j].ClassName=S1 then
            Figures[i]:=FiguresName[j].Create;
        end;
        Figures[i].PWidth:=SO(JSA.S[i]).i['PenWidth'];
        Figures[i].PStyleInd:=SO(JSA.S[i]).i['PenStyleInd'];
        Figures[i].PStyle:=TypePenStyle.Style[Figures[i].PStyleInd];
        Figures[i].PColor:=(SO(JSA.S[i]).i['PenColor']);
        Figures[i].BColor:=(SO(JSA.S[i]).i['BrushColor']);
        Figures[i].BStyleInd:=SO(JSA.S[i]).i['BrushStyleInd'];
        Figures[i].BStyle:=TypeBrushStyle.Style[Figures[i].BStyleInd];
        JSA1:=SO(JSA.S[i]).A['coord'];
        k:=0;
        for j:=0 to (JSA1.Length div 2)-1 do begin
          SetLength(Figures[i].DPoints, Length(Figures[i].DPoints)+1);
          Figures[i].DPoints[high(Figures[i].DPoints)]:=Canvas2Wrld(Point(JSA1.i[k],JSA1.i[k+1]));
          K:=k+2;
        end;
      end;
   end
   else
     ShowMessage('Unsupported format');
  end;
end;

procedure TMainForm.MenuItemSaveClick(Sender: TObject);
var
 obj:TSuperObject;
 save:TextFile;
 i,j:integer;
 Sname:String;
 Scoord:Array of TDoublePoint;
begin
  if SaveD.Execute then begin
    AssignFile(save,SaveD.FileName);
    Rewrite(save);
    writeln(save,'RedactoriA@1.0');
    writeln(save,'{"TFigures":');
    writeln(save,'  {');
    write(save,'    "Figure":');
    writeln(save,'[');
    for i:=0 to Length(Figures)-1 do begin
      Sname:=Figures[i].ClassName;
      write(save,'    {"name":'+'"'+Sname+'",');
      write(save,'"coord":[');
      for j:=0 to length(Figures[i].DPoints)-1 do begin
        SetLength(Scoord,Length(Scoord)+1);
        Scoord[j]:=Figures[i].DPoints[j];
        if j=length(Figures[i].DPoints)-1 then
          write(save,FloatToStr(Scoord[j].x)+','+FloatToStr(Scoord[j].y))
        else
          write(save,FloatToStr(Scoord[j].x)+','+FloatToStr(Scoord[j].y)+',');
      end;
      write(save,'],');
      write(save,'"PenWidth":'+IntToStr(Figures[i].PWidth)+',');
      write(save,'"PenStyleInd":'+IntToStr(Figures[i].PStyleInd)+',');
      write(save,'"PenColor":'+IntToStr(ColorToRGB(Figures[i].PColor))+',');
      write(save,'"BrushColor":'+IntToStr(ColorToRGB(Figures[i].BColor))+',');
    if i<>Length(Figures)-1 then
      writeln(save,'"BrushStyleInd":'+IntToStr(Figures[i].BStyleInd)+'},')
    else
      write(save,'"BrushStyleInd":'+IntToStr(Figures[i].BStyleInd)+'}');
    end;
    writeln(save,']');
    writeln(save,'  }');
    write(save,'}');
    closefile(save);
  end;
end;

procedure TMainForm.MenuItem3Click(Sender: TObject);
begin

end;

procedure TMainForm.MenuItemUpClick(Sender: TObject);
begin
  LayerDown;
  pb.Invalidate;
end;

procedure TMainForm.MenuItemDownClick(Sender: TObject);
begin
  LayerUp;
  pb.Invalidate;
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
  if (key=46) and (isDrawing=false)then begin
     AParam.DeleteFigure(Sender);
     pb.Invalidate;
  end;
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
  UPDpb:=Pb;

  BtnUndoCreate;
  BtnRedoCreate;

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

procedure TMainForm.BtnUndoCreate;
var
  AButton: TBitBtn;
begin
  AButton:=TBitBtn.Create(Self);
  AButton.Caption:='UNDO';
  AButton.Width := ToolsPanel.Width div 2;
  AButton.Height := 50;
  AButton.Top := 0;
  AButton.Parent := ToolsPanel;
  AButton.onClick := @BitUNDOClick;
end;

procedure TMainForm.BtnRedoCreate;
var
  AButton: TBitBtn;
begin
  AButton:=TBitBtn.Create(Self);
  AButton.Caption:='REDO';
  AButton.Width := ToolsPanel.Width div 2;
  AButton.Left := ToolsPanel.Width div 2;
  AButton.Height := 50;
  AButton.Top := 0;
  AButton.Parent := ToolsPanel;
  AButton.onClick := @BitREDOClick;
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
    ATool.ClearSelect;
  PanelDelete;
  PanelCreate;
  Invalidate;
end;

procedure TMainForm.PbMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ATool.CleanREDOFigures;
  if ssRight in Shift then
    if ATool.ClassName='TSelectTool' then begin
      Atool.rBtnPressed:= not Atool.rBtnPressed;
      ATool.MouseDown(Point(X,Y));
      isDrawing := true;
      ATool.WritePL:=false;
    end;
  if ssLeft in Shift then begin
    isDrawing := true;
    if not ATool.WritePL then
      ATool.MouseDown(Point(X,Y))
    else
      ATool.MouseMove(Point(X,Y));
    end;
  Invalidate;
end;

procedure TMainForm.PbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
begin
  if (isDrawing) and (not ATool.WritePL)then  begin
    ATool.MouseMove(Point(X,Y));
  end;
  Invalidate;
end;

procedure TMainForm.PbMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ATool.MouseUp(Point(X,Y));
  isDrawing:=false;
  panelchange:=false;
  Invalidate;
end;

procedure TMainForm.PbPaint(Sender: TObject);
begin
  if (ATool.ClassName='TSelectTool') and (not panelchange) then begin
    panelchange:=true;
    PanelDelete;
    PanelCreate;
    Invalidate;
  end;
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


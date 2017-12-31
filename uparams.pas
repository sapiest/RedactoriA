unit UParams;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ExtCtrls, Graphics, Dialogs, Controls, Spin,  StdCtrls, Buttons, UScale, UFigure;

type
  TComboBoxName = array of string;

  ARBrushStyle = record
    Style: TBrushStyle;
    Index: integer;
  end;

  ARPenStyle = record
    Style: TPenStyle;
    Index: integer;
  end;

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

  TParam = class
    PColor: TColor;
    BColor: TColor;
    BStyle: TBrushStyle;
    PStyle: TPenStyle;
    RoundedX: integer;
    RoundedY: integer;
    PWidth: integer;
    itFigure:TFigure;
    procedure DeleteFigure(Sender:TObject);
    procedure SelectedPenColorButtonChanged(Sender: TObject);
    procedure PenColorButtonChanged(Sender: TObject);
    procedure PenWidthChange(Sender: TObject);
    procedure SelectedPenWidthChange(Sender: TObject);
    procedure BrushColorButtonChanged(Sender: TObject);
    procedure SelectedBrushColorButtonChanged(Sender: TObject);
    procedure BrushStyleChange(Sender: TObject);
    procedure SelectedBrushStyleChange(Sender: TObject);
    procedure PenStyleChange(Sender: TObject);
    procedure SelectedPenStyleChange(Sender: TObject);
    procedure RoundXChange(Sender: TObject);
    procedure SelectedRoundXChange(Sender: TObject);
    procedure RoundYChange(Sender: TObject);
    procedure SelectedRoundYChange(Sender: TObject);
    procedure CreateColorButton(APanel: TPanel; Name: string; LastColor: TColor; AProcedure: TNotifyEvent);
    procedure CreateSpinEdit(APanel: TPanel; Name: string; LastWidth: integer; AProcedure: TNotifyEvent);
    procedure CreateComboBox(APanel: TPanel; Name: string; NameBrushStyle: TComboBoxName; Index: integer; AProcedure: TNotifyEvent);
    procedure CreateDeleteButton(APanel: TPanel;AProcedure: TNotifyEvent);
  end;
var
  TypeBrushStyle: RBrushStyle;
  TypePenStyle: RPenStyle;
  UPDpb:TPaintBox;
implementation

procedure TParam.DeleteFigure(Sender: TObject);
var
  i, j: integer;
begin
  j := 0;
  for i := 0 to high(Figures) do
    if (Figures[i].Selected) then
      FreeAndNil(Figures[i])
    else begin
      Figures[j] := Figures[i];
      inc(j);
    end;
 SetLength(Figures, j);
 Push(UndoRedoL,SaveFile);
end;

procedure TParam.SelectedPenColorButtonChanged(Sender: TObject);
var
  jFigure:TFigure;
begin
  for jFigure in Figures do begin
    with jFigure do
      if Selected then
        PColor:=(Sender as TColorButton).ButtonColor;
  end;
  Push(UndoRedoL,SaveFile);
  UPDpb.Invalidate;
end;

procedure TParam.PenColorButtonChanged(Sender: TObject);
begin
  PenColor:=(Sender as TColorButton).ButtonColor;
end;

procedure TParam.SelectedBrushColorButtonChanged(Sender: TObject);
var
  jFigure:TFigure;
begin
  for jFigure in Figures do begin
    with jFigure do
      if Selected then
        BColor:=(Sender as TColorButton).ButtonColor;
  end;
  Push(UndoRedoL,SaveFile);
  UPDpb.Invalidate;
end;

procedure TParam.BrushColorButtonChanged(Sender: TObject);
begin
  BrushColor:=(Sender as TColorButton).ButtonColor;
end;

procedure TParam.PenWidthChange(Sender: TObject);
begin
  PenWidthInt:=(Sender as TSpinEdit).Value;
end;

procedure TParam.SelectedPenWidthChange(Sender: TObject);
var
  jFigure:TFigure;
begin
  for jFigure in Figures do
    with jFigure do
      if Selected then
        PWidth:=(Sender as TSpinEdit).Value;
  Push(UndoRedoL,SaveFile);
  UPDpb.Invalidate;
end;

procedure TParam.SelectedBrushStyleChange(Sender: TObject);
var
  jFigure:TFigure;
begin
   for jFigure in Figures do
    with jFigure do
    if Selected then begin
      BStyleInd:=(Sender as TComboBox).ItemIndex;
      BStyle:=TypeBrushStyle.Style[(Sender as TComboBox).ItemIndex];
    end;
   Push(UndoRedoL,SaveFile);
   UPDpb.Invalidate;
end;

procedure TParam.BrushStyleChange(Sender: TObject);
begin
  BrushStyle.Index:=(Sender as TComboBox).ItemIndex;
  BrushStyle.Style:=TypeBrushStyle.Style[BrushStyle.Index];
end;

procedure TParam.SelectedPenStyleChange(Sender: TObject);
var
  jFigure:TFigure;
begin
  for jFigure in Figures do
    with jFigure do
    if Selected then begin
      PStyleInd:=(Sender as TComboBox).ItemIndex;
      PStyle:=TypePenStyle.Style[(Sender as TComboBox).ItemIndex];
    end;
  Push(UndoRedoL,SaveFile);
  UPDpb.Invalidate;
end;

procedure TParam.PenStyleChange(Sender: TObject);
begin
  PenStyle.Index:=(Sender as TComboBox).ItemIndex;
  PenStyle.Style:=TypePenStyle.Style[PenStyle.Index];
end;

procedure TParam.SelectedRoundXChange(Sender: TObject);
var
  jFigure:TFigure;
begin
   for jFigure in Figures do
     with jFigure do
       if Selected then
         RoundedX:=(Sender as TSpinEdit).Value;
   Push(UndoRedoL,SaveFile);
   UPDpb.Invalidate;
end;

procedure TParam.RoundXChange(Sender: TObject);
begin
  RoundX:=(Sender as TSpinEdit).Value;
end;

procedure TParam.SelectedRoundYChange(Sender: TObject);
var
  jFigure:TFigure;
begin
   for jFigure in Figures do
     with jFigure do
       if Selected then
         RoundedY:=(Sender as TSpinEdit).Value;
   Push(UndoRedoL,SaveFile);
   UPDpb.Invalidate;
end;

procedure TParam.RoundYChange(Sender: TObject);
begin
  RoundY:=(Sender as TSpinEdit).Value;
end;

procedure TParam.CreateDeleteButton(APanel: TPanel;AProcedure: TNotifyEvent);
var
  btnDELETE: TBitBtn;
begin
  btnDELETE:=TBitBtn.Create(APanel);
  btnDELETE.Align:=alTop;
  btnDELETE.Layout:=blGlyphBottom;
  btnDELETE.Caption:='DELETE';
  btnDELETE.Height:=40;
  btnDELETE.Parent:=APanel;
  btnDELETE.OnClick:=AProcedure;
end;

procedure TParam.CreateColorButton(APanel: TPanel; Name: string; LastColor: TColor; AProcedure: TNotifyEvent);
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

procedure TParam.CreateSpinEdit(APanel: TPanel; Name: string; LastWidth: integer; AProcedure: TNotifyEvent);
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

procedure TParam.CreateComboBox(APanel: TPanel; Name: string; NameBrushStyle: TComboBoxName; Index: integer; AProcedure: TNotifyEvent);
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

initialization
PenWidthInt:=1;
BrushStyle.Style:=bsSolid;
BrushStyle.Index:=6;
BrushColor:=clWhite;
PenStyle.Style:=psSolid;
PenStyle.Index:=5;

end.


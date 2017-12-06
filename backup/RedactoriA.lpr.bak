program RedactoriA;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
<<<<<<< HEAD
  Forms, Main, UFigureBase,UFigure, UScale, UParams
=======
  Forms, Main, UFigureBase,UFigure, UScale
>>>>>>> d74d7c7dbe047c54207d5bfa5823954a9737bee2
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.


program Logging;

uses
  Forms,
  main in 'main.pas' {Form1},
  Logger in 'Logger.pas',
  TestThread in 'TestThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

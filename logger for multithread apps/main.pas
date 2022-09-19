unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Logger, TestThread, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit2: TSpinEdit;
    Label3: TLabel;
    Button4: TButton;
    Button3: TButton;
    Label4: TLabel;
    SpinEdit3: TSpinEdit;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  log : TLogger;
  ThrList : Tlist;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);  // кнопка инициализации и запуска записи в лог
var
  i : integer;
  Thr : TTestThread;
begin
  If not DirectoryExists(getcurrentdir + '/Log') then      //файл лога будет находиться в директории программы в папке ../Log
    ForceDirectories(getcurrentdir + '/Log');
  log := TLogger.Create(getcurrentdir + '/Log' + '/Log.txt', SpinEdit1.Value);
  Button1.Caption := 'Log is proccesing';
  Button1.Enabled := false;
  Button2.Enabled := true;
  Timer1.Interval := SpinEdit3.Value * 1000;       // таймер для периодической очистки лога (можно обойтись без него и запускать лог в отдельном потоке)
  Timer1.Enabled := true;
end;

procedure TForm1.Button2Click(Sender: TObject);   //кнопка создания рабочих потоков
var
  i : integer;
  Thr : TTestThread;
begin
  if ThrList = nil then
    ThrList := TList.Create;
  Thr := TTestThread.Create(i, SpinEdit2.Value, log);
  ThrList.Add(Thr);
  Memo1.Lines.Append('Thread ' + inttostr(Thr.ThreadID) + '  delay = ' + inttostr(SpinEdit2.Value));
  Label3.Caption := 'Количество потоков  ' + inttostr(ThrList.Count);
  Button3.Enabled := true;
  Button4.Enabled := true;
end;

procedure TForm1.Button4Click(Sender: TObject);  //просим потоки уничтожиться
var
    i : integer;
  Thr : TTestThread;
begin
  for i:=0 to ThrList.Count-1 do
    begin
      thr := ThrList.Items[i];
      thr.Terminate;
    end;

end;

procedure TForm1.Button3Click(Sender: TObject);   //вывод на экран очереди последних сообщений
begin
  Memo1.Lines := log.GetAllQueue;
end;

procedure TForm1.Timer1Timer(Sender: TObject);     // таймер для периодической очистки лога
begin
  log.LogRemoveOldMsg;
end;

end.

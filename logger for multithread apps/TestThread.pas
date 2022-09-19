unit TestThread;

interface

uses Windows, SysUtils, SyncObjs, Classes, Logger;

type
  TTestThread = class(TThread)        // ������� �����
  private
    fPeriod : integer;                 // ������ �������� ��������� � ���
    fLogger : ^TLogger;               // ������ �� ������ ����
    procedure SendLogMsg(const msg: string; status: byte); // ��������� �������� ��������� � ���
  protected
    procedure Execute; override;
  public
    constructor Create(id, period : integer; var log: TLogger);
  end;
implementation



{TTestThread}

constructor TTestThread.Create(id, period : integer; var log: TLogger);
begin
  if period > 0 then               //�������������
    fPeriod := period
  else
    fPeriod := 50;                 //���� ����� ������ ����������� ������ �� ��������� 50��
  fLogger := @log;
  inherited Create(false);
end;

procedure TTestThread.SendLogMsg(const msg: string; status: byte);
begin
  fLogger.WriteLog(msg,status,ThreadID);
end;

procedure TTestThread.Execute;
var
  i : integer;
begin
i := 0;
While (not terminated) do
  begin
    SendLogMsg('Test message',i mod 3);
    inc(i);
    sleep(fPeriod);
  end;
end;

end.

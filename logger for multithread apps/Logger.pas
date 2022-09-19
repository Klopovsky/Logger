unit Logger;

interface

uses Windows, SysUtils, SyncObjs, Dialogs, Classes,DateUtils;

type
  PNode = ^TNode;    //  ��������� ��������������� ������
  TNode = record     //  ��� �������� ��������� ���������
    next : PNode;
    body : string;
  end;
  TQueue = class     // ����� ��� ������ � �������� (�����)
  private
    len : integer;   //������ ������
    head : PNode;
  public
    constructor Create (quant : integer);
    procedure PutIn (msg : string);          // ��������� ��������� � �������

  end;


  TLogger = class       // ����� ���� (����� ������� ����������)
  private
    Buffer : TQueue;
    fFileName : string;
    fStorageLife : integer;   // ����� ����� ��������� � ����� ���� � ��������
    fcs   : TCriticalSection;
    function StatusMsg(sts : byte):string;   // ������ ��������� 0 - Info 1 - warning 2 - critical
    function CreateLogMsg(const msg : string; status : byte; IDThread : cardinal):string; //������������ ������ ������ ��� ����
  public
    constructor Create(const fileName : string; storage_life : integer);
    procedure WriteLog(const msg : string; status : byte; IDThread : integer); //������ � ���� ����
    function GetAllQueue: TstringList;    //  ��������� ������ ��������� ��������� �� ������
    procedure LogRemoveOldMsg;              //  �������� ������ ��������� �� ����� ����
    function SearchDataTimeInLog (var strList : TStringList):integer;  // ����� � ����� ���� ������� ��������� ���������
    function ExtractDateTime(str : string):TDateTime;         //  ��������� ���� � ������� ������ �� ������ ����
  end;
implementation

{TQueue}
constructor TQueue.Create(quant : integer);
var i: integer; newNode: Pnode;
begin
  len:=10;
  head  := New(PNode);
  newNode := Head;

  for i:=1 to len do                     // ��������� ������ ������ ��� �������
  begin
    newNode.next := New(PNode);
    newNode:=newNode.next;
  end;
  newNode.next := head;
end;

procedure TQueue.PutIn (msg : string);
begin
  head.body := msg;
  head := Head.next;
end;

{\TQueue}


{TLogger}

constructor TLogger.Create(const fileName : string; storage_life : integer);
begin
  fcs := TCriticalSection.Create;
  fFileName := fileName;
  fStorageLife := storage_life;
  if FileExists(fFileName) then
    DeleteFile(fFileName);
  Buffer := TQueue.Create(10);
end;

function TLogger.StatusMsg(sts : byte):string;
begin
  case sts of
    0: result := '[Info]';
    1: result := '[Warning]';
    2: result := '[Critical]';
  else result := '[Unknow]';
  end;
end;

function TLogger.CreateLogMsg(const msg : string; status : byte; IDThread : cardinal):string;
begin
result:= FormatDateTime('[dd.mm.yyyy  hh:mm:ss.zzz]',now())
          + ' -- ' + StatusMsg(status) + ' ' + 'ID#' + inttostr(IDThread)+ ' -> ' + msg;
end;

function TLogger.GetAllQueue():TstringList;
var
  Node : PNode;
  i : integer;
begin
  result := TStringList.Create;
  with Buffer do
  begin
    Node:= head;
    for i:=1 to Buffer.len do
    begin
      node:=node.next;
      Result.Append(Node.body);
    end;
  end;
end;

procedure TLogger.WriteLog(const msg : string; status : byte; IDThread : integer);
var
  logFile : textfile;
  logMsg  : string;
  card  : cardinal;
begin
  AssignFile(logFile,fFileName);
  if not FileExists(fFileName) then
    rewrite(logFile);

  fcs.Enter;
  try
    logMsg := CreateLogMsg(msg, status, IDThread);
    Append(logFile);
    try
      Writeln(logFile,logMsg);
      Buffer.PutIn(logMsg);
    except
      ShowMessage('������ ������ � ���-����!');
    end;
  finally
    CloseFile(logFile);
    fcs.Leave;
  end;

end;

function TLogger.ExtractDateTime(str : string):TDateTime;
var
  Fmt : TFormatSettings;
begin
  fmt.ShortDateFormat:='dd.mm.yyyy';
  fmt.DateSeparator  :='.';
  fmt.LongTimeFormat :='hh:nn:ss.zzz';
  fmt.TimeSeparator  :=':';
  result := StrToDateTime(copy(str,2,24));
end;

function TLogger.SearchDataTimeInLog(var strList : TStringList):integer;
var
  first, last, mid : integer;
begin
  first:=0;
  last:=strList.Count-1;                                
  while last-first < 10 do    // ��� �� ����� ��������� ������ �� ���� � ������� (������ �������� ������ �� 10 �����)
    begin
      mid := (first+last) div 2;
      if WithinPastSeconds(ExtractDateTime(strList.Strings[first]), ExtractDateTime(strList.Strings[last]), fStorageLife) then
         last:=mid
      else first:=mid;
    end;
  while not WithinPastSeconds(ExtractDateTime(strList.Strings[first]), ExtractDateTime(strList.Strings[last]), fStorageLife) do
    inc(first);               // ���������� ���������� 10 �����
  result:=first;
end;

procedure TLogger.LogRemoveOldMsg;
var
  strList, strListOut  : TStringList;
  i, first : integer;
begin
  if not FileExists(fFileName) then
    exit;
  StrList := TStringList.Create;
  StrListOut := TStringList.Create;
  fcs.Enter;
  try
    StrList.LoadFromFile(fFileName);
    first := SearchDataTimeInLog(StrList);
    for i:=first to strList.Count-1 do
      strListOut.Append(strList.Strings[i]);
    strListOut.SaveToFile(fFileName);
  finally
    strList.Free;
    strListOut.Free;
    fcs.Leave;
  end;

end;


end.

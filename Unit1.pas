unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.ScktComp,
  Vcl.ComCtrls, Vcl.ExtCtrls, NB30;

type
  TForm1 = class(TForm)
    ClientSocket1: TClientSocket;
    ServerSocket1: TServerSocket;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    TrayIcon1: TTrayIcon;
    Button2: TButton;
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Button2Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function GetComputerNetName: string;
    function GetAdapterInfo(Lana: Char): string;
    function GetMACAddress: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


// �������� � ����
procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.Hide;
  TrayIcon1.Visible:=true;
end;

// ��������� - ��� ��������
procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Statusbar1.Panels.Items[0].Text:='Connection to '+Socket.RemoteAddress;
  // ��������� xml ��������� � ������� ��� �������
  ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
end;

// ��������� -  ������ ����������
procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Statusbar1.Panels.Items[0].Text:='Server not found '+Socket.RemoteAddress;
end;

// ��������� -  ��� ������������� ������
procedure TForm1.ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode:=0;
end;

// ��������� -  ��� �������� ��������� �� ������� �������
procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Socket.ReceiveText = 'need date' then
  begin
    // ��������� xml ��������� � �������
    ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
    Memo1.Lines.Add('��������� ����������');
  end;
end;

// ��������� - ��� �������� �����
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // ��������� xml ��������� � ������� ��� ��������
  ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
end;

// ��������� - ��� �������� �����
procedure TForm1.FormCreate(Sender: TObject);
begin
  // ������������ ������, ����������� � �������
  {ClientSocket1.Address := '192.168.100.3'; // IP ����� �������
  ClientSocket1.Port := 65000; // ��� ����
  ClientSocket1.Active := True; // ���������� �������}
  ClientSocket1.Open; // ���������

  //�������� ������  ��� �������� �����
  {ServerSocket1.Port := 64000;
  ServerSocket1.Active := True; // ���������� ������
  ServerSocket1.Open; // ���������       }
end;

// ��������� - ������ ������� c������ �����-���� ������
procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  {if Socket.ReceiveText = 'cod' then // ��������������
      ClientSocket1.Socket.SendText('������');
  else
    ClientSocket1.Socket.SendText('not test'); }
end;

// ������� ����� �� �����
procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  Form1.Show;
  TrayIcon1.Visible:=False;
end;

// ������� ����������� ����� ����������
function TForm1.GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

// ������� ��������� ���������� �� �������� ��������
function TForm1.GetAdapterInfo(Lana: Char): string;
var
  Adapter: TAdapterStatus;
  NCB: TNCB;
begin
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBRESET);
  NCB.ncb_lana_num := AnsiChar(Lana);
  if Netbios(@NCB) <> Char(NRC_GOODRET) then
  begin
    Result := '����� �� ��������';
    Exit;
  end;

  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBASTAT);
  NCB.ncb_lana_num := AnsiChar(Lana);
  NCB.ncb_callname := '*';

  FillChar(Adapter, SizeOf(Adapter), 0);
  NCB.ncb_buffer := @Adapter;
  NCB.ncb_length := SizeOf(Adapter);
  if Netbios(@NCB) <> Char(NRC_GOODRET) then
  begin
    Result := '����� �� ��������';
    Exit;
  end;
  Result :=
  IntToHex(Byte(Adapter.adapter_address[0]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[1]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[2]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[3]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[4]), 2) + '-' +
  IntToHex(Byte(Adapter.adapter_address[5]), 2);
end;

// ������� ����������� ��� ������ ��������
function TForm1.GetMACAddress: string;
var
  AdapterList: TLanaEnum;
  NCB: TNCB;
begin
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBENUM);
  NCB.ncb_buffer := @AdapterList;
  NCB.ncb_length := SizeOf(AdapterList);
  Netbios(@NCB);
  if Byte(AdapterList.length) > 0 then
    Result := GetAdapterInfo(Char(AdapterList.lana[0]))
  else
    Result := '����� �� ��������';
end;

end.

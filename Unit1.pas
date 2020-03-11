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


// Свернуть в трей
procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.Hide;
  TrayIcon1.Visible:=true;
end;

// Процедура - при коннекте
procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Statusbar1.Panels.Items[0].Text:='Connection to '+Socket.RemoteAddress;
  // отправить xml сообщение с даннами при запуске
  ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
end;

// Процедура -  сервер отключился
procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Statusbar1.Panels.Items[0].Text:='Server not found '+Socket.RemoteAddress;
end;

// Процедура -  при возникновении ошибки
procedure TForm1.ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode:=0;
end;

// Процедура -  при передаче сообщения от сервера клиенту
procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Socket.ReceiveText = 'need date' then
  begin
    // отправить xml сообщение с даннами
    ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
    Memo1.Lines.Add('Сообщение отправлено');
  end;
end;

// Процедура - при закрытии формы
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // отправить xml сообщение с даннами при закрытии
  ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
end;

// Процедура - при создании формы
procedure TForm1.FormCreate(Sender: TObject);
begin
  // активировать клиент, подключится к серверу
  {ClientSocket1.Address := '192.168.100.3'; // IP адрес сервера
  ClientSocket1.Port := 65000; // его порт
  ClientSocket1.Active := True; // активируем клиента}
  ClientSocket1.Open; // запускаем

  //включаем сервер  для обратной связи
  {ServerSocket1.Port := 64000;
  ServerSocket1.Active := True; // активируем сервер
  ServerSocket1.Open; // запускаем       }
end;

// Процедура - клиент передал cерверу какие-либо данные
procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  {if Socket.ReceiveText = 'cod' then // аутентификация
      ClientSocket1.Socket.SendText('Привет');
  else
    ClientSocket1.Socket.SendText('not test'); }
end;

// Вернуть форму на экран
procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  Form1.Show;
  TrayIcon1.Visible:=False;
end;

// Функция определения имени компьютера
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

// Функция получения информации от сетевого адаптера
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
    Result := 'Адрес не известен';
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
    Result := 'Адрес не известен';
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

// Функция определения МАК адреса адаптера
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
    Result := 'Адрес не известен';
end;

end.

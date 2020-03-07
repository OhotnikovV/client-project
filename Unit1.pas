unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.ScktComp,
  Vcl.ComCtrls, Vcl.ExtCtrls;

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
  private
    function GetComputerNetName: string;
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

  // отправить xml сообщение с даннами
  ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><MAC_address>B0-6E-BF-5C-E2-10</MAC_address></computers>');
  Memo1.Lines.Add('Сообщение отправлено');
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

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add(Socket.ReceiveText);
end;

// Процедура - при создании формы
procedure TForm1.FormCreate(Sender: TObject);
begin
  // активировать клиент, подключится к серверу
  {ClientSocket1.Address := '192.168.100.3'; // IP адрес сервера
  ClientSocket1.Port := 65000; // его порт
  ClientSocket1.Active := True; // активируем клиента}
  ClientSocket1.Open; // запускаем

  memo1.Lines.Add(GetComputerNetName); //вывод имени

  //включаем сервер  для обратной связи
  {ServerSocket1.Port := 64000;
  ServerSocket1.Active := True; // активируем сервер
  ServerSocket1.Open; // запускаем       }
end;

// Процедура - клиент установил сокетное соединение и ждет ответа сервера
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

// функция определения имени компьютера
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

end.

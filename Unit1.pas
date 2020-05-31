unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.ScktComp,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Menus,
  NB30, WinSock, IniFiles, GetComputerInfo;

type
  TForm1 = class(TForm)
    ClientSocket1: TClientSocket;
    StatusBar1: TStatusBar;
    TrayIcon1: TTrayIcon;
    ButtonTray: TButton;
    PopupMenu1: TPopupMenu;
    Setting1: TMenuItem;
    Exit1: TMenuItem;
    LabeName: TLabel;
    LabelIP: TLabel;
    LabelMAC: TLabel;
    LabelGetName: TLabel;
    LabelGetIP: TLabel;
    LabelGetMAC: TLabel;
    GroupBoxInfo: TGroupBox;
    PanelInfo: TPanel;
    Chatter1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ButtonTrayClick(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
    procedure Chatter1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  s:string;
  msgfrom,msgto:string;

implementation

{$R *.dfm}

uses Chatter;

// Свернуть в трей
procedure TForm1.ButtonTrayClick(Sender: TObject);
begin
  Form1.Hide;
end;

//Открываем чат
procedure TForm1.Chatter1Click(Sender: TObject);
begin
  Form2.Show;
end;

// Процедура - при коннекте
procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><IP_address>'+GetLocalIP+'</IP_address><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
  Statusbar1.Panels.Items[0].Text:='Connection to '+Socket.RemoteAddress;
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
  s:='';
  s:=Socket.ReceiveText;
  {Если если пришел запрос на имя компьютера, отправляем ответ.}
  if Copy(s,1,2) = '#N' then
  begin
    Delete(s,1,2);
    ClientSocket1.Socket.SendText('#N'+GetComputerNetName);
    Exit;
  end;
  {Если сервер прислал нам список пользователей}
  if Copy(s,1,2) = '#U' then
  begin
    Delete(s,1,2);
    Form2.ListBoxUsers.Items.Clear;
    Form2.ListBoxUsers.Items.Add('Все');
    {Добавляем по одному имени клиента в ListBox}
    while Pos(';',s) > 0 do
    begin
      Form2.ListBoxUsers.Items.Add(Copy(s,1,Pos(';',s)-1));
      Delete(s,1,Pos(';',s));
    end;
    Exit;
  end;
  {Если сервер прислал нам сообщение для ВСЕХ}
  if Copy(s,1,2) = '#M' then
  begin
     Delete(s,1,2);
     {Добавляем сообщение для всех с именем отправителя}
     Form2.MemoChat.Lines.Insert(0,Copy(s,1,Pos(';',s)-1)+': '+
                          Copy(s,Pos(';',s)+1,Length(s)-Pos(';',s)));
     Exit;
  end;
  {Если сервер прислал нам личное сообщение клиента}
  if Copy(s,1,2) = '#P' then
  begin
    Delete(s,1,2);
    {Записываем имя компьютера кому пришло сообщение}
    msgto := Copy(s,1,Pos(';',s)-1);
    Delete(s,1,Pos(';',s));
    {Имя компьютера от кого сообщение}
    msgfrom := Copy(s,1,Pos(';',s)-1);
    Delete(s,1,Pos(';',s));
    {Если оно для нас, или написано нами - добавляем в Memo1}
    if (msgto = GetComputerNetName) or (msgfrom = GetComputerNetName) then
      Form2.MemoChat.Lines.Insert(0, msgfrom+' (личное): '+s);
    Exit;
  end;
  {Если получаем сообщение с приставкой #date#, отправляем xml сообщение с даннами}
  if Copy(s,1,3) = '#D#' then
  begin
    Delete(s,1,3);
    ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><IP_address>'+GetLocalIP+'</IP_address><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
  end;
end;

// PopupMenu трея - выход
procedure TForm1.Exit1Click(Sender: TObject);
begin
  Form1.Close;
end;

// Процедура - при закрытии формы
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {Отправить xml сообщение с даннами при закрытии}
  ClientSocket1.Socket.SendText('<computers><NameComputer>'+GetComputerNetName+'</NameComputer><IP_address>'+GetLocalIP+'</IP_address><MAC_address>'+GetMACAddress+'</MAC_address></computers>');
  TrayIcon1.Visible:=false;
end;

// Процедура - при создании формы
procedure TForm1.FormCreate(Sender: TObject);
var
  Ini:TIniFile;
begin
  {проверяем существует ли файл, если сущестувует - то находим}
  if FileExists('config.ini') then
  begin
    Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'config.ini');
  end;
  {Присваиваем адрес для подключения к серверу}
  ClientSocket1.Address:=Ini.ReadString('ClientSocket','Address','');
  {Отображение программы в трее}
  TrayIcon1.Visible:=true;
  {Запускаем клиентский сокет}
  ClientSocket1.Open;
  {Вывод информации о системе}
  LabelGetName.Caption:=GetComputerNetName;
  LabelGetIP.Caption:=GetLocalIP;
  LabelGetMAC.Caption:=GetMACAddress;
end;

// Вернуть форму на экран
procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  Form1.Show;
end;

end.

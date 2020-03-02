unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.ScktComp,
  Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    ClientSocket1: TClientSocket;
    Button1: TButton;
    ServerSocket1: TServerSocket;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// ��������� xml ���������
procedure TForm1.Button1Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText('<computers><ip>192.168.100.3</ip></computers>');
  Memo1.Lines.Add('��������� ����������');
end;

// ��������� - ��� ��������
procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Statusbar1.Panels.Items[0].Text:='Connection to '+Socket.RemoteAddress;
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

// ��������� - ������ ��������� �������� ���������� � ���� ������ �������
procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  {if Socket.ReceiveText = 'cod' then // ��������������
      ClientSocket1.Socket.SendText('������');
  else
    ClientSocket1.Socket.SendText('not test'); }
end;

end.

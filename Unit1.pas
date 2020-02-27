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
    procedure Button1Click(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ClientSocket1.Address := '192.168.100.3'; // IP ����� �������
  ClientSocket1.Port := 65000; // ��� ����
  ClientSocket1.Active := True; // ���������� �������
  ClientSocket1.Open; // ���������
  if ClientSocket1.Active then
    Statusbar1.Panels.Items[0].Text:='Connection to ServerSocket1 192.168.100.3';

  ServerSocket1.Port := 64000;
  ServerSocket1.Active := True; // ���������� ������
  ServerSocket1.Open; // ���������
  ClientSocket1.Socket.SendText('������');
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if Socket.ReceiveText = '12354' then
    ClientSocket1.Socket.SendText('test')
  else
    ClientSocket1.Socket.SendText('not test')
end;

end.
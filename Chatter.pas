unit Chatter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,GetComputerInfo;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    ListBox1: TListBox;
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm2.Button1Click(Sender: TObject);
var
  privat,msg:string;
begin
  if ListBox1.ItemIndex < 0 then begin
    ShowMessage('At first you should select the user in the User List!');
    Exit;
  end;
  {���� ��� ��������� ���������}
  privat := '#P'+ListBox1.Items[ListBox1.ItemIndex]+';'; {��������� ����.������� � �������}
  {��������� ���� ��� (�� ����) � ���� ���������}
  msg := privat+GetComputerNetName+';'+Edit1.Text;
  {�������� ��� ��� ����� �� ������}
  Form1.ClientSocket1.Socket.SendText(msg);
  {� ����� ���� ����� � ��� ������ TEdit-�}
  Edit1.Text := '';
  ActiveControl := Edit1;
end;

end.

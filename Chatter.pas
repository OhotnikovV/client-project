unit Chatter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,GetComputerInfo;

type
  TForm2 = class(TForm)
    MemoChat: TMemo;
    EditSend: TEdit;
    ListBoxUsers: TListBox;
    ButtonSend: TButton;
    GroupBoxUsers: TGroupBox;
    GroupBoxChat: TGroupBox;
    PanelString: TPanel;
    procedure ButtonSendClick(Sender: TObject);
    procedure EditSendKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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

// ��������� ���������
procedure TForm2.ButtonSendClick(Sender: TObject);
var
  privat, msg: string;
begin
  if ListBoxUsers.ItemIndex < 0 then begin
    ShowMessage('�������� ������������ � ������ �������������!');
    Exit;
  end;
  {��������� ��� � ��� ���������� ����������}
  privat := '#P'+ListBoxUsers.Items[ListBoxUsers.ItemIndex]+';';
  {��������� ��� ������ ���������� � ���������}
  msg := privat + GetComputerNetName+';'+EditSend.Text;
  Form1.ClientSocket1.Socket.SendText(msg);
  {� ����� ���� ����� � ��� ������ TEdit-�}
  EditSend.Text := '';
  ActiveControl := EditSend;
end;

//��������� ��������� ����� Enter
procedure TForm2.EditSendKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
     ButtonSend.Click;
end;

end.

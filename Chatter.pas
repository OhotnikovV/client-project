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

var
  identif, msg: string;

// Отправить сообщение
procedure TForm2.ButtonSendClick(Sender: TObject);
begin
  if ListBoxUsers.ItemIndex < 0 then begin
    ShowMessage('Выберите кому необходимо отправить сообщение!');
    Exit;
  end;
  {Добавляем тег и имя выбранного компьютера}
  if ListBoxUsers.ItemIndex = 0 then
  begin
    identif := '#M';
  end else
  begin
    identif := '#P'+ListBoxUsers.Items[ListBoxUsers.ItemIndex]+';';
  end;
  {Добавляем имя нашего компьютера и сообщение}
  msg := identif + GetComputerNetName+';'+EditSend.Text;
  Form1.ClientSocket1.Socket.SendText(msg);
  {И снова ждем ввода в уже чистом TEdit-е}
  EditSend.Text := '';
  ActiveControl := EditSend;
end;

//Отправить сообщение через Enter
procedure TForm2.EditSendKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
     ButtonSend.Click;
end;

end.

object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Client'
  ClientHeight = 256
  ClientWidth = 481
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 237
    Width = 481
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 238
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 465
    Height = 169
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 191
    Width = 97
    Height = 25
    Caption = #1057#1074#1077#1088#1085#1091#1090#1100' '#1074' '#1090#1088#1077#1081
    TabOrder = 2
    OnClick = Button2Click
  end
  object ClientSocket1: TClientSocket
    Active = True
    Address = '192.168.100.3'
    ClientType = ctNonBlocking
    Port = 65000
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    OnError = ClientSocket1Error
    Left = 352
    Top = 192
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientRead = ServerSocket1ClientRead
    Left = 424
    Top = 192
  end
  object TrayIcon1: TTrayIcon
    OnDblClick = TrayIcon1DblClick
    Left = 288
    Top = 192
  end
end

object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Network Inventory - Client'
  ClientHeight = 235
  ClientWidth = 506
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
  object Label1: TLabel
    Left = 152
    Top = 224
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 216
    Width = 506
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 506
    Height = 113
    Align = alTop
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 8
      Top = 5
      Width = 249
      Height = 95
      Align = alCustom
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1080#1089#1090#1077#1084#1077
      TabOrder = 0
      object LabeName: TLabel
        Left = 16
        Top = 20
        Width = 89
        Height = 13
        Caption = #1048#1084#1103' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072':'
      end
      object LabelIP: TLabel
        Left = 16
        Top = 45
        Width = 47
        Height = 13
        Caption = 'IP '#1072#1076#1088#1077#1089':'
      end
      object LabelMAC: TLabel
        Left = 16
        Top = 70
        Width = 59
        Height = 13
        Caption = 'MAC '#1072#1076#1088#1077#1089':'
      end
      object LabelGetName: TLabel
        Left = 111
        Top = 20
        Width = 3
        Height = 13
      end
      object LabelGetIP: TLabel
        Left = 111
        Top = 45
        Width = 3
        Height = 13
      end
      object LabelGetMAC: TLabel
        Left = 111
        Top = 70
        Width = 3
        Height = 13
      end
    end
    object Button2: TButton
      Left = 424
      Top = 75
      Width = 73
      Height = 25
      Caption = #1057#1074#1077#1088#1085#1091#1090#1100
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 113
    Width = 506
    Height = 103
    Align = alClient
    TabOrder = 2
  end
  object ClientSocket1: TClientSocket
    Active = True
    Address = '127.0.0.1'
    ClientType = ctNonBlocking
    Port = 65000
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    OnError = ClientSocket1Error
    Left = 456
    Top = 8
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu1
    OnDblClick = TrayIcon1DblClick
    Left = 400
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 344
    Top = 8
    object Chatter1: TMenuItem
      Caption = 'Chatter'
      OnClick = Chatter1Click
    end
    object Setting1: TMenuItem
      Caption = 'Settings'
      OnClick = TrayIcon1DblClick
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end

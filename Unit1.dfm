object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Network Administration - Agent'
  ClientHeight = 169
  ClientWidth = 348
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
    Top = 150
    Width = 348
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 0
    Width = 348
    Height = 150
    Align = alClient
    TabOrder = 1
    object GroupBoxInfo: TGroupBox
      Left = 8
      Top = 5
      Width = 329
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
    object ButtonTray: TButton
      Left = 264
      Top = 106
      Width = 73
      Height = 25
      Caption = #1057#1074#1077#1088#1085#1091#1090#1100
      TabOrder = 1
      OnClick = ButtonTrayClick
    end
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 65000
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    OnError = ClientSocket1Error
    Left = 216
    Top = 8
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu1
    OnDblClick = TrayIcon1DblClick
    Left = 264
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 312
    Top = 8
    object Chatter1: TMenuItem
      Caption = #1063#1072#1090
      OnClick = Chatter1Click
    end
    object Setting1: TMenuItem
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100
      OnClick = TrayIcon1DblClick
    end
    object Exit1: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = Exit1Click
    end
  end
end

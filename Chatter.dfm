object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Chatter'
  ClientHeight = 349
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxUsers: TGroupBox
    Left = 0
    Top = 0
    Width = 539
    Height = 113
    Align = alTop
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
    TabOrder = 0
    object ListBoxUsers: TListBox
      Left = 2
      Top = 15
      Width = 535
      Height = 96
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object GroupBoxChat: TGroupBox
    Left = 0
    Top = 113
    Width = 539
    Height = 236
    Align = alClient
    Caption = #1063#1072#1090
    TabOrder = 1
    object MemoChat: TMemo
      Left = 2
      Top = 15
      Width = 535
      Height = 179
      Align = alClient
      ReadOnly = True
      TabOrder = 0
    end
    object PanelString: TPanel
      Left = 2
      Top = 194
      Width = 535
      Height = 40
      Align = alBottom
      TabOrder = 1
      object EditSend: TEdit
        Left = 0
        Top = 6
        Width = 441
        Height = 21
        TabOrder = 0
        OnKeyDown = EditSendKeyDown
      end
      object ButtonSend: TButton
        Left = 455
        Top = 6
        Width = 75
        Height = 25
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
        TabOrder = 1
        OnClick = ButtonSendClick
      end
    end
  end
end

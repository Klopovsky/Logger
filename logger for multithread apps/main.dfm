object Form1: TForm1
  Left = 192
  Top = 124
  Width = 723
  Height = 508
  Caption = 'Logging'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 187
    Height = 13
    Caption = #1042#1088#1077#1084#1103' '#1078#1080#1079#1085#1080' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1074' '#1083#1086#1075#1077', '#1089#1077#1082
  end
  object Label2: TLabel
    Left = 8
    Top = 296
    Width = 190
    Height = 13
    Caption = #1055#1077#1088#1080#1086#1076' '#1086#1073#1088#1072#1097#1077#1085#1080#1103' '#1087#1086#1090#1086#1082#1072' '#1082' '#1083#1086#1075#1091', '#1084#1089
  end
  object Label3: TLabel
    Left = 8
    Top = 368
    Width = 103
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1090#1086#1082#1086#1074
  end
  object Label4: TLabel
    Left = 8
    Top = 56
    Width = 160
    Height = 13
    Caption = #1055#1077#1088#1080#1086#1076' '#1086#1095#1080#1089#1090#1082#1080' '#1083#1086#1075' '#1092#1072#1081#1083#1072', '#1089#1077#1082
  end
  object Button1: TButton
    Left = 8
    Top = 88
    Width = 97
    Height = 25
    Caption = 'Run Logger'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 344
    Top = 16
    Width = 345
    Height = 329
    TabOrder = 1
  end
  object Button2: TButton
    Left = 24
    Top = 320
    Width = 97
    Height = 25
    Caption = 'Create Thread'
    Enabled = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object SpinEdit1: TSpinEdit
    Left = 208
    Top = 24
    Width = 129
    Height = 22
    MaxValue = 1000000
    MinValue = 1
    TabOrder = 3
    Value = 10
  end
  object SpinEdit2: TSpinEdit
    Left = 208
    Top = 288
    Width = 129
    Height = 22
    MaxValue = 1000000
    MinValue = 1
    TabOrder = 4
    Value = 100
  end
  object Button4: TButton
    Left = 24
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Kill all Threads'
    Enabled = False
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button3: TButton
    Left = 600
    Top = 352
    Width = 89
    Height = 25
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1073#1091#1092#1077#1088
    Enabled = False
    TabOrder = 6
    OnClick = Button3Click
  end
  object SpinEdit3: TSpinEdit
    Left = 208
    Top = 48
    Width = 129
    Height = 22
    MaxValue = 1000000
    MinValue = 1
    TabOrder = 7
    Value = 30
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 664
    Top = 432
  end
end

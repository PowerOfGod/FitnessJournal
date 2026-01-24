object frmSubscriptionEdit1: TfrmSubscriptionEdit1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1099#1081' '#1072#1073#1086#1085#1077#1084#1077#1085#1090
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lbClient: TLabel
    Left = 88
    Top = 35
    Width = 42
    Height = 15
    Caption = #1050#1083#1080#1077#1085#1090':'
  end
  object lblType: TLabel
    Left = 38
    Top = 91
    Width = 92
    Height = 15
    Caption = #1058#1080#1087' '#1072#1073#1086#1085#1077#1084#1077#1085#1090#1072':'
  end
  object lbStatDate: TLabel
    Left = 60
    Top = 152
    Width = 70
    Height = 15
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
  end
  object lbEndDate: TLabel
    Left = 39
    Top = 208
    Width = 91
    Height = 15
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
  end
  object lbPrice: TLabel
    Left = 99
    Top = 264
    Width = 31
    Height = 15
    Caption = #1062#1077#1085#1072':'
  end
  object cbClient: TComboBox
    Left = 160
    Top = 32
    Width = 145
    Height = 23
    TabOrder = 0
    Text = 'cbClient'
  end
  object cbType: TComboBox
    Left = 160
    Top = 88
    Width = 145
    Height = 23
    TabOrder = 1
    Text = 'cbType'
    OnChange = cbTypeChange
  end
  object dtStartDate: TDateTimePicker
    Left = 160
    Top = 144
    Width = 186
    Height = 23
    Date = 46046.000000000000000000
    Time = 0.777857129629410300
    TabOrder = 2
  end
  object dtEndDate: TDateTimePicker
    Left = 160
    Top = 200
    Width = 186
    Height = 23
    Date = 46046.000000000000000000
    Time = 0.778109363425755900
    TabOrder = 3
  end
  object edtPrice: TEdit
    Left = 160
    Top = 256
    Width = 121
    Height = 23
    TabOrder = 4
    Text = 'edtPrice'
  end
  object btnSave: TButton
    Left = 160
    Top = 328
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 5
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 271
    Top = 328
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 6
    OnClick = btnCancelClick
  end
end

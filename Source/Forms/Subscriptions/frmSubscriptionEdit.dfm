object frmSubscriptionEdit1: TfrmSubscriptionEdit1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077' '#1072#1073#1086#1085#1077#1084#1077#1085#1090#1072
  ClientHeight = 460
  ClientWidth = 480
  Color = 16744448
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lbClient: TLabel
    Left = 24
    Top = 30
    Width = 42
    Height = 15
    Caption = #1050#1083#1080#1077#1085#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblType: TLabel
    Left = 24
    Top = 90
    Width = 92
    Height = 15
    Caption = #1058#1080#1087' '#1072#1073#1086#1085#1077#1084#1077#1085#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbStatDate: TLabel
    Left = 24
    Top = 150
    Width = 68
    Height = 15
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbEndDate: TLabel
    Left = 24
    Top = 210
    Width = 92
    Height = 15
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrice: TLabel
    Left = 24
    Top = 270
    Width = 30
    Height = 15
    Caption = #1062#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cbClient: TComboBox
    Left = 24
    Top = 51
    Width = 430
    Height = 23
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object cbType: TComboBox
    Left = 24
    Top = 111
    Width = 430
    Height = 23
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = cbTypeChange
  end
  object dtStartDate: TDateTimePicker
    Left = 24
    Top = 171
    Width = 250
    Height = 23
    Date = 46046.000000000000000000
    Time = 0.777857129629410300
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object dtEndDate: TDateTimePicker
    Left = 24
    Top = 231
    Width = 250
    Height = 23
    Date = 46046.000000000000000000
    Time = 0.778109363425755900
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object edtPrice: TEdit
    Left = 24
    Top = 291
    Width = 200
    Height = 23
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
  object btnSave: TButton
    Left = 130
    Top = 380
    Width = 100
    Height = 35
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 250
    Top = 380
    Width = 100
    Height = 35
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 6
    OnClick = btnCancelClick
  end
end

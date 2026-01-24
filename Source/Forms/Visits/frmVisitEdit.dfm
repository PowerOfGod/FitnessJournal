object frmVisitEdit1: TfrmVisitEdit1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103' '#1087#1086#1089#1077#1097#1077#1085#1080#1103
  ClientHeight = 361
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblClient: TLabel
    Left = 30
    Top = 8
    Width = 39
    Height = 15
    Caption = #1050#1083#1080#1077#1085#1090
  end
  object lblPhone: TLabel
    Left = 23
    Top = 48
    Width = 48
    Height = 15
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object lblSubscription: TLabel
    Left = 8
    Top = 91
    Width = 62
    Height = 15
    Caption = #1040#1073#1086#1085#1077#1084#1077#1085#1090
  end
  object lblTrainer: TLabel
    Left = 30
    Top = 136
    Width = 39
    Height = 15
    Caption = #1058#1088#1077#1085#1077#1088
  end
  object lblNotes: TLabel
    Left = 23
    Top = 176
    Width = 46
    Height = 15
    Caption = #1047#1072#1084#1077#1090#1082#1080
  end
  object cbClient: TComboBox
    Left = 93
    Top = 8
    Width = 284
    Height = 23
    Style = csDropDownList
    TabOrder = 0
    OnChange = cbClientChange
  end
  object edtPhone: TEdit
    Left = 93
    Top = 45
    Width = 284
    Height = 23
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
    Text = 'edtPhone'
  end
  object edtSubscription: TEdit
    Left = 93
    Top = 88
    Width = 284
    Height = 23
    TabOrder = 2
    Text = 'edtSubscription'
  end
  object memoNotes: TMemo
    Left = 93
    Top = 173
    Width = 284
    Height = 132
    Lines.Strings = (
      'memoNotes')
    MaxLength = 500
    ScrollBars = ssVertical
    TabOrder = 3
    OnChange = memoNotesChange
  end
  object btnEntry: TButton
    Left = 93
    Top = 328
    Width = 75
    Height = 25
    Caption = #1042#1093#1086#1076
    TabOrder = 4
    OnClick = btnEntryClick
  end
  object btnExit: TButton
    Left = 192
    Top = 328
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 5
    OnClick = btnExitClick
  end
  object btnCancel: TButton
    Left = 302
    Top = 328
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object cbTrainer: TComboBox
    Left = 93
    Top = 133
    Width = 284
    Height = 23
    TabOrder = 7
    Text = 'cbTrainer'
  end
end

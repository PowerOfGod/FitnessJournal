object frmVisitEdit1: TfrmVisitEdit1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1089#1077#1097#1077#1085#1080#1077
  ClientHeight = 480
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
  object lblClient: TLabel
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
  object lblPhone: TLabel
    Left = 24
    Top = 90
    Width = 50
    Height = 15
    Caption = #1058#1077#1083#1077#1092#1086#1085
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblSubscription: TLabel
    Left = 24
    Top = 150
    Width = 64
    Height = 15
    Caption = #1040#1073#1086#1085#1077#1084#1077#1085#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblTrainer: TLabel
    Left = 24
    Top = 210
    Width = 41
    Height = 15
    Caption = #1058#1088#1077#1085#1077#1088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblNotes: TLabel
    Left = 24
    Top = 270
    Width = 49
    Height = 15
    Caption = #1047#1072#1084#1077#1090#1082#1080
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
    OnChange = cbClientChange
  end
  object edtPhone: TEdit
    Left = 24
    Top = 111
    Width = 430
    Height = 23
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object edtSubscription: TEdit
    Left = 24
    Top = 171
    Width = 430
    Height = 23
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object cbTrainer: TComboBox
    Left = 24
    Top = 231
    Width = 430
    Height = 23
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object memoNotes: TMemo
    Left = 24
    Top = 291
    Width = 430
    Height = 80
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    MaxLength = 500
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object btnEntry: TButton
    Left = 90
    Top = 400
    Width = 100
    Height = 35
    Caption = #1042#1093#1086#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnEntryClick
  end
  object btnExit: TButton
    Left = 200
    Top = 400
    Width = 100
    Height = 35
    Caption = #1042#1099#1093#1086#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = btnExitClick
  end
  object btnCancel: TButton
    Left = 310
    Top = 400
    Width = 100
    Height = 35
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 7
    OnClick = btnCancelClick
  end
end

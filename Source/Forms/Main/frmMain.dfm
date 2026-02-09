object formMain: TformMain
  Left = 0
  Top = 0
  Caption = #1060#1080#1090#1085#1077#1089'-'#1094#1077#1085#1090#1088': '#1046#1091#1088#1085#1072#1083' '#1087#1086#1089#1077#1097#1077#1085#1080#1081
  ClientHeight = 596
  ClientWidth = 956
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OnCreate = FormCreate
  TextHeight = 15
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 956
    Height = 29
    Caption = 'ToolBar1'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ExplicitWidth = 954
    object btnNewClient: TToolButton
      Left = 0
      Top = 0
      Hint = #1053#1086#1074#1099#1081' '#1082#1083#1080#1077#1085#1090
      Caption = 'btnNewClient'
      ImageIndex = 0
      OnClick = btnNewClientClick
    end
    object ToolButton1: TToolButton
      Left = 23
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object btnNewVisit: TToolButton
      Left = 31
      Top = 0
      Hint = #1053#1086#1074#1086#1077' '#1087#1086#1089#1077#1097#1077#1085#1080#1077
      Caption = 'btnNewVisit'
      ImageIndex = 1
      OnClick = btnNewVisitClick
    end
    object ToolButton2: TToolButton
      Left = 54
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object btnNewSubscription: TToolButton
      Left = 62
      Top = 0
      Hint = #1053#1086#1074#1099#1081' '#1072#1073#1086#1085#1077#1084#1077#1085#1090
      Caption = 'btnNewSubscription'
      ImageIndex = 2
      OnClick = btnNewSubscriptionClick
    end
    object ToolButton3: TToolButton
      Left = 85
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object btnRefresh: TToolButton
      Left = 93
      Top = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100
      Caption = 'btnRefresh'
      ImageIndex = 3
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 29
    Width = 956
    Height = 511
    ActivePage = tsVisits
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 954
    ExplicitHeight = 506
    object tsClients: TTabSheet
      Caption = #1050#1083#1080#1077#1085#1090#1099
      object DBGridClients: TDBGrid
        Left = 0
        Top = 0
        Width = 948
        Height = 481
        Align = alClient
        DataSource = DataSourceClients
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object tsSubscription: TTabSheet
      Caption = #1040#1073#1086#1085#1077#1084#1077#1085#1090#1099
      ImageIndex = 1
      object DBGridSubscriptions: TDBGrid
        Left = 0
        Top = 0
        Width = 953
        Height = 476
        DataSource = DataSourceSubscriptions
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object tsStatistics: TTabSheet
      Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
      ImageIndex = 2
    end
    object tsVisits: TTabSheet
      Caption = #1055#1086#1089#1077#1097#1077#1085#1080#1077
      ImageIndex = 3
      object PanelVisits: TPanel
        Left = 0
        Top = 0
        Width = 948
        Height = 481
        Align = alClient
        Caption = 'PanelVisits'
        TabOrder = 0
        ExplicitWidth = 946
        ExplicitHeight = 476
        object Label1: TLabel
          Left = 19
          Top = 16
          Width = 25
          Height = 15
          Caption = #1044#1072#1090#1072
          ParentShowHint = False
          ShowHint = False
        end
        object DateTimePicker1: TDateTimePicker
          Left = 58
          Top = 8
          Width = 186
          Height = 23
          Date = 46045.000000000000000000
          Time = 0.425898599540232700
          TabOrder = 0
        end
        object Button1: TButton
          Left = 272
          Top = 6
          Width = 75
          Height = 25
          Caption = #1055#1086#1082#1072#1079#1072#1090#1100
          TabOrder = 1
        end
        object DBGridVisits: TDBGrid
          Left = 1
          Top = 1
          Width = 946
          Height = 479
          Align = alClient
          DataSource = DataSourceVisits
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnDblClick = DBGridVisitsDblClick
        end
      end
    end
  end
  object btnTestDB: TButton
    Left = 392
    Top = 24
    Width = 75
    Height = 25
    Caption = #1058#1077#1089#1090' '#1041#1044
    TabOrder = 2
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 540
    Width = 956
    Height = 56
    Panels = <
      item
        Text = #1043#1086#1090#1086#1074
        Width = 150
      end
      item
        Text = #1041#1044': '#1085#1077' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1072
        Width = 150
      end
      item
        Width = 50
      end>
    ExplicitTop = 535
    ExplicitWidth = 954
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 224
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N2: TMenuItem
        Caption = #1042#1099#1093#1086#1076
      end
    end
    object N3: TMenuItem
      Caption = #1054#1087#1077#1088#1072#1094#1080#1080
    end
    object N4: TMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
    end
  end
  object DataSourceClients: TDataSource
    DataSet = FDQueryClients
    Left = 188
    Top = 143
  end
  object FDQueryClients: TFDQuery
    Left = 340
    Top = 191
  end
  object FDQuerySubscriptions: TFDQuery
    Left = 500
    Top = 191
  end
  object FDQueryVisits: TFDQuery
    Left = 476
    Top = 375
  end
  object DataSourceSubscriptions: TDataSource
    DataSet = FDQuerySubscriptions
    Left = 300
    Top = 143
  end
  object DataSourceVisits: TDataSource
    DataSet = FDQueryVisits
    Left = 450
    Top = 143
  end
end

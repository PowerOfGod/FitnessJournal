object formMain: TformMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1060#1080#1090#1085#1077#1089'-'#1094#1077#1085#1090#1088': '#1046#1091#1088#1085#1072#1083' '#1087#1086#1089#1077#1097#1077#1085#1080#1081
  ClientHeight = 596
  ClientWidth = 956
  Color = clBtnFace
  CustomTitleBar.Height = 5
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 5
  GlassFrame.Bottom = 5
  Menu = MainMenu1
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PanelToolbar: TPanel
    Left = 0
    Top = 0
    Width = 956
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object btnNewClient: TButton
      Left = 8
      Top = 6
      Width = 115
      Height = 33
      Caption = #226#158#149' '#1053#1086#1074#1099#1081' '#1082#1083#1080#1077#1085#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnNewClientClick
    end
    object btnNewVisit: TButton
      Left = 129
      Top = 6
      Width = 115
      Height = 33
      Caption = #240#159#154#170' '#1042#1093#1086#1076'/'#1042#1099#1093#1086#1076
      TabOrder = 1
      OnClick = btnNewVisitClick
    end
    object btnNewSubscription: TButton
      Left = 250
      Top = 6
      Width = 115
      Height = 33
      Caption = #240#159#147#139' '#1040#1073#1086#1085#1077#1084#1077#1085#1090
      TabOrder = 2
      OnClick = btnNewSubscriptionClick
    end
    object btnRefresh: TButton
      Left = 371
      Top = 6
      Width = 115
      Height = 33
      Caption = #240#159#148#132' '#1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 3
      OnClick = btnRefreshClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 45
    Width = 956
    Height = 495
    ActivePage = tsStatistics
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    Style = tsButtons
    TabHeight = 30
    TabOrder = 1
    TabWidth = 120
    OnChange = PageControl1Change
    object tsClients: TTabSheet
      Caption = #1050#1083#1080#1077#1085#1090#1099
      object PanelClientSearch: TPanel
        Left = 0
        Top = 0
        Width = 948
        Height = 45
        Align = alTop
        BevelOuter = bvNone
        Color = clGradientInactiveCaption
        ParentBackground = False
        TabOrder = 1
        object lblSearch: TLabel
          Left = 16
          Top = 15
          Width = 40
          Height = 15
          Caption = #1055#1086#1080#1089#1082':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edtSearch: TEdit
          Left = 72
          Top = 12
          Width = 200
          Height = 21
          TabOrder = 0
        end
        object btnClearSearch: TButton
          Left = 280
          Top = 11
          Width = 75
          Height = 25
          Cursor = crHandPoint
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100
          TabOrder = 1
        end
        object rbName: TRadioButton
          Left = 376
          Top = 12
          Width = 65
          Height = 17
          Caption = #1055#1086' '#1060#1048#1054
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object rbPhone: TRadioButton
          Left = 456
          Top = 12
          Width = 90
          Height = 17
          Caption = #1055#1086' '#1090#1077#1083#1077#1092#1086#1085#1091
          TabOrder = 3
        end
        object rbEmail: TRadioButton
          Left = 552
          Top = 12
          Width = 90
          Height = 17
          Caption = #1055#1086' Email'
          TabOrder = 4
        end
      end
      object DBGridClients: TDBGrid
        Left = 0
        Top = 45
        Width = 948
        Height = 410
        Align = alClient
        DataSource = DataSourceClients
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = [fsBold]
        OnDblClick = DBGridClientsDblClick
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
        TitleFont.Height = -11
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = [fsBold]
      end
    end
    object tsStatistics: TTabSheet
      Caption = #1056#1038#1057#8218#1056#176#1057#8218#1056#1105#1057#1027#1057#8218#1056#1105#1056#1108#1056#176
      ImageIndex = 2
    end
    object tsVisits: TTabSheet
      Caption = #1055#1086#1089#1077#1097#1077#1085#1080#1077
      ImageIndex = 3
      object PanelVisits: TPanel
        Left = 0
        Top = 0
        Width = 948
        Height = 455
        Align = alClient
        Caption = 'PanelVisits'
        TabOrder = 0
        object Label1: TLabel
          Left = 19
          Top = 16
          Width = 26
          Height = 13
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
          Height = 453
          Align = alClient
          DataSource = DataSourceVisits
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = [fsBold]
          OnDblClick = DBGridVisitsDblClick
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 540
    Width = 956
    Height = 56
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    Panels = <
      item
        Text = '['#1074#8364#1113'] '#1056#8220#1056#1109#1057#8218#1056#1109#1056#1030
        Width = 200
      end
      item
        Text = '['#1056#8216#1056#8221'] '#1056#1029#1056#181' '#1056#1111#1056#1109#1056#1169#1056#1108#1056#187#1057#1035#1057#8225#1056#181#1056#1029#1056#176
        Width = 250
      end
      item
        Text = '[i] '#1056#1038#1057#8218#1056#176#1057#8218#1056#1105#1057#1027#1057#8218#1056#1105#1056#1108#1056#176
        Width = 300
      end>
    UseSystemFont = False
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
    object mnReports: TMenuItem
      Caption = #1054#1090#1095#1077#1090#1099
      object mnClientsReport: TMenuItem
        Caption = #1057#1087#1080#1089#1086#1082' '#1082#1083#1080#1077#1085#1090#1086#1074
        OnClick = mnClientsReportClick
      end
      object mnSubscriptionsReport: TMenuItem
        Caption = #1040#1073#1086#1085#1077#1084#1077#1085#1090#1099
        OnClick = mnSubscriptionsReportClick
      end
      object mnVisitsReport: TMenuItem
        Caption = #1055#1086#1089#1077#1097#1077#1085#1080#1103
        OnClick = mnVisitsReportClick
      end
      object mnTrainerReport: TMenuItem
        Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1086' '#1090#1088#1077#1085#1077#1088#1072#1084
        OnClick = mnTrainerReportClick
      end
      object mnExportExcel: TMenuItem
        Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' Excel'
        OnClick = mnExportExcelClick
      end
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

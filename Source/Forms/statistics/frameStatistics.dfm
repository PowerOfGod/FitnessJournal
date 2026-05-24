object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 900
  Height = 600
  TabOrder = 0
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 28
      Width = 48
      Height = 15
      Caption = #1055#1077#1088#1080#1086#1076':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 250
      Top = 28
      Width = 9
      Height = 15
      Caption = #1089':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 400
      Top = 28
      Width = 17
      Height = 15
      Caption = #1087#1086':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object cmbPeriod: TComboBox
      Left = 80
      Top = 24
      Width = 150
      Height = 23
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = cmbPeriodChange
    end
    object dtpDateFrom: TDateTimePicker
      Left = 270
      Top = 24
      Width = 120
      Height = 30
      Date = 46070.000000000000000000
      Time = 0.471912002314638800
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = dtpDateFromChange
    end
    object dtpDateTo: TDateTimePicker
      Left = 420
      Top = 24
      Width = 120
      Height = 30
      Date = 46070.000000000000000000
      Time = 0.472055081016151200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnChange = dtpDateToChange
    end
    object btnRefresh: TButton
      Left = 560
      Top = 22
      Width = 100
      Height = 32
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnRefreshClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 70
    Width = 900
    Height = 511
    ActivePage = tabGeneral
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabHeight = 30
    TabOrder = 1
    TabWidth = 120
    object tabGeneral: TTabSheet
      Caption = #1056#1115#1056#177#1057#8240#1056#176#1057#1039' '#1057#1027#1057#8218#1056#176#1057#8218#1056#1105#1057#1027#1057#8218#1056#1105#1056#1108#1056#176
      object MemoStats: TMemo
        Left = 0
        Top = 0
        Width = 892
        Height = 220
        Align = alTop
        Color = 16777197
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object gridDaily: TDBGrid
        Left = 0
        Top = 220
        Width = 892
        Height = 251
        Align = alClient
        DataSource = dsDaily
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = [fsBold]
      end
    end
    object tabTrainer: TTabSheet
      Caption = #1055#1086' '#1090#1088#1077#1085#1077#1088#1072#1084
      ImageIndex = 1
      object gridTrainer: TDBGrid
        Left = 0
        Top = 0
        Width = 892
        Height = 481
        Align = alClient
        DataSource = dsTrainer
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = [fsBold]
      end
    end
    object tabHourly: TTabSheet
      Caption = #1055#1086' '#1095#1072#1089#1072#1084
      ImageIndex = 2
      object gridHourly: TDBGrid
        Left = 0
        Top = 0
        Width = 892
        Height = 481
        Align = alClient
        DataSource = dsHourly
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = [fsBold]
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 581
    Width = 900
    Height = 19
    Panels = <
      item
        Text = #1043#1086#1090#1086#1074
        Width = 200
      end
      item
        Text = #1042#1089#1077#1075#1086': 0'
        Width = 150
      end>
  end
  object dsDaily: TDataSource
    Left = 80
    Top = 160
  end
  object dsTrainer: TDataSource
    Left = 160
    Top = 160
  end
  object dsHourly: TDataSource
    Left = 240
    Top = 160
  end
  object qryDaily: TFDQuery
    Left = 80
    Top = 220
  end
  object qryTrainer: TFDQuery
    Left = 160
    Top = 220
  end
  object qryHourly: TFDQuery
    Left = 240
    Top = 220
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = Timer1Timer
    Left = 320
    Top = 160
  end
end

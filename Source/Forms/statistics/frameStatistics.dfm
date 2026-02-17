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
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 28
      Width = 45
      Height = 15
      Caption = #1055#1077#1088#1080#1086#1076':'
    end
    object Label2: TLabel
      Left = 250
      Top = 28
      Width = 9
      Height = 15
      Caption = #1089':'
    end
    object Label3: TLabel
      Left = 400
      Top = 28
      Width = 17
      Height = 15
      Caption = #1087#1086':'
    end
    object cmbPeriod: TComboBox
      Left = 80
      Top = 24
      Width = 150
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbPeriodChange
    end
    object dtpDateFrom: TDateTimePicker
      Left = 270
      Top = 25
      Width = 120
      Height = 23
      Date = 46070.000000000000000000
      Time = 0.471912002314638800
      TabOrder = 1
      OnChange = dtpDateFromChange
    end
    object dtpDateTo: TDateTimePicker
      Left = 420
      Top = 25
      Width = 120
      Height = 23
      Date = 46070.000000000000000000
      Time = 0.472055081016151200
      TabOrder = 2
      OnChange = dtpDateToChange
    end
    object btnRefresh: TButton
      Left = 560
      Top = 25
      Width = 100
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 3
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 70
    Width = 900
    Height = 511
    ActivePage = tabGeneral
    Align = alClient
    TabOrder = 1
    object tabGeneral: TTabSheet
      Caption = #1054#1073#1097#1072#1103' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072
      object MemoStats: TMemo
        Left = 0
        Top = 0
        Width = 892
        Height = 120
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object gridDaily: TDBGrid
        Left = 0
        Top = 120
        Width = 892
        Height = 361
        Align = alClient
        DataSource = dsDaily
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object tabTrainer: TTabSheet
      Caption = #1055#1086' '#1090#1088#1077#1085#1077#1088#1072#1084
      ImageIndex = 1
      object PanelLeft: TPanel
        Left = 0
        Top = 0
        Width = 400
        Height = 481
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object gridTrainer: TDBGrid
          Left = 0
          Top = 0
          Width = 400
          Height = 481
          Align = alClient
          DataSource = dsTrainer
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
      object PanelRight: TPanel
        Left = 400
        Top = 0
        Width = 492
        Height = 481
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
      end
    end
    object tabHourly: TTabSheet
      Caption = #1055#1086' '#1095#1072#1089#1072#1084
      ImageIndex = 2
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
    Left = 320
    Top = 160
  end
end

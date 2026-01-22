object Form1: TForm1
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 900
    Height = 29
    ButtonWidth = 31
    Caption = 'ToolBar1'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ExplicitWidth = 898
    object btnNewVisit: TToolButton
      Left = 0
      Top = 0
      Hint = #1053#1086#1074#1086#1077' '#1087#1086#1089#1077#1097#1077#1085#1080#1077
      Caption = 'btnNewVisit'
      ImageIndex = 0
    end
    object btnClientExit: TToolButton
      Left = 31
      Top = 0
      Hint = #1042#1099#1093#1086#1076' '#1082#1083#1080#1077#1085#1090#1072
      Caption = 'btnClientExit'
      ImageIndex = 1
    end
    object ToolButtonSep1: TToolButton
      Left = 62
      Top = 0
      Width = 8
      Caption = 'ToolButtonSep1'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object btnNewClient: TToolButton
      Left = 70
      Top = 0
      Hint = #1053#1086#1074#1099#1081' '#1082#1083#1080#1077#1085#1090
      Caption = 'btnNewClient'
      ImageIndex = 2
    end
    object btnEditClient: TToolButton
      Left = 101
      Top = 0
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1082#1083#1080#1077#1085#1090#1072
      Caption = 'btnEditClient'
      ImageIndex = 3
    end
    object ToolButtonSep2: TToolButton
      Left = 132
      Top = 0
      Width = 8
      Caption = 'ToolButtonSep2'
      ImageIndex = 4
      Style = tbsSeparator
    end
    object btnNewSubscription: TToolButton
      Left = 140
      Top = 0
      Hint = #1053#1086#1074#1099#1081' '#1072#1073#1086#1085#1077#1084#1077#1085#1090
      ImageIndex = 4
    end
    object ToolButtonSep3: TToolButton
      Left = 171
      Top = 0
      Width = 8
      Caption = 'ToolButtonSep3'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object btnRefresh: TToolButton
      Left = 179
      Top = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Caption = 'btnRefresh'
      ImageIndex = 5
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 29
    Width = 900
    Height = 571
    ActivePage = tsVisit
    Align = alClient
    HotTrack = True
    TabOrder = 1
    ExplicitWidth = 898
    ExplicitHeight = 566
    object tsVisit: TTabSheet
      Caption = #1055#1086#1089#1077#1097#1077#1085#1080#1103
      object PanelVisits: TPanel
        Left = 0
        Top = 0
        Width = 892
        Height = 543
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 890
        ExplicitHeight = 538
        object PanelVisitsTop: TPanel
          Left = 0
          Top = 0
          Width = 892
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 890
          object lblVisitDate: TLabel
            Left = 27
            Top = 16
            Width = 88
            Height = 19
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1077#1097#1077#1085#1080#1103
          end
          object dtVisitDate: TDateTimePicker
            Left = 131
            Top = 14
            Width = 105
            Height = 21
            Date = 44871.000000000000000000
            Time = 0.764218240736227000
            TabOrder = 0
          end
          object btnShowVisits: TButton
            Left = 242
            Top = 10
            Width = 75
            Height = 25
            Caption = #1055#1086#1082#1072#1079#1072#1090#1100
            TabOrder = 1
          end
        end
        object PanelVisitsGrid: TPanel
          Left = 0
          Top = 41
          Width = 892
          Height = 458
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitWidth = 890
          ExplicitHeight = 453
          object dbgVisits: TDBGrid
            Left = 0
            Top = 0
            Width = 892
            Height = 430
            Align = alClient
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
          end
          object StatusBar: TStatusBar
            Left = 0
            Top = 430
            Width = 892
            Height = 28
            Panels = <
              item
                Text = #1043#1086#1090#1086#1074
                Width = 200
              end
              item
                Text = #1041#1044': '#1085#1077' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1085#1072
                Width = 150
              end
              item
                Width = 50
              end>
            ExplicitTop = 439
          end
        end
        object PanelVisitsStats: TPanel
          Left = 0
          Top = 499
          Width = 892
          Height = 44
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitTop = 494
          ExplicitWidth = 890
          object lblTotalToday: TLabel
            Left = 16
            Top = 15
            Width = 107
            Height = 13
            Caption = #1055#1086#1089#1077#1097#1077#1085#1080#1081' '#1089#1077#1075#1086#1076#1085#1103
          end
          object lblTotalVisits: TLabel
            Left = 131
            Top = 15
            Width = 7
            Height = 13
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblActiveToday: TLabel
            Left = 200
            Top = 15
            Width = 104
            Height = 13
            Caption = #1040#1082#1090#1080#1074#1085#1099#1093' '#1082#1083#1080#1077#1085#1090#1086#1074
          end
          object lblActiveClients: TLabel
            Left = 310
            Top = 15
            Width = 7
            Height = 13
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblCurrentInGym: TLabel
            Left = 400
            Top = 15
            Width = 109
            Height = 13
            Caption = #1057#1077#1081#1095#1072#1089' '#1074' '#1079#1072#1083#1077' ('#1074#1093#1086#1076'):'
          end
          object lblCurrentCount: TLabel
            Left = 517
            Top = 15
            Width = 7
            Height = 13
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
    object tsClients: TTabSheet
      Caption = #1050#1083#1080#1077#1085#1090#1099
      ImageIndex = 1
      object PanelClients: TPanel
        Left = 0
        Top = 0
        Width = 892
        Height = 543
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object PanelClientsTop: TPanel
          Left = 0
          Top = 0
          Width = 892
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblClientSearch: TLabel
            Left = 16
            Top = 14
            Width = 33
            Height = 13
            Caption = #1055#1086#1080#1089#1082
          end
          object edtClientSearch: TEdit
            Left = 67
            Top = 11
            Width = 200
            Height = 21
            TabOrder = 0
          end
          object btnSearchClient: TButton
            Left = 273
            Top = 9
            Width = 75
            Height = 25
            Caption = #1053#1072#1081#1090#1080
            TabOrder = 1
          end
        end
        object PanelClientsGrid: TPanel
          Left = 0
          Top = 41
          Width = 892
          Height = 502
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object dbgClients: TDBGrid
            Left = 0
            Top = 0
            Width = 892
            Height = 502
            Align = alClient
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
          end
        end
      end
    end
    object tsSubscriptions: TTabSheet
      Caption = #1040#1073#1086#1085#1077#1084#1077#1085#1090
      ImageIndex = 2
    end
  end
  object ImageList: TImageList
    Left = 432
    Top = 232
  end
end

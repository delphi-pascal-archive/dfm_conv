object FrmMain: TFrmMain
  Left = 242
  Top = 131
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' DFM'
  ClientHeight = 417
  ClientWidth = 721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC7777CCCCCCC0000CCCC00000000CCCC7777CCCCCCCC
    C0000CCCCCCCCCCCCCC7777CCCCC0CCCCC0000CCCCCCCCCCCC7777CCCCC700CC
    C00CCCC0000000000CCCC77CCC77000C0000CCCC00000000CCCC7777C7770000
    00000CCCC000000CCCC777777777C000C00000CCCC0000CCCC77777C777CCC00
    CC00000CCCCCCCCCC77777CC77CCCCC0CCC000CCCCC00CCCCC777CCC7CCCCCCC
    CCCC0CCCCCCCCCCCCCC7CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC7CCC70CCC
    00CCCCCCCC0CC0CCCCCCCC77CC7700CC000CCCCCC000000CCCCCC777CC7700CC
    0000CCCC00000000CCCC7777CC7700CC0000C0CCC000000CCC7C7777CC7700CC
    0000C0CCC000000CCC7C7777CC7700CC0000CCCC00000000CCCC7777CC7700CC
    000CCCCCC000000CCCCCC777CC7700CC00CCCCCCCC0CC0CCCCCCCC77CC770CCC
    0CCCCCCCCCCCCCCCCCCCCCC7CCC7CCCCCCCC0CCCCCCCCCCCCCC7CCCCCCCCCCC0
    CCC000CCCCC00CCCCC777CCC7CCCCC00CC00000CCCCCCCCCC77777CC77CCC000
    C00000CCCC0000CCCC77777C777C000000000CCCC000000CCCC777777777000C
    0000CCCC00000000CCCC7777C77700CCC00CCCC0000000000CCCC77CCC770CCC
    CC0000CCCCCCCCCCCC7777CCCCC7CCCCC0000CCCCCCCCCCCCCC7777CCCCCCCCC
    0000CCCC00000000CCCC7777CCCCCCC0000CCCC0000000000CCCC7777CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object TLabel
    Left = 482
    Top = 10
    Width = 3
    Height = 16
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 721
    Height = 398
    ActivePage = tsSingle
    Align = alClient
    TabOrder = 2
    object tsSingle: TTabSheet
      Caption = #1054#1076#1080#1085' '#1092#1072#1081#1083
      OnShow = tsSingleShow
      object Label1: TLabel
        Left = 10
        Top = 20
        Width = 108
        Height = 16
        Alignment = taRightJustify
        Caption = '&'#1048#1089#1093#1086#1076#1085#1099#1081' '#1092#1072#1081#1083
      end
      object Label2: TLabel
        Left = 10
        Top = 63
        Width = 108
        Height = 16
        Alignment = taRightJustify
        Caption = '&'#1050#1086#1085#1077#1095#1085#1099#1081' '#1092#1072#1081#1083
      end
      object Label3: TLabel
        Left = 138
        Top = 89
        Width = 422
        Height = 16
        Caption = #1045#1089#1083#1080' '#1085#1077' '#1091#1082#1072#1079#1072#1085', '#1074' '#1082#1072#1095#1077#1089#1090#1074#1077' '#1082#1086#1085#1077#1095#1085#1086#1075#1086' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1080#1089#1093#1086#1076#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object btnStart: TButton
        Left = 610
        Top = 20
        Width = 80
        Height = 70
        Caption = '&'#1057#1090#1072#1088#1090
        TabOrder = 0
        OnClick = btnStartClick
      end
      object Edit1: TEdit
        Left = 138
        Top = 20
        Width = 415
        Height = 24
        TabOrder = 1
      end
      object btnSource: TButton
        Left = 561
        Top = 20
        Width = 31
        Height = 30
        Caption = '...'
        TabOrder = 2
        OnClick = btnSourceClick
      end
      object Edit2: TEdit
        Left = 138
        Top = 59
        Width = 415
        Height = 24
        TabOrder = 3
      end
      object btnDest: TButton
        Left = 561
        Top = 59
        Width = 31
        Height = 31
        Caption = '...'
        TabOrder = 4
        OnClick = btnDestClick
      end
    end
    object tsMulti: TTabSheet
      Caption = #1052#1085#1086#1075#1086' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 1
      OnShow = tsMultiShow
      object lbxFileNames: TListBox
        Left = 20
        Top = 20
        Width = 670
        Height = 267
        ItemHeight = 16
        MultiSelect = True
        TabOrder = 0
      end
      object btnAdd: TButton
        Left = 20
        Top = 305
        Width = 92
        Height = 31
        Caption = '&'#1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 1
        OnClick = btnAddClick
      end
      object btnRemove: TButton
        Left = 118
        Top = 305
        Width = 92
        Height = 31
        Caption = '&'#1048#1089#1082#1083#1102#1095#1080#1090#1100
        TabOrder = 2
        OnClick = btnRemoveClick
      end
      object btnMultiStart: TButton
        Left = 502
        Top = 305
        Width = 92
        Height = 31
        Caption = '&'#1057#1090#1072#1088#1090
        Default = True
        TabOrder = 4
        OnClick = btnMultiStartClick
      end
      object btnLog: TButton
        Left = 601
        Top = 305
        Width = 92
        Height = 31
        Caption = '&'#1051#1086#1075
        TabOrder = 5
        OnClick = btnLogClick
      end
      object btnRemoveAll: TButton
        Left = 217
        Top = 305
        Width = 92
        Height = 31
        Caption = #1048#1089#1082#1083' &'#1042#1089#1077
        TabOrder = 3
        OnClick = btnRemoveAllClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 2
      OnShow = TabSheet1Show
      object cbBackup: TCheckBox
        Left = 20
        Top = 12
        Width = 269
        Height = 21
        Caption = #1057#1086#1079#1076#1072#1074#1072#1090#1100' &bak-'#1092#1072#1081#1083' '#1087#1088#1080' '#1079#1072#1084#1077#1085#1077
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object cbBin2Text: TCheckBox
        Left = 20
        Top = 62
        Width = 245
        Height = 21
        Caption = '&'#1044#1074#1086#1080#1095#1085#1099#1081' '#1092#1072#1081#1083' -> '#1058#1077#1082#1089#1090#1086#1074#1099#1081
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object cbCode2Char: TCheckBox
        Left = 20
        Top = 36
        Width = 261
        Height = 21
        Caption = #1050#1086#1076#1099' &Unicode -> '#1089#1080#1084#1074#1086#1083#1099' WIN1251'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 398
    Width = 721
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object plCopyleft: TPanel
    Left = 304
    Top = 0
    Width = 416
    Height = 21
    Alignment = taRightJustify
    BevelOuter = bvNone
    Caption = 'plCopyleft'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object MultiOpenDialog: TOpenDialog
    Filter = 'DFM '#1092#1072#1081#1083#1099' (*.dfm)|*.dfm|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 360
    Top = 64
  end
  object SaveDialog1: TSaveDialog
    Filter = 'DFM '#1092#1072#1081#1083#1099' (*.dfm)|*.dfm|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Left = 328
    Top = 64
  end
  object SingleOpenDialog: TOpenDialog
    Filter = 'DFM '#1092#1072#1081#1083#1099' (*.dfm)|*.dfm|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 296
    Top = 64
  end
end

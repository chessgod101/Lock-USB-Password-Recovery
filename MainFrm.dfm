object LockUSBFrmMain: TLockUSBFrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Lock USB PW Recovery'
  ClientHeight = 102
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 29
    Top = 19
    Width = 29
    Height = 13
    Caption = 'Drive:'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 50
    Height = 13
    Caption = 'Password:'
  end
  object DriveComboBox: TComboBox
    Left = 64
    Top = 16
    Width = 152
    Height = 21
    TabOrder = 0
  end
  object PswEdit: TEdit
    Left = 64
    Top = 45
    Width = 233
    Height = 21
    TabOrder = 1
    Text = 'Click Recover....'
  end
  object RecoverBtn: TButton
    Left = 8
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Recover'
    TabOrder = 2
    OnClick = RecoverBtnClick
  end
  object RefreshBtn: TButton
    Left = 222
    Top = 14
    Width = 75
    Height = 25
    Caption = 'Refresh'
    TabOrder = 3
    OnClick = RefreshBtnClick
  end
  object AboutBtn: TButton
    Left = 222
    Top = 72
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 4
    OnClick = AboutBtnClick
  end
end

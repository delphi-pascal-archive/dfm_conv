unit propman;

interface

uses
  Unit1, Unit2,
  Windows, Sysutils, inifiles;

procedure LoadProps;
procedure SaveProps;

implementation

const
  sIniExt = '.ini';

function GetIniFileName: string;
begin
  result:= ChangeFileExt(ParamStr(0),sIniExt);
end;

// Восстановление из ini свойств
procedure LoadProps;
var ini: TIniFile;
begin
  ini:= TIniFile.Create(GetIniFileName);
  try
    FrmMain.MultiOpenDialog.InitialDir:= ini.ReadString('FrmMain','MultiOpenDialog.InitialDir','');
    FrmMain.SingleOpenDialog.InitialDir:= ini.ReadString('FrmMain','SingleOpenDialog.InitialDir','');
    FrmMain.SaveDialog1.InitialDir:= ini.ReadString('FrmMain','SaveDialog1.InitialDir','');
    FrmMain.PageControl.ActivePageIndex:= ini.ReadInteger('FrmMain','PageControl.ActivePageIndex',0);
    FrmMain.cbBackup.Checked:= ini.ReadBool('FrmMain','cbBackup.Checked',true);
    FrmMain.cbCode2Char.Checked:= ini.ReadBool('FrmMain','cbCode2Char.Checked',true);
    FrmMain.cbBin2Text.Checked:= ini.ReadBool('FrmMain','cbBin2Text.Checked',true);
    frmLog.LogSaveDialog.InitialDir:= ini.ReadString('frmLog','LogSaveDialog.InitialDir','');
  finally
    ini.Free;
  end;
end;

// Сохранение в ini свойств
procedure SaveProps;
var ini: TIniFile;
begin
  ini:= TIniFile.Create(GetIniFileName);
  try
    ini.WriteString('FrmMain','MultiOpenDialog.InitialDir',FrmMain.MultiOpenDialog.InitialDir);
    ini.WriteString('FrmMain','SingleOpenDialog.InitialDir',FrmMain.SingleOpenDialog.InitialDir);
    ini.WriteString('FrmMain','SaveDialog1.InitialDir',FrmMain.SaveDialog1.InitialDir);
    ini.WriteInteger('FrmMain','PageControl.ActivePageIndex',FrmMain.PageControl.ActivePageIndex);
    ini.WriteBool('FrmMain','cbBackup.Checked',FrmMain.cbBackup.Checked);
    ini.WriteBool('FrmMain','cbCode2Char.Checked',FrmMain.cbCode2Char.Checked);
    ini.WriteBool('FrmMain','cbBin2Text.Checked',FrmMain.cbBin2Text.Checked);
    ini.WriteString('frmLog','LogSaveDialog.InitialDir',frmLog.LogSaveDialog.InitialDir);
  finally
    ini.Free;
  end;
end;

end.

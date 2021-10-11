unit Unit1;

interface

uses
  myutils, Unit2, pars,
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,
  math, StdCtrls, ExtCtrls, ComCtrls;

type
  TFrmMain = class(TForm)
    MultiOpenDialog: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StatusBar: TStatusBar;
    SingleOpenDialog: TOpenDialog;
    plCopyleft: TPanel;
    PageControl: TPageControl;
    tsSingle: TTabSheet;
    Label1: TLabel;
    btnStart: TButton;
    Edit1: TEdit;
    btnSource: TButton;
    Edit2: TEdit;
    btnDest: TButton;
    tsMulti: TTabSheet;
    lbxFileNames: TListBox;
    btnAdd: TButton;
    btnRemove: TButton;
    btnMultiStart: TButton;
    btnLog: TButton;
    btnRemoveAll: TButton;
    Label2: TLabel;
    TabSheet1: TTabSheet;
    cbBackup: TCheckBox;
    cbBin2Text: TCheckBox;
    cbCode2Char: TCheckBox;
    Label3: TLabel;
    procedure btnStartClick(Sender: TObject);
    procedure btnSourceClick(Sender: TObject);
    procedure btnDestClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tsSingleShow(Sender: TObject);
    procedure tsMultiShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnLogClick(Sender: TObject);
    procedure btnMultiStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnRemoveAllClick(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
  private
    FFileNames: TStringList;
    FErrorCount: integer;
    function BackupFileName(FileName: string): string;
    procedure AddStatusError(const msg, SourceFileName, DestFileName: string);
    procedure AddStatusOK(const SourceFileName, DestFileName: string);
    procedure WriteStatus(const Msg: string);
    procedure Convert(const SourceFileName, DestFileName: string);
    function MultiMode: boolean;
    //преобразует длинное имя файла к виду C:\...ir\file.ext
    function CutFileName(s: string): string;
    //преобразует двоичный файл в текстовый
    function ConvBin2Text(const SourceFileName, DestFileName: string): boolean;
    //преобразует текстовый файл Unicode в текстовый файл Win1251
    procedure ConvText2Text(const SourceFileName, DestFileName: string);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.DFM}

const
  sCopyleft = 'Версия %s - Copyleft 2004 Антон Рыбалко - boldfish@list.ru ';

  sfStatus      = 'Статус: %s';
  sfErrorLog    = 'Ошибка'#9'%s'#13#10#9'%s'; // Error/tDestFileName/n/tmsg
  sfOKLog       = 'OK'#9'%s'; // OK/tDestFileName
  sOKStatus     = 'OK';
  sfHaveErrors  = 'Есть ошибки (%d)';
  sError        = 'Ошибка';
  sBakExt       = '.bak';
  sProcess      = 'Процесс преобразования...';

  SingleHeight = 166;
  MultiHeight  = 423;

function IsTextDfm(FileName: String; Stream: TMemoryStream): Boolean;
//On the basis of Markus Stephan algorithm (http://www.mirkes.de/eng/)
const
  StrLen = 9;
type
  Str9 = String[StrLen];
const
  FirstStrings : array[1..3] of Str9 =
  ('OBJECT', 'INLINE', 'INHERITED');
var
  FreeStream: Boolean;
  ObjName: Str9;
  i: integer;
begin
  FreeStream:= (Stream=nil);
  Result:= false;
  if FreeStream then
  begin
    Stream:= TMemoryStream.Create;
    Stream.LoadFromFile(FileName);
  end;
  Stream.Position:=0;
  SetLength(ObjName, StrLen);
  repeat
    Stream.ReadBuffer(ObjName[1], 1);
  until (Ord(ObjName[1])>32) or (Stream.Position>=Stream.Size-1);
  if (Stream.Size-Stream.Position>StrLen) and (Ord(ObjName[1])>32) then
  begin
    Stream.ReadBuffer(ObjName[2], StrLen-1);
    for i:=1 to 3 do
    begin
      Result:= (Pos(FirstStrings[i], UpperCase(ObjName))=1);
      if Result then Break;
    end;
  end;
  if FreeStream then Stream.Free;
end;

procedure TFrmMain.btnStartClick(Sender: TObject);
begin
  if Edit1.Text = '' then
    MessageBox(Handle, 'Введите имя исходного файла', sError, MB_OK + MB_ICONERROR)
  else if Edit2.Text = '' then
    Convert(Edit1.Text, Edit1.Text)
  else
    Convert(Edit1.Text, Edit2.Text);
end;

procedure TFrmMain.btnSourceClick(Sender: TObject);
begin
  if SingleOpenDialog.Execute then begin
    Edit1.Text:= SingleOpenDialog.FileName;
    SingleOpenDialog.InitialDir:= ExtractFileDir(SingleOpenDialog.FileName);
  end
end;

procedure TFrmMain.btnDestClick(Sender: TObject);
begin
  if SaveDialog1.Execute then begin
    Edit2.Text:= SaveDialog1.FileName;
    SaveDialog1.InitialDir:= ExtractFileDir(SaveDialog1.FileName);
  end;
end;

function TFrmMain.BackupFileName(FileName: string): string;
(*var ext: string;*)
begin
(*  ext:= ExtractFileExt(FileName);
  Insert('~',ext,2);
  result:= ChangeFileExt(FileName,ext);*)
  result:=FileName+sBakExt;
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
  btnSource.Height:=Edit1.Height;
  btnSource.Width:=btnSource.Height;
  btnDest.Height:=Edit2.Height;
  btnDest.Width:=btnDest.Height;
  btnStart.Height:=btnDest.Height+btnDest.Top-btnSource.Top;
end;

procedure TFrmMain.AddStatusError(const msg, SourceFileName, DestFileName: string);
begin
  if MultiMode then begin
    frmLog.AddLogLine(Format(sfErrorLog,[DestFileName,msg]));
    inc(FErrorCount);
  end else begin
    MessageBox(Handle, PAnsiChar(msg), sError, MB_OK + MB_ICONERROR);
    WriteStatus(sError);
  end;
end;

procedure TFrmMain.AddStatusOK(const SourceFileName, DestFileName: string);
begin
  if MultiMode then
    frmLog.AddLogLine(Format(sfOKLog,[DestFileName]))
  else
    WriteStatus(sOKStatus);
end;

procedure TFrmMain.tsSingleShow(Sender: TObject);
begin
  Height:=SingleHeight;
end;

procedure TFrmMain.tsMultiShow(Sender: TObject);
begin
  Height:=MultiHeight;
end;

procedure TFrmMain.btnAddClick(Sender: TObject);
var i: integer;
begin
  if MultiOpenDialog.Execute then begin
    for i:= 0 to MultiOpenDialog.Files.Count-1 do
      if FFileNames.IndexOf(MultiOpenDialog.Files[i])<0 then begin
        FFileNames.Add(MultiOpenDialog.Files[i]);
        lbxFileNames.Items.Add(CutFileName(MultiOpenDialog.Files[i]));
      end;
    MultiOpenDialog.InitialDir:= ExtractFileDir(MultiOpenDialog.FileName);
  end;
end;

procedure TFrmMain.btnRemoveClick(Sender: TObject);
var i: integer;
begin
  if lbxFileNames.SelCount>0 then
  begin
    i:= 0;
    while(i<lbxFileNames.Items.Count) do
    begin
      if lbxFileNames.Selected[i] then begin
        FFileNames.Delete(i);
        lbxFileNames.Items.Delete(i);
      end else
        inc(i);
    end;
  end;
end;

procedure TFrmMain.Convert(const SourceFileName, DestFileName: string);
begin
  // Making backup
  if (cbBackup.Checked) and (FileExists(DestFileName)) then
    CopyFile(PAnsiChar(SourceFileName), PAnsiChar((BackupFileName(DestFileName))), false);

  if cbBin2Text.Checked then
    ConvBin2Text(SourceFileName, DestFileName);

  if cbCode2Char.Checked and IsTextDfm(SourceFileName, nil) then
    ConvText2Text(SourceFileName,DestFileName);
end;

procedure TFrmMain.btnLogClick(Sender: TObject);
begin
  frmLog.Show;
end;

procedure TFrmMain.btnMultiStartClick(Sender: TObject);
var
  i: integer;
begin
  WriteStatus(sProcess);
  frmLog.ClearLog;
  FErrorCount:= 0;
  for i:= 0 to FFileNames.Count-1 do
    Convert(FFileNames[i],FFileNames[i]);
  if FErrorCount=0 then
    WriteStatus(sOKStatus)
  else
    WriteStatus(Format(sfHaveErrors,[FErrorCount]));
end;

function TFrmMain.MultiMode: boolean;
begin
  result:= PageControl.ActivePage=tsMulti;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FFileNames:= TStringList.Create;
  plCopyleft.Caption:= Format(sCopyleft,
    [GetAppVersionStr(true,true,false,false)]);
  WriteStatus('');
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FFileNames.Free;
end;

function TFrmMain.CutFileName(s: string): string;

function BigSize: boolean;
begin
  result:= lbxFileNames.Canvas.TextWidth(s)>lbxFileNames.ClientWidth-20;
end;

var p,max: integer;
begin
  if BigSize then begin
    p:= Pos('\',s);
    max:= length(s)-length(ExtractFileName(s));
    if (p>0)and(p+3<max) then begin
      Delete(s,p+1,3);
      Insert('...',s,p+1);
      inc(p,4);
      while (p<max)and(BigSize) do
      begin
        Delete(s,p,1);
        dec(max);
      end;
    end;
  end;
  result:= s;
end;

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift =[] then // Exceptiong Ctrl+Insert
    if PageControl.ActivePage=tsMulti then
      case Key of
        VK_INSERT: btnAdd.Click;
        VK_DELETE: if [ssCtrl] <> Shift then
                     btnRemove.Click
                   else
                     btnRemoveAll.Click;
        ord('S'):  btnMultiStart.Click;
        ord('L'):  btnLog.Click;
      end
    else
      case Key of
        VK_INSERT: btnSource.Click;
        ord('S'):  btnStart.Click;
      end
end;

procedure TFrmMain.btnRemoveAllClick(Sender: TObject);
begin
  lbxFileNames.Clear;
  FFileNames.Clear;
end;

procedure TFrmMain.WriteStatus(const Msg: string);
begin
  StatusBar.SimpleText:= Format(sfStatus,[Msg]);
end;

function TFrmMain.ConvBin2Text(const SourceFileName,
  DestFileName: string): boolean;
var
  Input,Output: TMemoryStream;
begin
  result:= false;
  Input:= TMemoryStream.Create;
  Output:= nil;
  try
    Input.LoadFromFile(SourceFileName);
    result:= not IsTextDfm('',Input);
    if result then
    begin
      Output:= TMemoryStream.Create;
      Input.Seek(0, soFromBeginning);
      ObjectResourceToText(Input, Output);
      Output.Seek(0, soFromBeginning);
      Output.SaveToFile(DestFileName);
      AddStatusOK(SourceFileName,DestFileName);
    end;
  except
    on E: Exception do
      AddStatusError(E.Message,SourceFileName,DestFileName);
  end;
  Input.Free;
  Output.Free;
end;

procedure TFrmMain.ConvText2Text(const SourceFileName,
  DestFileName: string);
var
  i: integer;
  source: TStringList;
  dest: TStringList;
begin
  source:= TStringList.Create;
  dest:= TStringList.Create;
  try
    source.LoadFromFile(SourceFileName);
    // Converting all strings from source
    for i:= 0 to source.Count-1 do
      dest.Add(ProcessString(source[i]));
    dest.SaveToFile(DestFileName);
    // Write "It's OK" to status bar
    AddStatusOK(SourceFileName,DestFileName);
  except
    on E: Exception do
      AddStatusError(Format(E.Message,[i+1]),SourceFileName,DestFileName);
  end;
  source.Free;
  dest.Free;
end;

procedure TFrmMain.TabSheet1Show(Sender: TObject);
begin
  Height:= SingleHeight;
end;

end.

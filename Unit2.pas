unit Unit2;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmLog = class(TForm)
    mmLog: TMemo;
    Panel1: TPanel;
    btnClose: TButton;
    btnSave: TButton;
    LogSaveDialog: TSaveDialog;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddLogLine(const s: string);
    procedure ClearLog;
  end;

var
  frmLog: TfrmLog;

implementation

{$R *.DFM}

procedure TfrmLog.btnSaveClick(Sender: TObject);
begin
  if LogSaveDialog.Execute then begin
    mmLog.Lines.SaveToFile(LogSaveDialog.FileName);
    LogSaveDialog.InitialDir:= ExtractFileDir(LogSaveDialog.FileName);
  end;
end;

procedure TfrmLog.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLog.AddLogLine(const s: string);
begin
  mmLog.Lines.Add(s);
end;

procedure TfrmLog.ClearLog;
begin
  mmLog.Clear;
end;

procedure TfrmLog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    Close;
end;

end.

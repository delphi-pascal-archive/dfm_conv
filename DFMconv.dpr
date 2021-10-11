program DFMconv;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FrmMain},
  Unit2 in 'Unit2.pas' {frmLog},
  propman in 'propman.pas',
  pars in 'pars.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Преобразование DFM';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmLog, frmLog);
  LoadProps;
  Application.Run;
  SaveProps;
end.

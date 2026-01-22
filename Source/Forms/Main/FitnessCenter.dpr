program FitnessCenter;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {formMain},
  AppConsts in '..\..\Core\AppConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.

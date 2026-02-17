program FitnessCenter;

uses
  Vcl.Forms,
  AppConsts in '..\..\Core\AppConsts.pas',
  frmClientEdit in '..\Clients\frmClientEdit.pas' {frmClientEdit1},
  frmVisitEdit in '..\Visits\frmVisitEdit.pas' {frmVisitEdit1},
  frmSubscriptionEdit in '..\Subscriptions\frmSubscriptionEdit.pas' {frmSubscriptionEdit1},
  DBModule in '..\..\Database\DBModule.pas',
  frmMain in 'frmMain.pas' {formMain},
  Vcl.Themes,
  Vcl.Styles,
  frameStatistics in '..\statistics\frameStatistics.pas' {Frame1: TFrame1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Onyx Blue');
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.

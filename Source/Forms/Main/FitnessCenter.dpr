program FitnessCenter;

uses
  Vcl.Forms,
  AppConsts in '..\..\Core\AppConsts.pas',
  frmClientEdit in '..\Clients\frmClientEdit.pas' {frmClientEdit1},
  frmVisitEdit in '..\Visits\frmVisitEdit.pas' {frmVisitEdit1},
  frmSubscriptionEdit in '..\Subscriptions\frmSubscriptionEdit.pas' {frmSubscriptionEdit1},
  DBModule in '..\..\Database\DBModule.pas',
  frmMain in 'frmMain.pas' {formMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.

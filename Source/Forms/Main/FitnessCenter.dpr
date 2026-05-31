program FitnessCenter;

uses
  Vcl.Forms,
  AppConsts in '..\..\Core\AppConsts.pas',
  frmClientEdit in '..\Clients\frmClientEdit.pas',
  frmVisitEdit in '..\Visits\frmVisitEdit.pas',
  frmSubscriptionEdit in '..\Subscriptions\frmSubscriptionEdit.pas',
  DBModule in '..\..\Database\DBModule.pas',
  frmMain in 'frmMain.pas',
  Vcl.Themes,
  Vcl.Styles,
  frameStatistics in '..\statistics\frameStatistics.pas' ,
  uUIStyles in '..\..\Core\uUIStyles.pas',
  frmSplash in 'frmSplash.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

   with TForm1.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;

   if not TStyleManager.TrySetStyle('Windows10 Green') then
    if not TStyleManager.TrySetStyle('Windows10 Blue') then
      TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.

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
  frameStatistics in '..\statistics\frameStatistics.pas' {Frame1: TFrame},
  uUIStyles in '..\..\Core\uUIStyles.pas',
  frmSplash in 'frmSplash.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

   with TForm1.Create(Application) do  // ← TForm1 - имя вашей формы
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

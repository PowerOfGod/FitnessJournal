program FitnessCenter;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {formMain},
  AppConsts in '..\..\Core\AppConsts.pas',
  frmClientEdit in '..\Clients\frmClientEdit.pas' {frmClientEdit1},
  frmVisitEdit in '..\Visits\frmVisitEdit.pas' {frmVisitEdit1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TfrmClientEdit1, frmClientEdit1);
  Application.CreateForm(TfrmClientEdit1, frmClientEdit1);
  Application.CreateForm(TfrmVisitEdit1, frmVisitEdit1);
  Application.Run;
end.

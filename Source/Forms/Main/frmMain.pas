unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Menus,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, frmClientEdit, frmVisitEdit, frmSubscriptionEdit, DBModule, AppConsts,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait;

type
  TformMain = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ToolBar1: TToolBar;
    btnNewClient: TToolButton;
    ToolButton1: TToolButton;
    btnNewVisit: TToolButton;
    ToolButton2: TToolButton;
    btnNewSubscription: TToolButton;
    ToolButton3: TToolButton;
    btnRefresh: TToolButton;
    PageControl1: TPageControl;
    tsClients: TTabSheet;
    tsSubscription: TTabSheet;
    tsStatistics: TTabSheet;
    tsVisits: TTabSheet;
    PanelVisits: TPanel;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    DBGridVisits: TDBGrid;
    StatusBar1: TStatusBar;
    btnTestDB: TButton;
    DataSourceClients: TDataSource;
    FDQueryClients: TFDQuery;
    DBGridClients: TDBGrid;
    FDQuerySubscriptions: TFDQuery;
    FDQueryVisits: TFDQuery;
    DataSourceSubscriptions: TDataSource;
    DataSourceVisits: TDataSource;
    procedure btnNewClientClick(Sender: TObject);
    procedure btnNewVisitClick(Sender: TObject);
    procedure btnNewSubscriptionClick(Sender: TObject);    // ДОБАВИТЬ эту строку
    procedure FormDestroy(Sender: TObject);   // ДОБАВИТЬ эту строку
    procedure btnTestDBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadClients;
    procedure LoadSubscription;
    procedure LoadVisits;
    procedure btnRefreshClick(Sender: TObject);
////    procedure LoadSubscriptions;
////    procedure LoadVisits;
    procedure PageControl1Change(Sender: TObject);
    procedure LoadStatistics;
  private
    { Private declarations }
    FDBPath: string;
  public
    { Public declarations }
  end;

var
  formMain: TformMain;

implementation



{$R *.dfm}

procedure TformMain.FormCreate(Sender: TObject);
begin
  // Инициализация
  FDBPath := '';

  // Привязываем обработчики
  PageControl1.OnChange := PageControl1Change;
  btnRefresh.OnClick := btnRefreshClick;

  // Статус по умолчанию
  StatusBar1.Panels[0].Text := 'Готов';
  StatusBar1.Panels[1].Text := 'БД: не подключена';
end;

procedure TformMain.LoadStatistics;
begin
  if not DB.IsConnected then Exit;

  // Простая статистика
  StatusBar1.Panels[2].Text :=
    Format('Клиентов: %d | Абонементов: %d | Посещений: %d',
      [FDQueryClients.RecordCount,
       FDQuerySubscriptions.RecordCount,
       FDQueryVisits.RecordCount]);
end;

procedure TformMain.LoadClients;
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;

  try
    FDQueryClients.Close;
    FDQueryClients.Connection := DB.GetConnection;
    FDQueryClients.SQL.Text :=
  'SELECT ' +
  'id, ' +
  'CAST(full_name AS VARCHAR(100)) AS full_name, ' +
  'CAST(phone AS VARCHAR(30)) AS phone, ' +
  'CAST(email AS VARCHAR(100)) AS email, ' +
  'CAST(membership_type AS VARCHAR(50)) AS membership_type, ' +
  'is_active ' +
  'FROM clients ' +
  'ORDER BY full_name';
    FDQueryClients.Open;

    FDQueryClients.FieldByName('full_name').DisplayWidth := 25;
FDQueryClients.FieldByName('phone').DisplayWidth := 15;
FDQueryClients.FieldByName('email').DisplayWidth := 30;
FDQueryClients.FieldByName('membership_type').DisplayWidth := 20;

    StatusBar1.Panels[1].Text := 'Клиентов: ' + IntToStr(FDQueryClients.RecordCount);

  except
    on E: Exception do
    begin
      ShowMessage('Ошибка загрузки клиентов: ' + E.Message);
    end;
  end;
end;


procedure TformMain.LoadSubscription;
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;

  try
    FDQuerySubscriptions.Close;
    FDQuerySubscriptions.Connection := DB.GetConnection;

    FDQuerySubscriptions.SQL.Text :=
      'SELECT ' +
      'id, ' +
      'client_id, ' +
      'subscription_type, ' +
      'start_date, ' +
      'end_date, ' +
      'price, ' +
      'visits_count, ' +
      'remaining_visits, ' +
      'is_active, ' +
      'notes ' +
      'FROM subscriptions ' +
      'ORDER BY start_date DESC';

    FDQuerySubscriptions.Open;




    StatusBar1.Panels[1].Text :=
      'Абонементов: ' + IntToStr(FDQuerySubscriptions.RecordCount);

  except
    on E: Exception do
      ShowMessage('Ошибка загрузки абонементов: ' + E.Message);
  end;
end;

procedure TformMain.LoadVisits;
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;

  try
    FDQueryVisits.Close;
    FDQueryVisits.Connection := DB.GetConnection;

    FDQueryVisits.SQL.Text :=
      'SELECT ' +
      'v.id, ' +
      'v.client_id, ' +
      'CAST(c.full_name AS VARCHAR(100)) AS full_name, ' +
      'v.visit_date, ' +
      'v.entry_time, ' +
      'v.exit_time, ' +
      'v.duration_minutes, ' +
      'CAST(v.trainer_name AS VARCHAR(100)) AS trainer_name, ' +
      'CAST(v.notes AS VARCHAR(100)) AS notes ' +
      'FROM visits v ' +
      'LEFT JOIN clients c ON c.id = v.client_id ' +
      'ORDER BY v.visit_date DESC, v.entry_time DESC';

    FDQueryVisits.Open;


    FDQueryVisits.FieldByName('full_name').DisplayWidth := 25;
    FDQueryVisits.FieldByName('trainer_name').DisplayWidth := 10;

    FDQueryVisits.FieldByName('notes').DisplayWidth := 25;

    StatusBar1.Panels[1].Text :=
      'Посещений: ' + IntToStr(FDQueryVisits.RecordCount);

  except
    on E: Exception do
      ShowMessage('Ошибка загрузки посещений: ' + E.Message);
  end;
end;



procedure TformMain.PageControl1Change(Sender: TObject);
begin
  if not DB.IsConnected then Exit;

  case PageControl1.ActivePageIndex of
    0: LoadClients;        // Клиенты
    1: LoadSubscription;   // Абонементы
    3: LoadVisits;         // Посещения
  end;
end;
procedure TformMain.FormDestroy(Sender: TObject);
begin
  // Не нужно освобождать DB - это сделает finalization
end;


procedure TformMain.btnTestDBClick(Sender: TObject);
begin
  // 1. Путь к БД рядом с exe
  FDBPath := GetDBPath;

  // 2. Проверка файла
  if not FileExists(FDBPath) then
  begin
    ShowMessage(
      'Файл базы данных не найден:' + sLineBreak +
      FDBPath + sLineBreak + sLineBreak +
      'Поместите FitnessCenter.db рядом с программой.'
    );
    Exit;
  end;

  // 3. Подключаемся
  try
    if DB.ConnectToDB(FDBPath) then
    begin
      StatusBar1.Panels[0].Text := 'Подключено: ' + ExtractFileName(FDBPath);
      ShowMessage('✅ База данных подключена');

      LoadClients;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;



procedure TformMain.btnNewClientClick(Sender: TObject);
var
  ClientForm: TfrmClientEdit1;
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;

  ClientForm := TfrmClientEdit1.Create(Self);
  try
    if ClientForm.ShowModal = mrOk then
    begin
      ShowMessage('Клиент добавлен!');
      LoadClients; // Обновить список клиентов
    end;
  finally
    ClientForm.Free;
  end;
end;


procedure TformMain.btnNewSubscriptionClick(Sender: TObject);
  var
  SubscriptionForm : TfrmSubscriptionEdit1;
begin
  SubscriptionForm := TfrmSubscriptionEdit1.Create(Self);
    try
      if SubscriptionForm.ShowModal = mrOk then ShowMessage('Абонемент добавлен!');


    finally
      SubscriptionForm.Free;
    end;

end;

procedure TformMain.btnNewVisitClick(Sender: TObject);
var
    VisitForm :TfrmVisitEdit1;
begin
      VisitForm := TfrmVisitEdit1.Create(Self);
      try

        if VisitForm.ShowModal = mrOk then
        begin
             ShowMessage('Посещение зарегистрировано!');
        end;


      finally
        VisitForm.Free;
      end;
end;


procedure TformMain.btnRefreshClick(Sender: TObject);
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;

  case PageControl1.ActivePageIndex of
    0: LoadClients;
    1: LoadSubscription;
    3: LoadVisits;
  end;
end;

//procedure TformMain.LoadSubscriptions;
//begin
//
//end;
//
//
//  procedure TformMain.LoadVisits;
//begin
//
//end;









end.




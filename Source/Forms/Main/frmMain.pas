unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Menus,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, frmClientEdit,
  frmVisitEdit, frmSubscriptionEdit, DBModule, AppConsts,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, System.UITypes, frameStatistics, ReportsModule, uUIStyles, Vcl.Themes, Vcl.Styles;

type
  TformMain = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    PanelToolbar: TPanel;
    btnNewClient: TButton;
    btnNewVisit: TButton;
    btnNewSubscription: TButton;
    btnRefresh: TButton;
    PageControl1: TPageControl;
    tsClients: TTabSheet;
    tsSubscription: TTabSheet;
    tsStatistics: TTabSheet;
    tsVisits: TTabSheet;
    PanelVisits: TPanel;
    DBGridVisits: TDBGrid;
    DBGridSubscriptions: TDBGrid;
    DataSourceClients: TDataSource;
    FDQueryClients: TFDQuery;
    DBGridClients: TDBGrid;
    FDQuerySubscriptions: TFDQuery;
    FDQueryVisits: TFDQuery;
    DataSourceSubscriptions: TDataSource;
    DataSourceVisits: TDataSource;
    StatusBar1: TStatusBar;
    mnReports: TMenuItem;
    PanelClientSearch: TPanel;
    lblSearch: TLabel;
    edtSearch: TEdit;
    mnuAbout: TMenuItem;
    mnuHelp: TMenuItem;
    btnClearSearch: TButton;
    rbName: TRadioButton;
    rbPhone: TRadioButton;
    rbEmail: TRadioButton;
    procedure RegisterVisitExit(VisitID: Integer);
    procedure btnNewClientClick(Sender: TObject);
    procedure btnNewVisitClick(Sender: TObject);
    procedure btnNewSubscriptionClick(Sender: TObject); // ДОБАВИТЬ эту строку
    procedure FormDestroy(Sender: TObject); // ДОБАВИТЬ эту строку
    procedure FormCreate(Sender: TObject);
    procedure LoadClients;
    procedure LoadSubscription;
    procedure LoadVisits;
    procedure btnRefreshClick(Sender: TObject);
    procedure EditClient(ClientID: Integer); // Новый метод
    procedure DeleteClient(ClientID: Integer);
    procedure SoftDeleteClient(ClientID: Integer; ClientName: String);
    procedure HardDeleteClient(ClientID: Integer; ClientName: String);
    /// /    procedure LoadSubscriptions;
    /// /    procedure LoadVisits;
    procedure mnTrainerReportClick(Sender: TObject);
    procedure mnVisitsReportClick(Sender: TObject);
    procedure mnSubscriptionsReportClick(Sender: TObject);
    procedure mnClientsReportClick(Sender: TObject);
    procedure mnExportExcelClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure LoadStatistics;
    procedure DBGridVisitsDblClick(Sender: TObject);
    procedure DBGridClientsDblClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure btnClearSearchClick(Sender: TObject);
    procedure rbSearchClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
    FDBPath: string;
    FStatsFrame: TFrame1;
    FSearchText: string;
    FSearchField: Integer;
    procedure ApplySearchFilter;
     procedure UpdateStatusBar;
    function GetTodayVisitsCount: Integer;
    function GetActiveSubscriptionsCount: Integer;
    procedure SetupToolbarButtons;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AutoFitGridColumns(Grid: TDBGrid);
    procedure FormResize(Sender: TObject);
    procedure UpdateStatisticsLayout;
    procedure mnuHelpClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
  public

    { Public declarations }
  end;

var
  formMain: TformMain;

implementation

{$R *.dfm}

procedure TformMain.N2Click(Sender: TObject);
begin
  Close;  // Закрыть приложение
end;

procedure TformMain.UpdateStatisticsLayout;
begin
  if Assigned(FStatsFrame) then
  begin
    // Принудительно пересчитываем размеры таблиц в статистике
    FStatsFrame.UpdateLayout;
  end;
end;

procedure TformMain.AutoFitGridColumns(Grid: TDBGrid);
var
  i: Integer;
  TotalWidth: Integer;
  VisibleCols: Integer;
  ColWidth: Integer;
begin
  if not Assigned(Grid) then Exit;
  if not Grid.DataSource.DataSet.Active then Exit;
  if Grid.Columns.Count = 0 then Exit;

  // Подсчитываем только видимые колонки
  VisibleCols := 0;
  for i := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns[i].Visible then
      Inc(VisibleCols);

  if VisibleCols = 0 then Exit;

  // Получаем доступную ширину (минус полоса прокрутки и отступы)
  TotalWidth := Grid.ClientWidth - 25;

  if TotalWidth < 100 then Exit;

  // Равномерно распределяем ширину между всеми видимыми колонками
  ColWidth := TotalWidth div VisibleCols;

  // Минимальная ширина колонки
  if ColWidth < 60 then
    ColWidth := 60;

  // Применяем ширину ко всем видимым колонкам
  for i := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns[i].Visible then
      Grid.Columns[i].Width := ColWidth;
end;



 procedure TformMain.FormResize(Sender: TObject);
begin
  // Подстраиваем активную таблицу главной формы
  if PageControl1.ActivePage = tsClients then
    AutoFitGridColumns(DBGridClients)
  else if PageControl1.ActivePage = tsSubscription then
    AutoFitGridColumns(DBGridSubscriptions)
  else if PageControl1.ActivePage = tsVisits then
    AutoFitGridColumns(DBGridVisits)
  else if PageControl1.ActivePage = tsStatistics then
    UpdateStatisticsLayout;  // ← ВЫЗЫВАЕМ ДЛЯ СТАТИСТИКИ
end;


procedure TformMain.EditClient(ClientID: Integer);
var
  ClientForm: TfrmClientEdit1;
  Query: TFDQuery;
begin
//  ShowMessage('Редактирование клиента с ID: ' + IntToStr(ClientID));
  if not DB.IsConnected then
  begin
    ShowMessage('Нет подключенияя к базе данных!');
    Exit;
  end;

  ClientForm := TfrmClientEdit1.Create(Self);
  try
    ClientForm.LoadDataForEdit(ClientID);
    ClientForm.Caption := 'Редактировать клиента';

    if ClientForm.ShowModal = mrOk then
    begin
      ShowMessage('Данные клиента обновлены!');
      LoadClients;
    end
    else
    begin
      ShowMessage('Редактирование отменено');
    end;

  finally
    ClientForm.Free;
  end;
end;

procedure TformMain.DeleteClient(ClientID: Integer);
var
  Query: TFDQuery;
  ClientName: string;
  HasActiveSubscriptions: Boolean;
  HasVisits: Boolean;
begin

  if not DB.IsConnected then
  begin
    ShowMessage('Нет подключенияя к базе данных!');
    Exit;
  end;

  Query := TFDQuery.Create(nil);
  try

    Query.Connection := DB.GetConnection;

    Query.SQL.Text := 'SELECT full_name FROM clients WHERE id = :id';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

    if Query.Eof then
    begin
      ShowMessage('Клиент не найден!');
      Exit;
    end;

    ClientName := Query.FieldByName('full_name').AsString;
    Query.Close;

    Query.SQL.Text := 'SELECT COUNT(*) as cnt FROM subscriptions ' +
      'WHERE client_id = :id AND is_active = 1 ' +
      'AND date(end_date) >= date(''now'')';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

    HasActiveSubscriptions := Query.FieldByName('cnt').AsInteger > 0;
    Query.Close;

    Query.SQL.Text := 'SELECT COUNT(*) as cnt FROM visits ' +
      'WHERE client_id = :id';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

    HasVisits := Query.FieldByName('cnt').AsInteger > 0;
    Query.Close;

    var
    WarningMsg := 'ВНИМАНИЕ! Вы собираетесь удалить клиента:' + sLineBreak +
      sLineBreak + 'Клиент: ' + ClientName + sLineBreak + 'ID: ' +
      IntToStr(ClientID) + sLineBreak + sLineBreak;

    if HasActiveSubscriptions then
      WarningMsg := WarningMsg + '⚠ У клиента есть активные абонементы!' +
        sLineBreak;

    if HasVisits then
      WarningMsg := WarningMsg + '⚠ У клиента есть история посещений!' +
        sLineBreak;

    WarningMsg := WarningMsg + sLineBreak + 'Выберите действие:' + sLineBreak +
      sLineBreak + 'Да    - Мягкое удаление (деактивация)' + sLineBreak +
      'Нет   - Полное удаление (опасно!)' + sLineBreak +
      'Отмена - Отменить удаление';

    var
    Res := MessageDlg(WarningMsg, mtWarning, [mbYes, mbNo, mbCancel], 0);

    case Res of
      mrYes:
        SoftDeleteClient(ClientID, ClientName); // Мягкое удаление
      mrNo:
        HardDeleteClient(ClientID, ClientName); // Полное удаление
      mrCancel:
        ShowMessage('Удаление отменено.'); // Отмена
    end;

  finally
    Query.Free;
  end;

end;


procedure TformMain.SoftDeleteClient(ClientID: Integer; ClientName: string);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;

    // Начинаем транзакцию
    Query.Connection.StartTransaction;

    try
      // 1. Деактивируем клиента
      Query.SQL.Text := 'UPDATE clients SET is_active = 0 ' + 'WHERE id = :id';
      Query.ParamByName('id').AsInteger := ClientID;
      Query.ExecSQL;

      // 2. Деактивируем все активные абонементы
      Query.SQL.Text := 'UPDATE subscriptions SET is_active = 0 ' +
        'WHERE client_id = :id AND is_active = 1';
      Query.ParamByName('id').AsInteger := ClientID;
      Query.ExecSQL;

      // Фиксируем транзакцию
      Query.Connection.Commit;

      ShowMessage('✅ Клиент успешно деактивирован!' + sLineBreak + sLineBreak +
        'Клиент: ' + ClientName + sLineBreak + 'ID: ' + IntToStr(ClientID) +
        sLineBreak + sLineBreak + '▪ Статус: НЕАКТИВЕН' + sLineBreak +
        '▪ Абонементы: деактивированы' + sLineBreak +
        '▪ История посещений: сохранена');

      // Обновляем список клиентов (показываем только активных)
      LoadClients;

    except
      on E: Exception do
      begin
        Query.Connection.Rollback;
        ShowMessage('❌ Ошибка при деактивации:' + sLineBreak + E.Message);
      end;
    end;

  finally
    Query.Free;
  end;
end;

procedure TformMain.HardDeleteClient(ClientID: Integer; ClientName: string);
var
  Query: TFDQuery;
  VisitCount, SubCount: Integer;
begin
  // Дополнительное подтверждение с подсчетом записей
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;

    // Получаем количество связанных записей
    Query.SQL.Text := 'SELECT ' +
      '(SELECT COUNT(*) FROM visits WHERE client_id = :id) as visits, ' +
      '(SELECT COUNT(*) FROM subscriptions WHERE client_id = :id) as subs';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

    VisitCount := Query.FieldByName('visits').AsInteger;
    SubCount := Query.FieldByName('subs').AsInteger;
    Query.Close;

    // Финальное подтверждение
    if MessageDlg('⚠ ПОЛНОЕ УДАЛЕНИЕ ⚠' + sLineBreak + sLineBreak + 'Клиент: ' +
      ClientName + sLineBreak + 'ID: ' + IntToStr(ClientID) + sLineBreak +
      sLineBreak + 'Будет удалено:' + sLineBreak + '• Посещений: ' +
      IntToStr(VisitCount) + sLineBreak + '• Абонементов: ' + IntToStr(SubCount)
      + sLineBreak + sLineBreak + 'ЭТО ДЕЙСТВИЕ НЕЛЬЗЯ ОТМЕНИТЬ!' + sLineBreak +
      sLineBreak + 'Введите "DELETE" для подтверждения:', mtError,
      [mbOK, mbCancel], 0) <> mrOk then
    begin
      ShowMessage('Полное удаление отменено.');
      Exit;
    end;

    // Запрос подтверждения строкой
    var
    ConfirmText := InputBox('Подтверждение удаления',
      'Введите "DELETE" для подтверждения:', '');

    if ConfirmText <> 'DELETE' then
    begin
      ShowMessage('Неверное подтверждение. Удаление отменено.');
      Exit;
    end;

  finally
    Query.Free;
  end;

  // САМО УДАЛЕНИЕ (в отдельной транзакции)
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;
    Query.Connection.StartTransaction;

    try
      // Удаляем посещения
      Query.SQL.Text := 'DELETE FROM visits WHERE client_id = :id';
      Query.ParamByName('id').AsInteger := ClientID;
      Query.ExecSQL;

      // Удаляем абонементы
      Query.SQL.Text := 'DELETE FROM subscriptions WHERE client_id = :id';
      Query.ParamByName('id').AsInteger := ClientID;
      Query.ExecSQL;

      // Удаляем клиента
      Query.SQL.Text := 'DELETE FROM clients WHERE id = :id';
      Query.ParamByName('id').AsInteger := ClientID;
      Query.ExecSQL;

      Query.Connection.Commit;

      ShowMessage('🗑️ Клиент ПОЛНОСТЬЮ удален!' + sLineBreak + sLineBreak +
        'Клиент: ' + ClientName + sLineBreak + 'ID: ' + IntToStr(ClientID) +
        sLineBreak + sLineBreak + '✅ Все данные удалены из базы.');

      LoadClients;

    except
      on E: Exception do
      begin
        Query.Connection.Rollback;
        ShowMessage('❌ Ошибка при удалении:' + sLineBreak + E.Message);
      end;
    end;

  finally
    Query.Free;
  end;
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
  // 1. Путь к БД рядом с exe
  FDBPath := GetDBPath;
  Color := clWhite;
    DBGridClients.Font.Size := 11;
  DBGridClients.TitleFont.Size := 11;


  N1.Caption := 'Файл';
  N2.Caption := 'Выход';

  DBGridSubscriptions.Font.Size := 11;
  DBGridSubscriptions.TitleFont.Size := 11;

  DBGridVisits.Font.Size := 11;
  DBGridVisits.TitleFont.Size := 11;
  // 2. Проверка файла
  if not FileExists(FDBPath) then
  begin
    ShowMessage('Файл базы данных не найден:' + sLineBreak + FDBPath +
      sLineBreak + sLineBreak +
      'Поместите FitnessCenter.db рядом с программой.');

    StatusBar1.Panels[1].Text := 'БД: не найдена';
    Exit;


  end;

  // 3. Подключаемся
  try
    if DB.ConnectToDB(FDBPath) then
    begin
      StatusBar1.Panels[0].Text := 'Подключено: ' + ExtractFileName(FDBPath);

      LoadClients;
      LoadSubscription;
      LoadVisits;
      LoadStatistics;

      // ========== СОЗДАЕМ ФРЕЙМ СТАТИСТИКИ ==========
      if tsStatistics.ControlCount = 0 then
      begin
        FStatsFrame := TFrame1.Create(tsStatistics);
        FStatsFrame.Parent := tsStatistics;
        FStatsFrame.Align := alClient;
        FStatsFrame.Initialize;
      end;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;

  // ========== ПРИМЕНЯЕМ СТИЛИ (ВНЕ БЛОКА try..except) ==========
  try
    
     TUIStyles.FormatDates(FDQueryClients, ['birth_date', 'registration_date']);
    TUIStyles.FormatDates(FDQuerySubscriptions, ['start_date', 'end_date']);
    TUIStyles.FormatDates(FDQueryVisits, ['visit_date']);


    StatusBar1.Panels[2].Text := 'Стили применены';
  except
    on E: Exception do
      StatusBar1.Panels[2].Text := 'Ошибка стилей: ' + E.Message;
  end;

   tsClients.Caption := 'Клиенты';
  tsSubscription.Caption := 'Абонементы';
  tsStatistics.Caption := 'Статистика';
  tsVisits.Caption := 'Посещения';

  // Привязываем обработчики
  PageControl1.OnChange := PageControl1Change;
  btnRefresh.OnClick := btnRefreshClick;

  // Статус по умолчанию
  if not DB.IsConnected then
  begin
    StatusBar1.Panels[0].Text := 'Готов';
    StatusBar1.Panels[1].Text := 'БД: не подключена';
  end;

  FSearchText := '';
  FSearchField := 0;

   UpdateStatusBar;

     SetupToolbarButtons;     // Настраиваем кнопки
  Self.KeyPreview := True;
  Self.OnKeyDown := FormKeyDown;

  edtSearch.OnChange := edtSearchChange;
  btnClearSearch.OnClick := btnClearSearchClick;
  rbName.OnClick := rbSearchClick;
  rbPhone.OnClick := rbSearchClick;
  rbEmail.OnClick := rbSearchClick;


   mnuHelp.OnClick := mnuHelpClick;
    mnuAbout.OnClick := mnuAboutClick;

   Self.OnResize := FormResize;
end;



procedure TformMain.LoadStatistics;
begin
  if not DB.IsConnected then Exit;

  StatusBar1.Panels[2].Text := Format('Всего: Клиентов=%d, Абонементов=%d, Посещений=%d',
    [FDQueryClients.RecordCount,
     FDQuerySubscriptions.RecordCount,
     FDQueryVisits.RecordCount]);
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

    // ПОКАЗЫВАЕМ ВСЕ АБОНЕМЕНТЫ С ПРАВИЛЬНЫМ СТАТУСОМ
    FDQuerySubscriptions.SQL.Text := 'SELECT ' + 's.id, ' + 's.client_id, ' +
      'CAST(c.full_name AS VARCHAR(100)) AS client_name, ' +
      'CAST(s.subscription_type AS VARCHAR(100)) AS subscription_type, ' +
      's.start_date, ' + 's.end_date, ' + 's.price, ' + 's.visit_count, ' +
      's.remaining_visit, ' +
      'CASE WHEN s.is_active = 1 AND date(s.end_date) >= date(''now'') THEN "Активен" '
      + '     WHEN s.is_active = 1 AND date(s.end_date) < date(''now'') THEN "Просрочен" '
      + '     ELSE "Неактивен" END as status, ' +
      'CASE WHEN s.is_active = 1 AND date(s.end_date) >= date(''now'') THEN 1 '
      + // Для сортировки
      '     WHEN s.is_active = 1 AND date(s.end_date) < date(''now'') THEN 2 ' +
      '     ELSE 3 END as status_order, ' +
      'CAST(s.notes AS VARCHAR(100)) AS notes ' + 'FROM subscriptions s ' +
      'LEFT JOIN clients c ON c.id = s.client_id ' +
      'ORDER BY s.id DESC';

    FDQuerySubscriptions.Open;
     if DBGridSubscriptions.Columns.Count > 0 then
  begin
    DBGridSubscriptions.Columns[0].Visible := False;  // ID
    DBGridSubscriptions.Columns[1].Visible := False;
    DBGridSubscriptions.Columns[10].Visible := False;
    DBGridSubscriptions.Columns[11].Visible := False;  // client_id


    DBGridSubscriptions.Columns[2].Title.Caption := 'Клиент';
    DBGridSubscriptions.Columns[3].Title.Caption := 'Тип абонемента';
    DBGridSubscriptions.Columns[4].Title.Caption := 'Дата начала';
    DBGridSubscriptions.Columns[5].Title.Caption := 'Дата окончания';
    DBGridSubscriptions.Columns[6].Title.Caption := 'Цена, руб';
    DBGridSubscriptions.Columns[7].Title.Caption := 'Всего';
    DBGridSubscriptions.Columns[8].Title.Caption := 'Осталось';
    DBGridSubscriptions.Columns[9].Title.Caption := 'Статус';

    // Увеличиваем нужные колонки
    DBGridSubscriptions.Columns[2].Width := 200;  // client_name - увеличили
    DBGridSubscriptions.Columns[3].Width := 125;
     DBGridSubscriptions.Columns[7].Width := 50;
      DBGridSubscriptions.Columns[8].Width := 50;  // subscription_type
    DBGridSubscriptions.Columns[9].Width := 120;
    DBGridSubscriptions.Columns[10].Width := 25;
    DBGridSubscriptions.Columns[11].Width := 120;   // status
  end;



    // Настройка ширины колонок
    FDQuerySubscriptions.FieldByName('client_name').DisplayWidth := 25;
    FDQuerySubscriptions.FieldByName('subscription_type').DisplayWidth := 15;
    FDQuerySubscriptions.FieldByName('status').DisplayWidth := 12;
    FDQuerySubscriptions.FieldByName('notes').DisplayWidth := 25;

    // Подсчет статистики
    var
    ActiveCount := 0;
    var
    ExpiredCount := 0;
    var
    InactiveCount := 0;

    FDQuerySubscriptions.First;
    while not FDQuerySubscriptions.Eof do
    begin
      if FDQuerySubscriptions.FieldByName('status').AsString = 'Активен' then
        Inc(ActiveCount)
      else if FDQuerySubscriptions.FieldByName('status').AsString = 'Просрочен'
      then
        Inc(ExpiredCount)
      else
        Inc(InactiveCount);
      FDQuerySubscriptions.Next;
    end;

    StatusBar1.Panels[1].Text :=
      Format('Абонементов: %d (Активных: %d, Просроченных: %d, Неактивных: %d)',
      [FDQuerySubscriptions.RecordCount, ActiveCount, ExpiredCount,
      InactiveCount]);

  except
    on E: Exception do
      ShowMessage('Ошибка загрузки абонементов: ' + E.Message);
  end;


   AutoFitGridColumns(DBGridSubscriptions);
   UpdateStatusBar;

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

    FDQueryVisits.SQL.Text := 'SELECT ' + 'v.id, ' + 'v.client_id, ' +
      'CAST(c.full_name AS VARCHAR(100)) AS full_name, ' + 'v.visit_date, ' +
      'v.entry_time, ' + 'v.exit_time, ' + 'v.duration_minutes, ' +
      'CAST(v.trainer_name AS VARCHAR(100)) AS trainer_name, ' +
      'CAST(v.notes AS VARCHAR(100)) AS notes ' + 'FROM visits v ' +
      'LEFT JOIN clients c ON c.id = v.client_id ' +
      'ORDER BY v.visit_date DESC, v.entry_time DESC';

    FDQueryVisits.Open;

     if DBGridVisits.Columns.Count > 0 then
  begin
    DBGridVisits.Columns[0].Visible := False;  // ID
    DBGridVisits.Columns[1].Visible := False;
    DBGridVisits.Columns[8].Visible := False; // client_id
    DBGridVisits.Columns[6].Alignment := taLeftJustify;

    DBGridVisits.Columns[2].Title.Caption := 'Клиент';
    DBGridVisits.Columns[3].Title.Caption := 'Дата';
    DBGridVisits.Columns[4].Title.Caption := 'Вход';
    DBGridVisits.Columns[5].Title.Caption := 'Выход';
    DBGridVisits.Columns[6].Title.Caption := 'Длительность, мин';
    DBGridVisits.Columns[7].Title.Caption := 'Тренер';


    // Увеличиваем нужные колонки
    DBGridVisits.Columns[2].Width := 250;  // full_name - увеличили
    DBGridVisits.Columns[7].Width := 200;  // trainer_name - увеличили
  end;


    FDQueryVisits.FieldByName('full_name').DisplayWidth := 25;
    FDQueryVisits.FieldByName('trainer_name').DisplayWidth := 10;

    FDQueryVisits.FieldByName('notes').DisplayWidth := 25;

    StatusBar1.Panels[1].Text := 'Посещений: ' +
      IntToStr(FDQueryVisits.RecordCount);

  except
    on E: Exception do
      ShowMessage('Ошибка загрузки посещений: ' + E.Message);
  end;
     AutoFitGridColumns(DBGridVisits);
   UpdateStatusBar;
end;

procedure TformMain.LoadClients;
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;

  try

    // 1. Закрываем запрос
    FDQueryClients.Close;



    // 2. Проверяем и устанавливаем подключение
    if not Assigned(FDQueryClients.Connection) then
      FDQueryClients.Connection := DB.GetConnection;

    // 3. Ваш SQL с CAST (оставляем как есть)
    FDQueryClients.SQL.Text := 'SELECT ' + 'id, ' +
      'CAST(full_name AS VARCHAR(100)) AS full_name, ' +
      'CAST(phone AS VARCHAR(30)) AS phone, ' +
      'CAST(email AS VARCHAR(100)) AS email, ' +
      'CAST(membership_type AS VARCHAR(50)) AS membership_type, ' + 'is_active '
      + 'FROM clients ' + 'WHERE is_active = 1 ' + // ← ДОБАВИТЬ ЭТУ СТРОКУ!
      'ORDER BY full_name';

    // 4. Открываем запрос
    FDQueryClients.Open;



    if DBGridClients.Columns.Count > 0 then
  begin

     DBGridClients.Columns[0].Visible := False;
     DBGridClients.Columns[5].Visible := False;


      DBGridClients.Columns[1].Title.Caption := 'ФИО клиента';
    DBGridClients.Columns[2].Title.Caption := 'Телефон';
    DBGridClients.Columns[3].Title.Caption := 'Email';
    DBGridClients.Columns[4].Title.Caption := 'Абонемент';

    DBGridClients.Columns[0].Width := 50;    // ID
    DBGridClients.Columns[1].Width := 200;   // ФИО
    DBGridClients.Columns[2].Width := 120;   // Телефон
    DBGridClients.Columns[3].Width := 180;   // Email
    DBGridClients.Columns[4].Width := 130;   // Тип абонемента

     AutoFitGridColumns(DBGridClients);
  end;





    ApplySearchFilter;

    // 5. Настройка ширины колонок
    FDQueryClients.FieldByName('full_name').DisplayWidth := 25;
    FDQueryClients.FieldByName('phone').DisplayWidth := 15;
    FDQueryClients.FieldByName('email').DisplayWidth := 30;
    FDQueryClients.FieldByName('membership_type').DisplayWidth := 20;

    // 6. Принудительное обновление DBGrid
    DBGridClients.Refresh;
    DBGridClients.Repaint;

    // 7. Обновляем статус
    StatusBar1.Panels[1].Text := 'Клиентов: ' +
      IntToStr(FDQueryClients.RecordCount);

  except
    on E: Exception do
    begin
      ShowMessage('Ошибка загрузки клиентов: ' + E.Message);
    end;
  end;

   UpdateStatusBar;
end;

procedure TformMain.PageControl1Change(Sender: TObject);
begin
  if not DB.IsConnected then
    Exit;

  case PageControl1.ActivePageIndex of
    0:
      begin
        LoadClients;
        StatusBar1.Panels[0].Text := 'Таблица: Клиенты';
        StatusBar1.Panels[1].Text := 'Клиентов: ' +
          IntToStr(FDQueryClients.RecordCount);
      end;
    1:
      begin
        LoadSubscription;
        StatusBar1.Panels[0].Text := 'Таблица: Абонементы';
        StatusBar1.Panels[1].Text := 'Абонементы: ' +
          IntToStr(FDQuerySubscriptions.RecordCount);
      end;
    2: // <-- ЭТО ВКЛАДКА СТАТИСТИКИ (индекс 2)
      begin
         StatusBar1.Panels[0].Text := 'Статистика';
        if Assigned(FStatsFrame) then
        begin
          FStatsFrame.RefreshData;
          UpdateStatisticsLayout;  // ← ДОБАВИТЬ
        end;
      end;
    3:
      begin
        LoadVisits;
        StatusBar1.Panels[0].Text := 'Таблица: Посещения';
        StatusBar1.Panels[1].Text := 'Посещений: ' +
          IntToStr(FDQueryVisits.RecordCount);
      end;
  end;

   if PageControl1.ActivePage = tsClients then
    AutoFitGridColumns(DBGridClients)
  else if PageControl1.ActivePage = tsSubscription then
    AutoFitGridColumns(DBGridSubscriptions)
  else if PageControl1.ActivePage = tsVisits then
    AutoFitGridColumns(DBGridVisits);
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  // Не нужно освобождать DB - это сделает finalization
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

    ClientForm.Caption := 'Добавить нового клиента';

    // Просто показываем форму
    // Форма сама сохраняет данные
    if ClientForm.ShowModal = mrOk then
    begin
      // Клиент уже сохранен формой
      // Просто обновляем список


      // Можно показать ID сохраненного клиента
      ShowMessage('Клиент добавлен! ID: ' + IntToStr(ClientForm.ClientID));
       LoadClients;
       PageControl1.ActivePageIndex := 0;
    end;
  finally
    ClientForm.Free;
  end;
end;

procedure TformMain.btnNewSubscriptionClick(Sender: TObject);
var
  SubscriptionForm: TfrmSubscriptionEdit1;
begin
  SubscriptionForm := TfrmSubscriptionEdit1.Create(Self);
  try
    if SubscriptionForm.ShowModal = mrOk then
      ShowMessage('Абонемент добавлен!');
      LoadSubscription;
      LoadClients;

      PageControl1.ActivePageIndex := 1;
  finally
    SubscriptionForm.Free;
  end;

end;

procedure TformMain.btnNewVisitClick(Sender: TObject);
var
  VisitForm: TfrmVisitEdit1;
begin
  VisitForm := TfrmVisitEdit1.Create(Self);
  try

    if VisitForm.ShowModal = mrOk then
    begin
      ShowMessage('Посещение зарегистрировано!');

      LoadVisits;

      if PageControl1.ActivePageIndex = 2 then
      begin
        if Assigned(FStatsFrame) then
          FStatsFrame.RefreshData;

      end;

      PageControl1.ActivePageIndex := 3;

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
    0:
      LoadClients;
    1:
      LoadSubscription; // Обновляем список абонементов
    3:
      LoadVisits;
  end;
end;

procedure TformMain.DBGridClientsDblClick(Sender: TObject);
begin
  if FDQueryClients.IsEmpty then
  begin
    ShowMessage('Нет данных в таблице!');
    Exit;
  end;

  var
  ClientID := FDQueryClients.FieldByName('id').AsInteger;
  var
  ClientName := FDQueryClients.FieldByName('full_name').AsString;
  var
  this := Self;

  var
  Res := MessageDlg('Выберите действие для клиента:' + sLineBreak + '«' +
    ClientName + '»', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

  case Res of
    mrYes:
    begin
       EditClient(ClientID);
      LoadClients;
    end;

    mrNo:
    begin
      DeleteClient(ClientID);
       LoadClients;
    end;
    mrCancel:
      ; // Ничего не делать
  end;
end;

procedure TformMain.DBGridVisitsDblClick(Sender: TObject);
begin
  if FDQueryVisits.IsEmpty then
  begin
    ShowMessage('Нет данных в таблице!!');
    Exit;
  end;

  var
  VisitID := FDQueryVisits.FieldByName('id').AsInteger;
  var
  ClientName := FDQueryVisits.FieldByName('full_name').AsString;

  var
  ExitTimeField := FDQueryVisits.FieldByName('exit_time');

  if ExitTimeField.IsNull then
  begin
    var
    Response := MessageDlg('Зарегистрировать выход ' + ClientName + '?',
      mtConfirmation, [mbYes, mbNo], 0);

    if Response = mrYes then
    begin
      RegisterVisitExit(VisitID)
      /// Тут функция  ///
    end;

  end
  else
  begin
    ShowMessage(ClientName + ' уже завершил(а) посещение' + sLineBreak +
      'Время выхода: ' + ExitTimeField.AsString);
  end;

end;

procedure TformMain.RegisterVisitExit(VisitID: Integer);
var
  ExitTime: TTime;
  Query: TFDQuery;
  EntryTimeStr: string;
  EntryTime: TTime;
  DurationMinutes: Integer;
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;

  ExitTime := Time;

  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := DB.GetConnection;

      // 1. Получаем время входа
      Query.SQL.Text := 'SELECT entry_time FROM visits WHERE id = :id';
      Query.ParamByName('id').AsInteger := VisitID;
      Query.Open;

      if Query.Eof then
      begin
        ShowMessage('Посещение не найдено!');
        Exit;
      end;

      EntryTimeStr := Query.FieldByName('entry_time').AsString;
      Query.Close;

      // 2. Преобразуем строку в TTime
      try
        EntryTime := StrToTime(EntryTimeStr);
      except
        // Если не удалось распарсить, используем текущее время минус 1 час
        EntryTime := Time - (1 / 24);
      end;

      // 3. Проверяем, что время выхода позже времени входа
      if ExitTime < EntryTime then
      begin
        // Если клиент пришел вечером, а выходит утром (например, ночная тренировка)
        // Добавляем 1 день
        ExitTime := ExitTime + 1;
      end;

      // 4. Рассчитываем длительность в минутах
      DurationMinutes := Round((ExitTime - EntryTime) * 24 * 60);

      // Проверяем корректность расчета
      if DurationMinutes < 0 then
        DurationMinutes := 0;
      if DurationMinutes > 1440 then
        DurationMinutes := 1440; // Максимум 24 часа

      // 5. Обновляем запись в базе данных
      Query.SQL.Text := 'UPDATE visits ' + 'SET exit_time = :exit_time, ' +
        'duration_minutes = :duration ' + 'WHERE id = :id';

      Query.ParamByName('exit_time').AsString :=
        FormatDateTime('hh:nn:ss', ExitTime);
      Query.ParamByName('duration').AsInteger := DurationMinutes;
      Query.ParamByName('id').AsInteger := VisitID;

      Query.ExecSQL;

      // 6. Показываем информацию пользователю
      ShowMessage('✅ Выход успешно зарегистрирован!' + sLineBreak + 'Клиент: ' +
        FDQueryVisits.FieldByName('full_name').AsString + sLineBreak +
        'Время входа: ' + FormatDateTime('hh:nn:ss', EntryTime) + sLineBreak +
        'Время выхода: ' + FormatDateTime('hh:nn:ss', ExitTime) + sLineBreak +
        'Длительность тренировки: ' + IntToStr(DurationMinutes) + ' минут' +
        sLineBreak + '    (' + FormatFloat('0.0', DurationMinutes / 60) +
        ' часов)');

      // 7. Обновляем список посещений
      LoadVisits;

    finally
      Query.Free;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Ошибка при регистрации выхода: ' + E.Message);
    end;
  end;
end;



procedure TformMain.mnClientsReportClick(Sender: TObject);
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Нет подключения к базе данных!');
    Exit;
  end;
  ShowClientsReport;
end;

// Отчет по абонементам
procedure TformMain.mnSubscriptionsReportClick(Sender: TObject);
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Нет подключения к базе данных!');
    Exit;
  end;
  ShowSubscriptionsReport;
end;

// Отчет по посещениям
procedure TformMain.mnVisitsReportClick(Sender: TObject);
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Нет подключения к базе данных!');
    Exit;
  end;
  ShowVisitsReport;
end;

// Отчет по тренерам
procedure TformMain.mnTrainerReportClick(Sender: TObject);
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Нет подключения к базе данных!');
    Exit;
  end;
  ShowTrainerReport;
end;

// Экспорт в Excel
procedure TformMain.mnExportExcelClick(Sender: TObject);
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Нет подключения к базе данных!');
    Exit;
  end;
  ExportToExcel;
end;


procedure TformMain.edtSearchChange(Sender: TObject);
begin
  FSearchText := Trim(edtSearch.Text);
  ApplySearchFilter;
end;

procedure TformMain.btnClearSearchClick(Sender: TObject);
begin
  edtSearch.Text := '';
  FSearchText := '';
  ApplySearchFilter;
  edtSearch.SetFocus;
end;

procedure TformMain.rbSearchClick(Sender: TObject);
begin
  if Sender = rbName then
    FSearchField := 0
  else if Sender = rbPhone then
    FSearchField := 1
  else if Sender = rbEmail then
    FSearchField := 2;

  ApplySearchFilter;
end;

procedure TformMain.ApplySearchFilter;
var
  TotalCount: Integer;
  FilterExpr: string;
   SearchText: string;
begin
  if not DB.IsConnected or not FDQueryClients.Active then
  begin
      Exit;
  end;


  TotalCount := FDQueryClients.RecordCount;

  FDQueryClients.Filtered := False;

 if Trim(FSearchText) <> '' then
  begin
    // Переводим в ВЕРХНИЙ РЕГИСТР (работает и с русскими буквами!)
    SearchText := AnsiUpperCase(Trim(FSearchText));
    SearchText := StringReplace(SearchText, '''', '''''', [rfReplaceAll]);

    case FSearchField of
      0: FilterExpr := 'UPPER(full_name) LIKE ''%' + SearchText + '%''';   // ФИО
      1: FilterExpr := 'UPPER(phone) LIKE ''%' + SearchText + '%''';       // Телефон
      2: FilterExpr := 'UPPER(email) LIKE ''%' + SearchText + '%''';       // Email
    else
      FilterExpr := 'UPPER(full_name) LIKE ''%' + SearchText + '%''';
    end;


    FDQueryClients.Filter := FilterExpr;
    FDQueryClients.Filtered := True;

    if FDQueryClients.RecordCount > 0 then
      StatusBar1.Panels[1].Text := Format('Найдено: %d из %d',
        [FDQueryClients.RecordCount, TotalCount])
    else
      StatusBar1.Panels[1].Text := 'Ничего не найдено';
  end
  else
  begin
    FDQueryClients.Filtered := False;
    StatusBar1.Panels[1].Text := 'Клиентов: ' + IntToStr(FDQueryClients.RecordCount);
  end;
end;
// procedure TformMain.LoadSubscriptions;
// begin
//
// end;
//
//
// procedure TformMain.LoadVisits;
// begin
//
// end;

function TformMain.GetTodayVisitsCount: Integer;
var
  Query: TFDQuery;
begin
  Result := 0;
  if not DB.IsConnected then Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;
    Query.SQL.Text := 'SELECT COUNT(*) as cnt FROM visits WHERE visit_date = date(''now'')';
    Query.Open;
    Result := Query.FieldByName('cnt').AsInteger;
  finally
    Query.Free;
  end;
end;

function TformMain.GetActiveSubscriptionsCount: Integer;
var
  Query: TFDQuery;
begin
  Result := 0;
  if not DB.IsConnected then Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;
    Query.SQL.Text :=
      'SELECT COUNT(*) as cnt FROM subscriptions ' +
      'WHERE is_active = 1 AND date(end_date) >= date(''now'')';
    Query.Open;
    Result := Query.FieldByName('cnt').AsInteger;
  finally
    Query.Free;
  end;
end;

procedure TformMain.UpdateStatusBar;
var
  ClientCount, SubCount, VisitCount, TodayVisits, ActiveSubs: Integer;
begin
  if not DB.IsConnected then
  begin
    StatusBar1.Panels[0].Text := '🔴 БД: не подключена';
    StatusBar1.Panels[1].Text := '⚠️ Нет данных';
    StatusBar1.Panels[2].Text := '📊 Статистика: 0';
    Exit;
  end;

  // Получаем данные
  ClientCount := FDQueryClients.RecordCount;
  SubCount := FDQuerySubscriptions.RecordCount;
  VisitCount := FDQueryVisits.RecordCount;
  TodayVisits := GetTodayVisitsCount;
  ActiveSubs := GetActiveSubscriptionsCount;

  // Обновляем панели
  StatusBar1.Panels[0].Text := Format('🟢 БД: %s', [ExtractFileName(FDBPath)]);
  StatusBar1.Panels[1].Text := Format('👥 Клиенты: %d | 📋 Абонементы: %d (актив: %d)',
    [ClientCount, SubCount, ActiveSubs]);
  StatusBar1.Panels[2].Text := Format('✅ Посещений сегодня: %d | Всего: %d',
    [TodayVisits, VisitCount]);
end;

procedure TformMain.SetupToolbarButtons;
begin
  // Настройка панели
  PanelToolbar.Color := clWhite;
  PanelToolbar.Height := 48;
  PanelToolbar.BevelOuter := bvNone;

  // Настройка кнопок
  btnNewClient.Caption := '➕ Новый клиент';
  btnNewClient.Hint := 'Добавить нового клиента (F2)';
  btnNewClient.ShowHint := True;

  btnNewVisit.Caption := '🚪 Вход/Выход';
  btnNewVisit.Hint := 'Зарегистрировать вход или выход (F3)';
  btnNewVisit.ShowHint := True;

  btnNewSubscription.Caption := '📋 Абонемент';
  btnNewSubscription.Hint := 'Оформить новый абонемент (F4)';
  btnNewSubscription.ShowHint := True;

  btnRefresh.Caption := '🔄 Обновить';
  btnRefresh.Hint := 'Обновить данные (F5)';
  btnRefresh.ShowHint := True;


end;
// ========== ГОРЯЧИЕ КЛАВИШИ ==========

procedure TformMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F2: btnNewClient.Click;
    VK_F3: btnNewVisit.Click;
    VK_F4: btnNewSubscription.Click;
    VK_F5: btnRefresh.Click;
  end;
end;

procedure TformMain.mnuHelpClick(Sender: TObject);
begin
  ShowMessage(
    '📖 СПРАВКА ПО ПРОГРАММЕ' + sLineBreak + sLineBreak +
    '─────────────────────────────────────────────' + sLineBreak +
    '  БЫСТРЫЕ КЛАВИШИ:                           ' + sLineBreak +
    '─────────────────────────────────────────────' + sLineBreak +
    '  F2  - Новый клиент                         ' + sLineBreak +
    '  F3  - Вход/Выход                           ' + sLineBreak +
    '  F4  - Новый абонемент                      ' + sLineBreak +
    '  F5  - Обновить                             ' + sLineBreak +
    '  F6  - Вкладка "Клиенты"                    ' + sLineBreak +
    '  F7  - Вкладка "Абонементы"                 ' + sLineBreak +
    '  F8  - Вкладка "Посещения"                  ' + sLineBreak +
    '─────────────────────────────────────────────' + sLineBreak + sLineBreak +
    '📌 РАБОТА С КЛИЕНТАМИ:' + sLineBreak +
    '• Двойной клик по клиенту - редактирование/удаление' + sLineBreak +
    '• Поиск клиентов - по ФИО, телефону или Email' + sLineBreak + sLineBreak +
    '📌 РАБОТА С ПОСЕЩЕНИЯМИ:' + sLineBreak +
    '• Двойной клик по посещению - завершение тренировки' + sLineBreak +
    '• При входе клиента автоматически проверяется абонемент' + sLineBreak + sLineBreak +
    '📌 ОТЧЕТЫ:' + sLineBreak +
    '• Все отчеты можно экспортировать в Excel' + sLineBreak +
    '• Статистика обновляется автоматически'
  );
end;

procedure TformMain.mnuAboutClick(Sender: TObject);
begin
  ShowMessage(
    '🏋️ ФИТНЕС-ЦЕНТР' + sLineBreak +
    'Журнал посещений' + sLineBreak + sLineBreak +
    'Версия: 1.0.0' + sLineBreak + sLineBreak +
    'Разработчик: Савченко Владислав' + sLineBreak + sLineBreak +
    '─────────────────────────────────────────────' + sLineBreak + sLineBreak +
    'Функционал программы:' + sLineBreak +
    '• Ведение базы данных клиентов' + sLineBreak +
    '• Оформление и учет абонементов' + sLineBreak +
    '• Регистрация посещений (вход/выход)' + sLineBreak +
    '• Расчет длительности тренировок' + sLineBreak +
    '• Генерация отчетов (клиенты, абонементы, посещения)' + sLineBreak +
    '• Статистика по тренерам и часам' + sLineBreak +
    '• Экспорт отчетов в Excel' + sLineBreak +
    '• Поиск и фильтрация данных' + sLineBreak + sLineBreak +
    '─────────────────────────────────────────────' + sLineBreak + sLineBreak +
    '© 2026 Фитнес-центр'
  );
end;


end.

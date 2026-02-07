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
    btnTestDB: TButton;
    DataSourceClients: TDataSource;
    FDQueryClients: TFDQuery;
    DBGridClients: TDBGrid;
    FDQuerySubscriptions: TFDQuery;
    FDQueryVisits: TFDQuery;
    DataSourceSubscriptions: TDataSource;
    DataSourceVisits: TDataSource;
    StatusBar1: TStatusBar;
    procedure RegisterVisitExit(VisitID: Integer);
    procedure btnNewClientClick(Sender: TObject);
    procedure btnNewVisitClick(Sender: TObject);
    procedure btnNewSubscriptionClick(Sender: TObject);    // ДОБАВИТЬ эту строку
    procedure FormDestroy(Sender: TObject);   // ДОБАВИТЬ эту строку
    procedure FormCreate(Sender: TObject);
    procedure LoadClients;
    procedure LoadSubscription;
    procedure LoadVisits;
    procedure btnRefreshClick(Sender: TObject);
////    procedure LoadSubscriptions;
////    procedure LoadVisits;
    procedure PageControl1Change(Sender: TObject);
    procedure LoadStatistics;
    procedure DBGridVisitsDblClick(Sender: TObject);
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

    StatusBar1.Panels[1].Text := 'БД: не найдена';
    Exit; // Выходим, т.к. без БД приложение не может работать
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
      'CAST(subscription_type AS VARCHAR(100)) AS subscription_type, ' +
      'start_date, ' +
      'end_date, ' +
      'price, ' +
      'visit_count, ' +
      'remaining_visit, ' +
      'is_active, ' +
      'CAST(notes AS VARCHAR(100)) AS notes ' +
      'FROM subscriptions ' +
      'ORDER BY start_date DESC';

    FDQuerySubscriptions.Open;

     FDQuerySubscriptions.FieldByName('subscription_type').DisplayWidth := 10;
     FDQuerySubscriptions.FieldByName('notes').DisplayWidth := 25;


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



    // 4. Открываем запрос
    FDQueryClients.Open;



    // 5. Настройка ширины колонок
    FDQueryClients.FieldByName('full_name').DisplayWidth := 25;
    FDQueryClients.FieldByName('phone').DisplayWidth := 15;
    FDQueryClients.FieldByName('email').DisplayWidth := 30;
    FDQueryClients.FieldByName('membership_type').DisplayWidth := 20;

    // 6. Принудительное обновление DBGrid
    DBGridClients.Refresh;
    DBGridClients.Repaint;

    // 7. Обновляем статус
    StatusBar1.Panels[1].Text := 'Клиентов: ' + IntToStr(FDQueryClients.RecordCount);


  except
    on E: Exception do
    begin
      ShowMessage('Ошибка загрузки клиентов: ' + E.Message);
    end;
  end;
end;

procedure TformMain.PageControl1Change(Sender: TObject);
begin
  if not DB.IsConnected then Exit;

  case PageControl1.ActivePageIndex of
    0: begin
          LoadClients;
          StatusBar1.Panels[0].Text := 'Таблица: Клиенты';
          StatusBar1.Panels[1].Text := 'Клиентов: ' +
           IntToStr(FDQueryClients.RecordCount);
       end;
    1: begin
          LoadSubscription  ;
          StatusBar1.Panels[0].Text := 'Таблица: Абонементы';
          StatusBar1.Panels[1].Text := 'Абонементы: ' +
           IntToStr(FDQuerySubscriptions.RecordCount);
       end;
    3: begin
          LoadVisits  ;
          StatusBar1.Panels[0].Text := 'Таблица: Посещения';
          StatusBar1.Panels[1].Text := 'Посещений: ' +
           IntToStr(FDQueryVisits.RecordCount);
       end;
  end;
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
    ClientForm.IsEditMode := False;
    ClientForm.Caption := 'Добавить нового клиента';

    // Просто показываем форму
    // Форма сама сохраняет данные
    if ClientForm.ShowModal = mrOk then
    begin
      // Клиент уже сохранен формой
      // Просто обновляем список
      LoadClients;

      // Можно показать ID сохраненного клиента
      ShowMessage('Клиент добавлен! ID: ' + IntToStr(ClientForm.ClientID));
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


procedure TformMain.DBGridVisitsDblClick(Sender: TObject);
begin
    if FDQueryVisits.IsEmpty  then
    begin
        ShowMessage('Нет данных в таблице!!');
        exit;
    end;

     var VisitID := FDQueryVisits.FieldByName('id').AsInteger;
      var ClientName := FDQueryVisits.FieldByName('full_name').AsString;

        var ExitTimeField := FDQueryVisits.FieldByName('exit_time');

        if ExitTimeField.IsNull then
        begin
           var Response := MessageDlg(
      'Зарегистрировать выход ' + ClientName + '?',
      mtConfirmation,
      [mbYes, mbNo],
      0);

      if Response = mrYes then
      begin
          RegisterVisitExit(VisitID)  /// Тут функция  ///
      end;

        end
        else
        begin
          ShowMessage(
      ClientName + ' уже завершил(а) посещение' + sLineBreak +
      'Время выхода: ' + ExitTimeField.AsString
    );
        end;


end;


procedure TformMain.RegisterVisitExit(VisitID: Integer);
var
  ExitTime: TTime;
  Query: TFDQuery;
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

     Query.SQL.Text :=
        'UPDATE visits ' +
        'SET exit_time = :exit_time, ' +
        'duration_minutes = :duration ' +
        'WHERE id = :id';

     Query.ParamByName('exit_time').AsString := FormatDateTime('hh:nn:ss', ExitTime);
      Query.ParamByName('duration').AsInteger := 60; // Пока заглушка - потом рассчитаем
      Query.ParamByName('id').AsInteger := VisitID;

         Query.ExecSQL;

          ShowMessage('Выход успешно зарегистрирован!');

           LoadVisits;
     finally
       Query.Free;
     end;
  except
    on E: Exception do
    begin
      ShowMessage('Ошибка: ' + E.Message);
    end;
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




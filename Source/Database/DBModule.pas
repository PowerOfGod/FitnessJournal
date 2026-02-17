unit DBModule;

interface

uses
  System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, VCL.Dialogs, System.Variants;

type
  TDBModule = class(TObject)
  private
    FConnection: TFDConnection;
    FDriverLink: TFDPhysSQLiteDriverLink;
    FDBPath: string;
    FIsConnected: Boolean;
    procedure InitializeConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function UpdateClient(ClientID: Integer; FullName, Phone, Email,
      MembershipType: string; BirthDate: TDate): Boolean;
    function ConnectToDB(const DBPath: string): Boolean;
    function DisconnectFromDB: Boolean;
    function IsConnected: Boolean;
    function GetConnection: TFDConnection;
     function HasActiveVisit(ClientID: Integer): Boolean;
    function ClientExists(ClientID: Integer): Boolean;
    function GetClientByID(ClientID: Integer): TFDMemTable;
    function GetClients: TFDMemTable;
    function GetSubscriptions: TFDMemTable;
    function GetVisits: TFDMemTable;
    function UpdateVisitExit(VisitID: Integer; ExitTime: TTime): Boolean;

    function AddClient(fullName: string; email: string;
    membershipType: string; registrationDate: TDate;
     Phone: string; isActive: Boolean; BirthDate: TDate): Integer;
    function  AddVisit(ClientID: Integer; VisitDate: TDate;
                            EntryTime, ExitTime: TTime;
                            TrainerName, Notes: string): Integer;
    function AddSubscription(ClientID: Integer;
                                   SubscriptionType: string;
                                   StartDate, EndDate: TDate;
                                   Price: Double;
                                   VisitsCount: Integer = 0;
  RemainingVisits: Integer = 0): Integer;

    property DBPath: string read FDBPath;
    property Connected: Boolean read FIsConnected;
  end;

var
  DB: TDBModule;

implementation

{ TDBModule }

constructor TDBModule.Create;
begin
  inherited;
  FIsConnected := False;
  FDBPath := '';

  // Создаем компоненты
  FDriverLink := TFDPhysSQLiteDriverLink.Create(nil);
  FConnection := TFDConnection.Create(nil);

  InitializeConnection;
end;

destructor TDBModule.Destroy;
begin
  DisconnectFromDB;

  if Assigned(FConnection) then
    FreeAndNil(FConnection);

  if Assigned(FDriverLink) then
    FreeAndNil(FDriverLink);

  inherited;
end;

procedure TDBModule.InitializeConnection;
begin
  FConnection.Params.Clear;
  FConnection.Params.Add('DriverID=SQLite');
  FConnection.Params.Add('LockingMode=Normal');
  FConnection.Params.Add('Synchronous=Normal');
  FConnection.Params.Add('SharedCache=False');
  FConnection.LoginPrompt := False;
end;

function TDBModule.HasActiveVisit(ClientID: Integer): Boolean;
var
  Query: TFDQuery;
  Count: Integer;
begin
  Result := False;

  if not FIsConnected then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    // Простой подсчет
  Query.SQL.Text :=
  'SELECT COUNT(*) as cnt FROM visits ' +
  'WHERE client_id = :client_id ' +
  'AND (exit_time IS NULL OR exit_time = '''')';

    Query.ParamByName('client_id').AsInteger := ClientID;
    Query.Open;

    Count := Query.FieldByName('cnt').AsInteger;
    ShowMessage(IntToStr(Count));
    if Count > 0 then
    begin
      Result := True;
    end
    else
    begin
        Result := false;
    end;



    // Для отладки
    ShowMessage('HasActiveVisit: клиент ID=' + IntToStr(ClientID) +
                ', активных посещений=' + IntToStr(Count));

  finally
    Query.Free;
  end;
end;

function TDBModule.ClientExists(ClientID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;

  if not FIsConnected then Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    // Проверяем существование активного клиента
    Query.SQL.Text := 'SELECT 1 FROM clients WHERE id = :id AND is_active = 1';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

    Result := not Query.Eof; // Если запись найдена - клиент существует
    Query.Close;

  finally
    Query.Free;
  end;
end;

function TDBModule.ConnectToDB(const DBPath: string): Boolean;
begin
  Result := False;

  try
    // Проверяем существование файла БД
    if not FileExists(DBPath) then
      raise Exception.Create('Файл базы данных не найден!' + #13#10 + 'Путь: ' + DBPath);

    // Отключаемся, если уже подключены
    if FConnection.Connected then
      FConnection.Connected := False;

    // Устанавливаем путь и подключаемся
    FConnection.Params.Values['Database'] := DBPath;
    FConnection.Connected := True;

    FDBPath := DBPath;
    FIsConnected := True;
    Result := True;

  except
    on E: Exception do
    begin
      FIsConnected := False;
      raise Exception.Create('Ошибка подключения к БД:' + #13#10 + E.Message);
    end;
  end;
end;

function TDBModule.DisconnectFromDB: Boolean;
begin
  Result := False;

  try
    if FConnection.Connected then
    begin
      FConnection.Connected := False;
      FIsConnected := False;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Ошибка отключения от БД:' + #13#10 + E.Message);
    end;
  end;
end;

function TDBModule.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

function TDBModule.IsConnected: Boolean;
begin
  Result := FIsConnected;
end;


function TDBModule.GetClients: TFDMemTable;
var
  Query : TFDQuery;
begin

  Result := TFDMemTable.Create(nil);

  if not FIsConnected then raise Exception.Create('Нет подключения к базе данных');

  Query := TFDQuery.Create(nil);
  try
      Query.Connection := FConnection;
      Query.SQL.Text := 'SELECT * FROM clients ORDER BY full_name';
       Query.Open;

      Result.data := Query.data;
       finally
    Query.Free;
  end;


end;


function TDBModule.GetSubscriptions: TFDMemTable;
var
  Query :TFDQuery;
begin

Result := TFDMemTable.Create(nil);
        if not FIsConnected then raise Exception.Create('Нет подключения к базе данных');
        Query := TFDQuery.Create(nil);
        try
             Query.Connection := FConnection;
              Query.SQL.Text := 'SELECT * FROM subscriptions ORDER BY start_date DESC';
              Query.Open;

               if not Query.IsEmpty then
      Result.Data := Query.Data;

      finally
    Query.Free;
  end;

end;


function TDBModule.GetVisits: TFDMemTable;
var
  Query :TFDQuery;
begin

Result := TFDMemTable.Create(nil);
        if not FIsConnected then raise Exception.Create('Нет подключения к базе данных');
        Query := TFDQuery.Create(nil);
        try
             Query.Connection := FConnection;
              Query.SQL.Text := 'SELECT v.*, c.full_name FROM visits v ' +
                      'LEFT JOIN clients c ON v.client_id = c.id ' +
                      'ORDER BY v.visit_date DESC, v.entry_time DESC';
              Query.Open;

               if not Query.IsEmpty then
      Result.Data := Query.Data;


         finally
    Query.Free;
  end;

end;

function TDBModule.AddClient(fullName: string;
  email: string; membershipType: string;
  registrationDate: TDate; Phone: string; isActive: Boolean;
  BirthDate: TDate): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;  // По умолчанию ошибка

  if not FIsConnected then
    raise Exception.Create('Нет подключения к базе данных');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    // ВАЖНО: Начинаем транзакцию
    if not FConnection.InTransaction then
      FConnection.StartTransaction;

    try
      Query.SQL.Text :=
        'INSERT INTO clients (' +
        '  full_name, ' +
        '  email, ' +
        '  membership_type, ' +
        '  registration_date, ' +
        '  phone, ' +
        '  is_active, ' +
        '  birth_date' +
        ') VALUES (' +
        '  :full_name, ' +
        '  :email, ' +
        '  :membership_type, ' +
        '  :registration_date, ' +
        '  :phone, ' +
        '  :is_active, ' +
        '  :birth_date' +
        ')';

      // Используем AsDateTime для дат
      Query.ParamByName('full_name').AsString := fullName;
      Query.ParamByName('email').AsString := email;
      Query.ParamByName('membership_type').AsString := membershipType;
      Query.ParamByName('registration_date').AsDateTime := registrationDate;
      Query.ParamByName('phone').AsString := Phone;
      Query.ParamByName('is_active').AsBoolean := isActive;
      Query.ParamByName('birth_date').AsDateTime := BirthDate;

      Query.ExecSQL;

      // Получаем ID новой записи
      Query.SQL.Text := 'SELECT last_insert_rowid() as new_id';
      Query.Open;

      if not Query.Eof then
        Result := Query.FieldByName('new_id').AsInteger;

      Query.Close;

      // ВАЖНО: Коммитим транзакцию
      if FConnection.InTransaction then
        FConnection.Commit;

    except
      on E: Exception do
      begin
        // Откатываем при ошибке
        if FConnection.InTransaction then
          FConnection.Rollback;
        raise;
      end;
    end;

  finally
    Query.Free;  // ← Освобождаем Query в любом случае
  end;
end;



function TDBModule.AddSubscription(ClientID: Integer;
                                   SubscriptionType: string;
                                   StartDate, EndDate: TDate;
                                   Price: Double;
                                   VisitsCount: Integer = 0;
  RemainingVisits: Integer = 0): Integer;
var
   Query: TFDQuery;
begin
    if not FIsConnected then
      raise Exception.Create('Нет подключения к базе данных');

      Query := TFDQuery.Create(nil);
      try

      Query.Connection := FConnection;

      Query.SQL.Text := 'INSERT INTO subscriptions (' +
        '  client_id,' +
        '  subscription_type, ' +
        '  start_date, ' +
        '  end_date, ' +
        '  price, '     +
        '  visit_count, ' +
        '  remaining_visit, ' +
        '  is_active ' +
        ') VALUES ( ' +
        '  :client_id, ' +
        '  :subscription_type, ' +
        '  :start_date, ' +
        '  :end_date, ' +
        '  :price, ' +
        '  :visits_count, ' +
        '  :remaining_visits, ' +
        '  1 )';


      Query.ParamByName('client_id').AsInteger := ClientID;
      Query.ParamByName('price').AsCurrency := Price;  // Лучше AsCurrency для денег
      Query.ParamByName('subscription_type').AsString := SubscriptionType;
      Query.ParamByName('start_date').AsDate := StartDate;
      Query.ParamByName('end_date').AsDate := EndDate;
      Query.ParamByName('visits_count').AsInteger := VisitsCount;
      Query.ParamByName('remaining_visits').AsInteger := RemainingVisits;

      Query.ExecSQL;

      Query.SQL.Text := '';

      Query.SQL.Text := 'SELECT last_insert_rowid() as new_id';
      Query.Open;
      Result := Query.FieldByName('new_id').AsInteger;
      finally
         Query.Free;
      end;

end;

function TDBModule.AddVisit(ClientID: Integer; VisitDate: TDate;
  EntryTime, ExitTime: TTime; TrainerName, Notes: string): Integer;
var
  Query: TFDQuery;
  DurationMinutes: Integer;
begin
  Result := -1;

  // 1. Проверка подключения к БД
  if not FIsConnected then
    raise Exception.Create('Нет подключения к базе данных');

  // 2. Проверка существования клиента (ДОБАВЛЕНО!)
  if not ClientExists(ClientID) then
    raise Exception.Create('Клиент с ID=' + IntToStr(ClientID) + ' не найден или не активен');

  // 3. Проверка входных данных
  if ClientID <= 0 then
    raise Exception.Create('Неверный ID клиента');

  if VisitDate = 0 then
    raise Exception.Create('Не указана дата посещения');

  if EntryTime = 0 then
    raise Exception.Create('Не указано время входа');

  if TrainerName = '' then
    raise Exception.Create('Не указано имя тренера');

  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := FConnection;

      // 4. Вычисляем длительность посещения (если exit_time задан)
      if ExitTime > 0 then
      begin
        // Проверяем, что время выхода позже времени входа
        if ExitTime < EntryTime then
          raise Exception.Create('Время выхода не может быть раньше времени входа');

        // Вычисляем разницу в минутах
        DurationMinutes := Round((ExitTime - EntryTime) * 24 * 60);
      end
      else
      begin
        // Клиент еще не вышел - длительность = 0
        DurationMinutes := 0;
      end;

      // 5. Формируем SQL запрос
      Query.SQL.Text :=
        'INSERT INTO visits (' +
        'client_id, visit_date, entry_time, ' +
        'exit_time, duration_minutes, trainer_name, notes' +
        ') VALUES (' +
        ':client_id, :visit_date, :entry_time, ' +
        ':exit_time, :duration_minutes, :trainer_name, :notes' +
        ')';

      // 6. Устанавливаем параметры
      Query.ParamByName('client_id').AsInteger := ClientID;
      Query.ParamByName('visit_date').AsDate := VisitDate;

      // Время храним как строку в формате "HH:MM:SS"
      Query.ParamByName('entry_time').AsString :=
        FormatDateTime('hh:nn:ss', EntryTime);

      // Обработка exit_time: если 0, то NULL (клиент еще не вышел)
      if ExitTime > 0 then
  Query.ParamByName('exit_time').AsString := FormatDateTime('hh:nn:ss', ExitTime)
else  Query.ParamByName('exit_time').AsString := '';





      Query.ParamByName('duration_minutes').AsInteger := DurationMinutes;
      Query.ParamByName('trainer_name').AsString := TrainerName;
      Query.ParamByName('notes').AsString := Notes;

      // 7. Выполняем запрос
      Query.ExecSQL;

      // 8. Получаем ID добавленной записи
      Query.SQL.Text := 'SELECT last_insert_rowid() as new_id';
      Query.Open;

      if not Query.Eof then
        Result := Query.FieldByName('new_id').AsInteger
      else
        Result := -1; // Не удалось получить ID

      Query.Close;

    except
      on E: Exception do
      begin
        // Логируем ошибку (можно добавить запись в лог)
        raise Exception.Create('Ошибка при добавлении посещения: ' + E.Message);
      end;
    end;

  finally
    Query.Free;
  end;
end;

function TDBModule.UpdateVisitExit(VisitID: Integer; ExitTime: TTime): Boolean;
var
  Query: TFDQuery;
  EntryTimeStr: string;
  EntryTime, Duration: Double;
begin
  Result := False;

  if not FIsConnected then Exit;
  if VisitID <= 0 then Exit;
  if ExitTime = 0 then Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    // 1. Получаем время входа для этого посещения
    Query.SQL.Text := 'SELECT entry_time FROM visits WHERE id = :id';
    Query.ParamByName('id').AsInteger := VisitID;
    Query.Open;

    if Query.Eof then
    begin
      ShowMessage('Посещение не найдено');
      Exit;
    end;

    EntryTimeStr := Query.FieldByName('entry_time').AsString;
    Query.Close;

    // 2. Преобразуем строку времени в TTime
    // Предполагаем формат "HH:MM:SS"
    EntryTime := StrToTime(EntryTimeStr);

    // 3. Проверяем, что время выхода позже времени входа
    if ExitTime <= EntryTime then
    begin
      ShowMessage('Время выхода должно быть позже времени входа');
      Exit;
    end;

    // 4. Вычисляем длительность в минутах
    Duration := (ExitTime - EntryTime) * 24 * 60; // в минутах

    // 5. Обновляем запись посещения
    Query.SQL.Text :=
      'UPDATE visits SET ' +
      'exit_time = :exit_time, ' +
      'duration_minutes = :duration ' +
      'WHERE id = :id';

    Query.ParamByName('exit_time').AsString := FormatDateTime('hh:nn:ss', ExitTime);
    Query.ParamByName('duration').AsInteger := Round(Duration);
    Query.ParamByName('id').AsInteger := VisitID;

    Query.ExecSQL;
    Result := Query.RowsAffected > 0;

  finally
    Query.Free;
  end;
end;

function TDBModule.GetClientByID(ClientID: Integer): TFDMemTable;
var
  Query: TFDQuery;
begin

Result := TFDMemTable.Create(nil);
  if not FIsConnected then
    raise Exception.Create('Нет подключения к базе данных');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT * FROM clients WHERE id = :id';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

     if not Query.IsEmpty then
      Result.Data := Query.Data;

        finally
    Query.Free;
  end;
end;


function TDBModule.UpdateClient(ClientID: Integer; FullName, Phone, Email,
  MembershipType: string; BirthDate: TDate): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;

  if not FIsConnected then
    raise Exception.Create('Нет подключения к базе данных');

  if ClientID <= 0 then
    raise Exception.Create('Неверный ID клиента');

  Query := TFDQuery.Create(nil);
  try  // Внешний try..finally для освобождения Query
    Query.Connection := FConnection;

    // Начинаем транзакцию
    if not FConnection.InTransaction then
      FConnection.StartTransaction;

    try  // Внутренний try..except для обработки ошибок БД
      Query.SQL.Text :=
        'UPDATE clients SET ' +
        'full_name = :full_name, ' +
        'phone = :phone, ' +
        'email = :email, ' +
        'birth_date = :birth_date, ' +
        'membership_type = :membership_type ' +
        'WHERE id = :id';

      Query.ParamByName('full_name').AsString := FullName;
      Query.ParamByName('phone').AsString := Phone;
      Query.ParamByName('email').AsString := Email;
      Query.ParamByName('birth_date').AsDateTime := BirthDate;
      Query.ParamByName('membership_type').AsString := MembershipType;
      Query.ParamByName('id').AsInteger := ClientID;

      Query.ExecSQL;

      Result := Query.RowsAffected > 0;

      // Фиксируем транзакцию
      if FConnection.InTransaction then
        FConnection.Commit;

    except
      on E: Exception do
      begin
        // Откатываем при ошибке
        if FConnection.InTransaction then
          FConnection.Rollback;

        // Пробрасываем ошибку дальше
        raise Exception.Create('Ошибка обновления клиента: ' + E.Message);
      end;
    end;  // Конец внутреннего try..except

  finally
    Query.Free;  // Освобождаем Query в любом случае
  end;
end;

initialization

DB := TDBModule.Create;

finalization

if Assigned(DB) then
  FreeAndNil(DB);

end.

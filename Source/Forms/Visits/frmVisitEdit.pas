unit frmVisitEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DBModule,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TfrmVisitEdit1 = class(TForm)
    lblClient: TLabel;
    cbClient: TComboBox;
    lblPhone: TLabel;
    edtPhone: TEdit;
    lblSubscription: TLabel;
    edtSubscription: TEdit;
    lblTrainer: TLabel;
    lblNotes: TLabel;
    memoNotes: TMemo;
    btnEntry: TButton;
    btnExit: TButton;
    btnCancel: TButton;
    cbTrainer: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure cbClientChange(Sender: TObject);
    procedure btnEntryClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure memoNotesChange(Sender: TObject);
    procedure LoadClients;
    procedure LoadClientInfo(ClientID: Integer);

  private
    FMode: (modeEntry, modeExit);
    FClientID : Integer;
    FIsEntryRegistered : Boolean;
    FVisitID: Integer;
    FEntryTime: TDateTime;


    { Private declarations }
  public

    property ClientID: Integer read FClientID;
    property IsEntryRegistered: Boolean read FIsEntryRegistered;
    { Public declarations }
  end;

var
  frmVisitEdit1: TfrmVisitEdit1;

implementation

{$R *.dfm}




procedure TfrmVisitEdit1.cbClientChange(Sender: TObject);
begin
  // ========== ШАГ 1: ПРОВЕРКА, ЧТО ВЫБРАН КЛИЕНТ ==========

  if cbClient.ItemIndex >= 0 then
  begin
    // ========== ШАГ 2: ПОЛУЧАЕМ ID КЛИЕНТА ==========

    // ВАЖНО: В Items.Objects мы сохранили ID клиента при загрузке
    // Сейчас мы его извлекаем и преобразуем обратно в Integer
    FClientID := Integer(cbClient.Items.Objects[cbClient.ItemIndex]);

    // Отладка (можно убрать в релизе)
    ShowMessage('Выбран клиент ID=' + IntToStr(FClientID) +
                ', проверяем активное посещение...');

    // ========== ШАГ 3: ЗАГРУЖАЕМ ДАННЫЕ КЛИЕНТА ==========

    // Загружаем телефон и информацию об абонементе
    LoadClientInfo(FClientID);

    // ========== ШАГ 4: ПРОВЕРЯЕМ АКТИВНОЕ ПОСЕЩЕНИЕ ==========

    // Вызываем метод из DBModule, который проверяет, есть ли незавершенное посещение
    if DB.HasActiveVisit(FClientID) then
    begin
      // ========== РЕЖИМ ВЫХОДА (клиент уже внутри) ==========

      ShowMessage('ЕСТЬ активное посещение! Переключаем в режим выхода');

      FMode := modeExit;  // Устанавливаем режим "Выход"

      // Настраиваем кнопки
      btnEntry.Enabled := False;        // Вход недоступен
      btnEntry.Caption := 'Вход (недоступен)';

      btnExit.Enabled := True;          // Выход доступен
      btnExit.Caption := 'ЗАВЕРШИТЬ ПОСЕЩЕНИЕ';

      // Блокируем поля ввода (нельзя менять данные во время тренировки)
      cbClient.Enabled := False;        // Нельзя сменить клиента
      cbTrainer.Enabled := False;       // Нельзя сменить тренера
      memoNotes.ReadOnly := True;       // Нельзя менять заметки

      // ========== ШАГ 5: НАХОДИМ ID АКТИВНОГО ПОСЕЩЕНИЯ ==========

      var Query := TFDQuery.Create(nil);
      try
        Query.Connection := DB.GetConnection;
        Query.SQL.Text :=
          'SELECT id FROM visits ' +
          'WHERE client_id = :id AND (exit_time IS NULL OR exit_time = '''')';
        Query.ParamByName('id').AsInteger := FClientID;
        Query.Open;

        if not Query.Eof then
        begin
          FVisitID := Query.FieldByName('id').AsInteger;
          ShowMessage('Найдено активное посещение ID=' + IntToStr(FVisitID));
        end;
      finally
        Query.Free;
      end;
    end
    else
    begin
      // ========== РЕЖИМ ВХОДА (новое посещение) ==========

      ShowMessage('НЕТ активного посещения. Режим входа');

      FMode := modeEntry;    // Устанавливаем режим "Вход"
      FVisitID := 0;         // Обнуляем ID посещения

      // Настраиваем кнопки
      btnEntry.Enabled := True;         // Вход доступен
      btnEntry.Caption := 'ВХОД';

      btnExit.Enabled := False;         // Выход недоступен
      btnExit.Caption := 'Выход';

      // Разблокируем поля ввода
      cbClient.Enabled := True;         // Можно сменить клиента
      cbTrainer.Enabled := True;        // Можно выбрать тренера
      memoNotes.ReadOnly := False;      // Можно писать заметки
    end;
  end
  else
  begin
    // ========== НИЧЕГО НЕ ВЫБРАНО ==========

    FClientID := 0;
    FVisitID := 0;

    // Очищаем поля
    edtPhone.Text := '';
    edtSubscription.Text := '';

    // Сбрасываем режим на вход
    FMode := modeEntry;
    btnEntry.Enabled := True;
    btnEntry.Caption := 'Вход';
    btnExit.Enabled := False;
    btnExit.Caption := 'Выход';

    // Разблокируем всё
    cbClient.Enabled := True;
    cbTrainer.Enabled := True;
    memoNotes.ReadOnly := False;
  end;
end;

procedure TfrmVisitEdit1.LoadClientInfo(ClientID: Integer);
var
  Query: TFDQuery;
begin

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;

    Query.SQL.Text := 'SELECT phone FROM clients WHERE id = :id';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

    if not Query.Eof then
      edtPhone.Text := Query.FieldByName('phone').AsString;

    Query.Close;

    Query.SQL.Text := 'SELECT subscription_type, end_date ' +
      'FROM subscriptions ' + 'WHERE client_id = :id AND is_active = 1 ' +
      'AND date(end_date) >= date(''now'') ' + 'LIMIT 1';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

      if not Query.Eof then
    begin
      edtSubscription.Text :=
        Query.FieldByName('subscription_type').AsString + ' (до ' +
        FormatDateTime('dd.mm.yyyy', Query.FieldByName('end_date').AsDateTime) + ')';
    end
    else
    begin
      edtSubscription.Text := 'Нет активного абонемента';
    end;


  finally
    Query.Free;
  end;

end;




procedure TfrmVisitEdit1.FormCreate(Sender: TObject);
begin

  FClientID := 0;
  FVisitID  := 0;
  FIsEntryRegistered := False;
  FMode := modeEntry;
  LoadClients;


  cbTrainer.Items.Clear;
  cbTrainer.Items.Add('Иван Петров');
  cbTrainer.Items.Add('Мария Сидорова');
  cbTrainer.Items.Add('Алексей Козлов');
  cbTrainer.Items.Add('Екатерина Новикова');

   if cbTrainer.Items.Count > 0 then
    cbTrainer.ItemIndex := 0;

  btnExit.Enabled := False;
  btnEntry.Enabled := True;

end;


procedure TfrmVisitEdit1.LoadClients;
var
  Query: TFDQuery;
  ClientID: Integer;
  ClientName: string;
begin
  // Очищаем ComboBox
  cbClient.Clear;

  // Проверяем подключение к БД
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;

  // Создаем запрос
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;

    // Загружаем только активных клиентов
    Query.SQL.Text :=
      'SELECT id, full_name FROM clients ' +
      'WHERE is_active = 1 ' +
      'ORDER BY full_name';
    Query.Open;

    // Пока есть записи
    while not Query.Eof do
    begin
      // Получаем данные из текущей записи
      ClientID := Query.FieldByName('id').AsInteger;
      ClientName := Query.FieldByName('full_name').AsString;

      // ВАЖНО: Добавляем в ComboBox строку + привязываем ID через Objects
      // TObject(ClientID) - это "хитрость" для хранения числа в Object
      cbClient.Items.AddObject(ClientName, TObject(ClientID));

      Query.Next;  // Переходим к следующей записи
    end;

  finally
    Query.Free;  // Освобождаем запрос
  end;

  // Если есть элементы, выбираем первый
  if cbClient.Items.Count > 0 then
    cbClient.ItemIndex := 0;
end;

procedure TfrmVisitEdit1.btnEntryClick(Sender: TObject);
var
  VisitDate: TDate;
  EntryTime: TTime;
  ExitTime: TTime;
  TrainerName: string;
  Notes: string;
begin
  // Дополнительная проверка - если мы в режиме выхода, кнопка должна быть неактивна
  if FMode = modeExit then
  begin
    ShowMessage('Сначала завершите текущее посещение!');
    Exit;
  end;

  // Проверка выбора клиента
  if cbClient.ItemIndex < 0 then
  begin
    ShowMessage('Выберите клиента!');
    cbClient.SetFocus;
    Exit;
  end;

  // Проверка выбора тренера
  if cbTrainer.ItemIndex < 0 then
  begin
    ShowMessage('Выберите тренера!');
    cbTrainer.SetFocus;
    Exit;
  end;

  // ПОСЛЕДНЯЯ ПРОВЕРКА - вдруг кто-то создал посещение параллельно
  if DB.HasActiveVisit(FClientID) then
  begin
    ShowMessage('У клиента уже есть активное посещение!' + sLineBreak +
                'Завершите его через кнопку "Выход"');
    // Обновим интерфейс
    cbClientChange(nil); // Перезагрузим состояние клиента
    Exit;
  end;

  // Получаем ID клиента
  FClientID := Integer(cbClient.Items.Objects[cbClient.ItemIndex]);

  // Подготавливаем данные
  VisitDate := Date;
  EntryTime := Time;
  ExitTime := 0;
  TrainerName := cbTrainer.Text;
  Notes := memoNotes.Text;

  // Сохраняем в БД
  try
    FVisitID := DB.AddVisit(
      FClientID,
      VisitDate,
      EntryTime,
      ExitTime,
      TrainerName,
      Notes
    );

    if FVisitID > 0 then
    begin
      FEntryTime := EntryTime;
      FIsEntryRegistered := True;

      // Переключаем в режим выхода
      FMode := modeExit;

      // Меняем интерфейс
      btnEntry.Enabled := False;
      btnEntry.Caption := 'Вход (недоступен)';
      btnExit.Enabled := True;
      btnExit.Caption := 'Завершить посещение';

      cbClient.Enabled := False;
      cbTrainer.Enabled := False;
      memoNotes.ReadOnly := True;

      ShowMessage(
        '✅ Вход зафиксирован!' + sLineBreak +
        'Клиент: ' + cbClient.Text + sLineBreak +
        'Время: ' + FormatDateTime('hh:nn:ss', EntryTime) + sLineBreak +
        'ID посещения: ' + IntToStr(FVisitID) + sLineBreak +
        sLineBreak +
        'Теперь нажмите "Завершить посещение", когда клиент будет уходить'
      );
    end
    else
    begin
      ShowMessage('❌ Ошибка: не удалось сохранить посещение');
    end;

  except
    on E: Exception do
    begin
      ShowMessage('❌ Ошибка при сохранении посещения:' + sLineBreak + E.Message);
    end;
  end;
end;

procedure TfrmVisitEdit1.btnExitClick(Sender: TObject);
var
  Query: TFDQuery;
  ActiveVisitID: Integer;
  EntryTime: TTime;
  ExitTime: TTime;
  DurationMinutes: Integer;
  EntryTimeStr: string;
  UserResponse: Integer;
begin
  // СНАЧАЛА проверяем выбран ли клиент
  if cbClient.ItemIndex < 0 then
  begin
    ShowMessage('Выберите клиента!');
    Exit;
  end;

  // ПОТОМ получаем ID клиента
  FClientID := Integer(cbClient.Items.Objects[cbClient.ItemIndex]);

  // ПОТОМ получаем текущее время выхода
  ExitTime := Time;  // ЭТО БЫЛО ПРОПУЩЕНО!

  // Ищем активное посещение
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;
    Query.SQL.Text :=
      'SELECT id, entry_time FROM visits ' +
      'WHERE client_id = :client_id ' +  // Используем параметры!
      ' AND (exit_time IS NULL OR exit_time = '''')';

    Query.ParamByName('client_id').AsInteger := FClientID;  // Правильно через параметры
    Query.Open;

    if Query.Eof then
    begin
      ShowMessage('Активное посещение не найдено!');
      Exit;
    end;

    // Нашли активное посещение
    ActiveVisitID := Query.FieldByName('id').AsInteger;

    // Время входа нужно преобразовать правильно
    EntryTimeStr := Query.FieldByName('entry_time').AsString;
    try
      EntryTime := StrToTime(EntryTimeStr);
    except
      ShowMessage('Ошибка преобразования времени входа: ' + EntryTimeStr);
      Exit;
    end;

    Query.Close;

    // Проверяем корректность времени
    if ExitTime < EntryTime then
    begin
     UserResponse := MessageDlg(
        'Внимание! Время выхода (' + TimeToStr(ExitTime) + ') раньше времени входа (' +
        TimeToStr(EntryTime) + ').' + sLineBreak +
        'Это может означать, что тренировка перешла за полночь.' + sLineBreak +
        sLineBreak +
        'Как поступить?' + sLineBreak +
        'Да - добавить 24 часа (тренировка после полуночи)' + sLineBreak +
        'Нет - отменить операцию',
        mtConfirmation, [mbYes, mbNo], 0);
       if UserResponse = mrYes then
      begin
        // Добавляем 24 часа к времени выхода (1 день = 1.0 в Delphi)
        ExitTime := ExitTime + 1.0;
      end
      else
        Exit;  // Пользователь отменил операцию
    end;

    // Вычисляем длительность
    DurationMinutes := Round((ExitTime - EntryTime) * 24 * 60);

    if DurationMinutes > 720 then
    begin
       UserResponse := MessageDlg(
        'Длительность тренировки составляет ' + IntToStr(DurationMinutes) +
        ' минут (' + FormatFloat('0.0', DurationMinutes / 60) + ' часов).' + sLineBreak +
        'Это необычно много для одной тренировки.' + sLineBreak +
        sLineBreak +
        'Продолжить?',
        mtWarning, [mbYes, mbNo], 0);
        if UserResponse <> mrYes then
          Exit;
    end;

    // Обновляем запись
    Query.SQL.Text :=
      'UPDATE visits SET exit_time = :exit_time, ' +
      'duration_minutes = :duration ' +
      'WHERE id = :id';

    Query.ParamByName('exit_time').AsString := FormatDateTime('hh:nn:ss', ExitTime);
    Query.ParamByName('duration').AsInteger := DurationMinutes;
    Query.ParamByName('id').AsInteger := ActiveVisitID;  // Используем ActiveVisitID, не VisitID!
    Query.ExecSQL;

    // Показываем результат
    ShowMessage(
      '✅ Посещение завершено!' + sLineBreak +
      'ID: ' + IntToStr(ActiveVisitID) + sLineBreak +
      'Вход: ' + TimeToStr(EntryTime) + sLineBreak +
      'Выход: ' + TimeToStr(ExitTime) + sLineBreak +
      'Длительность: ' + IntToStr(DurationMinutes) + ' минут'
    );

    // Закрываем форму
    ModalResult := mrOk;

  finally
    Query.Free;
  end;
end;

procedure TfrmVisitEdit1.btnCancelClick(Sender: TObject);
begin
  // Если мы в режиме выхода, спросим подтверждение
  if FMode = modeExit then
  begin
    if MessageDlg('Посещение еще не завершено. Все равно закрыть?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ModalResult := mrCancel;
    end;
  end
  else
  begin
    // Просто закрываем
    ModalResult := mrCancel;
  end;
end;


procedure TfrmVisitEdit1.memoNotesChange(Sender: TObject);
begin
   if memoNotes.MaxLength > 500 then
   begin
      ShowMessage('Вы превысили лимит символов!');
   end;

end;


end.

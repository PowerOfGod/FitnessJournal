unit ReportsModule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.Menus, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  DBModule, AppConsts, DateUtils, // Убрал frmVisitEdit, frmSubscriptionEdit - они не нужны
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, System.UITypes;

procedure ShowClientsReport;
procedure ShowSubscriptionsReport;
procedure ShowVisitsReport;
procedure ShowTrainerReport;
procedure ExportToExcel;

implementation

// Процедура показа отчета по клиентам
procedure ShowClientsReport;
var
  Form: TForm;
  Memo: TMemo;
  Query: TFDQuery;
begin
  // Создаем форму для отчета
  Form := TForm.Create(Application);
  try
    Form.Caption := 'Отчет - Клиенты';
    Form.Width := 900;
    Form.Height := 600;
    Form.Position := poScreenCenter;

    // Добавляем текстовое поле на всю форму
    Memo := TMemo.Create(Form);
    Memo.Parent := Form;
    Memo.Align := alClient;
    Memo.ScrollBars := ssBoth;
    Memo.Font.Name := 'Courier New';
    Memo.Font.Size := 10;
    Memo.ReadOnly := True;

    // Создаем запрос к БД
    Query := TFDQuery.Create(Form);
    Query.Connection := DB.GetConnection;

    // Заголовок отчета
    Memo.Lines.Add(StringOfChar('=', 100));
    Memo.Lines.Add('ФИТНЕС-ЦЕНТР - СПИСОК КЛИЕНТОВ');
    Memo.Lines.Add(StringOfChar('=', 100));
    Memo.Lines.Add('');

    // SQL запрос
    Query.SQL.Text :=
      'SELECT id, full_name, phone, email, membership_type, ' +
      'CASE WHEN is_active = 1 THEN "Активен" ELSE "Неактивен" END as status ' +
      'FROM clients ORDER BY full_name';
    Query.Open;

    // Заголовки колонок
    Memo.Lines.Add(Format('%-5s %-30s %-15s %-25s %-15s %-10s',
      ['ID', 'ФИО', 'Телефон', 'Email', 'Абонемент', 'Статус']));
    Memo.Lines.Add(StringOfChar('-', 100));

    // Данные
    while not Query.Eof do
    begin
      Memo.Lines.Add(Format('%-5d %-30s %-15s %-25s %-15s %-10s',
        [Query.FieldByName('id').AsInteger,
         Copy(Query.FieldByName('full_name').AsString, 1, 30),
         Query.FieldByName('phone').AsString,
         Copy(Query.FieldByName('email').AsString, 1, 25),
         Query.FieldByName('membership_type').AsString,
         Query.FieldByName('status').AsString]));
      Query.Next;
    end;

    // Итог
    Memo.Lines.Add(StringOfChar('-', 100));
    Memo.Lines.Add('Всего клиентов: ' + IntToStr(Query.RecordCount));
    Memo.Lines.Add('');
    Memo.Lines.Add('Отчет сформирован: ' + DateTimeToStr(Now));

    // Показываем форму
    Form.ShowModal;

  finally
    Form.Free;
  end;
end;

// Отчет по абонементам
procedure ShowSubscriptionsReport;
var
  Form: TForm;
  Memo: TMemo;
  Query: TFDQuery;
begin
  Form := TForm.Create(Application);
  try
    Form.Caption := 'Отчет - Абонементы';
    Form.Width := 1000;
    Form.Height := 600;
    Form.Position := poScreenCenter;

    Memo := TMemo.Create(Form);
    Memo.Parent := Form;
    Memo.Align := alClient;
    Memo.Font.Name := 'Courier New';
    Memo.Font.Size := 10;
    Memo.ScrollBars := ssBoth;
    Memo.ReadOnly := True;

    Query := TFDQuery.Create(Form);
    Query.Connection := DB.GetConnection;

    Memo.Lines.Add(StringOfChar('=', 110));
    Memo.Lines.Add('ФИТНЕС-ЦЕНТР - АБОНЕМЕНТЫ');
    Memo.Lines.Add(StringOfChar('=', 110));
    Memo.Lines.Add('');

    Query.SQL.Text :=
      'SELECT s.id, c.full_name as client, s.subscription_type, ' +
      's.start_date, s.end_date, s.price, ' +
      'CASE WHEN s.is_active = 1 AND date(s.end_date) >= date("now") THEN "Активен" ' +
      '     ELSE "Неактивен" END as status ' +
      'FROM subscriptions s ' +
      'LEFT JOIN clients c ON c.id = s.client_id ' +
      'ORDER BY s.end_date DESC';
    Query.Open;

    Memo.Lines.Add(Format('%-5s %-30s %-15s %-12s %-12s %-10s %-10s',
      ['ID', 'Клиент', 'Тип', 'Начало', 'Окончание', 'Цена', 'Статус']));
    Memo.Lines.Add(StringOfChar('-', 110));

    while not Query.Eof do
    begin
      Memo.Lines.Add(Format('%-5d %-30s %-15s %-12s %-12s %-10.0f %-10s',
        [Query.FieldByName('id').AsInteger,
         Copy(Query.FieldByName('client').AsString, 1, 30),
         Query.FieldByName('subscription_type').AsString,
         DateToStr(Query.FieldByName('start_date').AsDateTime),
         DateToStr(Query.FieldByName('end_date').AsDateTime),
         Query.FieldByName('price').AsFloat,
         Query.FieldByName('status').AsString]));
      Query.Next;
    end;

    Memo.Lines.Add(StringOfChar('-', 110));
    Memo.Lines.Add('Всего абонементов: ' + IntToStr(Query.RecordCount));

    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

// Отчет по посещениям
procedure ShowVisitsReport;
var
  Form: TForm;
  Memo: TMemo;
  Query: TFDQuery;
  DateFrom, DateTo: TDate;
  TotalVisits, TotalMinutes: Integer;
  DateStr: string;
begin
  // Спрашиваем период
  DateFrom := Date - 30; // последние 30 дней
  DateTo := Date;

  DateStr := DateToStr(DateFrom);
  if not InputQuery('Период отчета', 'Введите дату начала (ДД.ММ.ГГГГ):', DateStr) then
    Exit;
  try
    DateFrom := StrToDate(DateStr);
  except
    ShowMessage('Неверный формат даты!');
    Exit;
  end;

  DateStr := DateToStr(DateTo);
  if not InputQuery('Период отчета', 'Введите дату окончания (ДД.ММ.ГГГГ):', DateStr) then
    Exit;
  try
    DateTo := StrToDate(DateStr);
  except
    ShowMessage('Неверный формат даты!');
    Exit;
  end;

  Form := TForm.Create(Application);
  try
    Form.Caption := 'Отчет - Посещения';
    Form.Width := 1000;
    Form.Height := 600;
    Form.Position := poScreenCenter;

    Memo := TMemo.Create(Form);
    Memo.Parent := Form;
    Memo.Align := alClient;
    Memo.Font.Name := 'Courier New';
    Memo.Font.Size := 10;
    Memo.ScrollBars := ssBoth;
    Memo.ReadOnly := True;

    Query := TFDQuery.Create(Form);
    Query.Connection := DB.GetConnection;

    Memo.Lines.Add(StringOfChar('=', 110));
    Memo.Lines.Add('ФИТНЕС-ЦЕНТР - ЖУРНАЛ ПОСЕЩЕНИЙ');
    Memo.Lines.Add(StringOfChar('=', 110));
    Memo.Lines.Add('Период: ' + DateToStr(DateFrom) + ' - ' + DateToStr(DateTo));
    Memo.Lines.Add('');

    Query.SQL.Text :=
      'SELECT v.visit_date, c.full_name as client, ' +
      'v.entry_time, v.exit_time, v.duration_minutes, v.trainer_name ' +
      'FROM visits v ' +
      'LEFT JOIN clients c ON c.id = v.client_id ' +
      'WHERE v.visit_date BETWEEN :date_from AND :date_to ' +
      'ORDER BY v.visit_date DESC, v.entry_time DESC';
    Query.ParamByName('date_from').AsDate := DateFrom;
    Query.ParamByName('date_to').AsDate := DateTo;
    Query.Open;

    Memo.Lines.Add(Format('%-12s %-30s %-10s %-10s %-10s %-15s',
      ['Дата', 'Клиент', 'Вход', 'Выход', 'Минут', 'Тренер']));
    Memo.Lines.Add(StringOfChar('-', 110));

    TotalVisits := 0;
    TotalMinutes := 0;

    while not Query.Eof do
    begin
      Memo.Lines.Add(Format('%-12s %-30s %-10s %-10s %-10d %-15s',
        [DateToStr(Query.FieldByName('visit_date').AsDateTime),
         Copy(Query.FieldByName('client').AsString, 1, 30),
         Query.FieldByName('entry_time').AsString,
         Query.FieldByName('exit_time').AsString,
         Query.FieldByName('duration_minutes').AsInteger,
         Query.FieldByName('trainer_name').AsString]));

      TotalVisits := TotalVisits + 1;
      TotalMinutes := TotalMinutes + Query.FieldByName('duration_minutes').AsInteger;
      Query.Next;
    end;

    Memo.Lines.Add(StringOfChar('-', 110));
    Memo.Lines.Add(Format('ИТОГО: %d посещений, %d минут (%.1f часов)',
      [TotalVisits, TotalMinutes, TotalMinutes / 60]));

    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

// Отчет по тренерам
procedure ShowTrainerReport;
var
  Form: TForm;
  Memo: TMemo;
  Query: TFDQuery;
  DateFrom, DateTo: TDate;
  DateStr: string;
begin
  DateFrom := Date - 30;
  DateTo := Date;

  DateStr := DateToStr(DateFrom);
  if not InputQuery('Период отчета', 'Введите дату начала (ДД.ММ.ГГГГ):', DateStr) then
    Exit;
  try
    DateFrom := StrToDate(DateStr);
  except
    ShowMessage('Неверный формат даты!');
    Exit;
  end;

  DateStr := DateToStr(DateTo);
  if not InputQuery('Период отчета', 'Введите дату окончания (ДД.ММ.ГГГГ):', DateStr) then
    Exit;
  try
    DateTo := StrToDate(DateStr);
  except
    ShowMessage('Неверный формат даты!');
    Exit;
  end;

  Form := TForm.Create(Application);
  try
    Form.Caption := 'Отчет - Статистика по тренерам';
    Form.Width := 800;
    Form.Height := 500;
    Form.Position := poScreenCenter;

    Memo := TMemo.Create(Form);
    Memo.Parent := Form;
    Memo.Align := alClient;
    Memo.Font.Name := 'Courier New';
    Memo.Font.Size := 10;
    Memo.ScrollBars := ssBoth;
    Memo.ReadOnly := True;

    Query := TFDQuery.Create(Form);
    Query.Connection := DB.GetConnection;

    Memo.Lines.Add(StringOfChar('=', 80));
    Memo.Lines.Add('ФИТНЕС-ЦЕНТР - СТАТИСТИКА ПО ТРЕНЕРАМ');
    Memo.Lines.Add(StringOfChar('=', 80));
    Memo.Lines.Add('Период: ' + DateToStr(DateFrom) + ' - ' + DateToStr(DateTo));
    Memo.Lines.Add('');

    Query.SQL.Text :=
      'SELECT trainer_name, COUNT(*) as visits, ' +
      'SUM(duration_minutes) as total_minutes, ' +
      'AVG(duration_minutes) as avg_minutes ' +
      'FROM visits ' +
      'WHERE visit_date BETWEEN :date_from AND :date_to ' +
      'AND trainer_name IS NOT NULL ' +
      'GROUP BY trainer_name ' +
      'ORDER BY visits DESC';
    Query.ParamByName('date_from').AsDate := DateFrom;
    Query.ParamByName('date_to').AsDate := DateTo;
    Query.Open;

    Memo.Lines.Add(Format('%-20s %-12s %-15s %-12s',
      ['Тренер', 'Посещений', 'Всего минут', 'Среднее']));
    Memo.Lines.Add(StringOfChar('-', 60));

    while not Query.Eof do
    begin
      Memo.Lines.Add(Format('%-20s %-12d %-15d %-12.0f',
        [Query.FieldByName('trainer_name').AsString,
         Query.FieldByName('visits').AsInteger,
         Query.FieldByName('total_minutes').AsInteger,
         Query.FieldByName('avg_minutes').AsFloat]));
      Query.Next;
    end;

    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

// Простой экспорт в Excel (текстовый файл с разделителями)
procedure ExportToExcel;
var
  SaveDialog: TSaveDialog;
  Lines: TStringList;
  Query: TFDQuery;
  i: Integer;
  Line: string;
begin
  SaveDialog := TSaveDialog.Create(Application);
  try
    SaveDialog.Filter := 'CSV файлы|*.csv|Текстовые файлы|*.txt';
    SaveDialog.DefaultExt := 'csv';
    SaveDialog.FileName := 'Посещения_' + FormatDateTime('yyyy-mm-dd', Now);

    if not SaveDialog.Execute then
      Exit;

    Lines := TStringList.Create;
    Query := TFDQuery.Create(Application);
    try
      Query.Connection := DB.GetConnection;

      // Берем данные за последние 30 дней
      Query.SQL.Text :=
        'SELECT v.visit_date as "Дата", ' +
        'c.full_name as "Клиент", ' +
        'v.entry_time as "Вход", ' +
        'v.exit_time as "Выход", ' +
        'v.duration_minutes as "Минут", ' +
        'v.trainer_name as "Тренер" ' +
        'FROM visits v ' +
        'LEFT JOIN clients c ON c.id = v.client_id ' +
        'WHERE v.visit_date >= date("now", "-30 days") ' +
        'ORDER BY v.visit_date DESC';
      Query.Open;

      // Заголовки
      Line := '';
      for i := 0 to Query.FieldCount - 1 do
      begin
        if i > 0 then Line := Line + ';';
        Line := Line + Query.Fields[i].DisplayLabel;
      end;
      Lines.Add(Line);

      // Данные
      while not Query.Eof do
      begin
        Line := '';
        for i := 0 to Query.FieldCount - 1 do
        begin
          if i > 0 then Line := Line + ';';

          if Query.Fields[i].IsNull then
            Line := Line + ''
          else if Query.Fields[i].DataType in [ftDate, ftDateTime] then
            Line := Line + DateToStr(Query.Fields[i].AsDateTime)
          else
            Line := Line + Query.Fields[i].AsString;
        end;
        Lines.Add(Line);
        Query.Next;
      end;

      Lines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);
      ShowMessage('Данные сохранены в файл:' + #13#10 + SaveDialog.FileName);

    finally
      Lines.Free;
      Query.Free;
    end;

  finally
    SaveDialog.Free;
  end;
end;

end.

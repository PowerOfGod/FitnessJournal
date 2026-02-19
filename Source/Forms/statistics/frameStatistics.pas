unit frameStatistics;

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

type
  TFrame1 = class(TFrame)
    // Панели
    PanelTop: TPanel;
    PageControl1: TPageControl;
    tabGeneral: TTabSheet;
    tabTrainer: TTabSheet;
    tabHourly: TTabSheet;

    // Метки
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;

    // Элементы управления
    cmbPeriod: TComboBox;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    btnRefresh: TButton;

    // Компоненты для данных
    MemoStats: TMemo;
    gridDaily: TDBGrid;
    gridTrainer: TDBGrid;
    StatusBar1: TStatusBar;

    // DataSource
    dsDaily: TDataSource;
    dsTrainer: TDataSource;
    dsHourly: TDataSource;

    // Запросы
    qryDaily: TFDQuery;
    qryTrainer: TFDQuery;
    qryHourly: TFDQuery;

    // Таймер
    Timer1: TTimer;
    gridHourly: TDBGrid;

    // Процедуры-обработчики
    procedure cmbPeriodChange(Sender: TObject);
    procedure dtpDateFromChange(Sender: TObject);
    procedure dtpDateToChange(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    FDateFrom: TDate;
    FDateTo: TDate;
    FIsLoading: Boolean;

    procedure UpdateDateRange;
    procedure LoadDailyStats;
    procedure LoadTrainerStats;
    procedure LoadHourlyStats;
    procedure UpdateMemoStats;

  public
    procedure Initialize;
    procedure RefreshData;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

procedure TFrame1.Initialize;
begin
  // Заполняем список периодов
  cmbPeriod.Clear;
  cmbPeriod.Items.Add('Сегодня');
  cmbPeriod.Items.Add('Текущая неделя');
  cmbPeriod.Items.Add('Текущий месяц');
  cmbPeriod.Items.Add('Текущий квартал');
  cmbPeriod.Items.Add('Текущий год');
  cmbPeriod.Items.Add('Произвольный период');
  cmbPeriod.ItemIndex := 2; // Месяц по умолчанию

  // Устанавливаем начальные даты
  dtpDateFrom.Date := StartOfTheMonth(Date);
  dtpDateTo.Date := Date;

  dsDaily.DataSet := qryDaily;        // DataSource берет данные из запроса
  gridDaily.DataSource := dsDaily;     // Grid берет данные из DataSource

  dsTrainer.DataSet := qryTrainer;
  gridTrainer.DataSource := dsTrainer;

  dsHourly.DataSet := qryHourly;
  gridHourly.DataSource := dsHourly;

  // Настраиваем статусную строку
  StatusBar1.Panels.Clear;
  StatusBar1.Panels.Add;
  StatusBar1.Panels.Add;
  StatusBar1.Panels[0].Text := 'Готов';
  StatusBar1.Panels[0].Width := 200;
  StatusBar1.Panels[1].Text := 'Всего: 0';

  // Подключаем запросы к БД
  if DB.IsConnected then
  begin
    qryDaily.Connection := DB.GetConnection;
    qryTrainer.Connection := DB.GetConnection;
    qryHourly.Connection := DB.GetConnection;
  end;

  // Настраиваем таймер (обновление каждые 5 минут)
  Timer1.Interval := 300000; // 5 минут
  Timer1.Enabled := True;

  // Загружаем данные
  RefreshData;
end;

procedure TFrame1.RefreshData;
begin
  if not DB.IsConnected then
  begin
    StatusBar1.Panels[0].Text := 'Нет подключения к БД';
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    UpdateDateRange;
    LoadDailyStats;
    LoadTrainerStats;
    LoadHourlyStats;
    UpdateMemoStats;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrame1.Timer1Timer(Sender: TObject);
begin
  RefreshData;
end;

procedure TFrame1.UpdateDateRange;
var
  Today: TDate;
  DayOfWeekNum: Integer;
begin
  FIsLoading := True;
  Today := Date;

  try
    case cmbPeriod.ItemIndex of
      0: // Сегодня
        begin
          FDateFrom := Today;
          FDateTo := Today;
        end;

      1: // Текущая неделя
        begin
          DayOfWeekNum := DayOfWeek(Today);
          if DayOfWeekNum = 1 then
            FDateFrom := Today - 6
          else
            FDateFrom := Today - (DayOfWeekNum - 2);
          FDateTo := Today;
        end;

      2: // Текущий месяц
        begin
          FDateFrom := StartOfTheMonth(Today);
          FDateTo := Today;
        end;

      3: // Текущий квартал
        begin
          case MonthOf(Today) of
            1,2,3:  FDateFrom := EncodeDate(YearOf(Today), 1, 1);
            4,5,6:  FDateFrom := EncodeDate(YearOf(Today), 4, 1);
            7,8,9:  FDateFrom := EncodeDate(YearOf(Today), 7, 1);
            10,11,12: FDateFrom := EncodeDate(YearOf(Today), 10, 1);
          end;
          FDateTo := Today;
        end;

      4: // Текущий год
        begin
          FDateFrom := EncodeDate(YearOf(Today), 1, 1);
          FDateTo := Today;
        end;

      5: // Произвольный период
        begin
          FDateFrom := dtpDateFrom.Date;
          FDateTo := dtpDateTo.Date;

          if FDateFrom > FDateTo then
          begin
            ShowMessage('Дата начала не может быть позже даты окончания!');
            FDateFrom := dtpDateTo.Date;
            FDateTo := dtpDateFrom.Date;
          end;
        end;
    end;

    dtpDateFrom.Date := FDateFrom;
    dtpDateTo.Date := FDateTo;

    dtpDateFrom.Enabled := (cmbPeriod.ItemIndex = 5);
    dtpDateTo.Enabled := (cmbPeriod.ItemIndex = 5);

    StatusBar1.Panels[0].Text := Format('Период: %s - %s',
      [DateToStr(FDateFrom), DateToStr(FDateTo)]);

  finally
    FIsLoading := False;
  end;
end;

procedure TFrame1.LoadDailyStats;
begin
  qryDaily.Close;

   ShowMessage('Загружаем статистику за период: ' +
              DateToStr(FDateFrom) + ' - ' + DateToStr(FDateTo));
  qryDaily.SQL.Text :=
    'SELECT ' +
    '  visit_date, ' +
    '  COUNT(*) as visit_count, ' +
    '  COUNT(DISTINCT client_id) as unique_clients, ' +
    '  SUM(duration_minutes) as total_minutes ' +
    'FROM visits ' +
    'WHERE visit_date BETWEEN :date_from AND :date_to ' +
    'GROUP BY visit_date ' +
    'ORDER BY visit_date DESC';

  qryDaily.ParamByName('date_from').AsDate := FDateFrom;
  qryDaily.ParamByName('date_to').AsDate := FDateTo;
  qryDaily.Open;
   ShowMessage('Найдено записей: ' + IntToStr(qryDaily.RecordCount));
  // Настройка заголовков
  if qryDaily.Active then
  begin
    qryDaily.FieldByName('visit_date').DisplayLabel := 'Дата';
    qryDaily.FieldByName('visit_count').DisplayLabel := 'Посещений';
    qryDaily.FieldByName('unique_clients').DisplayLabel := 'Уникальных';
    qryDaily.FieldByName('total_minutes').DisplayLabel := 'Минут';
  end;
end;

procedure TFrame1.LoadTrainerStats;
begin
  qryTrainer.Close;
  qryTrainer.SQL.Text :=
    'SELECT ' +
    '  CAST(trainer_name AS VARCHAR(100)) AS trainer_name, ' +
    '  COUNT(*) as visit_count, ' +
    '  SUM(duration_minutes) as total_minutes ' +
    'FROM visits ' +
    'WHERE visit_date BETWEEN :date_from AND :date_to ' +
    '  AND trainer_name IS NOT NULL ' +
    'GROUP BY trainer_name ' +
    'ORDER BY visit_count DESC';

  qryTrainer.ParamByName('date_from').AsDate := FDateFrom;
  qryTrainer.ParamByName('date_to').AsDate := FDateTo;
  qryTrainer.Open;

  // Настройка заголовков
  if qryTrainer.Active then
  begin
    qryTrainer.FieldByName('trainer_name').DisplayLabel := 'Тренер';
    qryTrainer.FieldByName('visit_count').DisplayLabel := 'Посещений';
    qryTrainer.FieldByName('total_minutes').DisplayLabel := 'Минут';
  end;
end;

procedure TFrame1.LoadHourlyStats;
begin
  qryHourly.Close;
  qryHourly.SQL.Text :=
    'SELECT ' +
    '  CAST(strftime(''%H'', entry_time) AS INTEGER) as hour, ' +
    '  COUNT(*) as visit_count ' +
    'FROM visits ' +
    'WHERE visit_date BETWEEN :date_from AND :date_to ' +
    '  AND entry_time IS NOT NULL ' +
    'GROUP BY hour ' +
    'ORDER BY hour';

  qryHourly.ParamByName('date_from').AsDate := FDateFrom;
  qryHourly.ParamByName('date_to').AsDate := FDateTo;
  qryHourly.Open;

  if qryHourly.Active and not qryHourly.IsEmpty then
  begin
    qryHourly.FieldByName('hour').DisplayLabel := 'Час';
    qryHourly.FieldByName('hour').DisplayWidth := 10;
    qryHourly.FieldByName('visit_count').DisplayLabel := 'Посещений';
    qryHourly.FieldByName('visit_count').DisplayWidth := 15;
  end;
end;

procedure TFrame1.UpdateMemoStats;
var
  TotalVisits, TotalMinutes, TotalUnique: Integer;
begin
  TotalVisits := 0;
  TotalMinutes := 0;
  TotalUnique := 0;

  qryDaily.First;
  while not qryDaily.Eof do
  begin
    TotalVisits := TotalVisits + qryDaily.FieldByName('visit_count').AsInteger;
    TotalMinutes := TotalMinutes + qryDaily.FieldByName('total_minutes').AsInteger;
    TotalUnique := TotalUnique + qryDaily.FieldByName('unique_clients').AsInteger;
    qryDaily.Next;
  end;

  MemoStats.Clear;
  MemoStats.Lines.Add(StringOfChar('=', 50));
  MemoStats.Lines.Add('ИТОГОВАЯ СТАТИСТИКА');
  MemoStats.Lines.Add(StringOfChar('=', 50));
  MemoStats.Lines.Add('');
  MemoStats.Lines.Add(Format('Период: %s - %s',
    [DateToStr(FDateFrom), DateToStr(FDateTo)]));
  MemoStats.Lines.Add(Format('Всего посещений: %d', [TotalVisits]));
  MemoStats.Lines.Add(Format('Уникальных клиентов: %d', [TotalUnique]));
  MemoStats.Lines.Add(Format('Общее время: %d мин (%.1f ч)',
    [TotalMinutes, TotalMinutes / 60]));

  if TotalVisits > 0 then
    MemoStats.Lines.Add(Format('Средняя длительность: %.0f мин',
      [TotalMinutes / TotalVisits]));

  StatusBar1.Panels[1].Text := Format('Всего: %d', [TotalVisits]);
end;

procedure TFrame1.cmbPeriodChange(Sender: TObject);
begin
  if not FIsLoading then
    RefreshData;
end;

procedure TFrame1.dtpDateFromChange(Sender: TObject);
begin
  if (cmbPeriod.ItemIndex = 5) and not FIsLoading then
    RefreshData;
end;

procedure TFrame1.dtpDateToChange(Sender: TObject);
begin
  if (cmbPeriod.ItemIndex = 5) and not FIsLoading then
    RefreshData;
end;

procedure TFrame1.btnRefreshClick(Sender: TObject);
begin
  RefreshData;
end;

end. // <-- Это должен быть ОДИН end. в самом конце

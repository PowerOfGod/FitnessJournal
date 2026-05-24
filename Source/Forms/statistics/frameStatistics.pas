unit frameStatistics;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.Menus, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  DBModule, AppConsts, DateUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, System.UITypes;

type
  TFrame1 = class(TFrame)
    PanelTop: TPanel;
    PageControl1: TPageControl;
    tabGeneral: TTabSheet;
    tabTrainer: TTabSheet;
    tabHourly: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cmbPeriod: TComboBox;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    btnRefresh: TButton;
    MemoStats: TMemo;
    gridDaily: TDBGrid;
    gridTrainer: TDBGrid;
    StatusBar1: TStatusBar;
    dsDaily: TDataSource;
    dsTrainer: TDataSource;
    dsHourly: TDataSource;
    qryDaily: TFDQuery;
    qryTrainer: TFDQuery;
    qryHourly: TFDQuery;
    Timer1: TTimer;
    gridHourly: TDBGrid;
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
    procedure AutoFitGridColumns(Grid: TDBGrid);
    procedure FormResize(Sender: TObject);
  public
    procedure Initialize;
    procedure RefreshData;
    procedure UpdateLayout;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

procedure TFrame1.AutoFitGridColumns(Grid: TDBGrid);
var
  i: Integer;
  TotalWidth: Integer;
  VisibleCols: Integer;
  ColWidth: Integer;
begin
  if not Assigned(Grid) then Exit;
  if not Assigned(Grid.DataSource) then Exit;
  if not Assigned(Grid.DataSource.DataSet) then Exit;
  if not Grid.DataSource.DataSet.Active then Exit;
  if Grid.Columns.Count = 0 then Exit;

  // Подсчитываем только видимые колонки
  VisibleCols := 0;
  for i := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns[i].Visible then
      Inc(VisibleCols);

  if VisibleCols = 0 then Exit;

  // Получаем доступную ширину (минус полоса прокрутки)
  TotalWidth := Grid.ClientWidth - 25;
  if TotalWidth < 100 then Exit;

  // Равномерно распределяем ширину
  ColWidth := TotalWidth div VisibleCols;

  // Ограничиваем ширину
  if ColWidth < 80 then ColWidth := 80;
  if ColWidth > 300 then ColWidth := 300;

  // Применяем ширину ко всем видимым колонкам
  for i := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns[i].Visible then
      Grid.Columns[i].Width := ColWidth;
end;

procedure TFrame1.FormResize(Sender: TObject);
begin
  // При изменении размера подстраиваем все таблицы
  AutoFitGridColumns(gridDaily);
  AutoFitGridColumns(gridTrainer);
  AutoFitGridColumns(gridHourly);
end;

procedure TFrame1.UpdateLayout;
begin
  AutoFitGridColumns(gridDaily);
  AutoFitGridColumns(gridTrainer);
  AutoFitGridColumns(gridHourly);
end;

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

  tabGeneral.Caption := 'Общая статистика';
  tabTrainer.Caption := 'По тренерам';
  tabHourly.Caption := 'По часам';

  // Устанавливаем начальные даты
  dtpDateFrom.Date := StartOfTheMonth(Date);
  dtpDateTo.Date := Date;

  // Настраиваем DataSource
  dsDaily.DataSet := qryDaily;
  gridDaily.DataSource := dsDaily;
  dsTrainer.DataSet := qryTrainer;
  gridTrainer.DataSource := dsTrainer;
  dsHourly.DataSet := qryHourly;
  gridHourly.DataSource := dsHourly;

   // Настройка шрифтов как на других вкладках
  // Memo для статистики
  MemoStats.Font.Name := 'Segoe UI';
  MemoStats.Font.Size := 11;
  MemoStats.Color := 16777197;  // Светло-желтый фон

  // Таблица Общая статистика
  gridDaily.Font.Name := 'Segoe UI';
  gridDaily.Font.Size := 11;
  gridDaily.TitleFont.Name := 'Segoe UI';
  gridDaily.TitleFont.Size := 10;
  gridDaily.TitleFont.Style := [fsBold];
  gridDaily.TitleFont.Color := clNavy;

  // Таблица По тренерам
  gridTrainer.Font.Name := 'Segoe UI';
  gridTrainer.Font.Size := 11;
  gridTrainer.TitleFont.Name := 'Segoe UI';
  gridTrainer.TitleFont.Size := 10;
  gridTrainer.TitleFont.Style := [fsBold];
  gridTrainer.TitleFont.Color := clNavy;

  // Таблица По часам
  gridHourly.Font.Name := 'Segoe UI';
  gridHourly.Font.Size := 11;
  gridHourly.TitleFont.Name := 'Segoe UI';
  gridHourly.TitleFont.Size := 10;
  gridHourly.TitleFont.Style := [fsBold];
  gridHourly.TitleFont.Color := clNavy;



  // Настройка StatusBar
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

  // Подключаем обработчик изменения размера
  Self.OnResize := FormResize;

  // Настраиваем таймер (обновление каждые 5 минут)
  Timer1.Interval := 300000;
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
  StatusBar1.Panels[0].Text := 'Загрузка данных...';
  try
    UpdateDateRange;
   LoadDailyStats;
    LoadTrainerStats;
    LoadHourlyStats;
    UpdateMemoStats;

    StatusBar1.Panels[0].Text := Format('Период: %s - %s',
      [DateToStr(FDateFrom), DateToStr(FDateTo)]);

    // Подстраиваем колонки после загрузки
    UpdateLayout;
  except
    on E: Exception do
    begin
      StatusBar1.Panels[0].Text := 'Ошибка загрузки';
      ShowMessage('Ошибка при загрузке статистики: ' + E.Message);
    end;
  end;
  Screen.Cursor := crDefault;
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

  finally
    FIsLoading := False;
  end;
end;

procedure TFrame1.LoadDailyStats;
begin
  qryDaily.Close;

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

  // Настройка заголовков и выравнивания
  if qryDaily.Active then
  begin
    qryDaily.FieldByName('visit_date').DisplayLabel := 'Дата';
    qryDaily.FieldByName('visit_count').DisplayLabel := 'Посещений';
    qryDaily.FieldByName('unique_clients').DisplayLabel := 'Уникальных';
    qryDaily.FieldByName('total_minutes').DisplayLabel := 'Минут';

    // Выравнивание по левому краю
    qryDaily.FieldByName('visit_count').Alignment := taLeftJustify;
    qryDaily.FieldByName('unique_clients').Alignment := taLeftJustify;
    qryDaily.FieldByName('total_minutes').Alignment := taLeftJustify;
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
    '  AND trainer_name != "" ' +
    'GROUP BY trainer_name ' +
    'ORDER BY visit_count DESC';

  qryTrainer.ParamByName('date_from').AsDate := FDateFrom;
  qryTrainer.ParamByName('date_to').AsDate := FDateTo;
  qryTrainer.Open;

  if qryTrainer.Active then
  begin
    qryTrainer.FieldByName('trainer_name').DisplayLabel := 'Тренер';
    qryTrainer.FieldByName('visit_count').DisplayLabel := 'Посещений';
    qryTrainer.FieldByName('total_minutes').DisplayLabel := 'Минут';

    qryTrainer.FieldByName('visit_count').Alignment := taLeftJustify;
    qryTrainer.FieldByName('total_minutes').Alignment := taLeftJustify;
  end;
end;

procedure TFrame1.LoadHourlyStats;
begin
  qryHourly.Close;
  qryHourly.SQL.Text :=
    'SELECT ' +
    '  CASE WHEN entry_time IS NOT NULL AND entry_time != "" ' +
    '    THEN CAST(strftime(''%H'', entry_time) AS INTEGER) ' +
    '    ELSE 0 END as hour, ' +
    '  COUNT(*) as visit_count ' +
    'FROM visits ' +
    'WHERE visit_date BETWEEN :date_from AND :date_to ' +
    'GROUP BY hour ' +
    'ORDER BY hour';

  qryHourly.ParamByName('date_from').AsDate := FDateFrom;
  qryHourly.ParamByName('date_to').AsDate := FDateTo;

  try
    qryHourly.Open;
  except
    on E: Exception do
    begin
      ShowMessage('Ошибка в LoadHourlyStats: ' + E.Message);
      Exit;
    end;
  end;

  if qryHourly.Active and not qryHourly.IsEmpty then
  begin
    qryHourly.FieldByName('hour').DisplayLabel := 'Час';
    qryHourly.FieldByName('visit_count').DisplayLabel := 'Посещений';
    qryHourly.FieldByName('hour').Alignment := taLeftJustify;
    qryHourly.FieldByName('visit_count').Alignment := taLeftJustify;
  end;
end;

procedure TFrame1.UpdateMemoStats;
var
  TotalVisits, TotalMinutes, TotalUnique: Integer;
begin
  TotalVisits := 0;
  TotalMinutes := 0;
  TotalUnique := 0;

  // Проверка, что запрос активен и не пуст
  if not qryDaily.Active then
  begin
    StatusBar1.Panels[1].Text := 'Всего: 0';
    Exit;
  end;

  if qryDaily.IsEmpty then
  begin
    MemoStats.Clear;
    MemoStats.Lines.Add(StringOfChar('=', 50));
    MemoStats.Lines.Add('ИТОГОВАЯ СТАТИСТИКА');
    MemoStats.Lines.Add(StringOfChar('=', 50));
    MemoStats.Lines.Add('');
    MemoStats.Lines.Add('Нет данных за выбранный период');
    StatusBar1.Panels[1].Text := 'Всего: 0';
    Exit;
  end;

  try
    qryDaily.First;
    while not qryDaily.Eof do
    begin
      // Безопасное чтение с проверкой на NULL
      if not qryDaily.FieldByName('visit_count').IsNull then
        TotalVisits := TotalVisits + qryDaily.FieldByName('visit_count').AsInteger;

      if not qryDaily.FieldByName('total_minutes').IsNull then
        TotalMinutes := TotalMinutes + qryDaily.FieldByName('total_minutes').AsInteger;

      if not qryDaily.FieldByName('unique_clients').IsNull then
        TotalUnique := TotalUnique + qryDaily.FieldByName('unique_clients').AsInteger;

      qryDaily.Next;
    end;
  except
    on E: Exception do
    begin
      MemoStats.Clear;
      MemoStats.Lines.Add('Ошибка при расчете статистики: ' + E.Message);
      StatusBar1.Panels[1].Text := 'Ошибка расчета';
      Exit;
    end;
  end;

  // Заполнение MemoStats
  MemoStats.Clear;
  MemoStats.Lines.Add(StringOfChar('=', 50));
  MemoStats.Lines.Add('ИТОГОВАЯ СТАТИСТИКА');
  MemoStats.Lines.Add(StringOfChar('=', 50));
  MemoStats.Lines.Add('');
  MemoStats.Lines.Add(Format('Период: %s - %s',
    [DateToStr(FDateFrom), DateToStr(FDateTo)]));
  MemoStats.Lines.Add(Format('Всего посещений: %d', [TotalVisits]));
  MemoStats.Lines.Add(Format('Уникальных клиентов: %d', [TotalUnique]));

  if TotalMinutes > 0 then
    MemoStats.Lines.Add(Format('Общее время: %d мин (%.1f ч)',
      [TotalMinutes, TotalMinutes / 60]))
  else
    MemoStats.Lines.Add('Общее время: 0 мин');

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

end.

unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Menus,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, frmClientEdit, frmVisitEdit, frmSubscriptionEdit, DBModule, AppConsts,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

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
    DBGrid1: TDBGrid;
    StatusBar1: TStatusBar;
    btnTestDB: TButton;
    DataSourceClients: TDataSource;
    FDQueryClients: TFDQuery;
    DBGridClients: TDBGrid;
    procedure btnNewClientClick(Sender: TObject);
    procedure btnNewVisitClick(Sender: TObject);
    procedure btnNewSubscriptionClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);    // ДОБАВИТЬ эту строку
    procedure FormDestroy(Sender: TObject);   // ДОБАВИТЬ эту строку
    procedure btnTestDBClick(Sender: TObject);
    procedure LoadClients;
    procedure btnRefreshClick(Sender: TObject);
    procedure LoadSubscriptions;
    procedure LoadVisits;
    procedure PageControl1Change(Sender: TObject);
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

procedure TformMain.LoadClients;
var
  Query: TFDQuery;
begin

    if not DB.IsConnected then
    begin
        ShowMessage('Сначала подключитесь к базе данных!');
    end;


    try
      Query := DB.GetClients;

      FDQueryClients.Close;

      FDQueryClients.Connection := DB.GetConnection;
      FDQueryClients  .SQL.Text := 'SELECT * FROM clients ORDER BY full_name';
      FDQueryClients.Open;

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
    0: LoadClients;        // Клиенты
    1: LoadSubscriptions;  // Абонементы
    3: LoadVisits;         // Посещения
  end;
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
  // Теперь DB уже создан в initialization
  FDBPath := 'D:\программирование\FitnessJournal\Data\Database\FitnessCenter.db';

  // Автоматическое подключение (опционально)
  // if DB.ConnectToDB(FDBPath) then
  //   StatusBar1.Panels[0].Text := 'БД подключена';
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  // Не нужно освобождать DB - это сделает finalization
end;

procedure TformMain.btnTestDBClick(Sender: TObject);
var
  TestPath: string;
  OpenDialog: TOpenDialog;
begin
  // Показываем текущий путь
  ShowMessage('Пытаюсь найти файл по пути:' + #13#10 + FDBPath);

  // Проверяем несколько возможных путей
  if FileExists(FDBPath) then
  begin
    ShowMessage('Файл найден! Пробую подключиться...');

    // ВОТ ЭТО ГЛАВНОЕ - ПОДКЛЮЧАЕМСЯ!
    if DB.ConnectToDB(FDBPath) then
    begin
      ShowMessage('✅ Подключение к базе данных успешно!');
      StatusBar1.Panels[0].Text := 'Подключено: ' + ExtractFileName(FDBPath);
      btnTestDB.Caption := 'Отключить БД';
    end
    else
    begin
      ShowMessage('❌ Не удалось подключиться к базе данных');
    end;
  end
  else
  begin
    ShowMessage('Файл не найден. Проверяем альтернативные пути...');

    // Проверяем в папке с программой
    TestPath := ExtractFilePath(Application.ExeName) + 'Data\Database\FitnessCenter.db';
    if FileExists(TestPath) then
    begin
      ShowMessage('Файл найден в папке программы: ' + TestPath);
      FDBPath := TestPath;

      // ПОДКЛЮЧАЕМСЯ!
      if DB.ConnectToDB(FDBPath) then
      begin
        ShowMessage('✅ Подключение к базе данных успешно!');
        StatusBar1.Panels[0].Text := 'Подключено: ' + ExtractFileName(FDBPath);
        btnTestDB.Caption := 'Отключить БД';
      end;
    end
    else
    begin
      TestPath := ExtractFilePath(Application.ExeName) + 'FitnessCenter.db';
      if FileExists(TestPath) then
      begin
        ShowMessage('Файл найден рядом с программой: ' + TestPath);
        FDBPath := TestPath;

        // ПОДКЛЮЧАЕМСЯ!
        if DB.ConnectToDB(FDBPath) then
        begin
          ShowMessage('✅ Подключение к базе данных успешно!');
          StatusBar1.Panels[0].Text := 'Подключено: ' + ExtractFileName(FDBPath);
          btnTestDB.Caption := 'Отключить БД';
        end;
      end
      else
      begin
        ShowMessage('Файл не найден ни по одному из путей.' + #13#10 +
                    'Проверьте:' + #13#10 +
                    '1. Существование файла' + #13#10 +
                    '2. Правильность имени файла' + #13#10 +
                    '3. Разрешения на доступ к файлу');

        // Открываем диалог для выбора файла
        OpenDialog := TOpenDialog.Create(nil);
        try
          OpenDialog.Title := 'Выберите файл базы данных FitnessCenter.db';
          OpenDialog.Filter := 'SQLite Database (*.db)|*.db|All Files (*.*)|*.*';
          if OpenDialog.Execute then
          begin
            FDBPath := OpenDialog.FileName;
            ShowMessage('Выбран новый путь: ' + FDBPath);

            // ПОДКЛЮЧАЕМСЯ СРАЗУ ПОСЛЕ ВЫБОРА!
            if DB.ConnectToDB(FDBPath) then
            begin
              ShowMessage('✅ Подключение к базе данных успешно!');
              StatusBar1.Panels[0].Text := 'Подключено: ' + ExtractFileName(FDBPath);
              btnTestDB.Caption := 'Отключить БД';

               LoadClients;
            end
            else
            begin
              ShowMessage('❌ Не удалось подключиться к выбранному файлу');
            end;
          end;
        finally
          OpenDialog.Free;
        end;
      end;
    end;
  end;
end;


procedure TformMain.btnNewClientClick(Sender: TObject);
begin
  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
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
  if PageControl1.ActivePage = tsClients then
    LoadClients
  else if PageControl1.ActivePage = tsSubscription then
    LoadSubscriptions
  else if PageControl1.ActivePage = tsVisits then
    LoadVisits;
  end;
end.

procedure TformMain.LoadSubscriptions;
begin

end;


  procedure TformMain.LoadVisits;
begin

end;









end.




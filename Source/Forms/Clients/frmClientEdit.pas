unit frmClientEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, DBModule;

type
  TfrmClientEdit1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label4: TLabel;
    ComboBox1: TComboBox;
    Label5: TLabel;
    btnSaveClient: TButton;
    btnCancel: TButton;

    procedure btnSaveClientClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  FIsEditMode: Boolean;
    FClientID: Integer;
    procedure ClearForm;
    { Private declarations }
  public
  property IsEditMode: Boolean read FIsEditMode write FIsEditMode;
  property ClientID: Integer read FClientID write FClientID;
    { Public declarations }
  end;

var
  frmClientEdit1: TfrmClientEdit1;

implementation

{$R *.dfm}

procedure TfrmClientEdit1.btnSaveClientClick(Sender: TObject);
var
  FullName, Phone, Email, MembershipType: string;
  BirthDate: TDate;
  IsActive: Boolean;
begin
  // ШАГ 1: ВАЛИДАЦИЯ ДАННЫХ
  // Проверяем, что ФИО не пустое
  FullName := Trim(Edit1.Text);
  if FullName = '' then
  begin
    ShowMessage('Введите ФИО клиента!');
    Edit1.SetFocus;  // Устанавливаем фокус на поле с ошибкой
    Exit;            // Выходим из процедуры
  end;

  // Проверяем телефон
  Phone := Trim(Edit2.Text);
  if Phone = '' then
  begin
    ShowMessage('Введите телефон клиента!');
    Edit2.SetFocus;
    Exit;
  end;

  // ШАГ 2: СБОР ДАННЫХ ИЗ ПОЛЕЙ
  Email := Trim(Edit3.Text);
  MembershipType := ComboBox1.Text;
  BirthDate := DateTimePicker1.Date;
  IsActive := True;  // Новый клиент всегда активен

  // ШАГ 3: СОХРАНЕНИЕ В БАЗЕ ДАННЫХ
  try
    // Проверяем подключение к БД
    if DB.IsConnected then
    begin
      // Пока просто показываем, какие данные собрали
      // Позже заменим на реальное сохранение
      ShowMessage('Клиент будет сохранен:' + #13#10 +
                  'ФИО: ' + FullName + #13#10 +
                  'Телефон: ' + Phone + #13#10 +
                  'Email: ' + Email + #13#10 +
                  'Тип абонемента: ' + MembershipType + #13#10 +
                  'Дата рождения: ' + DateToStr(BirthDate));

      // Закрываем форму с результатом mrOk
      ModalResult := mrOk;
    end
    else
    begin
      ShowMessage('Ошибка: нет подключения к базе данных!');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Ошибка сохранения клиента: ' + E.Message);
    end;
  end;
end;




procedure TfrmClientEdit1.btnCancelClick(Sender: TObject);
begin
  // Спрашиваем подтверждение
  if MessageDlg('Отменить ввод данных?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ClearForm;  // Очищаем форму
    ModalResult := mrCancel;  // Закрываем с отменой
  end;
end;

// В FormCreate инициализировать значения

  procedure TfrmClientEdit1.FormCreate(Sender: TObject);
begin
  // Инициализация переменных
  FIsEditMode := False;  // По умолчанию - создание нового
  FClientID := 0;        // ID = 0 значит новый клиент

  // Устанавливаем текущую дату в DatePicker
  DateTimePicker1.Date := Now;

  // Очищаем и заполняем ComboBox
  ComboBox1.Clear;
  ComboBox1.Items.Add('Разовый');
  ComboBox1.Items.Add('Месячный');
  ComboBox1.Items.Add('Годовой');
  ComboBox1.ItemIndex := 0;

  // Очищаем форму
  ClearForm;
end;

procedure TfrmClientEdit1.ClearForm;
begin
  // Очищаем все поля ввода
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  DateTimePicker1.Date := Now;
  ComboBox1.ItemIndex := 0;
end;

end.

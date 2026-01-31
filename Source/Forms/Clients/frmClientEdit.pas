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
  function GetFullName: string;
function GetPhone: string;
function GetEmail: string;
function GetMembershipType: string;
function GetBirthDate: TDate;

    procedure ClearForm;
    { Private declarations }
  public
  property ClientFullName: string read GetFullName;
property ClientPhone: string read GetPhone;
property ClientEmail: string read GetEmail;
property ClientMembershipType: string read GetMembershipType;
property ClientBirthDate: TDate read GetBirthDate;
  property IsEditMode: Boolean read FIsEditMode write FIsEditMode;
  property ClientID: Integer read FClientID write FClientID;
    { Public declarations }
  end;

var
  frmClientEdit1: TfrmClientEdit1;

implementation

{$R *.dfm}

function TfrmClientEdit1.GetFullName: string;
begin
  Result := Trim(Edit1.Text);
end;

function TfrmClientEdit1.GetPhone: string;
begin
  Result := Trim(Edit2.Text);
end;

function TfrmClientEdit1.GetEmail: string;
begin
  Result := Trim(Edit3.Text);
end;

function TfrmClientEdit1.GetMembershipType: string;
begin
  Result := ComboBox1.Text;
end;

function TfrmClientEdit1.GetBirthDate: TDate;
begin
  Result := DateTimePicker1.Date;
end;


procedure TfrmClientEdit1.btnSaveClientClick(Sender: TObject);
var
  FullName, Phone, Email, MembershipType: string;
  BirthDate: TDate;
  IsActive: Boolean;
  ClientID: Integer;
begin
  // ШАГ 1: ВАЛИДАЦИЯ ДАННЫХ
  FullName := Trim(Edit1.Text);
  if FullName = '' then
  begin
    ShowMessage('Введите ФИО клиента!');
    Edit1.SetFocus;
    Exit;
  end;

  Phone := Trim(Edit2.Text);
  if Phone = '' then
  begin
    ShowMessage('Введите телефон клиента!');
    Edit2.SetFocus;
    Exit;
  end;

  // ШАГ 2: СБОР ДАННЫХ
  Email := Trim(Edit3.Text);
  MembershipType := ComboBox1.Text;
  BirthDate := DateTimePicker1.Date;
  IsActive := True;

  // ШАГ 3: СОХРАНЕНИЕ В БАЗЕ ДАННЫХ
  try
    if DB.IsConnected then
    begin
      // РЕАЛЬНОЕ СОХРАНЕНИЕ!
      ClientID := DB.AddClient(
        FullName,           // ФИО
        Email,              // Email
        MembershipType,     // Тип абонемента
        Now,                // Дата регистрации
        Phone,              // Телефон
        IsActive,           // Активен
        BirthDate           // Дата рождения
      );

      if ClientID > 0 then
      begin
        // Сохраняем ID клиента
        FClientID := ClientID;

        // Закрываем форму с результатом mrOk
        ModalResult := mrOk;

        // Сообщение об успехе
        ShowMessage('Клиент успешно сохранен!' + #13#10 +
                   'ID: ' + IntToStr(ClientID));
      end
      else
      begin
        ShowMessage('Ошибка: не удалось сохранить клиента');
      end;
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

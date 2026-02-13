unit frmClientEdit;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Menus,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, frmVisitEdit, frmSubscriptionEdit, DBModule, AppConsts,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, System.UITypes;

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


    procedure LoadClientData(ClientID: Integer);
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
  procedure LoadDataForEdit(ClientID: Integer);
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

procedure TfrmClientEdit1.LoadDataForEdit(ClientID: Integer);
begin
  FIsEditMode := True;
  FClientID := ClientID;
  LoadClientData(ClientID);
end;

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
  NewClientID: Integer;
  Success: Boolean;
begin
  // ВАЛИДАЦИЯ ДАННЫХ
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

  // СБОР ДАННЫХ
  Email := Trim(Edit3.Text);
  MembershipType := ComboBox1.Text;
  BirthDate := DateTimePicker1.Date;
  IsActive := True;

  try
    if not DB.IsConnected then
    begin
      ShowMessage('Ошибка: нет подключения к базе данных!');
      Exit;
    end;

    // ПРОВЕРЯЕМ РЕЖИМ РАБОТЫ
    if FIsEditMode and (FClientID > 0) then
    begin
      // РЕЖИМ РЕДАКТИРОВАНИЯ - обновляем существующего клиента
      Success := DB.UpdateClient(
        FClientID,        // ID клиента (не меняется!)
        FullName,         // Новое ФИО
        Phone,            // Новый телефон
        Email,            // Новый email
        MembershipType,   // Новый тип членства
        BirthDate         // Новая дата рождения
      );

      if Success then
      begin
        ModalResult := mrOk;
        ShowMessage('✅ Клиент успешно обновлен! ID: ' + IntToStr(FClientID));
      end
      else
        ShowMessage('❌ Ошибка: не удалось обновить клиента');
    end
    else
    begin
      // РЕЖИМ ДОБАВЛЕНИЯ - создаем нового клиента
      NewClientID := DB.AddClient(
        FullName,
        Email,
        MembershipType,
        Now,
        Phone,
        IsActive,
        BirthDate
      );

      if NewClientID > 0 then
      begin
        FClientID := NewClientID;
        ModalResult := mrOk;
        ShowMessage('✅ Клиент успешно добавлен! ID: ' + IntToStr(NewClientID));
      end
      else
      begin
        ShowMessage('❌ Ошибка: не удалось добавить клиента');
      end;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('❌ Ошибка сохранения клиента: ' + E.Message);
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


 ShowMessage('FormCreate: IsEditMode=' + BoolToStr(FIsEditMode, True) +
              ', ClientID=' + IntToStr(FClientID));
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

  // ЕСЛИ ЭТО РЕЖИМ РЕДАКТИРОВАНИЯ - ЗАГРУЖАЕМ ДАННЫЕ
  if FIsEditMode and (FClientID > 0) then
    LoadClientData(FClientID)
  else
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


procedure TfrmClientEdit1.LoadClientData(ClientID: Integer);
var
  Query: TFDQuery;
begin
  if not DB.IsConnected then Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;

    // Читаем данные клиента из БД
    Query.SQL.Text :=
      'SELECT full_name, phone, email, birth_date, membership_type ' +
      'FROM clients WHERE id = :id';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

    if not Query.Eof then
    begin
      // Заполняем поля формы
      Edit1.Text := Query.FieldByName('full_name').AsString;
      Edit2.Text := Query.FieldByName('phone').AsString;
      Edit3.Text := Query.FieldByName('email').AsString;
      DateTimePicker1.Date := Query.FieldByName('birth_date').AsDateTime;

      // Устанавливаем тип членства в ComboBox
      var MembershipType := Query.FieldByName('membership_type').AsString;
      for var i := 0 to ComboBox1.Items.Count - 1 do
        if ComboBox1.Items[i] = MembershipType then
        begin
          ComboBox1.ItemIndex := i;
          Break;
        end;
    end;

  finally
    Query.Free;
  end;
end;

end.

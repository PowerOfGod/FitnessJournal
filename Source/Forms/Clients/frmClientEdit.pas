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
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, System.UITypes, System.DateUtils;

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
  function IsValidEmail(const Email: string): Boolean;
  function IsValidBirthDate(const BirthDate: TDate): Boolean;
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


function TfrmClientEdit1.IsValidEmail(const Email: string): Boolean;
var
  AtPos, DotPos: Integer;
begin
   Result := False;

   if Trim(Email) = '' then
   Exit;

   AtPos := Pos('@', Email);
   if AtPos = 0 then
   begin
     ShowMessage('Ошибка: в email должен быть символ @');
    Exit;
   end;

  if AtPos = 1 then
  begin
    ShowMessage('Ошибка: email не может начинаться с @');
    Exit;
  end;

  DotPos := Pos('.', Email, AtPos + 1);
  if DotPos = 0 then
  begin
    ShowMessage('Ошибка: после @ должен быть домен (пример: mail.ru)');
    Exit;
  end;

  if DotPos = AtPos + 1 then
  begin
    ShowMessage('Ошибка: после @ должен быть домен (пример: @mail.ru)');
    Exit;
  end;

  if DotPos = Length(Email) then
  begin
    ShowMessage('Ошибка: после точки должно быть расширение (.ru, .com)');
    Exit;
  end;

   Result := True;

end;

function TfrmClientEdit1.IsValidBirthDate(const BirthDate: TDate): Boolean;
begin
     Result := False;

     if BirthDate > Date then
     begin
       ShowMessage('Ошибка: дата рождения не может быть в будущем!');
    Exit;
     end;

     if YearsBetween(Date, BirthDate) < 14 then
  begin
    ShowMessage('Ошибка: клиенту должно быть не менее 14 лет!');
    Exit;
  end;

  if YearsBetween(Date, BirthDate) > 120 then
  begin
    ShowMessage('Ошибка: проверьте правильность даты рождения!');
    Exit;
  end;

   Result := True;
end;

procedure TfrmClientEdit1.btnSaveClientClick(Sender: TObject);
var
  FullName, Phone, Email, MembershipType: string;
  BirthDate: TDate;
  IsActive: Boolean;
  NewClientID: Integer;
  Success: Boolean;
  SubscriptionStartDate: TDate;
  SubscriptionEndDate: TDate;
  SubscriptionPrice: Double;
  SubscriptionVisits: Integer;
  SubscriptionRemaining: Integer;
begin

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

  Email := Trim(Edit3.text);
  if Email <> '' then
  begin
      if not IsValidEmail(Email) then
      begin
        ShowMessage('Введен некоректный Email!');
         Edit3.SetFocus;
      Exit;
      end;

  end;

  BirthDate := DateTimePicker1.Date;
  if not IsValidBirthDate(BirthDate) then
  begin
    DateTimePicker1.SetFocus;
    Exit;
  end;


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


    if MembershipType <> 'Без абонемента' then
    begin

      case ComboBox1.ItemIndex of
        1:
        begin
          SubscriptionPrice := 500;
          SubscriptionVisits := 1;
          SubscriptionRemaining := 1;
          SubscriptionEndDate := Date + 1;
        end;
        2:
        begin
          SubscriptionPrice := 3000;
          SubscriptionVisits := 0;
          SubscriptionRemaining := 0;
          SubscriptionEndDate := Date + 30;
        end;
        3:
        begin
          SubscriptionPrice := 8000;
          SubscriptionVisits := 0;
          SubscriptionRemaining := 0;
          SubscriptionEndDate := Date + 90;
        end;
        4:
        begin
          SubscriptionPrice := 25000;
          SubscriptionVisits := 0;
          SubscriptionRemaining := 0;
          SubscriptionEndDate := Date + 365;
        end;
      else
        Exit;
      end;


      var Msg := '⚠ ПОДТВЕРЖДЕНИЕ АБОНЕМЕНТА ⚠' + sLineBreak + sLineBreak +
                 'Клиент: ' + FullName + sLineBreak +
                 'Абонемент: ' + MembershipType + sLineBreak +
                 'Стоимость: ' + FormatFloat('0 руб.', SubscriptionPrice) + sLineBreak +
                 'Действует до: ' + DateToStr(SubscriptionEndDate) + sLineBreak;

      if SubscriptionVisits > 0 then
        Msg := Msg + 'Количество посещений: ' + IntToStr(SubscriptionVisits) + sLineBreak;

      Msg := Msg + sLineBreak + 'Добавить абонемент клиенту?';

      if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      begin
        ShowMessage('Абонемент не будет добавлен');
        MembershipType := 'Без абонемента';
      end;
    end;


    if FIsEditMode and (FClientID > 0) then
    begin

      Success := DB.UpdateClient(
        FClientID,
        FullName,
        Phone,
        Email,
        MembershipType,
        BirthDate
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


        if (MembershipType <> 'Без абонемента') and (ComboBox1.ItemIndex > 0) then
        begin
          var SubID := DB.AddSubscription(
            NewClientID,
            MembershipType,
            Date,
            SubscriptionEndDate,
            SubscriptionPrice,
            SubscriptionVisits,
            SubscriptionRemaining
          );

          if SubID > 0 then
            ShowMessage('✅ Абонемент успешно добавлен! ID: ' + IntToStr(SubID))
          else
            ShowMessage('❌ Ошибка при добавлении абонемента');
        end;

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

  if MessageDlg('Отменить ввод данных?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ClearForm;
    ModalResult := mrCancel;
  end;
end;



procedure TfrmClientEdit1.FormCreate(Sender: TObject);
begin



  FIsEditMode := False;
  FClientID := 0;


  DateTimePicker1.Date := Now;


  ComboBox1.Clear;
  ComboBox1.Items.Add('Без абонемента');
  ComboBox1.Items.Add('Разовый');
  ComboBox1.Items.Add('Месячный');
  ComboBox1.Items.Add('Квартальный');
  ComboBox1.Items.Add('Годовой');
  ComboBox1.ItemIndex := 0;


  if FIsEditMode and (FClientID > 0) then
    LoadClientData(FClientID)
  else
    ClearForm;
end;

procedure TfrmClientEdit1.ClearForm;
begin

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


    Query.SQL.Text :=
      'SELECT full_name, phone, email, birth_date, membership_type ' +
      'FROM clients WHERE id = :id';
    Query.ParamByName('id').AsInteger := ClientID;
    Query.Open;

    if not Query.Eof then
    begin

      Edit1.Text := Query.FieldByName('full_name').AsString;
      Edit2.Text := Query.FieldByName('phone').AsString;
      Edit3.Text := Query.FieldByName('email').AsString;
      DateTimePicker1.Date := Query.FieldByName('birth_date').AsDateTime;


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

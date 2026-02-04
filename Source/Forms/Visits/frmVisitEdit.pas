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

       if cbClient.ItemIndex >= 0 then
       begin
          FClientID  := Integer(cbClient.Items.Objects[cbClient.ItemIndex]);

          LoadClientInfo(FClientID);
       end
       else
       begin
         FClientID  := 0;
         edtPhone.Text := '';
         edtSubscription.Text := '';
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

  LoadClients;


  cbTrainer.Items.Clear;
  cbTrainer.Items.Add('Иван Петров');
  cbTrainer.Items.Add('Мария Сидорова');
  cbTrainer.Items.Add('Алексей Козлов');
  cbTrainer.Items.Add('Екатерина Новикова');

   if cbTrainer.Items.Count > 0 then
    cbTrainer.ItemIndex := 0;

  btnExit.Enabled := False;

end;


 procedure TfrmVisitEdit1.LoadClients;
begin

  cbClient.Clear;

  if not DB.IsConnected then
  begin
    ShowMessage('Сначала подключитесь к базе данных!');
    Exit;
  end;
      var Query := TFDQuery.Create(nil);
  try

      Query.Connection := DB.GetConnection;

        Query.SQL.Text :=
      'SELECT id, full_name, phone FROM clients ' +
      'WHERE is_active = 1 ' +
      'ORDER BY full_name';
    Query.Open;

        while not Query.Eof do
    begin
      // Сохраняем ID клиента в Tag
      cbClient.Items.AddObject(
        Query.FieldByName('full_name').AsString,
        TObject(Query.FieldByName('id').AsInteger)
      );
      Query.Next;
    end;


  finally
    Query.Free;
  end;
end;




procedure TfrmVisitEdit1.btnEntryClick(Sender: TObject);
var
  VisitDate: TDate;
  EntryTime: TTime;
  ExitTime: TTime;
  TrainerName: string;
  Notes: string;
begin
  // 1. Проверка выбора клиента
  if cbClient.ItemIndex < 0 then
  begin
    ShowMessage('Выберите клиента!');
    cbClient.SetFocus;
    Exit;
  end;

  // 2. Проверка выбора тренера
  if cbTrainer.ItemIndex < 0 then
  begin
    ShowMessage('Выберите тренера!');
    cbTrainer.SetFocus;
    Exit;
  end;

  // 3. Подготавливаем данные
  VisitDate := Date;
  EntryTime := Time;
  ExitTime := 0; // 0 = NULL (клиент еще не вышел)
  TrainerName := cbTrainer.Text;
  Notes := memoNotes.Text;

  // 4. Получаем ID клиента
  FClientID := Integer(cbClient.Items.Objects[cbClient.ItemIndex]);

  // 5. Сохраняем в БД
  try
    FVisitID := DB.AddVisit(  // ← ВАЖНО: сохраняем возвращаемый ID!
      FClientID,
      VisitDate,
      EntryTime,
      ExitTime,
      TrainerName,
      Notes
    );

    if FVisitID > 0 then
    begin
      // Успешно сохранено
      FEntryTime := EntryTime;
      FIsEntryRegistered := True;

      // Меняем интерфейс
      btnEntry.Enabled := False;
      btnExit.Enabled := True;
      cbClient.Enabled := False;
      cbTrainer.Enabled := False;
      memoNotes.ReadOnly := True;

      // Сообщение об успехе
      ShowMessage(
        '✅ Вход зафиксирован!' + sLineBreak +
        'Клиент: ' + cbClient.Text + sLineBreak +
        'Время: ' + FormatDateTime('hh:nn:ss', EntryTime) + sLineBreak +
        'ID посещения: ' + IntToStr(FVisitID)
      );
    end
    else
    begin
      ShowMessage('❌ Ошибка: не удалось сохранить посещение (ID <= 0)');
    end;

  except
    on E: Exception do
    begin
      ShowMessage('❌ Ошибка при сохранении посещения:' + sLineBreak + E.Message);
    end;
  end;
end;


procedure TfrmVisitEdit1.btnExitClick(Sender: TObject);
begin
  if FIsEntryRegistered = False then
  begin
    ShowMessage('Вы не зарегистрированны! Введите данные и войдите)');
    Exit;
  end
  else
  begin
      ModalResult := mrOk;
  end;



end;

procedure TfrmVisitEdit1.btnCancelClick(Sender: TObject);
begin
  // Очистка формы
  cbClient.ItemIndex := -1;
  cbTrainer.Text := '';
  edtPhone.Text := '';
  edtSubscription.Text := '';
  memoNotes.Text := '';

  // Сброс состояния
  FIsEntryRegistered := False;
  btnEntry.Enabled := True;
  btnExit.Enabled := False;
end;


procedure TfrmVisitEdit1.memoNotesChange(Sender: TObject);
begin
   if memoNotes.MaxLength > 500 then
   begin
      ShowMessage('Вы превысили лимит символов!');
   end;

end;


end.

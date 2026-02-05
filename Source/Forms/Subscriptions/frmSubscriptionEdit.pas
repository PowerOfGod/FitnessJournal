unit frmSubscriptionEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DBModule,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.ComCtrls;

type
  TfrmSubscriptionEdit1 = class(TForm)
    cbClient: TComboBox;
    cbType: TComboBox;
    lbClient: TLabel;
    lblType: TLabel;
    dtStartDate: TDateTimePicker;
    dtEndDate: TDateTimePicker;
    lbStatDate: TLabel;
    lbEndDate: TLabel;
    edtPrice: TEdit;
    lbPrice: TLabel;
    btnSave: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private

    FClientID : Integer;
    FSubscriptionID: Integer;
    procedure LoadClientsFromDB;
    procedure CalculateEndDate;
     procedure UpdatePrice;
    procedure SetupSubscriptionTypes;
    { Private declarations }
  public

   property ClientID: Integer read FClientID;
    { Public declarations }
  end;

var
  frmSubscriptionEdit1: TfrmSubscriptionEdit1;
  SubscriptionPrices: array[0..3] of Double = (500, 3000, 8000, 25000);
  SubscriptionDurations: array[0..3] of Integer = (1, 30, 90, 365);

implementation

{$R *.dfm}



procedure TfrmSubscriptionEdit1.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Отменить добавление абонемента? Все введенные данные будут потеряны.',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ModalResult := mrCancel;
  end;
end;


procedure TfrmSubscriptionEdit1.btnSaveClick(Sender: TObject);
var
  SubscriptionType: string;
  StartDate, EndDate: TDate;
  Price: Double;
  VisitsCount: Integer;
  RemainingVisits: Integer;
begin
  // 1. Проверка выбора клиента и типа
  if (cbType.ItemIndex < 0) or (cbClient.ItemIndex < 0) then
  begin
    ShowMessage('Выберите клиента и тип абонемента!');
    Exit;
  end;

  // 2. Получаем ID клиента
  if cbClient.ItemIndex > 0 then
    FClientID := Integer(cbClient.Items.Objects[cbClient.ItemIndex])
  else
  begin
    ShowMessage('Выберите клиента!');
    Exit;
  end;

  // 3. Получаем данные из формы
  SubscriptionType := cbType.Text;
  StartDate := dtStartDate.Date;
  EndDate := dtEndDate.Date;

  // Проверяем что цена - число
  if not TryStrToFloat(edtPrice.Text, Price) then
  begin
    ShowMessage('Неверный формат цены!');
    Exit;
  end;

  // 4. Определяем количество посещений
  if SubscriptionType = 'Разовый' then
  begin
    VisitsCount := 1;
    RemainingVisits := 1;
  end
  else
  begin
    VisitsCount := 0;        // Безлимит
    RemainingVisits := 0;    // Безлимит
  end;

  // 5. Сохраняем в БД
  try
    FSubscriptionID := DB.AddSubscription(  // ← ИСПРАВЬ!
      FClientID,
      SubscriptionType,
      StartDate,
      EndDate,
      StrToFloat(edtPrice.Text),
      VisitsCount,
      RemainingVisits
    );

    // 6. Проверяем результат
    if FSubscriptionID > 0 then
    begin
      ShowMessage(
        '✅ Абонемент успешно добавлен!' + sLineBreak +
        'Клиент: ' + cbClient.Text + sLineBreak +
        'Тип: ' + SubscriptionType + sLineBreak +
        'Стоимость: ' + FormatFloat('0 руб.', Price) + sLineBreak +
        'ID абонемента: ' + IntToStr(FSubscriptionID)  // ← ИСПРАВЬ!
      );
      ModalResult := mrOk;
    end
    else
    begin
      ShowMessage('❌ Ошибка: не удалось сохранить абонемент (ID <= 0)');
    end;

  except
    on E: Exception do
    begin
      ShowMessage('❌ Ошибка сохранения абонемента:' + sLineBreak + E.Message);
    end;
  end;
end;

procedure TfrmSubscriptionEdit1.cbTypeChange(Sender: TObject);
begin


//  case cbType.ItemIndex of
//    0:begin
//           dtEndDate.Date := Date + 1;
//           edtPrice.Text := '500';
////        edtSubscription.Text := 'Месячный (до 31.01.2024)';
//      end;
//    1:begin
//          dtEndDate.Date := Date + 30;
//          edtPrice.Text := '3000';
////        edtPhone.Text := '+7 999 222-33-44';
////        edtSubscription.Text := 'Разовый';
//      end;
//
//    2:begin
//          dtEndDate.Date := Date + 90;
//          edtPrice.Text := '8000';
////        edtPhone.Text := '+7 999 333-44-55';
////        edtSubscription.Text := 'Годовой (до 31.12.2024)';
//      end;
//    3:begin
//          dtEndDate.Date := Date + 365;
//          edtPrice.Text := '25000';
////        edtPhone.Text := '+7 999 333-44-55';
////        edtSubscription.Text := 'Годовой (до 31.12.2024)';
//      end;
//
//  end;

//    FClientID  := cbClient.ItemIndex + 1;

CalculateEndDate;
  UpdatePrice;

end;

procedure TfrmSubscriptionEdit1.FormCreate(Sender: TObject);
begin


  FClientID := 0;
  FSubscriptionID := 0;
  edtPrice.ReadOnly := True;
  edtPrice.Color := clBtnFace;

  cbType.ItemIndex := 0;
    SubscriptionPrices[0] := 500;
     SubscriptionPrices[1] := 3000;
      SubscriptionPrices[2] := 8000;
       SubscriptionPrices[3] := 25000;

       SubscriptionDurations[0] := 1;
       SubscriptionDurations[1] := 30;
       SubscriptionDurations[2] := 90;
       SubscriptionDurations[3] := 365;

        edtPrice.ReadOnly := True;
        edtPrice.Color := clBtnFace;

         LoadClientsFromDB;
         SetupSubscriptionTypes;



  dtStartDate.Date := Date;
  CalculateEndDate;
  UpdatePrice;

end;


procedure TfrmSubscriptionEdit1.LoadClientsFromDB;
begin
  cbClient.Clear;
  cbClient.Items.Add('-- Выберите клиента --');

  if not DB.IsConnected then
  begin
    ShowMessage('Нет подключения к базе данных!');
    Exit;
  end;

  var Query := TFDQuery.Create(nil);
  try
    Query.Connection := DB.GetConnection;
    Query.SQL.Text :=
      'SELECT id, full_name, phone ' +
      'FROM clients ' +
      'WHERE is_active = 1 ' +
      'ORDER BY full_name';
    Query.Open;

    while not Query.Eof do
    begin
      cbClient.Items.AddObject(
        Query.FieldByName('full_name').AsString,
        TObject(Query.FieldByName('id').AsInteger)
      );
      Query.Next;
    end;

  finally
    Query.Free;
  end;

  cbClient.ItemIndex := 0;
end;

procedure TfrmSubscriptionEdit1.SetupSubscriptionTypes;
begin
    cbType.Items.Clear;


cbType.Items.Add('Разовый');
  cbType.Items.Add('Месячный');
  cbType.Items.Add('Квартальный');
  cbType.Items.Add('Годовой');

  if cbType.Items.Count > 0 then
    cbType.ItemIndex := 0;

end;

procedure TfrmSubscriptionEdit1.CalculateEndDate;
begin
  if cbType.ItemIndex < 0 then Exit;

  // Используем массив длительностей
  if (cbType.ItemIndex >= 0) and (cbType.ItemIndex <= High(SubscriptionDurations)) then
  begin
    dtEndDate.Date := dtStartDate.Date + SubscriptionDurations[cbType.ItemIndex];
  end
  else
  begin
    dtEndDate.Date := dtStartDate.Date;
  end;
end;

procedure TfrmSubscriptionEdit1.UpdatePrice;
begin
     if cbType.ItemIndex < 0 then
  begin
    edtPrice.Text := '0';
    Exit;
  end;

  // Используем массив цен
  if (cbType.ItemIndex >= 0) and (cbType.ItemIndex <= High(SubscriptionPrices)) then
  begin
    edtPrice.Text := FormatFloat('0', SubscriptionPrices[cbType.ItemIndex]);
  end
  else
  begin
    edtPrice.Text := '0';
  end;


end;

end.

unit frmSubscriptionEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

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

    { Private declarations }
  public

   property ClientID: Integer read FClientID;
    { Public declarations }
  end;

var
  frmSubscriptionEdit1: TfrmSubscriptionEdit1;

implementation

{$R *.dfm}



procedure TfrmSubscriptionEdit1.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Отменить ввод данных?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then
  begin
    // Очистка формы
    cbClient.ItemIndex := -1;
    cbType.ItemIndex := -1;
    edtPrice.Text := '';
    dtStartDate.Date := Date;
    dtEndDate.Date := Date + 30;

    ModalResult := mrCancel;
  end;

end;

procedure TfrmSubscriptionEdit1.btnSaveClick(Sender: TObject);
begin
// Проверка: если НЕ выбран клиент ИЛИ НЕ выбран тренер
  if (cbType.ItemIndex < 0) or (cbClient.ItemIndex < 0) then
  begin
    ShowMessage('Выберите клиента и абонемент!');
    Exit;
  end;





  ShowMessage('Вы успешно купили абонемент!' + #13#10 + 'Клиент: ' + cbClient.Text + #13#10 + 'Абонемент: ' + cbType.Text);
  ModalResult := mrOk;
end;

procedure TfrmSubscriptionEdit1.cbTypeChange(Sender: TObject);
begin


  case cbType.ItemIndex of
    0:begin
           dtEndDate.Date := Date + 1;
           edtPrice.Text := '500';
//        edtSubscription.Text := 'Месячный (до 31.01.2024)';
      end;
    1:begin
          dtEndDate.Date := Date + 30;
          edtPrice.Text := '3000';
//        edtPhone.Text := '+7 999 222-33-44';
//        edtSubscription.Text := 'Разовый';
      end;

    2:begin
          dtEndDate.Date := Date + 90;
          edtPrice.Text := '8000';
//        edtPhone.Text := '+7 999 333-44-55';
//        edtSubscription.Text := 'Годовой (до 31.12.2024)';
      end;
    3:begin
          dtEndDate.Date := Date + 365;
          edtPrice.Text := '25000';
//        edtPhone.Text := '+7 999 333-44-55';
//        edtSubscription.Text := 'Годовой (до 31.12.2024)';
      end;

  end;

    FClientID  := cbClient.ItemIndex + 1;

end;

procedure TfrmSubscriptionEdit1.FormCreate(Sender: TObject);
begin


  FClientID := 0;
  edtPrice.ReadOnly := True;
  edtPrice.Color := clBtnFace;



  cbClient.Items.Add('Савченко Владислав Павлович');
  cbClient.Items.Add('Бондарев Владислав Александрович');
  cbClient.Items.Add('Джоли Анжелина Питтовна');

    cbType.Items.Add('Разовый (500 руб)');
  cbType.Items.Add('Месячный (3000 руб)');
  cbType.Items.Add('Квартальный (8000 руб)');
  cbType.Items.Add('Годовой (25000 руб)');


  dtStartDate.Date := Date;
  dtEndDate.Date := Date + 30;

end;

end.

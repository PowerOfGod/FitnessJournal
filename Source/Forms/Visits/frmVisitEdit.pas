unit frmVisitEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

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



  private

    FClientID : Integer;
    FIsEntryRegistered : Boolean;
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
  case cbClient.ItemIndex of
    0:begin
        edtPhone.Text := '+7 999 111-22-33';
        edtSubscription.Text := 'Месячный (до 31.01.2024)';
      end;
    1:begin
        edtPhone.Text := '+7 999 222-33-44';
        edtSubscription.Text := 'Разовый';
      end;

    2:begin
        edtPhone.Text := '+7 999 333-44-55';
        edtSubscription.Text := 'Годовой (до 31.12.2024)';
      end;

  end;

    FClientID  := cbClient.ItemIndex + 1;
end;

procedure TfrmVisitEdit1.FormCreate(Sender: TObject);
begin

  FClientID := 0;
  FIsEntryRegistered := False;


  cbClient.Items.Add('Савченко Владислав Павлович');
  cbClient.Items.Add('Бондарев Владислав Александрович');
  cbClient.Items.Add('Джоли Анжелина Питтовна');

  cbTrainer.Items.Add('Кирюха');
  cbTrainer.Items.Add('Серега');
  cbTrainer.Items.Add('Петя');
  cbTrainer.Items.Add('Толик');

  btnExit.Enabled := False;

end;






procedure TfrmVisitEdit1.btnEntryClick(Sender: TObject);
begin
  // Проверка: если НЕ выбран клиент ИЛИ НЕ выбран тренер
  if (cbClient.ItemIndex < 0) or (cbTrainer.ItemIndex < 0) then
  begin
    ShowMessage('Выберите клиента и тренера!');
    Exit;
  end;

  // Регистрация входа
  FIsEntryRegistered := True;
  btnEntry.Enabled := False;
  btnExit.Enabled := True;

  ShowMessage('Вы успешно зарегистрировались!' + #13#10 + 'Клиент: ' + cbClient.Text + #13#10 + 'Тренер: ' + cbTrainer.Text);
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

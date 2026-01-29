unit frmClientEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

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
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientEdit1: TfrmClientEdit1;

implementation

{$R *.dfm}

procedure TfrmClientEdit1.btnSaveClientClick(Sender: TObject);
begin
  if Trim(Edit1.Text) = '' then
  begin
    ShowMessage('Введите ФИО клиента!');
    Edit1.SetFocus;
    Exit;
  end;

  ModalResult := mrOk;
end;



procedure TfrmClientEdit1.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

// В FormCreate инициализировать значения
procedure TfrmClientEdit1.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := Date;

  ComboBox1.Items.Add('Разовый');
  ComboBox1.Items.Add('Месячный');
  ComboBox1.Items.Add('Годовой');
  ComboBox1.ItemIndex := 0;
end;

end.

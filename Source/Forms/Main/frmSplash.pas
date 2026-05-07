unit frmSplash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)   // ← оставляем TForm1 (как у вас в форме)
    ImageLogo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClick(Sender: TObject);   // ← ДОБАВИТЬ для закрытия по клику
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Настройка текста по центру
  Label1.Left := 0;
  Label1.Width := ClientWidth;
  Label1.Alignment := taCenter;

  Label2.Left := 0;
  Label2.Width := ClientWidth;
  Label2.Alignment := taCenter;

  Label3.Left := 0;
  Label3.Width := ClientWidth;
  Label3.Alignment := taCenter;

  // Включаем таймер при создании формы
  Timer1.Interval := 2000;
  Timer1.Enabled := True;   // ← ВКЛЮЧАЕМ ТАЙМЕР
end;

procedure TForm1.FormShow(Sender: TObject);   // ← TForm1, не TfrmSplash
begin
//  Timer1.Enabled := True;   // включаем таймер при показе формы
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Close;
end;

procedure TForm1.FormClick(Sender: TObject);   // ← ДОБАВИТЬ
begin
  // По клику на заставку - сразу закрываем
  Timer1.Enabled := False;
  Close;
end;

end.

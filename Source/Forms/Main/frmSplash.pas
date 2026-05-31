unit frmSplash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    ImageLogo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClick(Sender: TObject);
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

  Label1.Left := 0;
  Label1.Width := ClientWidth;
  Label1.Alignment := taCenter;

  Label2.Left := 0;
  Label2.Width := ClientWidth;
  Label2.Alignment := taCenter;

  Label3.Left := 0;
  Label3.Width := ClientWidth;
  Label3.Alignment := taCenter;


  Timer1.Interval := 2000;
  Timer1.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Close;
end;

procedure TForm1.FormClick(Sender: TObject);
begin

  Timer1.Enabled := False;
  Close;
end;

end.

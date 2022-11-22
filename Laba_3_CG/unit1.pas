unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  MaskEdit;

type
  coords=record
    x, y: integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    FlipAndDecreaseButton: TButton;
    FlipAndIncreaseButton: TButton;
    stretchOyButton: TButton;
    stretchOxButton: TButton;
    mirrorOxButton: TButton;
    mirrorOyButton: TButton;
    mY: TEdit;
    Label2: TLabel;
    mX: TEdit;
    Label1: TLabel;
    MoveButton: TButton;
    RotateButton: TButton;
    FinishDrawing: TButton;
    ClearCanvas: TButton;
    PaintBox1: TPaintBox;
    procedure Button1Click(Sender: TObject);
    procedure ClearCanvasClick(Sender: TObject);
    procedure FinishDrawingClick(Sender: TObject);
    procedure FlipAndDecreaseButtonClick(Sender: TObject);
    procedure FlipAndIncreaseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mirrorOxButtonClick(Sender: TObject);
    procedure mirrorOyButtonClick(Sender: TObject);
    procedure MoveButtonClick(Sender: TObject);
    procedure mXChange(Sender: TObject);
    procedure mXKeyPress(Sender: TObject; var Key: char);
    procedure mYKeyPress(Sender: TObject; var Key: char);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RotateButtonClick(Sender: TObject);
    procedure stretchOxButtonClick(Sender: TObject);
    procedure stretchOyButtonClick(Sender: TObject);
  private

  public

  end;

var

  Form1: TForm1;
  R: array of coords;
  p: integer;
  MoveM, RotateM: array [0..2, 0..2] of integer;
  Sender: TObject;

implementation

{$R *.lfm}

{ TForm1 }

procedure swap(var x, y: integer);

var tmp: integer;

begin
  tmp:=x;
  x:=y;
  y:=tmp;
end;

function sign(x: integer): integer;

begin
  if x>=0 then sign:=1 else sign:=-1;
end;

procedure BV4(x1,x2,y1,y2: integer);

var
  x, y, s1, s2, dy, dx, e, i: integer;
  l: boolean;

begin
  Form1.PaintBox1.Canvas.Brush.Color:=clWhite;
  x:=x1;
  y:=y1;
  dx:=abs(x2-x1);
  dy:=abs(y2-y1);
  s1:=sign(x2-x1);
  s2:=sign(y2-y1);
  if dy < dx then
    l:=false
  else
    begin
      l:=true;
      swap(dx,dy);
    end;
  e:=2*dy-dx;
  for i:=1 to dx+dy do
  begin
    Form1.PaintBox1.Canvas.DrawPixel(x, y, TColorToFPColor(clRed));
    if e < 0 then
    begin
      if l then
        y+=s2
      else
        x+=s1;
      e:=e+2*dy;
    end
    else
    begin
      if l then
        x+=s1
      else
        y+=s2;
      e:=e-2*dx
    end;
  Form1.PaintBox1.Canvas.DrawPixel(x, y, TColorToFPColor(clRed));
  end;
end;

procedure Move;

var
  x, y, i: integer;

begin
  x:=StrToInt(Form1.mX.Text);
  y:=StrToInt(Form1.mY.Text);
  for i:=0 to p do
  begin
    R[i].x+=x;
    R[i].y+=y;
  end;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  for i:=0 to p do
  begin
    if i > 0 then
      BV4(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
  end;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin
  R[p].x:=X;
  R[p].y:=Y;
  if p > 0 then BV4(R[p].x, R[p-1].x, R[p].y, R[p-1].y);
  p+=1;
  setlength(R, p+1);
end;

procedure Rotate(g: real);

var
  i, m, n: integer;

begin
  m:=Form1.PaintBox1.Width div 2;
  n:=Form1.PaintBox1.Height div 2;
  for i:=0 to p do
  begin
    R[i].x:=round( (R[i].x * cos(g) - R[i].y * sin(g) - m * cos(g) + m + n * sin(g)) );
    R[i].y:=round( (R[i].x * sin(g) + R[i].y * cos(g) - m * sin(g) - n * cos(g) + n) );
  end;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  for i:=0 to p do
  begin
    if i > 0 then
      BV4(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
  end;
end;

procedure mirrorOx;

var
  i, m, n: integer;
  g: real;

begin
  g:= 3.14 / 45;
  m:=Form1.PaintBox1.Width div 2;
  n:=Form1.PaintBox1.Height div 2;
  for i:=0 to p do
  begin
    R[i].x:=800 - round(R[i].x);
  end;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  for i:=0 to p do
  begin
    if i > 0 then
      BV4(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
  end;
end;

procedure mirrorOy;

var
  i, m, n: integer;
  g: real;

begin
  g:= 3.14 / 45;
  m:=Form1.PaintBox1.Width div 2;
  n:=Form1.PaintBox1.Height div 2;
  for i:=0 to p do
  begin
    R[i].y:=600 - round(R[i].y);
  end;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  for i:=0 to p do
  begin
    if i > 0 then
      BV4(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
  end;
end;

procedure StretchOx(kx: real);

var
  m, i: integer;

begin
  m:=Form1.PaintBox1.Width div 2;
  for i:=0 to p do
  begin
    R[i].x:=round(R[i].x * kx - m * kx + m);
  end;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  for i:=0 to p do
  begin
    if i > 0 then
      BV4(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
  end;
end;

procedure StretchOy(ky: real);

var
  n, i: integer;

begin
  n:=Form1.PaintBox1.Height div 2;
  for i:=0 to p do
  begin
    R[i].y:=round(R[i].y * ky - n * ky + n);
  end;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  for i:=0 to p do
  begin
    if i > 0 then
      BV4(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
  end;
end;

procedure FlipAndIncrease;

var
  i: integer;
  RR: array of coords;

begin
  for i:=0 to 5 do
  begin
    StretchOx(1.1);
    StretchOy(1.1);
  end;
  setlength(RR, p);
  RR:=R;
  for i:=0 to 90 do Rotate(3.14/45);
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  for i:=0 to p do
  begin
    if i > 0 then
      BV4(RR[i].x, RR[i-1].x, RR[i].y, RR[i-1].y);
  end;
  setlength(RR, 0);
end;

procedure FlipAndDecrease;

var
  i: integer;
  RR: array of coords;

begin
  for i:=0 to 5 do
  begin
    StretchOx(0.98);
    StretchOy(0.98);
  end;
  setlength(RR, p);
  RR:=R;
  for i:=0 to 90 do Rotate(-3.14/45);
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  for i:=0 to p do
  begin
    if i > 0 then
      BV4(RR[i].x, RR[i-1].x, RR[i].y, RR[i-1].y);
  end;
  setlength(RR, 0);
end;

procedure TForm1.RotateButtonClick(Sender: TObject);

begin
  Rotate(3.14/45);
end;

procedure TForm1.stretchOxButtonClick(Sender: TObject);

begin
  if Form1.CheckBox1.Checked then
    StretchOx(0.9)
  else
    StretchOx(1.1);
end;

procedure TForm1.stretchOyButtonClick(Sender: TObject);

begin
  if Form1.CheckBox2.Checked then
    StretchOy(0.9)
  else
    StretchOy(1.1);
end;

procedure TForm1.FormCreate(Sender: TObject);

begin
  p:=0;
  setlength(R, p+1);
end;

procedure TForm1.mirrorOxButtonClick(Sender: TObject);

begin
  mirrorOx;
end;

procedure TForm1.mirrorOyButtonClick(Sender: TObject);

begin
  mirrorOy;
end;

procedure TForm1.MoveButtonClick(Sender: TObject);

begin
  Move;
end;

procedure TForm1.mXChange(Sender: TObject);
begin

end;

procedure TForm1.mXKeyPress(Sender: TObject; var Key: char);

begin
  if (length(Form1.mX.text) = 0) and (not (key in ['0'.. '9', #45, #8])) then
  key:= #0;
  if (length(Form1.mX.text) > 0) and (not (key in ['0'.. '9', #8])) then
  key:= #0;
end;

procedure TForm1.mYKeyPress(Sender: TObject; var Key: char);
begin
  if (length(Form1.mY.text) = 0) and (not (key in ['0'.. '9', #45, #8])) then
  key:= #0;
  if (length(Form1.mY.text) > 0) and (not (key in ['0'.. '9', #8])) then
  key:= #0;
end;

procedure TForm1.FinishDrawingClick(Sender: TObject);

begin
  BV4(R[0].x, R[p-1].x, R[0].y, R[p-1].y);
  R[p].x:=R[0].x;
  R[p].y:=R[0].y;
end;

procedure TForm1.FlipAndDecreaseButtonClick(Sender: TObject);

begin
  FlipAndDecrease;
end;

procedure TForm1.FlipAndIncreaseButtonClick(Sender: TObject);

begin
  FlipAndIncrease;
end;

procedure TForm1.ClearCanvasClick(Sender: TObject);

begin
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  p:=0;
  setlength(R, p+1);
end;

procedure TForm1.Button1Click(Sender: TObject);

var
  i, j: integer;

begin
  for i:=0 to 10 do
  begin
    for j:=0 to 2 do Rotate(3.14/45);
    StretchOx(1.01);
  end;
  for i:=0 to 10 do
  Move;
end;

end.

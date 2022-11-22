unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, math;

type
  points=record
    x, y: integer;
  end;


  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PaintBox1: TPaintBox;
    SimpleLine: TRadioButton;
    BV4Line: TRadioButton;
    BV8Line: TRadioButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  P, R, Anim: array of points;
  m, g, b: integer;
  tmp, buf: TBitMap;

implementation

{$R *.lfm}

function sign(x: integer): integer;

begin
  if x>=0 then sign:=1 else sign:=-1;
end;

procedure swap(var x, y: integer);

var tmp: integer;

begin
  tmp:=x;
  x:=y;
  y:=tmp;
end;

procedure Simple(x1,x2,y1,y2: integer);

var x, y, m: real;
  i: integer;

begin
  if x1<>x2 then
  begin
    m:=(y2-y1)/(x2-x1);
    if abs(m) > 1 then
    begin
      if y1 > y2 then
      begin
        swap(x1,x2);
        swap(y1,y2);
      end;
      x:=x1;
      for i:=y1 to y2 do
      begin
        Form1.PaintBox1.Canvas.DrawPixel(round(x), i, TColorToFPColor(clRed));
        x+=1/m;
      end;
    end
    else
    begin
      if x1 > x2 then
      begin
        swap(x1, x2);
        swap(y1, y2);
      end;
      y:=y1;
      for i:=x1 to x2 do
      begin
        Form1.PaintBox1.Canvas.DrawPixel(i, round(y), TColorToFPColor(clRed));
        y+=m;
      end;
    end;
  end
  else
end;

procedure BV4(x1,x2,y1,y2: integer);

var x, y, s1, s2, dx, dy, e, i: integer;
  l: boolean;

begin
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

procedure BV8(x1,x2,y1,y2: integer);

var x, y, s1, s2, dx, dy, e, i: integer;
  l: boolean;

begin
  l:=false;
  x:=x1;
  y:=y1;
  dx:=abs(x2-x1);
  dy:=abs(y2-y1);
  s1:=sign(x2-x1);
  s2:=sign(y2-y1);
  if dy > dx then
  begin
    swap(dx,dy);
    l:=true;
  end
  else
    l:=false;
  e:=2*dy-dx;
  for i:=1 to dx do
  begin
    Form1.PaintBox1.Canvas.DrawPixel(x, y, TcolorToFPColor(clRed));
    while e>=0 do
    begin
      if l then
        x+=s1
      else
        y+=s2;
      e:=e-2*dx;
    end;
    if l then
      y+=s2
    else
      x+=s1;
    e:=e+2*dy;
  end;
  Form1.PaintBox1.Canvas.DrawPixel(x, y, TcolorToFPColor(clRed));
end;

procedure CircleB(x1, x2, y1, y2: integer);

var rad, x, y, e: integer;

begin
  rad:=round(power((power((x2-x1),2) + power((y2-y1),2)),0.5));
  x:=0;
  y:=rad;
  e:=3-2*rad;
  while x<y do
  begin
    with buf.Canvas do
    begin
      DrawPixel(x1+x, y1+y, TColorToFPColor(clRed));
      DrawPixel(x1+y, y1+x, TColorToFPColor(clRed));
      DrawPixel(x1+y, y1-x, TColorToFPColor(clRed));
      DrawPixel(x1+x, y1-y, TColorToFPColor(clRed));
      DrawPixel(x1-x, y1-y, TColorToFPColor(clRed));
      DrawPixel(x1-y, y1-x, TColorToFPColor(clRed));
      DrawPixel(x1-y, y1+x, TColorToFPColor(clRed));
      DrawPixel(x1-x, y1+y, TColorToFPColor(clRed));
    end;
    if e< 0 then
    e:=e+4*x+6
  else
  begin
    e:=e+4*(x-y)+10;
    y-=1;
  end;
  x+=1;
  end;
  if x = y then
  begin
    with buf.Canvas do
    begin
      DrawPixel(x1+x, y1+y, TColorToFPColor(clRed));
      DrawPixel(x1+y, y1+x, TColorToFPColor(clRed));
      DrawPixel(x1+y, y1-x, TColorToFPColor(clRed));
      DrawPixel(x1+x, y1-y, TColorToFPColor(clRed));
      DrawPixel(x1-x, y1-y, TColorToFPColor(clRed));
      DrawPixel(x1-y, y1-x, TColorToFPColor(clRed));
      DrawPixel(x1-y, y1+x, TColorToFPColor(clRed));
      DrawPixel(x1-x, y1+y, TColorToFPColor(clRed));
    end;
  end;
end;

procedure DrawAux(xn, yn: integer);

var i: integer;

begin
  for i:=1 to length(R)-2 do
  begin
    if Form1.CheckBox2.Checked then sleep(100);
    if Form1.SimpleLine.Checked then Simple(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
    if Form1.BV4Line.Checked then BV4(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
    if Form1.BV8Line.Checked then BV8(R[i].x, R[i-1].x, R[i].y, R[i-1].y);
  end;
end;

procedure Bezie();

var
  xn, yn, i, j, h: integer;
  step, t: real;
  Source: TRect;
  Dest: TRect;
  tmpC: TBitMap;

begin
  tmp:=TBitMap.Create;
  tmpC:=TBitMap.Create;
  buf:=TBitMap.Create;
  with buf do
    begin
      Width := Form1.PaintBox1.Width;
      Height := Form1.PaintBox1.Height;
    end;
  with tmp do
    begin
      Width := Form1.PaintBox1.Width;
      Height := Form1.PaintBox1.Height;
      Dest := Rect(0, 0, Width, Height);
    end;
  with tmpC do
    begin
      Width := Form1.PaintBox1.Width;
      Height := Form1.PaintBox1.Height;
      Dest := Rect(0, 0, Width, Height);
    end;
  b:=0;
  step:=0.01;
  xn:=P[0].x; yn:=P[0].y; t:=0;
  R:=P;
  repeat
    for j:=m-1 downto 2 do
      for i:=0 to j-1 do
      begin
        R[i].x:=R[i].x+round(t*(R[i+1].x-R[i].x));
        R[i].y:=R[i].y+round(t*(R[i+1].y-R[i].y));
      end;
    setlength(Anim, b+1);
    Anim[b].x:=xn;
    Anim[b].y:=yn;
    b+=1;
    if Form1.CheckBox2.Checked then sleep(100);
    if Form1.SimpleLine.Checked then Simple(xn, R[0].x, yn, R[0].y);
    if Form1.BV4Line.Checked then BV4(xn, R[0].x, yn, R[0].y);
    if Form1.BV8Line.Checked then BV8(xn, R[0].x, yn, R[0].y);
    if Form1.CheckBox1.Checked then DrawAux(xn, yn);
    t+=step; xn:=R[0].x; yn:=R[0].y;
  until t > 1;
  setlength(Anim, b+1);
  Anim[b].x:=xn;
  Anim[b].y:=yn;
  with Form1.PaintBox1 do
    Source := Rect(0, 0, Width, Height);
  tmpC.Canvas.CopyRect(Dest, Form1.PaintBox1.Canvas, Source);
  tmp:=tmpC;
  Form1.Timer1.Enabled:=True;
  for i:=0 to b-60 do
  begin
    sleep(100);
    buf.Canvas.Draw(0, 0, tmp);
    CircleB(Anim[i].x, Anim[i].x+20, Anim[i].y, Anim[i].y);
    Form1.Paintbox1.Canvas.Rectangle(0,0,Form1.PaintBox1.Width, Form1.PaintBox1.Height);
    Form1.PaintBox1.Canvas.Draw(0, 0, buf);
    //sleep(10);
    //CircleB(Anim[i].x, Anim[i].x+20, Anim[i].y, Anim[i].y);
    //buf.Canvas.Draw(0,0,tmp);
    //Form1.PaintBox1.Canvas.Draw(0,0,buf);
    //buf.Canvas.Rectangle(0,0,Form1.PaintBox1.Width, Form1.PaintBox1.Height);
    //tmp:=tmpC;
  end;
  Form1.Timer1.Enabled:=False;
end;

procedure TForm1.FormCreate(Sender: TObject);

begin
  m:=0;
  Form1.PaintBox1.Canvas.Brush.Color:=clMenu;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Bezie;
  m:=0;
  setlength(P, m+1);
  Form1.Button1.Enabled:=False;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.Button1.Enabled:=False;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, 1303, 984);
  m:=0;
  setlength(P, m+1);
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin
  setlength(P, m+1);
  P[m].x:=X;
  P[m].y:=Y;
  if m>=1 then
  begin
    Form1.Button1.Enabled:=True;
    if Form1.SimpleLine.Checked then Simple(P[m].x, P[m-1].x, P[m].y, P[m-1].y);
    if Form1.BV4Line.Checked then BV4(P[m].x, P[m-1].x, P[m].y, P[m-1].y);
    if Form1.BV8Line.Checked then BV8(P[m].x, P[m-1].x, P[m].y, P[m-1].y);
  end;
  m+=1;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Form1.Caption:='Лаба 1 | X: ' + inttostr(X) + ' Y: ' + inttostr(Y);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Form1.PaintBox1.Canvas.Draw(0, 0, tmp);;
end;

end.

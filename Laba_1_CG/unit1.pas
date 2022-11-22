unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  math;

type

  { TForm1 }

  TForm1 = class(TForm)
    sec: TCheckBox;
    ClearButt: TButton;
    Panel1: TPanel;
    SimpleButt: TRadioButton;
    BV4Butt: TRadioButton;
    BV8Butt: TRadioButton;
    CircleButt: TRadioButton;
    CircleBButt: TRadioButton;
    procedure CircleBButtChange(Sender: TObject);
    procedure ClearButtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  Form1: TForm1;
  cntr, x1, x2, y1, y2, i, dx, dy, e: integer;
  m: double;
  l: boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  cntr:=0;
  l:=false;
end;

procedure TForm1.CircleBButtChange(Sender: TObject);
begin

end;

procedure TForm1.ClearButtClick(Sender: TObject);
begin
  Form1.Canvas.FillRect(0, 0, Form1.Width, Form1.Height);
end;

procedure swap(var x, y: integer);

var tmp: integer;

begin
  tmp:=x;
  x:=y;
  y:=tmp;
end;

procedure Simple(x1,x2,y1,y2: integer);

var x, y: real;

begin
  if x1 <> x2 then
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
        Form1.Canvas.DrawPixel(round(x), i, TColorToFPColor(clRed));
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
        Form1.Canvas.DrawPixel(i, round(y), TColorToFPColor(clRed));
        y+=m;
      end;
    end;
  end
  else
  begin
    if y1<>y2 then
      Form1.Canvas.DrawPixel(x1, y1, TColorToFPColor(clRed))
    else
      ShowMessage('Ошибка!');
  end;
end;

function sign(x: integer): integer;

begin
  if x>=0 then sign:=1 else sign:=-1;
end;

procedure BV8(x1,x2,y1,y2: integer);

var x,y,s1,s2: integer;

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
    Form1.Canvas.DrawPixel(x, y, TcolorToFPColor(clRed));
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
  Form1.Canvas.DrawPixel(x, y, TcolorToFPColor(clRed));
end;

procedure BV4(x1,x2,y1,y2: integer);

var x, y, s1, s2: integer;

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
    Form1.Canvas.DrawPixel(x, y, TColorToFPColor(clRed));
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
  Form1.Canvas.DrawPixel(x, y, TColorToFPColor(clRed));
  end;
end;

procedure CircleB(x1, x2, y1, y2: integer);

var rad, x, y: integer;

begin
  rad:=round(power((power((x2-x1),2) + power((y2-y1),2)),0.5));
  x:=0;
  y:=rad;
  e:=3-2*rad;
  while x<y do
  begin
    with Form1.Canvas do
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
    with Form1.Canvas do
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

procedure Circle(x1, x2, y1, y2: integer);

var rad, oct, x, y: integer;

begin
  rad:=round(power((power((x2-x1),2) + power((y2-y1),2)),0.5));
  oct:=round(rad/(power(2,0.5)));
  for x:=1 to oct do
  begin
    y:=round(power(power(rad,2)-power(x,2),0.5));
    with Form1.Canvas do
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

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if sec.Checked then
  begin
    x1:=X;
    y1:=Y;
  end
  else
  begin
    if cntr>1 then
    begin
      cntr:=0;
      x1:=0;
      x2:=0;
      y1:=0;
      y2:=0;
    end;
    if cntr=0 then
    begin
      x1:=X;
      y1:=Y;
      cntr+=1;
    end
    else
    begin
      x2:=X;
      y2:=Y;
      cntr+=1;
      with Form1.Panel1 do
      begin
        if SimpleButt.Checked=true then Simple(x1,x2,y1,y2);
        if BV4Butt.Checked=true then BV4(x1,x2,y1,y2);
        if BV8Butt.Checked=true then BV8(x1,x2,y1,y2);
        if CircleButt.Checked=true then Circle(x1,x2,y1,y2);
        if CircleBButt.Checked=true then CircleB(x1,x2,y1,y2);
      end;
    end;
  end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Form1.Caption:='Лаба 1 | X: ' + inttostr(X) + ' Y: ' + inttostr(Y) + '          x1: ' + inttostr(x1) + ' y1: ' + inttostr(y1) + ' x2: ' + inttostr(x2) + ' y2: ' + inttostr(y2);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if sec.checked then
  begin
    x2:=X;
    y2:=Y;
    with Form1.Panel1 do
    begin
      if SimpleButt.Checked=true then Simple(x1,x2,y1,y2);
      if BV4Butt.Checked=true then BV4(x1,x2,y1,y2);
      if BV8Butt.Checked=true then BV8(x1,x2,y1,y2);
      if CircleButt.Checked=true then Circle(x1,x2,y1,y2);
      if CircleBButt.Checked=true then CircleB(x1,x2,y1,y2);
    end;
  end;
end;
end.

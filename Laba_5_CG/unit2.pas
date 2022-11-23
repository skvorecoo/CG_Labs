unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

procedure Simple(x1,x2,y1,y2: integer);

procedure BV8(x1,x2,y1,y2: integer);

procedure BV4(x1,x2,y1,y2: integer);

implementation

uses unit1;

procedure swap(var x, y: integer);

var tmp: integer;

begin
  tmp:=x;
  x:=y;
  y:=tmp;
end;

procedure Simple(x1,x2,y1,y2: integer);

var
  x, y, m: real;
  i: integer;

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
  begin
    if y1<>y2 then
      Form1.Canvas.DrawPixel(x1, y1, TColorToFPColor(clRed))
  end;
end;

function sign(x: integer): integer;

begin
  if x>=0 then sign:=1 else sign:=-1;
end;

procedure BV8(x1,x2,y1,y2: integer);

var
  x, y, s1, s2, dx, dy, e, i: integer;
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

procedure BV4(x1,x2,y1,y2: integer);

var
  x, y, s1, s2, dx, dy, e, i: integer;
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

end.


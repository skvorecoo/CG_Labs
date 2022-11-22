unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Unit2;

type

  TCoords = record
    x, y: integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    ClearPaintBoxBtn: TButton;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    procedure ClearPaintBoxBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  i, CountStack, kk: integer;
  Moves, Stack: array of TCoords;

implementation

{$R *.lfm}

procedure Pop(var x, y: integer);

begin
  x:=Stack[CountStack].x;
  y:=Stack[CountStack].y;
  SetLength(Stack, CountStack);
  CountStack-=1;
end;

procedure Push(x, y: integer);

begin
  CountStack+=1;
  SetLength(Stack, CountStack+1);
  Stack[CountStack].x:=x;
  Stack[CountStack].y:=y;
end;

procedure FillFigure();

var
  x, y, xw, xr, xl, xb, j: integer;
  fl: boolean;

begin

  while CountStack > 0 do

  begin

    Pop(x, y);

    Form1.PaintBox1.Canvas.DrawPixel(x, y, TColorToFPColor(clBlack));

    xw:=x; x+=1;

    while Form1.PaintBox1.Canvas.Pixels[x, y] <> clRed do

    begin

      Form1.PaintBox1.Canvas.DrawPixel(x, y, TColorToFPColor(clBlack));
      x+=1;

    end;

    xr:=x-1; x:=xw; x-=1;

    while Form1.PaintBox1.Canvas.Pixels[x, y] <> clRed do

    begin

      Form1.PaintBox1.Canvas.DrawPixel(x, y, TColorToFPColor(clBlack));
      x-=1;

    end;

    xl:=x+1;

    for j:= -1 to 2 do

    if (j = -1) or (j = 2) then

    begin

      X:=xl; y:=y+j;

      while x <= xr do

      begin

        fl:=false;

        while ((Form1.PaintBox1.Canvas.Pixels[x, y] <> clRed) and (Form1.PaintBox1.Canvas.Pixels[x, y]<> clBlack) and (x < xr)) do

        begin

          x+=1;

          if not fl then fl:=true;

        end;

        if fl then

        begin

          if ((Form1.PaintBox1.Canvas.Pixels[x, y] <> clRed) and (Form1.PaintBox1.Canvas.Pixels[x, y] <> clBlack) and (x = xr)) then Push(x, y) else Push(x-1, y);

          fl:=false;

        end;

        xb:=x;

        while ((Form1.PaintBox1.Canvas.Pixels[x, y] = clBlack) or (Form1.PaintBox1.Canvas.Pixels[x, y] = clRed) and (x < xr)) do x+=1;

        if x = xb then x+=1;

      end;

    end

  end;

end;

procedure ClearPaintBox;

begin
  Form1.PaintBox1.Canvas.Brush.Color:=clWhite;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  i:=0;
end;

procedure DrawLine(x, y: integer);

begin
  if i=0 then SetLength(Moves, 1);

  Moves[i].x:=x;
  Moves[i].y:=y;

  if i>0 then BV8(Moves[i].x, Moves[i-1].x, Moves[i].y, Moves[i-1].y);

  i+=1;
  SetLength(Moves, i+2);
end;

{ TForm1 }

procedure TForm1.ClearPaintBoxBtnClick(Sender: TObject);
begin
  ClearPaintBox;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Timer1.Enabled:=True;
  i:=0;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then DrawLine(X, Y);
  if Button = mbRight then
  begin
    i:=0;
    SetLength(Stack, 1);
    CountStack:=0;
    Push(x, y);
    FillFigure();
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Form1.PaintBox1.Canvas.Brush.Color:=clWhite;
  Form1.PaintBox1.Canvas.Rectangle(0, 0, Form1.PaintBox1.Width, Form1.PaintBox1.Height);
  Form1.Timer1.Enabled:=False;
end;

end.


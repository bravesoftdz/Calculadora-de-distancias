unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, Math;

type

  { TFPrinc }

  TFPrinc = class(TForm)
    BCalcular: TButton;
    BSalir: TButton;
    BLimpiar: TButton;
    ECoordX1: TEdit;
    ECoordX2: TEdit;
    ECoordY1: TEdit;
    ECoordY2: TEdit;
    EDist: TEdit;
    ERumbo: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    PBox: TPaintBox;
    SpeedButton1: TSpeedButton;
    procedure BLimpiarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure BCalcularClick(Sender: TObject);
    procedure ECoordX1Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FPrinc: TFPrinc;

const
  Version='v1.0';

implementation

uses Acerca;

{$R *.lfm}

{ TFPrinc }

function Grados(Norte1,Norte2,DistH: double): double;
begin
  if DistH>0 then Result:=RadToDeg(ArcCos(Abs(Norte1-Norte2)/DistH))
             else Result:=0;
end;

{Convierte grados a formato grados/minutos/segundos}
function DecAGrados(Valor: Double): string;
var
  sGrad,sMin,sSeg: string;
  xMin,xSeg: Double;
begin
  xMin:=Frac(Valor)*60;
  xSeg:=Frac(xMin)*60;
  sGrad:=FloatToStr(Trunc(Valor));
  sMin:=FloatToStr(Trunc(xMin));
  sSeg:=FloatToStr(Trunc(xSeg));
  Result:=sGrad+'° '+sMin+''' '+sSeg+'"';
end;

function Sentido(Este1,Norte1,Este2,Norte2: Double): string;
var
  Cad: string;
begin
  if (Norte1<Norte2) and (Este1=Este2) then Cad:='N FRANCO';
  if (Norte1>Norte2) and (Este1=Este2) then Cad:='S FRANCO';
  if (Norte1=Norte2) and (Este1<Este2) then Cad:='E FRANCO';
  if (Norte1=Norte2) and (Este1>Este2) then Cad:='W FRANCO';
  if (Norte1<Norte2) and (Este1<Este2) then Cad:='N - E';
  if (Norte1<Norte2) and (Este1>Este2) then Cad:='N - W';
  if (Norte1>Norte2) and (Este1<Este2) then Cad:='S - E';
  if (Norte1>Norte2) and (Este1>Este2) then Cad:='S - W';
  Result:=Cad;
end;

function DistHoriz(Este1,Norte1,Este2,Norte2: Integer): Double;
begin
  Result:=Sqrt(Sqr(Abs(Este1-Este2))+Sqr(Abs(Norte1-Norte2)));
end;

procedure TFPrinc.BCalcularClick(Sender: TObject);
var
  X1,X2,Y1,Y2,CX,CY,Ancho,Alto,Inv: integer;
  Dist,Prop: Double;
begin
  //se calcula la distancia:
  X1:=StrToInt(ECoordX1.Text);
  X2:=StrToInt(ECoordX2.Text);
  Y1:=StrToInt(ECoordY1.Text);
  Y2:=StrToInt(ECoordY2.Text);
  Dist:=DistHoriz(X1,Y1,X2,Y2);
  EDist.Text:=FormatFloat('#,###0.00',Dist);
  //se calcula y se muestra el rumbo:
  ERumbo.Text:=DecAGrados(Grados(Y1,Y2,Dist))+'  '+Sentido(X1,Y1,X2,Y2);
  //se dibuja la línea:
  PBox.Canvas.Pen.Width:=2;
  Ancho:=Abs(X1-X2);
  Alto:=Abs(Y1-Y2);
  if Ancho>Alto then Prop:=Ancho
                else Prop:=Alto;
  Inv:=PBox.Width-30;
  if Prop<>0 then Prop:=Inv/Prop
             else Prop:=1;
  if X1>X2 then
  begin
    X1:=Round(Ancho*Prop);
    X2:=0;
  end
  else
  begin
    X2:=Round(Ancho*Prop);
    X1:=0;
  end;
  if Y1>Y2 then
  begin
    Y1:=Round(Alto*Prop);
    Y2:=0;
  end
  else
  begin
    Y2:=Round(Alto*Prop);
    Y1:=0;
  end;
  CX:=(PBox.Width-Round(Ancho*Prop)) div 2;  //centra la anchura de la imagen
  CY:=(PBox.Height-Round(Alto*Prop)) div 2;  //centra la altura de la imagen
  PBox.Canvas.Clear;
  //se dibujan los círculos de los extremos y la línea:
  PBox.Canvas.Pen.Color:=clLime;
  PBox.Canvas.Brush.Color:=clLime;
  PBox.Canvas.Ellipse(X1+CX-4,PBox.Width-Y1-CY-4,X1+CX+4,PBox.Width-Y1-CY+4);
  PBox.Canvas.Pen.Color:=clRed;
  PBox.Canvas.Brush.Color:=clRed;
  PBox.Canvas.Ellipse(X2+CX-4,PBox.Width-Y2-CY-4,X2+CX+4,PBox.Width-Y2-CY+4);
  PBox.Canvas.Pen.Color:=clBlack;
  PBox.Canvas.Line(X1+CX,PBox.Width-Y1-CY,X2+CX,PBox.Width-Y2-CY);
  PBox.Canvas.Brush.Color:=clWhite;
  PBox.Canvas.Lock;
end;

procedure TFPrinc.ECoordX1Change(Sender: TObject);
begin
  BCalcular.Enabled:=(ECoordX1.Text<>'') and (ECoordX2.Text>'')
                 and (ECoordY1.Text<>'') and (ECoordY2.Text<>'');
end;

procedure TFPrinc.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);
    Key:=#0;
    if BCalcular.Focused then BCalcular.Click;
  end
end;

procedure TFPrinc.FormShow(Sender: TObject);
begin
  Caption:='Calculadora de distancia entre coordenadas UTM '+Version;
end;

procedure TFPrinc.FormWindowStateChange(Sender: TObject);
begin
  PBox.Repaint;
end;

procedure TFPrinc.SpeedButton1Click(Sender: TObject);
begin
  FAcerca.ShowModal;
end;

procedure TFPrinc.BSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFPrinc.BLimpiarClick(Sender: TObject);
begin
  ECoordX1.Clear;
  ECoordX2.Clear;
  ECoordY1.Clear;
  ECoordY2.Clear;
  ERumbo.Clear;
  PBox.Canvas.Clear;
  EDist.Text:='0,00';
  ECoordX1.SetFocus;
end;

end.

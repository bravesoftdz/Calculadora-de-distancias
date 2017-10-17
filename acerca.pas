unit Acerca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, TplShapesUnit;

type

  { TFAcerca }

  TFAcerca = class(TForm)
    Button1: TButton;
    Image1: TImage;
    LVersion: TLabel;
    LTitulo: TLabel;
    LLeng: TLabel;
    LAutor: TLabel;
    LFecha: TLabel;
    plRoundSquareShape1: TplRoundSquareShape;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FAcerca: TFAcerca;

implementation

{$R *.lfm}

{ TFAcerca }

procedure TFAcerca.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFAcerca.FormShow(Sender: TObject);
begin
  //Color:=$D9FCFF;
  Color:=$FFFCD9;
  LTitulo.Caption:='Calculadora de distancia entre coordenadas UTM';
  LVersion.Caption:='v1.0';
  LLeng.Caption:='Desarrollado en Lazarus v1.6';
  LAutor.Caption:='Autor: Ing. Francisco J. Sáez S.';
  LFecha.Caption:='Calabozo, Guárico (Venezuela), 30 de Abril de 2016.';
end;

end.


program CalcDistCoord;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, pl_shapespak, principal, Acerca
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='Calculadora de Distancia entre Coordenadas';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFPrinc, FPrinc);
  Application.CreateForm(TFAcerca, FAcerca);
  Application.Run;
end.


program Encrypt;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, EncrypUnit;

{$R Encrypt.res}

begin
  if ParamCount > 0 then
  begin
    writeln('"', EncryptJ1(ParamStr(1)), '"');
  end else
  begin
    Application.Initialize;
    Application.CreateForm(TEncrypForm, EncrypForm);
    Application.Run;
  end;
end.


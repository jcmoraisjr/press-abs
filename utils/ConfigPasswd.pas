(*
  AbstractClasses, Password Routines for Configuration Files
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit ConfigPasswd;

{$I abs.inc}

interface

uses
  PressConfig;

type
  TDecryptFnc = class(TPressConfigFunction)
  protected
    function GetValue: string; override;
  end;

function DecryptJ1(const AEntr: string): string;

implementation

uses
  SysUtils, PressUtils;

{ TDecryptFnc }

function TDecryptFnc.GetValue: string;
var
  VAlg, VValue: string;
begin
  Result := '';
  if Params.Count >= 2 then
  begin
    VAlg := Params[0];
    if SameText(VAlg, 'j1') then
    begin
      VValue := PressUnquotedStr(Params[1]);
      Result := DecryptJ1(VValue);
    end;
  end;
end;

function DecryptJ1(const AEntr: string): string;

  function HexToDec(APos: Integer; AChar: Char): Byte;
  begin
    case AChar of
      '0'..'9': Result := Ord(AChar) - Ord('0');
      'A'..'F': Result := Ord(AChar) + 10 - Ord('A');
      'a'..'f': Result := Ord(AChar) + 10 - Ord('a');
      else Result := 0;
    end;
    Result := ((7 * APos + Result) xor $A) mod $10;
  end;

var
  I: Integer;
begin
  SetLength(Result, Length(AEntr) div 2);
  for I := 1 to Length(Result) do
    Result[I] := Chr($10 * HexToDec(I, AEntr[2 * I - 1]) + HexToDec(I, AEntr[2 * I]));
end;

initialization
  TDecryptFnc.RegisterFunction('Decrypt');

end.

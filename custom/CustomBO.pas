(*
  AbstractClasses, Custom Business Objects
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomBO;

{$I abs.inc}

interface

uses
  PressClasses,
  PressSubject,
  PressAttributes,
  CustomClasses;

type
  TCustomObject = class(TPressObject)
  protected
    function InternalReadMethod(AAttr: TPressAttribute; const AMethodName: string; AParams: TPressStringArray): Variant; override;
  end;

  TCustomQuery = class(TPressQuery)
  end;

  TCustomParts = class(TPressParts)
  end;

  TCustomReferences = class(TPressReferences)
  end;

  TCNPJCPFString = class(TPressPlainString)
  protected
    function GetDisplayText: string; override;
    procedure SetValue(const AValue: string); override;
  end;

  TFoneString = class(TPressPlainString)
  protected
    function GetDisplayText: string; override;
  end;

  TPontoString = class(TPressPlainString)
  protected
    function GetDisplayText: string; override;
  end;

  TTempoHHMM = class(TPressTime)
  protected
    function GetAsString: string; override;
    procedure SetAsString(const AValue: string); override;
  end;

implementation

uses
  SysUtils, CustomConsts;

{ TCustomObject }

function TCustomObject.InternalReadMethod(AAttr: TPressAttribute;
  const AMethodName: string; AParams: TPressStringArray): Variant;
begin
  if Assigned(AAttr) and (Length(AParams) = 0) and
   SameText(AMethodName, 'Extenso') and (AAttr is TPressNumeric) then
    Result := Extenso(AAttr.AsFloat)
  else
    Result := inherited InternalReadMethod(AAttr, AMethodName, AParams);
end;

{ TCNPJCPFString }

function TCNPJCPFString.GetDisplayText: string;

  procedure FormatCNPJ(var Result: string);
  begin
    Insert('.', Result, 3);
    Insert('.', Result, 7);
    Insert('/', Result, 11);
    Insert('-', Result, 16);
  end;

  procedure FormatCPF(var Result: string);
  begin
    Insert('.', Result, 4);
    Insert('.', Result, 8);
    Insert('-', Result, 12);
  end;

begin
  Result := Value;
  if ValidateChars(Result, ['0'..'9']) then
    if Length(Result) = 11 then
      FormatCPF(Result)
    else if Length(Result) = 14 then
      FormatCNPJ(Result);
end;

procedure TCNPJCPFString.SetValue(const AValue: string);

  procedure ValidateCNPJ(const ACNPJ: string);

    function CheckCNPJ(const ACNPJ: string): Boolean;
    var
      Soma, Dg1, Dg2: integer;
    begin
      if Length(ACNPJ)<>14 then
      begin
        CheckCNPJ := False;
        Exit;
      end;
      Soma := 0;
      Inc(Soma, (Ord(ACNPJ[01]) - $30) * 5);
      Inc(Soma, (Ord(ACNPJ[02]) - $30) * 4);
      Inc(Soma, (Ord(ACNPJ[03]) - $30) * 3);
      Inc(Soma, (Ord(ACNPJ[04]) - $30) * 2);
      Inc(Soma, (Ord(ACNPJ[05]) - $30) * 9);
      Inc(Soma, (Ord(ACNPJ[06]) - $30) * 8);
      Inc(Soma, (Ord(ACNPJ[07]) - $30) * 7);
      Inc(Soma, (Ord(ACNPJ[08]) - $30) * 6);
      Inc(Soma, (Ord(ACNPJ[09]) - $30) * 5);
      Inc(Soma, (Ord(ACNPJ[10]) - $30) * 4);
      Inc(Soma, (Ord(ACNPJ[11]) - $30) * 3);
      Inc(Soma, (Ord(ACNPJ[12]) - $30) * 2);
      Dg1 := 11 - (Soma mod 11);
      if Dg1 >= 10 then
        Dg1 := 0;
      Soma := 0;
      Inc(Soma, (Ord(ACNPJ[01]) - $30) * 6);
      Inc(Soma, (Ord(ACNPJ[02]) - $30) * 5);
      Inc(Soma, (Ord(ACNPJ[03]) - $30) * 4);
      Inc(Soma, (Ord(ACNPJ[04]) - $30) * 3);
      Inc(Soma, (Ord(ACNPJ[05]) - $30) * 2);
      Inc(Soma, (Ord(ACNPJ[06]) - $30) * 9);
      Inc(Soma, (Ord(ACNPJ[07]) - $30) * 8);
      Inc(Soma, (Ord(ACNPJ[08]) - $30) * 7);
      Inc(Soma, (Ord(ACNPJ[09]) - $30) * 6);
      Inc(Soma, (Ord(ACNPJ[10]) - $30) * 5);
      Inc(Soma, (Ord(ACNPJ[11]) - $30) * 4);
      Inc(Soma, (Ord(ACNPJ[12]) - $30) * 3);
      Inc(Soma, 2 * Dg1);
      Dg2 := 11 - (Soma mod 11);
      if Dg2 >= 10 then
        Dg2 := 0;
      CheckCNPJ := (ACNPJ[13] = Chr(Dg1 + $30)) and (ACNPJ[14] = Chr(Dg2 + $30));
    end;

  begin
    if not CheckCNPJ(ACNPJ) then
      raise ECustomException.CreateFmt(SCustomInvalidCNPJ, [ACNPJ]);
  end;

  procedure ValidateCPF(const ACPF: string);

    function CheckCPF(const ACPF: string): Boolean;
    var
      Soma, Dg1, Dg2: integer;
    begin
      if Length(ACPF) <> 11 then
      begin
        CheckCPF := False;
        Exit;
      end;
      Soma := 0;
      Inc(Soma, (Ord(ACPF[1]) - $30) * 10);
      Inc(Soma, (Ord(ACPF[2]) - $30) * 9);
      Inc(Soma, (Ord(ACPF[3]) - $30) * 8);
      Inc(Soma, (Ord(ACPF[4]) - $30) * 7);
      Inc(Soma, (Ord(ACPF[5]) - $30) * 6);
      Inc(Soma, (Ord(ACPF[6]) - $30) * 5);
      Inc(Soma, (Ord(ACPF[7]) - $30) * 4);
      Inc(Soma, (Ord(ACPF[8]) - $30) * 3);
      Inc(Soma, (Ord(ACPF[9]) - $30) * 2);
      Dg1 := 11 - (Soma mod 11);
      if Dg1 >= 10 then
        Dg1 := 0;
      Soma := 0;
      Inc(Soma, (Ord(ACPF[1]) - $30) * 11);
      Inc(Soma, (Ord(ACPF[2]) - $30) * 10);
      Inc(Soma, (Ord(ACPF[3]) - $30) * 9);
      Inc(Soma, (Ord(ACPF[4]) - $30) * 8);
      Inc(Soma, (Ord(ACPF[5]) - $30) * 7);
      Inc(Soma, (Ord(ACPF[6]) - $30) * 6);
      Inc(Soma, (Ord(ACPF[7]) - $30) * 5);
      Inc(Soma, (Ord(ACPF[8]) - $30) * 4);
      Inc(Soma, (Ord(ACPF[9]) - $30) * 3);
      Inc(Soma, (2 * Dg1));
      Dg2 := 11 - (Soma mod 11);
      if Dg2 >= 10 then
        Dg2 := 0;
      CheckCPF := (ACPF[10] = Chr(Dg1 + $30)) and (ACPF[11] = Chr(Dg2 + $30));
    end;

  begin
    if not CheckCPF(ACPF) then
      raise ECustomException.CreateFmt(SCustomInvalidCPF, [ACPF]);
  end;

begin
  if not ChangesDisabled then
    if Length(AValue) = 11 then
      ValidateCPF(AValue)
    else if Length(AValue) = 14 then
      ValidateCNPJ(AValue)
    else if AValue <> '' then
      raise ECustomException.CreateFmt(SCustomInvalidCNPJorCPF, [AValue]);
  inherited;
end;

{ TFoneString }

function TFoneString.GetDisplayText: string;

  procedure Format6(var Result: string);
  begin
    Insert('-', Result, 3);
  end;

  procedure Format7(var Result: string);
  begin
    Insert('-', Result, 4);
  end;

  procedure Format8(var Result: string);
  begin
    Insert('-', Result, 5);
  end;

  procedure Format9(var Result: string);
  begin
    Insert('(', Result, 1);
    Insert(') ', Result, 4);
    Insert('-', Result, 9);
  end;

  procedure Format10(var Result: string);
  begin
    Insert('(', Result, 1);
    if Result[2] = '0' then
      Insert(') ', Result, 5)
    else
      Insert(') ', Result, 4);
    Insert('-', Result, 10);
  end;

  procedure Format11(var Result: string);
  begin
    Insert('(', Result, 1);
    Insert(') ', Result, 5);
    Insert('-', Result, 11);
  end;

begin
  Result := Value;
  if ValidateChars(Result, ['0'..'9']) then
    if Length(Result) = 6 then
      Format6(Result)
    else if Length(Result) = 7 then
      Format7(Result)
    else if Length(Result) = 8 then
      Format8(Result)
    else if Length(Result) = 9 then
      Format9(Result)
    else if Length(Result) = 10 then
      Format10(Result)
    else if Length(Result) = 11 then
      Format11(Result);
end;

{ TPontoString }

function TPontoString.GetDisplayText: string;

  procedure FormatPonto(var Result: string);
  var
    I: Integer;
  begin
    I := Length(Result) - 2;
    while I > 1 do
    begin
      Insert('.', Result, I);
      Dec(I, 3);
    end;
  end;

begin
  Result := Value;
  if ValidateChars(Result, ['0'..'9']) then
    FormatPonto(Result);
end;

{ TTempoHHMM }

function TTempoHHMM.GetAsString: string;
begin
  if not IsEmpty then
    Result := FormatDateTime('hh:nn', Value)
  else
    Result := '';
end;

procedure TTempoHHMM.SetAsString(const AValue: string);
var
  VNum, VError: Integer;
begin
  if Pos(':', AValue) > 0 then
    inherited SetAsString(AValue)
  else
  begin
    Val(AValue, VNum, VError);
    if VError = 0 then
      Value := VNum / 60 / 24
    else
      Clear;
  end;
end;

initialization
  TCustomObject.RegisterClass;
  TCustomQuery.RegisterClass;
  TCNPJCPFString.RegisterAttribute;
  TFoneString.RegisterAttribute;
  TPontoString.RegisterAttribute;
  TTempoHHMM.RegisterAttribute;

finalization
  TCustomObject.UnregisterClass;
  TCustomQuery.UnregisterClass;
  TCNPJCPFString.UnregisterAttribute;
  TFoneString.UnregisterAttribute;
  TPontoString.UnregisterAttribute;
  TTempoHHMM.UnregisterAttribute;

end.

(*
  AbstractClasses, OPF Customization for Interbase and Firebird
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit OPFIBFbBroker;

{$I abs.inc}

interface

uses
  PressOPFStorage, PressIBFbBroker;

type
  TOPFIBFbDDLBuilder = class(TPressIBFbDDLBuilder)
  public
    function CreateFieldStatement(AFieldMetadata: TPressOPFFieldMetadata): string; override;
  end;

implementation

uses
  PressSubject;

{ TOPFIBFbDDLBuilder }

function TOPFIBFbDDLBuilder.CreateFieldStatement(
  AFieldMetadata: TPressOPFFieldMetadata): string;
begin
  Result := inherited CreateFieldStatement(AFieldMetadata);
  if AFieldMetadata.DataType in [attAnsiString, attMemo] then
    Result := Result + ' character set iso8859_1 collate pt_br';
end;

end.

(*
  AbstractClasses, OPF Customization for Zeos
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit OPFZeosBroker;

{$I abs.inc}

interface

uses
  PressOPFMapper, PressOPFSQLBuilder, PressZeosBroker;

type
  TOPFZeosBroker = class(TPressZeosBroker)
  protected
    function InternalMapperClass: TPressOPFObjectMapperClass; override;
  end;

  TOPFZeosMapper = class(TPressZeosObjectMapper)
  protected
    function InternalDDLBuilderClass: TPressOPFDDLBuilderClass; override;
  end;

implementation

uses
  OPFIBFbBroker;

{ TOPFZeosBroker }

function TOPFZeosBroker.InternalMapperClass: TPressOPFObjectMapperClass;
begin
  Result := TOPFZeosMapper;
end;

{ TOPFZeosMapper }

function TOPFZeosMapper.InternalDDLBuilderClass: TPressOPFDDLBuilderClass;
begin
  Result := TOPFIBFbDDLBuilder;
end;

initialization
  TOPFZeosBroker.RegisterService;

finalization
  TOPFZeosBroker.UnregisterService;

end.

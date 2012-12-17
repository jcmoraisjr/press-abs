(*
  AbstractClasses, OPF Customization for SQLdb
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit OPFSQLdbBroker;

{$I abs.inc}

interface

uses
  PressOPFMapper, PressOPFSQLBuilder, PressSQLdbBroker;

type
  TOPFSQLdbBroker = class(TPressSQLdbBroker)
  protected
    function InternalMapperClass: TPressOPFObjectMapperClass; override;
  end;

  TOPFSQLdbMapper = class(TPressSQLdbObjectMapper)
  protected
    function InternalDDLBuilderClass: TPressOPFDDLBuilderClass; override;
  end;

implementation

uses
  PressIBFbBroker,
  OPFIBFbBroker;

{ TOPFSQLdbBroker }

function TOPFSQLdbBroker.InternalMapperClass: TPressOPFObjectMapperClass;
begin
  Result := TOPFSQLdbMapper;
end;

{ TOPFSQLdbMapper }

function TOPFSQLdbMapper.InternalDDLBuilderClass: TPressOPFDDLBuilderClass;
begin
  Result := inherited InternalDDLBuilderClass;
  if Result = TPressIBFbDDLBuilder then
    Result := TOPFIBFbDDLBuilder;
end;

initialization
  TOPFSQLdbBroker.RegisterService;

finalization
  TOPFSQLdbBroker.UnregisterService;

end.

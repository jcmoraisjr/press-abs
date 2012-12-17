(*
  AbstractClasses, OPF Customization for FBLib
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit OPFFBLibBroker;

{$I abs.inc}

interface

uses
  PressOPFMapper, PressOPFSQLBuilder, PressFBLibBroker;

type
  TOPFFBLibBroker = class(TPressFBLibBroker)
  protected
    function InternalMapperClass: TPressOPFObjectMapperClass; override;
  end;

  TOPFFBLibMapper = class(TPressFBLibObjectMapper)
  protected
    function InternalDDLBuilderClass: TPressOPFDDLBuilderClass; override;
  end;

implementation

uses
  OPFIBFbBroker;

{ TOPFFBLibBroker }

function TOPFFBLibBroker.InternalMapperClass: TPressOPFObjectMapperClass;
begin
  Result := TOPFFBLibMapper;
end;

{ TOPFFBLibMapper }

function TOPFFBLibMapper.InternalDDLBuilderClass: TPressOPFDDLBuilderClass;
begin
  Result := TOPFIBFbDDLBuilder;
end;

initialization
  TOPFFBLibBroker.RegisterService;

finalization
  TOPFFBLibBroker.UnregisterService;

end.

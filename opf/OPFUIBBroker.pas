(*
  AbstractClasses, OPF Customization for UIB
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit OPFUIBBroker;

{$I abs.inc}

interface

uses
  PressOPFMapper, PressOPFSQLBuilder, PressUIBBroker;

type
  TOPFUIBBroker = class(TPressUIBBroker)
  protected
    function InternalMapperClass: TPressOPFObjectMapperClass; override;
  end;

  TOPFUIBMapper = class(TPressUIBObjectMapper)
  protected
    function InternalDDLBuilderClass: TPressOPFDDLBuilderClass; override;
  end;

implementation

uses
  OPFIBFbBroker;

{ TOPFUIBBroker }

function TOPFUIBBroker.InternalMapperClass: TPressOPFObjectMapperClass;
begin
  Result := TOPFUIBMapper;
end;

{ TOPFUIBMapper }

function TOPFUIBMapper.InternalDDLBuilderClass: TPressOPFDDLBuilderClass;
begin
  Result := TOPFIBFbDDLBuilder;
end;

initialization
  TOPFUIBBroker.RegisterService;

finalization
  TOPFUIBBroker.UnregisterService;

end.

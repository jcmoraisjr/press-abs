(*
  AbstractClasses, Business Objects for authentication and Authorization
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit UserBO;

{$I abs.inc}

interface

uses
  PressUserModel;

type

(*
  Declarar na aplicação:

  type
    TAppResource = (...);

  initialization
    PressModel.RegisterEnumMetadata(TypeInfo(TAppResource),
     'TPressAppResource', ['...']);


  O ResourceId do gerenciador de relatório pode ser opcionalmente setado:

  uses
    CustomMVP;

  initialization
    GReportResourceId := Ord(ReportEnumValue);
*)

  TUserData = class(TPressUserData)
  protected
    function InternalHash(const AEntry: string): string; override;
  end;

implementation

uses
  PressSubject, PressUser, md5;

{ TUserData }

function TUserData.InternalHash(const AEntry: string): string;
begin
  Result := MD5Print(MD5String(AEntry));
end;

initialization
  TUserData.RegisterService(True);

end.

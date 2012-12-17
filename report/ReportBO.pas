(*
  AbstractClasses, Business Objects for Reports
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit ReportBO;

{$I abs.inc}

interface

uses
  Classes,
  PressSubject,
  PressAttributes,
  PressUserModel,
  PressReport;

type
  TReportGroup = class(TPressCustomReportGroup)
    _ObjectClassName: TPressPlainString;
    _Reports: TPressParts;
  private
    function GetObjectClassName: string;
  protected
    function InternalCreateReportItemIterator: TPressItemsIterator; override;
    class function InternalMetadataStr: string; override;
  public
    class function ObjectClassAttributeName: string; override;
    property ObjectClassName: string read GetObjectClassName;
  end;

  TReportItem = class(TPressCustomReportItem)
    _Caption: TPressAnsiString;
    _UserGroups: TPressUserGroupReferences;
    _Visible: TPressBoolean;
    _Formula: TPressAnsiString;
    _ReportMetadata: TPressBinary;
  private
    FBO: TPressObject;
    function GetBO: TPressObject;
    function GetFormula: string;
    procedure SetFormula(const Value: string);
  protected
    procedure Finit; override;
    function GetReportCaption: string; override;
    procedure GetReportData(AStream: TStream); override;
    function GetReportVisible: Boolean; override;
    class function InternalMetadataStr: string; override;
    procedure SetReportData(AStream: TStream); override;
    property BO: TPressObject read GetBO;
  public
    property UserGroups: TPressUserGroupReferences read _UserGroups;
  published
    property Formula: string read GetFormula write SetFormula;
  end;

  TReportData = class(TPressCustomReportData)
  protected
    function InternalReportGroupClass: TPressReportGroupClass; override;
  end;

implementation

uses
  SysUtils,
{$ifndef ver130}
  Variants,
{$endif}
  PressClasses,
  PressConsts,
  PressUser;

{ TReportGroup }

function TReportGroup.GetObjectClassName: string;
begin
  Result := _ObjectClassName.Value;
end;

function TReportGroup.InternalCreateReportItemIterator: TPressItemsIterator;
begin
  Result := _Reports.CreateIterator;
end;

class function TReportGroup.InternalMetadataStr: string;
begin
  Result := 'TReportGroup PersistentName="TRepGrp" ('+
   'ObjectClassName: PlainString(32);' +
   'Reports: Parts(TReportItem);' +
   ')';
end;

class function TReportGroup.ObjectClassAttributeName: string;
begin
  Result := 'ObjectClassName';
end;

{ TReportItem }

procedure TReportItem.Finit;
begin
  FBO.Free;
  inherited;
end;

function TReportItem.GetBO: TPressObject;
begin
  if not Assigned(FBO) then
    FBO := PressModel.ClassByName((Owner as TReportGroup).ObjectClassName).Create;
  Result := FBO;
end;

function TReportItem.GetFormula: string;
begin
  Result := _Formula.Value;
end;

function TReportItem.GetReportCaption: string;
begin
  Result := _Caption.Value;
end;

procedure TReportItem.GetReportData(AStream: TStream);
begin
  _ReportMetadata.SaveToStream(AStream);
end;

function TReportItem.GetReportVisible: Boolean;

  function UsuarioTemPrivilegio: Boolean;

    function UsuarioTemGrupo(AUserGroups: TPressUserGroupReferences; AGrupo: TPressUserGroup): Boolean;
    var
      I: Integer;
    begin
      Result := True;
      for I := 0 to Pred(AUserGroups.Count) do
        if AUserGroups[I] = AGrupo then
          Exit;
      Result := False;
    end;

    function UsuarioAtual: TPressUser;
    var
      VUserData: TPressCustomUserData;
    begin
      VUserData := PressUserData;
      if VUserData is TPressUserData and VUserData.HasUser and
       (VUserData.CurrentUser is TPressUser) then
        Result := TPressUser(VUserData.CurrentUser)
      else
        Result := nil;
    end;

  var
    VUser: TPressUser;
    I: Integer;
  begin
    Result := True;
    VUser := UsuarioAtual;
    if Assigned(VUser) then
    begin
      if VUser.UserId = SPressUserAdminId then
        Exit;
      for I := 0 to Pred(UserGroups.Count) do
        if UsuarioTemGrupo(VUser.UserGroups, UserGroups[I]) then
          Exit;
    end;
    Result := False;
  end;

begin
  Result := _Visible.Value and UsuarioTemPrivilegio;
end;

class function TReportItem.InternalMetadataStr: string;
begin
  Result := 'TReportItem PersistentName="TRepItem" (' +
   'Caption: AnsiString(40);' +
   'UserGroups: TPressUserGroupReferences PersistentName="UserGrp";' +
   'Visible: Boolean DefaultValue=True;' +
   'Formula: AnsiString(1024);' +
   'ReportMetadata: Binary;' +
   ')';
end;

procedure TReportItem.SetFormula(const Value: string);
var
  VValue: Variant;
begin
  try
    if Value <> '' then
      VValue := BO.Expression(Value)
    else
      VValue := False;
  except
    on E: EPressParseError do
      VValue := 0
    else
      raise;
  end;
  if VarType(VValue) <> varBoolean then
    raise Exception.CreateFmt('''%s'' não é uma expressão lógica válida.', [Value]);
  _Formula.Value := Value;
end;

procedure TReportItem.SetReportData(AStream: TStream);
begin
  _ReportMetadata.LoadFromStream(AStream);
end;

{ TPressReportData }

function TReportData.InternalReportGroupClass: TPressReportGroupClass;
begin
  Result := TReportGroup;
end;

initialization
  TReportGroup.RegisterClass;
  TReportItem.RegisterClass;
  TReportData.RegisterService;

finalization
  TReportGroup.UnregisterClass;
  TReportItem.UnregisterClass;
  TReportData.UnregisterService;

end.

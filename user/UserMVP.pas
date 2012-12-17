(*
  AbstractClasses, MVP Classes for Authentication and Authorization
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit UserMVP;

{$I abs.inc}

interface

uses
  Classes, PressClasses, PressNotifier, PressUserModel,
  PressMVP, PressMVPModel, PressMVPPresenter, PressMVPCommand, CustomMVP;

type
  TUserEditPresenter = class(TCustomEditPresenter)
  protected
    procedure InitPresenter; override;
  end;

  TUserChangePasswordCommand = class(TPressMVPObjectCommand)
  protected
    function GetCaption: string; override;
    procedure InternalExecute; override;
  end;

  TUserQueryPresenter = class(TCustomQueryPresenter)
  protected
    procedure InitPresenter; override;
    function InternalQueryItemsDisplayNames: string; override;
  end;

  TUserGroupEditPresenter = class(TCustomEditPresenter)
  protected
    procedure InitPresenter; override;
  end;

  TUserGroupQueryPresenter = class(TCustomTinyQueryPresenter)
  protected
    procedure InitPresenter; override;
    function InternalQueryItemsDisplayNames: string; override;
  end;

  TUserGroupSearchPresenter = class(TCustomSearchPresenter)
  protected
    procedure InitPresenter; override;
    function InternalQueryItemsDisplayNames: string; override;
  end;

  TUserGroupResourceEditPresenter = class(TCustomEditPresenter)
  protected
    procedure InitPresenter; override;
  end;

  TUserLogonPresenter = class(TPressMVPFormPresenter)
  private
    FNotifier: IPressHolder;  // TPressNotifier
    procedure Notify(AEvent: TPressEvent);
  protected
    procedure InitPresenter; override;
  end;

  TUserChangePasswordEditPresenter = class(TPressMVPFormPresenter)
  protected
    procedure InitPresenter; override;
  public
    class procedure Execute(AUser: TPressUser; AForceChange: Boolean);
  end;

  TUserLogoffCommand = class(TPressMVPCommand)
  protected
    procedure InternalExecute; override;
  end;

implementation

uses
  PressUser;

{ TUserEditPresenter }

procedure TUserEditPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('UserName', 'NomeEdit');
  CreateSubPresenter('UserId', 'UserIdEdit');
  CreateSubPresenter('PasswordExpired', 'ExpirarSenhaCheckBox');
  CreateSubPresenter('UserGroups', 'GruposStringGrid', 'GroupName');
  Model.InsertCommand(0, TUserChangePasswordCommand);
  BindCommand(TUserChangePasswordCommand, 'AlterarSenhaSpeedButton');
end;

{ TUserChangePasswordCommand }

function TUserChangePasswordCommand.GetCaption: string;
begin
  Result := 'Alterar senha';
end;

procedure TUserChangePasswordCommand.InternalExecute;
var
  VUser: TPressUser;
begin
  inherited;
  VUser := Model.Subject as TPressUser;
  TUserChangePasswordEditPresenter.Execute(VUser, True);
end;

{ TUserQueryPresenter }

procedure TUserQueryPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('UserName', 'NomeEdit');
end;

function TUserQueryPresenter.InternalQueryItemsDisplayNames: string;
begin
  Result := 'UserName;UserId';
end;

{ TUserGroupEditPresenter }

procedure TUserGroupEditPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('GroupName', 'NomeEdit');
  CreateSubPresenter('GroupResources', 'AcessosStringGrid', 'ResourceId;AccessMode');
end;

{ TUserGroupQueryPresenter }

procedure TUserGroupQueryPresenter.InitPresenter;
begin
  inherited;
end;

function TUserGroupQueryPresenter.InternalQueryItemsDisplayNames: string;
begin
  Result := 'GroupName';
end;

{ TUserGroupSearchPresenter }

procedure TUserGroupSearchPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('GroupName', 'SearchStringEdit');
end;

function TUserGroupSearchPresenter.InternalQueryItemsDisplayNames: string;
begin
  Result := 'GroupName';
end;

{ TUserGroupResourceEditPresenter }

procedure TUserGroupResourceEditPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('ResourceId', 'TipoAcessoComboBox').View.ReadOnly := True;
  CreateSubPresenter('AccessMode', 'ModoAcessoComboBox');
end;

{ TUserLogonPresenter }

procedure TUserLogonPresenter.InitPresenter;
begin
  inherited;
  FNotifier := TPressHolder.Create(TPressNotifier.Create({$ifdef fpc}@{$endif}Notify));
  TPressNotifier(FNotifier.Instance).AddNotificationItem(
   nil, [TPressUserLogonEvent]);
  CreateSubPresenter('UserId', 'UserIDEdit');
  CreateSubPresenter('Password', 'SenhaEdit');
  BindCommand(TPressMVPSaveObjectCommand, 'OkButton');
  BindCommand(TPressMVPCancelObjectCommand, 'CancelButton');
end;

procedure TUserLogonPresenter.Notify(AEvent: TPressEvent);
begin
  if AEvent is TPressUserLogonEvent then
    TUserChangePasswordEditPresenter.Execute(nil, False);
end;

{ TUserChangePasswordEditPresenter }

class procedure TUserChangePasswordEditPresenter.Execute(
  AUser: TPressUser; AForceChange: Boolean);
var
  VUserData: TPressCustomUserData;
  VChangePassword: TPressChangePassword;
begin
  if not Assigned(AUser) then
  begin
    VUserData := PressUserData;
    if VUserData.HasUser and (VUserData.CurrentUser is TPressUser) then
      AUser := TPressUser(VUserData.CurrentUser);
  end;
  if Assigned(AUser) and (AForceChange or AUser.PasswordExpired) then
  begin
    VChangePassword := TPressChangePassword.Create;
    try
      AUser.PasswordExpired := True;
      VChangePassword.User := AUser;
      VChangePassword.StoreUser := not AForceChange;
      VChangePassword.UpdatePasswordExpired := not AForceChange;
      Run(VChangePassword);
    finally
      VChangePassword.Free;
    end;
  end;
end;

procedure TUserChangePasswordEditPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('Password1', 'Senha1Edit');
  CreateSubPresenter('Password2', 'Senha2Edit');
  BindCommand(TPressMVPSaveObjectCommand, 'OKButton');
  BindCommand(TPressMVPCancelObjectCommand, 'CancelarButton');
end;

{ TUserLogoffCommand }

procedure TUserLogoffCommand.InternalExecute;
begin
  inherited;
  PressUserData.Logoff;
end;

initialization
  TUserEditPresenter.RegisterBO(TPressUser);
  TUserQueryPresenter.RegisterBO(TPressUserQuery);
  TUserGroupEditPresenter.RegisterBO(TPressUserGroup);
  TUserGroupQueryPresenter.RegisterBO(TPressUserGroupQuery);
  TUserGroupSearchPresenter.RegisterBO(TPressUserGroupQuery, [fpQuery]);
  TUserGroupResourceEditPresenter.RegisterBO(TPressUserGroupResource, [fpExisting]);
  TUserLogonPresenter.RegisterBO(TPressLogon);
  TUserChangePasswordEditPresenter.RegisterBO(TPressChangePassword);

end.

(*
  AbstractClasses, Authentication and Authorization, Change Password Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit UserChangePasswordEditFrm;

{$I abs.inc}

interface

uses
  Forms, Classes, Controls, StdCtrls;

type
  TUserChangePasswordEditForm = class(TForm)
    Senha1Label: TLabel;
    Senha1Edit: TEdit;
    Senha2Edit: TEdit;
    Senha2Label: TLabel;
    OKButton: TButton;
    CancelarButton: TButton;
  end;

implementation

uses
  PressXCLBroker, UserMVP;

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

initialization
  PressXCLForm(TUserChangePasswordEditPresenter, TUserChangePasswordEditForm);

end.

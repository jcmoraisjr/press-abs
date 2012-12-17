(*
  AbstractClasses, Authentication and Authorization, Resource Edit Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit UserGroupResourceEditFrm;

{$I abs.inc}

interface

uses
  CustomEditFrm, Classes, Controls, StdCtrls, ExtCtrls;

type
  TUserGroupResourceEditForm = class(TCustomEditForm)
    TipoAcessoLabel: TLabel;
    TipoAcessoComboBox: TComboBox;
    ModoAcessoLabel: TLabel;
    ModoAcessoComboBox: TComboBox;
  end;

implementation

uses
  PressXCLBroker, UserMVP;

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

initialization
  PressXCLForm(TUserGroupResourceEditPresenter, TUserGroupResourceEditForm);

end.

(*
  AbstractClasses, Authentication and Authorization, Logon Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit UserLogonFrm;

{$I abs.inc}

interface

uses
  Forms, Classes, Controls, StdCtrls;

type
  TUserLogonForm = class(TForm)
    LogonLabel: TLabel;
    UserIDEdit: TEdit;
    SenhaLabel: TLabel;
    SenhaEdit: TEdit;
    OkButton: TButton;
    CancelButton: TButton;
  end;

implementation

uses
  PressXCLBroker, UserMVP;

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

initialization
  PressXCLForm(TUserLogonPresenter, TUserLogonForm);

end.

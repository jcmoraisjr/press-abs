(*
  AbstractClasses, Authentication and Authorization, User Query Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit UserQueryFrm;

{$I abs.inc}

interface

uses
  CustomQueryFrm, Classes, Controls, StdCtrls, ExtCtrls, Buttons, Grids;

type
  TUserQueryForm = class(TCustomQueryForm)
    NomeEdit: TEdit;
  end;

implementation

uses
  PressXCLBroker, UserMVP;

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

initialization
  PressXCLForm(TUserQueryPresenter, TUserQueryForm);

end.

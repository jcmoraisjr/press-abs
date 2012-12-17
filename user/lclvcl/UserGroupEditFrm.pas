(*
  AbstractClasses, Authentication and Authorization, Group Edit Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit UserGroupEditFrm;

{$I abs.inc}

interface

uses
  CustomEditFrm, Classes, Controls, StdCtrls, ExtCtrls, Grids;

type
  TUserGroupEditForm = class(TCustomEditForm)
    NomeLabel: TLabel;
    NomeEdit: TEdit;
    AcessosGroupBox: TGroupBox;
    AcessosStringGrid: TStringGrid;
  end;

implementation

uses
  PressXCLBroker, UserMVP;

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

initialization
  PressXCLForm(TUserGroupEditPresenter, TUserGroupEditForm);

end.

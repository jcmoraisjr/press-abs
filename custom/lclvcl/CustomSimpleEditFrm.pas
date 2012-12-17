(*
  AbstractClasses, Custom Simple Edit Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomSimpleEditFrm;

{$I abs.inc}

interface

uses
  CustomEditFrm, Classes, Controls, StdCtrls, ExtCtrls;

type
  TCustomSimpleEditForm = class(TCustomEditForm)
    NomeGroupBox: TGroupBox;
    NomeLabel: TLabel;
    NomeEdit: TEdit;
  end;

implementation

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

end.

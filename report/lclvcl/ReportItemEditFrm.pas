(*
  AbstractClasses, Report, Item Edit Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit ReportItemEditFrm;

{$I abs.inc}

interface

uses
  CustomEditFrm, Classes, Controls, StdCtrls, ExtCtrls, Buttons, Grids;

type
  TReportItemEditForm = class(TCustomEditForm)
    TituloLabel: TLabel;
    TituloEdit: TEdit;
    GruposUsuarioLabel: TLabel;
    GruposUsuarioStringGrid: TStringGrid;
    VisivelCheckBox: TCheckBox;
    FormulaLabel: TLabel;
    FormulaEdit: TEdit;
  end;

implementation

uses
  PressXCLBroker, ReportMVP;

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

initialization
  PressXCLForm(TReportItemEditPresenter, TReportItemEditForm);

end.

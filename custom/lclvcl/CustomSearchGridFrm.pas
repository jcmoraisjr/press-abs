(*
  AbstractClasses, Custom Search Grid Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomSearchGridFrm;

{$I abs.inc}

interface

uses
  Forms, Classes, Controls, StdCtrls, ExtCtrls, Buttons, Grids;

type

  { TCustomSearchGridForm }

  TCustomSearchGridForm = class(TForm)
    DataPanel: TPanel;
    DataLinePanel: TPanel;
    FecharButton: TButton;
    GridPanel: TPanel;
    BottomPanel: TPanel;
    BottomLinePanel: TPanel;
    QuerySpeedButton: TSpeedButton;
    SearchListBox: TStringGrid;
    SelectButton: TButton;
  end;

implementation

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

end.

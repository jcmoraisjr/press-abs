(*
  AbstractClasses, Custom Query Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomQueryFrm;

{$I abs.inc}

interface

uses
  Forms, Classes, Controls, StdCtrls, ExtCtrls, Buttons, Grids;

type

  { TCustomQueryForm }

  TCustomQueryForm = class(TForm)
    DataPanel: TPanel;
    FecharButton: TButton;
    GridPanel: TPanel;
    QuerySpeedButton: TSpeedButton;
    QueryStringGrid: TStringGrid;
    DataLinePanel: TPanel;
    BottomPanel: TPanel;
    BottomLinePanel: TPanel;
  end;

implementation

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

end.

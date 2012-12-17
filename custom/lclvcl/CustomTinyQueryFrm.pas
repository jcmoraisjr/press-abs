(*
  AbstractClasses, Custom Tiny Query Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomTinyQueryFrm;

{$I abs.inc}

interface

uses
  Forms, Classes, Controls, StdCtrls, ExtCtrls, Grids;

type

  { TCustomTinyQueryForm }

  TCustomTinyQueryForm = class(TForm)
    AtualizarButton: TButton;
    FecharButton: TButton;
    GridPanel: TPanel;
    QueryStringGrid: TStringGrid;
    BottomPanel: TPanel;
    BottomLinePanel: TPanel;
  end;

implementation

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

end.

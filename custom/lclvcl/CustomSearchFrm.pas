(*
  AbstractClasses, Custom Search Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomSearchFrm;

{$I abs.inc}

interface

uses
  Forms, Classes, Controls, StdCtrls, ExtCtrls, Buttons;

type

  { TCustomSearchForm }

  TCustomSearchForm = class(TForm)
    DataPanel: TPanel;
    DataLinePanel: TPanel;
    FecharButton: TButton;
    GridPanel: TPanel;
    BottomPanel: TPanel;
    BottomLinePanel: TPanel;
    QuerySpeedButton: TSpeedButton;
    SearchListBox: TListBox;
    SearchStringEdit: TEdit;
    SelectButton: TButton;
  end;

implementation

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

end.

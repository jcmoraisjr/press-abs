(*
  AbstractClasses, Custom Edit Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomEditFrm;

{$I abs.inc}

interface

uses
  Forms, Classes, Controls, StdCtrls, ExtCtrls;

type

  { TCustomEditForm }

  TCustomEditForm = class(TForm)
    ClientPanel: TPanel;
    BottomPanel: TPanel;
    FecharButton: TButton;
    GravarButton: TButton;
    LinePanel: TPanel;
  end;

implementation

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

end.

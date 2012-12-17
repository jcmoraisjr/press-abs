(*
  AbstractClasses, MVP Classes for Reports
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit ReportMVP;

{$I abs.inc}

interface

uses
  Classes,
  PressMVPModel,
  PressMVPCommand,
  CustomMVP;

type
  TReportGroupEditPresenter = class(TCustomEditPresenter)
  protected
    procedure InitPresenter; override;
  end;

  TReportItemEditPresenter = class(TCustomEditPresenter)
  protected
    procedure InitPresenter; override;
  end;

  TReportLoadReportCommand = class(TPressMVPObjectCommand)
  protected
    function GetCaption: string; override;
    function GetShortCut: TShortCut; override;
    procedure InternalExecute; override;
  end;

  TReportSaveReportCommand = class(TPressMVPObjectCommand)
  protected
    function GetCaption: string; override;
    function GetShortCut: TShortCut; override;
    procedure InternalExecute; override;
    function InternalIsEnabled: Boolean; override;
  end;

  TReportDesignReportCommand = class(TPressMVPObjectCommand)
  protected
    function GetCaption: string; override;
    function GetShortCut: TShortCut; override;
    procedure InternalExecute; override;
  end;

implementation

uses
  Windows,
  SysUtils,
  Menus,
  Dialogs,
  ReportBO;

const
  { TODO : Mover para propriedade da classe }
  CDefaultReportExt = 'frf';

{ TReportGroupEditPresenter }

procedure TReportGroupEditPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('Reports', 'RelatoriosStringGrid', 'Caption;Visible');
  View.Text := Format(
   'Relatórios de "%s"', [(Model.Subject as TReportGroup).ObjectClassName]);
end;

{ TReportItemEditPresenter }

procedure TReportItemEditPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('Caption', 'TituloEdit');
  CreateSubPresenter('UserGroups', 'GruposUsuarioStringGrid', 'GroupName');
  CreateSubPresenter('Visible', 'VisivelCheckBox');
  CreateSubPresenter('Formula', 'FormulaEdit');
  Model.AddCommands([nil, TReportLoadReportCommand, TReportSaveReportCommand,
   nil, TReportDesignReportCommand]);
end;

{ TReportLoadReportCommand }

function TReportLoadReportCommand.GetCaption: string;
begin
  Result := 'Ler novo relatório';
end;

function TReportLoadReportCommand.GetShortCut: TShortCut;
begin
  Result := Menus.ShortCut(Ord('O'), [ssCtrl]);
end;

procedure TReportLoadReportCommand.InternalExecute;
var
  VDlg: TOpenDialog;
  VReport: TReportItem;
begin
  inherited;
  VReport := Model.Subject as TReportItem;
  VDlg := TOpenDialog.Create(nil);
  try
    VDlg.DefaultExt := CDefaultReportExt;
    VDlg.Filter := Format('Relatório (*.%s)|*.%:0s', [CDefaultReportExt]);
    VDlg.Options := [ofHideReadOnly, ofFileMustExist, ofEnableSizing];
    if VDlg.Execute then
      VReport.LoadFromFile(VDlg.FileName);
  finally
    VDlg.Free;
  end;
end;

{ TReportSaveReportCommand }

function TReportSaveReportCommand.GetCaption: string;
begin
  Result := 'Gravar relatório';
end;

function TReportSaveReportCommand.GetShortCut: TShortCut;
begin
  Result := Menus.ShortCut(Ord('S'), [ssCtrl]);
end;

procedure TReportSaveReportCommand.InternalExecute;
var
  VDlg: TSaveDialog;
  VReport: TReportItem;
begin
  inherited;
  VReport := Model.Subject as TReportItem;
  VDlg := TSaveDialog.Create(nil);
  try
    VDlg.DefaultExt := CDefaultReportExt;
    VDlg.Filter := Format('Relatório (*.%s)|*.%:0s', [CDefaultReportExt]);
    VDlg.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
    if VDlg.Execute then
      VReport.SaveToFile(VDlg.FileName);
  finally
    VDlg.Free;
  end;
end;

function TReportSaveReportCommand.InternalIsEnabled: Boolean;
begin
  Result := inherited InternalIsEnabled and
   not (Model.Subject as TReportItem)._ReportMetadata.IsEmpty;
end;

{ TReportDesignReportCommand }

function TReportDesignReportCommand.GetCaption: string;
begin
  Result := 'Desenhar relatório';
end;

function TReportDesignReportCommand.GetShortCut: TShortCut;
begin
  Result := Menus.ShortCut(VK_F8, [ssCtrl]);
end;

procedure TReportDesignReportCommand.InternalExecute;
begin
  inherited;
  (Model.Subject as TReportItem).Design;
end;

initialization
  TReportGroupEditPresenter.RegisterBO(TReportGroup);
  TReportItemEditPresenter.RegisterBO(TReportItem);

end.
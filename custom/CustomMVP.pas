(*
  AbstractClasses, Custom MVP Classes
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomMVP;

{$I abs.inc}

interface

uses
  Classes,
  PressNotifier,
  PressSubject,
  PressMVP,
  PressMVPModel,
  PressMVPPresenter,
  PressMVPCommand,
  PressUserModel,
  PressReport,
  PressReportManager;

type
  TCustomMainFormPresenter = class(TPressMVPMainFormPresenter)
  private
    FNotifier: TPressNotifier;
    procedure Notify(AEvent: TPressEvent);
  protected
    procedure ExecuteLogoff; virtual;
    procedure ExecuteLogon; virtual;
    procedure Finit; override;
    procedure InitPresenter; override;
  end;

  TCustomEditModel = class(TPressMVPObjectModel)
  private
    FReportManager: TPressReportManager;
  protected
    procedure Finit; override;
    procedure InitCommands; override;
    procedure SubjectChanged(AOldSubject: TPressSubject); override;
  public
    property ReportManager: TPressReportManager read FReportManager;
  end;

  TCustomQueryModel = class(TPressMVPQueryModel)
  private
    FReportManager: TPressReportManager;
  protected
    procedure Finit; override;
    procedure SubjectChanged(AOldSubject: TPressSubject); override;
  end;

  TCustomSearchModel = class(TPressMVPQueryModel)
  end;

  TCustomOwnedReferencesModel = class(TPressMVPItemsModel)
  public
    constructor Create(AParent: TPressMVPModel; ASubjectMetadata: TPressSubjectMetadata); override;
    class function Apply(ASubjectMetadata: TPressSubjectMetadata): Boolean; override;
  end;

  TCustomEditPresenter = class(TPressMVPFormPresenter)
  private
    FGravarCommand: TPressMVPCustomSaveObjectCommand;
    FFecharCommand: TPressMVPCustomCancelObjectCommand;
  protected
    procedure InitPresenter; override;
    function InternalCancelCommand: TPressMVPCustomCancelObjectCommandClass; virtual;
    class function InternalModelClass: TPressMVPObjectModelClass; override;
    function InternalSaveCommand: TPressMVPCustomSaveObjectCommandClass; virtual;
  public
    property FecharCommand: TPressMVPCustomCancelObjectCommand read FFecharCommand;
    property GravarCommand: TPressMVPCustomSaveObjectCommand read FGravarCommand;
  end;

  TCustomSimpleEditPresenter = class(TCustomEditPresenter)
  protected
    procedure InitPresenter; override;
  end;

  TCustomQueryPresenter = class(TPressMVPQueryPresenter)
  private
    FQueryItemsPresenter: TPressMVPPresenter;
  protected
    procedure InitPresenter; override;
    class function InternalModelClass: TPressMVPObjectModelClass; override;
    property QueryItemsPresenter: TPressMVPPresenter read FQueryItemsPresenter;
  end;

  TCustomTinyQueryPresenter = class(TPressMVPQueryPresenter)
  private
    FAtualizarCommand: TPressMVPCommand;
    FQueryItemsPresenter: TPressMVPPresenter;
  protected
    procedure InitPresenter; override;
    class function InternalModelClass: TPressMVPObjectModelClass; override;
    procedure Running; override;
    property QueryItemsPresenter: TPressMVPPresenter read FQueryItemsPresenter;
  end;

  TCustomSearchPresenter = class(TPressMVPQueryPresenter)
  protected
    procedure InitPresenter; override;
    class function InternalModelClass: TPressMVPObjectModelClass; override;
  end;

  TCustomSearchItemsPresenter = class(TPressMVPItemsPresenter)
  protected
    procedure InitPresenter; override;
  end;

  TChangeUserTmpCommand = class(TPressMVPObjectCommand)
  private
    FPresenterClass: TPressMVPFormPresenterClass;
  protected
    function GetCaption: string; override;
    function GetShortCut: TShortCut; override;
    procedure InternalExecute; override;
  end;

  { TODO : Reduzir acoplamento, usar Notifier }
  TReportManager = class(TPressReportManager)
  protected
    function AddReportGroup: TPressManageReportsCommand; override;
    function AddReportItem(AItem: TPressCustomReportItem; APosition: Integer): TPressExecuteReportCommand; override;
    function InternalExecuteReportCommandClass: TPressExecuteReportCommandClass; override;    
  end;

  TExecuteReportCommand = class(TPressExecuteReportCommand)
  protected
    function InternalIsEnabled: Boolean; override;
  end;

  TLogonTmp = class(TPressLogon)
  private
    FModel: TPressMVPObjectModel;
  protected
    procedure InternalStore(const ASession: IPressSession; AStoreMethod: TPressObjectOperation); override;
  public
    property Model: TPressMVPObjectModel read FModel;
  end;

  TLogoffCommand = class(TPressMVPEmptySubjectCommand)
  protected
    procedure InternalExecute; override;
  end;

var
  { TODO : Mover para ReportBO ao reduzir acoplamento }
  GReportResourceId: Integer;

implementation

uses
  Windows,
  Menus,
  PressAttributes,
  PressMVPFactory,
  { TODO : Reduzir acoplamento }
  ReportBO,
  PressUser;

{ TCustomMainFormPresenter }

procedure TCustomMainFormPresenter.ExecuteLogoff;
begin
end;

procedure TCustomMainFormPresenter.ExecuteLogon;
begin
end;

procedure TCustomMainFormPresenter.Finit;
begin
  FNotifier.Free;
  inherited;
end;

procedure TCustomMainFormPresenter.InitPresenter;
begin
  inherited;
  FNotifier := TPressNotifier.Create({$ifdef fpc}@{$endif}Notify);
  FNotifier.AddNotificationItem(nil, [TPressUserEvent]);
end;

procedure TCustomMainFormPresenter.Notify(AEvent: TPressEvent);
begin
  if AEvent is TPressUserLogonEvent then
    ExecuteLogon
  else if AEvent is TPressUserLogoffEvent then
    ExecuteLogoff;
end;

{ TCustomEditModel }

procedure TCustomEditModel.Finit;
begin
  FReportManager.Free;
  inherited;
end;

procedure TCustomEditModel.InitCommands;
var
  VIndex: Integer;
begin
  inherited;
  VIndex := PressDefaultMVPFactory.Forms.IndexOfObjectClass(
   TPressLogon, fpExisting, True);
  if VIndex >= 0 then
    TChangeUserTmpCommand(Commands[AddCommand(TChangeUserTmpCommand)]).FPresenterClass :=
     PressDefaultMVPFactory.Forms[VIndex].PresenterClass;  // friend class
end;

procedure TCustomEditModel.SubjectChanged(AOldSubject: TPressSubject);
begin
  inherited;
  if not Assigned(FReportManager) then
    FReportManager := TReportManager.Create(Self);
end;

{ TCustomQueryModel }

procedure TCustomQueryModel.Finit;
begin
  FReportManager.Free;
  inherited;
end;

procedure TCustomQueryModel.SubjectChanged(AOldSubject: TPressSubject);
begin
  inherited;
  if not Assigned(FReportManager) then
    FReportManager := TReportManager.Create(Self);
end;

{ TCustomOwnedReferencesModel }

class function TCustomOwnedReferencesModel.Apply(
  ASubjectMetadata: TPressSubjectMetadata): Boolean;
begin
  Result := ASubjectMetadata.Supports(TPressReferences);
end;

constructor TCustomOwnedReferencesModel.Create(AParent: TPressMVPModel;
  ASubjectMetadata: TPressSubjectMetadata);
begin
  inherited Create(AParent, ASubjectMetadata);
  PersistChange := False;
end;

{ TCustomEditPresenter }

procedure TCustomEditPresenter.InitPresenter;
begin
  inherited;
  FGravarCommand := BindCommand(InternalSaveCommand, 'GravarButton') as TPressMVPCustomSaveObjectCommand;
  FFecharCommand := BindCommand(InternalCancelCommand, 'FecharButton') as TPressMVPCustomCancelObjectCommand;
end;

function TCustomEditPresenter.InternalCancelCommand: TPressMVPCustomCancelObjectCommandClass;
begin
  Result := TPressMVPCancelConfirmObjectCommand;
end;

class function TCustomEditPresenter.InternalModelClass: TPressMVPObjectModelClass;
begin
  Result := TCustomEditModel;
end;

function TCustomEditPresenter.InternalSaveCommand: TPressMVPCustomSaveObjectCommandClass;
begin
  Result := TPressMVPSaveConfirmObjectCommand;
end;

{ TCustomSimpleEditPresenter }

procedure TCustomSimpleEditPresenter.InitPresenter;
begin
  inherited;
  CreateSubPresenter('Nome', 'NomeEdit');
end;

{ TCustomQueryPresenter }

procedure TCustomQueryPresenter.InitPresenter;
begin
  inherited;
  BindCommand(TPressMVPExecuteQueryCommand, 'QuerySpeedButton');
  BindCommand(TPressMVPCancelObjectCommand, 'FecharButton');
  FQueryItemsPresenter := CreateQueryItemsPresenter('QueryStringGrid');
end;

class function TCustomQueryPresenter.InternalModelClass: TPressMVPObjectModelClass;
begin
  Result := TCustomQueryModel;
end;

{ TCustomTinyQueryPresenter }

procedure TCustomTinyQueryPresenter.InitPresenter;
begin
  inherited;
  FAtualizarCommand := BindCommand(TPressMVPExecuteQueryCommand, 'AtualizarButton');
  BindCommand(TPressMVPCancelObjectCommand, 'FecharButton');
  FQueryItemsPresenter := CreateQueryItemsPresenter('QueryStringGrid');
end;

class function TCustomTinyQueryPresenter.InternalModelClass: TPressMVPObjectModelClass;
begin
  Result := TCustomQueryModel;
end;

procedure TCustomTinyQueryPresenter.Running;
begin
  inherited;
  FAtualizarCommand.Execute;
end;

{ TCustomSearchPresenter }

procedure TCustomSearchPresenter.InitPresenter;
begin
  inherited;
  BindCommand(TPressMVPExecuteQueryCommand, 'QuerySpeedButton');
  BindCommand(TPressMVPCloseObjectCommand, 'FecharButton');
  CreateQueryItemsPresenter('SearchListBox', '', nil, TCustomSearchItemsPresenter);
end;

class function TCustomSearchPresenter.InternalModelClass: TPressMVPObjectModelClass;
begin
  Result := TCustomSearchModel;
end;

{ TCustomSearchItemsPresenter }

procedure TCustomSearchItemsPresenter.InitPresenter;
begin
  inherited;
  BindCommand(TPressMVPAssignSelectionCommand, 'SelectButton');
end;

{ TChangeUserTmpCommand }

function TChangeUserTmpCommand.GetCaption: string;
begin
  Result := 'Alterar usuário (temporário)';
end;

function TChangeUserTmpCommand.GetShortCut: TShortCut;
begin
  Result := Menus.ShortCut(VK_F12, [ssCtrl]);
end;

procedure TChangeUserTmpCommand.InternalExecute;
var
  VLogon: TLogonTmp;
begin
  inherited;
  if not Assigned(FPresenterClass) then
    Exit;
  VLogon := TLogonTmp.Create;
  try
    VLogon.FModel := Model;  // friend class
    FPresenterClass.Run(VLogon);
  finally
    VLogon.Release;
  end;
end;

{ TReportManager }

function TReportManager.AddReportGroup: TPressManageReportsCommand;
begin
  Result := inherited AddReportGroup;
  Result.ResourceId := GReportResourceId;
end;

function TReportManager.AddReportItem(AItem: TPressCustomReportItem;
  APosition: Integer): TPressExecuteReportCommand;
begin
  Result := inherited AddReportItem(AItem, APosition);
end;

function TReportManager.InternalExecuteReportCommandClass: TPressExecuteReportCommandClass;
begin
  Result := TExecuteReportCommand;
end;

{ TExecuteReportCommand }

function TExecuteReportCommand.InternalIsEnabled: Boolean;
var
  VFormula: string;
begin
  Result := inherited InternalIsEnabled;
  if Result and (ReportItem is TReportItem) then
  begin
    VFormula := TReportItem(ReportItem)._Formula.Value;
    if VFormula <> '' then
      Result := Model.Subject.Expression(VFormula);
  end;
end;

{ TLogonTmp }

procedure TLogonTmp.InternalStore(
  const ASession: IPressSession; AStoreMethod: TPressObjectOperation);
var
  VUser: TPressCustomUser;
begin
  VUser := PressUserData.QueryUser(UserId, Password);
  if Assigned(VUser) then
  begin
    try
      Model.User := VUser;
    finally
      VUser.Free;
    end;
  end else
    inherited;
end;

{ TLogoffCommand }

procedure TLogoffCommand.InternalExecute;
begin
  inherited;
  PressUserData.Logoff;
end;

initialization
  TLogonTmp.RegisterClass;

finalization
  TLogonTmp.UnregisterClass;

end.

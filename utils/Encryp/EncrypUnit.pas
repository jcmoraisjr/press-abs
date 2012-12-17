unit EncrypUnit;

interface

uses
  Forms, StdCtrls;

type
  TEncrypForm = class(TForm)
    AlgoritmoLabel: TLabel;
    AlgoritmoComboBox: TComboBox;
    EntradaLabel: TLabel;
    EntradaEdit: TEdit;
    SaidaLabel: TLabel;
    SaidaEdit: TEdit;
    CalcularButton: TButton;
    SairButton: TButton;
    procedure CalcularButtonClick(Sender: TObject);
    procedure SairButtonClick(Sender: TObject);
  end;

var
  EncrypForm: TEncrypForm;

function EncryptJ1(const AEntr: string): string;

implementation

{$R *.lfm}

function EncryptJ1(const AEntr: string): string;

  function DecToHex(APos: Integer; AVal: Byte): Char;
  const
    CHex: array[$0..$F] of char = (
     '0', '1', '2', '3', '4', '5', '6', '7',
     '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
  var
    VVal: Integer;
  begin
    VVal := ((AVal xor $A) - (7 * APos)) mod $10;
    if VVal < 0 then
      VVal := VVal + $10;
    Result := CHex[VVal];
  end;

var
  I: Integer;
begin
  SetLength(Result, 2 * Length(AEntr));
  for I := 1 to Length(AEntr) do
  begin
    Result[2 * I - 1] := DecToHex(I, Ord(AEntr[I]) div $10);
    Result[2 * I] := DecToHex(I, Ord(AEntr[I]) mod $10);
  end;
end;

procedure TEncrypForm.CalcularButtonClick(Sender: TObject);
begin
  case AlgoritmoComboBox.ItemIndex of
    0: SaidaEdit.Text := EncryptJ1(EntradaEdit.Text);
    else SaidaEdit.Text := '';
  end;
end;

procedure TEncrypForm.SairButtonClick(Sender: TObject);
begin
  Close;
end;

end.

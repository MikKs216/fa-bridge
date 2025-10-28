unit TestPascalHighlighting;

interface

uses
  Windows, Classes, SysUtils;

type
  TTestClass = class
  private
    FValue: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Calculate(AInput: Double): Double;
  end;

implementation

constructor TTestClass.Create;
begin
  FValue := 0;
end;

destructor TTestClass.Destroy;
begin
  inherited;
end;

function TTestClass.Calculate(AInput: Double): Double;
begin
  Result := AInput * 2;
end;

// Test FA Custom Functions
procedure TestFAFunctions;
var
  rodCislo: string;
  ico: string;
  isValid: boolean;
  nazev: string;
begin
  // Kontrolní funkce
  rodCislo := '7512311234';
  isValid := CheckRodneCislo(rodCislo);
  
  if CheckICO('12345678') then
    ShowMessage('ICO je validní');
  
  // Načítání dat z ARES
  if NactiAdresuZARES(ico, '', '', '', nazev, '', '', '', '', '', '') then
    MsgBoxInfo('Načteno', 'Firma: ' + nazev);
  
  // Další FA funkce
  if CheckDIC('CZ12345678') then
    MsgBoxAsk('DPH', 'Platce DPH?');
end;

// Test formulářových odkazů
procedure TestFormReferences;
var
  hodnota: string;
  cislo: Integer;
begin
  // Reference na údaje s tečkami
  hodnota := [.ckUVRozsahPV.];
  cislo := StrToInt([.ckUVRozsahZV.]);
  
  // Reference na údaje s dvojtečkami
  if [:edVyhlaska:] = '504' then
    ShowMessage('Vyhláška 504');
  
  // Kombinace
  if SameText([.ckFillZkr.], 'Z') then
  begin
    Result := GetFormField([.ckUTVRoz.]);
  end;
end;

// Test standardních Pascal konstrukcí
procedure TestStandardPascal;
var
  i, sum: Integer;
  price: Double;
  name: string;
  isActive: Boolean;
begin
  // Cykly
  for i := 1 to 10 do
  begin
    sum := sum + i;
  end;
  
  while sum < 100 do
  begin
    Inc(sum);
  end;
  
  repeat
    sum := sum - 1;
  until sum <= 50;
  
  // Podmínky
  if isActive then
  begin
    name := 'Active';
  end
  else if sum > 25 then
    name := 'Medium'
  else
    name := 'Low';
  
  // Case
  case sum of
    0..10: ShowMessage('Low');
    11..50: ShowMessage('Medium');
    51..100: ShowMessage('High');
  end;
  
  // Stringy a čísla
  name := 'Test String';
  price := 123.45;
  sum := $FF; // Hex
  
  // Konstanty
  if isActive = true then
    sum := 0
  else
    sum := nil;
end;

{$REGION 'Additional Tests'}
// Test komentářů
(* Blokový komentář *)
{ Další blokový komentář }
// Řádkový komentář

{$IFDEF DEBUG}
procedure DebugFunction;
begin
  // Debug kód
end;
{$ENDIF}
{$ENDREGION}

end.


















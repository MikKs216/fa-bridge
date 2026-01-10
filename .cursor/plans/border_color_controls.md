# Nastavení Border Color Controls

## Cíl
Nastavit barvu border pro controls na formuláři (faEdit, cxDBCheckBox, cxDBMemo, cxListBox) na červenou pro testování.

## Implementace

Upravit proceduru `ConnectMtValues` v [FAdelphi/Main.pas](FAdelphi/Main.pas) (řádky 11870-11914).

Přidat nastavení BorderColor pro každý typ controls **BEZ podmíněného překladu UCURSOR** a s komentáři:

```pascal
if c is TfaEdit then begin
  TfaEdit(c).DataSource := dsValues;
  TfaEdit(c).DataField := c.Name;
  TfaEdit(c).OnMouseDown := DoOnMouseDown;
  TfaEdit(c).OnMouseMove := DoOnMouseMove;
  // PŘIDÁNO: Nastavení barvy border na červenou (pracovní test)
  TfaEdit(c).BorderColor := clRed;
end
else if c is TcxDBCheckBox then begin
  TcxDBCheckBox(c).DataBinding.DataSource := dsValues;
  TcxDBCheckBox(c).DataBinding.DataField := c.Name;
  TcxDBCheckBox(c).OnMouseDown := DoOnMouseDown;
  // PŘIDÁNO: Nastavení barvy border na červenou (pracovní test)
  if c is TcxDBCheckBoxEx then
    TcxDBCheckBoxEx(c).Style.BorderColor := clRed;
end
else if c is TcxDBMemo then begin
  TcxDBMemo(c).DataBinding.DataSource := dsValues;
  TcxDBMemo(c).DataBinding.DataField := c.Name;
  TcxDBMemo(c).OnMouseDown := DoOnMouseDown;
  TcxDBMemo(c).OnEnter := DoOnMemoEnter;
  TcxDBMemo(c).OnExit := DoOnMemoExit;
  TcxDBMemo(c).OnEditing := DoOnMemoEditing;
  TcxDBMemo(c).Style.LookAndFeel.Kind := lfFlat;
  TcxDBMemo(c).Style.LookAndFeel.NativeStyle := FALSE;
  // PŘIDÁNO: Nastavení barvy border na červenou (pracovní test)
  if c is TcxDBMemoEx then
    TcxDBMemoEx(c).Style.BorderColor := clRed;
end
else if c is TcxListBoxEx then begin
  LoadListBoxData(TcxListBoxEx(c));
  TcxListBoxEx(c).OnMouseDown := DoOnMouseDown;
  TcxListBoxEx(c).Style.LookAndFeel.Kind := lfFlat;
  TcxListBoxEx(c).Style.LookAndFeel.NativeStyle := FALSE;
  // PŘIDÁNO: Nastavení barvy border na červenou (pracovní test)
  TcxListBoxEx(c).Style.BorderColor := clRed;
end;
```

## Poznámky
- Pro `TfaEdit` je BorderColor přímá vlastnost
- Pro cxDB* komponenty je BorderColor přes `Style.BorderColor`
- Pro TcxDBCheckBox a TcxDBMemo je nutné zkontrolovat, jestli jsou to Ex verze před přístupem ke Style.BorderColor
- TcxListBoxEx už je Ex verze, takže cast není nutný
- Všechny změny jsou bez podmíněného překladu UCURSOR
- Každý přidaný řádek má komentář "PŘIDÁNO:" pro snadnou identifikaci














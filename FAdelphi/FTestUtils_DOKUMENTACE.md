# Dokumentace unit FTestUtils.pas

## Přehled

Unit `FTestUtils` poskytuje funkcionalitu pro generování testovacích dat formulářů na základě jejich designu. Hlavní funkcí je automatické vytvoření `.frm` souboru s testovacími hodnotami pro všechna pole formuláře.

## Závislosti

- `Classes`, `SysUtils`, `DateUtils`
- `Main` - přístup k `GfaMain` a `mtDef`
- `FUtils` - pomocné funkce (`NormalPath`, `GetExePath`, `UnzipFile`, `SaveStringToFile`, `CreateGUIDString`)
- `FCommonUtils` - společné utility
- `uLkJSON` - parsování JSON
- `kbmMemTable` - práce s datovými strukturami
- `Dialogs`, `Controls`, `SPolFunkce`
- `DB` - datové typy pro práci s databázovými poli (`TField`, `TStringField`, `TMemoField`, atd.)

## Datové typy

### TFormFieldInfo

Record obsahující informace o prvku formuláře:

```pascal
TFormFieldInfo = record
  Name: string;           // Název pole
  FldType: string;        // 'String', 'Number', 'Date', 'Boolean', 'Memo'
  Left: Integer;          // X souřadnice
  Top: Integer;           // Y souřadnice
  PageKey: Integer;       // Číslo stránky formuláře
end;
```

**Pole:**
- `Name` - název pole (povinné)
- `FldType` - typ pole: `'String'`, `'Number'`, `'Date'`, `'Boolean'`, `'Memo'`
- `Left` - X souřadnice pole na formuláři
- `Top` - Y souřadnice pole na formuláři
- `PageKey` - identifikátor stránky formuláře

### TFormFieldInfoArray

Dynamické pole záznamů `TFormFieldInfo`:

```pascal
TFormFieldInfoArray = array of TFormFieldInfo;
```

## Konstanty

### ROW_TOLERANCE

```pascal
ROW_TOLERANCE = 5; // Tolerance v pixelech pro určení, že pole jsou "ve stejném řádku"
```

Používá se při řazení polí - pokud mají pole rozdíl v Y souřadnici menší nebo rovný této hodnotě, jsou považována za stejný řádek a řadí se podle X souřadnice.

## Veřejné funkce

### GenerateTestFormData

**Hlavní funkce pro generování testovacích dat formuláře.**

```pascal
function GenerateTestFormData(
  AStartNumber: Integer;
  AStartDate: TDateTime;
  ACheckBoxValue: Boolean;
  const AOutputFileName: string = ''
): Boolean;
```

**Popis:**
Načte design formuláře ze ZIP archivu, seřadí pole podle pozice na formuláři a vygeneruje `.frm` soubor s testovacími hodnotami.

**Parametry:**
- `AStartNumber` - počáteční hodnota pro číselná pole (každé další pole má hodnotu +1)
- `AStartDate` - počáteční datum pro datumová pole (každé další pole má datum +1 den)
- `ACheckBoxValue` - hodnota pro všechny checkboxy (`True` nebo `False`)
- `AOutputFileName` - název výstupního `.frm` souboru (prázdný = automatický název ve formátu `{DefID}_test.frm`)

**Návratová hodnota:**
- `True` - úspěšné vygenerování
- `False` - chyba při generování

**Pracovní postup:**
1. Získá `DefID` z `GfaMain.mtDef`
2. Extrahuje `design.json` ze ZIP archivu (`Export\{DefID}.fdx.zip`)
3. Parsuje JSON a sbírá informace o prvcích formuláře
4. Seřadí pole podle pozice (shora dolů, zleva doprava)
5. Vygeneruje hodnoty pro každé pole podle jeho typu
6. Vytvoří `.frm` soubor s hlavičkou `[FormHead]` a sekcí `[Values]`
7. Uloží soubor do `Export\{DefID}_test.frm` nebo na zadanou cestu

**Poznámky:**
- Vyžaduje inicializovaný `GfaMain` a aktivní `mtDef`
- ZIP archiv musí existovat v `Export\{DefID}.fdx.zip`
- Vytváří dočasné soubory v `Temp\` složce (automaticky mazány)

### FillTestValuesToMtValues

**Vyplní testovací hodnoty přímo do mtValues s respektováním formátů dat z mtFields.**

```pascal
function FillTestValuesToMtValues(
  AStartNumber: Integer;
  AStartDate: TDateTime;
  ACheckBoxValue: Boolean;
  AOnlyEmptyFields: Boolean = False
): Boolean;
```

**Popis:**
Načte design formuláře ze ZIP archivu, seřadí pole podle pozice na formuláři a zapíše testovací hodnoty přímo do `mtValues` s respektováním formátů dat z `mtFields`. Podobně jako `FillTestValues` v `Main.pas`, ale využívá informace z `design.json` pro řazení polí podle jejich pozice na formuláři.

**Parametry:**
- `AStartNumber` - počáteční hodnota pro číselná pole (každé další pole má hodnotu +1)
- `AStartDate` - počáteční datum pro datumová pole (každé další pole má datum +1 den)
- `ACheckBoxValue` - hodnota pro všechny checkboxy (`True` nebo `False`)
- `AOnlyEmptyFields` - vyplnit pouze prázdná pole (`True`) nebo všechna pole (`False`)

**Návratová hodnota:**
- `True` - úspěšné vyplnění hodnot
- `False` - chyba při vyplňování

**Pracovní postup:**
1. Získá `DefID` z `GfaMain.mtDef`
2. Ověří aktivitu `mtValues` a `mtFields`
3. Extrahuje `design.json` ze ZIP archivu (`Export\{DefID}.fdx.zip`)
   - Pokud ZIP nebo design.json chybí, zobrazí chybovou hlášku a skončí
4. Parsuje JSON a sbírá informace o prvcích formuláře
   - Pokud parsování selže, zobrazí chybovou hlášku a skončí
5. Seřadí pole podle pozice (shora dolů, zleva doprava)
6. Zkontroluje, zda design.json obsahuje všechna pole z `mtValues`
   - Pokud ne, zobrazí varování (ale pokračuje)
7. Pro každé pole v pořadí podle design.json:
   - Najde pole v `mtValues` podle jména
   - Pokud je pole v `mtFields`, použije informace o formátu dat
   - Vygeneruje hodnotu podle typu pole a formátu
   - Zapíše hodnotu do `mtValues`
8. Uloží změny pomocí `Post`

**Respektované formáty dat z mtFields:**
- **String pole (`cStringTypeValue = 'S'`):**
  - `mtFieldsDisplayFormat` obsahuje `'#'` → generuje číselný text s pořadovým číslem (`'1'`, `'2'`, `'3'`, ...)
  - `mtFieldsDisplayFormat` obsahuje `'^'` → generuje uppercase text s pořadovým číslem (`'TEXT1'`, `'TEXT2'`, `'TEXT3'`, ...)
  - Jinak → generuje text s pořadovým číslem (`'Text1'`, `'Text2'`, `'Text3'`, ...)
  - `mtFieldsDataTypeLength` určuje maximální délku pole (aktuálně nepoužíváno pro generování)
- **Memo pole (`cMemoTypeValue = 'M'`):**
  - Generuje text ve formátu `'{číslo}' + #13#10 + 'memo'`
  - ListBox pole se neplní (kontrola přes `FControlsNamesList`)
- **Číselná pole (`cNumericTypeValue = 'N'`, `cCurrencyTypeValue = 'C'`):**
  - `mtFieldsDataTypeLength` určuje počet desetinných míst (výchozí: 15)
  - Používá `RoundAri` pro zaokrouhlení
  - Inkrementuje hodnotu o 0.01 pro každé další pole
- **Datumová pole (`cDateTypeValue = 'D'`):**
  - Používá `AStartDate` a přidává 1 den pro každé další pole
  - `mtFieldsRepInfoDateMask` může obsahovat masku pro formátování (aktuálně nepoužíváno)
- **Boolean pole (`cBooleanTypeValue = 'B'`):**
  - Používá hodnotu `ACheckBoxValue` pro všechna checkboxy
- **Integer pole:**
  - Generuje sekvenční celá čísla od `AStartNumber`

**Poznámky:**
- Vyžaduje inicializovaný `GfaMain`, aktivní `mtDef`, `mtValues` a `mtFields`
- **DŮLEŽITÉ:** ZIP archiv MUSÍ existovat v `Export\{DefID}.fdx.zip` a obsahovat `design.json`
- **DŮLEŽITÉ:** `design.json` MUSÍ obsahovat VŠECHNA pole, která jsou v `mtValues`
- Pokud `design.json` chybí nebo je neúplný, funkce zobrazí chybovou hlášku nebo varování
- Vytváří dočasné soubory v `Temp\` složce (automaticky mazány)
- Pole jsou zpracovávána **POUZE** v pořadí podle jejich pozice na formuláři (z design.json)
- Pole, která NEJSOU v design.json, NEBUDOU naplněna (změna oproti starší verzi)
- Používá stejnou logiku generování hodnot jako `FillTestValues` v `Main.pas`

**Rozdíly oproti `FillTestValues`:**
- Využívá informace z `design.json` pro řazení polí podle pozice
- Respektuje formáty dat z `mtFields` (DisplayFormat, DataTypeLength)
- Podporuje parametr `AOnlyEmptyFields` pro vyplnění pouze prázdných polí
- Generuje hodnoty v pořadí podle pozice polí na formuláři

## Privátní funkce

### ExtractDesignJsonFromZip

**Extrahuje design.json ze ZIP archivu a načte jeho obsah.**

```pascal
function ExtractDesignJsonFromZip(const ADefID: string; 
  out AJsonContent: string): Boolean;
```

**Popis:**
Rozbalí ZIP archiv obsahující design formuláře a načte obsah souboru `design.json`.

**Parametry:**
- `ADefID` - identifikátor definice formuláře
- `AJsonContent` - výstupní parametr obsahující JSON text

**Návratová hodnota:**
- `True` - úspěšná extrakce
- `False` - chyba (soubor nenalezen, chyba při rozbalování)

**Pracovní postup:**
1. Sestaví cestu k ZIP souboru: `Export\{ADefID}.fdx.zip`
2. Ověří existenci ZIP souboru
3. Vytvoří temp adresář `Temp\` pokud neexistuje
4. Rozbalí ZIP pomocí `UnzipFile`
5. Načte `design.json` z temp adresáře
6. Smaže temp soubor
7. Vrátí obsah JSON jako string

**Chyby:**
- Zobrazí zprávu pokud ZIP soubor neexistuje
- Zobrazí zprávu pokud `design.json` není v archivu
- Zobrazí zprávu při chybě při rozbalování

### ParseDesignJsonAndCollectFields

**Parsuje JSON a sbírá informace o prvcích formuláře.**

```pascal
function ParseDesignJsonAndCollectFields(const AJsonContent: string;
  var AFields: TFormFieldInfoArray): Boolean;
```

**Popis:**
Prochází JSON strukturu designu formuláře a extrahuje informace o všech polích (TextEditBox, CheckBox, TextMemoBox).

**Parametry:**
- `AJsonContent` - JSON text obsahující design formuláře
- `AFields` - výstupní pole s informacemi o prvcích formuláře

**Návratová hodnota:**
- `True` - úspěšné parsování a nalezení alespoň jednoho pole
- `False` - chyba při parsování nebo žádné pole nenalezeno

**Struktura JSON:**
- Root je pole stránek (`TlkJSONlist`)
- Každá stránka (`TlkJSONobject`) obsahuje:
  - `PageKey` - číslo stránky
  - `TextEditBox` - pole textových vstupů
  - `CheckBox` - pole checkboxů
  - `TextMemoBox` - pole memo polí

**Zpracovávané sekce:**
- `TextEditBox` - textová pole (typ určen z `FldType`: `'String'`, `'Number'`, `'Date'`)
- `CheckBox` - checkboxy (typ: `'Boolean'`)
- `TextMemoBox` - memo pole (typ: `'Memo'`)

**Extrahované informace:**
- `Name` - název pole (povinné, bez něj se pole přeskočí)
- `Left` - X souřadnice (výchozí: 0)
- `Top` - Y souřadnice (výchozí: 0)
- `PageKey` - číslo stránky (výchozí: 0)
- `FldType` - typ pole (určen podle sekce a vlastnosti `FldType`)

**Chyby:**
- Zobrazí zprávu při chybě parsování JSON
- Zobrazí zprávu pokud nebyly nalezeny žádné prvky

### CompareFieldsByPosition

**Porovnávací funkce pro řazení prvků podle pozice.**

```pascal
function CompareFieldsByPosition(const F1, F2: TFormFieldInfo): Integer;
```

**Popis:**
Porovnává dva prvky formuláře pro účely řazení. Používá se v `SortFieldsByPosition`.

**Parametry:**
- `F1` - první prvek k porovnání
- `F2` - druhý prvek k porovnání

**Návratová hodnota:**
- `< 0` - `F1` je před `F2`
- `= 0` - prvky jsou na stejné pozici
- `> 0` - `F1` je za `F2`

**Řazení:**
1. Primárně podle `PageKey` (stránka formuláře)
2. Sekundárně podle `Top` (Y souřadnice - shora dolů)
3. Pokud jsou ve stejném řádku (rozdíl Y ≤ `ROW_TOLERANCE`), řadí podle `Left` (X souřadnice - zleva doprava)

### SortFieldsByPosition

**Seřadí pole prvků podle jejich pozice na formuláři.**

```pascal
procedure SortFieldsByPosition(var AFields: TFormFieldInfoArray);
```

**Popis:**
Seřadí pole prvků formuláře podle jejich pozice pomocí bubble sort algoritmu. Řazení probíhá shora dolů, zleva doprava v rámci řádků.

**Parametry:**
- `AFields` - pole prvků k seřazení (modifikováno na místě)

**Algoritmus:**
- Používá bubble sort s optimalizací (přerušení pokud není provedena žádná výměna)
- Porovnávání pomocí `CompareFieldsByPosition`

**Výsledek:**
Pole je seřazeno tak, že prvky jsou v pořadí, jak se mají zobrazovat na formuláři (shora dolů, zleva doprava).

### GenerateFieldValue

**Generuje hodnotu pro pole podle jeho typu.**

```pascal
function GenerateFieldValue(const AFieldType: string;
  var ANumberCounter: Integer;
  var ADateCounter: TDateTime;
  ACheckBoxValue: Boolean): string;
```

**Popis:**
Vygeneruje testovací hodnotu pro pole na základě jeho typu. Používá čítače pro inkrementální hodnoty.

**Parametry:**
- `AFieldType` - typ pole (`'String'`, `'Number'`, `'Date'`, `'Boolean'`, `'Memo'`)
- `ANumberCounter` - čítač pro číselná pole (modifikován - inkrementován)
- `ADateCounter` - čítač pro datumová pole (modifikován - přidán 1 den)
- `ACheckBoxValue` - hodnota pro checkboxy

**Návratová hodnota:**
String obsahující vygenerovanou hodnotu ve formátu vhodném pro `.frm` soubor.

**Generované hodnoty podle typu:**
- `'Number'` - číslo jako string (`IntToStr(ANumberCounter)`), čítač +1
- `'Date'` - datum jako string (`DateToStr(ADateCounter)`), datum +1 den
- `'Boolean'` - `'True'` nebo `'False'` podle `ACheckBoxValue`
- `'Memo'` - `'Memo text {číslo}'`, čítač +1
- `'String'` a ostatní - `'Text{číslo}'`, čítač +1

**Poznámky:**
- Čítače jsou modifikovány, takže každé další pole dostane jinou hodnotu
- Pro datumová pole se používá `IncDay` z `DateUtils`

### CreateTestFormHead

**Vytvoří sekci [FormHead] pro FRM soubor.**

```pascal
function CreateTestFormHead(const ADefID: string): string;
```

**Popis:**
Vygeneruje hlavičku `.frm` souboru s testovacími hodnotami a novým GUID.

**Parametry:**
- `ADefID` - identifikátor definice formuláře

**Návratová hodnota:**
String obsahující sekci `[FormHead]` ve formátu INI souboru.

**Vygenerované hodnoty:**
- `ID` - nový GUID
- `GUID` - nový GUID
- `MasterGuid` - prázdný string
- `DefID` - předaný `ADefID`
- `DefVersion` - `'1.0'`
- `Period` - aktuální rok (`FormatDateTime('yyyy', Now)`)
- `Group` - prázdný string
- `SubGroup` - prázdný string
- `CreateDate` - aktuální datum
- `ModifiedDate` - aktuální datum
- `ModifiedTime` - aktuální čas
- `Autor` - `'TEST_GENERATOR'`
- `Locked` - `'False'`
- `WorkState` - `'0'`

**Formát:**
Výstup je ve formátu INI souboru:
```
[FormHead]
ID={GUID}
GUID={GUID}
...
```

## Pracovní tok

1. **Inicializace**
   - Získání `DefID` z `GfaMain.mtDef`
   - Ověření existence a aktivace dat

2. **Extrakce designu**
   - Rozbalení ZIP archivu `Export\{DefID}.fdx.zip`
   - Načtení `design.json`

3. **Parsování**
   - Parsování JSON struktury
   - Extrakce informací o všech polích formuláře
   - Určení typu každého pole

4. **Řazení**
   - Seřazení polí podle pozice (PageKey → Top → Left)

5. **Generování hodnot**
   - Pro každé pole vygenerování testovací hodnoty podle typu
   - Použití čítačů pro inkrementální hodnoty

6. **Vytvoření FRM souboru**
   - Vytvoření hlavičky `[FormHead]` s novým GUID
   - Vytvoření sekce `[Values]` s hodnotami polí
   - Uložení do souboru

## Formát výstupního souboru

Výstupní `.frm` soubor má následující strukturu:

```ini
[FormHead]
ID={GUID}
GUID={GUID}
MasterGuid=
DefID={DefID}
DefVersion=1.0
Period=2026
Group=
SubGroup=
CreateDate={datum}
ModifiedDate={datum}
ModifiedTime={čas}
Autor=TEST_GENERATOR
Locked=False
WorkState=0

[Values]
{FieldName1}={Value1}
{FieldName2}={Value2}
...
```

## Chybové stavy

Unit zobrazuje uživatelské zprávy (`ShowMessage`) v následujících případech:

1. `GfaMain` není inicializován
2. Definice formuláře není načtena
3. `DefID` není definováno
4. ZIP soubor nenalezen
5. Chyba při rozbalování ZIP souboru
6. `design.json` nenalezen v archivu
7. Chyba při parsování JSON
8. V design.json nebyly nalezeny žádné prvky
9. Chyba při generování testovacích dat

## Omezení a poznámky

- Používá bubble sort pro řazení (dostatečné pro menší počet prvků)
- Tolerance pro určení řádku je fixní (`ROW_TOLERANCE = 5`)
- Všechny checkboxy dostanou stejnou hodnotu (`ACheckBoxValue`)
- Číselná pole začínají od `AStartNumber` a inkrementují se
- Datumová pole začínají od `AStartDate` a přidávají se dny
- Textová pole dostávají hodnoty ve formátu `'Text{číslo}'`
- Memo pole dostávají hodnoty ve formátu `'Memo text {číslo}'`
- Temp soubory jsou automaticky mazány po použití

## Pomocné funkce

### GenerateRandomText

**Generuje náhodný text o zadané délce.**

```pascal
function GenerateRandomText(ALength: Integer; AGenNumber: boolean = False): string;
```

**Popis:**
Vygeneruje náhodný text o zadané délce. Může generovat buď písmena (a-z) nebo číslice (0-9).

**Parametry:**
- `ALength` - délka generovaného textu
- `AGenNumber` - pokud `True`, generuje číslice, jinak písmena

**Návratová hodnota:**
String obsahující náhodný text.

**Použití:**
Používá se při generování testovacích hodnot pro stringová pole s různými formáty.

## Budoucí rozšíření

Možné oblasti pro rozšíření:
- Konfigurovatelná tolerance pro řádky
- Pokročilejší generování hodnot (realistická data, validace)
- Podpora dalších typů polí
- Možnost generovat více testovacích souborů najednou
- Export do jiných formátů (CSV, JSON)
- Validace generovaných dat proti schématu formuláře
- Respektování `mtFieldsRepInfoDateMask` pro formátování dat
- Podpora dalších formátů z `mtFieldsDisplayFormat`

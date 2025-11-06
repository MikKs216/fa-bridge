
unit FCommonUtils;
{$WARN SYMBOL_PLATFORM OFF}
{$OPTIMIZATION OFF}

interface

uses
  Windows, Classes, Graphics, IniFiles, kbmMemTable, Dialogs;

const
  cFADecimalSeparator = '.';

  cCRLFAlternate = #255'#';
  cCRLF = #13#10;

type
  TShellOpenCmdType = (ctOpen, ctPrintDefault, ctPrintDialog, ctPrintTo);

//cursor functions
/// <summary>Zobrazí kurzor čekání (hodinové sklo).</summary>
procedure StartWait;
/// <summary>Skryje kurzor čekání.</summary>
procedure StopWait;
/// <summary>Skryje kurzor čekání a vyčistí stav.</summary>
procedure StopWaitClear;

//message functions
/// <summary>Zobrazí dialogové okno s chybovou zprávou.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text chybové zprávy.</param>
/// <param name="AFlags">Příznaky dialogu (např. tlačítka).</param>
/// <returns>Hodnota odpovědi uživatele.</returns>
function MsgBoxErr(const ACaption, AMsg: string; AFlags: longint): integer; overload;
/// <summary>Zobrazí dialogové okno s varovnou zprávou.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text varovné zprávy.</param>
/// <param name="AFlags">Příznaky dialogu (např. tlačítka).</param>
/// <returns>Hodnota odpovědi uživatele.</returns>
function MsgBoxWarn(const ACaption, AMsg: string; AFlags: longint): integer; overload;
/// <summary>Zobrazí dialogové okno s dotazem.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text dotazu.</param>
/// <param name="AFlags">Příznaky dialogu (např. tlačítka).</param>
/// <returns>Hodnota odpovědi uživatele.</returns>
function MsgBoxAsk(const ACaption, AMsg: string; AFlags: longint): integer; overload;
/// <summary>Zobrazí dialogové okno s dotazem a vlastními tlačítky.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text dotazu.</param>
/// <param name="ABtn1Text">Text prvního tlačítka.</param>
/// <param name="ABtn2Text">Text druhého tlačítka.</param>
/// <param name="ABtn3Text">Text třetího tlačítka.</param>
/// <param name="ADefaultBtn">Číslo výchozího tlačítka (1-3, výchozí je 1).</param>
/// <param name="ABtnWidth">Šířka tlačítek v bodech (výchozí je 100).</param>
/// <param name="ADlgType">Typ dialogu (výchozí je 3).</param>
/// <param name="ADlgWidth">Šířka dialogu v bodech (0 = automatická).</param>
/// <returns>Hodnota odpovědi uživatele (číslo stisknutého tlačítka).</returns>
function MsgBoxAskButtons(ACaption, AMsg: string; ABtn1Text: string; ABtn2Text: string; ABtn3Text: string;
  ADefaultBtn: Integer = 1; ABtnWidth: Integer = 100; ADlgType: integer = 3; ADlgWidth: Integer = 0): integer;
/// <summary>Zobrazí dialogové okno s informační zprávou.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text informační zprávy.</param>
/// <param name="AFlags">Příznaky dialogu (např. tlačítka).</param>
/// <returns>Hodnota odpovědi uživatele.</returns>
function MsgBoxInfo(const ACaption, AMsg: string; AFlags: longint): integer; overload;

//conversion functions
/// <summary>Převede celé číslo na hexadecimální řetězec.</summary>
/// <param name="AValue">Celé číslo k převedení.</param>
/// <returns>Hexadecimální řetězec.</returns>
function IntToHexStr(AValue: integer): string;
/// <summary>Převede hexadecimální řetězec na celé číslo.</summary>
/// <param name="AValue">Hexadecimální řetězec.</param>
/// <returns>Celé číslo nebo 0, pokud převod selže.</returns>
function HexStrToInt(AValue: string): integer;
/// <summary>Převede barvu na hexadecimální řetězec.</summary>
/// <param name="AColor">Barva k převedení.</param>
/// <returns>Hexadecimální řetězec barvy.</returns>
function ColorToHexStr(AColor: TColor): string;
/// <summary>Převede hexadecimální řetězec na barvu.</summary>
/// <param name="AStr">Hexadecimální řetězec barvy.</param>
/// <returns>Barva nebo clBlack, pokud převod selže.</returns>
function HexStrToColor(const AStr: string): TColor;
/// <summary>Převede barvu na textový řetězec.</summary>
/// <param name="AColor">Barva k převedení.</param>
/// <returns>Textový řetězec barvy.</returns>
function ColorToStr(AColor: TColor): string;
/// <summary>Převede textový řetězec na barvu.</summary>
/// <param name="AStr">Textový řetězec barvy.</param>
/// <returns>Barva nebo clBlack, pokud převod selže.</returns>
function StrToColor(const AStr: string): TColor;
/// <summary>Ověří, zda je řetězec platným hexadecimálním kódem barvy.</summary>
/// <param name="AStr">Řetězec k ověření.</param>
/// <returns>True, pokud je řetězec platný hexadecimální kód barvy, jinak false.</returns>
function IsValidHexStrColor(const AStr: string): boolean;
/// <summary>Převede logickou barvu na textový řetězec.</summary>
/// <param name="AColor">Logická barva k převedení.</param>
/// <returns>Textový řetězec logické barvy.</returns>
function LogicColorToStr(AColor: TColor): string;
/// <summary>Převede textový řetězec na logickou barvu.</summary>
/// <param name="AStr">Textový řetězec logické barvy.</param>
/// <returns>Logická barva nebo clBlack, pokud převod selže.</returns>
function StrToLogicColor(const AStr: string): TColor;
/// <summary>Ověří, zda je řetězec platným kódem logické barvy.</summary>
/// <param name="AStr">Řetězec k ověření.</param>
/// <returns>True, pokud je řetězec platný kód logické barvy, jinak false.</returns>
function IsValidStrLogicColor(const AStr: string): boolean;
/// <summary>Zjistí, zda je barva logická barva.</summary>
/// <param name="AColor">Barva k ověření.</param>
/// <returns>True, pokud je barva logická, jinak false.</returns>
function IsLogicColor(AColor: TColor): boolean;
/// <summary>Odstraní diakritiku z jednoho znaku.</summary>
/// <param name="c">Znak k převedení.</param>
/// <returns>Znak bez diakritiky.</returns>
function ChangeDiakritic(const c: char): char;
/// <summary>Zjistí, zda je řetězec složen pouze z velkých písmen.</summary>
/// <param name="s">Řetězec k ověření.</param>
/// <returns>True, pokud jsou všechna písmena velká, jinak false.</returns>
function IsStringUpperCase(const s: string): boolean;
/// <summary>Zjistí, zda je řetězec složen pouze z malých písmen.</summary>
/// <param name="s">Řetězec k ověření.</param>
/// <returns>True, pokud jsou všechna písmena malá, jinak false.</returns>
function IsStringLowerCase(const s: string): boolean;
/// <summary>Zjistí, zda má řetězec první písmeno velké a ostatní malá.</summary>
/// <param name="s">Řetězec k ověření.</param>
/// <returns>True, pokud má řetězec první písmeno velké, jinak false.</returns>
function IsStringFirstUpperCase(const s: string): boolean;
/// <summary>Vrací řetězec, kde první znak a každý první znak po mezeře je převeden na velké písmeno. Ostatní znaky zůstávají beze změny.</summary>
/// <param name="s">Vstupní text, který se má upravit.</param>
/// <returns>Upravený text s velkými počátečními písmeny slov.</returns>
function StringFirstUpperCase(const s: string): string;
/// <summary>Změní velikost písmen v řetězci (velká na malá, malá na velká).</summary>
/// <param name="s">Vstupní text.</param>
/// <returns>Text se změněnou velikostí písmen.</returns>
function ChangeStringCase(const s: string): string;
/// <summary>Odstraní znaky, které nejsou povoleny v licenčních klíčích.</summary>
/// <param name="s">Vstupní text.</param>
/// <returns>Text bez nepovolených znaků.</returns>
function RemoveNonLicChar(const s: string): string;

//string functions
/// <summary>Nahradí všechny výskyty zadaného řetězce jiným textem. Volitelně bez ohledu na velikost písmen.</summary>
/// <param name="ASearch">Hledaný text.</param>
/// <param name="AStr">Vstupní text, ve kterém se má nahradit.</param>
/// <param name="AReplace">Text, kterým se má nahradit.</param>
/// <param name="AIgnoreCase">Pokud je true, nahrazuje bez ohledu na velikost písmen.</param>
/// <returns>Text po nahrazení všech výskytů.</returns>
function Replace(const ASearch, AStr, AReplace: string;
  AIgnoreCase: boolean = FALSE): string;
/// <summary>Vrací text doplněný uvozovkami zleva a zprava.</summary>
/// <param name="AString">Text, jenž bude uvozen.</param>
/// <returns>Text obalený uvozovkami.</returns>
function QuotedStr(const AString: string): string;
/// <summary>Převede řetězec z kódování Windows-1250 na ANSI.</summary>
/// <param name="AStr">Vstupní text v kódování Windows-1250.</param>
/// <returns>Text v ANSI kódování.</returns>
function Str1250ToANSI(const AStr: string): string;
/// <summary>Testuje, zda zadaný text představuje platné celé číslo v rozsahu 32bitového integeru.</summary>
/// <param name="AStr">Text, který se má testovat.</param>
/// <returns>Vrací true, pokud je text validní celé číslo (Int32), jinak false.</returns>
function IsInteger(const AStr: string): boolean;
/// <summary>Testuje, zda zadaný text představuje platné desetinné číslo.</summary>
/// <param name="AStr">Text, který se má testovat.</param>
/// <returns>Vrací true, pokud je text validní desetinné číslo, jinak false.</returns>
function IsFloat(const AStr: string): boolean;
/// <summary>Testuje, zda zadaný text představuje platné celé číslo měny.</summary>
/// <param name="AStr">Text, který se má testovat.</param>
/// <returns>Vrací true, pokud je text validní celé číslo měny, jinak false.</returns>
function IsCurrencyInt(AStr: string): boolean;
/// <summary>Testuje, zda zadaný text je ve formátu "dd.MM.yyyy" a zároveň představuje reálné datum. Pokud neprojde primární test, zkouší systémový formát.</summary>
/// <param name="AStr">Text, který se má testovat.</param>
/// <returns>Vrací true, pokud je text validní datum, jinak false.</returns>
function IsDate(const AStr: string): boolean;
/// <summary>Testuje, zda zadaný text představuje platnou boolean hodnotu.</summary>
/// <param name="AStr">Text, který se má testovat.</param>
/// <returns>Vrací true, pokud je text validní boolean hodnota, jinak false.</returns>
function IsBoolean(const AStr: string): boolean;
/// <summary>Zjistí, zda řetězec obsahuje pouze tečky.</summary>
/// <param name="s">Řetězec k ověření.</param>
/// <returns>True, pokud řetězec obsahuje pouze tečky, jinak false.</returns>
function IsDots(const s: string): boolean;
/// <summary>Převede text na celé číslo. Pokud není platné číslo, vrací 0.</summary>
/// <param name="AStr">Text k převedení.</param>
/// <returns>Celé číslo nebo 0, pokud převod selže.</returns>
function StrToIntSafe(const AStr: string): integer;
/// <summary>Převede text na číslo s desetinnou čárkou. Pokud není platné číslo, vrací 0.</summary>
/// <param name="AStr">Text k převedení.</param>
/// <returns>Desetinné číslo nebo 0, pokud převod selže.</returns>
function StrToFloatSafe(const AStr: string): double;
/// <summary>Převede text na boolean. Přijímá „true“, „1“, „ano“, „yes“. Jinak false.</summary>
/// <param name="AStr">Text k převedení.</param>
/// <returns>Boolean hodnota.</returns>
function StrToBoolSafe(const AStr: string): boolean;
/// <summary>Převede text na datum. Pokud není platné datum, vrací DateTime.MinValue.</summary>
/// <param name="AStr">Text k převedení.</param>
/// <returns>Datum nebo DateTime.MinValue, pokud převod selže.</returns>
function StrToDateSafe(const AStr: string): TDateTime;
/// <summary>Vrací datum jako řetězec ve formátu yyyy-MM-dd.</summary>
/// <param name="ADate">Datum k převedení.</param>
/// <returns>Datum jako řetězec ve formátu yyyy-MM-dd.</returns>
function DateToStrNorm(ADate: TDateTime): string;
/// <summary>Vygeneruje nový GUID ve formátu jako Delphi CreateGUID: {VELKÝMI-PÍSMENY}.</summary>
/// <returns>GUID jako string s velkými písmeny a závorkami.</returns>
function CreateGUIDString:string;
/// <summary>Odstraní nevhodné mezery a sjednotí oddělovače v řetězci data.</summary>
/// <param name="AStrDate">Vstupní řetězec s datem.</param>
/// <returns>Normalizovaný řetězec data.</returns>
function NormalizeDateStr(const AStrDate: string):string;
/// <summary>Testuje, zda zadaný text obsahuje pouze číslice 0–9.</summary>
/// <param name="AStr">Text, který se má testovat.</param>
/// <returns>Vrací true, pokud text obsahuje pouze číslice, jinak false.</returns>
function IsDigit(AStr: string): boolean;
/// <summary>Odstraní z textu znaky, které nemají ekvivalent v Latin2 a nahradí je podobnými znaky nebo otazníkem '?'.</summary>
/// <param name="AStr">Vstupní text ke zpracování.</param>
/// <returns>Text se znaky mimo Latin2 nahrazenými alternativami nebo '?'.</returns>
function ReplaceLatin2InvalidChar(const AStr: string): string;
/// <summary>Přidá XML hodnotu do dokumentu.</summary>
/// <param name="ADoc">XML dokument (vstupní a výstupní parametr).</param>
/// <param name="AKey">Klíč (název elementu).</param>
/// <param name="AValue">Hodnota elementu.</param>
procedure AddXMLStrValue(var ADoc: string; AKey, AValue: string);
/// <summary>Porovná dvě verze programu podle zadaných kritérií.</summary>
/// <param name="ver1">První verze k porovnání.</param>
/// <param name="ver2">Druhá verze k porovnání.</param>
/// <param name="major">Pokud je true, porovnává major verzi.</param>
/// <param name="minor">Pokud je true, porovnává minor verzi.</param>
/// <param name="release">Pokud je true, porovnává release verzi.</param>
/// <returns>-1 pokud ver1 < ver2, 0 pokud jsou stejné, 1 pokud ver1 > ver2.</returns>
function ComparePrgVersion(ver1:string; ver2:string; major:Boolean; minor:Boolean; release:Boolean):integer;
/// <summary>Porovná dvě verze (formát X.Y.Z) a vrací -1, 0, 1.</summary>
/// <param name="ver1">První verze k porovnání.</param>
/// <param name="ver2">Druhá verze k porovnání.</param>
/// <returns>-1 pokud ver1 < ver2, 0 pokud jsou stejné, 1 pokud ver1 > ver2.</returns>
function CompareVersion(ver1:string; ver2:string):integer;
/// <summary>Převede XML dokument nebo řetězec z UTF-8/UTF-16 na Windows-1250.</summary>
/// <param name="AFileOrStr">Cesta k XML souboru nebo XML řetězec.</param>
/// <returns>XML text v kódování Windows-1250.</returns>
function XMLStrToWindows1250(const AFileOrStr: string): string;
/// <summary>Normalizuje XML text: nahradí zakázané znaky a escapuje speciální XML znaky (&lt;, &gt;, &amp;, &apos;, &quot;).</summary>
/// <param name="AXmlStr">Vstupní XML řetězec k normalizaci.</param>
/// <returns>Normalizovaný XML text vhodný pro zápis do dokumentu.</returns>
function XMLNormChars(const AXmlStr: string): string;
/// <summary>Převede řetězec z jednoho kódování do druhého.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="ACodePageFrom">Zdrojové kódování (code page).</param>
/// <param name="ACodePageTo">Cílové kódování (code page).</param>
/// <returns>Text převedený do cílového kódování.</returns>
function StrCharsetConversion(const AStr: string; ACodePageFrom: integer;
  ACodePageTo: integer): string;
/// <summary>Odstraní zleva všechny znaky uvedené v seznamu znaků.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="AChars">Znaky, které se mají zleva odstranit (např. ",.;").</param>
/// <returns>Text bez zadaných znaků zleva.</returns>
function TrimCharsLeft(const AStr: string; const AChars: string): string;
/// <summary>Odstraní zprava všechny znaky uvedené v seznamu znaků.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="AChars">Znaky, které se mají zprava odstranit (např. ",.;").</param>
/// <returns>Text bez zadaných znaků zprava.</returns>
function TrimCharsRight(const AStr: string; const AChars: string): string;
/// <summary>Odstraní zleva i zprava všechny znaky uvedené v seznamu znaků.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="AChars">Znaky, které se mají odstranit (např. ",.;").</param>
/// <returns>Text bez zadaných znaků na začátku i na konci.</returns>
function TrimChars(const AStr: string; const AChars: string): string;
/// <summary>Odstraní z textu všechny znaky, které se vyskytují v seznamu znaků.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="AChars">Znaky, které se mají z textu odstranit (např. ",.;").</param>
/// <returns>Text bez všech výskytů zadaných znaků.</returns>
function RemoveChars(const AStr: string; const AChars: string): string;
/// <summary>Spojí dva texty zadaným oddělovačem, pokud nejsou prázdné. Oddělovač se použije jen pokud jsou oba texty neprázdné.</summary>
/// <param name="AStr1">První řetězec.</param>
/// <param name="AStr2">Druhý řetězec.</param>
/// <param name="ASeparator">Oddělovač, který se použije mezi texty (výchozí je čárka).</param>
/// <returns>Spojený text podle pravidel, nebo prázdný řetězec.</returns>
function ConCatStr(const AStr1, AStr2: string; const ASeparator: string = ','): string;

//stringlist / string functions
/// <summary>Do textu AStr přidá řádek AAddedStrLine.</summary>
/// <param name="AStr">Text do kterého se řádek přidává (vstupní a výstupní parametr).</param>
/// <param name="AAddedStrLine">Přidávaný řádek.</param>
procedure AddStringLine(var AStr: string; const AAddedStrLine: string);
/// <summary>Vrátí počet řádků v textu.</summary>
/// <param name="AStr">Text k počítání řádků.</param>
/// <returns>Počet řádků v textu.</returns>
function GetStringLinesCount(const AStr: string): integer;
/// <summary>Vrátí řádek z textu podle čísla řádku.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="ALineNo">Číslo řádku (0 = první řádek).</param>
/// <returns>Řádek z textu nebo prázdný řetězec, pokud řádek neexistuje.</returns>
function GetStringLine(const AStr: string; ALineNo: integer = 0): string;
/// <summary>Vrátí hodnotu z řádku ve formátu "Název=Hodnota".</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="AValueName">Název hodnoty (levá strana před '=').</param>
/// <returns>Hodnota z řádku nebo prázdný řetězec, pokud hodnota neexistuje.</returns>
function GetStringLineValue(const AStr, AValueName: string): string;
/// <summary>Uloží text do souboru.</summary>
/// <param name="AStr">Text k uložení.</param>
/// <param name="AFileName">Cesta k souboru.</param>
procedure SaveStringToFile(const AStr, AFileName: string);
/// <summary>Načte text ze souboru.</summary>
/// <param name="AFileName">Cesta k souboru.</param>
/// <returns>Text ze souboru nebo prázdný řetězec, pokud soubor neexistuje.</returns>
function LoadStringFromFile(const AFileName: string): string;
/// <summary>Získá sekci z textu ve formátu INI.</summary>
/// <param name="AData">Vstupní text s daty.</param>
/// <param name="ASection">Název sekce.</param>
/// <returns>Obsah sekce nebo prázdný řetězec, pokud sekce neexistuje.</returns>
function GetSection(const AData, ASection: string): string;
/// <summary>Nastaví nebo vytvoří sekci v textu ve formátu INI.</summary>
/// <param name="AMainData">Vstupní text s daty.</param>
/// <param name="ASection">Název sekce.</param>
/// <param name="ASectionData">Obsah sekce.</param>
/// <returns>Text s nastavenou nebo vytvořenou sekcí.</returns>
function SetSection(const AMainData, ASection, ASectionData: string): string;
/// <summary>Odstraní řádek z textu podle čísla řádku.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="ALineNo">Číslo řádku k odstranění (0 = první řádek).</param>
/// <returns>Text bez odstraněného řádku.</returns>
function DeleteStringLine(const AStr: string; ALineNo: integer = 0): string;
/// <summary>Vrátí název z řádku ve formátu "Název=Hodnota" podle hodnoty.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="AValue">Hodnota k hledání (pravá strana za '=').</param>
/// <param name="CaseSensitive">Pokud je true, hledá s ohledem na velikost písmen.</param>
/// <returns>Název z řádku nebo prázdný řetězec, pokud hodnota neexistuje.</returns>
function GetStringLineName(const AStr, AValue: string; CaseSensitive: Boolean = True): string;

//csv strings functions
/// <summary>Vrací počet položek v CSV řetězci odděleném čárkami.</summary>
/// <param name="ACSVList">CSV text.</param>
/// <returns>Počet položek v CSV řetězci.</returns>
function CountListItems(const ACSVList: string): integer;
/// <summary>Vrací položku z CSV řetězce na základě indexu.</summary>
/// <param name="ACSVList">CSV text.</param>
/// <param name="AItemIndex">Index položky (0-based).</param>
/// <returns>Položka z CSV řetězce nebo prázdný řetězec, pokud index není platný.</returns>
function GetListItem(const ACSVList: string; AItemIndex: integer): string;
/// <summary>Přidá hodnotu do CSV seznamu, pokud tam ještě není.</summary>
/// <param name="ACSVList">CSV text.</param>
/// <param name="AStringItem">Hodnota, kterou chceme přidat.</param>
/// <param name="AAddIfExist">Pokud je true, přidá i když hodnota již existuje.</param>
/// <returns>CSV seznam s přidanou hodnotou.</returns>
function AddValueToList(const ACSVList, AStringItem: string;
  AAddIfExist: boolean = FALSE): string;
/// <summary>Odebere hodnotu ze CSV seznamu, pokud existuje.</summary>
/// <param name="ACSVList">CSV text.</param>
/// <param name="AStringItem">Hodnota, kterou chceme odebrat.</param>
/// <returns>CSV seznam bez odebrané hodnoty.</returns>
function RemoveValueFromList(const ACSVList, AStringItem: string): string;
/// <summary>Odstraní mezery na začátku a konci každé položky v CSV seznamu.</summary>
/// <param name="AStringListText">CSV text.</param>
/// <returns>CSV seznam s oříznutými položkami.</returns>
function TrimStringListText(const AStringListText: string): string;
/// <summary>Vrací skupinu z CSV seznamu, která obsahuje zadanou hodnotu.</summary>
/// <param name="AGroupCSVList">CSV seznam skupin.</param>
/// <param name="AStringItem">Hledaná hodnota.</param>
/// <returns>Skupina obsahující hodnotu nebo prázdný řetězec.</returns>
function GetGroupWithString(const AGroupCSVList, AStringItem: string): string;
/// <summary>Vrací true, pokud CSV seznam obsahuje danou hodnotu.</summary>
/// <param name="ACSVList">CSV text.</param>
/// <param name="AStringItem">Hodnota k hledání.</param>
/// <returns>True, pokud CSV seznam obsahuje hodnotu, jinak false.</returns>
function IsItemInList(const ACSVList, AStringItem: string): boolean;
/// <summary>Vrací pozici hodnoty v CSV seznamu, nebo -1 pokud neexistuje.</summary>
/// <param name="ACSVList">CSV text.</param>
/// <param name="AStringItem">Hledaná hodnota.</param>
/// <returns>Pozice hodnoty v CSV seznamu (0-based) nebo -1, pokud neexistuje.</returns>
function GetItemPosition(const ACSVList, AStringItem: string): integer;
/// <summary>Převede CSV seznam čísel na seznam int hodnot (s limitem).</summary>
/// <param name="ACSVList">CSV text s čísly.</param>
/// <param name="ALimit">Maximální počet hodnot k dekódování.</param>
/// <returns>Dekódovaný seznam čísel jako text.</returns>
function DecodeIntegerList(ACSVList: string; ALimit: integer): string;
/// <summary>Ověří, zda CSV seznam obsahuje pouze platná celá čísla.</summary>
/// <param name="ACSVList">CSV text.</param>
/// <returns>True, pokud CSV seznam obsahuje pouze platná celá čísla, jinak false.</returns>
function CheckValidIntegerList(ACSVList: string): boolean;
/// <summary>Vrací hodnotu pole ze záznamu CSV na základě názvu sloupce.</summary>
/// <param name="ACsvString">CSV řetězec s daty.</param>
/// <param name="AFieldName">Název sloupce.</param>
/// <param name="ARecNo">Číslo záznamu (0-based).</param>
/// <returns>Hodnota pole nebo prázdný řetězec, pokud pole nebo záznam neexistuje.</returns>
function GetCsvFieldByName(const ACsvString: string; const AFieldName: string;
  ARecNo: integer): string;
//var tranformation
/// <summary>Zjistí, zda je variant hodnota prázdná nebo null.</summary>
/// <param name="Value">Hodnota k ověření.</param>
/// <returns>True, pokud je hodnota prázdná nebo null, jinak false.</returns>
function VarIsNE(Value: Variant): boolean;
/// <summary>Převede variant na desetinné číslo.</summary>
/// <param name="Value">Hodnota k převedení.</param>
/// <returns>Desetinné číslo nebo 0, pokud převod selže.</returns>
function VarToDouble(Value: Variant): double;
/// <summary>Převede variant na celé číslo.</summary>
/// <param name="Value">Hodnota k převedení.</param>
/// <returns>Celé číslo nebo 0, pokud převod selže.</returns>
function VarToInt(Value: Variant): integer;
/// <summary>Převede variant na boolean.</summary>
/// <param name="Value">Hodnota k převedení.</param>
/// <returns>Boolean hodnota nebo false, pokud převod selže.</returns>
function VarToBool(Value: Variant): boolean;

//date functions
/// <summary>Upraví datum tak, že doplní nuly u dne a měsíce.</summary>
/// <param name="ADat">Řetězec s datem (vstupní a výstupní parametr).</param>
/// <returns>True, pokud se úprava podařila, jinak false.</returns>
function CorrectDateString(var ADat: string): boolean;
//num functions
/// <summary>Opraví formát čísla v textu.</summary>
/// <param name="ANum">Řetězec s číslem (vstupní a výstupní parametr).</param>
/// <param name="AInteger">Pokud je true, očekává celé číslo, jinak desetinné.</param>
/// <returns>True, pokud se úprava podařila, jinak false.</returns>
function CorrectNumberString(var ANum: string; AInteger: boolean = FALSE): boolean;

//path and file functions
/// <summary>Normalizuje cestu (nahradí zpětná lomítka za obyčejná).</summary>
/// <param name="APathStr">Cesta k normalizaci.</param>
/// <returns>Normalizovaná cesta.</returns>
function NormalPath(const APathStr: string): string;
/// <summary>Vrací jedinečný název souboru v daném adresáři.</summary>
/// <param name="APath">Cesta k adresáři.</param>
/// <param name="AFileName">Základní název souboru.</param>
/// <returns>Jedinečný název souboru včetně cesty.</returns>
function GetUniqueFileName(const APath, AFileName: string): string;
/// <summary>Nahradí neplatné znaky ve jménu souboru znakem podtržítko.</summary>
/// <param name="AFileName">Název souboru k úpravě.</param>
/// <returns>Název souboru s nahrazenými neplatnými znaky.</returns>
function SetValidFileName(const AFileName: string): string;
/// <summary>Nahradí neplatné znaky a ořízne mezeru.</summary>
/// <param name="AFileName">Název souboru k úpravě.</param>
/// <returns>Název souboru s nahrazenými neplatnými znaky a oříznutými mezerami.</returns>
function SetValidFileNameTrim(const AFileName: string): string;
/// <summary>Smaže soubory podle masky v zadaném adresáři.</summary>
/// <param name="APath">Cesta k adresáři.</param>
/// <param name="AFileSpec">Maska souborů (např. "*.txt").</param>
procedure DeleteFiles(APath, AFileSpec: string);

//zaokrouhlovani
/// <summary>Zaokrouhlí číslo na nejbližší hodnotu podle zadaného počtu desetinných míst.</summary>
/// <param name="AValue">Hodnota k zaokrouhlení.</param>
/// <param name="ADigit">Počet desetinných míst (výchozí je -2, což znamená zaokrouhlení na nejbližší stovku).</param>
/// <returns>Zaokrouhlená hodnota.</returns>
function RoundAri(const AValue: extended;
  const ADigit: integer = -2): extended;
/// <summary>Zaokrouhlí desetinné číslo nahoru na zadaný počet desetinných míst.</summary>
/// <param name="AValue">Hodnota k zaokrouhlení.</param>
/// <param name="ADigit">Počet desetinných míst (výchozí je -2).</param>
/// <returns>Zaokrouhlená hodnota nahoru.</returns>
function RoundUp(const AValue: extended;
  const ADigit: integer = -2): extended;
/// <summary>Zaokrouhlí desetinné číslo dolů na zadaný počet desetinných míst.</summary>
/// <param name="AValue">Hodnota k zaokrouhlení.</param>
/// <param name="ADigit">Počet desetinných míst (výchozí je -2).</param>
/// <returns>Zaokrouhlená hodnota dolů.</returns>
function RoundDown(const AValue: extended;
  const ADigit: integer = -2): extended;
/// <summary>Zaokrouhlí desetinné číslo na nejbližší polovinu (0, 0.5 nebo 1).</summary>
/// <param name="AValue">Hodnota k zaokrouhlení.</param>
/// <returns>Zaokrouhlená hodnota na nejbližší polovinu.</returns>
function RoundHalfAri(const AValue: extended): extended;
/// <summary>Zaokrouhlí desetinné číslo na nejbližší polovinu, zaokrouhluje .01-.50 nahoru na .5 a .51-.99 nahoru na 1.</summary>
/// <param name="AValue">Hodnota k zaokrouhlení.</param>
/// <returns>Zaokrouhlená hodnota na nejbližší polovinu.</returns>
function RoundHalfUp(const AValue: extended): extended;

/// <summary>Vrací větší ze dvou čísel typu double.</summary>
/// <param name="A">První číslo.</param>
/// <param name="B">Druhé číslo.</param>
/// <returns>Větší z obou čísel.</returns>
function MaxFloat(A, B: double): double;
/// <summary>Vrací menší ze dvou čísel typu double.</summary>
/// <param name="A">První číslo.</param>
/// <param name="B">Druhé číslo.</param>
/// <returns>Menší z obou čísel.</returns>
function MinFloat(A, B: double): double;

//shell functions
/// <summary>Otevře soubor pomocí výchozí aplikace.</summary>
/// <param name="FileName">Cesta k souboru.</param>
procedure ShellOpen(const FileName: string);
/// <summary>Spustí soubor s parametry pomocí ShellExecute.</summary>
/// <param name="AFileName">Cesta k souboru.</param>
/// <param name="AParams">Parametry pro spuštění.</param>
procedure ShellExec(const AFileName: string; const AParams: string);
/// <summary>Otevře PDF dokument pomocí PDF čtečky.</summary>
/// <param name="AReaderExePath">Cesta k PDF čtečce.</param>
/// <param name="ADocumentName">Cesta k PDF dokumentu.</param>
/// <param name="ACmdType">Typ příkazu (otevření, tisk, atd.).</param>
/// <param name="AIniPath">Cesta k INI souboru s nastavením.</param>
/// <param name="ALicOk">Pokud je true, licence je platná.</param>
/// <returns>True, pokud se otevření podařilo, jinak false.</returns>
function ShellOpenPdf(const AReaderExePath, ADocumentName: string;
  ACmdType: TShellOpenCmdType; const AIniPath: string; ALicOk: boolean): boolean;
/// <summary>Spustí soubor a čeká na ukončení procesu.</summary>
/// <param name="AFileName">Cesta k souboru.</param>
/// <param name="AParams">Parametry pro spuštění.</param>
/// <param name="CmdShow">Příznak zobrazení okna (výchozí je SW_SHOWNORMAL).</param>
/// <returns>True, pokud se spuštění podařilo, jinak false.</returns>
function ShellOpenAndWait(AFileName: string; AParams: string = ''; CmdShow: Integer = SW_SHOWNORMAL): boolean;
{procedure ShellPrintPDF(const AFileName, ADirWorkPath: string);}
{function ShellExecuteAcrobatReader(const DocumentName: string): Boolean;}

//e-mail functions
/// <summary>Odešle e-mail s přílohami.</summary>
/// <param name="AAddress">E-mailová adresa příjemce.</param>
/// <param name="ASubject">Předmět e-mailu.</param>
/// <param name="ABody">Tělo e-mailu.</param>
/// <param name="AAttachments">Seznam příloh.</param>
/// <param name="AShowDialog">Pokud je true, zobrazí dialog pro úpravu před odesláním.</param>
/// <param name="AErrorMsg">Chybová zpráva, pokud došlo k chybě (výstupní parametr).</param>
/// <returns>True, pokud se odeslání podařilo, jinak false.</returns>
function SendEmail(AAddress, ASubject, ABody: string; AAttachments: TStringList;
  AShowDialog: boolean; out AErrorMsg: string): boolean;

//file functions
/// <summary>Vrací verzi aktuálního spuštěného assembly nebo zadaného souboru.</summary>
/// <param name="AFileName">Cesta k souboru (pokud je prázdná, použije se aktuální assembly).</param>
/// <returns>Verze programu jako řetězec.</returns>
function GetPrgVersion(AFileName: string = ''): string;
/// <summary>Vrátí jméno aktuálního uživatele Windows.</summary>
/// <returns>Jméno uživatele Windows.</returns>
function GetWinUserName: string;
/// <summary>Vyhledá všechny soubory dle masky a rekurzivně.</summary>
/// <param name="ADir">Cesta k adresáři.</param>
/// <param name="AMask">Maska souborů (např. "*.txt").</param>
/// <param name="AWithSubDirs">Pokud je true, vyhledává i v podadresářích.</param>
/// <returns>Seznam cest k souborům oddělených středníkem.</returns>
function SearchFiles(const ADir, AMask: string; AWithSubDirs: boolean): string;
/// <summary>Pokusí se smazat adresář i se soubory. Pokud se nepodaří, vrací false.</summary>
/// <param name="ADir">Cesta k adresáři.</param>
/// <param name="AWithSubDirs">Pokud je true, smaže i podadresáře.</param>
/// <param name="AMsg">Chybová zpráva, pokud došlo k chybě.</param>
/// <returns>True, pokud se smazání podařilo, jinak false.</returns>
function TryDeleteDirectory(const ADir: string; AWithSubDirs: boolean = false;
  const AMsg: string = ''): Boolean;

//printer functions
/// <summary>Vrátí název výchozí tiskárny.</summary>
/// <returns>Název výchozí tiskárny.</returns>
function DefaultPrinter: string;

//ulozeni strings do ini
/// <summary>Uloží seznam řádků do INI souboru jako jedna sekce.</summary>
/// <param name="AStrings">Seznam řádků k uložení.</param>
/// <param name="AIniFileName">Cesta k INI souboru.</param>
/// <param name="ASection">Název sekce.</param>
/// <param name="AIdent">Identifikátor pro uložení (např. "Item").</param>
procedure SaveStringsToIni(AStrings: TStrings;
  const AIniFileName, ASection, AIdent: string);
/// <summary>Načte řádky ze sekce z INI souboru.</summary>
/// <param name="AStrings">Seznam řádků k naplnění (výstupní parametr).</param>
/// <param name="AIniFileName">Cesta k INI souboru.</param>
/// <param name="ASection">Název sekce.</param>
/// <param name="AIdent">Identifikátor pro načtení (např. "Item").</param>
procedure LoadStringsFromIni(AStrings: TStrings;
  const AIniFileName, ASection, AIdent: string);

//bezpecne zapsani do ini
/// <summary>Bezpečně uloží TMemIniFile do souboru.</summary>
/// <param name="AIni">TMemIniFile objekt k uložení.</param>
/// <returns>True, pokud se uložení podařilo, jinak false.</returns>
function SaveMemIni(AIni: TMemIniFile): boolean;

//kontroly
/// <summary>Ověří platnost rodného čísla a vrátí datum narození.</summary>
/// <param name="ARodneCislo">Rodné číslo k ověření.</param>
/// <param name="ATestProDIC">Pokud je true, testuje i pro DIČ.</param>
/// <param name="ACheckECP">Pokud je true, kontroluje i ECP (elektronická čísla).</param>
/// <param name="ADatNar">Datum narození (výstupní parametr).</param>
/// <param name="AMsg">Chybová zpráva, pokud došlo k chybě (výstupní parametr).</param>
/// <returns>True, pokud je rodné číslo platné, jinak false.</returns>
function CheckRodneCisloDatNar(const ARodneCislo: string;
                               const ATestProDIC: boolean;
                               ACheckECP: boolean;
                               var ADatNar: TDateTime;
                               var AMsg: string): boolean;
/// <summary>Ověří platnost rodného čísla a vrátí chybovou zprávu.</summary>
/// <param name="ARodneCislo">Rodné číslo k ověření.</param>
/// <param name="AMsg">Chybová zpráva, pokud došlo k chybě (výstupní parametr).</param>
/// <param name="ATestProDIC">Pokud je true, testuje i pro DIČ (výchozí je false).</param>
/// <param name="ACheckECP">Pokud je true, kontroluje i ECP (elektronická čísla, výchozí je false).</param>
/// <returns>True, pokud je rodné číslo platné, jinak false.</returns>
function CheckRodneCisloMsg(const ARodneCislo: string;
                            var AMsg: string;
                            ATestProDIC: boolean = FALSE;
                            ACheckECP: boolean = FALSE): boolean;
/// <summary>Ověří platnost rodného čísla (český formát).</summary>
/// <param name="ARodneCislo">Rodné číslo k ověření.</param>
/// <param name="ATestProDIC">Pokud je true, testuje i pro DIČ (výchozí je false).</param>
/// <param name="ACheckECP">Pokud je true, kontroluje i ECP (elektronická čísla, výchozí je false).</param>
/// <returns>True, pokud je rodné číslo platné, jinak false.</returns>
function CheckRodneCislo(const ARodneCislo: string;
                         ATestProDIC: boolean = FALSE;
                         ACheckECP: boolean = FALSE): boolean;
/// <summary>Ověří platnost IČO (české identifikační číslo).</summary>
/// <param name="AIC">IČO k ověření.</param>
/// <returns>True, pokud je IČO platné, jinak false.</returns>
function CheckICO(const AIC: string): boolean;
/// <summary>Ověří platnost DIČ (CZ + IČO).</summary>
/// <param name="ADIC">DIČ k ověření.</param>
/// <param name="APravnickaOsoba">Pokud je true, kontroluje pro právnickou osobu (výchozí je false).</param>
/// <param name="ATestovatTypOsoby">Pokud je true, testuje typ osoby (výchozí je false).</param>
/// <returns>True, pokud je DIČ platné, jinak false.</returns>
function CheckDIC(const ADIC: string;
  APravnickaOsoba: boolean = FALSE; ATestovatTypOsoby: boolean = FALSE): boolean;
/// <summary>Ověří platnost slovenského DIČ.</summary>
/// <param name="ADIC">Slovenské DIČ k ověření.</param>
/// <returns>True, pokud je slovenské DIČ platné, jinak false.</returns>
function CheckSkDIC(const ADIC: string): boolean;
/// <summary>Ověří platnost slovenského IČDPH.</summary>
/// <param name="AICDPH">Slovenské IČDPH k ověření.</param>
/// <returns>True, pokud je slovenské IČDPH platné, jinak false.</returns>
function CheckSkICDPH(const AICDPH: string): boolean;
/// <summary>Ověří kontrolní číslici čísla účtu (český formát – základní účet bez předčíslí).</summary>
/// <param name="ABU">Číslo bankovního účtu k ověření.</param>
/// <returns>True, pokud je číslo účtu platné, jinak false.</returns>
function CheckBU(const ABU: string): boolean;
/// <summary>Ověří platnost IBANu podle kontrolního algoritmu.</summary>
/// <param name="IBAN">IBAN k ověření.</param>
/// <returns>True, pokud je IBAN platný, jinak false.</returns>
function CheckIBAN(IBAN: string): boolean;

//Zip
/// <summary>Vytvoří ZIP archiv ze zadaného souboru.</summary>
/// <param name="ASrcFileName">Cesta ke zdrojovému souboru.</param>
/// <param name="ADstFileName">Cesta k výstupnímu ZIP souboru.</param>
/// <param name="AComment">Komentář k ZIP souboru.</param>
/// <param name="APassword">Heslo pro zašifrování (pokud je prázdné, soubor není zašifrovaný).</param>
/// <returns>True, pokud se vytvoření ZIP archivu podařilo, jinak false.</returns>
function ZipFile(const ASrcFileName, ADstFileName, AComment: string;
  const APassword: string = ''): boolean;
/// <summary>Rozbalí ZIP archiv do zadané složky.</summary>
/// <param name="ASrcFileName">Cesta k ZIP souboru.</param>
/// <param name="ADstDir">Cílová složka pro rozbalení.</param>
/// <param name="APassword">Heslo pro rozbalení (pokud je prázdné, soubor není zašifrovaný).</param>
/// <returns>True, pokud se rozbalení podařilo, jinak false.</returns>
function UnzipFile(const ASrcFileName, ADstDir: string;
  APassword: string = ''): boolean;
/// <summary>Vrátí komentář z ZIP souboru.</summary>
/// <param name="AFileName">Cesta k ZIP souboru.</param>
/// <returns>Komentář z ZIP souboru nebo prázdný řetězec.</returns>
function GetZipFileComment(const AFileName: string): string;
/// <summary>Načte paměťovou tabulku ze ZIP archivu.</summary>
/// <param name="AMt">Paměťová tabulka k naplnění.</param>
/// <param name="AZipFileName">Cesta k ZIP souboru.</param>
/// <param name="APassword">Heslo pro rozbalení (pokud je prázdné, soubor není zašifrovaný).</param>
/// <returns>True, pokud se načtení podařilo, jinak false.</returns>
function LoadMemTableFromZip(AMt: TkbmMemTable; const AZipFileName: string;
  const APassword: string = ''): boolean;
/// <summary>Načte text ze souboru v ZIP archivu.</summary>
/// <param name="AZipFileName">Cesta k ZIP souboru.</param>
/// <param name="ATextFileName">Název textového souboru v ZIP archivu.</param>
/// <param name="AText">Načtený text (výstupní parametr).</param>
/// <param name="APassword">Heslo pro rozbalení (pokud je prázdné, soubor není zašifrovaný).</param>
/// <returns>True, pokud se načtení podařilo, jinak false.</returns>
function LoadTextFromZip(const AZipFileName, ATextFileName: string;
  out AText: string; const APassword: string = ''): boolean;

//ziskani z webu
/// <summary>Načte adresu z ARES registru podle IČO.</summary>
/// <param name="AICO">IČO subjektu.</param>
/// <param name="AProxyServer">Adresa proxy serveru.</param>
/// <param name="AProxyPort">Port proxy serveru.</param>
/// <param name="ATypOsoby">Typ osoby (výstupní parametr).</param>
/// <param name="ANazevFirmy">Název firmy (výstupní parametr).</param>
/// <param name="AUlice">Ulice (výstupní parametr).</param>
/// <param name="ACisloPop">Číslo popisné (výstupní parametr).</param>
/// <param name="ACisloOrientacni">Číslo orientační (výstupní parametr).</param>
/// <param name="AObec">Obec (výstupní parametr).</param>
/// <param name="APSC">PSČ (výstupní parametr).</param>
/// <param name="AMsg">Chybová zpráva, pokud došlo k chybě (výstupní parametr).</param>
/// <returns>True, pokud se načtení podařilo, jinak false.</returns>
function NactiAdresuZARES(const AICO: string; const AProxyServer, AProxyPort: string;
  out ATypOsoby, ANazevFirmy, AUlice, ACisloPop, ACisloOrientacni, AObec, APSC, AMsg: string): boolean;
/// <summary>Načte adresu a DIČ z ARES registru podle IČO.</summary>
/// <param name="AICO">IČO subjektu.</param>
/// <param name="AProxyServer">Adresa proxy serveru.</param>
/// <param name="AProxyPort">Port proxy serveru.</param>
/// <param name="ATypOsoby">Typ osoby (výstupní parametr).</param>
/// <param name="ANazevFirmy">Název firmy (výstupní parametr).</param>
/// <param name="AUlice">Ulice (výstupní parametr).</param>
/// <param name="ACisloPop">Číslo popisné (výstupní parametr).</param>
/// <param name="ACisloOrientacni">Číslo orientační (výstupní parametr).</param>
/// <param name="AObec">Obec (výstupní parametr).</param>
/// <param name="APSC">PSČ (výstupní parametr).</param>
/// <param name="ADIC">DIČ (výstupní parametr).</param>
/// <param name="AMsg">Chybová zpráva, pokud došlo k chybě (výstupní parametr).</param>
/// <returns>True, pokud se načtení podařilo, jinak false.</returns>
function NactiAdresuZARESD(const AICO: string; const AProxyServer, AProxyPort: string;
  out ATypOsoby, ANazevFirmy, AUlice, ACisloPop, ACisloOrientacni, AObec, APSC, ADIC, AMsg: string): boolean;
/// <summary>Načte data ze webového seznamu a převede je do CSV formátu.</summary>
/// <param name="AUrl">URL adresa webového seznamu.</param>
/// <param name="AColumns">Názvy sloupců k načtení (oddělené čárkou).</param>
/// <param name="AProxyServer">Adresa proxy serveru.</param>
/// <param name="AProxyPort">Port proxy serveru.</param>
/// <param name="AHeader">Hlavička CSV s názvy sloupců (výstupní parametr).</param>
/// <param name="AList">Seznam dat v CSV formátu (výstupní parametr).</param>
/// <param name="AMsg">Chybová zpráva, pokud došlo k chybě (výstupní parametr).</param>
/// <returns>True, pokud se načtení podařilo, jinak false.</returns>
function WebList2CSV(
  const AUrl, AColumns: string;
  const AProxyServer, AProxyPort: string;
  out AHeader: string;
  out AList: string;
  out AMsg: string): boolean;
/// <summary>Ověří, zda je počítač připojen k internetu pomocí síťového rozhraní.</summary>
/// <returns>True pokud je síťové připojení aktivní, jinak false.</returns>
function IsConnectedToInternet: boolean;
/// <summary>Načte dokument z HTTP adresy.</summary>
/// <param name="AHTTPAdress">HTTP adresa dokumentu.</param>
/// <param name="AProxyHost">Adresa proxy serveru (výchozí je prázdný řetězec).</param>
/// <param name="AProxyPort">Port proxy serveru (výchozí je prázdný řetězec).</param>
/// <returns>Obsah dokumentu nebo prázdný řetězec, pokud došlo k chybě.</returns>
function GetHTTPDocument(const AHTTPAdress: string;
  const AProxyHost: string = '';
  const AProxyPort: string = ''): string;
/// <summary>Ověří platnost DPH čísla přes VIES službu.</summary>
/// <param name="countrycode">Kód země (např. "CZ", "SK").</param>
/// <param name="vatno">DPH číslo k ověření.</param>
/// <param name="proxyAddress">Adresa proxy serveru.</param>
/// <param name="proxyPort">Port proxy serveru.</param>
/// <param name="vysledek">Výsledek kontroly (výstupní parametr).</param>
/// <returns>Kód výsledku: 0 = OK, jinak chyba.</returns>
function CheckVAT(countrycode:widestring; vatno:widestring;
  proxyAddress: string; proxyPort: string; out vysledek:string):integer;
/// <summary>Ověří platnost plátce DPH přes finanční úřad.</summary>
/// <param name="vatno">DPH číslo k ověření.</param>
/// <param name="proxyAddress">Adresa proxy serveru.</param>
/// <param name="proxyPort">Port proxy serveru.</param>
/// <param name="vysledek">Výsledek kontroly (výstupní parametr).</param>
/// <param name="ucty">Bankovní účty plátce (výstupní parametr).</param>
/// <returns>Kód výsledku: 0 = OK, jinak chyba.</returns>
function CheckPlatce(vatno:widestring; proxyAddress: string; proxyPort: string; out vysledek:string;  out ucty:string):integer;
/// <summary>Ověří platnost plátce DPH přes finanční úřad pomocí HTTPS.</summary>
/// <param name="vatno">DPH číslo k ověření.</param>
/// <param name="proxyAddress">Adresa proxy serveru.</param>
/// <param name="proxyPort">Port proxy serveru.</param>
/// <param name="vysledek">Výsledek kontroly (výstupní parametr).</param>
/// <param name="ucty">Bankovní účty plátce (výstupní parametr).</param>
/// <returns>Kód výsledku: 0 = OK, jinak chyba.</returns>
function CheckPlatceHttps(vatno:widestring;  proxyAddress: string; proxyPort: string; out vysledek:string;  out ucty:string):integer;

/// <summary>Vypočítá text pro QR kód s platebními údaji.</summary>
/// <param name="AIBAN">IBAN číslo účtu.</param>
/// <param name="ACastka">Částka platby.</param>
/// <param name="AMenaUctu">Měna účtu.</param>
/// <param name="APlatce">Název platce.</param>
/// <param name="AVarSym">Variabilní symbol.</param>
/// <param name="ASpecSym">Specifický symbol.</param>
/// <param name="AKonSym">Konstantní symbol.</param>
/// <param name="AZpravaPrijemci">Zpráva pro příjemce.</param>
/// <returns>Text pro QR kód.</returns>
function CalcQRCodeText(
  const AIBAN: string;
  const ACastka: double;
  const AMenaUctu, APlatce, AVarSym, ASpecSym, AKonSym, AZpravaPrijemci: string): string;
/// <summary>Převede české číslo bankovního účtu na IBAN.</summary>
/// <param name="ABU">Číslo bankovního účtu ve formátu "číslo/kód banky".</param>
/// <param name="AMenaUctu">Měna účtu (např. "CZK").</param>
/// <returns>IBAN číslo účtu.</returns>
function ConvertBU2IBAN(const ABU, AMenaUctu: string): string;
/// <summary>Zformátuje IBAN číslo do standardního formátu (po 4 znacích oddělených mezerou).</summary>
/// <param name="IBAN">IBAN číslo k formátování.</param>
/// <returns>Zformátované IBAN číslo.</returns>
function FormatIBAN(const IBAN: string): string;
{procedure CreateQRCode2File(
   const AFileNameQRC: string; //soubor s vytvorenym obrazkem s QRCode
   const AQRText: string;
   AWidth: integer = 200; AHeight: integer = 200);}

//ostatni
/// <summary>Vrátí datum narození z rodného čísla.</summary>
/// <param name="ARC">Rodné číslo.</param>
/// <param name="ACheckECP">Pokud je true, kontroluje i ECP (elektronická čísla, výchozí je false).</param>
/// <returns>Datum narození nebo DateTime.MinValue, pokud rodné číslo není platné.</returns>
function RCDatNar(ARC: string; ACheckECP: boolean = FALSE): TDateTime;
/// <summary>Vrátí kód pohlaví z rodného čísla ('M' nebo 'F').</summary>
/// <param name="ARC">Rodné číslo.</param>
/// <param name="ACheckECP">Pokud je true, kontroluje i ECP (elektronická čísla, výchozí je false).</param>
/// <returns>Kód pohlaví ('M' pro muž, 'F' pro žena) nebo prázdný řetězec, pokud rodné číslo není platné.</returns>
function RCToSexCode(ARC: string; ACheckECP: boolean = FALSE): string;
/// <summary>Vrací desetinnou část čísla jako řetězec (oddělovač .).</summary>
/// <param name="ANum">Číslo k převedení.</param>
/// <param name="ADigit">Počet desetinných míst (výchozí je -2).</param>
/// <returns>Desetinná část čísla jako řetězec.</returns>
function Frac2Str(ANum: double; ADigit: integer = -2): string;
/// <summary>Vrací celočíselnou část čísla jako řetězec.</summary>
/// <param name="ANum">Číslo k převedení.</param>
/// <param name="AFormatFloat">Pokud je true, formátuje výstup jako číslo (výchozí je true).</param>
/// <returns>Celočíselná část čísla jako řetězec.</returns>
function IntPart2Str(ANum: double; AFormatFloat: boolean = TRUE): string;
/// <summary>Vrátí hodnotu podle podmínky (ternární operátor).</summary>
/// <param name="ACond1">Podmínka k vyhodnocení.</param>
/// <param name="AValue1">Hodnota, pokud je podmínka true.</param>
/// <param name="AValueElse">Hodnota, pokud je podmínka false.</param>
/// <returns>Hodnota podle podmínky.</returns>
function Cond(ACond1: boolean; AValue1,
  AValueElse: Variant): Variant;
/// <summary>Vrátí hodnotu podle dvou podmínek.</summary>
/// <param name="ACond1">První podmínka k vyhodnocení.</param>
/// <param name="AValue1">Hodnota, pokud je první podmínka true.</param>
/// <param name="ACond2">Druhá podmínka k vyhodnocení.</param>
/// <param name="AValue2">Hodnota, pokud je druhá podmínka true.</param>
/// <param name="AValueElse">Hodnota, pokud jsou obě podmínky false.</param>
/// <returns>Hodnota podle podmínek.</returns>
function Cond2(ACond1: boolean; AValue1: Variant;
  ACond2: boolean; AValue2: Variant;
  AValueElse: Variant): Variant;
/// <summary>Vrátí hodnotu podle tří podmínek.</summary>
/// <param name="ACond1">První podmínka k vyhodnocení.</param>
/// <param name="AValue1">Hodnota, pokud je první podmínka true.</param>
/// <param name="ACond2">Druhá podmínka k vyhodnocení.</param>
/// <param name="AValue2">Hodnota, pokud je druhá podmínka true.</param>
/// <param name="ACond3">Třetí podmínka k vyhodnocení.</param>
/// <param name="AValue3">Hodnota, pokud je třetí podmínka true.</param>
/// <param name="AValueElse">Hodnota, pokud jsou všechny podmínky false.</param>
/// <returns>Hodnota podle podmínek.</returns>
function Cond3(ACond1: boolean; AValue1: Variant;
  ACond2: boolean; AValue2: Variant;
  ACond3: boolean; AValue3: Variant;
  AValueElse: Variant): Variant;
/// <summary>Vrátí hodnotu podle čtyř podmínek.</summary>
/// <param name="ACond1">První podmínka k vyhodnocení.</param>
/// <param name="AValue1">Hodnota, pokud je první podmínka true.</param>
/// <param name="ACond2">Druhá podmínka k vyhodnocení.</param>
/// <param name="AValue2">Hodnota, pokud je druhá podmínka true.</param>
/// <param name="ACond3">Třetí podmínka k vyhodnocení.</param>
/// <param name="AValue3">Hodnota, pokud je třetí podmínka true.</param>
/// <param name="ACond4">Čtvrtá podmínka k vyhodnocení.</param>
/// <param name="AValue4">Hodnota, pokud je čtvrtá podmínka true.</param>
/// <param name="AValueElse">Hodnota, pokud jsou všechny podmínky false.</param>
/// <returns>Hodnota podle podmínek.</returns>
function Cond4(ACond1: boolean; AValue1: Variant;
  ACond2: boolean; AValue2: Variant;
  ACond3: boolean; AValue3: Variant;
  ACond4: boolean; AValue4: Variant;
  AValueElse: Variant): Variant;
/// <summary>Vrátí hodnotu podle pěti podmínek.</summary>
/// <param name="ACond1">První podmínka k vyhodnocení.</param>
/// <param name="AValue1">Hodnota, pokud je první podmínka true.</param>
/// <param name="ACond2">Druhá podmínka k vyhodnocení.</param>
/// <param name="AValue2">Hodnota, pokud je druhá podmínka true.</param>
/// <param name="ACond3">Třetí podmínka k vyhodnocení.</param>
/// <param name="AValue3">Hodnota, pokud je třetí podmínka true.</param>
/// <param name="ACond4">Čtvrtá podmínka k vyhodnocení.</param>
/// <param name="AValue4">Hodnota, pokud je čtvrtá podmínka true.</param>
/// <param name="ACond5">Pátá podmínka k vyhodnocení.</param>
/// <param name="AValue5">Hodnota, pokud je pátá podmínka true.</param>
/// <param name="AValueElse">Hodnota, pokud jsou všechny podmínky false.</param>
/// <returns>Hodnota podle podmínek.</returns>
function Cond5(ACond1: boolean; AValue1: Variant;
  ACond2: boolean; AValue2: Variant;
  ACond3: boolean; AValue3: Variant;
  ACond4: boolean; AValue4: Variant;
  ACond5: boolean; AValue5: Variant;
  AValueElse: Variant): Variant;

/// <summary>Zkontroluje a opraví pozici formuláře na obrazovce.</summary>
/// <param name="ALeft">Levá pozice formuláře (vstupní a výstupní parametr).</param>
/// <param name="ATop">Horní pozice formuláře (vstupní a výstupní parametr).</param>
/// <param name="AWidth">Šířka formuláře.</param>
procedure CheckFormPosition(var ALeft, ATop: integer; AWidth: integer);
/// <summary>Vrátí typy fontů dostupné v systému.</summary>
/// <returns>Počet typů fontů nebo 0.</returns>
function GetFontTypes:Integer;
/// <summary>Vrátí DPI pro PDF renderování.</summary>
/// <returns>DPI pro PDF renderování.</returns>
function GetDPIForPDFRender: Integer;
/// <summary>Ověří platnost e-mailové adresy.</summary>
/// <param name="AEmailStr">E-mailová adresa k ověření.</param>
/// <param name="AIsMailList">Pokud je true, ověřuje seznam e-mailových adres oddělených čárkou nebo středníkem (výchozí je false).</param>
/// <returns>True, pokud je e-mailová adresa platná, jinak false.</returns>
function IsEmailValid(const AEmailStr: string; AIsMailList: Boolean = false): Boolean;
/// <summary>Ověří platnost ID datové schránky (český formát).</summary>
/// <param name="AIdds">ID datové schránky k ověření.</param>
/// <returns>True, pokud je ID datové schránky platné, jinak false.</returns>
function CheckIDDS(AIdds: string): boolean;


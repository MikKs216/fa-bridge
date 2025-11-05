interface

uses
  Dialogs, Messages, Windows, Controls, Classes, DB, FDlg, Res_FA, DKLicUtils,
  VersyPDF, VersyPDFTypes, StdCtrls, FileCtrl;

type
  TSlaveState = (ssNone, ssNew, ssOpen);
  TScriptState = (ssNoActive, ssCalculate, ssDefault, ssInit, ssEnable,
    ssCheck, ssLists, ssSysComment, ssCharacteristics, ssElFilling, ssPeriod,
    ssOnValidate, ssFieldChangeExit, ssSetMenuFunctions, ssMenuFunction,
    ssPaymentInfo, ssPaymentOrder, ssBeforePrint, ssBeforeSave,
    ssAfterLoadPage, ssDoEndShowChecking, ssDoClearFillingInfo, ssOnActivate);

const
  cFunctionVersion = 432; // zvysit pri doplneni nejakych funkci, nejlepe nastavit aktualni verzi bez tecek
  cMaxInt = 2147483647;

//specialni funkce pouzitelne pouze v odpovidajicich procedurach

/// <summary>Přiřadí hodnotu do zadaného údaje. Používá se v proceduře Calculate.</summary>
/// <param name="AFieldName">Název údaje, do kterého se má přiřadit hodnota.</param>
/// <param name="AValue">Hodnota k přiřazení.</param>
procedure Cal(const AFieldName: string; AValue: variant);

/// <summary>Přiřadí hodnotu do zadaného údaje s automatickým zaokrouhlením číselných hodnot podle počtu desetinných míst údaje. Používá se v proceduře Calculate.</summary>
/// <param name="AFieldName">Název údaje, do kterého se má přiřadit hodnota.</param>
/// <param name="AValue">Hodnota k přiřazení.</param>
procedure CalN(const AFieldName: string; AValue: variant);

/// <summary>Přiřadí výchozí hodnotu do údaje. Používá se v procedurách Default (pro aktuální údaj) nebo Init (pro všechny údaje).</summary>
/// <param name="AFieldName">Název údaje, do kterého se má přiřadit výchozí hodnota.</param>
/// <param name="AValue">Výchozí hodnota k přiřazení.</param>
procedure Ini(const AFieldName: string; AValue: variant);

/// <summary>Přiřadí výchozí hodnotu do údaje pouze v proceduře Init. Používá se v proceduře Init.</summary>
/// <param name="AFieldName">Název údaje, do kterého se má přiřadit výchozí hodnota.</param>
/// <param name="AValue">Výchozí hodnota k přiřazení.</param>
procedure Ino(const AFieldName: string; AValue: variant);

/// <summary>Přiřadí výchozí hodnotu do údaje pouze v proceduře Default. Používá se v proceduře Default.</summary>
/// <param name="AFieldName">Název údaje, do kterého se má přiřadit výchozí hodnota.</param>
/// <param name="AValue">Výchozí hodnota k přiřazení.</param>
procedure Def(const AFieldName: string; AValue: variant);

/// <summary>Povolí nebo zakáže údaj podle podmínky. Pokud je podmínka false, údaj se vyprázdní a zakáže. Používá se v proceduře Enable.</summary>
/// <param name="AFieldName">Název údaje, který se má povolit nebo zakázat.</param>
/// <param name="ACond">Pokud je true, údaj se povolí, pokud je false, údaj se zakáže a vyprázdní.</param>
procedure Ena(const AFieldName: string; ACond: boolean);

/// <summary>Přidá chybovou zprávu do kontrol, pokud je podmínka true. Používá se v proceduře Check.</summary>
/// <param name="AFieldName">Název údaje, ke kterému se má přidat kontrola.</param>
/// <param name="ACond">Pokud je true, přidá se chybová zpráva.</param>
/// <param name="AMsg">Text chybové zprávy.</param>
/// <param name="AKind">Typ zprávy: 0=chyba, 4=chyba EP, 5=varování EP (výchozí je 0).</param>
procedure Chk(const AFieldName: string; ACond: boolean; const AMsg: string;
  AKind: integer = 0);

/// <summary>Otevře seznam a přiřadí vybranou hodnotu do údaje. Používá se v proceduře Lists.</summary>
/// <param name="AFieldName">Název údaje, do kterého se má přiřadit hodnota ze seznamu.</param>
/// <param name="AListName">Název seznamu.</param>
/// <param name="AForDate">Datum, pro které se má seznam načíst.</param>
/// <param name="AListFieldName">Název pole v seznamu, jehož hodnota se má přiřadit.</param>
/// <param name="AColumns">Názvy sloupců k zobrazení v seznamu (oddělené čárkou).</param>
/// <param name="AFilter">Filtr pro seznam.</param>
procedure Lst(const AFieldName: string; const AListName: string;
  AForDate: TDateTime; const AListFieldName: string; const AColumns:string = '';
  const AFilter:string = '');

/// <summary>Otevře jednoduchý seznam a přiřadí vybranou hodnotu do údaje. Používá se v proceduře Lists.</summary>
/// <param name="AFieldName">Název údaje, do kterého se má přiřadit hodnota ze seznamu.</param>
/// <param name="AListValues">Seznam hodnot seznamu (oddělené čárkou).</param>
/// <param name="AColumnsWidth">Šířka jednotlivých sloupců v seznamu (v bodech, oddělené čárkou).</param>
/// <param name="AResultColumnIndex">Index údaje seznamu, jehož hodnota se vyplní do údaje formuláře po výběru (počítáno od 0).</param>
/// <param name="ACaption">Název seznamu.</param>
/// <param name="AColumnNames">Názvy sloupců v seznamu (oddělené čárkou).</param>
/// <param name="AInitValue">Počáteční hodnota, na kterou se má postavit kurzor při otevření.</param>
procedure SimpleLst(const AFieldName: string; const AListValues: string;
  const AColumnsWidth: string = ''; AResultColumnIndex: integer = 0;
  const ACaption: string = ''; const AColumnNames: string = '';
  const AInitValue: string = '');

/// <summary>Zkontroluje, zda je hodnota obsažena v jednoduchém seznamu.</summary>
/// <param name="AValue">Hodnota, která se má zkontrolovat.</param>
/// <param name="AListValues">Seznam hodnot seznamu (oddělené čárkou).</param>
/// <param name="AColumnIndex">Index sloupce v seznamu, ve kterém se má hledat (počítáno od 0).</param>
/// <returns>True, pokud je hodnota obsažena v seznamu, jinak false.</returns>
function IsValueInSimpleList(const AValue, AListValues: string;
  AColumnIndex: integer = 0): boolean;

/// <summary>Otevře jednoduchý seznam pro výběr hodnoty.</summary>
/// <param name="AListValues">Seznam hodnot seznamu.</param>
/// <param name="AValue">Hodnota na která se má postavit kurzor při otevření.</param>
/// <param name="AColumnsWidth">Šířka jednotlivých sloupců v seznamu (v bodech). Pokud je některá hodnota 0, tak se nastaví výchozí šířka, pokud je -1, tak se sloupec nezobrazí vůbec.</param>
/// <param name="AResultColumnIndex">Index údaje seznamu, jehož hodnota se vyplní do údaje formuláře po výběru (počítáno od 0).</param>
/// <param name="ACaption">Název seznamu.</param>
/// <param name="AColumnNames">Názvy sloupců v seznamu.</param>
/// <returns>Hodnotu vybraného údaje.</returns>
function DoOpenSimpleList(const AListValues: string; AValue: string;
  const AColumnsWidth: string = ''; AResultColumnIndex: integer = 0;
  const ACaption: string = ''; const AColumnNames: string = ''): variant;

//obecne pouzitelne funkce ve scriptu

//skok na udaj
/// <summary>Přesune fokus na zadaný údaj (může být i na jiné stránce).</summary>
procedure GotoFld(const AFieldName: string);

/// <summary>Přesune fokus na přílohy formuláře.</summary>
procedure GotoAppendix;

//nacteni hodnoty ze seznamu
/// <summary>Načte hodnotu ze seznamu podle zadaných klíčových polí.</summary>
/// <param name="AListName">Název seznamu.</param>
/// <param name="AForDate">Datum, pro které se má seznam načíst.</param>
/// <param name="AKeyFieldNames">Názvy klíčových polí oddělené středníkem.</param>
/// <param name="AkeyFieldValues">Hodnoty klíčových polí (pole variant).</param>
/// <param name="AResultFieldName">Název pole, jehož hodnotu chceme získat.</param>
/// <returns>Hodnotu zadaného pole ze seznamu, nebo null pokud nebyl nalezen záznam.</returns>
function LstLookup(const AListName: string; AForDate: TDateTime;
  AKeyFieldNames: string; AkeyFieldValues: variant;
  const AResultFieldName: string): variant;

//nacteni nejblizsi hodnoty ze seznamu
/// <summary>Načte nejbližší hodnotu ze seznamu podle zadaných klíčových polí (sestupně podle data).</summary>
/// <param name="AListName">Název seznamu.</param>
/// <param name="AForDate">Datum, pro které se má seznam načíst.</param>
/// <param name="AKeyFieldNames">Názvy klíčových polí oddělené středníkem.</param>
/// <param name="AkeyFieldValues">Hodnoty klíčových polí (array of const).</param>
/// <param name="AResultFieldName">Název pole, jehož hodnotu chceme získat.</param>
/// <returns>Hodnotu zadaného pole ze seznamu, nebo null pokud nebyl nalezen záznam.</returns>
function LstLookupNearest(const AListName: string; AForDate: TDateTime;
  AKeyFieldNames: string; AkeyFieldValues: array of const;
  const AResultFieldName: string): variant;

//nacteni nejblizsi hodnoty ze seznamu - jednodussi varianta
/// <summary>Načte nejbližší hodnotu ze seznamu podle zadaných klíčových polí (používá dnešní datum, sestupně).</summary>
/// <param name="AListName">Název seznamu.</param>
/// <param name="AKeyFieldNames">Názvy klíčových polí oddělené středníkem.</param>
/// <param name="AkeyFieldValues">Hodnoty klíčových polí (array of const).</param>
/// <param name="AResultFieldName">Název pole, jehož hodnotu chceme získat.</param>
/// <returns>Hodnotu zadaného pole ze seznamu, nebo null pokud nebyl nalezen záznam.</returns>
function LstLookupNear(const AListName: string;
  AKeyFieldNames: string; AkeyFieldValues: array of const;
  const AResultFieldName: string): variant;

//nacteni nejblizsi hodnoty ze seznamu - jednodussi varianta, vzestupne trideni
/// <summary>Načte nejbližší hodnotu ze seznamu podle zadaných klíčových polí (používá dnešní datum, vzestupně).</summary>
/// <param name="AListName">Název seznamu.</param>
/// <param name="AKeyFieldNames">Názvy klíčových polí oddělené středníkem.</param>
/// <param name="AkeyFieldValues">Hodnoty klíčových polí (array of const).</param>
/// <param name="AResultFieldName">Název pole, jehož hodnotu chceme získat.</param>
/// <returns>Hodnotu zadaného pole ze seznamu, nebo null pokud nebyl nalezen záznam.</returns>
function LstLookupNearAscending(const AListName: string;
  AKeyFieldNames: string; AkeyFieldValues: array of const;
  const AResultFieldName: string): variant;

//vyber hodnoty ze seznamu
/// <summary>Otevře modální okno se seznamem a vrátí vybranou hodnotu.</summary>
/// <param name="AListName">Název seznamu.</param>
/// <param name="AForDate">Datum, pro které se má seznam načíst.</param>
/// <param name="AKeyFieldNames">Názvy klíčových polí oddělené středníkem.</param>
/// <param name="AkeyFieldValues">Hodnoty klíčových polí (variant).</param>
/// <param name="AResultFieldName">Název pole, jehož hodnotu chceme získat.</param>
/// <param name="AColumns">Názvy sloupců k zobrazení v seznamu (oddělené čárkou).</param>
/// <returns>Hodnotu zadaného pole ze seznamu, nebo null pokud uživatel zrušil výběr.</returns>
function OpenLst(const AListName: string; AForDate: TDateTime;
  AKeyFieldNames: string; AkeyFieldValues: variant;
  const AResultFieldName: string; const AColumns:string = ''): variant;

//dalsi funkce na seznamy
{unction GetLstTable(AListName:string; ADate:TDateTime;
  out ATable: TTable):boolean;}
/// <summary>Načte data ze webového seznamu a převede je do CSV formátu.</summary>
/// <param name="AUrl">URL adresa webového seznamu.</param>
/// <param name="AColumns">Názvy sloupců k načtení (oddělené čárkou).</param>
/// <param name="AHeader">Hlavička CSV s názvy sloupců (výstupní parametr).</param>
/// <param name="AList">Seznam dat v CSV formátu (výstupní parametr).</param>
/// <param name="AMsg">Chybová zpráva, pokud došlo k chybě (výstupní parametr).</param>
/// <returns>True, pokud se načtení podařilo, jinak false.</returns>
function WebList2CSV(
  const AUrl, AColumns: string;
  var AHeader: string;
  var AList: string;
  var AMsg: string): boolean;

/// <summary>Načte seznam do pracovní tabulky (wt1 až wt9).</summary>
/// <param name="AListName">Název seznamu.</param>
/// <param name="AForDate">Datum, pro které se má seznam načíst.</param>
/// <param name="AWtNumber">Číslo pracovní tabulky (1 až 9).</param>
/// <returns>True, pokud se načtení podařilo, jinak false.</returns>
function LoadListToWT(const AListName: string; AForDate: TDateTime; AWtNumber: Integer): boolean;

//nacteni informace o klientovi
/// <summary>Zjištění hodnoty z nastavení klienta, případně i dalších, které jsou předávány z FS do FA.</summary>
/// <param name="AParamName">Název parametru.</param>
/// <param name="ABankAccountIndex">Pořadové číslo bankovního účtu, pokud má uživatel zadáno víc účtů.</param>
/// <returns>Řetězcovou hodnotu parametru.</returns>
function ClientParam(AParamName: string; ABankAccountIndex: integer = 0):
  string;

/// <summary>Vrátí všechny parametry klienta jako text.</summary>
/// <returns>Textový seznam všech parametrů klienta.</returns>
function GetClientParams: string;

//zjisteni existence formulare
/// <summary>Zjistí, zda formulář s daným názvem existuje.</summary>
/// <param name="AFormName">GUID nebo cesta k formuláři.</param>
/// <returns>True, pokud formulář existuje, jinak false.</returns>
function FormExists(const AFormName: string): boolean;

//nacteni dat jineho formulare
/// <summary>Vrací data zadaného formuláře. Když je AFormName prázdné, tak data vlastního formuláře.</summary>
/// <param name="AFormName">GUID nebo cesta k formuláři. Může se získat výběrem pomocí funkce GetForms.</param>
/// <returns>Data zadaného formuláře v interním formátu (jako se ukládá do FRM).</returns>
function GetFormDataText(const AFormName: string): string;

//nacteni udaje z jineho formulare
/// <summary>Vrací hodnotu jednoho údaje formuláře.</summary>
/// <param name="AFormName">GUID nebo cesta k formuláři.</param>
/// <param name="AFieldName">Název údaje.</param>
/// <returns>Hodnota údaje převedená na řetězec.</returns>
function GetFormField(const AFormName: string;
  const AFieldName: string): string;

/// <summary>Nastaví textovou hodnotu udaje v datech předaných v parametru ADataString.</summary>
/// <param name="ADataString">Data formuláře v interním formátu (jako ve FRM).</param>
/// <param name="AFieldName">Název údaje.</param>
/// <param name="AFieldValue">Hodnota údaje.</param>
/// <returns>Vrací data z parametru ADataString se změněnou hodnotou údaje.</returns>
function SetDataFormField(const ADataString: string;
  const AFieldName, AFieldValue: string): string;

//nacteni vice udajue z jineho formulare
/// <summary>Načte hodnoty více údajů z jiného formuláře do aktuálního formuláře.</summary>
/// <param name="AFormName">GUID nebo cesta k formuláři, ze kterého se mají načíst údaje.</param>
/// <param name="AFieldList">Seznam názvů údajů k načtení (oddělené čárkou).</param>
/// <param name="AExcudeFieldList">Seznam názvů údajů, které se mají vyloučit z načtení (oddělené čárkou).</param>
procedure TakeFormFields(const AFormName: string;
  const AFieldList: string; const AExcudeFieldList: string = '');

//vyber z formularu
/// <summary>Otevře dialog pro výběr formulářů a vrátí seznam GUID vybraných formulářů.</summary>
/// <param name="ADefID">ID definic formulářů (oddělené čárkou).</param>
/// <param name="AMultiselect">Pokud je true, umožní výběr více formulářů.</param>
/// <param name="ACaption">Název dialogu.</param>
/// <param name="AOrder">Řazení formulářů.</param>
/// <returns>Seznam GUID vybraných formulářů (oddělené odřádkováním).</returns>
function GetForms(const ADefID: string; AMultiselect: boolean = FALSE;
  const ACaption: string = '';AOrder: string = ''): string;

/// <summary>Zjistí počet vytvořených formulářů zadaných definic.</summary>
/// <param name="ADefID">ID definic (oddělené čárkou).</param>
/// <returns>Počet formulářů.</returns>
function GetFormCount(const ADefID: string): integer;

/// <summary>Otevře dialog pro výběr formulářů nebo dokumentů. Výstupní hodnoty jsou v globálních proměnných GfodFrmID, GfodFrmDefID, GfodDocId, GfodFiles, GfodGUID.</summary>
/// <param name="AMultiSelect">Pokud je true, umožní výběr více položek.</param>
/// <param name="ACaption">Název dialogu.</param>
/// <param name="ASelectDefId">ID definic formulářů k výběru.</param>
/// <param name="AShowFrm">Pokud je true, zobrazí záložku formulářů.</param>
/// <param name="AShowDoc">Pokud je true, zobrazí záložku dokumentů.</param>
/// <param name="AShowOpenDlg">Pokud je true, zobrazí dialog pro výběr souborů.</param>
/// <param name="AShowBtnZrusit">Pokud je true, zobrazí tlačítko Zrušit.</param>
/// <returns>True, pokud uživatel vybral nějakou položku, jinak false.</returns>
function GetFormsOrDocuments(AMultiSelect: boolean = FALSE;
  ACaption: string = '';
  ASelectDefId: string = '';
  AShowFrm: boolean = true;
  AShowDoc: boolean = false;
  AShowOpenDlg: boolean = false;
  AShowBtnZrusit: Boolean = True
  ): boolean;

/// <summary>Načte dokument z archivu podle ID dokumentu.</summary>
/// <param name="AIDDoc">ID dokumentu v archivu.</param>
/// <returns>GUID nebo cesta k dokumentu, nebo prázdný řetězec pokud dokument neexistuje.</returns>
function  GetDoc(AIDDoc: integer): string;

/// <summary>Zjistí, zda aplikace běží jako standalone aplikace.</summary>
/// <returns>True, pokud aplikace běží jako standalone, jinak false.</returns>
function RunAsStandalone: boolean;

/// <summary>Zobrazí dialog s výsledky kontrol formuláře.</summary>
/// <param name="AShowOK">Pokud je true, zobrazí i úspěšné kontroly.</param>
/// <param name="AShowDifs">Pokud je true, zobrazí rozdíly.</param>
/// <param name="AForceTipEP">Pokud je true, vynutí tip pro EP.</param>
/// <returns>True, pokud uživatel potvrdil, jinak false.</returns>
function ShowChecking(AShowOK: boolean = FALSE;
  AShowDifs: boolean = FALSE; AForceTipEP: Boolean = FALSE): boolean;

/// <summary>Zobrazí výsledky kontrol formuláře.</summary>
procedure DisplayCheck;

/// <summary>Načte algoritmus výkazu podle ID výkazu.</summary>
/// <param name="AVykazID">ID výkazu.</param>
/// <param name="AVTisicich">Pokud je true, vrací algoritmus ve formátu pro tisíce.</param>
/// <returns>Algoritmus výkazu.</returns>
function GetAlgVykaz(const AVykazID: string; AVTisicich: boolean): string;

/// <summary>Zjistí, zda výkaz s daným ID existuje.</summary>
/// <param name="AVykazID">ID výkazu.</param>
/// <returns>True, pokud výkaz existuje, jinak false.</returns>
function VykazExists(const AVykazID: string): boolean;

//zapis zaznamu do platebniho kalendare
/// <summary>Uloží do platebního kalendáře záznam pro platbu.</summary>
/// <param name="ADatePayment">Datum platby.</param>
/// <param name="AText">Předmět platby.</param>
/// <param name="AValue">Částka.</param>
/// <param name="AAccount">Číslo bankovního účtu.</param>
/// <param name="ABank">Kód banky.</param>
/// <param name="ASpecSym">Specifický symbol.</param>
/// <param name="AVarSym">Variabilní symbol.</param>
/// <param name="AKonSym">Konstantní symbol.</param>
/// <param name="AIBAN">IBAN.</param>
/// <param name="ASwift">Swift.</param>
/// <returns>Vrací TRUE pokud se záznam podařilo uložit.</returns>
function SavePaymentRec(ADatePayment: TDateTime;
  const AText: string; AValue: double;
  const AAccount: string='';
  const ABank: string='';
  const ASpecSym: string='';
  const AVarSym: string='';
  const AKonSym: string='';
  const AIBAN: string='';
  const ASwift: string=''): boolean;

/// <summary>Vytvoří formulář příkaz k úhradě a otevře jej.</summary>
/// <param name="ADatePayment">Datum platby.</param>
/// <param name="AValue">Částka.</param>
/// <param name="AAccount">Číslo bankovního účtu včetně kódu banky.</param>
/// <param name="AVarSym">Variabilní symbol.</param>
/// <param name="AConSym">Konstantní symbol.</param>
/// <param name="ASpecSym">Specifický symbol.</param>
/// <param name="AText">Předmět platby.</param>
/// <param name="APaymentOrderDefID">ID definice formuláře, pokud není zadáno vezme se předdefinovaný vzor.</param>
procedure CreatePaymentOrder(ADatePayment: TDateTime; AValue: double;
  const AAccount, AVarSym, AConSym, ASpecSym, AText: string;
  APaymentOrderDefID: string = '');

/// <summary>Vytvoří formulář SEPA příkaz k úhradě a otevře jej.</summary>
/// <param name="ADatePayment">Datum platby.</param>
/// <param name="AValue">Částka.</param>
/// <param name="AIban">IBAN.</param>
/// <param name="ASwift">SWIFT.</param>
/// <param name="AVarSym">Variabilní symbol.</param>
/// <param name="AConSym">Konstantní symbol.</param>
/// <param name="ASpecSym">Specifický symbol.</param>
/// <param name="APrijemce">Název příjemce platby.</param>
/// <param name="AReference">Reference platby (var.sym.).</param>
/// <param name="AInformace">Text.</param>
/// <param name="APlatebniTitul">Předmět platby.</param>
/// <param name="APaymentOrderDefID">ID definice formuláře, pokud není zadáno vezme se předdefinovaný vzor.</param>
/// <param name="ASenderIban">IBAN odesílatele.</param>
/// <param name="ASenderSwift">SWIFT odesílatele.</param>
procedure CreatePaymentOrderSEPA(ADatePayment: TDateTime; AValue: double;
  const AIban, ASwift, AVarSym: string;
  AConSym: string = '';
  ASpecSym: string = '';
  APrijemce: string = '';
  AReference: string = '';
  AInformace: string = '';
  APlatebniTitul: string = '';
  APaymentOrderDefID: string = '';
  ASenderIban: string = '';
  ASenderSwift: string = '');

/// <summary>Vytvoří nový formulář a otevře jej. Vrací GUID vytvořeného formuláře.</summary>
/// <param name="ADefID">ID definice formuláře.</param>
/// <param name="AData">Data formuláře v interním formátu.</param>
/// <returns>GUID vytvořeného formuláře.</returns>
function CreateOpenNewForm(const ADefID, AData: string): string;

/// <summary>Otevření formuláře.</summary>
/// <param name="AGuidOrStandaloneFileName">GUID formuláře ve FS nebo cesta k datům ve FA.</param>
procedure OpenSavedForm(const AGuidOrStandaloneFileName: string);

/// <summary>Uloží záznam o zastoupení do archivu.</summary>
/// <param name="AType">Typ zastoupení (např. "Plná moc", "Mandátní smlouva").</param>
/// <param name="AForOffice">Instituce, vůči které je zastoupení (např. "FU", "ZP", "CU", "SSP").</param>
/// <param name="ASubject">Předmět zastoupení.</param>
/// <param name="AGeneration">True, pokud jde o generální plnou moc.</param>
/// <param name="AValidityFrom">Platnost zastoupení od.</param>
/// <param name="AValidityTo">Platnost zastoupení do.</param>
/// <param name="AComment">Poznámka.</param>
procedure SaveRepresentationRec(
  const AType: string;
  const AForOffice: string;
  const ASubject: string;
  const AGeneration: boolean;
  const AValidityFrom: TDateTime;
  const AValidityTo: TDateTime;
  const AComment: string);

/// <summary>Aktualizace univerzálních parametrů klienta. Vytvoří nový parametr nebo aktualizuje již existující.</summary>
/// <param name="AParamId">ID parametru.</param>
/// <param name="ASkupina">Skupina parametru - popis.</param>
/// <param name="APopis">Popis parametru.</param>
/// <param name="AHodnota">Hodnota parametru.</param>
procedure UniParUpdate(
  const AParamId: string;
  const ASkupina: string;
  const APopis: string;
  const AHodnota: string);

/// <summary>Sváže formulář AFrmGUID s formulářem AMasterGUID.</summary>
/// <param name="AFrmGUID">Přivzovaný formulář.</param>
/// <param name="AMasterGUID">GUID nadřízeného formuláře.</param>
/// <param name="AMsgErr">Chybová zpráva, pokud nedošlo k zápisu.</param>
procedure FormBind(
  const AFrmGUID: string;
  const AMasterGUID: string;
  var AMsgErr: string);

/// <summary>Zapíše hodnotu do zadaného údaje formuláře.</summary>
/// <param name="AFrmGUID">GUID formuláře.</param>
/// <param name="AFieldName">Název údaje, do kterého se má zapsat hodnota.</param>
/// <param name="AValue">Hodnota k zápisu.</param>
/// <param name="AMsgErr">Chybová zpráva, pokud došlo k chybě (výstupní parametr).</param>
/// <returns>True, pokud se zápis podařil, jinak false.</returns>
function WriteValue2Form(
  const AFrmGUID: string;
  const AFieldName: string;
  const AValue: string;
  var AMsgErr: string): boolean;

//pridani radku do stringu
/// <summary>Do textu AStr přidá řádek AAddedStrLine.</summary>
/// <param name="AStr">Text do kterého se řádek přidává.</param>
/// <param name="AAddedStrLine">Přidávaný řádek.</param>
procedure AddStrLine(var AStr: string; const AAddedStrLine: string);

//slozeni data ze dne, mesice a roku
/// <summary>Vytvoří datum ze zadaných hodnot.</summary>
/// <param name="AYear">Rok (0 znamená aktuální rok).</param>
/// <param name="AMonth">Měsíc (1 až 12, výchozí je 1).</param>
/// <param name="ADay">Den (1 až 31, výchozí je 1).</param>
/// <returns>Datum vytvořené ze zadaných hodnot.</returns>
function EncDate(AYear: Word = 0; AMonth: Word = 1; ADay: Word = 1): TDateTime;

/// <summary>Spojí části adresy do jednoho řetězce.</summary>
/// <param name="AUlice">Ulice.</param>
/// <param name="ACisloPopisne">Číslo popisné.</param>
/// <param name="APOBox">PO Box.</param>
/// <param name="APSC">PSČ.</param>
/// <param name="AMisto">Místo.</param>
/// <param name="AOkres">Okres.</param>
/// <param name="AStat">Stát.</param>
/// <param name="AMultiLine">Pokud je True, tak za každou část vloží odřádkování, jinak části oddělí čárkou.</param>
/// <returns>Vytvořený řetězec adresy.</returns>
function CalcFullAddress(const AUlice, ACisloPopisne, APOBox,
  APSC, AMisto, AOkres, AStat: string;
  AMultiLine: boolean): string;

/// <summary>Spojí jméno, příjmení a další části do jednoho řetězce.</summary>
/// <param name="ATitul">Titul.</param>
/// <param name="AJmeno">Jméno.</param>
/// <param name="APrijmeni">Příjmení.</param>
/// <param name="ARodnePrijmeni">Rodné příjmení.</param>
/// <param name="AHodnost">Titul za jménem (např. Csc.).</param>
/// <returns>Spojené jméno.</returns>
function CalcFullName(const ATitul, AJmeno, APrijmeni,
  ARodnePrijmeni: string;
  AHodnost: string = ''): string;

/// <summary>Vybere telefon nebo mobil. Telefon má přednost.</summary>
/// <param name="ATelefon">Telefon.</param>
/// <param name="AMobil">Mobil.</param>
/// <returns>Vrací Atelefon, pokud je zadáno, jinak Amobil.</returns>
function CalcPhoneMobil(const ATelefon, AMobil: string): string;

/// <summary>Vrátí část textu před prvním výskytem zadaného znaku. Pokud znak není nalezen, vrací prázdný řetězec.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="AChar">Znak, před kterým se má část vyjmout (výchozí je '/').</param>
/// <returns>Část řetězce před zadaným znakem, nebo prázdný řetězec.</returns>
function ExtractBeforeChar(const AStr: string; const AChar: string = '/'):
  string;

/// <summary>Vrátí část textu za prvním výskytem zadaného znaku. Pokud znak není nalezen, vrací celý vstupní text.</summary>
/// <param name="AStr">Vstupní text.</param>
/// <param name="AChar">Znak, za kterým se má část vyjmout (výchozí je '/').</param>
/// <returns>Část řetězce za zadaným znakem, nebo celý vstupní text.</returns>
function ExtractAfterChar(const AStr: string; const AChar: string = '/'):
  string;

/// <summary>Spojí bankovní účet, kód banky a příp. spec. symbol do jednoho řetězce.</summary>
/// <param name="ABankAccount">Číslo účtu.</param>
/// <param name="ABankCode">Kód banky.</param>
/// <param name="ASpecSym">Specifický symbol.</param>
/// <returns>Spojený celý bankovní účet (např. 123465/0300).</returns>
function CalcFullBaAccount(const ABankAccount, ABankCode: string;
  ASpecSym: string = ''): string;

/// <summary>Rozdělí adresu do jednotlivých částí.</summary>
/// <param name="AAdresa">Celá adresa.</param>
/// <param name="AUlice">Ulice.</param>
/// <param name="APSC">PSČ.</param>
/// <param name="AMisto">Místo.</param>
procedure SplitAddress(const AAdresa: string; out AUlice, APSC, AMisto: string);

/// <summary>Vytáhne ulici z adresy.</summary>
/// <param name="AAdresa">Celá adresa.</param>
/// <returns>Vrací ulici.</returns>
function StreetFromAddress(AAdresa: string): string;

/// <summary>Vytáhne PSČ z adresy.</summary>
/// <param name="AAdresa">Celá adresa.</param>
/// <returns>Vrací PSČ.</returns>
function ZipCodeFromAddress(const AAdresa: string): string;

/// <summary>Vytáhne místo z adresy.</summary>
/// <param name="AAdresa">Celá adresa.</param>
/// <returns>Vrací místo (obec).</returns>
function CityFromAddress(const AAdresa: string): string;

/// <summary>Zformátuje PSČ na tvar xxx xx. Pokud je text delší než 6 znaků, tak vrací beze změn.</summary>
/// <param name="APSC">PSČ bez mezer (nebo ZIP kód pro jiné státy).</param>
/// <returns>Formátované PSČ.</returns>
function NormalZipCodeCzech(APSC: string): string;

/// <summary>Vytáhne bankovní účet z řetězce, kde je účet / kód banky.</summary>
/// <param name="ABankAccount">Celý bankovní účet.</param>
/// <returns>Část bankovního účtu bez kódu banky.</returns>
function ExtractBankAccount(const ABankAccount: string): string;

/// <summary>Vytáhne kód banky z řetězce, kde je účet / kód banky.</summary>
/// <param name="ABankAccount">Celý bankovní účet.</param>
/// <returns>Kód banky.</returns>
function ExtractBankCode(const ABankAccount: string): string;

/// <summary>Vytáhne ulici z řetězce, kde je ulice a číslo popisné.</summary>
/// <param name="AStreetAndNum">Text obsahující ulici a číslo.</param>
/// <returns>Vrací ulici bez čísla.</returns>
function ExtractStreetFromStreetAndNum(AStreetAndNum: string): string;

/// <summary>Vytáhne číslo popisné z řetězce, kde je ulice a číslo popisné.</summary>
/// <param name="AStreetAndNum">Text obsahující ulici a číslo.</param>
/// <returns>Číslo popisné/orientační.</returns>
function ExtractNumberFromStreetAndNum(AStreetAndNum: string): string;

/// <summary>Vrací název měsíce podle čísla měsíce. Lze volit, zda má být malými písmeny.</summary>
/// <param name="AMonth">Číslo měsíce (1 až 12).</param>
/// <param name="ALowerCase">Pokud je true, vrací název měsíce malými písmeny.</param>
/// <returns>Název měsíce nebo prázdný řetězec, pokud číslo není v rozsahu 1–12.</returns>
function NameOfMonth(AMonth: integer; ALowerCase: boolean = FALSE): string;

/// <summary>Jméno měsíce ve druhém pádu (Ledna, Února ...).</summary>
/// <param name="AMonth">Pořadové číslo měsíce (1 až 12).</param>
/// <param name="ALowerCase">True, pokud má být jméno měsíce s malým písmenem na začátku.</param>
/// <returns>Jméno měsíce.</returns>
function NameOfMonth2(AMonth: integer; ALowerCase: boolean = FALSE): string;

/// <summary>Ověří validitu a převede na formát dd.MM.yyyy.</summary>
/// <param name="ADate">Datum k převedení.</param>
/// <param name="ADateString">Alternativní řetězec s datem (pokud je prázdný, použije se ADate).</param>
/// <returns>Datum převedené na text ve formátu dd.MM.yyyy, nebo prázdný řetězec pokud datum není platné.</returns>
function GetValidDateStr(ADate: TDateTime; ADateString: string = ''): string;

/// <summary>Ověří validitu a převede datum na zadaný formát.</summary>
/// <param name="ADate">Datum k převedení.</param>
/// <param name="AFmt">Cílový formát (výchozí je 'DD.MM.YYYY').</param>
/// <returns>Datum převedené na text ve zadaném formátu, nebo prázdný řetězec pokud datum není platné.</returns>
function GetValidDateStrFmt(ADate: TDateTime;
  AFmt: string = 'DD.MM.YYYY'): string;

/// <summary>Vrátí hodnotu, pokud jsou všechny zadané údaje prázdné, jinak vrací null. Pokud je AZeroValueClear true a hodnota je 0, vrací null.</summary>
/// <param name="ASrcFieldNames">Seznam názvů údajů oddělených čárkou, které se mají zkontrolovat.</param>
/// <param name="AValue">Hodnota, která se má vrátit, pokud jsou všechny údaje prázdné.</param>
/// <param name="AZeroValueClear">Pokud je true a hodnota je 0, vrací null.</param>
/// <returns>Hodnotu AValue, pokud jsou všechny údaje prázdné, jinak null.</returns>
function ValidValue(const ASrcFieldNames: string; AValue: Variant;
  AZeroValueClear: boolean = FALSE): Variant;

/// <summary>Vyprázdní zadaný údaj.</summary>
/// <param name="AFieldName">Název údaje, který se má vyprázdnit.</param>
procedure ClearField(const AFieldName: string);

/// <summary>Vrátí normalizovaný text pro předání ve funkci Period podle zadaného období ve tvaru: 'yyyy' - rok, 'yyyy,n' - rok n-tý měsíc, 'yyyy,n,q' - rok n-té čtvrtletí, 'dd.mm.yyyy' - datum, 'dd.mm.yyyy,dd.mm.yyyy' - období od data do data, '' - nezadané datum - vrátí dnešní datum.</summary>
/// <param name="APeriod">Datum nebo období.</param>
/// <returns>Normalizovaný text pro funkci Period.</returns>
function CalcPeriod(const APeriod: string): string;

/// <summary>Zobrazí náhled jednoduché sestavy.</summary>
/// <param name="AReportName">Název sestavy.</param>
procedure PreviewSimpleReport(const AReportName: string);

/// <summary>Zobrazí instrukci pro zadaný údaj.</summary>
/// <param name="AFieldName">Název údaje, pro který se má zobrazit instrukce.</param>
procedure ShowInstruction(const AFieldName: string);

/// <summary>Převádí částku na slova (česká varianta) – omezená implementace.</summary>
/// <param name="AValue">Číslo k převedení na slova.</param>
/// <param name="AUpperFirstChar">Pokud je true, první písmeno bude velké.</param>
/// <returns>Textové vyjádření čísla (např. dva tisíce tři sta padesát osm).</returns>
function AmountByWords(AValue: extended;
  AUpperFirstChar: boolean = FALSE): string;

/// <summary>Pokusí se otevřít záznam hodnot pro úpravu.</summary>
procedure TryEditValuesRecord;

/// <summary>Pokusí se uložit záznam hodnot.</summary>
procedure TryPostValuesRecord;

/// <summary>Zobrazí dialogové okno s chybovou zprávou.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text chybové zprávy.</param>
/// <param name="AFlags">Příznaky dialogu (např. tlačítka).</param>
/// <returns>Hodnota odpovědi uživatele.</returns>
function MsgBoxErr(const ACaption, AMsg: string; AFlags: longint): integer;

/// <summary>Zobrazí dialogové okno s varovnou zprávou.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text varovné zprávy.</param>
/// <param name="AFlags">Příznaky dialogu (např. tlačítka).</param>
/// <returns>Hodnota odpovědi uživatele.</returns>
function MsgBoxWarn(const ACaption, AMsg: string; AFlags: longint): integer;

/// <summary>Zobrazí dialogové okno s dotazem.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text dotazu.</param>
/// <param name="AFlags">Příznaky dialogu (např. tlačítka).</param>
/// <returns>Hodnota odpovědi uživatele.</returns>
function MsgBoxAsk(const ACaption, AMsg: string; AFlags: longint): integer;

/// <summary>Zobrazí dialogové okno s informační zprávou.</summary>
/// <param name="ACaption">Nadpis dialogového okna.</param>
/// <param name="AMsg">Text informační zprávy.</param>
/// <param name="AFlags">Příznaky dialogu (např. tlačítka).</param>
/// <returns>Hodnota odpovědi uživatele.</returns>
function MsgBoxInfo(const ACaption, AMsg: string; AFlags: longint): integer;

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

/// <summary>Zobrazí hlášení pro ladění skriptu.</summary>
procedure Msg(const AMessage: string);

/// <summary>Zobrazí hlášení pro ladění skriptu. Parametr může být libovolného typu - převede jej na text.</summary>
procedure Msgv(AMessage: variant);

/// <summary>Inicializuje globální proměnné skriptu.</summary>
procedure InitScriptGVariables;

/// <summary>Vytvoří tisková data pro tabulku ve formátu PDF.</summary>
/// <param name="ATableDataText">Textová data tabulky.</param>
/// <param name="ADPFFileName">Název výstupního PDF souboru.</param>
/// <param name="ARowsInPriloha">Počet řádků na jednu přílohu.</param>
/// <param name="AShiftRows">Počet řádků k posunu.</param>
/// <param name="APageCount">Počet stránek (-1 = automaticky).</param>
/// <returns>Textová data pro tisk.</returns>
function CreatePrintDataForTable(const ATableDataText,
  ADPFFileName: string; ARowsInPriloha, AShiftRows: integer;
  APageCount: integer = -1): string;

/// <summary>Nastaví data formuláře z textového řetězce.</summary>
/// <param name="AData">Data formuláře v interním formátu.</param>
procedure SetFormData(const AData: string);

/// <summary>Nastaví příznak změny formuláře.</summary>
/// <param name="AWasChange">True, pokud došlo ke změně, jinak false.</param>
procedure SetChangeFlag(AWasChange: boolean);

/// <summary>Vrátí příznak změny formuláře.</summary>
/// <returns>True, pokud došlo ke změně, jinak false.</returns>
function GetChangeFlag: boolean;

/// <summary>Nastaví příznak zámku formuláře.</summary>
/// <param name="ALock">True, pokud je formulář uzamčen, jinak false.</param>
procedure SetLockFlag(ALock: boolean);

/// <summary>Vrátí příznak zámku formuláře.</summary>
/// <returns>True, pokud je formulář uzamčen, jinak false.</returns>
function GetLockFlag: boolean;

/// <summary>Vrátí text příloh formuláře.</summary>
/// <returns>Text příloh formuláře.</returns>
function GetAppendixString: string;

/// <summary>Vrátí text poznámek formuláře.</summary>
/// <returns>Text poznámek formuláře.</returns>
function GetNotesString: string;

/// <summary>Vrátí text komentáře formuláře.</summary>
/// <returns>Text komentáře formuláře.</returns>
function GetCommentString: string;

/// <summary>Nastaví, zda se má povolit údaje po výpočtu.</summary>
/// <param name="ADoEnableAfterCalculate">True, pokud se mají povolit údaje po výpočtu, jinak false.</param>
procedure SetDoEnableAfterCalculate(ADoEnableAfterCalculate: boolean);

/// <summary>Vrátí pole MTV (Multi-Table View) podle názvu.</summary>
/// <param name="AFieldName">Název pole.</param>
/// <returns>Objekt pole nebo nil, pokud pole neexistuje.</returns>
function GetMTVField(const AFieldName: string): TField;

/// <summary>Vrátí hodnotu pole MTV (Multi-Table View) podle názvu a typu hodnoty.</summary>
/// <param name="AFieldName">Název pole.</param>
/// <param name="AValueType">Typ hodnoty (např. 'Text', 'Value').</param>
/// <returns>Hodnota pole nebo null, pokud pole neexistuje.</returns>
function GetMTVFieldValue(const AFieldName: string; const AValueType: string): Variant;

/// <summary>Získá vnořenou sekci z dat formuláře.</summary>
/// <param name="AData">Data formuláře v interním formátu.</param>
/// <param name="ASectionName">Název sekce.</param>
/// <returns>Obsah sekce nebo prázdný řetězec, pokud sekce neexistuje.</returns>
function GetNestedSection(const AData, ASectionName: string): string;

/// <summary>Přidá vnořenou sekci do dat formuláře.</summary>
/// <param name="AData">Data formuláře v interním formátu.</param>
/// <param name="ASectionName">Název sekce.</param>
/// <param name="ASectionData">Obsah sekce k přidání.</param>
/// <returns>Data formuláře s přidanou sekcí.</returns>
function AddNestedSection(const AData, ASectionName,
  ASectionData: string): string;

/// <summary>Nahradí vnořenou sekci v datech formuláře.</summary>
/// <param name="AData">Data formuláře v interním formátu.</param>
/// <param name="ASectionName">Název sekce.</param>
/// <param name="ASectionData">Nový obsah sekce.</param>
/// <returns>Data formuláře s nahrazenou sekcí.</returns>
function ReplaceNestedSection(const AData, ASectionName,
  ASectionData: string): string;

/// <summary>Odstraní vnořenou sekci z dat formuláře.</summary>
/// <param name="AData">Data formuláře v interním formátu.</param>
/// <param name="ASectionName">Název sekce k odstranění.</param>
/// <returns>Data formuláře bez odstraněné sekce.</returns>
function DeleteNestedSection(const AData, ASectionName: string): string;

/// <summary>Získá hodnotu údaje z vnořené sekce formuláře.</summary>
/// <param name="AData">Data formuláře v interním formátu.</param>
/// <param name="ANestedSectionName">Název vnořené sekce.</param>
/// <param name="AFieldName">Název údaje.</param>
/// <returns>Hodnota údaje nebo prázdný řetězec, pokud neexistuje.</returns>
function GetFormFieldCompactNested(const AData, ANestedSectionName,
  AFieldName: string): string;

/// <summary>Otevře vnořený formulář a vrátí jeho GUID.</summary>
/// <param name="ANestedFormID">ID vnořeného formuláře.</param>
/// <param name="ADefID">ID definice formuláře.</param>
/// <param name="AData">Data formuláře v interním formátu.</param>
/// <param name="AAddedData">Další data k přidání.</param>
/// <param name="ALevel">Úroveň vnoření.</param>
/// <returns>GUID otevřeného formuláře.</returns>
function DoOpenNestedForm(ANestedFormID: integer;
  const ADefID, AData, AAddedData: string; ALevel: integer): string;

/// <summary>Připraví sestavu z vnořeného formuláře.</summary>
/// <param name="ANestedFormID">ID vnořeného formuláře.</param>
/// <param name="ADefID">ID definice formuláře.</param>
/// <param name="AData">Data formuláře v interním formátu.</param>
/// <param name="ALevel">Úroveň vnoření.</param>
/// <param name="ADstFileName">Název výstupního souboru sestavy.</param>
/// <returns>GUID vytvořené sestavy.</returns>
function DoPrepareReportNestedForm(ANestedFormID: integer;
  const ADefID, AData: string; ALevel: integer;
  const ADstFileName: string): string;

/// <summary>Zjistí, zda je formulář ve vnořeném stavu.</summary>
/// <returns>True, pokud je formulář vnořený, jinak false.</returns>
function NestedState: boolean;

/// <summary>Znovu načte všechny seznamy (ListBox) ve formuláři.</summary>
procedure ReloadListBoxes;

/// <summary>Vrátí index vybrané položky v seznamu.</summary>
/// <param name="AListBoxName">Název seznamu.</param>
/// <returns>Index vybrané položky (-1, pokud není nic vybráno).</returns>
function GetListBoxItemIndex(const AListBoxName: string): integer;

/// <summary>Nastaví vybranou položku v seznamu podle indexu.</summary>
/// <param name="AListBoxName">Název seznamu.</param>
/// <param name="AItemIndex">Index položky k výběru (-1 pro zrušení výběru).</param>
procedure SetListBoxItemIndex(const AListBoxName: string; AItemIndex: integer);

/// <summary>Vrátí text položky v seznamu podle indexu.</summary>
/// <param name="AListBoxName">Název seznamu.</param>
/// <param name="AItemIndex">Index položky.</param>
/// <returns>Text položky nebo prázdný řetězec, pokud index není platný.</returns>
function GetListBoxItemString(const AListBoxName: string;
  AItemIndex: integer): string;

/// <summary>Nastaví text položky v seznamu podle indexu.</summary>
/// <param name="AListBoxName">Název seznamu.</param>
/// <param name="AItemIndex">Index položky.</param>
/// <param name="AItemString">Nový text položky.</param>
procedure SetListBoxItemString(const AListBoxName: string;
  AItemIndex: integer; AItemString: string);

/// <summary>Vrátí počet položek v seznamu.</summary>
/// <param name="AListBoxName">Název seznamu.</param>
/// <returns>Počet položek v seznamu.</returns>
function GetListBoxItemCount(const AListBoxName: string): integer;

/// <summary>Zobrazí dialog pro zadání celého čísla.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel">Popisek pole.</param>
/// <param name="AValue">Vstupní a výstupní hodnota celého čísla.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskInt(const ACaption: string;
                const ALabel: string; var AValue: integer): TModalResult;

/// <summary>Zobrazí dialog pro zadání desetinného čísla.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel">Popisek pole.</param>
/// <param name="AValue">Vstupní a výstupní hodnota desetinného čísla.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskFloat(const ACaption: string;
                const ALabel: string; var AValue: double): TModalResult;

/// <summary>Zobrazí dialog pro zadání textu.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel">Popisek pole.</param>
/// <param name="AValue">Vstupní a výstupní hodnota textu.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskStr(const ACaption: string;
                const ALabel: string; var AValue: string): TModalResult;

/// <summary>Zobrazí dialog pro zadání textu s vlastní pozicí okna.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel">Popisek pole.</param>
/// <param name="AValue">Vstupní a výstupní hodnota textu.</param>
/// <param name="ALeft">Levá pozice okna v pixelech.</param>
/// <param name="ATop">Horní pozice okna v pixelech.</param>
/// <param name="ACorectionWidth">Korekce šířky okna v pixelech.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskStrV(const ACaption: string;
                const ALabel: string; var AValue: string;
                ALeft: integer; ATop: integer;
                ACorectionWidth: integer): TModalResult;

/// <summary>Zobrazí dialog pro zadání víceřádkového textu.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel">Popisek pole.</param>
/// <param name="AValue">Vstupní a výstupní hodnota textu.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskMemo(const ACaption: string;
                const ALabel: string; var AValue: string): TModalResult;

/// <summary>Zobrazí dialog pro zadání víceřádkového textu s vlastní pozicí okna.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel">Popisek pole.</param>
/// <param name="AValue">Vstupní a výstupní hodnota textu.</param>
/// <param name="ALeft">Levá pozice okna v pixelech.</param>
/// <param name="ATop">Horní pozice okna v pixelech.</param>
/// <param name="ACorectionWidth">Korekce šířky okna v pixelech.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskMemoV(const ACaption: string;
                const ALabel: string; var AValue: string;
                ALeft: integer; ATop: integer;
                ACorectionWidth: integer): TModalResult;

/// <summary>Zobrazí dialog pro zadání dvou celých čísel.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel1">Popisek prvního pole.</param>
/// <param name="AValue1">Vstupní a výstupní hodnota prvního celého čísla.</param>
/// <param name="ALabel2">Popisek druhého pole.</param>
/// <param name="AValue2">Vstupní a výstupní hodnota druhého celého čísla.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskIntInt(const ACaption: string;
                const ALabel1: string; var AValue1: integer;
                const ALabel2: string; var AValue2: integer): TModalResult;

/// <summary>Zobrazí dialog pro zadání data.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel">Popisek pole.</param>
/// <param name="AValue">Vstupní a výstupní hodnota data.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskDate(const ACaption: string;
                const ALabel: string; var AValue: TDate): TModalResult;

/// <summary>Zobrazí dialog pro zadání dvou dat.</summary>
/// <param name="ACaption">Nadpis dialogu.</param>
/// <param name="ALabel1">Popisek prvního pole.</param>
/// <param name="AValue1">Vstupní a výstupní hodnota prvního data.</param>
/// <param name="ALabel2">Popisek druhého pole.</param>
/// <param name="AValue2">Vstupní a výstupní hodnota druhého data.</param>
/// <returns>Výsledek dialogu (mrOK, mrCancel).</returns>
function AskDateDate(const ACaption: string;
                const ALabel1: string; var AValue1: TDate;
                const ALabel2: string; var AValue2: TDate): TModalResult;

/// <summary>Vyčistí informace o vyplňování tiskopisu.</summary>
procedure ClearTskpFillingInfo;

/// <summary>Přečte binární soubor a vrátí jeho obsah jako base64 string (bez zalomení řádků).</summary>
/// <param name="AFileName">Cesta k souboru.</param>
/// <returns>Řetězec v base64 formátu.</returns>
function BinaryFileToStringBase64(const AFileName: string): string;

/// <summary>Převede base64 string na binární soubor a uloží jej.</summary>
/// <param name="AStrBase64">Řetězec kódovaný v base64.</param>
/// <param name="AFileName">Cesta k výstupnímu souboru.</param>
procedure StringBase64ToBinaryFile(const AStrBase64, AFileName: string);

/// <summary>Přečte binární soubor a vrátí jeho obsah jako base64 MIME string.</summary>
/// <param name="AFileName">Cesta k souboru.</param>
/// <returns>Řetězec v base64 MIME formátu.</returns>
function BinaryFileToStringMime(const AFileName: string): string;

/// <summary>Převede base64 MIME text na binární soubor a uloží jej.</summary>
/// <param name="AString">Řetězec kódovaný v base64 MIME.</param>
/// <param name="AFileName">Cesta k výstupnímu souboru.</param>
procedure StringMimeToBinaryFile(const AString, AFileName: string);

/// <summary>Nastaví, zda má být dialog pro otevření souboru víceřádkový.</summary>
/// <param name="AMultiline">True, pokud má být dialog víceřádkový, jinak false.</param>
procedure SetMultilineOpenDialog(AMultiline: boolean);

/// <summary>Otevře dialog pro výběr adresy klienta a vrátí vybranou hodnotu.</summary>
/// <param name="AColumns">Názvy sloupců k zobrazení (oddělené čárkou).</param>
/// <param name="ATypeOffice">Typ úřadu/kanceláře.</param>
/// <param name="AShowSave2Disc">Pokud je true, zobrazí možnost uložení na disk.</param>
/// <param name="ADefAdrNazev">Výchozí název adresy.</param>
/// <param name="ADefAdrIdDs">Výchozí ID datové schránky.</param>
/// <param name="ADefAdrEmail">Výchozí e-mail.</param>
/// <returns>Vybraná hodnota adresy nebo prázdný řetězec.</returns>
function SelectClientAdress(
  AColumns: string = '';
  const ATypeOffice: string = '';
  const AShowSave2Disc: boolean=false;
  const ADefAdrNazev: string = '';
  const ADefAdrIdDs: string = '';
  const ADefAdrEmail: string = ''): string;

/// <summary>Otevře dialog pro výběr osoby klienta a vrátí vybranou hodnotu.</summary>
/// <param name="AColumns">Názvy sloupců k zobrazení (oddělené čárkou).</param>
/// <returns>Vybraná hodnota osoby nebo prázdný řetězec.</returns>
function SelectClientPerson(AColumns: string = ''): string;

/// <summary>Otevře dialog pro výběr bankovního účtu klienta a vrátí vybranou hodnotu.</summary>
/// <param name="AColumns">Názvy sloupců k zobrazení (oddělené čárkou).</param>
/// <returns>Vybraná hodnota bankovního účtu nebo prázdný řetězec.</returns>
function SelectClientBankAccount(AColumns: string = ''): string;

/// <summary>Otevře dialog pro výběr příloh a vrátí informace o vybrané příloze.</summary>
/// <param name="AData">Vstupní data příloh.</param>
/// <param name="AIdOut">Výstupní ID vybrané přílohy.</param>
/// <param name="ATypeOut">Výstupní typ vybrané přílohy.</param>
/// <param name="ADataOut">Výstupní data vybrané přílohy.</param>
/// <returns>True, pokud uživatel vybral přílohu, jinak false.</returns>
function SelectAttachments(
  const AData: string;
  var AIdOut: string;
  var ATypeOut: string;
  var ADataOut: string): boolean;

/// <summary>Nastaví uživatelské nastavení pro tisk příloh formuláře.</summary>
/// <param name="AValue">True, pokud se mají tisknout přílohy, jinak false.</param>
procedure SetFormUserSettingPrintAppendix(AValue: boolean);

/// <summary>Nastaví číslo strany, od které se má sestava vytisknout.</summary>
procedure SetFormUserSettingPrintFromPage(AValue: integer);

/// <summary>Připraví sestavu z určitých stránek souboru.</summary>
/// <param name="ADstFileName">Cesta k výstupnímu souboru sestavy.</param>
/// <param name="AFromPage">Číslo stránky, od které se má začít (0 = od začátku).</param>
/// <returns>Cesta k připravenému souboru sestavy.</returns>
function PrepareReportFilePages(const ADstFileName: string;
  AFromPage: Integer = 0): string;

/// <summary>Vrátí nastavení sestavy jako text.</summary>
/// <returns>Text nastavení sestavy.</returns>
function GetReportSettings: string;

/// <summary>Vrátí verzi funkční knihovny.</summary>
/// <returns>Číslo verze funkční knihovny.</returns>
function FuncVersion: integer;

/// <summary>Vrátí číslo výrobní licence.</summary>
/// <returns>Číslo výrobní licence.</returns>
function GetLicProductionNumber: string;

/// <summary>Vloží logo do PDF souboru.</summary>
/// <param name="APDFName">Cesta k PDF souboru.</param>
/// <param name="APosX">Pozice X v pixelech.</param>
/// <param name="APosY">Pozice Y v pixelech.</param>
/// <param name="AWidthMax">Maximální šířka loga v pixelech (výchozí je 100).</param>
/// <param name="AheightMax">Maximální výška loga v pixelech (výchozí je 80).</param>
/// <param name="AImgPath">Cesta k obrázku loga (pokud je prázdná, použije se výchozí logo).</param>
procedure InsertLogoToPDF(const APDFName: string; APosX: integer; APosY: integer;
  AWidthMax: integer = 100; AheightMax: integer = 80; const AImgPath: string = '');

/// <summary>Vrátí cestu k logu.</summary>
/// <returns>Cesta k souboru s logem.</returns>
function GetLogoPath: string;

/// <summary>Vloží QR kód do PDF souboru s platebními údaji.</summary>
/// <param name="APDFName">Cesta k PDF souboru.</param>
/// <param name="APosX">Pozice X v pixelech.</param>
/// <param name="APosY">Pozice Y v pixelech.</param>
/// <param name="AIBAN">IBAN číslo účtu.</param>
/// <param name="ABU">Číslo bankovního účtu.</param>
/// <param name="ACastka">Částka platby.</param>
/// <param name="AMenaUctu">Měna účtu.</param>
/// <param name="APlatce">Název platce.</param>
/// <param name="AVarSym">Variabilní symbol.</param>
/// <param name="ASpecSym">Specifický symbol.</param>
/// <param name="AKonSym">Konstantní symbol.</param>
/// <param name="AZpravaPrijemci">Zpráva pro příjemce.</param>
/// <param name="AWidth">Šířka QR kódu v pixelech (výchozí je 200).</param>
/// <param name="AHeight">Výška QR kódu v pixelech (výchozí je 200).</param>
procedure InsertQRCodeToPDF(
  const APDFName: string; APosX: integer; APosY: integer;
  const AIBAN, ABU: string;
  const ACastka: double;
  const AMenaUctu, APlatce, AVarSym, ASpecSym, AKonSym, AZpravaPrijemci: string;
  AWidth: integer = 200; AHeight: integer = 200);

/// <summary>Vloží QR kód s textem do PDF souboru.</summary>
/// <param name="APDFName">Cesta k PDF souboru.</param>
/// <param name="APosX">Pozice X v pixelech.</param>
/// <param name="APosY">Pozice Y v pixelech.</param>
/// <param name="AText">Text k zakódování do QR kódu.</param>
/// <param name="AWidth">Šířka QR kódu v pixelech (výchozí je 200).</param>
/// <param name="AHeight">Výška QR kódu v pixelech (výchozí je 200).</param>
procedure InsertQRCodeTextToPDF(
  const APDFName: string; APosX: integer; APosY: integer;
  const AText: string;
  AWidth: integer = 200; AHeight: integer = 200);

/// <summary>Vloží čárový kód do PDF souboru.</summary>
/// <param name="APDFName">Cesta k PDF souboru.</param>
/// <param name="APosX">Pozice X v pixelech.</param>
/// <param name="APosY">Pozice Y v pixelech.</param>
/// <param name="ABarCodeText">Text k zakódování do čárového kódu.</param>
/// <param name="ABarCodeType">Typ čárového kódu (např. 'Code128', 'EAN13').</param>
/// <param name="AWidth">Šířka čárového kódu v pixelech (výchozí je 200).</param>
/// <param name="AHeight">Výška čárového kódu v pixelech (výchozí je 200).</param>
/// <param name="AAngle">Úhel natočení čárového kódu ve stupních (výchozí je 0.0).</param>
procedure InsertBarCodeToPDF(
  const APDFName: string; APosX: integer; APosY: integer;
  const ABarCodeText: string;
  const ABarCodeType: string;
  AWidth: integer = 200; AHeight: integer = 200;
  AAngle: double =0.0);

/// <summary>Optimalizuje PDF soubor (zmenší velikost).</summary>
/// <param name="APDFNameIn">Cesta k vstupnímu PDF souboru.</param>
/// <param name="APDFNameOut">Cesta k výstupnímu optimalizovanému PDF souboru.</param>
procedure PackPDF(const APDFNameIn: string; const APDFNameOut: string);

/// <summary>Vytvoří FDF soubor z řetězce a přidruží ho k PDF souboru.</summary>
/// <param name="AFDFString">FDF data jako text.</param>
/// <param name="APDFFileName">Cesta k PDF souboru.</param>
/// <param name="ATargetFileName">Cesta k výstupnímu FDF souboru.</param>
procedure CreateFDFFile(const AFDFString: string; const APDFFileName: string;
  const ATargetFileName: string);

/// <summary>Provede konverzi nepřípustných znaků ve FDF.</summary>
function EncodeFDFString(const AStr: string): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GetTxtFileFromFDR(const AFileName: string): string;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure DoPrintForm(const AFormData: string;
   ASendMail: boolean; AOnlyPrepareFile: boolean; var AOutPDFFileName: string);

/// <summary>TODO: doplnit dokumentaci</summary>
function mtWorkSaveToString: string;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure mtWorkLoadFromString(str: string);

/// <summary>TODO: doplnit dokumentaci</summary>
function GetDirWorkPath: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GetExeFilePath: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function DoCopyFile(ASourceFileName: string; ADestinationFileName: string): boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function VyberCertifikat(var AHash:string; var ASubject:string;
  var AFullSubject:string; var ACertifikat:string):boolean;

/// <summary>Vrací celočíselnou část řetězce s číslem oddělenou tečkou.</summary>
/// <param name="AFieldName">Řetězec s číslem (např. "123.45").</param>
/// <param name="AFormatFloat">Pokud je true, formátuje výstup jako číslo.</param>
/// <returns>Celočíselná část čísla jako řetězec.</returns>
function FloatFieldIntPartStr(AFieldName: string; AFormatFloat: boolean = TRUE): string;

/// <summary>Vrací desetinnou část řetězce s číslem.</summary>
/// <param name="AFieldName">Řetězec s číslem (např. "123.45").</param>
/// <param name="ADigit">Počet desetinných míst (výchozí je -2).</param>
/// <returns>Desetinná část čísla jako řetězec.</returns>
function FloatFieldFracPartStr(AFieldName: string; ADigit: integer = -2): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function StartCounterZero: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function Utf8ToAnsiString(const str: string): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function SelectDir(const Caption: string; const Root: WideString; var Directory: string): Boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function GetPDS(const APDSFileName: string = ''): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function SCheckVAT(countrycode:string; vatno:string; var vysledek:string):integer;

/// <summary>TODO: doplnit dokumentaci</summary>
function SCheckPlatce(vatno:string; var vysledek:string):integer;

/// <summary>TODO: doplnit dokumentaci</summary>
function SNactiAdresuZARES(const AICO: string;
  var ATypOsoby, ANazevFirmy, AUlice, ACisloPop, ACisloOrientacni, AObec, APSC, AMsg: string): boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function SNactiAdresuZARESD(const AICO: string;
  var ATypOsoby, ANazevFirmy, AUlice, ACisloPop, ACisloOrientacni, AObec, APSC, ADIC, AMsg: string): boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function ShowInfoARES(const AICO: string;
  AMsgAsk: Boolean = false; AWithCreditCheck: Boolean = False): string;

//funkce pouzivane pro import el. podani z XML
/// <summary>TODO: doplnit dokumentaci</summary>
procedure mtValuesClearFields;

/// <summary>TODO: doplnit dokumentaci</summary>
function ReplaceXmlStr(const AStr: string): string;

/// <summary>Pokusí se převést datum ze vstupního textu.</summary>
/// <param name="AYear">Rok.</param>
/// <param name="AMonth">Měsíc.</param>
/// <param name="ADay">Den.</param>
/// <param name="AHour">Hodina.</param>
/// <param name="AMinute">Minuta.</param>
/// <param name="ASecond">Sekunda.</param>
/// <param name="AMilliSecond">Milisekunda.</param>
/// <param name="AValue">Výstupní datum, pokud je úspěšné.</param>
/// <returns>True pokud se převod podařil, jinak false.</returns>
function TryEncodeDateTimeEx(const AYear,AMonth,ADay,AHour,AMinute,ASecond,
  AMilliSecond : word; out AValue : TDateTime): Boolean;

/// <summary>Vyhodnotí řetězec s datem/časem a převede na DateTime. Pokud selže, vrátí DateTime.MinValue.</summary>
/// <param name="DateTimeFormat">Formátovací řetězec pro datum.</param>
/// <param name="DateTimeStr">Řetězec s datem/časem k převedení.</param>
/// <returns>Datum převedené z řetězce, nebo DateTime.MinValue pokud převod selže.</returns>
function DateTimeStrEval(const DateTimeFormat: string;
  const DateTimeStr: string): TDateTime;

/// <summary>TODO: doplnit dokumentaci</summary>
function GetFillingInfo: string;

//breakpoint do script editoru
/// <summary>TODO: doplnit dokumentaci</summary>
procedure BP(AEnabled: boolean; ABpID: string;
  AVar1: variant; AVar2: variant; AVar3: variant;
  AVar4: variant; AVar5: variant; AVar6: variant;
  AVar7: variant; AVar8: variant; AVar9: variant);

//dalsi
/// <summary>TODO: doplnit dokumentaci</summary>
function ControlAndSendForm: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SaveFormWithoutCheck;

/// <summary>TODO: doplnit dokumentaci</summary>
function SizeOfFile(const AFilePath: string): double;

/// <summary>TODO: doplnit dokumentaci</summary>
function GetAdrClip: string;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetGScriptFieldName;

/// <summary>TODO: doplnit dokumentaci</summary>
function IsPaymentInDB(
  var APayCnt: integer;
  var ASendPayCnt: integer;
  var APaidPayCnt: integer): boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure DelPaymentInDB;

/// <summary>TODO: doplnit dokumentaci</summary>
function MsgAskYesNoCancel(const ACaption, AMsg: string; ADefBtn: TMsgDlgBtn): integer;

/// <summary>TODO: doplnit dokumentaci</summary>
function SaveDocumentToDB(const APath: string;
  ANazevDokumentu: string = '';
  const AComment: string = ''; const ACommentMemo: string = ''): string;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure OpenWebPortalCSSZ(const fn: string);

/// <summary>TODO: doplnit dokumentaci</summary>
function SendFilesByEmailOrDS(AMailAddr, ASubject, ABody: string;
  AAttachmentsFileNames: TStringList; AShowDialog: boolean; out AErrorMsg: string): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function SelectEmailOrDS(AOnlyEmail: Boolean = False): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function PDFEditorPath: string;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetOpenPDFEditorFlag(AIsOpen: Boolean);

/// <summary>TODO: doplnit dokumentaci</summary>
function GetOpenPDFEditorFlag: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure ShowProgress(APos: Integer; AMax: Integer = 100);

/// <summary>TODO: doplnit dokumentaci</summary>
procedure CreateWtFields(ATableNameCis: integer; const AFieldNames: string);

/// <summary>TODO: doplnit dokumentaci</summary>
function SaveWtToString(ATableNameCis: integer): string;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure LoadWtFromString(ATableNameCis: integer; str: string);

/// <summary>TODO: doplnit dokumentaci</summary>
procedure AppProcessMessages;

/// <summary>TODO: doplnit dokumentaci</summary>
function CheckDotNet: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure RunDotNetStript(const AScript: string; const AParams: string = ''; ACscs: Boolean = False; const AParamsRef: string = '');

/// <summary>TODO: doplnit dokumentaci</summary>
function SaveAppendixToPDF: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function IsDotNetDetected(version: string; service: integer): boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure ForceSaveNestedData;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure ForceCloseFA;

/// <summary>TODO: doplnit dokumentaci</summary>
function SaveNewFormToDB: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure LoadingStart(AStepCount: Integer; AEnableBreak: Boolean = False;
  const ACaption: string = ''; const AText: string = '');

/// <summary>TODO: doplnit dokumentaci</summary>
procedure LoadingStop;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure LoadingStep;

/// <summary>TODO: doplnit dokumentaci</summary>
function LoadingBreakRequest: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function ConvertFR3ToPDF(const AReportFileNameCsvList: string): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function DoCancelEditForm: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function EvalScript(AStrValue: string): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function EvalMethod(AMethodName: string): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function EvalParamMethod(AMethodName: string; AParam: variant): string;

/// <summary>TODO: doplnit dokumentaci</summary>
function CreateHBWithImportCSV(const ABaUcet,
  AKodBanky, AFormatHB: string;
  const APrevPrikCsv, APrevPrikPCsv, ABoFirmaCsv, AFirmaUctCsv: string;
  var AOutText, AMsg: string): boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SendOrderFioAPI(const AXmlFile, AFileFormat, AToken: string);

//funkce na cteni globalnich parametru pro instanci
/// <summary>TODO: doplnit dokumentaci</summary>
function Gsl: TStringList;

/// <summary>TODO: doplnit dokumentaci</summary>
function GFillMemo: string; //tabulky z nastaveni klienta (mtAuta v csv)

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptState: TScriptState;

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptFieldName: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptOldFieldName: string;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGScriptState(value: TScriptState);

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGScriptFieldName(value: string);

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGScriptOldFieldName(value: string);

/// <summary>TODO: doplnit dokumentaci</summary>
function GGotoFieldName: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptPreparedLists: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptGetFormsIDDefs: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptFldDisplayValue: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptZeroValueClear: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptFillingInfo: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GShowThousandSeparator: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
function GSlaveState: TSlaveState;

/// <summary>TODO: doplnit dokumentaci</summary>
function GCheckGotoFldName: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GScriptFillingZip: boolean;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGScriptFillingZip(value: boolean);

//vystup funkce GetFormsOrDocuments
/// <summary>TODO: doplnit dokumentaci</summary>
function GfodFrmID: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GfodFrmDefID: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GfodDocId: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GfodFiles: string;

/// <summary>TODO: doplnit dokumentaci</summary>
function GfodGUID: string;

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGfodFrmID(value: string);

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGfodFrmDefID(value: string);

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGfodDocId(value: string);

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGfodFiles(value: string);

/// <summary>TODO: doplnit dokumentaci</summary>
procedure SetValueGfodGUID(value: string);


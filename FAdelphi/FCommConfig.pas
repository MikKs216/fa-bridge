{ ============================================================================
  Unit: FCommConfig
  Autor: AI Assistant
  Datum: 26.10.2025
  Popis: Globální konfigurace FComm - přepínání mezi legacy a FComm API
  
  Konfigurace: fcomm.ini v adresáři s aplikací
  
  [Signature]
  UseFcomm=0   ; 0=CAPICOM (legacy), 1=FComm API
  
  [EPO]
  UseFcomm=0   ; 0=Legacy, 1=FComm API (budoucnost)
  
  [ISDS]
  UseFcomm=0   ; 0=Legacy, 1=FComm API (budoucnost)
  
  [Banking]
  UseFcomm=0   ; 0=Legacy, 1=FComm API (budoucnost)
  
  Použití:
    if GetSignatureProvider = sptFcomm then
      // Použít FComm API
    else
      // Použít legacy řešení (CAPICOM)
  ============================================================================ }

unit FCommConfig;

interface

uses
  SysUtils, IniFiles;

type
  { Typy modulů pro budoucí rozšíření }
  TFCommModuleType = (
    fmtSignature,   // Podepisování dokumentů
    fmtEPO,         // Elektronická podání (MF ČR, ČSSZ)
    fmtISDS,        // Datové schránky
    fmtBanking      // Internet banking
  );
  
  { Provider pro podepisování }
  TSignatureProviderType = (sptCapicom, sptFcomm);
  
  { Budoucí typy pro další moduly }
  // TEPOProviderType = (eptLegacy, eptFcomm);
  // TISDSProviderType = (iptLegacy, iptFcomm);
  // TBankingProviderType = (bptLegacy, bptFcomm);

{ === API pro podepisování === }

// Globální přepínač - vrací aktuálně použitý provider pro podepisování
function GetSignatureProvider: TSignatureProviderType;

// Pro budoucí rozšíření - nastavení providera za běhu
procedure SetSignatureProvider(AProvider: TSignatureProviderType);

{ === Budoucí API pro další moduly === }

// function GetEPOProvider: TEPOProviderType;
// function GetISDSProvider: TISDSProviderType;
// function GetBankingProvider: TBankingProviderType;

implementation

const
  INI_FILE_NAME = 'fcomm.ini';
  
  { INI sekce pro jednotlivé moduly }
  INI_SECTION_SIGNATURE = 'Signature';
  INI_SECTION_EPO = 'EPO';
  INI_SECTION_ISDS = 'ISDS';
  INI_SECTION_BANKING = 'Banking';
  
  { INI klíč pro přepínání (společný pro všechny moduly) }
  INI_KEY_USE_FCOMM = 'UseFcomm';

var
  { Globální proměnné pro uchování aktuální konfigurace }
  FSignatureProvider: TSignatureProviderType;
  // FEPOProvider: TEPOProviderType;
  // FISDSProvider: TISDSProviderType;
  // FBankingProvider: TBankingProviderType;

{ === Pomocné funkce === }

function GetIniFilePath: string;
begin
  // INI soubor ve stejném adresáři jako aplikace
  Result := ExtractFilePath(ParamStr(0)) + INI_FILE_NAME;
end;

{ === API pro podepisování === }

function GetSignatureProvider: TSignatureProviderType;
begin
  Result := FSignatureProvider;
end;

procedure SetSignatureProvider(AProvider: TSignatureProviderType);
begin
  FSignatureProvider := AProvider;
end;

function LoadSignatureProviderFromIni: TSignatureProviderType;
var
  IniFile: TIniFile;
  IniPath: string;
  UseFcomm: Integer;
begin
  // Výchozí: CAPICOM (zpětná kompatibilita)
  Result := sptCapicom;
  
  try
    IniPath := GetIniFilePath;
    
    // Pokud INI soubor neexistuje, použít CAPICOM
    if not FileExists(IniPath) then
      Exit;
    
    IniFile := TIniFile.Create(IniPath);
    try
      // Načíst hodnotu ze sekce [Signature]
      // 0 = CAPICOM (legacy), 1 = FComm API
      UseFcomm := IniFile.ReadInteger(INI_SECTION_SIGNATURE, INI_KEY_USE_FCOMM, 0);
      
      if UseFcomm = 1 then
        Result := sptFcomm
      else
        Result := sptCapicom;
    finally
      IniFile.Free;
    end;
  except
    // Při jakékoli chybě použít CAPICOM (bezpečný fallback)
    Result := sptCapicom;
  end;
end;

{ === Budoucí funkce pro další moduly === }

{
function LoadEPOProviderFromIni: TEPOProviderType;
var
  IniFile: TIniFile;
  IniPath: string;
  UseFcomm: Integer;
begin
  Result := eptLegacy; // Výchozí: legacy řešení
  
  try
    IniPath := GetIniFilePath;
    if not FileExists(IniPath) then Exit;
    
    IniFile := TIniFile.Create(IniPath);
    try
      UseFcomm := IniFile.ReadInteger(INI_SECTION_EPO, INI_KEY_USE_FCOMM, 0);
      if UseFcomm = 1 then
        Result := eptFcomm;
    finally
      IniFile.Free;
    end;
  except
    Result := eptLegacy;
  end;
end;
}

{ === Inicializace === }

initialization
  // Načíst konfiguraci při startu aplikace
  FSignatureProvider := LoadSignatureProviderFromIni;
  // FEPOProvider := LoadEPOProviderFromIni;
  // FISDSProvider := LoadISDSProviderFromIni;
  // FBankingProvider := LoadBankingProviderFromIni;

end.



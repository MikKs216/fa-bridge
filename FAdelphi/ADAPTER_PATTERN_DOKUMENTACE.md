# Adapter Pattern pro prepinani mezi CAPICOM a fcomm API

## Prehled

Tento dokument popisuje implementaci **Adapter Pattern** pro prepinani mezi starym zpusobem nacitani certifikatu (CAPICOM) a novym zpusobem (fcomm HTTP API).

## Architektura

```
┌─────────────────────────────────────────────────────────────┐
│                    EElPodani.pas                            │
│           (ZADNE ZMENY oproti puvodni verzi!)              │
│    Cert := TCertificateWrapper(Objects[...]);              │
│    Cert.SubjectFieldCommonName                             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ pouziva
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    EElPodDM.pas                             │
│    Certificates: TCertificatesWrapper  (JEDINA ZMENA)      │
│    CertificatesLoad() - vytvori wrapper                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ pouziva
                         ▼
┌─────────────────────────────────────────────────────────────┐
│            mfcr_certificate_adapter.pas                     │
│                  (NOVY SOUBOR)                              │
│                                                             │
│  TCertificatesWrapper                                       │
│    ├─ if UseFCommAPI → FCertificatesAPI                    │
│    └─ else          → FCertificatesOld                     │
│                                                             │
│  TCertificateWrapper                                        │
│    ├─ if UseFCommAPI → FCertificateAPI                     │
│    └─ else          → FCertificateOld                      │
└───────────┬─────────────────────┬───────────────────────────┘
            │                     │
            │                     │
            ▼                     ▼
  ┌──────────────────┐  ┌──────────────────┐
  │ mfcr_certificate │  │ mfcr_certificate │
  │     .pas         │  │     _api.pas     │
  │                  │  │                  │
  │  TCertificates   │  │ TCertificatesAPI │
  │  (CAPICOM)       │  │  (fcomm API)     │
  └──────────────────┘  └──────────────────┘
```

## Klicove komponenty

### 1. `mfcr_certificate_adapter.pas` (NOVY)

Obsahuje dve hlavni tridy:

#### `TCertificatesWrapper`
- Wrapper pro kolekci certifikatu
- Vytvari se s parametry `(UseFCommAPI: Boolean, BaseUrl: string)`
- Interne drzi bud `FCertificatesOld` nebo `FCertificatesAPI`
- Poskytuje UPLNE STEJNE rozhrani jako puvodni `TCertificates`:
  - `Count: Integer`
  - `Certificate(Index): TCertificateWrapper`
  - `Display(Index)`
  - `SignDocument(Index, DocFile, SigFile)`
  - `GetCertificateThumbprint(Index): string`
  - `FindCertificate(Thumbprint): TCertificateWrapper`

#### `TCertificateWrapper`
- Wrapper pro jednotlivy certifikat
- Interne drzi bud `FCertificateOld` nebo `FCertificateAPI`
- Poskytuje UPLNE STEJNE properties jako puvodni `TCertificate`:
  - `Version, SerialNumber, SubjectName, IssuerName`
  - `ValidFromDate, ValidToDate, Thumbprint`
  - `SubjectFieldCommonName, IssuerFieldCommonName, SubjectOrganization`
  - `Display()`, `SignDocument(DocFile, SigFile)`

### 2. `EElPodDM.pas` (MINIMALNI ZMENY)

**Deklarace:**
```pascal
// PUVODNI:
Certificates: TCertificates;

// NOVE:
Certificates: TCertificatesWrapper;
```

**Implementace CertificatesLoad:**
```pascal
// PUVODNI (starý zpusob):
Certificates := TCertificates.Create;

// NOVE (adapter pattern):
Certificates := TCertificatesWrapper.Create(
  GfaMain.UseFCommAPI,      // z FormStudio.ini
  GfaMain.FCommBaseUrl      // z FormStudio.ini
);
```

**ODSTRANENY:** Vsechny helper funkce (GetCertificatesCount, GetCertificate, SignDocumentByIndex, atd.) - uz nejsou potreba!

### 3. `EElPodani.pas` (MINIMALNI ZMENY)

#### Uses sekce:
```pascal
// PRIDANO:
uses
  ..., mfcr_certificate, mfcr_certificate_adapter, ...
```

#### Type casts:
```pascal
// PUVODNI (oldver):
Cert := TCertificate(CbCertificates.Properties.Items.Objects[...]);

// NOVE (adapter pattern):
Cert := TCertificateWrapper(CbCertificates.Properties.Items.Objects[...]);
```

#### Pristup k properties:
```pascal
// STEJNE jako predtim:
Cert.SubjectFieldCommonName
Cert.SubjectOrganization
Cert.ValidToDate
// atd.
```

#### Volani metod:
```pascal
// STEJNE jako predtim:
MFCRModule.Certificates.Display(Index)
MFCRModule.Certificates.SignDocument(Index, InputFile, OutputFile)
MFCRModule.Certificates.GetCertificateThumbprint(Index)
```

## Porovnani pristup u

### ❌ Puvodni reseni (helper funkce)

| **Co**               | **Pocet zmen**                 |
|----------------------|--------------------------------|
| EElPodDM.pas         | +80 radku (helper funkce)      |
| EElPodani.pas        | ~20 mist zmeneno               |
| Nove soubory         | 0                              |
| **Celkem**           | ~100 radku zmen v prod. kodu   |

**Nevyhody:**
- Zmeny v produknim kodu (EElPodani.pas)
- Dulezi ty helper funkce (vice kodu)
- Horsi objektovy design
- Tezsi udrzba

### ✅ Adapter Pattern (NOVE reseni)

| **Co**               | **Pocet zmen**                 |
|----------------------|--------------------------------|
| EElPodDM.pas         | 3 radky (typ + constructor)    |
| EElPodani.pas        | 5 mist (jen typecast)          |
| Nove soubory         | 1 (mfcr_certificate_adapter)   |
| **Celkem**           | ~8 radku zmen v prod. kodu     |

**Vyhody:**
- ✅ MINIMALNI zmeny v produknim kodu
- ✅ Cisty objektovy design (Adapter Pattern)
- ✅ Snadna rozsiritelnost pro dalsi moduly
- ✅ Lepsi separace zodpovednosti
- ✅ Testovani izolovane od business logiky

## Konfigurace

Prepinani mezi starym a novym zpusobem se ridi konfiguracnim souborem `FormStudio.ini`:

```ini
[Certificates]
UseFCommAPI=0           ; 0 = CAPICOM (stary), 1 = fcomm API (novy)
FCommBaseUrl=http://localhost:54321
```

Konfigurace se nacita v `Main.pas` v metode `LoadParamsFromIni`.

## Rozsiritelnost pro dalsi moduly

Adapter Pattern je idealni pro dalsi moduly (CSSZ, Datove schranky, atd.):

### Navrhovana struktura:

```
EPMF/
├── Certificates/
│   ├── mfcr_certificate.pas         (stary CAPICOM)
│   ├── mfcr_certificate_api.pas     (novy fcomm API)
│   └── mfcr_certificate_adapter.pas (adapter)
│
├── Sending/
│   ├── MFCR/
│   │   ├── mfcr_sending.pas         (stary zpusob)
│   │   ├── mfcr_sending_api.pas     (novy zpusob)
│   │   └── mfcr_sending_adapter.pas (adapter)
│   │
│   └── CSSZ/
│       ├── cssz_sending.pas         (stary zpusob)
│       ├── cssz_sending_api.pas     (novy zpusob)
│       └── cssz_sending_adapter.pas (adapter)
│
└── DataBoxes/
    ├── databox.pas                  (stary zpusob)
    ├── databox_api.pas              (novy zpusob)
    └── databox_adapter.pas          (adapter)
```

### Priklad pro CSSZ (budouci):

```pascal
// V EElPodPVS.pas (CSSZ modul):

// Deklarace:
Certificates: TCSSZCertificatesWrapper;  // Stejny pristup jako MFCR

// Pouziti:
Cert := TCSSZCertificateWrapper(CbCertificates.Properties.Items.Objects[...]);
Cert.SubjectFieldCommonName  // Stejne properties
```

### Priklad pro odesila ni (budouci):

```pascal
// V EElPodDM.pas:

// Deklarace:
Sender: TMFCRSendingWrapper;

// Pouziti:
Sender := TMFCRSendingWrapper.Create(GfaMain.UseFCommAPI, GfaMain.FCommBaseUrl);
Sender.SendDocument(SignatureFile, ReceiptFile, Params);
```

## Omezeni pro novy zpusob (fcomm API)

1. **Display()** - fcomm API nema metodu pro zobrazeni certifikatu
   - Wrapper zobrazi informacni zpravu
   
2. **SerialNumber** - fcomm API nema tuto property
   - Wrapper vraci prazdny retezec

Tyto omezeni jsou ciste kosmeticka a neovlivnuji funkcnost elektronickych podani.

## Testovani

### Test 1: Stary zpusob (CAPICOM)

1. Nastavit v `FormStudio.ini`:
   ```ini
   [Certificates]
   UseFCommAPI=0
   ```

2. Spustit aplikaci
3. Otevrit formular elektronickeho podani
4. Kliknout na "Nacist certifikaty"
5. Overit, ze se zobrazuji certifikaty
6. Vybrat certifikat a otestovat podepsani

### Test 2: Novy zpusob (fcomm API)

1. Spustit `fcomm` server:
   ```cmd
   cd D:\Projekty\fcomm-FAkomunikace\fcomm
   dotnet run
   ```

2. Nastavit v `FormStudio.ini`:
   ```ini
   [Certificates]
   UseFCommAPI=1
   FCommBaseUrl=http://localhost:54321
   ```

3. Spustit aplikaci
4. Otevrit formular elektronickeho podani
5. Kliknout na "Nacist certifikaty"
6. Overit, ze se zobrazuji certifikaty z fcomm API
7. Vybrat certifikat a otestovat podepsani

### Test 3: Prepinani mezi zpusoby

1. Otestovat s `UseFCommAPI=0`
2. Zmenit na `UseFCommAPI=1`
3. Restartovat aplikaci
4. Overit, ze prepinani funguje bez chyb

## Zaver

Adapter Pattern poskytuje:
- ✅ Minimalni zmeny v existujicim kodu
- ✅ Cisty objektovy design
- ✅ Snadnou rozsiritelnost
- ✅ Lepsi udrzbu a testovani
- ✅ Jednotny pristup pro vice modulu

Je to idealni reseni pro postupnou migraci ze stare technologie (CAPICOM) na novou (fcomm API) bez nutnosti prepisovat celou aplikaci.

---
**Vytvoreno:** 2026-01-19  
**Autor:** AI Coding Assistant  
**Verze:** 1.0

# Instrukce pro implementaci panelu HISTORIE do FA Bridge

## Přehled

Tento dokument obsahuje podklady pro implementaci panelu **HISTORIE** do doplňku FA Bridge. Panel zobrazuje historii aktuálně otevřeného souboru z `.lh` adresáře.

**Verze:** 0.5.78

---

## Krok 1: Přidat nové soubory

Zkopíruj následující soubory do projektu FA Bridge:

1. **`src/historyProvider.ts`** - Kompletní soubor z `IMPLEMENTACE_PODKLADY/historyProvider.ts`
2. **`src/historyPanel.ts`** - Kompletní soubor z `IMPLEMENTACE_PODKLADY/historyPanel.ts`

---

## Krok 2: Upravit src/extension.ts

### 2.1 Přidat importy na začátek souboru:

```typescript
import { HistoryPanel } from './historyPanel';
import { HistoryProvider } from './historyProvider';
```

### 2.2 Přidat kód do funkce `activate()`

Otevři soubor `extension_ADDITIONS.ts` a zkopíruj celý obsah sekce "KÓD PRO PANEL HISTORIE" do funkce `activate()` v `src/extension.ts`.

**Poznámka:** Kód můžeš přidat na začátek nebo konec funkce `activate()`, podle struktury existujícího kódu.

---

## Krok 3: Upravit package.json

### 3.1 Přidat do `contributes.views.explorer`:

```json
{
  "id": "faHistoryPanel",
  "name": "HISTORIE",
  "when": "config.local-history.enabled != false",
  "weight": 100,
  "description": "Historie aktuálně otevřeného souboru"
}
```

**Důležité:** `weight: 100` zajistí, že panel HISTORIE bude zobrazen před sekcí "Nápověda".

### 3.2 Přidat do `contributes.commands`:

```json
{
  "command": "faHistory.showDiff",
  "title": "Zobrazit rozdíly",
  "icon": "$(diff)"
},
{
  "command": "faHistory.restoreFile",
  "title": "Vrátit stav souboru do tohoto bodu",
  "icon": "$(history)"
},
{
  "command": "faHistory.refresh",
  "title": "Obnovit historii",
  "icon": "$(refresh)"
}
```

### 3.3 Přidat do `contributes.menus`:

```json
{
  "view/item/context": [
    {
      "command": "faHistory.showDiff",
      "when": "view == faHistoryPanel && viewItem == historyPatch",
      "group": "navigation"
    },
    {
      "command": "faHistory.restoreFile",
      "when": "view == faHistoryPanel && viewItem == historyPatch",
      "group": "actions"
    }
  ],
  "view/title": [
    {
      "command": "faHistory.refresh",
      "when": "view == faHistoryPanel",
      "group": "navigation"
    }
  ]
}
```

### 3.4 Přidat do `contributes.configuration.properties`:

```json
{
  "local-history.enabled": {
    "type": "boolean",
    "default": true,
    "description": "Zapnout/vypnout historii souborů. Když je vypnutá, panel HISTORIE se skryje."
  },
  "faHistory.maxFiles": {
    "type": "number",
    "default": 50,
    "description": "Maximální počet souborů zobrazených v panelu historie"
  },
  "faHistory.showDates": {
    "type": "boolean",
    "default": true,
    "description": "Zobrazovat datumy u verzí v panelu historie"
  }
}
```

### 3.5 Aktualizovat verzi:

Změň verzi v `package.json` na **0.5.78** (nebo vyšší):

```json
{
  "version": "0.5.78"
}
```

---

## Krok 4: TypeScript konfigurace

Pokud ještě neexistuje `tsconfig.json`, vytvoř ho s obsahem z `IMPLEMENTACE_PODKLADY/tsconfig.json`.

Pokud už existuje, ujisti se, že obsahuje:
- `"module": "commonjs"`
- `"target": "ES2020"`
- `"outDir": "out"`
- `"rootDir": "src"`
- `"strict": true`

---

## Krok 5: Build a testování

1. Spusť `npm install` (pokud jsou nové závislosti)
2. Spusť `npm run compile` pro kompilaci TypeScriptu
3. V Cursoru/VS Code otevři Command Palette (Ctrl+Shift+P) a zadej "Developer: Reload Window"
4. Otevři workspace s `.lh` adresářem
5. Otevři soubor v editoru - panel HISTORIE by se měl zobrazit v exploreru

---

## Struktura souborů po implementaci

```
fa-bridge/
├── package.json              (upravený)
├── tsconfig.json             (nový nebo upravený)
├── src/
│   ├── extension.ts          (upravený - přidán kód pro historii)
│   ├── historyProvider.ts   (nový)
│   └── historyPanel.ts      (nový)
└── out/                      (zkompilované soubory)
```

---

## Funkcionalita

### Co panel dělá:

1. **Zobrazuje historii aktuálního souboru** - Automaticky se aktualizuje při přepnutí záložky
2. **Stromová struktura** - Commity → Patche
3. **Zobrazení rozdílů** - Kliknutí na patch zobrazí side-by-side diff
4. **Vrácení souboru** - Pravý klik na patch umožňuje vrátit soubor do vybraného bodu s vytvořením zálohy
5. **Automatické skrytí** - Panel se skryje, když je historie vypnutá v nastavení

### Struktura historie:

Panel hledá historii v `.lh` adresáři podle struktury projektu:
- `.lh/np_03Obalka/script_np_03Obalka.pas.json` pro soubor `np_03Obalka/script_np_03Obalka.pas`
- Pokud přesná cesta neexistuje, hledá rekurzivně podle názvu souboru

---

## Řešení problémů

### Panel se nezobrazuje:
- Zkontroluj, zda je `local-history.enabled` nastaveno na `true` v nastavení
- Zkontroluj, zda existuje `.lh` adresář v kořeni workspace
- Zkontroluj konzoli pro chyby (F12 → Console)

### Historie se nenačítá:
- Zkontroluj, zda existuje JSON soubor s historií pro aktuální soubor
- Zkontroluj strukturu JSON souboru (musí obsahovat `sourceFile`, `commits`, atd.)

### Chyby při kompilaci:
- Zkontroluj, zda jsou všechny importy správné
- Zkontroluj TypeScript verzi (`npm list typescript`)
- Zkontroluj, zda jsou všechny závislosti nainstalované (`npm install`)

---

## Kontakt

V případě dotazů nebo problémů kontaktuj vývojáře FA Bridge.

---

**Konec instrukce**


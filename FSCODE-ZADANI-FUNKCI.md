# Propojení FA - Cursor/VsCode

### 1\. Cursor/VsCode → FA

***

#### Uložit a zbuildit kód — `Ctrl+S`

* Už funguje - uloží a zbuldí script formuláře

#### FA do popředí — `Ctrl+Q`

* Pouze aktivuje FA okno. **Neukládá** soubor.

#### Uložit, zbuildit, aktivovat FA — `F2`

* Uloží aktuální dokument a zbuildí (stejný save flow jako Ctrl+S).
* Aktivuje okno FA / formulář do popředí.
* Pokud editor není napojen na běžící FA: soubor se uloží, uživatel dostane varování, FA se neaktivuje.

#### Vložit aktuální údaj do scriptu — `Ctrl+Shift+V`

* Vloží název focusovaného údaje (inputu) ve formuláři na pozici carretu do textu

#### Najít údaj ve formuláři — `Ctrl+U`

* Vezme identifikátor údaje pod kurzorem (pokud kurzor není na slově tak nedělá nic).
* Pokud carret stojí na `Udaj.Value` nebo `Udaj.ToString()` v části .Value nebo .ToString(), hledá `Udaj`.
* Pošle FA požadavek „najdi tento údaj ve formuláři“.
* FA najde a focusne odpovídající údaj / input.
* Pokud takový údaj neexistuje tak toast "Údaj neexistuje"
* Pokud existuje, tak toast "Hledám údaj ..."
* Později: dokázat vyhledat i ostatní prvky jako label, shape ... (nějak je ukázat, nebo otevřít design editor a tam je focusovat)

### 2\. Vazba okna Cursoru/VsCode odpovídající otevřenému projektu \(oknu\) FA

***

* Z okna FA zavolání editace scriptu (Ctrl+Q) otevře nové okno editoru pokud nebylo. Pokud bylo otevřené tak jej dá do popředí. - ***To už funguje*** 
* Z okna Cursor/VsCode (Ctrl+Q, F2) aktivuje okno FA, pokud bylo otevřené. Pokud nebylo tak nedělá nic. (Nebo může umět otevřít a propojit? Pro případ, že FA spadne v průběhu ladění scriptu).
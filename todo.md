# TODO - Úkoly do budoucna

## IntelliSense dokumentace pro Pascal funkce

### Úkol
Implementovat IntelliSense dokumentaci pro Pascal funkce/procedury pomocí `///` komentářů.

### Co je potřeba udělat:
1. **Doplnit `///` komentáře do Pascal souborů** - dokumentační komentáře před funkcemi/procedurami v Pascal souborech
2. **Implementovat HoverProvider** - vytvořit provider, který:
   - Najde funkci/proceduru pod kurzorem
   - Vyhledá `///` komentář nad ní
   - Zobrazí ho v tooltipu při najetí myší (hover)
3. **Registrovat provider** - zaregistrovat HoverProvider pro Pascal jazyk v extension

### Formát komentářů:
```pascal
/// <summary>
/// Zpracuje příkaz z FA formuláře
/// </summary>
/// <param name="Command">Název příkazu (např. 'Aktivovat_formular')</param>
procedure ProcessFACommand(const Command: string);
```

### Výhody:
- Dokumentace přímo v kódu (jedno místo)
- Viditelná při hoveru (IntelliSense tooltip)
- Funguje i v completion listu (autocomplete)
- Standardní formát (`///` používá např. C#, TypeScript, Doxygen)










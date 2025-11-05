using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Net.NetworkInformation;
using System.Text;
using System.Text.RegularExpressions;
using System.Linq;

namespace FormAssistant.FSUtils
{
    /// <summary>
    /// Třída poskytující sjednocený přístup k různým funkcím
    /// souvisejícím s řetězci, daty, výpočty, souborovými operacemi a validací dat.
    /// Tato třída sdružuje funkce z původních knihoven FCommonUtils, FscriptUtils a RTL delphi.
    /// </summary>
    public static class Fs
    {
        // STRING UTILS (původně FStr)
        // -----------------

        /// <summary>
        /// Vrací řetězec, kde první znak a každý první znak po mezeře je převeden na velké písmeno.
        /// Ostatní znaky zůstávají beze změny.
        /// </summary>
        /// <param name="input">Vstupní text, který se má upravit.</param>
        /// <returns>Upravený text s velkými počátečními písmeny slov.</returns>
        // NOTE: otestováno
        public static string StringFirstUpperCase(string input) // otestováno, optimalizováno
        {
            if (string.IsNullOrWhiteSpace(input))
                return input;

            var sb = new StringBuilder(input.Length);
            bool makeUpper = true;

            foreach (char c in input)
            {
                if (makeUpper && char.IsLetter(c))
                {
                    sb.Append(char.ToUpper(c));
                    makeUpper = false;
                }
                else
                {
                    sb.Append(c);
                    if (c == ' ')
                        makeUpper = true;
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Vrací text doplněný uvozovkami zleva a zprava.
        /// </summary>
        /// <param name="input">Text, jenž bude uvozen.</param>
        /// <returns>Text obalený uvozovkami.</returns>
        // NOTE: otestováno
        public static string QuotedStr(string input)
        {
            return $"\"{input}\"";
        }

        /// <summary>
        /// Odstraní diakritiku z textu a vrátí jeho základní ASCII podobu.
        /// </summary>
        /// <param name="input">Text, který se má převést.</param>
        /// <returns>Text bez diakritiky.</returns>
        // NOTE: otestováno
        // TODO: Při transformaci Str1250ToANSI přejmenovat na RemoveDiacritics
        public static string RemoveDiacritics(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return input;

            string normalized = input.Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder();

            foreach (char c in normalized)
            {
                UnicodeCategory uc = CharUnicodeInfo.GetUnicodeCategory(c);
                if (uc != UnicodeCategory.NonSpacingMark)
                {
                    sb.Append(c);
                }
            }
            return sb.ToString().Normalize(NormalizationForm.FormC);
        }

        /// <summary>
        /// Nahradí všechny výskyty zadaného řetězce jiným textem. Volitelně bez ohledu na velikost písmen.
        /// </summary>
        /// <param name="search">Hledaný text.</param>
        /// <param name="input">Vstupní text, ve kterém se má nahradit.</param>
        /// <param name="replacement">Text, kterým se má nahradit.</param>
        /// <param name="ignoreCase">Pokud je true, nahrazuje bez ohledu na velikost písmen.</param>
        /// <returns>Text po nahrazení všech výskytů.</returns>
        // NOTE: otestováno
        public static string Replace(string search, string input, string replacement, bool ignoreCase = false)
        {
            if (string.IsNullOrEmpty(search)) return input;

            return ignoreCase
                ? ReplaceIgnoreCase(input, search, replacement)
                : input.Replace(search, replacement);
        }

        private static string ReplaceIgnoreCase(string input, string search, string replacement)
        {
            if (string.IsNullOrEmpty(search)) return input;

            StringBuilder result = new StringBuilder();
            int pos = 0;
            int index;

            while ((index = input.IndexOf(search, pos, StringComparison.OrdinalIgnoreCase)) != -1)
            {
                result.Append(input, pos, index - pos);
                result.Append(replacement);
                pos = index + search.Length;
            }

            result.Append(input, pos, input.Length - pos);
            return result.ToString();
        }

        /// <summary>
        /// Testuje, zda zadaný text představuje platné celé číslo v rozsahu 32bitového integeru.
        /// </summary>
        /// <param name="input">Text, který se má testovat.</param>
        /// <returns>Vrací true, pokud je text validní celé číslo (Int32), jinak false.</returns>
        // NOTE: otestováno
        public static bool IsInteger(string input)
        {
            return int.TryParse(input, NumberStyles.Integer, CultureInfo.InvariantCulture, out _);
        }

        /// <summary>
        /// Testuje, zda zadaný text představuje platné desetinné číslo.
        /// </summary>
        /// <param name="input">Text, který se má testovat.</param>
        /// <returns>Vrací true, pokud je text validní desetinné číslo, jinak false.</returns>
        // NOTE: otestováno
        // TODO: Nahrazuje funkci v delphi IsFloat - změnit v konverzním programu
        public static bool IsDecimal(string input)
        {
            return decimal.TryParse(input, NumberStyles.Number, CultureInfo.InvariantCulture, out _);
        }

        /// <summary>
        /// Testuje, zda zadaný text je ve formátu "dd.MM.yyyy" a zároveň představuje reálné datum.
        /// Pokud neprojde primární test, zkouší systémový formát.
        /// </summary>
        // NOTE: otestováno
        public static bool IsDate(string input)
        {
            if (string.IsNullOrWhiteSpace(input) || input.Length != 10)
                return false;

            if (input[2] != '.' || input[5] != '.')
                return false;

            string day = input.Substring(0, 2);
            string month = input.Substring(3, 2);
            string year = input.Substring(6, 4);

            if (!int.TryParse(day, out int d) || d < 1 || d > 31) return false;
            if (!int.TryParse(month, out int m) || m < 1 || m > 12) return false;
            if (!int.TryParse(year, out int y) || y < 1000 || y > 2099) return false;

            if (!DateTime.TryParseExact(input, "dd.MM.yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out _))
                return false;

            if (!DateTime.TryParse(input, out _))
                return false;

            return true;
        }

        /// <summary>
        /// Testuje, zda zadaný text obsahuje pouze číslice 0–9.
        /// </summary>
        // NOTE: otestováno
        public static bool IsDigit(string input)
        {
            if (string.IsNullOrEmpty(input)) return false;

            foreach (char c in input)
            {
                if (!char.IsDigit(c))
                    return false;
            }
            return true;
        }

        // TODO: Musí se upravit podle potřeby v konkrétním formuláři (ns_17CbCR). 
        //   Text bude patrně v Unicode, tak dořešit převod. 
        // 
        /// <summary>
        /// Odstraní z textu znaky, které nemají ekvivalent v Latin2 a nahradí je podobnými znaky nebo otazníkem '?'.
        /// </summary>
        /// <param name="input">Vstupní text ke zpracování.</param>
        /// <returns>Text se znaky mimo Latin2 nahrazenými alternativami nebo '?'.</returns>
        // public static string ReplaceLatin2InvalidChar(string input)
        // {
        //     if (string.IsNullOrEmpty(input)) return input;

        //     var map = new Dictionary<char, char>
        //     {
        //         [(char)129] = '?',
        //         [(char)130] = ',',
        //         [(char)131] = '?',
        //         [(char)132] = '"',
        //         [(char)133] = '.',
        //         [(char)134] = '?',
        //         [(char)135] = '?',
        //         [(char)136] = '?',
        //         [(char)137] = '?',
        //         [(char)139] = '<',
        //         [(char)144] = '?',
        //         [(char)145] = '`',
        //         [(char)146] = (char)180,
        //         [(char)147] = '"',
        //         [(char)148] = '"',
        //         [(char)149] = '-',
        //         [(char)150] = '-',
        //         [(char)151] = '-',
        //         [(char)152] = '?',
        //         [(char)153] = '?',
        //         [(char)160] = ' ',
        //         [(char)166] = '?',
        //         [(char)169] = '?',
        //         [(char)171] = '<',
        //         [(char)172] = '?',
        //         [(char)173] = '-',
        //         [(char)174] = '?',
        //         [(char)177] = '?',
        //         [(char)181] = '?',
        //         [(char)182] = '?',
        //         [(char)183] = ' ',
        //         [(char)187] = '>'
        //     };

        //     var sb = new StringBuilder(input.Length);
        //     foreach (var c in input)
        //     {
        //         if (c > 255)
        //         {
        //             sb.Append('?');
        //         }
        //         else if (map.TryGetValue(c, out var replacement))
        //         {
        //             sb.Append(replacement);
        //         }
        //         else
        //         {
        //             sb.Append(c);
        //         }
        //     }
        //     return sb.ToString();
        // }


        /// <summary>
        /// Normalizuje XML text: nahradí zakázané znaky a escapuje speciální XML znaky (&lt;, &gt;, &amp;, &apos;, &quot;).
        /// </summary>
        /// <param name="input">Vstupní XML řetězec k normalizaci.</param>
        /// <returns>Normalizovaný XML text vhodný pro zápis do dokumentu.</returns>
        // NOTE: otestováno
        public static string XmlNormChars(string input)
        {
            if (string.IsNullOrEmpty(input)) return input;

            var chars = input.ToCharArray();
            for (int i = 0; i < chars.Length; i++)
            {
                char c = chars[i];
                if (c < 32 && c != '\t' && c != '\n' && c != '\r')
                {
                    chars[i] = ' ';
                }
            }

            string result = new string(chars);
            result = result.Replace("&", "&amp;");
            result = result.Replace("<", "&lt;");
            result = result.Replace(">", "&gt;");
            result = result.Replace("'", "&apos;");
            result = result.Replace("\"", "&quot;");
            return result;
        }

        /// <summary>
        /// Odstraní zleva všechny znaky uvedené v seznamu znaků.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="trimChars">Znaky, které se mají zleva odstranit (např. ",.;").</param>
        /// <returns>Text bez zadaných znaků zleva.</returns>
        // NOTE: otestováno
        public static string TrimCharsLeft(string input, string trimChars)
        {
            if (string.IsNullOrEmpty(input) || string.IsNullOrEmpty(trimChars))
                return input;
            return input.TrimStart(trimChars.ToCharArray());
        }

        /// <summary>
        /// Odstraní zprava všechny znaky uvedené v seznamu znaků.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="trimChars">Znaky, které se mají zprava odstranit (např. ",.;").</param>
        /// <returns>Text bez zadaných znaků zprava.</returns>
        // NOTE: otestováno
        public static string TrimCharsRight(string input, string trimChars)
        {
            if (string.IsNullOrEmpty(input) || string.IsNullOrEmpty(trimChars))
                return input;
            return input.TrimEnd(trimChars.ToCharArray());
        }

        /// <summary>
        /// Odstraní zleva i zprava všechny znaky uvedené v seznamu znaků.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="trimChars">Znaky, které se mají odstranit (např. ",.;").</param>
        /// <returns>Text bez zadaných znaků na začátku i na konci.</returns>
        // NOTE: otestováno
        public static string TrimChars(string input, string trimChars)
        {
            if (string.IsNullOrEmpty(input) || string.IsNullOrEmpty(trimChars))
                return input;
            return input.Trim(trimChars.ToCharArray());
        }

        /// <summary>
        /// Odstraní z textu všechny znaky, které se vyskytují v seznamu znaků.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="removeChars">Znaky, které se mají z textu odstranit (např. ",.;").</param>
        /// <returns>Text bez všech výskytů zadaných znaků.</returns>
        // NOTE: otestováno
        public static string RemoveChars(string input, string removeChars)
        {
            if (string.IsNullOrEmpty(input) || string.IsNullOrEmpty(removeChars))
                return input;

            var result = new StringBuilder(input.Length);
            var removeSet = new HashSet<char>(removeChars);

            foreach (var c in input)
            {
                if (!removeSet.Contains(c))
                    result.Append(c);
            }
            return result.ToString();
        }

        /// <summary>
        /// Spojí dva texty zadaným oddělovačem, pokud nejsou prázdné. Oddělovač se použije jen pokud jsou oba texty neprázdné.
        /// </summary>
        /// <param name="text1">První řetězec.</param>
        /// <param name="text2">Druhý řetězec.</param>
        /// <param name="separator">Oddělovač, který se použije mezi texty (výchozí je čárka).</param>
        /// <returns>Spojený text podle pravidel, nebo prázdný řetězec.</returns>
        // NOTE: otestováno
        public static string ConcatStr(string text1, string text2, string separator = ",")
        {
            if (!string.IsNullOrEmpty(text1) && !string.IsNullOrEmpty(text2))
                return text1 + separator + text2;
            else if (!string.IsNullOrEmpty(text1))
                return text1;
            else if (!string.IsNullOrEmpty(text2))
                return text2;
            else
                return string.Empty;
        }

        /// <summary>
        /// Vrátí část textu před prvním výskytem zadaného znaku. Pokud znak není nalezen, vrací prázdný řetězec.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="separator">Znak, před kterým se má část vyjmout (výchozí je '/').</param>
        /// <returns>Část řetězce před zadaným znakem, nebo prázdný řetězec.</returns>
        // NOTE: otestováno
        public static string ExtractBeforeChar(string input, char separator = '/')
        {
            if (input == null) return string.Empty;

            int index = input.IndexOf(separator);
            return index > 0 ? input.Substring(0, index) : string.Empty;
        }

        /// <summary>
        /// Vrátí část textu za prvním výskytem zadaného znaku. Pokud znak není nalezen, vrací celý vstupní text.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="separator">Znak, za kterým se má část vyjmout (výchozí je '/').</param>
        /// <returns>Část řetězce za zadaným znakem, nebo celý vstupní text.</returns>
        // NOTE: otestováno
        public static string ExtractAfterChar(string input, char separator = '/')
        {
            if (input == null) return string.Empty;

            int index = input.IndexOf(separator);
            return index >= 0 && index + 1 < input.Length ? input[(index + 1)..] : input;
        }

        /// <summary>
        /// Vrací název měsíce podle čísla měsíce. Lze volit, zda má být malými písmeny.
        /// </summary>
        /// <param name="month">Číslo měsíce (1 až 12).</param>
        /// <param name="lowerCase">Pokud je true, vrací název měsíce malými písmeny.</param>
        /// <returns>Název měsíce nebo prázdný řetězec, pokud číslo není v rozsahu 1–12.</returns>
        public static string NameOfMonth(int month, bool lowerCase = false)
        {
            string[] monthNames = new[]
            {
                "Leden", "Únor", "Březen", "Duben", "Květen", "Červen",
                "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec"
            };

            if (month < 1 || month > 12)
                return string.Empty;

            string result = monthNames[month - 1];
            return lowerCase ? result.ToLower() : result;
        }

        /// <summary>
        /// Vrací podřetězec z textu jako v Delphi Copy – indexování od 1. Bez výjimek.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="startIndex">Pozice prvního znaku (1-based).</param>
        /// <param name="length">Počet znaků k převzetí.</param>
        /// <returns>Podřetězec nebo prázdný řetězec, pokud je vstup neplatný.</returns>
        public static string Copy(string input, int startIndex, int length)
        {
            if (string.IsNullOrEmpty(input) || startIndex < 1 || length < 1)
                return string.Empty;

            int actualStart = startIndex - 1;
            if (actualStart >= input.Length)
                return string.Empty;

            int maxLength = Math.Min(length, input.Length - actualStart);
            return input.Substring(actualStart, maxLength);
        }

        /// <summary>
        /// Odstraní část textu od dané pozice v délce znaků – jako Delphi Delete. Indexování od 1.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="startIndex">Pozice znaku odkud mazat (1-based).</param>
        /// <param name="count">Počet znaků ke smazání.</param>
        /// <returns>Text s odstraněnou částí nebo původní/prázdný řetězec při neplatném vstupu.</returns>
        public static string Delete(string input, int startIndex, int count)
        {
            if (string.IsNullOrEmpty(input) || startIndex < 1 || count < 1)
                return input ?? string.Empty;

            int actualStart = startIndex - 1;
            if (actualStart >= input.Length)
                return input;

            int safeCount = Math.Min(count, input.Length - actualStart);
            return input.Remove(actualStart, safeCount);
        }

        /// <summary>
        /// Převede text na malá písmena bez ohledu na kulturu prostředí (invariantní).
        /// </summary>
        /// <param name="input">Text, který se má převést na malá písmena.</param>
        /// <returns>Text převedený na malá písmena.</returns>
        public static string LowerCase(string input)
        {
            return input?.ToLowerInvariant() ?? string.Empty;
        }

        /// <summary>
        /// Převede text na velká písmena bez ohledu na kulturu (invariantně).
        /// </summary>
        /// <param name="input">Vstupní text, který chceme převést na velká písmena.</param>
        /// <returns>Text převedený na velká písmena.</returns>
        public static string UpperCase(string input)
        {
            return input?.ToUpperInvariant() ?? string.Empty;
        }

        /// <summary>
        /// Převede text na velká písmena podle aktuální kultury.
        /// </summary>
        /// <param name="input">Text, který se má převést na velká písmena.</param>
        /// <returns>Text převedený na velká písmena.</returns>
        public static string AnsiUpperCase(string input)
        {
            return input?.ToUpper(CultureInfo.CurrentCulture) ?? string.Empty;
        }

        /// <summary>
        /// Převede text na malá písmena podle aktuální kultury.
        /// </summary>
        /// <param name="input">Text, který se má převést na malá písmena.</param>
        /// <returns>Text převedený na malá písmena.</returns>
        public static string AnsiLowerCase(string input)
        {
            return input?.ToLower(CultureInfo.CurrentCulture) ?? string.Empty;
        }

        /// <summary>
        /// Porovná dva řetězce bez ohledu na velikost písmen a podle aktuální kultury.
        /// </summary>
        /// <param name="input">První text pro porovnání.</param>
        /// <param name="compareTo">Druhý text pro porovnání.</param>
        /// <returns>True, pokud jsou texty stejné bez ohledu na velikost písmen a kulturu.</returns>
        public static bool AnsiSameText(string input, string compareTo)
        {
            return string.Compare(input, compareTo, ignoreCase: true, culture: CultureInfo.CurrentCulture) == 0;
        }

        /// <summary>
        /// Porovná dva řetězce bez ohledu na velikost písmen a bez závislosti na kultuře.
        /// </summary>
        /// <param name="input">První text pro porovnání.</param>
        /// <param name="compareTo">Druhý text pro porovnání.</param>
        /// <returns>True, pokud jsou texty stejné bez ohledu na velikost písmen a kulturu.</returns>
        public static bool SameText(string input, string compareTo)
        {
            return string.Compare(input, compareTo, ignoreCase: true, culture: CultureInfo.InvariantCulture) == 0;
        }

        /// <summary>
        /// Vrací délku textu. Pokud je null, vrací 0.
        /// </summary>
        /// <param name="input">Řetězec, jehož délku chceme zjistit.</param>
        /// <returns>Délka textu.</returns>
        public static int Length(string input)
        {
            return input?.Length ?? 0;
        }

        /// <summary>
        /// Vrací pozici podřetězce v řetězci (1-based, ekvivalent Delphi Pos).
        /// </summary>
        /// <param name="substring">Podřetězec, který hledáme.</param>
        /// <param name="text">Text, ve kterém hledáme.</param>
        /// <returns>Pozice prvního výskytu (1-based), nebo 0 pokud nenalezeno.</returns>
        public static int Pos(string substring, string text)
        {
            if (string.IsNullOrEmpty(substring) || string.IsNullOrEmpty(text))
                return 0;

            int index = text.IndexOf(substring, StringComparison.Ordinal);
            return index >= 0 ? index + 1 : 0;
        }

        /// <summary>
        /// Odstraní mezery zleva i zprava.
        /// </summary>
        /// <param name="input">Text k oříznutí.</param>
        /// <returns>Oříznutý text.</returns>
        public static string TrimAll(string input)
        {
            return input?.Trim() ?? string.Empty;
        }

        /// <summary>
        /// Odstraní mezery zleva.
        /// </summary>
        /// <param name="input">Text k oříznutí.</param>
        /// <returns>Text bez levých mezer.</returns>
        public static string TrimLeft(string input)
        {
            return input?.TrimStart() ?? string.Empty;
        }

        /// <summary>
        /// Odstraní mezery zprava.
        /// </summary>
        /// <param name="input">Text k oříznutí.</param>
        /// <returns>Text bez pravých mezer.</returns>
        public static string TrimRight(string input)
        {
            return input?.TrimEnd() ?? string.Empty;
        }

        /// <summary>
        /// Doplňuje zleva zadaný znak, dokud text nedosáhne požadované délky.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="totalWidth">Požadovaná výsledná délka.</param>
        /// <param name="padChar">Znak pro doplnění. Výchozí je mezera.</param>
        /// <returns>Text doplněný zleva.</returns>
        public static string StrPadLeft(string input, int totalWidth, char padChar = ' ')
        {
            return (input ?? string.Empty).PadLeft(totalWidth, padChar);
        }

        /// <summary>
        /// Doplňuje zprava zadaný znak, dokud text nedosáhne požadované délky.
        /// </summary>
        /// <param name="input">Vstupní text.</param>
        /// <param name="totalWidth">Požadovaná výsledná délka.</param>
        /// <param name="padChar">Znak pro doplnění. Výchozí je mezera.</param>
        /// <returns>Text doplněný zprava.</returns>
        public static string StrPadRight(string input, int totalWidth, char padChar = ' ')
        {
            return (input ?? string.Empty).PadRight(totalWidth, padChar);
        }

        /// <summary>
        /// Formatuje řetězec podobně jako funkce Format v Delphi,
        /// převádí Delphi formátovací specifikátory na C# ekvivalenty s pořadovými čísly.
        /// </summary>
        /// <param name="format">Vstupní formátovací řetězec ve stylu Delphi.</param>
        /// <param name="args">Argumenty, které se mají formátovat.</param>
        /// <returns>Zformátovaný řetězec.</returns>
        public static string Format(string format, params object[] args)
        {
            StringBuilder csharpFormatStringBuilder = new StringBuilder();
            int argIndex = 0;

            // Přidán typ 'eE' do regexu
            string pattern = @"%(?<flags>[-0]?)(?<width>\d*)?(?:\.(?<precision>\d+))?(?<type>[sSfeEdDuUpPcCxXbBMZHiIkjJvVrRAgG])";
            MatchCollection matches = Regex.Matches(format, pattern);
            int lastIndex = 0;

            foreach (Match match in matches)
            {
                csharpFormatStringBuilder.Append(format.Substring(lastIndex, match.Index - lastIndex));

                string flags = match.Groups["flags"].Value;
                string width = match.Groups["width"].Value;
                string precision = match.Groups["precision"].Value;
                string type = match.Groups["type"].Value;

                string specifier;

                switch (type.ToLowerInvariant())
                {
                    case "s":
                        if (!string.IsNullOrEmpty(width))
                        {
                            int w = int.Parse(width);
                            specifier = flags.Contains("-")
                                ? $"{{{argIndex},-{w}}}"
                                : $"{{{argIndex},{w}}}";
                        }
                        else
                        {
                            specifier = $"{{{argIndex}}}";
                        }
                        break;

                    case "d":
                    case "u":
                        if (!string.IsNullOrEmpty(width))
                        {
                            int w = int.Parse(width);
                            if (flags.Contains("0"))
                                specifier = $"{{{argIndex}:D{w}}}";
                            else if (flags.Contains("-"))
                                specifier = $"{{{argIndex},-{w}}}";
                            else
                                specifier = $"{{{argIndex},{w}}}";
                        }
                        else if (!string.IsNullOrEmpty(precision))
                        {
                            int p = int.Parse(precision);
                            specifier = $"{{{argIndex}:D{p}}}";
                        }
                        else
                        {
                            specifier = $"{{{argIndex}}}";
                        }
                        break;

                    case "f":
                        if (!string.IsNullOrEmpty(width) && !string.IsNullOrEmpty(precision))
                        {
                            int w = int.Parse(width);
                            int p = int.Parse(precision);
                            specifier = flags.Contains("-")
                                ? $"{{{argIndex},-{w}:F{p}}}"
                                : $"{{{argIndex},{w}:F{p}}}";
                        }
                        else if (!string.IsNullOrEmpty(precision))
                        {
                            int p = int.Parse(precision);
                            specifier = $"{{{argIndex}:F{p}}}";
                        }
                        else if (!string.IsNullOrEmpty(width))
                        {
                            int w = int.Parse(width);
                            specifier = flags.Contains("-")
                                ? $"{{{argIndex},-{w}:F2}}"
                                : $"{{{argIndex},{w}:F2}}";
                        }
                        else
                        {
                            specifier = $"{{{argIndex}:F2}}";
                        }
                        break;

                    case "e":
                        if (!string.IsNullOrEmpty(width) && !string.IsNullOrEmpty(precision))
                        {
                            int w = int.Parse(width);
                            int p = int.Parse(precision);
                            specifier = flags.Contains("-")
                                ? $"{{{argIndex},-{w}:E{p}}}"
                                : $"{{{argIndex},{w}:E{p}}}";
                        }
                        else if (!string.IsNullOrEmpty(precision))
                        {
                            int p = int.Parse(precision);
                            specifier = $"{{{argIndex}:E{p}}}";
                        }
                        else if (!string.IsNullOrEmpty(width))
                        {
                            int w = int.Parse(width);
                            specifier = flags.Contains("-")
                                ? $"{{{argIndex},-{w}:E2}}"
                                : $"{{{argIndex},{w}:E2}}";
                        }
                        else
                        {
                            specifier = $"{{{argIndex}:E2}}";
                        }
                        break;

                    case "g":
                        if (!string.IsNullOrEmpty(width) && !string.IsNullOrEmpty(precision))
                        {
                            int w = int.Parse(width);
                            int p = int.Parse(precision);
                            specifier = flags.Contains("-")
                                ? $"{{{argIndex},-{w}:G{p}}}"
                                : $"{{{argIndex},{w}:G{p}}}";
                        }
                        else if (!string.IsNullOrEmpty(precision))
                        {
                            int p = int.Parse(precision);
                            specifier = $"{{{argIndex}:G{p}}}";
                        }
                        else if (!string.IsNullOrEmpty(width))
                        {
                            int w = int.Parse(width);
                            specifier = flags.Contains("-")
                                ? $"{{{argIndex},-{w}:G}}"
                                : $"{{{argIndex},{w}:G}}";
                        }
                        else
                        {
                            specifier = $"{{{argIndex}:G}}";
                        }
                        break;

                    case "x":
                        if (!string.IsNullOrEmpty(width))
                        {
                            int w = int.Parse(width);
                            specifier = $"{{{argIndex},{w}:x}}";
                        }
                        else
                        {
                            specifier = $"{{{argIndex}:x}}";
                        }
                        break;

                    case "X":
                        if (!string.IsNullOrEmpty(width))
                        {
                            int w = int.Parse(width);
                            specifier = $"{{{argIndex},{w}:X}}";
                        }
                        else
                        {
                            specifier = $"{{{argIndex}:X}}";
                        }
                        break;

                    default:
                        specifier = $"{{{argIndex}}}";
                        break;
                }

                csharpFormatStringBuilder.Append(specifier);
                lastIndex = match.Index + match.Length;
                argIndex++;
            }

            // Přidat zbytek textu po posledním matchi
            csharpFormatStringBuilder.Append(format.Substring(lastIndex));

            // Použijeme českou kulturu kvůli desetinné čárce
            return string.Format(CultureInfo.GetCultureInfo("cs-CZ"), csharpFormatStringBuilder.ToString(), args);
        }

        /// <summary>
        /// Vygeneruje nový GUID ve formátu jako Delphi CreateGUID: {VELKÝMI-PÍSMENY}.
        /// </summary>
        /// <returns>GUID jako string s velkými písmeny a závorkami.</returns>
        public static string CreateGUIDString()
        {
            return Guid.NewGuid().ToString("B").ToUpperInvariant();
        }

        // CSV UTILS (původně FCsv a statické metody z FStringList)
        // -----------------

        /// <summary>
        /// Vrací počet položek v CSV řetězci odděleném čárkami.
        /// </summary>
        /// <param name="input">CSV text.</param>
        public static int CsvCountListItems(string input)
        {
            return string.IsNullOrWhiteSpace(input) ? 0 : input.Split(',').Length;
        }

        /// <summary>
        /// Vrací položku z CSV řetězce na základě indexu.
        /// </summary>
        /// <param name="input">CSV text.</param>
        /// <param name="index">Index položky (0-based).</param>
        public static string CsvGetListItem(string input, int index)
        {
            if (string.IsNullOrWhiteSpace(input)) return string.Empty;
            var parts = input.Split(',');
            return (index >= 0 && index < parts.Length) ? parts[index].Trim() : string.Empty;
        }

        /// <summary>
        /// Přidá hodnotu do CSV seznamu, pokud tam ještě není.
        /// </summary>
        /// <param name="list">CSV text.</param>
        /// <param name="value">Hodnota, kterou chceme přidat.</param>
        public static string CsvAddValueToList(string list, string value)
        {
            if (string.IsNullOrEmpty(value)) return list ?? string.Empty;
            var parts = (list ?? "").Split(',').Select(p => p.Trim()).ToList();
            if (!parts.Contains(value))
                parts.Add(value);
            return string.Join(",", parts);
        }

        /// <summary>
        /// Odebere hodnotu ze CSV seznamu, pokud existuje.
        /// </summary>
        /// <param name="list">CSV text.</param>
        /// <param name="value">Hodnota, kterou chceme odebrat.</param>
        public static string CsvRemoveValueFromList(string list, string value)
        {
            if (string.IsNullOrEmpty(value)) return list ?? string.Empty;
            var parts = (list ?? "").Split(',').Select(p => p.Trim()).ToList();
            parts.RemoveAll(p => p == value);
            return string.Join(",", parts);
        }

        /// <summary>
        /// Vrací true, pokud CSV seznam obsahuje danou hodnotu.
        /// </summary>
        /// <param name="list">CSV text.</param>
        /// <param name="value">Hodnota k hledání.</param>
        public static bool CsvIsItemInList(string list, string value)
        {
            return (list ?? "").Split(',').Any(p => p.Trim() == value);
        }

        /// <summary>
        /// Vrací pozici hodnoty v CSV seznamu, nebo -1 pokud neexistuje.
        /// </summary>
        /// <param name="list">CSV text.</param>
        /// <param name="value">Hledaná hodnota.</param>
        public static int CsvGetItemPosition(string list, string value)
        {
            var parts = (list ?? "").Split(',').Select(p => p.Trim()).ToList();
            return parts.IndexOf(value);
        }

        /// <summary>
        /// Převede CSV seznam čísel na seznam int hodnot.
        /// </summary>
        /// <param name="csv">CSV text s čísly.</param>
        public static List<int> CsvDecodeIntegerList(string csv)
        {
            return (csv ?? "")
                .Split(',')
                .Select(s => int.TryParse(s.Trim(), out int val) ? val : (int?)null)
                .Where(v => v.HasValue)
                .Select(v => v.Value)
                .ToList();
        }

        /// <summary>
        /// Ověří, zda CSV seznam obsahuje pouze platná celá čísla.
        /// </summary>
        /// <param name="csv">CSV text.</param>
        public static bool CsvCheckValidIntegerList(string csv)
        {
            return string.IsNullOrWhiteSpace(csv) || csv.Split(',').All(s => int.TryParse(s.Trim(), out _));
        }

        /// <summary>
        /// Vrací hodnotu pole ze záznamu CSV na základě názvu sloupce.
        /// </summary>
        /// <param name="csvHeader">Hlavička CSV s názvy sloupců.</param>
        /// <param name="csvData">Řádek s daty.</param>
        /// <param name="fieldName">Název sloupce.</param>
        public static string CsvGetFieldByName(string csvHeader, string csvData, string fieldName)
        {
            if (string.IsNullOrEmpty(csvHeader) || string.IsNullOrEmpty(csvData) || string.IsNullOrEmpty(fieldName))
                return string.Empty;

            var header = csvHeader.Split(',').Select(h => h.Trim()).ToList();
            var data = csvData.Split(',').Select(d => d.Trim()).ToList();

            int index = header.IndexOf(fieldName.Trim());
            return (index >= 0 && index < data.Count) ? data[index] : string.Empty;
        }

        // DATE UTILS (původně FDays)
        // -----------------

        /// <summary>
        /// Odstraní nevhodné mezery a sjednotí oddělovače v řetězci data.
        /// </summary>
        /// <param name="dateStr">Vstupní řetězec s datem.</param>
        public static string NormalizeDateStr(string dateStr)
        {
            return dateStr?.Trim().Replace('-', '.').Replace('/', '.');
        }

        /// <summary>
        /// Upraví datum tak, že doplní nuly u dne a měsíce.
        /// </summary>
        /// <param name="dateStr">Řetězec s datem.</param>
        public static string CorrectDateString(string dateStr)
        {
            var parts = NormalizeDateStr(dateStr).Split('.');
            if (parts.Length >= 3)
            {
                return $"{parts[0].PadLeft(2, '0')}.{parts[1].PadLeft(2, '0')}.{parts[2]}";
            }
            return dateStr;
        }

        /// <summary>
        /// Ověří validitu a převede na formát dd.MM.yyyy.
        /// </summary>
        /// <param name="dateStr">Řetězec s datem.</param>
        public static string GetValidDateStr(string dateStr)
        {
            if (DateTime.TryParse(CorrectDateString(dateStr), out var dt))
                return dt.ToString("dd.MM.yyyy");
            return string.Empty;
        }

        /// <summary>
        /// Ověří validitu a převede datum na zadaný formát.
        /// </summary>
        /// <param name="dateStr">Řetězec s datem.</param>
        /// <param name="format">Cílový formát.</param>
        public static string GetValidDateStrFmt(string dateStr, string format)
        {
            if (DateTime.TryParse(CorrectDateString(dateStr), out var dt))
                return dt.ToString(format);
            return string.Empty;
        }

        /// <summary>
        /// Převede řetězec na DateTime nebo vrátí null, pokud není platný.
        /// </summary>
        /// <param name="dateStr">Řetězec s datem.</param>
        public static DateTime? EncDate(string dateStr)
        {
            if (DateTime.TryParse(CorrectDateString(dateStr), out var dt))
                return dt;
            return null;
        }

        /// <summary>
        /// Pokusí se převést datum ze vstupního textu.
        /// </summary>
        /// <param name="dateStr">Řetězec s datem.</param>
        /// <param name="result">Výstupní datum, pokud je úspěšné.</param>
        public static bool TryEncodeDateTimeEx(string dateStr, out DateTime result)
        {
            return DateTime.TryParse(CorrectDateString(dateStr), out result);
        }

        /// <summary>
        /// Vrací aktuální rok.
        /// </summary>
        public static int CurrentYear()
        {
            return DateTime.Now.Year;
        }

        /// <summary>
        /// Vrací dnešní datum bez času.
        /// </summary>
        public static DateTime TodayDate => DateTime.Today;

        /// <summary>
        /// Vrací aktuální datum a čas.
        /// </summary>
        public static DateTime NowDateTime => DateTime.Now;

        /// <summary>
        /// Vrací den z data.
        /// </summary>
        public static int DayOf(DateTime dt) => dt.Day;

        /// <summary>
        /// Vrací měsíc z data.
        /// </summary>
        public static int MonthOf(DateTime dt) => dt.Month;

        /// <summary>
        /// Vrací rok z data.
        /// </summary>
        public static int YearOf(DateTime dt) => dt.Year;

        /// <summary>
        /// Vrací počet dní v daném měsíci a roce.
        /// </summary>
        public static int DaysInMonth(int year, int month) => DateTime.DaysInMonth(year, month);

        /// <summary>
        /// Vrací počet dní v roce.
        /// </summary>
        public static int DaysInYear(int year) => (DateTime.IsLeapYear(year) ? 366 : 365);

        /// <summary>
        /// Vrací počet dní mezi dvěma daty.
        /// </summary>
        public static int DaysBetween(DateTime fromDate, DateTime toDate) => (toDate - fromDate).Days;

        /// <summary>
        /// Rozloží datum na rok, měsíc a den.
        /// </summary>
        public static (int year, int month, int day) DecodeDate(DateTime dt) => (dt.Year, dt.Month, dt.Day);

        /// <summary>
        /// Rozloží datum na rok, měsíc, den a den v týdnu.
        /// </summary>
        public static (int year, int month, int day, int dayOfWeek) DecodeDateFully(DateTime dt)
            => (dt.Year, dt.Month, dt.Day, (int)dt.DayOfWeek);

        /// <summary>
        /// Vytvoří datum ze zadaných hodnot.
        /// </summary>
        public static DateTime EncodeDate(int year, int month, int day) => new DateTime(year, month, day);

        /// <summary>
        /// Přičte počet dní k datu.
        /// </summary>
        public static DateTime IncDay(DateTime dt, int days = 1) => dt.AddDays(days);

        /// <summary>
        /// Přičte počet měsíců k datu.
        /// </summary>
        public static DateTime IncMonth(DateTime dt, int months = 1) => dt.AddMonths(months);

        /// <summary>
        /// Přičte počet let k datu.
        /// </summary>
        public static DateTime IncYear(DateTime dt, int years = 1) => dt.AddYears(years);

        /// <summary>
        /// Vrací datum ve formátu dle zadané masky.
        /// </summary>
        /// <param name="format">Formátovací řetězec (např. "dd.MM.yyyy").</param>
        /// <param name="dt">Formátované datum.</param>
        public static string FormatDateTime(string format, DateTime dt)
            => dt.ToString(format, CultureInfo.InvariantCulture);

        /// <summary>
        /// Vrací číslo dne v týdnu.
        /// </summary>
        /// <param name="dt">Datum.</param>
        /// <returns>Den v týdnu.</returns>
        public static int DayOfTheWeek(DateTime dt) 
            => (int)dt.DayOfWeek;

        // MATH UTILS (původně FCalc)
        // -----------------

        /// <summary>
        /// Zaokrouhlí číslo na nejbližší celé číslo.
        /// </summary>
        public static int Round(double value) => (int)Math.Round(value, MidpointRounding.AwayFromZero);

        /// <summary>
        /// Zaokrouhlí číslo na nejbližší celé číslo.
        /// </summary>
        public static int Round(decimal value) => (int)Math.Round(value, MidpointRounding.AwayFromZero);

        /// <summary>
        /// Vrací celočíselnou část čísla (truncation).
        /// </summary>
        public static int Trunc(double value) => (int)(value < 0 ? Math.Ceiling(value) : Math.Floor(value));

        /// <summary>
        /// Vrací celočíselnou část čísla (truncation).
        /// </summary>
        public static int Trunc(decimal value) => (int)(value < 0 ? Math.Ceiling(value) : Math.Floor(value));

        /// <summary>
        /// Vrací celočíselnou část čísla.
        /// </summary>
        public static int Int(double value) => Trunc(value);

        /// <summary>
        /// Vrací celočíselnou část čísla.
        /// </summary>
        public static int Int(decimal value) => Trunc(value);

        /// <summary>
        /// Vrací desetinnou část čísla.
        /// </summary>
        public static double Frac(double value) => value - Trunc(value);

        /// <summary>
        /// Vrací desetinnou část čísla.
        /// </summary>
        public static decimal Frac(decimal value) => value - Trunc(value);

        /// <summary>
        /// Vrací menší ze dvou srovnatelných hodnot.
        /// </summary>
        public static T Min<T>(T a, T b) where T : IComparable<T> => a.CompareTo(b) < 0 ? a : b;

        /// <summary>
        /// Vrací větší ze dvou srovnatelných hodnot.
        /// </summary>
        public static T Max<T>(T a, T b) where T : IComparable<T> => a.CompareTo(b) > 0 ? a : b;

        /// <summary>
        /// Vrací absolutní hodnotu čísla.
        /// </summary>
        public static double Abs(double value) => Math.Abs(value);

        /// <summary>
        /// Vrací absolutní hodnotu čísla.
        /// </summary>
        public static decimal Abs(decimal value) => Math.Abs(value);

        /// <summary>
        /// Provádí celočíselné dělení.
        /// </summary>
        public static int Div(int a, int b) => a / b;

        /// <summary>
        /// Vrací zbytek po celočíselném dělení.
        /// </summary>
        public static int Mod(int a, int b) => a % b;

        /// <summary>
        /// Zaokrouhlí desetinné číslo nahoru na zadaný počet desetinných míst.
        /// </summary>
        public static decimal RoundUp(decimal value, int digit = -2)
        {
            if (value == 0) return 0;
            var factor = (decimal)Math.Pow(10, -digit);
            var scaled = Math.Floor(Math.Abs(value) * factor);
            var result = scaled / factor;
            if (result < Math.Abs(value))
                result += 1 / factor;
            return Math.Sign(value) * result;
        }

        /// <summary>
        /// Zaokrouhlí číslo typu double nahoru na zadaný počet desetinných míst.
        /// </summary>
        public static double RoundUp(double value, int digit = -2) => (double)RoundUp((decimal)value, digit);

        /// <summary>
        /// Zaokrouhlí desetinné číslo dolů na zadaný počet desetinných míst.
        /// </summary>
        public static decimal RoundDown(decimal value, int digit = -2)
        {
            var factor = (decimal)Math.Pow(10, -digit);
            var result = Math.Floor(value * factor) / factor;
            return result;
        }

        /// <summary>
        /// Zaokrouhlí číslo typu double dolů na zadaný počet desetinných míst.
        /// </summary>
        public static double RoundDown(double value, int digit = -2) => (double)RoundDown((decimal)value, digit);

        /// <summary>
        /// Zaokrouhlí desetinné číslo na nejbližší polovinu (0, 0.5 nebo 1).
        /// </summary>
        public static decimal RoundHalf(decimal value)
        {
            var fr = (int)(Frac(value) * 100);
            decimal part = fr switch
            {
                < 25 => 0m,
                < 75 => 0.5m,
                _ => 1m
            };
            return Int(value) + part;
        }

        /// <summary>
        /// Zaokrouhlí číslo typu double na nejbližší polovinu (0, 0.5 nebo 1).
        /// </summary>
        public static double RoundHalf(double value) => (double)RoundHalf((decimal)value);

        /// <summary>
        /// Zaokrouhlí desetinné číslo na nejbližší polovinu, zaokrouhluje .01-.50 nahoru na .5 a .51-.99 nahoru na 1.
        /// </summary>
        public static decimal RoundHalfUp(decimal value)
        {
            var fr = (int)(Frac(value) * 100);
            decimal part = fr switch
            {
                0 => 0m,
                <= 50 => 0.5m,
                _ => 1m
            };
            return Int(value) + part;
        }

        /// <summary>
        /// Zaokrouhlí číslo typu double na nejbližší polovinu, zaokrouhluje .01-.50 nahoru na .5 a .51-.99 nahoru na 1.
        /// </summary>
        public static double RoundHalfUp(double value) => (double)RoundHalfUp((decimal)value);

        /// <summary>
        /// Vrací větší ze dvou čísel typu double.
        /// </summary>
        public static double MaxFloat(double a, double b) => Math.Max(a, b);

        /// <summary>
        /// Vrací větší ze dvou čísel typu decimal.
        /// </summary>
        public static decimal MaxFloat(decimal a, decimal b) => Math.Max(a, b);

        /// <summary>
        /// Vrací menší ze dvou čísel typu double.
        /// </summary>
        public static double MinFloat(double a, double b) => Math.Min(a, b);

        /// <summary>
        /// Vrací menší ze dvou čísel typu decimal.
        /// </summary>
        public static decimal MinFloat(decimal a, decimal b) => Math.Min(a, b);

        /// <summary>
        /// Formátuje číslo typu double pomocí invariantní kultury.
        /// </summary>
        /// <param name="format">Formátovací řetězec.</param>
        /// <param name="value">Hodnota k formátování.</param>
        /// <returns>Formátovaný řetězec.</returns>
        public static string FormatFloat(string format, double value)
        {
            return value.ToString(format, System.Globalization.CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Formátuje číslo typu decimal pomocí invariantní kultury.
        /// </summary>
        /// <param name="format">Formátovací řetězec.</param>
        /// <param name="value">Hodnota k formátování.</param>
        /// <returns>Formátovaný řetězec.</returns>
        public static string FormatFloat(string format, decimal value)
        {
            return value.ToString(format, System.Globalization.CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Převádí částku na slova (česká varianta) – omezená implementace.
        /// </summary>
        public static string AmountByWords(decimal amount, bool upperFirstChar = false)
        {
            string[] jednotky =
            {
                "nula", "jedna", "dva", "tři", "čtyři", "pět", "šest", "sedm", "osm", "devět",
                "deset", "jedenáct", "dvanáct", "třináct", "čtrnáct", "patnáct", "šestnáct", "sedmnáct", "osmnáct", "devatenáct"
            };

            string[] desitky =
            {
                "", "", "dvacet", "třicet", "čtyřicet", "padesát", "šedesát", "sedmdesát", "osmdesát", "devadesát"
            };

            string[] stovky =
            {
                "", "sto", "dvě stě", "tři sta", "čtyři sta", "pět set", "šest set", "sedm set", "osm set", "devět set"
            };

            string ToWords(int number)
            {
                if (number == 0) return jednotky[0];

                string result = "";
                if (number / 100 > 0)
                {
                    result += stovky[number / 100] + " ";
                    number %= 100;
                }
                if (number >= 20)
                {
                    result += desitky[number / 10] + " ";
                    number %= 10;
                }
                if (number > 0)
                {
                    result += jednotky[number] + " ";
                }
                return result.Trim();
            }

            int v = (int)Math.Abs(Math.Truncate(amount));
            string resultText = v == 0 ? jednotky[0] : "";

            if (v >= 1_000_000_000)
            {
                resultText += ToWords(v / 1_000_000_000) + " miliard ";
                v %= 1_000_000_000;
            }
            if (v >= 1_000_000)
            {
                resultText += ToWords(v / 1_000_000) + " milionů ";
                v %= 1_000_000;
            }
            if (v >= 1_000)
            {
                resultText += ToWords(v / 1_000) + " tisíc ";
                v %= 1_000;
            }
            if (v > 0)
            {
                resultText += ToWords(v);
            }

            if (amount < 0)
            {
                resultText = "mínus " + resultText;
            }

            resultText = resultText.Trim();
            if (upperFirstChar && resultText.Length > 0)
            {
                resultText = char.ToUpper(resultText[0]) + resultText.Substring(1);
            }
            return resultText;
        }

        /// <summary>
        /// Převádí číslo na slova (česká varianta) – omezená implementace.
        /// </summary>
        public static string AmountByWords(double amount, bool upperFirstChar = false)
        {
            return AmountByWords((decimal)amount, upperFirstChar);
        }

        // CONVERSION UTILS (původně FConv)
        //-----------------

        /// <summary>
        /// Převede text na celé číslo. Pokud není platné číslo, vrací 0.
        /// </summary>
        public static int StrToIntSafe(string input)
            => int.TryParse(input, NumberStyles.Integer, CultureInfo.InvariantCulture, out var result) ? result : 0;

        /// <summary>
        /// Převede text na číslo s desetinnou čárkou. Pokud není platné číslo, vrací 0.
        /// </summary>
        public static double StrToFloatSafe(string input)
            => double.TryParse(input, NumberStyles.Float, CultureInfo.InvariantCulture, out var result) ? result : 0;

        /// <summary>
        /// Převede text na boolean. Přijímá „true“, „1“, „ano“, „yes“. Jinak false.
        /// </summary>
        public static bool StrToBoolSafe(string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return false;
            input = input.Trim().ToLowerInvariant();
            return input is "true" or "1" or "ano" or "yes";
        }

        /// <summary>
        /// Převede base64 MIME text na binární soubor.
        /// </summary>
        /// <param name="base64String">Řetězec kódovaný v base64.</param>
        /// <param name="filePath">Cesta k výstupnímu souboru.</param>
        public static void StringMimeToBinaryFile(string base64String, string filePath)
        {
            var bytes = Convert.FromBase64String(base64String);
            File.WriteAllBytes(filePath, bytes);
        }

        /// <summary>
        /// Přečte binární soubor a vrátí jeho obsah jako base64 MIME string.
        /// </summary>
        /// <param name="filePath">Cesta k souboru.</param>
        /// <returns>Řetězec v base64 MIME formátu.</returns>
        public static string BinaryFileToStringMime(string filePath)
        {
            var bytes = File.ReadAllBytes(filePath);
            return Convert.ToBase64String(bytes);
        }

        /// <summary>
        /// Přečte binární soubor a vrátí jeho obsah jako base64 string (bez zalomení řádků).
        /// </summary>
        /// <param name="filePath">Cesta k souboru.</param>
        /// <returns>Řetězec v base64.</returns>
        public static string BinaryFileToStringBase64(string filePath)
        {
            var bytes = File.ReadAllBytes(filePath);
            return Convert.ToBase64String(bytes);
        }

        /// <summary>
        /// Převede text na datum. Pokud není platné datum, vrací DateTime.MinValue.
        /// </summary>
        public static DateTime StrToDateSafe(string input)
            => DateTime.TryParse(input, CultureInfo.InvariantCulture, DateTimeStyles.None, out var result) ? result : DateTime.MinValue;

        /// <summary>
        /// Vrací datum jako řetězec ve formátu yyyy-MM-dd.
        /// </summary>
        public static string DateToStrNorm(DateTime date)
            => date.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);

        /// <summary>
        /// Vrací desetinnou část čísla jako řetězec (oddělovač .).
        /// </summary>
        public static string Frac2Str(double value)
        {
            var frac = value - Math.Truncate(value);
            return frac.ToString("0.##################", CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Vrací celočíselnou část čísla jako řetězec.
        /// </summary>
        public static string IntPart2Str(double value)
            => ((long)Math.Truncate(value)).ToString(CultureInfo.InvariantCulture);

        /// <summary>
        /// Vrací celočíselnou část řetězce s číslem oddělenou tečkou.
        /// </summary>
        public static string FloatFieldIntPartStr(string value)
        {
            var parts = value.Split('.', ',');
            return parts.Length > 0 ? parts[0] : string.Empty;
        }

        /// <summary>
        /// Vrací desetinnou část řetězce s číslem.
        /// </summary>
        public static string FloatFieldFracPartStr(string value)
        {
            var parts = value.Split('.', ',');
            return parts.Length > 1 ? parts[1] : string.Empty;
        }

        /// <summary>
        /// Vyhodnotí řetězec s datem/časem a převede na DateTime. Pokud selže, vrátí DateTime.MinValue.
        /// </summary>
        public static DateTime DateTimeStrEval(string input)
            => DateTime.TryParse(input, CultureInfo.InvariantCulture, DateTimeStyles.None, out var result) ? result : DateTime.MinValue;

        /// <summary>
        /// Převede UTF-8 byte pole na ANSI string (v C# jako string z UTF8).
        /// </summary>
        public static string UTF8ToAnsiString(byte[] utf8bytes)
            => Encoding.Default.GetString(Encoding.Convert(Encoding.UTF8, Encoding.Default, utf8bytes));

        /// <summary>
        /// Převod čísla na řetězec s invariantní kulturou.
        /// </summary>
        public static string FloatToStr(double value)
            => value.ToString(CultureInfo.InvariantCulture);

        /// <summary>
        /// Převede text na číslo (double), vyhodí výjimku pokud nelze.
        /// </summary>
        public static double StrToFloat(string input)
            => double.Parse(input, CultureInfo.InvariantCulture);

        /// <summary>
        /// Převede text na boolean. Vyhodí výjimku pokud nelze.
        /// </summary>
        public static bool StrToBool(string input)
            => bool.Parse(input);

        /// <summary>
        /// Převede boolean na řetězec "true" nebo "false".
        /// </summary>
        public static string BoolToStr(bool value)
            => value.ToString().ToLowerInvariant();

        /// <summary>
        /// Převede text na decimal (měna), vyhodí výjimku pokud nelze.
        /// </summary>
        public static decimal StrToCurr(string input)
            => decimal.Parse(input, CultureInfo.InvariantCulture);

        /// <summary>
        /// Převede text na datum. Vyhodí výjimku pokud neplatné.
        /// </summary>
        public static DateTime StrToDate(string input)
            => DateTime.Parse(input, CultureInfo.InvariantCulture);

        /// <summary>
        /// Převede datum na string dle kultury.
        /// </summary>
        public static string DateToStr(DateTime dt)
            => dt.ToString("d", CultureInfo.InvariantCulture);

        /// <summary>
        /// Převede text na celé číslo. Vyhodí výjimku pokud nelze.
        /// </summary>
        public static int StrToInt(string input)
            => int.Parse(input, CultureInfo.InvariantCulture);

        /// <summary>
        /// Převede datum a čas na string.
        /// </summary>
        public static string DateTimeToStr(DateTime dt)
            => dt.ToString(CultureInfo.InvariantCulture);

        /// <summary>
        /// Převede objekt na řetězec.
        /// </summary>
        public static string VarToStr(object value)
            => Convert.ToString(value, CultureInfo.InvariantCulture) ?? string.Empty;

        /// <summary>
        /// Převede objekt na DateTime. Pokud nelze, vrací DateTime.MinValue.
        /// </summary>
        public static DateTime VarToDateTime(object value)
            => DateTime.TryParse(Convert.ToString(value), CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt) ? dt : DateTime.MinValue;

        /// <summary>
        /// Převod z ANSI na UTF8.
        /// </summary>
        public static byte[] AnsiToUTF8(string input)
            => Encoding.UTF8.GetBytes(Encoding.Default.GetString(Encoding.Default.GetBytes(input)));

        /// <summary>
        /// Převod z UTF8 na ANSI.
        /// </summary>
        public static string UTF8ToAnsi(string input)
            => Encoding.Default.GetString(Encoding.UTF8.GetBytes(input));

        // FILE UTILS (původně FFiles)
        // -----------------

        /// <summary>
        /// Normalizuje cestu (nahradí zpětná lomítka za obyčejná).
        /// </summary>
        public static string NormalPath(string path)
            => path?.Replace("\\", "/") ?? string.Empty;

        /// <summary>
        /// Vrací jedinečný název souboru v daném adresáři.
        /// </summary>
        public static string GetUniqueFileName(string directory, string baseName, string extension)
        {
            int index = 1;
            string filePath;
            do
            {
                var name = index == 1 ? baseName : $"{baseName}_{index}";
                filePath = Path.Combine(directory, name + extension);
                index++;
            } while (File.Exists(filePath));
            return filePath;
        }

        /// <summary>
        /// Nahradí neplatné znaky ve jménu souboru znakem podtržítko.
        /// </summary>
        public static string SetValidFileName(string fileName)
            => string.Join("", fileName.Select(c => Path.GetInvalidFileNameChars().Contains(c) ? '_' : c));

        /// <summary>
        /// Nahradí neplatné znaky a ořízne mezeru.
        /// </summary>
        public static string SetValidFileNameTrim(string fileName)
            => SetValidFileName(fileName).Trim();

        /// <summary>
        /// Vrací verzi aktuálního spuštěného assembly.
        /// </summary>
        public static string GetPpgVersion()
            => System.Reflection.Assembly.GetExecutingAssembly().GetName().Version?.ToString() ?? "1.0.0.0";

        /// <summary>
        /// Porovná dvě verze (formát X.Y.Z) a vrací -1, 0, 1.
        /// </summary>
        public static int CompareVersion(string v1, string v2)
        {
            var a = Version.Parse(v1);
            var b = Version.Parse(v2);
            return a.CompareTo(b);
        }

        /// <summary>
        /// Vyhledá všechny soubory dle masky a rekurzivně.
        /// </summary>
        public static string[] SearchFiles(string path, string pattern, bool recursive = true)
            => Directory.GetFiles(path, pattern, recursive ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly);

        /// <summary>
        /// Uloží seznam řádků do INI souboru jako jedna sekce.
        /// </summary>
        public static void SaveStringsToIni(string filePath, string section, string[] lines)
        {
            using var sw = new StreamWriter(filePath, false);
            sw.WriteLine($"[{section}]");
            for (int i = 0; i < lines.Length; i++)
                sw.WriteLine($"Item{i}={lines[i]}");
        }

        /// <summary>
        /// Načte řádky ze sekce z INI souboru.
        /// </summary>
        public static string[] LoadStringsFromIni(string filePath, string section)
        {
            if (!File.Exists(filePath)) return Array.Empty<string>();
            var lines = File.ReadAllLines(filePath);
            var inSection = false;
            return lines
                .Where(line =>
                {
                    if (line.StartsWith("[")) inSection = line.Equals("[" + section + "]", StringComparison.OrdinalIgnoreCase);
                    return inSection && line.Contains('=');
                })
                .Select(line => line[(line.IndexOf('=') + 1)..])
                .ToArray();
        }

        /// <summary>
        /// Pokusí se smazat adresář i se soubory. Pokud se nepodaří, vrací false.
        /// </summary>
        public static bool TryDeleteDirectory(string path)
        {
            try
            {
                if (Directory.Exists(path)) Directory.Delete(path, true);
                return true;
            }
            catch { return false; }
        }

        /// <summary>
        /// Smaže víc souborů.
        /// </summary>
        public static void DeleteFiles(params string[] files)
        {
            foreach (var f in files)
            {
                if (File.Exists(f)) File.Delete(f);
            }
        }

        /// <summary>
        /// Získá název souboru z cesty.
        /// </summary>
        public static string ExtractFileName(string path)
            => Path.GetFileName(path);

        /// <summary>
        /// Získá cestu k adresáři ze souborové cesty.
        /// </summary>
        public static string ExtractFilePath(string path)
            => Path.GetDirectoryName(path) ?? string.Empty;

        /// <summary>
        /// Získá příponu souboru z cesty.
        /// </summary>
        public static string ExtractFileExt(string path)
            => Path.GetExtension(path);

        /// <summary>
        /// Získá cestu k adresáři ze souborové cesty.
        /// </summary>
        public static string ExtractFileDir(string path)
            => Path.GetDirectoryName(path) ?? string.Empty;

        /// <summary>
        /// Změní příponu souboru v dané cestě.
        /// </summary>
        public static string ChangeFileExt(string path, string newExt)
            => Path.ChangeExtension(path, newExt);

        /// <summary>
        /// Vytvoří všechny adresáře a podadresáře v zadané cestě, pokud již neexistují.
        /// </summary>
        public static void ForceDirectories(string path)
            => Directory.CreateDirectory(path);

        /// <summary>
        /// Smaže zadaný soubor.
        /// </summary>
        public static void DeleteFile(string path)
        {
            if (File.Exists(path)) File.Delete(path);
        }

        /// <summary>
        /// Určuje, zda zadaný soubor existuje.
        /// </summary>
        public static bool FileExists(string path)
            => File.Exists(path);

        // CHECK UTILS (původně FCheck)
        // -----------------

        /// <summary>
        /// Ověří platnost rodného čísla (český formát).
        /// </summary>
        public static bool CheckRodneCislo(string rc)
        {
            rc = rc.Replace("/", "").Trim();
            //if (!Regex.IsMatch(rc, "^\d{9,10}$")) return false; // Původní kontrola je zakomentována, protože předchozí řádek by ji mohl způsobit problém

            if (rc.Length == 10 && long.Parse(rc.Substring(0, 9)) % 11 != long.Parse(rc.Substring(9, 1)))
                return false;

            int year = int.Parse(rc.Substring(0, 2));
            int month = int.Parse(rc.Substring(2, 2));
            int day = int.Parse(rc.Substring(4, 2));

            if (month > 50) month -= 50;
            if (month > 20 && year >= 54) month -= 20;

            try
            {
                _ = new DateTime(year > 53 ? 1900 + year : 2000 + year, month, day);
            }
            catch { return false; }

            return true;
        }

        /// <summary>
        /// Ověří platnost IČO (české identifikační číslo).
        /// </summary>
        public static bool CheckICO(string ico)
        {
            ico = Regex.Replace(ico, "\\s", "");
            if (!Regex.IsMatch(ico, "^\\d{8}$")) return false;

            int sum = 0;
            for (int i = 0; i < 7; i++)
                sum += (8 - i) * (ico[i] - '0');

            int mod = sum % 11;
            int check = (mod == 0) ? 1 : (mod == 1 ? 0 : 11 - mod);

            return check == (ico[7] - '0');
        }

        /// <summary>
        /// Ověří platnost DIČ (CZ + IČO).
        /// </summary>
        public static bool CheckDIC(string dic)
        {
            dic = dic.Trim().ToUpperInvariant();
            if (!dic.StartsWith("CZ")) return false;
            return CheckICO(dic.Substring(2));
        }

        /// <summary>
        /// Ověří kontrolní číslici čísla účtu (český formát – základní účet bez předčíslí).
        /// </summary>
        public static bool CheckBU(string account)
        {
            if (!long.TryParse(account, out var num)) return false;
            int[] multipliers = { 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 };
            string padded = num.ToString().PadLeft(10, '0');
            long sum = 0;
            for (int i = 0; i < 10; i++)
                sum += (padded[i] - '0') * multipliers[i];
            return sum % 11 == 0;
        }

        /// <summary>
        /// Ověří platnost IBANu podle kontrolního algoritmu.
        /// </summary>
        public static bool CheckIBAN(string iban)
        {
            iban = Regex.Replace(iban.ToUpperInvariant(), "\\s", "");
            if (!Regex.IsMatch(iban, "^[A-Z]{2}[0-9A-Z]{13,32}$")) return false;

            string rearranged = iban.Substring(4) + iban.Substring(0, 4);
            string numeric = string.Concat(rearranged.Select(c => char.IsDigit(c) ? c.ToString() : ((int)c - 55).ToString()));

            int remainder = 0;
            foreach (char c in numeric)
            {
                int digit = int.Parse(c.ToString());
                remainder = (remainder * 10 + digit) % 97;
            }
            return remainder == 1;
        }

        /// <summary>
        /// Ověří, zda je počítač připojen k internetu pomocí síťového rozhraní.
        /// </summary>
        /// <returns>True pokud je síťové připojení aktivní, jinak false.</returns>
        public static bool IsConnectedToInternet()
        {
            return NetworkInterface.GetIsNetworkAvailable();
        }

        // ZIP UTILS (původně FZip)
        // -----------------

        /// <summary>
        /// Vytvoří ZIP archiv ze zadané složky.
        /// </summary>
        /// <param name="sourceDirectory">Cesta ke složce, která se má zabalit.</param>
        /// <param name="destinationZipFilePath">Výstupní cesta pro ZIP soubor.</param>
        /// <param name="overwrite">Přepsat existující soubor, pokud existuje.</param>
        public static void CreateZipFromFolder(string sourceDirectory, string destinationZipFilePath, bool overwrite = true)
        {
            if (File.Exists(destinationZipFilePath) && overwrite)
                File.Delete(destinationZipFilePath);
            ZipFile.CreateFromDirectory(sourceDirectory, destinationZipFilePath);
        }

        /// <summary>
        /// Rozbalí ZIP archiv do zadané složky.
        /// </summary>
        /// <param name="zipFilePath">Cesta k ZIP souboru.</param>
        /// <param name="destinationDirectory">Cílová složka pro rozbalení.</param>
        /// <param name="overwrite">Přepsat soubory, pokud již existují.</param>
        public static void ExtractZipToFolder(string zipFilePath, string destinationDirectory, bool overwrite = true)
        {
            if (overwrite && Directory.Exists(destinationDirectory))
                Directory.Delete(destinationDirectory, true);
            ZipFile.ExtractToDirectory(zipFilePath, destinationDirectory);
        }

        /// <summary>
        /// Vyprázdní hodnotu fieldu (např. FaProperty) voláním SetValue(null).
        /// </summary>
        /// <param name="field">Objekt fieldu, který má být vyprázdněn.</param>
        public static void ClearField(dynamic field)
        {
            field.SetValue(null);
        }

        /// <summary>
        /// Prozatímní stub pro lookup hodnoty v seznamu. Vrací vždy null.
        /// </summary>
        /// <param name="listName">Název seznamu.</param>
        /// <param name="date">Datum pro lookup.</param>
        /// <param name="keyField">Název klíčového pole.</param>
        /// <param name="keyValue">Hodnota klíče.</param>
        /// <param name="resultField">Název pole, jehož hodnotu chceme získat.</param>
        /// <returns>Vždy null (stub).</returns>
        public static object LstLookup(string listName, DateTime date, string keyField, object keyValue, string resultField)
        {
            // TODO: Implementace lookupu v seznamu
            return null;
        }

        /// <summary>
        /// Prozatímní stub pro získání parametru klienta. Vrací vždy prázdný řetězec.
        /// </summary>
        /// <param name="paramName">Název parametru.</param>
        /// <returns>Vždy prázdný řetězec (stub).</returns>
        public static string ClientParam(string paramName)
        {
            // TODO: Implementace získání parametru klienta
            return "";
        }

    }
}
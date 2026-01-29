{ 27.1.2026 10:28:10 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Oprava velikosti dialogu  }
{ 27.1.2026 10:24:43 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Upravy generovani - zaporne hodonty  }
unit FTestUtils;
//Redesignováno 24.01.2026 v15
//TODO: u fill zvyšování od startvalue jen pro vyplňované údaje
//TODO: pořešit zvyšování desetinného čísla
interface

uses
  Classes, SysUtils, DateUtils, Main, FUtils, FCommonUtils, uLkJSON, kbmMemTable, DB, IniFiles, Windows;

type
  /// <summary>
  /// Nová struktura pro pole s pořadím a vygenerovanou hodnotou
  /// </summary>
  TFieldOrderInfo = record
    FieldName: string;      // Název pole
    PageKey: Integer;       // Sekvenční číslo stránky (1, 2, 3...)
    X: Integer;             // Left souřadnice (původní)
    Y: Integer;             // Vypočtené: PageKey*1000 + Top
    DataType: string;       // 'String', 'Number', 'Date', 'Boolean', 'Memo'
    Places: Integer;        // Z JSON: FldTypePlaces
    DisplayFormat: string;  // Z JSON: DisplayFormat
    Visible: Boolean;       // Z JSON: Visible
    Order: Integer;         // Vypočtené pořadí v rámci typu
    TextValue: string;      // Vygenerovaná hodnota
  end;
  
  TFieldOrderInfoArray = array of TFieldOrderInfo;
  
  /// <summary>
  /// Typ příkazu pro generování
  /// </summary>
  TCommandType = (ctClear, ctFillAll, ctFill, ctCalculate, ctDisabling);
  
  /// <summary>
  /// Parametry pro generování hodnot
  /// </summary>
  TGenerationParams = record
    Text: string;              // Pro text="..."
    StartValue: Double;        // Pro start=10 nebo start=3.26 (celé i desetinné)
    StepValue: Double;         // Pro step=5 nebo step=0.1 (celé i desetinné)
    DecimalPlaces: Integer;    // Pro decimal=2
    DecimalStartValue: Double; // Pro decimalstart=0.5 (oddělené zvyšování desetinné části)
    DecimalStepValue: Double;  // Pro decimalstep=0.1 (oddělené zvyšování desetinné části)
    WordCount: Integer;        // Pro words=3 (0 = nepoužívat)
    AddOrderPrefix: Boolean;   // Pro #,words
    AddOrderSuffix: Boolean;   // Pro words,#
    ClearBefore: Boolean;      // True = smazat před vyplněním, False = vyplnit jen prázdné
    CheckBoxValue: Boolean;    // Pro checkbox=true/false
    CheckBoxSet: Boolean;      // True = byl zadán parametr checkbox=
    StartValueHasDecimal: Boolean; // True = start obsahuje desetinnou část
  end;
  
  /// <summary>
  /// Jeden příkaz pro generování
  /// </summary>
  TCommand = record
    CommandType: TCommandType;
    FieldPattern: string;      // Pro fill: "R*", "R0?a" atd.
    Params: TGenerationParams;
    BoolValue: Boolean;        // Pro calculate=on/off, disabling=on/off
  end;
  
  TCommandArray = array of TCommand;

/// <summary>
/// Vyplní testovací hodnoty přímo do mtValues podle pořadí z design.json
/// </summary>
function FillTestValuesToMtValues: Boolean;

implementation

uses
  Dialogs, Controls, SPolFunkce, Forms, StdCtrls;

const
  ROW_TOLERANCE = 5; // Tolerance v pixelech pro určení, že pole jsou "ve stejném řádku"

var
  GWordDictionary: TStringList = nil; // Cache pro slovník slov

/// <summary>
/// Extrahuje textový parametr text="..." nebo text='...'
/// </summary>
function ExtractTextParam(const ALine: string): string;
var
  startPos, endPos: Integer;
  quoteChar: Char;
begin
  Result := '';
  
  // Najít text=
  startPos := Pos('text=', LowerCase(ALine));
  if startPos = 0 then
    Exit;
  
  startPos := startPos + 5; // Přeskočit "text="
  
  // Najít uvozovky
  if startPos > Length(ALine) then
    Exit;
  
  quoteChar := ALine[startPos];
  if (quoteChar <> '"') and (quoteChar <> '''') then
    Exit;
  
  Inc(startPos); // Přeskočit první uvozovku
  
  // Najít uzavírací uvozovku
  endPos := startPos;
  while (endPos <= Length(ALine)) and (ALine[endPos] <> quoteChar) do
    Inc(endPos);
  
  if endPos > Length(ALine) then
    Exit;
  
  Result := Copy(ALine, startPos, endPos - startPos);
end;

/// <summary>
/// Extrahuje číselný parametr (např. start=10)
/// </summary>
function ExtractNumberParam(const ALine, AParamName: string): Integer;
var
  startPos, endPos: Integer;
  valueStr: string;
begin
  Result := -1; // -1 = nebylo nalezeno
  
  startPos := Pos(LowerCase(AParamName) + '=', LowerCase(ALine));
  if startPos = 0 then
    Exit;
  
  startPos := startPos + Length(AParamName) + 1; // Přeskočit "param="
  
  // Najít konec čísla (mezera nebo konec řádku)
  endPos := startPos;
  while (endPos <= Length(ALine)) and (ALine[endPos] in ['0'..'9', '-']) do
    Inc(endPos);
  
  valueStr := Copy(ALine, startPos, endPos - startPos);
  
  try
    Result := StrToInt(valueStr);
  except
    Result := -1;
  end;
end;

/// <summary>
/// Extrahuje desetinný parametr (např. decimalstart=0.5)
/// </summary>
function ExtractDecimalParam(const ALine, AParamName: string): Double;
var
  startPos, endPos: Integer;
  valueStr: string;
  tempStr: string;
  oldDecimalSep: Char;
begin
  Result := -999999.0; // Speciální hodnota = nebylo nalezeno
  
  startPos := Pos(LowerCase(AParamName) + '=', LowerCase(ALine));
  if startPos = 0 then
    Exit;
  
  startPos := startPos + Length(AParamName) + 1; // Přeskočit "param="
  
  // Najít konec čísla (mezera nebo konec řádku)
  // Podporujeme desetinnou tečku i čárku a záporné číslo (mínus na začátku)
  endPos := startPos;
  while (endPos <= Length(ALine)) and (ALine[endPos] in ['0'..'9', '-', '.', ',']) do
    Inc(endPos);
  
  valueStr := Copy(ALine, startPos, endPos - startPos);
  
  // Nahradit čárku tečkou pro StrToFloat
  tempStr := StringReplace(valueStr, ',', '.', [rfReplaceAll]);
  
  try
    // Dočasně nastavit desetinný oddělovač na tečku
    oldDecimalSep := DecimalSeparator;
    try
      DecimalSeparator := '.';
      Result := StrToFloat(tempStr);
    finally
      DecimalSeparator := oldDecimalSep;
    end;
  except
    Result := -999999.0;
  end;
end;

/// <summary>
/// Extrahuje parametr words:N nebo words nebo words:
/// </summary>
function ExtractWordParam(const ALine: string): Integer;
var
  startPos, equalPos, endPos: Integer;
  valueStr: string;
begin
  Result := 0; // 0 = nepoužívat slova
  
  startPos := Pos('words', LowerCase(ALine));
  if startPos = 0 then
    Exit;
  
  equalPos := startPos + 5; // Pozice za "words"
  
  // Pokud není rovnítko, vrátit 1 (jedno slovo)
  if (equalPos > Length(ALine)) or (ALine[equalPos] <> '=') then
  begin
    Result := 1;
    Exit;
  end;
  
  Inc(equalPos); // Přeskočit rovnítko
  
  // Pokud nic nenásleduje, vrátit 1
  if equalPos > Length(ALine) then
  begin
    Result := 1;
    Exit;
  end;
  
  // Najít konec čísla
  endPos := equalPos;
  while (endPos <= Length(ALine)) and (ALine[endPos] in ['0'..'9']) do
    Inc(endPos);
  
  valueStr := Copy(ALine, equalPos, endPos - equalPos);
  
  // Pokud je prázdné, vrátit 1
  if valueStr = '' then
  begin
    Result := 1;
    Exit;
  end;
  
  try
    Result := StrToInt(valueStr);
  except
    Result := 1;
  end;
end;

/// <summary>
/// Detekuje #, na začátku a/nebo konci
/// </summary>
procedure ExtractOrderMarkers(const ALine: string; var APrefix, ASuffix: Boolean);
var
  trimmed: string;
begin
  APrefix := False;
  ASuffix := False;
  
  trimmed := Trim(ALine);
  
  if Length(trimmed) = 0 then
    Exit;
  
  // Hledat #, na začátku
  if Pos('#,', trimmed) > 0 then
    APrefix := True;
  
  // Hledat ,# na konci
  if Pos(',#', trimmed) > 0 then
    ASuffix := True;
end;

/// <summary>
/// Inicializuje výchozí parametry
/// </summary>
procedure InitDefaultParams(var AParams: TGenerationParams);
begin
  AParams.Text := '';
  AParams.StartValue := 1.0;
  AParams.StepValue := 1.0;
  AParams.DecimalPlaces := 0;
  AParams.DecimalStartValue := 0.0; // Výchozí: 0.0
  AParams.DecimalStepValue := 0.0;  // Výchozí: 0.0 (desetinná část se nezvyšuje)
  AParams.WordCount := 0;
  AParams.AddOrderPrefix := False;
  AParams.AddOrderSuffix := False;
  AParams.ClearBefore := False; // Výchozí: vyplnit jen prázdné
  AParams.CheckBoxValue := False; // Výchozí hodnota (ignoruje se pokud není CheckBoxSet)
  AParams.CheckBoxSet := False;   // Výchozí: checkbox= nebyl zadán
  AParams.StartValueHasDecimal := False; // Výchozí: start je celé číslo
end;

/// <summary>
/// Parsuje příkazy ze vstupního textu
/// </summary>
function ParseCommands(const AInput: string; var ACommands: TCommandArray; out AError: string): Boolean;
var
  lines: TStringList;
  i, cmdCount: Integer;
  line, cmd, originalLine: string;
  command: TCommand;
  spacePos, commentPos: Integer;
  tempInt: Integer;
  tempDecimal: Double;
begin
  Result := False;
  AError := '';
  SetLength(ACommands, 0);
  cmdCount := 0;
  
  lines := TStringList.Create;
  try
    lines.Text := AInput;
    
    for i := 0 to lines.Count - 1 do
    begin
      originalLine := lines[i];
      line := originalLine;
      
      // Odstranit komentáře (vše za //)
      commentPos := Pos('//', line);
      if commentPos > 0 then
        line := Copy(line, 1, commentPos - 1);
      
      line := Trim(line);
      
      if line = '' then
        Continue;
      
      // Rozdělit na příkaz a parametry
      spacePos := Pos(' ', line);
      if spacePos = 0 then
        cmd := LowerCase(line)
      else
        cmd := LowerCase(Copy(line, 1, spacePos - 1));
      
      // Inicializovat command
      FillChar(command, SizeOf(command), 0);
      InitDefaultParams(command.Params);
      
      // Identifikovat typ příkazu
      if cmd = 'clr' then
      begin
        command.CommandType := ctClear;
      end
      else if cmd = 'fillall' then
      begin
        command.CommandType := ctFillAll;
        
        // Extrahovat parametry
        command.Params.Text := ExtractTextParam(line);
        
        // start může být celé nebo desetinné číslo (např. start=3.26)
        tempDecimal := ExtractDecimalParam(line, 'start');
        if tempDecimal <> -999999.0 then
        begin
          command.Params.StartValue := tempDecimal;
          // Zjistit, jestli má desetinnou část
          command.Params.StartValueHasDecimal := (Frac(tempDecimal) <> 0.0);
          // Pokud má desetinnou část a není zadán explicitní decimalstart, použít ji
          if command.Params.StartValueHasDecimal then
            command.Params.DecimalStartValue := Frac(tempDecimal);
        end;
        
        // step může být celé nebo desetinné číslo (např. step=0.1)
        tempDecimal := ExtractDecimalParam(line, 'step');
        if tempDecimal <> -999999.0 then
          command.Params.StepValue := tempDecimal;
        
        tempInt := ExtractNumberParam(line, 'decimal');
        if tempInt >= 0 then
          command.Params.DecimalPlaces := tempInt;
        
        // Extrahovat desetinné parametry (přepíší desetinnou část ze start, pokud jsou zadány)
        tempDecimal := ExtractDecimalParam(line, 'decimalstart');
        if tempDecimal <> -999999.0 then
          command.Params.DecimalStartValue := tempDecimal;
        
        tempDecimal := ExtractDecimalParam(line, 'decimalstep');
        if tempDecimal <> -999999.0 then
          command.Params.DecimalStepValue := tempDecimal;
        
        command.Params.WordCount := ExtractWordParam(line);
        ExtractOrderMarkers(line, command.Params.AddOrderPrefix, command.Params.AddOrderSuffix);
        
        // Zkontrolovat clr parametr
        // clr může být samostatné slovo (s mezerami nebo na konci řádku)
        if (Pos(' clr ', LowerCase(' ' + line + ' ')) > 0) or
           (Pos(' clr=', LowerCase(line)) > 0) or
           (LowerCase(Copy(line, Length(line) - 3, 4)) = ' clr') then
          command.Params.ClearBefore := True;
        
        // Zkontrolovat checkbox
        if Pos('checkbox=false', LowerCase(line)) > 0 then
        begin
          command.Params.CheckBoxValue := False;
          command.Params.CheckBoxSet := True;
        end
        else if Pos('checkbox=true', LowerCase(line)) > 0 then
        begin
          command.Params.CheckBoxValue := True;
          command.Params.CheckBoxSet := True;
        end;
      end
      else if cmd = 'fill' then
      begin
        command.CommandType := ctFill;
        
        // Extrahovat pattern (druhé slovo)
        if spacePos > 0 then
        begin
          line := Copy(line, spacePos + 1, Length(line));
          line := Trim(line);
          
          spacePos := Pos(' ', line);
          if spacePos = 0 then
            command.FieldPattern := line
          else
          begin
            command.FieldPattern := Copy(line, 1, spacePos - 1);
            line := Copy(line, spacePos + 1, Length(line));
          end;
        end;
        
        // Extrahovat parametry (stejně jako u fillall)
        command.Params.Text := ExtractTextParam(line);
        
        // start může být celé nebo desetinné číslo (např. start=3.26)
        tempDecimal := ExtractDecimalParam(line, 'start');
        if tempDecimal <> -999999.0 then
        begin
          command.Params.StartValue := tempDecimal;
          // Zjistit, jestli má desetinnou část
          command.Params.StartValueHasDecimal := (Frac(tempDecimal) <> 0.0);
          // Pokud má desetinnou část a není zadán explicitní decimalstart, použít ji
          if command.Params.StartValueHasDecimal then
            command.Params.DecimalStartValue := Frac(tempDecimal);
        end;
        
        // step může být celé nebo desetinné číslo (např. step=0.1)
        tempDecimal := ExtractDecimalParam(line, 'step');
        if tempDecimal <> -999999.0 then
          command.Params.StepValue := tempDecimal;
        
        tempInt := ExtractNumberParam(line, 'decimal');
        if tempInt >= 0 then
          command.Params.DecimalPlaces := tempInt;
        
        // Extrahovat desetinné parametry (přepíší desetinnou část ze start, pokud jsou zadány)
        tempDecimal := ExtractDecimalParam(line, 'decimalstart');
        if tempDecimal <> -999999.0 then
          command.Params.DecimalStartValue := tempDecimal;
        
        tempDecimal := ExtractDecimalParam(line, 'decimalstep');
        if tempDecimal <> -999999.0 then
          command.Params.DecimalStepValue := tempDecimal;
        
        command.Params.WordCount := ExtractWordParam(line);
        ExtractOrderMarkers(line, command.Params.AddOrderPrefix, command.Params.AddOrderSuffix);
        
        // Zkontrolovat clr parametr
        // clr může být samostatné slovo (s mezerami nebo na konci řádku)
        if (Pos(' clr ', LowerCase(' ' + line + ' ')) > 0) or
           (Pos(' clr=', LowerCase(line)) > 0) or
           (LowerCase(Copy(line, Length(line) - 3, 4)) = ' clr') then
          command.Params.ClearBefore := True;
        
        // Zkontrolovat checkbox
        if Pos('checkbox=false', LowerCase(line)) > 0 then
        begin
          command.Params.CheckBoxValue := False;
          command.Params.CheckBoxSet := True;
        end
        else if Pos('checkbox=true', LowerCase(line)) > 0 then
        begin
          command.Params.CheckBoxValue := True;
          command.Params.CheckBoxSet := True;
        end;
      end
      else if Pos('calculate=', LowerCase(line)) > 0 then
      begin
        command.CommandType := ctCalculate;
        // Extrahovat hodnotu on/off
        if Pos('calculate=off', LowerCase(line)) > 0 then
          command.BoolValue := False  // vypnout výpočty
        else if Pos('calculate=on', LowerCase(line)) > 0 then
          command.BoolValue := True;  // zapnout výpočty
      end
      else if Pos('disabling=', LowerCase(line)) > 0 then
      begin
        command.CommandType := ctDisabling;
        // Extrahovat hodnotu on/off
        if Pos('disabling=off', LowerCase(line)) > 0 then
          command.BoolValue := False  // vypnout disabling
        else if Pos('disabling=on', LowerCase(line)) > 0 then
          command.BoolValue := True;  // zapnout disabling
      end
      else
      begin
        // Neznámý příkaz - vrátit chybu
        AError := 'Řádek ' + IntToStr(i + 1) + ': Neznámý příkaz "' + cmd + '"' + #13#10 + 
                  'Platné příkazy: clr, fillall, fill, calculate=on/off, disabling=on/off' + #13#10 + 
                  'Řádek: ' + originalLine;
        Exit;
      end;
      
      // Přidat příkaz do pole
      Inc(cmdCount);
      SetLength(ACommands, cmdCount);
      ACommands[cmdCount - 1] := command;
    end;
    
    Result := cmdCount > 0;
  finally
    lines.Free;
  end;
end;

/// <summary>
/// Testuje zda řetězec odpovídá wildcard patternu
/// </summary>
function MatchesWildcard(const AText, APattern: string): Boolean;
var
  textIdx, patIdx: Integer;
  textLen, patLen: Integer;
  star: Integer;
  upperText, upperPattern: string;
begin
  Result := False;
  
  // Case-insensitive porovnání
  upperText := UpperCase(AText);
  upperPattern := UpperCase(APattern);
  
  textLen := Length(upperText);
  patLen := Length(upperPattern);
  textIdx := 1;
  patIdx := 1;
  star := 0;
  
  while textIdx <= textLen do
  begin
    if (patIdx <= patLen) and ((upperPattern[patIdx] = '?') or (upperPattern[patIdx] = upperText[textIdx])) then
    begin
      Inc(textIdx);
      Inc(patIdx);
    end
    else if (patIdx <= patLen) and (upperPattern[patIdx] = '*') then
    begin
      star := patIdx;
      Inc(patIdx);
    end
    else if star > 0 then
    begin
      patIdx := star + 1;
      Inc(textIdx);
    end
    else
      Exit;
  end;
  
  // Přeskočit trailing *
  while (patIdx <= patLen) and (upperPattern[patIdx] = '*') do
    Inc(patIdx);
  
  Result := patIdx > patLen;
end;

/// <summary>
/// Extrahuje číslo z názvu pole (např. "R40" -> 40)
/// </summary>
function ExtractNumberFromFieldName(const AFieldName: string): Integer;
var
  i, startPos: Integer;
  numStr: string;
begin
  Result := -1;
  numStr := '';
  startPos := 0;
  
  for i := 1 to Length(AFieldName) do
  begin
    if AFieldName[i] in ['0'..'9'] then
    begin
      if startPos = 0 then
        startPos := i;
      numStr := numStr + AFieldName[i];
    end
    else if startPos > 0 then
      Break; // Konec čísla
  end;
  
  if numStr <> '' then
  begin
    try
      Result := StrToInt(numStr);
    except
      Result := -1;
    end;
  end;
end;

/// <summary>
/// Matchuje pole podle patternu (podporuje wildcards a rozmezí)
/// </summary>
function MatchFieldNames(const APattern: string; const AAllFields: TFieldOrderInfoArray): TFieldOrderInfoArray;
var
  parts: TStringList;
  i, j, resultCount: Integer;
  part: string;
  matched: Boolean;
begin
  SetLength(Result, 0);
  resultCount := 0;
  
  parts := TStringList.Create;
  try
    // Rozdělit podle čárky
    parts.Delimiter := ',';
    parts.StrictDelimiter := True;
    parts.DelimitedText := APattern;
    
    for i := 0 to parts.Count - 1 do
    begin
      part := Trim(parts[i]);
      
      // Wildcard nebo exact match
      for j := 0 to High(AAllFields) do
      begin
        matched := False;
        
        if (Pos('*', part) > 0) or (Pos('?', part) > 0) then
          matched := MatchesWildcard(AAllFields[j].FieldName, part)
        else
          matched := (UpperCase(AAllFields[j].FieldName) = UpperCase(part));
        
        if matched then
        begin
          Inc(resultCount);
          SetLength(Result, resultCount);
          Result[resultCount - 1] := AAllFields[j];
        end;
      end;
    end;
  finally
    parts.Free;
  end;
end;

/// <summary>
/// Extrahuje design.json ze ZIP archivu
/// </summary>
function ExtractDesignJsonFromZip(const ADefID: string; 
  out AJsonContent: string; out AErrorMsg: string): Boolean;
var
  zipPath: string;
  tempDir: string;
  jsonFile: string;
  sl: TStringList;
begin
  Result := False;
  AJsonContent := '';
  AErrorMsg := '';
  
  try
    zipPath := NormalPath(GetExePath) + 'Export\' + ADefID + '.fdx.zip';
    
    if not FileExists(zipPath) then
    begin
      AErrorMsg := 'ZIP soubor neexistuje:' + #13#10 + zipPath;
      Exit;
    end;
    
    tempDir := NormalPath(GetExePath) + 'Temp\';
    if not DirectoryExists(tempDir) then
      ForceDirectories(tempDir);
    
    if not UnzipFile(zipPath, tempDir, '') then
    begin
      AErrorMsg := 'Nepodařilo se rozbalit ZIP soubor:' + #13#10 + zipPath;
      Exit;
    end;
    
    jsonFile := tempDir + ADefID + '.design.json';
    if not FileExists(jsonFile) then
    begin
      AErrorMsg := 'Po rozbalení ZIP souboru nebyl nalezen design.json soubor:' + #13#10 + jsonFile;
      Exit;
    end;
    
    sl := TStringList.Create;
    try
      sl.LoadFromFile(jsonFile);
      AJsonContent := sl.Text;
      Result := True;
    finally
      sl.Free;
    end;
    
    try
      SysUtils.DeleteFile(jsonFile);
    except
      // Ignorovat chyby při mazání temp souborů
    end;
    
  except
    on E: Exception do
    begin
      AErrorMsg := 'Chyba při extrakci design.json:' + #13#10 + E.Message;
      Result := False;
    end;
  end;
end;

/// <summary>
/// Parsuje JSON a načte pouze TextEditBox pole do oddělených kolekcí podle typu
/// </summary>
function ParseJsonToCollections(
  const AJsonContent: string;
  var ADateFields: TFieldOrderInfoArray;
  var AStringFields: TFieldOrderInfoArray;
  var ANumberFields: TFieldOrderInfoArray;
  var ABooleanFields: TFieldOrderInfoArray;
  var AMemoFields: TFieldOrderInfoArray
): Boolean;
var
  JSONRoot: TlkJSONbase;
  JSONArray: TlkJSONlist;
  JSONPage: TlkJSONobject;
  JSONSection: TlkJSONbase;
  JSONList: TlkJSONlist;
  JSONField: TlkJSONobject;
  i, j, k: Integer;
  seqPageKey: Integer;  // Sekvenční PageKey (1, 2, 3...)
  topValue: Integer;
  leftValue: Integer;
  fieldInfo: TFieldOrderInfo;
  fldType: string;
  dateCount, stringCount, numberCount, booleanCount, memoCount: Integer;
begin
  Result := False;
  SetLength(ADateFields, 0);
  SetLength(AStringFields, 0);
  SetLength(ANumberFields, 0);
  SetLength(ABooleanFields, 0);
  SetLength(AMemoFields, 0);
  dateCount := 0;
  stringCount := 0;
  numberCount := 0;
  booleanCount := 0;
  memoCount := 0;
  
  try
    JSONRoot := TlkJSON.ParseText(AJsonContent);
    if JSONRoot = nil then
      Exit;
    
    try
      JSONArray := JSONRoot as TlkJSONlist;
      
      // Procházet stránky a přiřadit sekvenční PageKey
      for i := 0 to JSONArray.Count - 1 do
      begin
        JSONPage := JSONArray.Child[i] as TlkJSONobject;
        if JSONPage = nil then Continue;
        
        // NORMALIZACE: Přiřadit sekvenční PageKey (1, 2, 3...)
        seqPageKey := i + 1;
        
        // Zpracovat TextEditBox
        if JSONPage.Field['TextEditBox'] <> nil then
        begin
          JSONList := JSONPage.Field['TextEditBox'] as TlkJSONlist;
          if JSONList <> nil then
          begin
            for k := 0 to JSONList.Count - 1 do
            begin
              JSONField := JSONList.Child[k] as TlkJSONobject;
              if JSONField = nil then Continue;
              
              FillChar(fieldInfo, SizeOf(fieldInfo), 0);
              fieldInfo.PageKey := seqPageKey;
              
              // Název pole
              try
                fieldInfo.FieldName := JSONField.Field['Name'].Value;
              except
                Continue;
              end;
              
              // Left souřadnice
              try
                leftValue := Trunc((JSONField.Field['Left'] as TlkJSONnumber).Value);
                fieldInfo.X := leftValue;
              except
                fieldInfo.X := 0;
              end;
              
              // Top souřadnice a výpočet Y
              try
                topValue := Trunc((JSONField.Field['Top'] as TlkJSONnumber).Value);
                fieldInfo.Y := seqPageKey * 1000 + topValue;
              except
                fieldInfo.Y := seqPageKey * 1000;
              end;
              
              // FldType
              try
                fldType := JSONField.Field['FldType'].Value;
                fieldInfo.DataType := fldType;
              except
                fldType := 'String';
                fieldInfo.DataType := 'String';
              end;
              
              // FldTypePlaces
              try
                fieldInfo.Places := (JSONField.Field['FldTypePlaces'] as TlkJSONnumber).Value;
              except
                fieldInfo.Places := 0;
              end;
              
              // DisplayFormat
              try
                fieldInfo.DisplayFormat := JSONField.Field['DisplayFormat'].Value;
              except
                fieldInfo.DisplayFormat := '';
              end;
              
              // Visible
              try
                fieldInfo.Visible := (JSONField.Field['Visible'] as TlkJSONboolean).Value;
              except
                fieldInfo.Visible := True; // Výchozí: pole je viditelné
              end;
              
              // Přidat do příslušné kolekce podle typu (jen pokud je Visible=true)
              if not fieldInfo.Visible then
                Continue; // Přeskočit neviditelné pole
              
              if fldType = 'Date' then
              begin
                Inc(dateCount);
                SetLength(ADateFields, dateCount);
                ADateFields[dateCount - 1] := fieldInfo;
              end
              else if fldType = 'String' then
              begin
                Inc(stringCount);
                SetLength(AStringFields, stringCount);
                AStringFields[stringCount - 1] := fieldInfo;
              end
              else if (fldType = 'Number') or (fldType = 'Currency') then
              begin
                Inc(numberCount);
                SetLength(ANumberFields, numberCount);
                ANumberFields[numberCount - 1] := fieldInfo;
              end;
            end;
          end;
        end;
        
        // Zpracovat CheckBox
        if JSONPage.Field['CheckBox'] <> nil then
        begin
          JSONList := JSONPage.Field['CheckBox'] as TlkJSONlist;
          if JSONList <> nil then
          begin
            for k := 0 to JSONList.Count - 1 do
            begin
              JSONField := JSONList.Child[k] as TlkJSONobject;
              if JSONField = nil then Continue;
              
              FillChar(fieldInfo, SizeOf(fieldInfo), 0);
              fieldInfo.PageKey := seqPageKey;
              fieldInfo.DataType := 'Boolean';
              
              try
                fieldInfo.FieldName := JSONField.Field['Name'].Value;
              except
                Continue;
              end;
              
              try
                leftValue := Trunc((JSONField.Field['Left'] as TlkJSONnumber).Value);
                fieldInfo.X := leftValue;
              except
                fieldInfo.X := 0;
              end;
              
              try
                topValue := Trunc((JSONField.Field['Top'] as TlkJSONnumber).Value);
                fieldInfo.Y := seqPageKey * 1000 + topValue;
              except
                fieldInfo.Y := seqPageKey * 1000;
              end;
              
              // Visible
              try
                fieldInfo.Visible := (JSONField.Field['Visible'] as TlkJSONboolean).Value;
              except
                fieldInfo.Visible := True; // Výchozí: pole je viditelné
              end;
              
              // Přidat jen pokud je Visible=true
              if not fieldInfo.Visible then
                Continue;
              
              Inc(booleanCount);
              SetLength(ABooleanFields, booleanCount);
              ABooleanFields[booleanCount - 1] := fieldInfo;
            end;
          end;
        end;
        
        // Zpracovat TextMemoBox
        if JSONPage.Field['TextMemoBox'] <> nil then
        begin
          JSONList := JSONPage.Field['TextMemoBox'] as TlkJSONlist;
          if JSONList <> nil then
          begin
            for k := 0 to JSONList.Count - 1 do
            begin
              JSONField := JSONList.Child[k] as TlkJSONobject;
              if JSONField = nil then Continue;
              
              FillChar(fieldInfo, SizeOf(fieldInfo), 0);
              fieldInfo.PageKey := seqPageKey;
              fieldInfo.DataType := 'Memo';
              
              try
                fieldInfo.FieldName := JSONField.Field['Name'].Value;
              except
                Continue;
              end;
              
              try
                leftValue := Trunc((JSONField.Field['Left'] as TlkJSONnumber).Value);
                fieldInfo.X := leftValue;
              except
                fieldInfo.X := 0;
              end;
              
              try
                topValue := Trunc((JSONField.Field['Top'] as TlkJSONnumber).Value);
                fieldInfo.Y := seqPageKey * 1000 + topValue;
              except
                fieldInfo.Y := seqPageKey * 1000;
              end;
              
              // Visible
              try
                fieldInfo.Visible := (JSONField.Field['Visible'] as TlkJSONboolean).Value;
              except
                fieldInfo.Visible := True; // Výchozí: pole je viditelné
              end;
              
              // Přidat jen pokud je Visible=true
              if not fieldInfo.Visible then
                Continue;
              
              Inc(memoCount);
              SetLength(AMemoFields, memoCount);
              AMemoFields[memoCount - 1] := fieldInfo;
            end;
          end;
        end;
      end;
      
      Result := (dateCount + stringCount + numberCount + booleanCount + memoCount) > 0;
      
    finally
      JSONRoot.Free;
    end;
    
  except
    Result := False;
  end;
end;

/// <summary>
/// Porovnávací funkce pro řazení podle Y a X
/// </summary>
function CompareFieldsByYX(const F1, F2: TFieldOrderInfo): Integer;
var
  yDiff: Integer;
begin
  yDiff := F1.Y - F2.Y;
  
  // Pokud jsou ve stejném řádku (Y rozdíl <= tolerance), řadit podle X
  if Abs(yDiff) <= ROW_TOLERANCE then
    Result := F1.X - F2.X
  else
    Result := yDiff;
end;

/// <summary>
/// Seřadí kolekci podle Y a X a přiřadí Order
/// </summary>
procedure SortAndAssignOrder(var AFields: TFieldOrderInfoArray);
var
  i, j: Integer;
  temp: TFieldOrderInfo;
  swapped: Boolean;
begin
  // Bubble sort podle Y a X
  if Length(AFields) = 0 then Exit;
  
  for i := 0 to High(AFields) - 1 do
  begin
    swapped := False;
    for j := 0 to High(AFields) - i - 1 do
    begin
      if CompareFieldsByYX(AFields[j], AFields[j + 1]) > 0 then
      begin
        temp := AFields[j];
        AFields[j] := AFields[j + 1];
        AFields[j + 1] := temp;
        swapped := True;
      end;
    end;
    if not swapped then
      Break;
  end;
  
  // Přiřadit Order od 1
  for i := 0 to High(AFields) do
    AFields[i].Order := i + 1;
end;

/// <summary>
/// Načte slovník slov ze souboru (cached)
/// </summary>
function LoadWordDictionary: TStringList;
var
  wordFile: string;
  fileStream: TFileStream;
  utf8Content: UTF8String;
  ansiContent: AnsiString;
  buffer: array of Byte;
  i: Integer;
begin
  if GWordDictionary = nil then
  begin
    GWordDictionary := TStringList.Create;
    wordFile := NormalPath(GetExePath) + 'test-words.txt';
    
    if FileExists(wordFile) then
    begin
      try
        // Načíst soubor jako UTF-8 a konvertovat na Windows-1250
        fileStream := TFileStream.Create(wordFile, fmOpenRead or fmShareDenyWrite);
        try
          SetLength(buffer, fileStream.Size);
          fileStream.ReadBuffer(buffer[0], fileStream.Size);
          SetString(utf8Content, PAnsiChar(@buffer[0]), fileStream.Size);
          
          // Konvertovat UTF-8 na ANSI (Windows-1250)
          ansiContent := UTF8Decode(utf8Content);
          GWordDictionary.Text := ansiContent;
        finally
          fileStream.Free;
        end;
      except
        // Ignorovat chyby při čtení
      end;
    end;
  end;
  
  Result := GWordDictionary;
end;

/// <summary>
/// Vygeneruje textovou hodnotu podle parametrů
/// </summary>
/// <summary>
/// Extrahuje první číslo z textu (pro pole s DisplayFormat obsahujícím #)
/// </summary>
function ExtractNumberFromText(const AText: string): string;
var
  i: Integer;
  inNumber: Boolean;
begin
  Result := '';
  inNumber := False;
  
  for i := 1 to Length(AText) do
  begin
    if AText[i] in ['0'..'9'] then
    begin
      Result := Result + AText[i];
      inNumber := True;
    end
    else if inNumber then
      Break; // Našli jsme celé číslo, konec
  end;
end;

function GenerateTextValue(const AParams: TGenerationParams; const AFieldInfo: TFieldOrderInfo; AOrder: Integer): string;
var
  dict: TStringList;
  i, startIdx: Integer;
  words: string;
  hasNumberFormat: Boolean;
begin
  Result := '';
  hasNumberFormat := Pos('#', AFieldInfo.DisplayFormat) > 0;
  
  // Slovník slov
  if AParams.WordCount > 0 then
  begin
    dict := LoadWordDictionary;
    if dict.Count > 0 then
    begin
      words := '';
      startIdx := (AOrder - 1) mod dict.Count; // Cyklicky pro případ více Order než slov
      
      for i := 0 to AParams.WordCount - 1 do
      begin
        if i > 0 then
          words := words + ' ';
        words := words + dict[(startIdx + i) mod dict.Count];
      end;
      
      // Přidat pořadové číslo
      if AParams.AddOrderPrefix then
        Result := IntToStr(AOrder) + ' ' + words
      else if AParams.AddOrderSuffix then
        Result := words + ' ' + IntToStr(AOrder)
      else
        Result := words;
    end
    else
    begin
      if hasNumberFormat then
        Result := IntToStr(AOrder) // Jen číslo pro pole s číselným formátem
      else
        Result := 'T' + IntToStr(AOrder); // Fallback pokud slovník není dostupný
    end;
  end
  // Vlastní text
  else if AParams.Text <> '' then
  begin
    Result := AParams.Text;
    
    // Nahradit # za pořadové číslo
    if Pos('#', Result) > 0 then
      Result := StringReplace(Result, '#', IntToStr(AOrder), [rfReplaceAll]);
    
    // Nahradit @ za slovo ze slovníku (podle pořadí)
    if Pos('@', Result) > 0 then
    begin
      dict := LoadWordDictionary;
      if (dict <> nil) and (dict.Count > 0) then
      begin
        // Použít slovo podle pořadí (cyklicky)
        words := dict[(AOrder - 1) mod dict.Count];
        Result := StringReplace(Result, '@', words, [rfReplaceAll]);
        // NEVOLAT dict.Free - dict je globální proměnná!
      end
      else
      begin
        // Fallback pokud slovník není dostupný
        Result := StringReplace(Result, '@', 'slovo' + IntToStr(AOrder), [rfReplaceAll]);
      end;
    end;
    
    // Nahradit $ za náhodné slovo ze slovníku
    if Pos('$', Result) > 0 then
    begin
      dict := LoadWordDictionary;
      if (dict <> nil) and (dict.Count > 0) then
      begin
        // Použít náhodné slovo
        words := dict[Random(dict.Count)];
        Result := StringReplace(Result, '$', words, [rfReplaceAll]);
        // NEVOLAT dict.Free - dict je globální proměnná!
      end
      else
      begin
        // Fallback pokud slovník není dostupný
        Result := StringReplace(Result, '$', 'random' + IntToStr(AOrder), [rfReplaceAll]);
      end;
    end;
    
    // Pokud text neobsahoval žádnou značku, přidat číslo na konec (zpětná kompatibilita)
    if (Pos('#', AParams.Text) = 0) and (Pos('@', AParams.Text) = 0) and (Pos('$', AParams.Text) = 0) then
      Result := Result + IntToStr(AOrder);
  end
  // Výchozí
  else
  begin
    if hasNumberFormat then
      Result := IntToStr(AOrder) // Jen číslo pro pole s číselným formátem
    else
      Result := 'T' + IntToStr(AOrder);
  end;
  
  // Pokud má pole číselný formát (DisplayFormat obsahuje #) a výsledek obsahuje číslo,
  // extrahovat jen to číslo
  if hasNumberFormat and (Result <> '') then
  begin
    words := ExtractNumberFromText(Result);
    if words <> '' then
      Result := words;
  end;
end;

/// <summary>
/// Vygeneruje číselnou hodnotu podle parametrů a vlastností pole (Places, DisplayFormat)
/// </summary>
function GenerateNumberValue(const AParams: TGenerationParams; const AFieldInfo: TFieldOrderInfo; AOrder: Integer): string;
var
  value: Integer;
  wholePart: Integer;
  totalValue: Double;
  decimalValue: Double;
  decimalStr: string;
  formatStr: string;
  oldDecimalSep: Char;
  effectivePlaces: Integer;
begin
  // Zjistit efektivní počet desetinných míst:
  // - pokud je zadán parametr decimal, má přednost
  // - jinak použít Places z JSON (AFieldInfo.Places)
  if AParams.DecimalPlaces > 0 then
    effectivePlaces := AParams.DecimalPlaces
  else
    effectivePlaces := AFieldInfo.Places;
  
  // Desetinná místa
  if effectivePlaces > 0 then
  begin
    // Spočítat celkovou hodnotu (start + (order-1) * step) jako Double
    totalValue := AParams.StartValue + (AOrder - 1) * AParams.StepValue;
    
    // Rozdělit na celou část
    wholePart := Trunc(totalValue);
    
    // Desetinná část: 
    // - Pokud je zadán decimalstep != 0, použít oddělené zvyšování (DecimalStartValue + DecimalStepValue)
    // - Jinak použít desetinnou část z totalValue (start + step)
    if AParams.DecimalStepValue <> 0.0 then
      // Oddělené zvyšování desetinné části
      decimalValue := AParams.DecimalStartValue + (AOrder - 1) * AParams.DecimalStepValue
    else
      // Použít desetinnou část z totalValue
      decimalValue := Frac(totalValue);
    
    // Formátovat desetinnou část podle počtu míst s tečkou jako oddělovačem
    formatStr := '%.' + IntToStr(effectivePlaces) + 'f';
    oldDecimalSep := DecimalSeparator;
    try
      DecimalSeparator := '.';
      decimalStr := Format(formatStr, [decimalValue]);
    finally
      DecimalSeparator := oldDecimalSep;
    end;
    
    // Extrahovat pouze desetinnou část (za tečkou)
    if Pos('.', decimalStr) > 0 then
      decimalStr := Copy(decimalStr, Pos('.', decimalStr) + 1, Length(decimalStr))
    else
      decimalStr := StringOfChar('0', effectivePlaces);
    
    // Sestavit výsledek: celá část + tečka + desetinná část (pro databázi)
    Result := IntToStr(wholePart) + '.' + decimalStr;
  end
  else
  begin
    // Bez desetinných míst: použít standardní výpočet a zaokrouhlit
    value := Round(AParams.StartValue + (AOrder - 1) * AParams.StepValue);
    Result := IntToStr(value);
  end;
end;

/// <summary>
/// Vygeneruje datumovou hodnotu podle parametrů
/// </summary>
function GenerateDateValue(const AParams: TGenerationParams; AOrder: Integer): string;
var
  dateValue: TDateTime;
  dayOffset: Integer;
begin
  dayOffset := Round(AParams.StartValue + (AOrder - 1) * AParams.StepValue);
  dateValue := Date + dayOffset;
  Result := FormatDateTime('dd.mm.yyyy', dateValue);
end;

/// <summary>
/// Vygeneruje TextValue pro všechna pole v kolekci
/// </summary>
procedure GenerateTextValues(var AFields: TFieldOrderInfoArray; const AFieldType: string);
var
  i: Integer;
begin
  for i := 0 to High(AFields) do
  begin
    if AFieldType = 'String' then
      AFields[i].TextValue := 'T' + IntToStr(AFields[i].Order)
    else if AFieldType = 'Number' then
      AFields[i].TextValue := IntToStr(AFields[i].Order)
    else if AFieldType = 'Date' then
      AFields[i].TextValue := FormatDateTime('dd.mm.yyyy', Date + AFields[i].Order)
    else if AFieldType = 'Boolean' then
      AFields[i].TextValue := 'True'
    else if AFieldType = 'Memo' then
      AFields[i].TextValue := IntToStr(AFields[i].Order) + #13#10 + 'memo';
  end;
end;

/// <summary>
/// Exportuje kolekci do TXT souboru
/// </summary>
procedure ExportCollectionToTxt(const AFields: TFieldOrderInfoArray; const AFileName: string);
var
  sl: TStringList;
  i: Integer;
begin
  sl := TStringList.Create;
  try
    sl.Add('Order | FieldName | PageKey | Y | X | TextValue');
    sl.Add('------|-----------|---------|---|---|----------');
    for i := 0 to High(AFields) do
      sl.Add(Format('%5d | %-30s | %7d | %5d | %5d | %s', [
        AFields[i].Order,
        AFields[i].FieldName,
        AFields[i].PageKey,
        AFields[i].Y,
        AFields[i].X,
        AFields[i].TextValue
      ]));
    sl.SaveToFile(AFileName);
  finally
    sl.Free;
  end;
end;

/// <summary>
/// Smaže obsah všech polí v mtValues
/// </summary>
procedure ClearAllFields;
var
  i: Integer;
  field: TField;
begin
  with GfaMain.mtValues do
  begin
    if RecordCount = 0 then
      Exit;
    
    Edit;
    
    for i := 0 to Fields.Count - 1 do
    begin
      field := Fields[i];
      try
        if field is TBooleanField then
          field.AsBoolean := False  // Checkboxy nastavit na false
        else
          field.AsString := '';     // Ostatní pole vyprázdnit
      except
        // Ignorovat chyby (např. ReadOnly pole)
      end;
    end;
    
    // Uložit změny
    Post;
  end;
end;

/// <summary>
/// Smaže obsah vybraných polí podle seznamu
/// </summary>
procedure ClearSelectedFields(const AFields: TFieldOrderInfoArray);
var
  i: Integer;
  field: TField;
begin
  with GfaMain.mtValues do
  begin
    if RecordCount = 0 then
      Exit;
    
    Edit;
    
    for i := 0 to High(AFields) do
    begin
      field := FindField(AFields[i].FieldName);
      if field <> nil then
      begin
        try
          if field is TBooleanField then
            field.AsBoolean := False  // Checkboxy nastavit na false
          else
            field.AsString := '';     // Ostatní pole vyprázdnit
        except
          // Ignorovat chyby (např. ReadOnly pole)
        end;
      end;
    end;
    
    // Uložit změny
    Post;
  end;
end;

/// <summary>
/// Vyplní všechna pole s parametry
/// </summary>
procedure FillAllFieldsWithParams(
  const AParams: TGenerationParams;
  var ADateFields: TFieldOrderInfoArray;
  var AStringFields: TFieldOrderInfoArray;
  var ANumberFields: TFieldOrderInfoArray;
  var ABooleanFields: TFieldOrderInfoArray;
  var AMemoFields: TFieldOrderInfoArray
);
var
  i: Integer;
begin
  // Vygenerovat hodnoty pro každou kolekci podle parametrů
  for i := 0 to High(ADateFields) do
    ADateFields[i].TextValue := GenerateDateValue(AParams, ADateFields[i].Order);
  
  for i := 0 to High(AStringFields) do
    AStringFields[i].TextValue := GenerateTextValue(AParams, AStringFields[i], AStringFields[i].Order);
  
  for i := 0 to High(ANumberFields) do
    ANumberFields[i].TextValue := GenerateNumberValue(AParams, ANumberFields[i], ANumberFields[i].Order);
  
  // fillall NENASTAVUJE checkboxy - ponechá je tak, jak jsou
  // Pro nastavení checkboxů použijte příkaz fill s checkbox=true/false
  
  for i := 0 to High(AMemoFields) do
    AMemoFields[i].TextValue := IntToStr(AMemoFields[i].Order) + #13#10 + 'memo';
end;

/// <summary>
/// Vyplní vybrané pole podle patternu s parametry
/// </summary>
procedure FillSelectedFieldsWithParams(
  const AFieldPattern: string;
  const AParams: TGenerationParams;
  var ADateFields: TFieldOrderInfoArray;
  var AStringFields: TFieldOrderInfoArray;
  var ANumberFields: TFieldOrderInfoArray;
  var ABooleanFields: TFieldOrderInfoArray;
  var AMemoFields: TFieldOrderInfoArray
);
var
  allFields: TFieldOrderInfoArray;
  matchedFields: TFieldOrderInfoArray;
  i, j, k, allCount, fillOrder: Integer;
  field: TFieldOrderInfo;
  isDuplicate: Boolean;
begin
  // Sloučit všechna pole do jednoho array
  allCount := Length(ADateFields) + Length(AStringFields) + Length(ANumberFields) + 
              Length(ABooleanFields) + Length(AMemoFields);
  SetLength(allFields, allCount);
  
  allCount := 0;
  for i := 0 to High(ADateFields) do
  begin
    allFields[allCount] := ADateFields[i];
    Inc(allCount);
  end;
  for i := 0 to High(AStringFields) do
  begin
    allFields[allCount] := AStringFields[i];
    Inc(allCount);
  end;
  for i := 0 to High(ANumberFields) do
  begin
    allFields[allCount] := ANumberFields[i];
    Inc(allCount);
  end;
  for i := 0 to High(ABooleanFields) do
  begin
    allFields[allCount] := ABooleanFields[i];
    Inc(allCount);
  end;
  for i := 0 to High(AMemoFields) do
  begin
    allFields[allCount] := AMemoFields[i];
    Inc(allCount);
  end;
  
  // Matchovat podle patternu
  matchedFields := MatchFieldNames(AFieldPattern, allFields);
  
  // Odstranit duplicity (pole se může matchovat více patterny)
  // Procházíme pole a odstraňujeme duplicitní FieldName
  j := 0;
  for i := 0 to High(matchedFields) do
  begin
    // Zkontrolovat, jestli pole s tímto jménem už není v poli
    isDuplicate := False;
    for k := 0 to j - 1 do
    begin
      if UpperCase(matchedFields[k].FieldName) = UpperCase(matchedFields[i].FieldName) then
      begin
        isDuplicate := True;
        Break;
      end;
    end;
    
    // Pokud není duplicitní, přidat do výsledku
    if not isDuplicate then
    begin
      if j <> i then
        matchedFields[j] := matchedFields[i];
      Inc(j);
    end;
  end;
  SetLength(matchedFields, j);
  
  // Seřadit matchovaná pole podle Y a X (ne podle Order, protože Order je duplicitní mezi typy)
  for i := 0 to High(matchedFields) - 1 do
  begin
    for j := i + 1 to High(matchedFields) do
    begin
      if CompareFieldsByYX(matchedFields[j], matchedFields[i]) < 0 then
      begin
        // Prohodit
        field := matchedFields[i];
        matchedFields[i] := matchedFields[j];
        matchedFields[j] := field;
      end;
    end;
  end;
  
  // DEBUG: Zobrazit všechna matchovaná pole (odkomentujte pro diagnostiku)
  (*
  var debugMsg: string;
  debugMsg := 'Matchovaná pole pro pattern "' + AFieldPattern + '":' + #13#10;
  for i := 0 to High(matchedFields) do
    debugMsg := debugMsg + IntToStr(i+1) + '. ' + matchedFields[i].FieldName + 
                ' (Order=' + IntToStr(matchedFields[i].Order) + 
                ', Type=' + matchedFields[i].DataType + ')' + #13#10;
  ShowMessage(debugMsg);
  *)
  
  // Vygenerovat hodnoty pro matchovaná pole
  // Použít pořadí v rámci matchovaných polí, započítávat jen skutečně vyplňovaná pole
  // Pokud pole už má TextValue a není ClearBefore, nepřepisovat
  fillOrder := 0; // Pořadové číslo pro generování (započítává jen pole, která se vyplňují)
  for i := 0 to High(matchedFields) do
  begin
    // Pokud není ClearBefore a pole už má hodnotu, přeskočit
    if (not AParams.ClearBefore) and (matchedFields[i].TextValue <> '') then
      Continue;
    
    // Zpracovat podle typu pole a zvýšit fillOrder jen pokud se pole skutečně vyplnilo
    if matchedFields[i].DataType = 'Date' then
    begin
      Inc(fillOrder);
      matchedFields[i].TextValue := GenerateDateValue(AParams, fillOrder);
    end
    else if matchedFields[i].DataType = 'String' then
    begin
      Inc(fillOrder);
      matchedFields[i].TextValue := GenerateTextValue(AParams, matchedFields[i], fillOrder);
    end
    else if (matchedFields[i].DataType = 'Number') or (matchedFields[i].DataType = 'Currency') then
    begin
      Inc(fillOrder);
      matchedFields[i].TextValue := GenerateNumberValue(AParams, matchedFields[i], fillOrder);
    end
    else if matchedFields[i].DataType = 'Boolean' then
    begin
      // Vyplnit jen pokud byl zadán parametr checkbox=
      if AParams.CheckBoxSet then
      begin
        if AParams.CheckBoxValue then
          matchedFields[i].TextValue := 'True'
        else
          matchedFields[i].TextValue := 'False';
        // Boolean pole nezvyšuje fillOrder (netřeba číslo)
      end;
    end
    else if matchedFields[i].DataType = 'Memo' then
    begin
      Inc(fillOrder);
      matchedFields[i].TextValue := IntToStr(fillOrder) + #13#10 + 'memo';
    end;
    // Pokud není žádný z podporovaných typů, fillOrder se nezvýší
  end;
  
  // Aktualizovat hodnotu v původních arrays
  for i := 0 to High(matchedFields) do
  begin
    // Aktualizovat jen pokud byla vygenerována nová hodnota
    for j := 0 to High(ADateFields) do
      if ADateFields[j].FieldName = matchedFields[i].FieldName then
        ADateFields[j].TextValue := matchedFields[i].TextValue;
    for j := 0 to High(AStringFields) do
      if AStringFields[j].FieldName = matchedFields[i].FieldName then
        AStringFields[j].TextValue := matchedFields[i].TextValue;
    for j := 0 to High(ANumberFields) do
      if ANumberFields[j].FieldName = matchedFields[i].FieldName then
        ANumberFields[j].TextValue := matchedFields[i].TextValue;
    for j := 0 to High(ABooleanFields) do
      if ABooleanFields[j].FieldName = matchedFields[i].FieldName then
        ABooleanFields[j].TextValue := matchedFields[i].TextValue;
    for j := 0 to High(AMemoFields) do
      if AMemoFields[j].FieldName = matchedFields[i].FieldName then
        AMemoFields[j].TextValue := matchedFields[i].TextValue;
  end;
end;

type
  TKeyDownHandler = class
  private
    FForm: TForm;
  public
    constructor Create(AForm: TForm);
    procedure HandleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

constructor TKeyDownHandler.Create(AForm: TForm);
begin
  inherited Create;
  FForm := AForm;
end;

procedure TKeyDownHandler.HandleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Ctrl+Enter = OK
  if (Key = VK_RETURN) and (ssCtrl in Shift) then
  begin
    Key := 0;
    if FForm <> nil then
      FForm.ModalResult := mrOk;
  end
  // Esc = Cancel (pro jistotu, mělo by fungovat automaticky)
  else if Key = VK_ESCAPE then
  begin
    Key := 0;
    if FForm <> nil then
      FForm.ModalResult := mrCancel;
  end;
end;

/// <summary>
/// Načte textový soubor s detekcí UTF-8 BOM
/// Pokud má soubor UTF-8 BOM, načte v UTF-8, jinak v ANSI (Win-1250)
/// </summary>
procedure LoadTextFileWithEncoding(const AFileName: string; AStrings: TStrings);
var
  fileStream: TFileStream;
  buffer: array[0..2] of Byte;
  bytesRead: Integer;
  utf8Stream: TStringStream;
  content: AnsiString;
  hasUTF8BOM: Boolean;
begin
  if not FileExists(AFileName) then
    Exit;
    
  fileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    // Zkontrolovat UTF-8 BOM (EF BB BF)
    hasUTF8BOM := False;
    if fileStream.Size >= 3 then
    begin
      bytesRead := fileStream.Read(buffer, 3);
      hasUTF8BOM := (bytesRead = 3) and (buffer[0] = $EF) and (buffer[1] = $BB) and (buffer[2] = $BF);
    end;
    
    if hasUTF8BOM then
    begin
      // Načíst jako UTF-8 (přeskočit BOM)
      fileStream.Position := 3;
      SetLength(content, fileStream.Size - 3);
      if fileStream.Size > 3 then
        fileStream.Read(content[1], fileStream.Size - 3);
      
      // Převést UTF-8 na string pomocí UTF8Decode
      AStrings.Text := UTF8Decode(content);
    end
    else
    begin
      // Načíst jako ANSI (Win-1250)
      fileStream.Position := 0;
      AStrings.LoadFromStream(fileStream);
    end;
  finally
    fileStream.Free;
  end;
end;

/// <summary>
/// Zobrazí dialog pro zadání parametrů generování
/// </summary>
function ShowGenerationParamsDialog(out AParams: string): Boolean;
var
  dlg: TForm;
  memo: TMemo;
  btnOK, btnCancel: TButton;
  lbl: TLabel;
  paramsFile, defaultParamsFile, loadedText, iniFileName: string;
  fileStream: TFileStream;
  stringList: TStringList;
  ini: TMemIniFile;
  dlgWidth, dlgHeight: Integer;
  keyHandler: TKeyDownHandler;
begin
  Result := False;
  AParams := '';
  
  // Cesta k souboru s parametry
  paramsFile := NormalPath(GetExePath) + 'testparams.txt';
  defaultParamsFile := NormalPath(GetExePath) + 'testparams-default.txt';
  
  dlg := TForm.Create(nil);
  keyHandler := TKeyDownHandler.Create(dlg);
  try
    dlg.Caption := 'Parametry generování testovacích dat';
    dlg.Width := 800;
    dlg.Height := 700;
    dlg.Position := poMainFormCenter;
    dlg.BorderStyle := bsSizeable;
    dlg.KeyPreview := True;
    dlg.OnKeyDown := keyHandler.HandleKeyDown;
    
    // Label s nápovedou
    lbl := TLabel.Create(dlg);
    lbl.Parent := dlg;
    lbl.Left := 10;
    lbl.Top := 10;
    lbl.Caption := 'Zadej parametry pro generování (jeden příkaz na řádek):';
    
    // Memo pro zadání parametrů
    memo := TMemo.Create(dlg);
    memo.Parent := dlg;
    memo.Left := 10;
    memo.Top := 30;
    memo.Width := dlg.ClientWidth - 20;
    memo.Height := dlg.ClientHeight - 80;
    memo.Anchors := [akLeft, akTop, akRight, akBottom];
    memo.ScrollBars := ssVertical;
    memo.Font.Name := 'Courier New';
    memo.Font.Size := 9;
    
    // Načíst uložené parametry nebo použít výchozí soubor
    stringList := TStringList.Create;
    try
      if FileExists(paramsFile) then
      begin
        stringList.LoadFromFile(paramsFile);
        // Pokud je soubor prázdný nebo obsahuje jen prázdné řádky, načíst default
        if Trim(stringList.Text) = '' then
        begin
          if FileExists(defaultParamsFile) then
            LoadTextFileWithEncoding(defaultParamsFile, stringList)
          else
            stringList.Text := 'clr' + #13#10 + 'fillall';
        end;
      end
      else
      begin
        // Pokud testparams.txt neexistuje, načíst default soubor
        if FileExists(defaultParamsFile) then
          LoadTextFileWithEncoding(defaultParamsFile, stringList)
        else
          stringList.Text := 'clr' + #13#10 + 'fillall';
      end;
      memo.Lines.Text := stringList.Text;
    finally
      stringList.Free;
    end;
    
    // Načíst velikost dialogu z INI
    if (GfaMain <> nil) then
    begin
      try
        iniFileName := GfaMain.GetIniFileName;
        if FileExists(iniFileName) then
        begin
          ini := TMemIniFile.Create(iniFileName);
          try
            dlgWidth := ini.ReadInteger('TestDataDialog', 'Width', dlg.Width);
            dlgHeight := ini.ReadInteger('TestDataDialog', 'Height', dlg.Height);
            if (dlgWidth >= 400) and (dlgWidth <= 2000) then
              dlg.Width := dlgWidth;
            if (dlgHeight >= 300) and (dlgHeight <= 1500) then
              dlg.Height := dlgHeight;
          finally
            ini.Free;
          end;
        end;
      except
        // Ignorovat chyby při načítání INI
      end;
    end;
    
    // Tlačítko OK
    btnOK := TButton.Create(dlg);
    btnOK.Parent := dlg;
    btnOK.Caption := 'OK';
    btnOK.Left := dlg.ClientWidth - 180;
    btnOK.Top := dlg.ClientHeight - 35;
    btnOK.Width := 75;
    btnOK.Anchors := [akRight, akBottom];
    btnOK.ModalResult := mrOk;
    btnOK.Default := True;
    
    // Tlačítko Cancel
    btnCancel := TButton.Create(dlg);
    btnCancel.Parent := dlg;
    btnCancel.Caption := 'Zrušit';
    btnCancel.Left := dlg.ClientWidth - 95;
    btnCancel.Top := dlg.ClientHeight - 35;
    btnCancel.Width := 75;
    btnCancel.Anchors := [akRight, akBottom];
    btnCancel.ModalResult := mrCancel;
    btnCancel.Cancel := True;
    
    if dlg.ShowModal = mrOk then
    begin
      AParams := Trim(memo.Lines.Text);
      
      // Pokud je prázdné, použít výchozí
      if AParams = '' then
        AParams := 'clr' + #13#10 + 'fillall';
      
      // Uložit parametry do souboru
      try
        stringList := TStringList.Create;
        try
          stringList.Text := AParams;
          stringList.SaveToFile(paramsFile);
        finally
          stringList.Free;
        end;
      except
        // Ignorovat chybu při ukládání
      end;
      
      // Uložit velikost dialogu do INI
      if (GfaMain <> nil) and GfaMain.CanWriteToIniFile then
      begin
        try
          iniFileName := GfaMain.GetIniFileName;
          ini := TMemIniFile.Create(iniFileName);
          try
            ini.WriteInteger('TestDataDialog', 'Width', dlg.Width);
            ini.WriteInteger('TestDataDialog', 'Height', dlg.Height);
            ini.UpdateFile;
          finally
            ini.Free;
          end;
        except
          // Ignorovat chyby při ukládání INI
        end;
      end;
      
      Result := True;
    end;
  finally
    keyHandler.Free;
    dlg.Free;
  end;
end;

/// <summary>
/// Hlavní funkce pro vyplnění testovacích hodnot do mtValues
/// </summary>
function FillTestValuesToMtValues: Boolean;
var
  defID: string;
  jsonContent: string;
  dateFields: TFieldOrderInfoArray;
  stringFields: TFieldOrderInfoArray;
  numberFields: TFieldOrderInfoArray;
  booleanFields: TFieldOrderInfoArray;
  memoFields: TFieldOrderInfoArray;
  valueDict: TStringList;
  i, cmdIdx: Integer;
  field: TField;
  exportPath: string;
  textValue: string;
  generationParams: string;
  commands: TCommandArray;
  cmd: TCommand;
  parseError: string;
  extractError: string;
  zipPath: string;
  allFields, matchedFields: TFieldOrderInfoArray;
  allCount: Integer;
begin
  Result := False;
  
  // Zobrazit dialog pro zadání parametrů generování
  if not ShowGenerationParamsDialog(generationParams) then
    Exit;  // Uživatel zrušil dialog
  
  try
    // Kontrola GfaMain
    if GfaMain = nil then
    begin
      ShowMessage('Nelze vytvořit testovací data: GfaMain není inicializován.');
      Exit;
    end;
    
    if not GfaMain.mtDef.Active then
    begin
      ShowMessage('Nelze vytvořit testovací data: mtDef není aktivní.');
      Exit;
    end;
    
    if not GfaMain.mtValues.Active then
    begin
      ShowMessage('Nelze vytvořit testovací data: mtValues není aktivní.');
      Exit;
    end;
    
    if not GfaMain.mtFields.Active then
    begin
      ShowMessage('Nelze vytvořit testovací data: mtFields není aktivní.');
      Exit;
    end;
    
    defID := GfaMain.mtDefID.AsString;
    if defID = '' then
    begin
      ShowMessage('Nelze vytvořit testovací data: DefID je prázdný.');
      Exit;
    end;

    // Zkontrolovat, zda existuje ZIP soubor, pokud ne, zkusit konverzi
    zipPath := NormalPath(GetExePath) + 'Export\' + defID + '.fdx.zip';
    if not FileExists(zipPath) then
    begin
      // Zkusit konverzi FDE na FDEX
      GfaMain.ConvertFDEtoFDEX;
      // Po konverzi znovu zkontrolovat existenci ZIP souboru
      if not FileExists(zipPath) then
      begin
        ShowMessage('Nelze vytvořit testovací data: FDX soubor neexistuje.' + #13#10 + 
                    'Očekávaná cesta:' + #13#10 + zipPath);
        Exit;
      end;
    end;
    
    // Načíst a parsovat design.json do oddělených kolekcí
    if not ExtractDesignJsonFromZip(defID, jsonContent, extractError) then
    begin
      ShowMessage('Nelze vytvořit testovací data:' + #13#10 + #13#10 + extractError);
      Exit;
    end;
    
    if not ParseJsonToCollections(jsonContent, dateFields, stringFields, numberFields, booleanFields, memoFields) then
    begin
      ShowMessage('Nelze vytvořit testovací data: Nepodařilo se parsovat design.json do kolekcí polí.' + #13#10 + 
                  'Soubor pravděpodobně neobsahuje žádná pole typu TextEditBox, CheckBox nebo TextMemoBox.');
      Exit;
    end;
    
    // Seřadit každou kolekci a přiřadit Order
    SortAndAssignOrder(dateFields);
    SortAndAssignOrder(stringFields);
    SortAndAssignOrder(numberFields);
    SortAndAssignOrder(booleanFields);
    SortAndAssignOrder(memoFields);
    
    // Parsovat příkazy
    if not ParseCommands(generationParams, commands, parseError) then
    begin
      ShowMessage('Chyba při parsování příkazů:' + #13#10 + #13#10 + parseError);
      Exit;
    end;
    
    // PRVNÍ PRŮCHOD: Provést nastavovací příkazy (calculate, disabling) jako první
    for cmdIdx := 0 to High(commands) do
    begin
      cmd := commands[cmdIdx];
      
      case cmd.CommandType of
        ctCalculate:
          GfaMain.SetFormCalculationEnabled(cmd.BoolValue);
        
        ctDisabling:
          GfaMain.SetFieldEditingModeEnabled(cmd.BoolValue);
      end;
    end;
    
    // DRUHÝ PRŮCHOD: Provést clr příkazy
    for cmdIdx := 0 to High(commands) do
    begin
      cmd := commands[cmdIdx];
      
      if cmd.CommandType = ctClear then
        ClearAllFields;
    end;
    
    // TŘETÍ PRŮCHOD: Provést fillall příkazy
    for cmdIdx := 0 to High(commands) do
    begin
      cmd := commands[cmdIdx];
      
      if cmd.CommandType = ctFillAll then
      begin
        // Pokud má ClearBefore, smazat všechna pole nejdřív
        if cmd.Params.ClearBefore then
          ClearAllFields;
        
        FillAllFieldsWithParams(cmd.Params, dateFields, stringFields, numberFields, booleanFields, memoFields);
      end;
    end;
    
    // ČTVRTÝ PRŮCHOD: Provést všechny fill příkazy (mohou přepsat hodnoty z fillall)
    for cmdIdx := 0 to High(commands) do
    begin
      cmd := commands[cmdIdx];
      
      if cmd.CommandType = ctFill then
      begin
        // Pokud má ClearBefore, smazat matchovaná pole nejdřív
        if cmd.Params.ClearBefore then
        begin
          // Najít matchovaná pole
          allCount := Length(dateFields) + Length(stringFields) + Length(numberFields) + 
                     Length(booleanFields) + Length(memoFields);
          SetLength(allFields, allCount);
          allCount := 0;
          
          for i := 0 to High(dateFields) do
          begin
            allFields[allCount] := dateFields[i];
            Inc(allCount);
          end;
          for i := 0 to High(stringFields) do
          begin
            allFields[allCount] := stringFields[i];
            Inc(allCount);
          end;
          for i := 0 to High(numberFields) do
          begin
            allFields[allCount] := numberFields[i];
            Inc(allCount);
          end;
          for i := 0 to High(booleanFields) do
          begin
            allFields[allCount] := booleanFields[i];
            Inc(allCount);
          end;
          for i := 0 to High(memoFields) do
          begin
            allFields[allCount] := memoFields[i];
            Inc(allCount);
          end;
          
          matchedFields := MatchFieldNames(cmd.FieldPattern, allFields);
          ClearSelectedFields(matchedFields);
        end;
        
        FillSelectedFieldsWithParams(cmd.FieldPattern, cmd.Params, dateFields, stringFields, numberFields, booleanFields, memoFields);
      end;
    end;
    
    // Exportovat do TXT souborů pro kontrolu
    // exportPath := NormalPath(GetExePath) + 'Export\';
    // ExportCollectionToTxt(dateFields, exportPath + defID + '_date_fields.txt');
    // ExportCollectionToTxt(stringFields, exportPath + defID + '_string_fields.txt');
    // ExportCollectionToTxt(numberFields, exportPath + defID + '_number_fields.txt');
    // ExportCollectionToTxt(booleanFields, exportPath + defID + '_boolean_fields.txt');
    // ExportCollectionToTxt(memoFields, exportPath + defID + '_memo_fields.txt');
    
    // Vytvořit pomocný slovník pro rychlé vyhledávání hodnot
    valueDict := TStringList.Create;
    
    // Přidat všechna pole do slovníku (FieldName -> TextValue)
    for i := 0 to High(dateFields) do
      valueDict.Values[UpperCase(dateFields[i].FieldName)] := dateFields[i].TextValue;
    for i := 0 to High(stringFields) do
      valueDict.Values[UpperCase(stringFields[i].FieldName)] := stringFields[i].TextValue;
    for i := 0 to High(numberFields) do
      valueDict.Values[UpperCase(numberFields[i].FieldName)] := numberFields[i].TextValue;
    for i := 0 to High(booleanFields) do
      valueDict.Values[UpperCase(booleanFields[i].FieldName)] := booleanFields[i].TextValue;
    for i := 0 to High(memoFields) do
      valueDict.Values[UpperCase(memoFields[i].FieldName)] := memoFields[i].TextValue;
    
    // Aplikovat hodnoty do mtValues
    with GfaMain.mtValues do
    begin
      if RecordCount = 0 then
        Append
      else
        Edit;
      
      // Projít všechna pole v mtValues a najít hodnotu ze slovníku
      for i := 0 to Fields.Count - 1 do
      begin
        field := Fields[i];
        
        textValue := valueDict.Values[UpperCase(field.FieldName)];
        
        if textValue <> '' then
        begin
          // Checkboxy nastavit vždy
          if field is TBooleanField then
          begin
            // Checkboxy vždy nastavit (nemají prázdný stav)
            field.Value := (textValue = 'True');
          end
          else if field.AsString = '' then
          begin
            // Ostatní pole vyplnit jen pokud jsou prázdné
            // (clr parametr zajistí vyprázdnění před vyplněním)
            if field is TDateField then
            begin
              // Převést textové datum na TDateTime
              try
                field.Value := StrToDate(textValue);
              except
                // Pokud převod selže, ignorovat
              end;
            end
            else
            begin
              // String, Memo, Number - přiřadit jako text
              try
                // Pro číselná pole převést tečku na čárku (české nastavení)
                if (field is TFloatField) or (field is TCurrencyField) then
                  field.Value := StringReplace(textValue, '.', ',', [rfReplaceAll])
                else
                  field.Value := textValue;
              except
                // Ignorovat chyby (např. ListBox)
              end;
            end;
          end;
        end;
      end;
    end;
    
    // Uvolnit slovník
    valueDict.Free;
    
    // Post změny a refresh
    GfaMain.TryPostMtValues;
    GfaMain.mtValues.Refresh;
    
    Result := True;
    
  except
    on E: Exception do
    begin
      ShowMessage('Chyba při vyplňování testovacích hodnot: ' + E.Message);
      Result := False;
    end;
  end;
end;

initialization

finalization
  if GWordDictionary <> nil then
    GWordDictionary.Free;

end.

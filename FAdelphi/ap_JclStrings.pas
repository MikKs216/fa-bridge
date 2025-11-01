{***************************************************************************}
{ This source code was generated automatically by                           }
{ Pas file import tool for Scripter Studio (Pro)                            }
{                                                                           }
{ Scripter Studio and Pas file import tool for Scripter Studio              }
{ written by TMS Software                                                   }
{            copyright © 1997 - 2010                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{***************************************************************************}
unit ap_JclStrings;

interface

uses
  Windows,
  Classes,
  SysUtils,
  JclAnsiStrings,
  JclWideStrings,
  JclBase,
  JclStrings,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatJclStringsLibrary = class(TatScripterLibrary)
    procedure __TJclStringBuilderCreate(AMachine: TatVirtualMachine);
    procedure __TJclStringBuilderAppend(AMachine: TatVirtualMachine);
    procedure __TJclStringBuilderAppendFormat(AMachine: TatVirtualMachine);
    procedure __TJclStringBuilderInsert(AMachine: TatVirtualMachine);
    procedure __TJclStringBuilderReplace(AMachine: TatVirtualMachine);
    procedure __TJclStringBuilderRemove(AMachine: TatVirtualMachine);
    procedure __TJclStringBuilderEnsureCapacity(AMachine: TatVirtualMachine);
    procedure __TJclStringBuilderClear(AMachine: TatVirtualMachine);
    procedure __TJclStringBuilderToString(AMachine: TatVirtualMachine);
    procedure __GetTJclStringBuilder__Chars__(AMachine: TatVirtualMachine);
    procedure __SetTJclStringBuilder__Chars__(AMachine: TatVirtualMachine);
    procedure __GetTJclStringBuilderLength(AMachine: TatVirtualMachine);
    procedure __SetTJclStringBuilderLength(AMachine: TatVirtualMachine);
    procedure __GetTJclStringBuilderCapacity(AMachine: TatVirtualMachine);
    procedure __SetTJclStringBuilderCapacity(AMachine: TatVirtualMachine);
    procedure __GetTJclStringBuilderMaxCapacity(AMachine: TatVirtualMachine);
    procedure __TJclTabSetCreate(AMachine: TatVirtualMachine);
    procedure __TJclTabSetDestroy(AMachine: TatVirtualMachine);
    procedure __TJclTabSetClone(AMachine: TatVirtualMachine);
    procedure __TJclTabSetNewReference(AMachine: TatVirtualMachine);
    procedure __TJclTabSetAdd(AMachine: TatVirtualMachine);
    procedure __TJclTabSetDelete(AMachine: TatVirtualMachine);
    procedure __TJclTabSetExpand(AMachine: TatVirtualMachine);
    procedure __TJclTabSetOptimalFillInfo(AMachine: TatVirtualMachine);
    procedure __TJclTabSetOptimize(AMachine: TatVirtualMachine);
    procedure __TJclTabSetStartColumn(AMachine: TatVirtualMachine);
    procedure __TJclTabSetTabFrom(AMachine: TatVirtualMachine);
    procedure __TJclTabSetUpdatePosition(AMachine: TatVirtualMachine);
    procedure __TJclTabSetToString(AMachine: TatVirtualMachine);
    procedure __TJclTabSetFromString(AMachine: TatVirtualMachine);
    procedure __GetTJclTabSetActualTabWidth(AMachine: TatVirtualMachine);
    procedure __GetTJclTabSetCount(AMachine: TatVirtualMachine);
    procedure __GetTJclTabSetTabStops(AMachine: TatVirtualMachine);
    procedure __SetTJclTabSetTabStops(AMachine: TatVirtualMachine);
    procedure __GetTJclTabSetTabWidth(AMachine: TatVirtualMachine);
    procedure __SetTJclTabSetTabWidth(AMachine: TatVirtualMachine);
    procedure __GetTJclTabSetZeroBased(AMachine: TatVirtualMachine);
    procedure __SetTJclTabSetZeroBased(AMachine: TatVirtualMachine);
    procedure __NullReferenceExceptionCreate(AMachine: TatVirtualMachine);
    procedure __StrIsAlpha(AMachine: TatVirtualMachine);
    procedure __StrIsAlphaNum(AMachine: TatVirtualMachine);
    procedure __StrIsAlphaNumUnderscore(AMachine: TatVirtualMachine);
    procedure __StrConsistsOfNumberChars(AMachine: TatVirtualMachine);
    procedure __StrIsDigit(AMachine: TatVirtualMachine);
    procedure __StrSame(AMachine: TatVirtualMachine);
    procedure __StrCenter(AMachine: TatVirtualMachine);
    procedure __StrCharPosLower(AMachine: TatVirtualMachine);
    procedure __StrCharPosUpper(AMachine: TatVirtualMachine);
    procedure __StrDoubleQuote(AMachine: TatVirtualMachine);
    procedure __StrEnsureNoPrefix(AMachine: TatVirtualMachine);
    procedure __StrEnsureNoSuffix(AMachine: TatVirtualMachine);
    procedure __StrEnsurePrefix(AMachine: TatVirtualMachine);
    procedure __StrEnsureSuffix(AMachine: TatVirtualMachine);
    procedure __StrEscapedToString(AMachine: TatVirtualMachine);
    procedure __StrLower(AMachine: TatVirtualMachine);
    procedure __StrLowerInPlace(AMachine: TatVirtualMachine);
    procedure __StrLowerBuff(AMachine: TatVirtualMachine);
    procedure __StrMove(AMachine: TatVirtualMachine);
    procedure __StrPadLeft(AMachine: TatVirtualMachine);
    procedure __StrPadRight(AMachine: TatVirtualMachine);
    procedure __StrProper(AMachine: TatVirtualMachine);
    procedure __StrProperBuff(AMachine: TatVirtualMachine);
    procedure __StrQuote(AMachine: TatVirtualMachine);
    procedure __StrReplace(AMachine: TatVirtualMachine);
    procedure __StrReplaceChar(AMachine: TatVirtualMachine);
    procedure __StrRepeat(AMachine: TatVirtualMachine);
    procedure __StrRepeatLength(AMachine: TatVirtualMachine);
    procedure __StrReverse(AMachine: TatVirtualMachine);
    procedure __StrReverseInPlace(AMachine: TatVirtualMachine);
    procedure __StrSingleQuote(AMachine: TatVirtualMachine);
    procedure __StrStringToEscaped(AMachine: TatVirtualMachine);
    procedure __StrStripNonNumberChars(AMachine: TatVirtualMachine);
    procedure __StrToHex(AMachine: TatVirtualMachine);
    procedure __StrTrimCharLeft(AMachine: TatVirtualMachine);
    procedure __StrTrimCharRight(AMachine: TatVirtualMachine);
    procedure __StrTrimQuotes(AMachine: TatVirtualMachine);
    procedure __StrUpper(AMachine: TatVirtualMachine);
    procedure __StrUpperInPlace(AMachine: TatVirtualMachine);
    procedure __StrUpperBuff(AMachine: TatVirtualMachine);
    procedure __StrAddRef(AMachine: TatVirtualMachine);
    procedure __StrDecRef(AMachine: TatVirtualMachine);
    procedure __StrLength(AMachine: TatVirtualMachine);
    procedure __StrRefCount(AMachine: TatVirtualMachine);
    procedure __StrCharCount(AMachine: TatVirtualMachine);
    procedure __StrStrCount(AMachine: TatVirtualMachine);
    procedure __StrCompare(AMachine: TatVirtualMachine);
    procedure __StrCompareRange(AMachine: TatVirtualMachine);
    procedure __StrCompareRangeEx(AMachine: TatVirtualMachine);
    procedure __StrFillChar(AMachine: TatVirtualMachine);
    procedure __StrRepeatChar(AMachine: TatVirtualMachine);
    procedure __StrFind(AMachine: TatVirtualMachine);
    procedure __StrILastPos(AMachine: TatVirtualMachine);
    procedure __StrIPos(AMachine: TatVirtualMachine);
    procedure __StrLastPos(AMachine: TatVirtualMachine);
    procedure __StrMatch(AMachine: TatVirtualMachine);
    procedure __StrMatches(AMachine: TatVirtualMachine);
    procedure __StrNIPos(AMachine: TatVirtualMachine);
    procedure __StrNPos(AMachine: TatVirtualMachine);
    procedure __StrSearch(AMachine: TatVirtualMachine);
    procedure __StrAfter(AMachine: TatVirtualMachine);
    procedure __StrBefore(AMachine: TatVirtualMachine);
    procedure __StrSplit(AMachine: TatVirtualMachine);
    procedure __StrBetween(AMachine: TatVirtualMachine);
    procedure __StrChopRight(AMachine: TatVirtualMachine);
    procedure __StrLeft(AMachine: TatVirtualMachine);
    procedure __StrMid(AMachine: TatVirtualMachine);
    procedure __StrRestOf(AMachine: TatVirtualMachine);
    procedure __StrRight(AMachine: TatVirtualMachine);
    procedure __CharEqualNoCase(AMachine: TatVirtualMachine);
    procedure __CharIsAlpha(AMachine: TatVirtualMachine);
    procedure __CharIsAlphaNum(AMachine: TatVirtualMachine);
    procedure __CharIsBlank(AMachine: TatVirtualMachine);
    procedure __CharIsControl(AMachine: TatVirtualMachine);
    procedure __CharIsDelete(AMachine: TatVirtualMachine);
    procedure __CharIsDigit(AMachine: TatVirtualMachine);
    procedure __CharIsFracDigit(AMachine: TatVirtualMachine);
    procedure __CharIsHexDigit(AMachine: TatVirtualMachine);
    procedure __CharIsLower(AMachine: TatVirtualMachine);
    procedure __CharIsNumberChar(AMachine: TatVirtualMachine);
    procedure __CharIsNumber(AMachine: TatVirtualMachine);
    procedure __CharIsPrintable(AMachine: TatVirtualMachine);
    procedure __CharIsPunctuation(AMachine: TatVirtualMachine);
    procedure __CharIsReturn(AMachine: TatVirtualMachine);
    procedure __CharIsSpace(AMachine: TatVirtualMachine);
    procedure __CharIsUpper(AMachine: TatVirtualMachine);
    procedure __CharIsValidIdentifierLetter(AMachine: TatVirtualMachine);
    procedure __CharIsWhiteSpace(AMachine: TatVirtualMachine);
    procedure __CharIsWildcard(AMachine: TatVirtualMachine);
    procedure __CharType(AMachine: TatVirtualMachine);
    procedure __CharHex(AMachine: TatVirtualMachine);
    procedure __CharLower(AMachine: TatVirtualMachine);
    procedure __CharUpper(AMachine: TatVirtualMachine);
    procedure __CharToggleCase(AMachine: TatVirtualMachine);
    procedure __CharPos(AMachine: TatVirtualMachine);
    procedure __CharLastPos(AMachine: TatVirtualMachine);
    procedure __CharIPos(AMachine: TatVirtualMachine);
    procedure __CharReplace(AMachine: TatVirtualMachine);
    procedure __StringsToMultiSz(AMachine: TatVirtualMachine);
    procedure __MultiSzToStrings(AMachine: TatVirtualMachine);
    procedure __MultiSzLength(AMachine: TatVirtualMachine);
    procedure __AllocateMultiSz(AMachine: TatVirtualMachine);
    procedure __FreeMultiSz(AMachine: TatVirtualMachine);
    procedure __MultiSzDup(AMachine: TatVirtualMachine);
    procedure __AnsiStringsToAnsiMultiSz(AMachine: TatVirtualMachine);
    procedure __AnsiMultiSzToAnsiStrings(AMachine: TatVirtualMachine);
    procedure __AnsiMultiSzLength(AMachine: TatVirtualMachine);
    procedure __AllocateAnsiMultiSz(AMachine: TatVirtualMachine);
    procedure __FreeAnsiMultiSz(AMachine: TatVirtualMachine);
    procedure __AnsiMultiSzDup(AMachine: TatVirtualMachine);
    procedure __WideStringsToWideMultiSz(AMachine: TatVirtualMachine);
    procedure __WideMultiSzToWideStrings(AMachine: TatVirtualMachine);
    procedure __WideMultiSzLength(AMachine: TatVirtualMachine);
    procedure __AllocateWideMultiSz(AMachine: TatVirtualMachine);
    procedure __FreeWideMultiSz(AMachine: TatVirtualMachine);
    procedure __WideMultiSzDup(AMachine: TatVirtualMachine);
    procedure __StrIToStrings(AMachine: TatVirtualMachine);
    procedure __StrToStrings(AMachine: TatVirtualMachine);
    procedure __TrimStrings(AMachine: TatVirtualMachine);
    procedure __TrimStringsRight(AMachine: TatVirtualMachine);
    procedure __TrimStringsLeft(AMachine: TatVirtualMachine);
    procedure __AddStringToStrings(AMachine: TatVirtualMachine);
    procedure __FileToString(AMachine: TatVirtualMachine);
    procedure __StringToFile(AMachine: TatVirtualMachine);
    procedure __StrToken(AMachine: TatVirtualMachine);
    procedure __StrTokens(AMachine: TatVirtualMachine);
    procedure __StrTokenToStrings(AMachine: TatVirtualMachine);
    procedure __StrWord(AMachine: TatVirtualMachine);
    procedure __StrIdent(AMachine: TatVirtualMachine);
    procedure __StrToFloatSafe(AMachine: TatVirtualMachine);
    procedure __StrToIntSafe(AMachine: TatVirtualMachine);
    procedure __StrNormIndex(AMachine: TatVirtualMachine);
    procedure __ArrayOf(AMachine: TatVirtualMachine);
    procedure __DotNetFormat(AMachine: TatVirtualMachine);
    procedure __StrExpandTabs(AMachine: TatVirtualMachine);
    procedure __StrOptimizeTabs(AMachine: TatVirtualMachine);
    procedure __StrResetLength(AMachine: TatVirtualMachine);
    procedure __CompareNaturalStr(AMachine: TatVirtualMachine);
    procedure __CompareNaturalText(AMachine: TatVirtualMachine);
    procedure __GetStrCaseMapReady(AMachine: TatVirtualMachine);
    procedure __SetStrCaseMapReady(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  EJclStringErrorClass = class of EJclStringError;
  TAnsiStringsClass = class of TAnsiStrings;
  TWideStringsClass = class of TWideStrings;
  TAnsiStringListClass = class of TAnsiStringList;
  TWideStringListClass = class of TWideStringList;
  FormatExceptionClass = class of FormatException;
  ArgumentExceptionClass = class of ArgumentException;
  ArgumentNullExceptionClass = class of ArgumentNullException;
  ArgumentOutOfRangeExceptionClass = class of ArgumentOutOfRangeException;
  TJclStringBuilderClass = class of TJclStringBuilder;
  TStringBuilderClass = class of TStringBuilder;
  TJclTabSetClass = class of TJclTabSet;
  NullReferenceExceptionClass = class of NullReferenceException;



implementation



procedure TatJclStringsLibrary.__TJclStringBuilderCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := ObjectToVar(TJclStringBuilderClass(CurrentClass.ClassRef).Create(VarToStr(GetInputArg(0))));
2: AResult := ObjectToVar(TJclStringBuilderClass(CurrentClass.ClassRef).Create(VarToStr(GetInputArg(0)),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclStringBuilderAppend(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TJclStringBuilder(CurrentObject).Append(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclStringBuilderAppendFormat(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TJclStringBuilder(CurrentObject).AppendFormat(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclStringBuilderInsert(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := ObjectToVar(TJclStringBuilder(CurrentObject).Insert(GetInputArg(0),VarToStr(GetInputArg(1))));
3: AResult := ObjectToVar(TJclStringBuilder(CurrentObject).Insert(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclStringBuilderReplace(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := ObjectToVar(TJclStringBuilder(CurrentObject).Replace(VarToStr(GetInputArg(0))[1],VarToStr(GetInputArg(1))[1]));
3: AResult := ObjectToVar(TJclStringBuilder(CurrentObject).Replace(VarToStr(GetInputArg(0))[1],VarToStr(GetInputArg(1))[1],GetInputArg(2)));
4: AResult := ObjectToVar(TJclStringBuilder(CurrentObject).Replace(VarToStr(GetInputArg(0))[1],VarToStr(GetInputArg(1))[1],GetInputArg(2),GetInputArg(3)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclStringBuilderRemove(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TJclStringBuilder(CurrentObject).Remove(GetInputArg(0),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclStringBuilderEnsureCapacity(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TJclStringBuilder(CurrentObject).EnsureCapacity(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclStringBuilderClear(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TJclStringBuilder(CurrentObject).Clear;
  end;
end;

procedure TatJclStringsLibrary.__TJclStringBuilderToString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(TJclStringBuilder(CurrentObject).ToString);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__GetTJclStringBuilder__Chars__(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclStringBuilder(CurrentObject).__Chars__[GetArrayIndex(0)]);
  end;
end;

procedure TatJclStringsLibrary.__SetTJclStringBuilder__Chars__(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TJclStringBuilder(CurrentObject).__Chars__[GetArrayIndex(0)]:=VarToStr(GetInputArg(0))[1];
  end;
end;

procedure TatJclStringsLibrary.__GetTJclStringBuilderLength(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclStringBuilder(CurrentObject).Length);
  end;
end;

procedure TatJclStringsLibrary.__SetTJclStringBuilderLength(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TJclStringBuilder(CurrentObject).Length:=GetInputArg(0);
  end;
end;

procedure TatJclStringsLibrary.__GetTJclStringBuilderCapacity(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclStringBuilder(CurrentObject).Capacity);
  end;
end;

procedure TatJclStringsLibrary.__SetTJclStringBuilderCapacity(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TJclStringBuilder(CurrentObject).Capacity:=GetInputArg(0);
  end;
end;

procedure TatJclStringsLibrary.__GetTJclStringBuilderMaxCapacity(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclStringBuilder(CurrentObject).MaxCapacity);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TJclTabSetClass(CurrentClass.ClassRef).Create);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TJclTabSet(CurrentObject).Destroy;
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetClone(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TJclTabSet(CurrentObject).Clone);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetNewReference(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TJclTabSet(CurrentObject).NewReference);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetAdd(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TJclTabSet(CurrentObject).Add(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetDelete(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TJclTabSet(CurrentObject).Delete(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetExpand(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(TJclTabSet(CurrentObject).Expand(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetOptimalFillInfo(AMachine: TatVirtualMachine);
  var
  Param2: SizeInt;
  Param3: SizeInt;
begin
  with AMachine do
  begin
Param2 := GetInputArg(2);
Param3 := GetInputArg(3);
    TJclTabSet(CurrentObject).OptimalFillInfo(GetInputArg(0),GetInputArg(1),Param2,Param3);
    SetInputArg(2,Param2);
    SetInputArg(3,Param3);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetOptimize(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(TJclTabSet(CurrentObject).Optimize(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetStartColumn(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TJclTabSet(CurrentObject).StartColumn;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetTabFrom(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TJclTabSet(CurrentObject).TabFrom(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetUpdatePosition(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := TJclTabSet(CurrentObject).UpdatePosition(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetToString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(TJclTabSet(CurrentObject).ToString);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__TJclTabSetFromString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TJclTabSetClass(CurrentClass.ClassRef).FromString(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__GetTJclTabSetActualTabWidth(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclTabSet(CurrentObject).ActualTabWidth);
  end;
end;

procedure TatJclStringsLibrary.__GetTJclTabSetCount(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclTabSet(CurrentObject).Count);
  end;
end;

procedure TatJclStringsLibrary.__GetTJclTabSetTabStops(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclTabSet(CurrentObject).TabStops[GetArrayIndex(0)]);
  end;
end;

procedure TatJclStringsLibrary.__SetTJclTabSetTabStops(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TJclTabSet(CurrentObject).TabStops[GetArrayIndex(0)]:=GetInputArg(0);
  end;
end;

procedure TatJclStringsLibrary.__GetTJclTabSetTabWidth(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclTabSet(CurrentObject).TabWidth);
  end;
end;

procedure TatJclStringsLibrary.__SetTJclTabSetTabWidth(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TJclTabSet(CurrentObject).TabWidth:=GetInputArg(0);
  end;
end;

procedure TatJclStringsLibrary.__GetTJclTabSetZeroBased(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TJclTabSet(CurrentObject).ZeroBased);
  end;
end;

procedure TatJclStringsLibrary.__SetTJclTabSetZeroBased(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TJclTabSet(CurrentObject).ZeroBased:=GetInputArg(0);
  end;
end;

procedure TatJclStringsLibrary.__NullReferenceExceptionCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(NullReferenceExceptionClass(CurrentClass.ClassRef).Create);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrIsAlpha(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrIsAlpha(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrIsAlphaNum(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrIsAlphaNum(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrIsAlphaNumUnderscore(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrIsAlphaNumUnderscore(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrConsistsOfNumberChars(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrConsistsOfNumberChars(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrIsDigit(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrIsDigit(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrSame(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.StrSame(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := JclStrings.StrSame(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrCenter(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := string(JclStrings.StrCenter(VarToStr(GetInputArg(0)),GetInputArg(1)));
3: AResult := string(JclStrings.StrCenter(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2))[1]));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrCharPosLower(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrCharPosLower(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrCharPosUpper(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrCharPosUpper(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrDoubleQuote(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrDoubleQuote(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrEnsureNoPrefix(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrEnsureNoPrefix(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrEnsureNoSuffix(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrEnsureNoSuffix(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrEnsurePrefix(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrEnsurePrefix(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrEnsureSuffix(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrEnsureSuffix(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrEscapedToString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrEscapedToString(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrLower(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrLower(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrLowerInPlace(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    JclStrings.StrLowerInPlace(Param0);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StrLowerBuff(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    JclStrings.StrLowerBuff(PChar(VarToStr(GetInputArg(0))));
  end;
end;

procedure TatJclStringsLibrary.__StrMove(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    JclStrings.StrMove(Param0,VarToStr(GetInputArg(1)),GetInputArg(2),GetInputArg(3),GetInputArg(4));
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StrPadLeft(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := string(JclStrings.StrPadLeft(VarToStr(GetInputArg(0)),GetInputArg(1)));
3: AResult := string(JclStrings.StrPadLeft(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2))[1]));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrPadRight(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := string(JclStrings.StrPadRight(VarToStr(GetInputArg(0)),GetInputArg(1)));
3: AResult := string(JclStrings.StrPadRight(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2))[1]));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrProper(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrProper(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrProperBuff(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    JclStrings.StrProperBuff(PChar(VarToStr(GetInputArg(0))));
  end;
end;

procedure TatJclStringsLibrary.__StrQuote(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrQuote(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1]));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrReplace(AMachine: TatVirtualMachine);
  var
  Param0: string;
  Param3: TReplaceFlags;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
IntToSet(Param3, VarToInteger(GetInputArg(3)), SizeOf(Param3));
    Case InputArgCount of
      3: JclStrings.StrReplace(Param0,VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
      4: JclStrings.StrReplace(Param0,VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),Param3);
    end;
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StrReplaceChar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrReplaceChar(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1],VarToStr(GetInputArg(2))[1]));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrRepeat(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrRepeat(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrRepeatLength(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrRepeatLength(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrReverse(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrReverse(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrReverseInPlace(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    JclStrings.StrReverseInPlace(Param0);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StrSingleQuote(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrSingleQuote(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrStringToEscaped(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrStringToEscaped(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrStripNonNumberChars(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrStripNonNumberChars(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrToHex(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrToHex(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrTrimCharLeft(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrTrimCharLeft(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1]));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrTrimCharRight(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrTrimCharRight(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1]));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrTrimQuotes(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrTrimQuotes(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrUpper(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrUpper(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrUpperInPlace(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    JclStrings.StrUpperInPlace(Param0);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StrUpperBuff(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    JclStrings.StrUpperBuff(PChar(VarToStr(GetInputArg(0))));
  end;
end;

procedure TatJclStringsLibrary.__StrAddRef(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    JclStrings.StrAddRef(Param0);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StrDecRef(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    JclStrings.StrDecRef(Param0);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StrLength(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrLength(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrRefCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrRefCount(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrCharCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrCharCount(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrStrCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrStrCount(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrCompare(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.StrCompare(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := JclStrings.StrCompare(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrCompareRange(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
4: AResult := JclStrings.StrCompareRange(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),GetInputArg(3));
5: AResult := JclStrings.StrCompareRange(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),GetInputArg(3),GetInputArg(4));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrCompareRangeEx(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrCompareRangeEx(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),GetInputArg(3),GetInputArg(4));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrFillChar(AMachine: TatVirtualMachine);
  var
  Param0: Variant;
begin
  with AMachine do
  begin
Param0 := GetInputArg(0);
    JclStrings.StrFillChar(Param0,GetInputArg(1),VarToStr(GetInputArg(2))[1]);
    SetInputArg(0,Param0);
  end;
end;

procedure TatJclStringsLibrary.__StrRepeatChar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrRepeatChar(VarToStr(GetInputArg(0))[1],GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrFind(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.StrFind(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := JclStrings.StrFind(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrILastPos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrILastPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrIPos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrIPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrLastPos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrLastPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrMatch(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.StrMatch(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := JclStrings.StrMatch(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrMatches(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.StrMatches(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := JclStrings.StrMatches(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrNIPos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrNIPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrNPos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrNPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrSearch(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.StrSearch(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := JclStrings.StrSearch(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrAfter(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrAfter(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrBefore(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrBefore(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrSplit(AMachine: TatVirtualMachine);
  var
  Param2: string;
  Param3: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
Param3 := VarToStr(GetInputArg(3));
AResult := JclStrings.StrSplit(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2,Param3);
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
    SetInputArg(3,string(Param3));
  end;
end;

procedure TatJclStringsLibrary.__StrBetween(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrBetween(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1],VarToStr(GetInputArg(2))[1]));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrChopRight(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrChopRight(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrLeft(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrLeft(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrMid(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrMid(VarToStr(GetInputArg(0)),GetInputArg(1),GetInputArg(2)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrRestOf(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrRestOf(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrRight(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrRight(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharEqualNoCase(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharEqualNoCase(VarToStr(GetInputArg(0))[1],VarToStr(GetInputArg(1))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsAlpha(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsAlpha(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsAlphaNum(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsAlphaNum(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsBlank(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsBlank(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsControl(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsControl(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsDelete(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsDelete(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsDigit(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsDigit(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsFracDigit(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsFracDigit(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsHexDigit(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsHexDigit(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsLower(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsLower(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsNumberChar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsNumberChar(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsNumber(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsNumber(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsPrintable(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsPrintable(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsPunctuation(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsPunctuation(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsReturn(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsReturn(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsSpace(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsSpace(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsUpper(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsUpper(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsValidIdentifierLetter(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsValidIdentifierLetter(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsWhiteSpace(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsWhiteSpace(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIsWildcard(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharIsWildcard(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharType(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(JclStrings.CharType(VarToStr(GetInputArg(0))[1]));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharHex(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(JclStrings.CharHex(VarToStr(GetInputArg(0))[1]));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharLower(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharLower(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharUpper(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharUpper(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharToggleCase(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CharToggleCase(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharPos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.CharPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1]);
3: AResult := JclStrings.CharPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1],GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharLastPos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.CharLastPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1]);
3: AResult := JclStrings.CharLastPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1],GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharIPos(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := JclStrings.CharIPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1]);
3: AResult := JclStrings.CharIPos(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1],GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CharReplace(AMachine: TatVirtualMachine);
  var
  Param0: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
AResult := JclStrings.CharReplace(Param0,VarToStr(GetInputArg(1))[1],VarToStr(GetInputArg(2))[1]);
    ReturnOutputArg(AResult);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StringsToMultiSz(AMachine: TatVirtualMachine);
  var
  Param0: PMultiSz;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := PChar(VarToStr(GetInputArg(0)));
AResult := string(JclStrings.StringsToMultiSz(Param0,TStrings(VarToObject(GetInputArg(1)))));
    ReturnOutputArg(AResult);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__MultiSzToStrings(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    JclStrings.MultiSzToStrings(TStrings(VarToObject(GetInputArg(0))),PChar(VarToStr(GetInputArg(1))));
  end;
end;

procedure TatJclStringsLibrary.__MultiSzLength(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.MultiSzLength(PChar(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__AllocateMultiSz(AMachine: TatVirtualMachine);
  var
  Param0: PMultiSz;
begin
  with AMachine do
  begin
Param0 := PChar(VarToStr(GetInputArg(0)));
    JclStrings.AllocateMultiSz(Param0,GetInputArg(1));
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__FreeMultiSz(AMachine: TatVirtualMachine);
  var
  Param0: PMultiSz;
begin
  with AMachine do
  begin
Param0 := PChar(VarToStr(GetInputArg(0)));
    JclStrings.FreeMultiSz(Param0);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__MultiSzDup(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.MultiSzDup(PChar(VarToStr(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__AnsiStringsToAnsiMultiSz(AMachine: TatVirtualMachine);
  var
  Param0: PAnsiMultiSz;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := PChar(VarToStr(GetInputArg(0)));
AResult := string(JclStrings.AnsiStringsToAnsiMultiSz(Param0,TStrings(VarToObject(GetInputArg(1)))));
    ReturnOutputArg(AResult);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__AnsiMultiSzToAnsiStrings(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    JclStrings.AnsiMultiSzToAnsiStrings(TStrings(VarToObject(GetInputArg(0))),PChar(VarToStr(GetInputArg(1))));
  end;
end;

procedure TatJclStringsLibrary.__AnsiMultiSzLength(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.AnsiMultiSzLength(PChar(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__AllocateAnsiMultiSz(AMachine: TatVirtualMachine);
  var
  Param0: PAnsiMultiSz;
begin
  with AMachine do
  begin
Param0 := PChar(VarToStr(GetInputArg(0)));
    JclStrings.AllocateAnsiMultiSz(Param0,GetInputArg(1));
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__FreeAnsiMultiSz(AMachine: TatVirtualMachine);
  var
  Param0: PAnsiMultiSz;
begin
  with AMachine do
  begin
Param0 := PChar(VarToStr(GetInputArg(0)));
    JclStrings.FreeAnsiMultiSz(Param0);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__AnsiMultiSzDup(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.AnsiMultiSzDup(PChar(VarToStr(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__WideStringsToWideMultiSz(AMachine: TatVirtualMachine);
  var
  Param0Buf: array of WideChar;
  Param0: PWideMultiSz;
  AResult: variant;
begin
  with AMachine do
  begin
SetLength(Param0Buf, Length(VarToStr(GetInputArg(0))) + 1);
Param0 := StringToWideChar(VarToStr(GetInputArg(0)),@Param0Buf[0],Length(Param0Buf));
AResult := WideCharToString(JclStrings.WideStringsToWideMultiSz(Param0,TJclWideStrings(VarToObject(GetInputArg(1)))));
    ReturnOutputArg(AResult);
    SetInputArg(0,WideCharToString(Param0));
  end;
end;

procedure TatJclStringsLibrary.__WideMultiSzToWideStrings(AMachine: TatVirtualMachine);
  var
  Param1Buf: array of WideChar;
begin
  with AMachine do
  begin
SetLength(Param1Buf, Length(VarToStr(GetInputArg(1))) + 1);
    JclStrings.WideMultiSzToWideStrings(TJclWideStrings(VarToObject(GetInputArg(0))),StringToWideChar(VarToStr(GetInputArg(1)),@Param1Buf[0],Length(Param1Buf)));
  end;
end;

procedure TatJclStringsLibrary.__WideMultiSzLength(AMachine: TatVirtualMachine);
  var
  Param0Buf: array of WideChar;
  AResult: variant;
begin
  with AMachine do
  begin
SetLength(Param0Buf, Length(VarToStr(GetInputArg(0))) + 1);
AResult := JclStrings.WideMultiSzLength(StringToWideChar(VarToStr(GetInputArg(0)),@Param0Buf[0],Length(Param0Buf)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__AllocateWideMultiSz(AMachine: TatVirtualMachine);
  var
  Param0Buf: array of WideChar;
  Param0: PWideMultiSz;
begin
  with AMachine do
  begin
SetLength(Param0Buf, Length(VarToStr(GetInputArg(0))) + 1);
Param0 := StringToWideChar(VarToStr(GetInputArg(0)),@Param0Buf[0],Length(Param0Buf));
    JclStrings.AllocateWideMultiSz(Param0,GetInputArg(1));
    SetInputArg(0,WideCharToString(Param0));
  end;
end;

procedure TatJclStringsLibrary.__FreeWideMultiSz(AMachine: TatVirtualMachine);
  var
  Param0Buf: array of WideChar;
  Param0: PWideMultiSz;
begin
  with AMachine do
  begin
SetLength(Param0Buf, Length(VarToStr(GetInputArg(0))) + 1);
Param0 := StringToWideChar(VarToStr(GetInputArg(0)),@Param0Buf[0],Length(Param0Buf));
    JclStrings.FreeWideMultiSz(Param0);
    SetInputArg(0,WideCharToString(Param0));
  end;
end;

procedure TatJclStringsLibrary.__WideMultiSzDup(AMachine: TatVirtualMachine);
  var
  Param0Buf: array of WideChar;
  AResult: variant;
begin
  with AMachine do
  begin
SetLength(Param0Buf, Length(VarToStr(GetInputArg(0))) + 1);
AResult := WideCharToString(JclStrings.WideMultiSzDup(StringToWideChar(VarToStr(GetInputArg(0)),@Param0Buf[0],Length(Param0Buf))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrIToStrings(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      3: JclStrings.StrIToStrings(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),TStrings(VarToObject(GetInputArg(2))));
      4: JclStrings.StrIToStrings(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),TStrings(VarToObject(GetInputArg(2))),GetInputArg(3));
    end;
  end;
end;

procedure TatJclStringsLibrary.__StrToStrings(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      3: JclStrings.StrToStrings(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),TStrings(VarToObject(GetInputArg(2))));
      4: JclStrings.StrToStrings(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),TStrings(VarToObject(GetInputArg(2))),GetInputArg(3));
    end;
  end;
end;

procedure TatJclStringsLibrary.__TrimStrings(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      1: JclStrings.TrimStrings(TStrings(VarToObject(GetInputArg(0))));
      2: JclStrings.TrimStrings(TStrings(VarToObject(GetInputArg(0))),GetInputArg(1));
    end;
  end;
end;

procedure TatJclStringsLibrary.__TrimStringsRight(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      1: JclStrings.TrimStringsRight(TStrings(VarToObject(GetInputArg(0))));
      2: JclStrings.TrimStringsRight(TStrings(VarToObject(GetInputArg(0))),GetInputArg(1));
    end;
  end;
end;

procedure TatJclStringsLibrary.__TrimStringsLeft(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      1: JclStrings.TrimStringsLeft(TStrings(VarToObject(GetInputArg(0))));
      2: JclStrings.TrimStringsLeft(TStrings(VarToObject(GetInputArg(0))),GetInputArg(1));
    end;
  end;
end;

procedure TatJclStringsLibrary.__AddStringToStrings(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.AddStringToStrings(VarToStr(GetInputArg(0)),TStrings(VarToObject(GetInputArg(1))),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__FileToString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.FileToString(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StringToFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      2: JclStrings.StringToFile(VarToStr(GetInputArg(0)),GetInputArg(1));
      3: JclStrings.StringToFile(VarToStr(GetInputArg(0)),GetInputArg(1),GetInputArg(2));
    end;
  end;
end;

procedure TatJclStringsLibrary.__StrToken(AMachine: TatVirtualMachine);
  var
  Param0: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
AResult := string(JclStrings.StrToken(Param0,VarToStr(GetInputArg(1))[1]));
    ReturnOutputArg(AResult);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatJclStringsLibrary.__StrTokens(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    JclStrings.StrTokens(VarToStr(GetInputArg(0)),TStrings(VarToObject(GetInputArg(1))));
  end;
end;

procedure TatJclStringsLibrary.__StrTokenToStrings(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    JclStrings.StrTokenToStrings(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))[1],TStrings(VarToObject(GetInputArg(2))));
  end;
end;

procedure TatJclStringsLibrary.__StrWord(AMachine: TatVirtualMachine);
  var
  Param1: SizeInt;
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param1 := GetInputArg(1);
Param2 := VarToStr(GetInputArg(2));
AResult := JclStrings.StrWord(VarToStr(GetInputArg(0)),Param1,Param2);
    ReturnOutputArg(AResult);
    SetInputArg(1,Param1);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatJclStringsLibrary.__StrIdent(AMachine: TatVirtualMachine);
  var
  Param1: SizeInt;
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param1 := GetInputArg(1);
Param2 := VarToStr(GetInputArg(2));
AResult := JclStrings.StrIdent(VarToStr(GetInputArg(0)),Param1,Param2);
    ReturnOutputArg(AResult);
    SetInputArg(1,Param1);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatJclStringsLibrary.__StrToFloatSafe(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.StrToFloatSafe(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrToIntSafe(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(JclStrings.StrToIntSafe(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrNormIndex(AMachine: TatVirtualMachine);
  var
  Param1: SizeInt;
  Param2: SizeInt;
begin
  with AMachine do
  begin
Param1 := GetInputArg(1);
Param2 := GetInputArg(2);
    JclStrings.StrNormIndex(GetInputArg(0),Param1,Param2);
    SetInputArg(1,Param1);
    SetInputArg(2,Param2);
  end;
end;

procedure TatJclStringsLibrary.__ArrayOf(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.ArrayOf(TStrings(VarToObject(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__DotNetFormat(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.DotNetFormat(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrExpandTabs(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrExpandTabs(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrOptimizeTabs(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(JclStrings.StrOptimizeTabs(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__StrResetLength(AMachine: TatVirtualMachine);
  var
  Param0: WideString;
begin
  with AMachine do
  begin
Param0 := GetInputArg(0);
    JclStrings.StrResetLength(Param0);
    SetInputArg(0,Param0);
  end;
end;

procedure TatJclStringsLibrary.__CompareNaturalStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CompareNaturalStr(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__CompareNaturalText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := JclStrings.CompareNaturalText(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatJclStringsLibrary.__GetStrCaseMapReady(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(JclStrings.StrCaseMapReady);
  end;
end;

procedure TatJclStringsLibrary.__SetStrCaseMapReady(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    JclStrings.StrCaseMapReady:=GetInputArg(0);
  end;
end;

procedure TatJclStringsLibrary.Init;
begin
  With Scripter.DefineClass(EJclStringError) do
  begin
  end;
  With Scripter.DefineClass(TAnsiStrings) do
  begin
  end;
  With Scripter.DefineClass(TWideStrings) do
  begin
  end;
  With Scripter.DefineClass(TAnsiStringList) do
  begin
  end;
  With Scripter.DefineClass(TWideStringList) do
  begin
  end;
  With Scripter.DefineClass(FormatException) do
  begin
  end;
  With Scripter.DefineClass(ArgumentException) do
  begin
  end;
  With Scripter.DefineClass(ArgumentNullException) do
  begin
  end;
  With Scripter.DefineClass(ArgumentOutOfRangeException) do
  begin
  end;
  With Scripter.DefineClass(TJclStringBuilder) do
  begin
    DefineMethod('Create',2,tkClass,TJclStringBuilder,__TJclStringBuilderCreate,true,1,'Value: string; Capacity: SizeInt = 16');
    DefineMethod('Append',1,tkClass,TJclStringBuilder,__TJclStringBuilderAppend,false,0,'Value: string');
    DefineMethod('AppendFormat',2,tkClass,TJclStringBuilder,__TJclStringBuilderAppendFormat,false,0,'Fmt: string; Arg0: Variant');
    DefineMethod('Insert',3,tkClass,TJclStringBuilder,__TJclStringBuilderInsert,false,1,'Index: SizeInt; Value: string; Count: SizeInt = 1');
    DefineMethod('Replace',4,tkClass,TJclStringBuilder,__TJclStringBuilderReplace,false,2,'OldChar: Char; NewChar: Char; StartIndex: SizeInt = 0; Count: SizeInt = -1');
    DefineMethod('Remove',2,tkClass,TJclStringBuilder,__TJclStringBuilderRemove,false,0,'StartIndex: SizeInt; Length: SizeInt');
    DefineMethod('EnsureCapacity',1,tkVariant,nil,__TJclStringBuilderEnsureCapacity,false,0,'Capacity: SizeInt');
    DefineMethod('Clear',0,tkNone,nil,__TJclStringBuilderClear,false,0,'');
    DefineMethod('ToString',0,tkVariant,nil,__TJclStringBuilderToString,false,0,'');
    DefaultProperty := DefineProp('__Chars__',tkVariant,__GetTJclStringBuilder__Chars__,__SetTJclStringBuilder__Chars__,nil,false,1);
    DefineProp('Length',tkVariant,__GetTJclStringBuilderLength,__SetTJclStringBuilderLength,nil,false,0);
    DefineProp('Capacity',tkVariant,__GetTJclStringBuilderCapacity,__SetTJclStringBuilderCapacity,nil,false,0);
    DefineProp('MaxCapacity',tkVariant,__GetTJclStringBuilderMaxCapacity,nil,nil,false,0);
  end;
  With Scripter.DefineClass(TStringBuilder) do
  begin
  end;
  With Scripter.DefineClass(TJclTabSet) do
  begin
    DefineMethod('Create',0,tkClass,TJclTabSet,__TJclTabSetCreate,true,0,'');
    DefineMethod('Destroy',0,tkNone,nil,__TJclTabSetDestroy,false,0,'');
    DefineMethod('Clone',0,tkClass,TJclTabSet,__TJclTabSetClone,false,0,'');
    DefineMethod('NewReference',0,tkClass,TJclTabSet,__TJclTabSetNewReference,false,0,'');
    DefineMethod('Add',1,tkVariant,nil,__TJclTabSetAdd,false,0,'Column: SizeInt');
    DefineMethod('Delete',1,tkVariant,nil,__TJclTabSetDelete,false,0,'Column: SizeInt');
    DefineMethod('Expand',1,tkVariant,nil,__TJclTabSetExpand,false,0,'S: string');
    DefineMethod('OptimalFillInfo',4,tkNone,nil,__TJclTabSetOptimalFillInfo,false,0,'StartColumn: SizeInt; TargetColumn: SizeInt; TabsNeeded: SizeInt; SpacesNeeded: SizeInt').SetVarArgs([2,3]);
    DefineMethod('Optimize',1,tkVariant,nil,__TJclTabSetOptimize,false,0,'S: string');
    DefineMethod('StartColumn',0,tkVariant,nil,__TJclTabSetStartColumn,false,0,'');
    DefineMethod('TabFrom',1,tkVariant,nil,__TJclTabSetTabFrom,false,0,'Column: SizeInt');
    DefineMethod('UpdatePosition',1,tkVariant,nil,__TJclTabSetUpdatePosition,false,0,'S: string');
    DefineMethod('ToString',0,tkVariant,nil,__TJclTabSetToString,false,0,'');
    DefineMethod('FromString',1,tkClass,TJclTabSet,__TJclTabSetFromString,true,0,'S: string');
    DefineProp('ActualTabWidth',tkVariant,__GetTJclTabSetActualTabWidth,nil,nil,false,0);
    DefineProp('Count',tkVariant,__GetTJclTabSetCount,nil,nil,false,0);
    DefaultProperty := DefineProp('TabStops',tkVariant,__GetTJclTabSetTabStops,__SetTJclTabSetTabStops,nil,false,1);
    DefineProp('TabWidth',tkVariant,__GetTJclTabSetTabWidth,__SetTJclTabSetTabWidth,nil,false,0);
    DefineProp('ZeroBased',tkVariant,__GetTJclTabSetZeroBased,__SetTJclTabSetZeroBased,nil,false,0);
  end;
  With Scripter.DefineClass(NullReferenceException) do
  begin
    DefineMethod('Create',0,tkClass,NullReferenceException,__NullReferenceExceptionCreate,true,0,'');
  end;
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('StrIsAlpha',1,tkVariant,nil,__StrIsAlpha,false,0,'S: string');
    DefineMethod('StrIsAlphaNum',1,tkVariant,nil,__StrIsAlphaNum,false,0,'S: string');
    DefineMethod('StrIsAlphaNumUnderscore',1,tkVariant,nil,__StrIsAlphaNumUnderscore,false,0,'S: string');
    DefineMethod('StrConsistsOfNumberChars',1,tkVariant,nil,__StrConsistsOfNumberChars,false,0,'S: string');
    DefineMethod('StrIsDigit',1,tkVariant,nil,__StrIsDigit,false,0,'S: string');
    DefineMethod('StrSame',3,tkVariant,nil,__StrSame,false,1,'S1: string; S2: string; CaseSensitive: Boolean = False');
    DefineMethod('StrCenter',3,tkVariant,nil,__StrCenter,false,1,'S: string; L: SizeInt; C: Char = '' ''');
    DefineMethod('StrCharPosLower',2,tkVariant,nil,__StrCharPosLower,false,0,'S: string; CharPos: SizeInt');
    DefineMethod('StrCharPosUpper',2,tkVariant,nil,__StrCharPosUpper,false,0,'S: string; CharPos: SizeInt');
    DefineMethod('StrDoubleQuote',1,tkVariant,nil,__StrDoubleQuote,false,0,'S: string');
    DefineMethod('StrEnsureNoPrefix',2,tkVariant,nil,__StrEnsureNoPrefix,false,0,'Prefix: string; Text: string');
    DefineMethod('StrEnsureNoSuffix',2,tkVariant,nil,__StrEnsureNoSuffix,false,0,'Suffix: string; Text: string');
    DefineMethod('StrEnsurePrefix',2,tkVariant,nil,__StrEnsurePrefix,false,0,'Prefix: string; Text: string');
    DefineMethod('StrEnsureSuffix',2,tkVariant,nil,__StrEnsureSuffix,false,0,'Suffix: string; Text: string');
    DefineMethod('StrEscapedToString',1,tkVariant,nil,__StrEscapedToString,false,0,'S: string');
    DefineMethod('StrLower',1,tkVariant,nil,__StrLower,false,0,'S: string');
    DefineMethod('StrLowerInPlace',1,tkNone,nil,__StrLowerInPlace,false,0,'S: string').SetVarArgs([0]);
    DefineMethod('StrLowerBuff',1,tkNone,nil,__StrLowerBuff,false,0,'S: PChar');
    DefineMethod('StrMove',5,tkNone,nil,__StrMove,false,0,'Dest: string; Source: string; ToIndex: SizeInt; FromIndex: SizeInt; Count: SizeInt').SetVarArgs([0]);
    DefineMethod('StrPadLeft',3,tkVariant,nil,__StrPadLeft,false,1,'S: string; Len: SizeInt; C: Char = NativeSpace');
    DefineMethod('StrPadRight',3,tkVariant,nil,__StrPadRight,false,1,'S: string; Len: SizeInt; C: Char = NativeSpace');
    DefineMethod('StrProper',1,tkVariant,nil,__StrProper,false,0,'S: string');
    DefineMethod('StrProperBuff',1,tkNone,nil,__StrProperBuff,false,0,'S: PChar');
    DefineMethod('StrQuote',2,tkVariant,nil,__StrQuote,false,0,'S: string; C: Char');
    DefineMethod('StrReplace',4,tkNone,nil,__StrReplace,false,1,'S: string; Search: string; Replace: string; Flags: TReplaceFlags = []').SetVarArgs([0]);
    DefineMethod('StrReplaceChar',3,tkVariant,nil,__StrReplaceChar,false,0,'S: string; Source: Char; Replace: Char');
    DefineMethod('StrRepeat',2,tkVariant,nil,__StrRepeat,false,0,'S: string; Count: SizeInt');
    DefineMethod('StrRepeatLength',2,tkVariant,nil,__StrRepeatLength,false,0,'S: string; L: SizeInt');
    DefineMethod('StrReverse',1,tkVariant,nil,__StrReverse,false,0,'S: string');
    DefineMethod('StrReverseInPlace',1,tkNone,nil,__StrReverseInPlace,false,0,'S: string').SetVarArgs([0]);
    DefineMethod('StrSingleQuote',1,tkVariant,nil,__StrSingleQuote,false,0,'S: string');
    DefineMethod('StrStringToEscaped',1,tkVariant,nil,__StrStringToEscaped,false,0,'S: string');
    DefineMethod('StrStripNonNumberChars',1,tkVariant,nil,__StrStripNonNumberChars,false,0,'S: string');
    DefineMethod('StrToHex',1,tkVariant,nil,__StrToHex,false,0,'Source: string');
    DefineMethod('StrTrimCharLeft',2,tkVariant,nil,__StrTrimCharLeft,false,0,'S: string; C: Char');
    DefineMethod('StrTrimCharRight',2,tkVariant,nil,__StrTrimCharRight,false,0,'S: string; C: Char');
    DefineMethod('StrTrimQuotes',1,tkVariant,nil,__StrTrimQuotes,false,0,'S: string');
    DefineMethod('StrUpper',1,tkVariant,nil,__StrUpper,false,0,'S: string');
    DefineMethod('StrUpperInPlace',1,tkNone,nil,__StrUpperInPlace,false,0,'S: string').SetVarArgs([0]);
    DefineMethod('StrUpperBuff',1,tkNone,nil,__StrUpperBuff,false,0,'S: PChar');
    DefineMethod('StrAddRef',1,tkNone,nil,__StrAddRef,false,0,'S: string').SetVarArgs([0]);
    DefineMethod('StrDecRef',1,tkNone,nil,__StrDecRef,false,0,'S: string').SetVarArgs([0]);
    DefineMethod('StrLength',1,tkVariant,nil,__StrLength,false,0,'S: string');
    DefineMethod('StrRefCount',1,tkVariant,nil,__StrRefCount,false,0,'S: string');
    DefineMethod('StrCharCount',2,tkVariant,nil,__StrCharCount,false,0,'S: string; C: Char');
    DefineMethod('StrStrCount',2,tkVariant,nil,__StrStrCount,false,0,'S: string; SubS: string');
    DefineMethod('StrCompare',3,tkVariant,nil,__StrCompare,false,1,'S1: string; S2: string; CaseSensitive: Boolean = False');
    DefineMethod('StrCompareRange',5,tkVariant,nil,__StrCompareRange,false,1,'S1: string; S2: string; Index: SizeInt; Count: SizeInt; CaseSensitive: Boolean = True');
    DefineMethod('StrCompareRangeEx',5,tkVariant,nil,__StrCompareRangeEx,false,0,'S1: string; S2: string; Index: SizeInt; Count: SizeInt; CaseSensitive: Boolean');
    DefineMethod('StrFillChar',3,tkNone,nil,__StrFillChar,false,0,'S; Count: SizeInt; C: Char').SetVarArgs([0]);
    DefineMethod('StrRepeatChar',2,tkVariant,nil,__StrRepeatChar,false,0,'C: Char; Count: SizeInt');
    DefineMethod('StrFind',3,tkVariant,nil,__StrFind,false,1,'Substr: string; S: string; Index: SizeInt = 1');
    DefineMethod('StrILastPos',2,tkVariant,nil,__StrILastPos,false,0,'SubStr: string; S: string');
    DefineMethod('StrIPos',2,tkVariant,nil,__StrIPos,false,0,'SubStr: string; S: string');
    DefineMethod('StrLastPos',2,tkVariant,nil,__StrLastPos,false,0,'SubStr: string; S: string');
    DefineMethod('StrMatch',3,tkVariant,nil,__StrMatch,false,1,'Substr: string; S: string; Index: SizeInt = 1');
    DefineMethod('StrMatches',3,tkVariant,nil,__StrMatches,false,1,'Substr: string; S: string; Index: SizeInt = 1');
    DefineMethod('StrNIPos',3,tkVariant,nil,__StrNIPos,false,0,'S: string; SubStr: string; N: SizeInt');
    DefineMethod('StrNPos',3,tkVariant,nil,__StrNPos,false,0,'S: string; SubStr: string; N: SizeInt');
    DefineMethod('StrSearch',3,tkVariant,nil,__StrSearch,false,1,'Substr: string; S: string; Index: SizeInt = 1');
    DefineMethod('StrAfter',2,tkVariant,nil,__StrAfter,false,0,'SubStr: string; S: string');
    DefineMethod('StrBefore',2,tkVariant,nil,__StrBefore,false,0,'SubStr: string; S: string');
    DefineMethod('StrSplit',4,tkVariant,nil,__StrSplit,false,0,'SubStr: string; S: string; Left: string; Right: string').SetVarArgs([2,3]);
    DefineMethod('StrBetween',3,tkVariant,nil,__StrBetween,false,0,'S: string; Start: Char; Stop: Char');
    DefineMethod('StrChopRight',2,tkVariant,nil,__StrChopRight,false,0,'S: string; N: SizeInt');
    DefineMethod('StrLeft',2,tkVariant,nil,__StrLeft,false,0,'S: string; Count: SizeInt');
    DefineMethod('StrMid',3,tkVariant,nil,__StrMid,false,0,'S: string; Start: SizeInt; Count: SizeInt');
    DefineMethod('StrRestOf',2,tkVariant,nil,__StrRestOf,false,0,'S: string; N: SizeInt');
    DefineMethod('StrRight',2,tkVariant,nil,__StrRight,false,0,'S: string; Count: SizeInt');
    DefineMethod('CharEqualNoCase',2,tkVariant,nil,__CharEqualNoCase,false,0,'C1: Char; C2: Char');
    DefineMethod('CharIsAlpha',1,tkVariant,nil,__CharIsAlpha,false,0,'C: Char');
    DefineMethod('CharIsAlphaNum',1,tkVariant,nil,__CharIsAlphaNum,false,0,'C: Char');
    DefineMethod('CharIsBlank',1,tkVariant,nil,__CharIsBlank,false,0,'C: Char');
    DefineMethod('CharIsControl',1,tkVariant,nil,__CharIsControl,false,0,'C: Char');
    DefineMethod('CharIsDelete',1,tkVariant,nil,__CharIsDelete,false,0,'C: Char');
    DefineMethod('CharIsDigit',1,tkVariant,nil,__CharIsDigit,false,0,'C: Char');
    DefineMethod('CharIsFracDigit',1,tkVariant,nil,__CharIsFracDigit,false,0,'C: Char');
    DefineMethod('CharIsHexDigit',1,tkVariant,nil,__CharIsHexDigit,false,0,'C: Char');
    DefineMethod('CharIsLower',1,tkVariant,nil,__CharIsLower,false,0,'C: Char');
    DefineMethod('CharIsNumberChar',1,tkVariant,nil,__CharIsNumberChar,false,0,'C: Char');
    DefineMethod('CharIsNumber',1,tkVariant,nil,__CharIsNumber,false,0,'C: Char');
    DefineMethod('CharIsPrintable',1,tkVariant,nil,__CharIsPrintable,false,0,'C: Char');
    DefineMethod('CharIsPunctuation',1,tkVariant,nil,__CharIsPunctuation,false,0,'C: Char');
    DefineMethod('CharIsReturn',1,tkVariant,nil,__CharIsReturn,false,0,'C: Char');
    DefineMethod('CharIsSpace',1,tkVariant,nil,__CharIsSpace,false,0,'C: Char');
    DefineMethod('CharIsUpper',1,tkVariant,nil,__CharIsUpper,false,0,'C: Char');
    DefineMethod('CharIsValidIdentifierLetter',1,tkVariant,nil,__CharIsValidIdentifierLetter,false,0,'C: Char');
    DefineMethod('CharIsWhiteSpace',1,tkVariant,nil,__CharIsWhiteSpace,false,0,'C: Char');
    DefineMethod('CharIsWildcard',1,tkVariant,nil,__CharIsWildcard,false,0,'C: Char');
    DefineMethod('CharType',1,tkInteger,nil,__CharType,false,0,'C: Char');
    DefineMethod('CharHex',1,tkInteger,nil,__CharHex,false,0,'C: Char');
    DefineMethod('CharLower',1,tkVariant,nil,__CharLower,false,0,'C: Char');
    DefineMethod('CharUpper',1,tkVariant,nil,__CharUpper,false,0,'C: Char');
    DefineMethod('CharToggleCase',1,tkVariant,nil,__CharToggleCase,false,0,'C: Char');
    DefineMethod('CharPos',3,tkVariant,nil,__CharPos,false,1,'S: string; C: Char; Index: SizeInt = 1');
    DefineMethod('CharLastPos',3,tkVariant,nil,__CharLastPos,false,1,'S: string; C: Char; Index: SizeInt = 1');
    DefineMethod('CharIPos',3,tkVariant,nil,__CharIPos,false,1,'S: string; C: Char; Index: SizeInt = 1');
    DefineMethod('CharReplace',3,tkVariant,nil,__CharReplace,false,0,'S: string; Search: Char; Replace: Char').SetVarArgs([0]);
    DefineMethod('StringsToMultiSz',2,tkVariant,nil,__StringsToMultiSz,false,0,'Dest: PMultiSz; Source: TStrings').SetVarArgs([0]);
    DefineMethod('MultiSzToStrings',2,tkNone,nil,__MultiSzToStrings,false,0,'Dest: TStrings; Source: PMultiSz');
    DefineMethod('MultiSzLength',1,tkVariant,nil,__MultiSzLength,false,0,'Source: PMultiSz');
    DefineMethod('AllocateMultiSz',2,tkNone,nil,__AllocateMultiSz,false,0,'Dest: PMultiSz; Len: SizeInt').SetVarArgs([0]);
    DefineMethod('FreeMultiSz',1,tkNone,nil,__FreeMultiSz,false,0,'Dest: PMultiSz').SetVarArgs([0]);
    DefineMethod('MultiSzDup',1,tkVariant,nil,__MultiSzDup,false,0,'Source: PMultiSz');
    DefineMethod('AnsiStringsToAnsiMultiSz',2,tkVariant,nil,__AnsiStringsToAnsiMultiSz,false,0,'Dest: PAnsiMultiSz; Source: TAnsiStrings').SetVarArgs([0]);
    DefineMethod('AnsiMultiSzToAnsiStrings',2,tkNone,nil,__AnsiMultiSzToAnsiStrings,false,0,'Dest: TAnsiStrings; Source: PAnsiMultiSz');
    DefineMethod('AnsiMultiSzLength',1,tkVariant,nil,__AnsiMultiSzLength,false,0,'Source: PAnsiMultiSz');
    DefineMethod('AllocateAnsiMultiSz',2,tkNone,nil,__AllocateAnsiMultiSz,false,0,'Dest: PAnsiMultiSz; Len: SizeInt').SetVarArgs([0]);
    DefineMethod('FreeAnsiMultiSz',1,tkNone,nil,__FreeAnsiMultiSz,false,0,'Dest: PAnsiMultiSz').SetVarArgs([0]);
    DefineMethod('AnsiMultiSzDup',1,tkVariant,nil,__AnsiMultiSzDup,false,0,'Source: PAnsiMultiSz');
    DefineMethod('WideStringsToWideMultiSz',2,tkVariant,nil,__WideStringsToWideMultiSz,false,0,'Dest: PWideMultiSz; Source: TWideStrings').SetVarArgs([0]);
    DefineMethod('WideMultiSzToWideStrings',2,tkNone,nil,__WideMultiSzToWideStrings,false,0,'Dest: TWideStrings; Source: PWideMultiSz');
    DefineMethod('WideMultiSzLength',1,tkVariant,nil,__WideMultiSzLength,false,0,'Source: PWideMultiSz');
    DefineMethod('AllocateWideMultiSz',2,tkNone,nil,__AllocateWideMultiSz,false,0,'Dest: PWideMultiSz; Len: SizeInt').SetVarArgs([0]);
    DefineMethod('FreeWideMultiSz',1,tkNone,nil,__FreeWideMultiSz,false,0,'Dest: PWideMultiSz').SetVarArgs([0]);
    DefineMethod('WideMultiSzDup',1,tkVariant,nil,__WideMultiSzDup,false,0,'Source: PWideMultiSz');
    DefineMethod('StrIToStrings',4,tkNone,nil,__StrIToStrings,false,1,'S: string; Sep: string; List: TStrings; AllowEmptyString: Boolean = True');
    DefineMethod('StrToStrings',4,tkNone,nil,__StrToStrings,false,1,'S: string; Sep: string; List: TStrings; AllowEmptyString: Boolean = True');
    DefineMethod('TrimStrings',2,tkNone,nil,__TrimStrings,false,1,'List: TStrings; DeleteIfEmpty: Boolean = True');
    DefineMethod('TrimStringsRight',2,tkNone,nil,__TrimStringsRight,false,1,'List: TStrings; DeleteIfEmpty: Boolean = True');
    DefineMethod('TrimStringsLeft',2,tkNone,nil,__TrimStringsLeft,false,1,'List: TStrings; DeleteIfEmpty: Boolean = True');
    DefineMethod('AddStringToStrings',3,tkVariant,nil,__AddStringToStrings,false,0,'S: string; Strings: TStrings; Unique: Boolean');
    DefineMethod('FileToString',1,tkVariant,nil,__FileToString,false,0,'FileName: string');
    DefineMethod('StringToFile',3,tkNone,nil,__StringToFile,false,1,'FileName: string; Contents: AnsiString; Append: Boolean = False');
    DefineMethod('StrToken',2,tkVariant,nil,__StrToken,false,0,'S: string; Separator: Char').SetVarArgs([0]);
    DefineMethod('StrTokens',2,tkNone,nil,__StrTokens,false,0,'S: string; List: TStrings');
    DefineMethod('StrTokenToStrings',3,tkNone,nil,__StrTokenToStrings,false,0,'S: string; Separator: Char; List: TStrings');
    DefineMethod('StrWord',3,tkVariant,nil,__StrWord,false,0,'S: string; Index: SizeInt; Word: string').SetVarArgs([1,2]);
    DefineMethod('StrIdent',3,tkVariant,nil,__StrIdent,false,0,'S: string; Index: SizeInt; Ident: string').SetVarArgs([1,2]);
    DefineMethod('StrToFloatSafe',1,tkVariant,nil,__StrToFloatSafe,false,0,'S: string');
    DefineMethod('StrToIntSafe',1,tkInteger,nil,__StrToIntSafe,false,0,'S: string');
    DefineMethod('StrNormIndex',3,tkNone,nil,__StrNormIndex,false,0,'StrLen: SizeInt; Index: SizeInt; Count: SizeInt').SetVarArgs([1,2]);
    DefineMethod('ArrayOf',1,tkVariant,nil,__ArrayOf,false,0,'List: TStrings');
    DefineMethod('DotNetFormat',2,tkVariant,nil,__DotNetFormat,false,0,'Fmt: string; Arg0: Variant');
    DefineMethod('StrExpandTabs',1,tkVariant,nil,__StrExpandTabs,false,0,'S: string');
    DefineMethod('StrOptimizeTabs',1,tkVariant,nil,__StrOptimizeTabs,false,0,'S: string');
    DefineMethod('StrResetLength',1,tkNone,nil,__StrResetLength,false,0,'S: WideString').SetVarArgs([0]);
    DefineMethod('CompareNaturalStr',2,tkVariant,nil,__CompareNaturalStr,false,0,'S1: string; S2: string');
    DefineMethod('CompareNaturalText',2,tkVariant,nil,__CompareNaturalText,false,0,'S1: string; S2: string');
    DefineProp('StrCaseMapReady',tkVariant,__GetStrCaseMapReady,__SetStrCaseMapReady,nil,false,0);
    AddConstant('NativeNull',NativeNull);
    AddConstant('NativeSoh',NativeSoh);
    AddConstant('NativeStx',NativeStx);
    AddConstant('NativeEtx',NativeEtx);
    AddConstant('NativeEot',NativeEot);
    AddConstant('NativeEnq',NativeEnq);
    AddConstant('NativeAck',NativeAck);
    AddConstant('NativeBell',NativeBell);
    AddConstant('NativeBackspace',NativeBackspace);
    AddConstant('NativeTab',NativeTab);
    AddConstant('NativeLineFeed',NativeLineFeed);
    AddConstant('NativeVerticalTab',NativeVerticalTab);
    AddConstant('NativeFormFeed',NativeFormFeed);
    AddConstant('NativeCarriageReturn',NativeCarriageReturn);
    AddConstant('NativeCrLf',NativeCrLf);
    AddConstant('NativeSo',NativeSo);
    AddConstant('NativeSi',NativeSi);
    AddConstant('NativeDle',NativeDle);
    AddConstant('NativeDc1',NativeDc1);
    AddConstant('NativeDc2',NativeDc2);
    AddConstant('NativeDc3',NativeDc3);
    AddConstant('NativeDc4',NativeDc4);
    AddConstant('NativeNak',NativeNak);
    AddConstant('NativeSyn',NativeSyn);
    AddConstant('NativeEtb',NativeEtb);
    AddConstant('NativeCan',NativeCan);
    AddConstant('NativeEm',NativeEm);
    AddConstant('NativeEndOfFile',NativeEndOfFile);
    AddConstant('NativeEscape',NativeEscape);
    AddConstant('NativeFs',NativeFs);
    AddConstant('NativeGs',NativeGs);
    AddConstant('NativeRs',NativeRs);
    AddConstant('NativeUs',NativeUs);
    AddConstant('NativeSpace',NativeSpace);
    AddConstant('NativeComma',NativeComma);
    AddConstant('NativeBackslash',NativeBackslash);
    AddConstant('NativeForwardSlash',NativeForwardSlash);
    AddConstant('NativeDoubleQuote',NativeDoubleQuote);
    AddConstant('NativeSingleQuote',NativeSingleQuote);
    AddConstant('NativeLineBreak',NativeLineBreak);
    AddConstant('C1_UPPER',C1_UPPER);
    AddConstant('C1_LOWER',C1_LOWER);
    AddConstant('C1_DIGIT',C1_DIGIT);
    AddConstant('C1_SPACE',C1_SPACE);
    AddConstant('C1_PUNCT',C1_PUNCT);
    AddConstant('C1_CNTRL',C1_CNTRL);
    AddConstant('C1_BLANK',C1_BLANK);
    AddConstant('C1_XDIGIT',C1_XDIGIT);
    AddConstant('C1_ALPHA',C1_ALPHA);
    AddConstant('TabSetFormatting_SurroundStopsWithBrackets',TabSetFormatting_SurroundStopsWithBrackets);
    AddConstant('TabSetFormatting_EmptyBracketsIfNoStops',TabSetFormatting_EmptyBracketsIfNoStops);
    AddConstant('TabSetFormatting_NoTabStops',TabSetFormatting_NoTabStops);
    AddConstant('TabSetFormatting_NoTabWidth',TabSetFormatting_NoTabWidth);
    AddConstant('TabSetFormatting_AutoTabWidth',TabSetFormatting_AutoTabWidth);
    AddConstant('TabSetFormatting_Default',TabSetFormatting_Default);
    AddConstant('TabSetFormatting_AlwaysUseBrackets',TabSetFormatting_AlwaysUseBrackets);
    AddConstant('TabSetFormatting_Full',TabSetFormatting_Full);
    AddConstant('TabSetFormatting_StopsOnly',TabSetFormatting_StopsOnly);
    AddConstant('TabSetFormatting_TabWidthOnly',TabSetFormatting_TabWidthOnly);
    AddConstant('TabSetFormatting_StopsWithoutBracketsAndTabWidth',TabSetFormatting_StopsWithoutBracketsAndTabWidth);
    AddConstant('MaxStrCharCount',MaxStrCharCount);
    AddConstant('StrLoOffset',StrLoOffset);
    AddConstant('StrUpOffset',StrUpOffset);
    AddConstant('StrReOffset',StrReOffset);
    AddConstant('StrCaseMapSize',StrCaseMapSize);
  end;
end;

class function TatJclStringsLibrary.LibraryName: string;
begin
  result := 'JclStrings';
end;

initialization
  RegisterScripterLibrary(TatJclStringsLibrary, True);

{$WARNINGS ON}

end.


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
unit ap_FCommonUtils;

interface

uses
  Windows,
  Classes,
  Graphics,
  IniFiles,
  kbmMemTable,
  Dialogs,
  FCommonUtils,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatFCommonUtilsLibrary = class(TatScripterLibrary)
    procedure __StartWait(AMachine: TatVirtualMachine);
    procedure __StopWait(AMachine: TatVirtualMachine);
    procedure __MsgBoxErr(AMachine: TatVirtualMachine);
    procedure __MsgBoxWarn(AMachine: TatVirtualMachine);
    procedure __MsgBoxAsk(AMachine: TatVirtualMachine);
    procedure __MsgBoxAskButtons(AMachine: TatVirtualMachine);
    procedure __MsgBoxInfo(AMachine: TatVirtualMachine);
    procedure __IntToHexStr(AMachine: TatVirtualMachine);
    procedure __HexStrToInt(AMachine: TatVirtualMachine);
    procedure __ColorToHexStr(AMachine: TatVirtualMachine);
    procedure __HexStrToColor(AMachine: TatVirtualMachine);
    procedure __ColorToStr(AMachine: TatVirtualMachine);
    procedure __StrToColor(AMachine: TatVirtualMachine);
    procedure __IsValidHexStrColor(AMachine: TatVirtualMachine);
    procedure __LogicColorToStr(AMachine: TatVirtualMachine);
    procedure __StrToLogicColor(AMachine: TatVirtualMachine);
    procedure __IsValidStrLogicColor(AMachine: TatVirtualMachine);
    procedure __IsLogicColor(AMachine: TatVirtualMachine);
    procedure __ChangeDiakritic(AMachine: TatVirtualMachine);
    procedure __IsStringUpperCase(AMachine: TatVirtualMachine);
    procedure __IsStringLowerCase(AMachine: TatVirtualMachine);
    procedure __IsStringFirstUpperCase(AMachine: TatVirtualMachine);
    procedure __StringFirstUpperCase(AMachine: TatVirtualMachine);
    procedure __ChangeStringCase(AMachine: TatVirtualMachine);
    procedure __RemoveNonLicChar(AMachine: TatVirtualMachine);
    procedure __Replace(AMachine: TatVirtualMachine);
    procedure __QuotedStr(AMachine: TatVirtualMachine);
    procedure __Str1250ToANSI(AMachine: TatVirtualMachine);
    procedure __IsInteger(AMachine: TatVirtualMachine);
    procedure __IsFloat(AMachine: TatVirtualMachine);
    procedure __IsCurrencyInt(AMachine: TatVirtualMachine);
    procedure __IsDate(AMachine: TatVirtualMachine);
    procedure __IsBoolean(AMachine: TatVirtualMachine);
    procedure __IsDots(AMachine: TatVirtualMachine);
    procedure __StrToIntSafe(AMachine: TatVirtualMachine);
    procedure __StrToFloatSafe(AMachine: TatVirtualMachine);
    procedure __StrToBoolSafe(AMachine: TatVirtualMachine);
    procedure __StrToDateSafe(AMachine: TatVirtualMachine);
    procedure __DateToStrNorm(AMachine: TatVirtualMachine);
    procedure __CreateGUIDString(AMachine: TatVirtualMachine);
    procedure __NormalizeDateStr(AMachine: TatVirtualMachine);
    procedure __IsDigit(AMachine: TatVirtualMachine);
    procedure __ReplaceLatin2InvalidChar(AMachine: TatVirtualMachine);
    procedure __AddXMLStrValue(AMachine: TatVirtualMachine);
    procedure __ComparePrgVersion(AMachine: TatVirtualMachine);
    procedure __CompareVersion(AMachine: TatVirtualMachine);
    procedure __XMLStrToWindows1250(AMachine: TatVirtualMachine);
    procedure __XMLNormChars(AMachine: TatVirtualMachine);
    procedure __StrCharsetConversion(AMachine: TatVirtualMachine);
    procedure __TrimCharsLeft(AMachine: TatVirtualMachine);
    procedure __TrimCharsRight(AMachine: TatVirtualMachine);
    procedure __TrimChars(AMachine: TatVirtualMachine);
    procedure __RemoveChars(AMachine: TatVirtualMachine);
    procedure __ConCatStr(AMachine: TatVirtualMachine);
    procedure __AddStringLine(AMachine: TatVirtualMachine);
    procedure __GetStringLinesCount(AMachine: TatVirtualMachine);
    procedure __GetStringLine(AMachine: TatVirtualMachine);
    procedure __GetStringLineValue(AMachine: TatVirtualMachine);
    procedure __SaveStringToFile(AMachine: TatVirtualMachine);
    procedure __LoadStringFromFile(AMachine: TatVirtualMachine);
    procedure __GetSection(AMachine: TatVirtualMachine);
    procedure __SetSection(AMachine: TatVirtualMachine);
    procedure __DeleteStringLine(AMachine: TatVirtualMachine);
    procedure __GetStringLineName(AMachine: TatVirtualMachine);
    procedure __CountListItems(AMachine: TatVirtualMachine);
    procedure __GetListItem(AMachine: TatVirtualMachine);
    procedure __AddValueToList(AMachine: TatVirtualMachine);
    procedure __RemoveValueFromList(AMachine: TatVirtualMachine);
    procedure __TrimStringListText(AMachine: TatVirtualMachine);
    procedure __GetGroupWithString(AMachine: TatVirtualMachine);
    procedure __IsItemInList(AMachine: TatVirtualMachine);
    procedure __GetItemPosition(AMachine: TatVirtualMachine);
    procedure __DecodeIntegerList(AMachine: TatVirtualMachine);
    procedure __CheckValidIntegerList(AMachine: TatVirtualMachine);
    procedure __GetCsvFieldByName(AMachine: TatVirtualMachine);
    procedure __VarIsNE(AMachine: TatVirtualMachine);
    procedure __VarToDouble(AMachine: TatVirtualMachine);
    procedure __VarToInt(AMachine: TatVirtualMachine);
    procedure __VarToBool(AMachine: TatVirtualMachine);
    procedure __CorrectDateString(AMachine: TatVirtualMachine);
    procedure __CorrectNumberString(AMachine: TatVirtualMachine);
    procedure __NormalPath(AMachine: TatVirtualMachine);
    procedure __GetUniqueFileName(AMachine: TatVirtualMachine);
    procedure __SetValidFileName(AMachine: TatVirtualMachine);
    procedure __SetValidFileNameTrim(AMachine: TatVirtualMachine);
    procedure __DeleteFiles(AMachine: TatVirtualMachine);
    procedure __RoundAri(AMachine: TatVirtualMachine);
    procedure __RoundUp(AMachine: TatVirtualMachine);
    procedure __RoundDown(AMachine: TatVirtualMachine);
    procedure __RoundHalfAri(AMachine: TatVirtualMachine);
    procedure __RoundHalfUp(AMachine: TatVirtualMachine);
    procedure __MaxFloat(AMachine: TatVirtualMachine);
    procedure __MinFloat(AMachine: TatVirtualMachine);
    procedure __ShellOpen(AMachine: TatVirtualMachine);
    procedure __ShellExec(AMachine: TatVirtualMachine);
    procedure __ShellOpenPdf(AMachine: TatVirtualMachine);
    procedure __ShellOpenAndWait(AMachine: TatVirtualMachine);
    procedure __SendEmail(AMachine: TatVirtualMachine);
    procedure __GetPrgVersion(AMachine: TatVirtualMachine);
    procedure __GetWinUserName(AMachine: TatVirtualMachine);
    procedure __SearchFiles(AMachine: TatVirtualMachine);
    procedure __TryDeleteDirectory(AMachine: TatVirtualMachine);
    procedure __DefaultPrinter(AMachine: TatVirtualMachine);
    procedure __SaveStringsToIni(AMachine: TatVirtualMachine);
    procedure __LoadStringsFromIni(AMachine: TatVirtualMachine);
    procedure __SaveMemIni(AMachine: TatVirtualMachine);
    procedure __CheckRodneCisloDatNar(AMachine: TatVirtualMachine);
    procedure __CheckRodneCisloMsg(AMachine: TatVirtualMachine);
    procedure __CheckRodneCislo(AMachine: TatVirtualMachine);
    procedure __CheckICO(AMachine: TatVirtualMachine);
    procedure __CheckDIC(AMachine: TatVirtualMachine);
    procedure __CheckSkDIC(AMachine: TatVirtualMachine);
    procedure __CheckSkICDPH(AMachine: TatVirtualMachine);
    procedure __CheckBU(AMachine: TatVirtualMachine);
    procedure __CheckIBAN(AMachine: TatVirtualMachine);
    procedure __ZipFile(AMachine: TatVirtualMachine);
    procedure __UnzipFile(AMachine: TatVirtualMachine);
    procedure __GetZipFileComment(AMachine: TatVirtualMachine);
    procedure __LoadMemTableFromZip(AMachine: TatVirtualMachine);
    procedure __LoadTextFromZip(AMachine: TatVirtualMachine);
    procedure __NactiAdresuZARES(AMachine: TatVirtualMachine);
    procedure __NactiAdresuZARESD(AMachine: TatVirtualMachine);
    procedure __WebList2CSV(AMachine: TatVirtualMachine);
    procedure __IsConnectedToInternet(AMachine: TatVirtualMachine);
    procedure __GetHTTPDocument(AMachine: TatVirtualMachine);
    procedure __CheckVAT(AMachine: TatVirtualMachine);
    procedure __CheckPlatce(AMachine: TatVirtualMachine);
    procedure __CheckPlatceHttps(AMachine: TatVirtualMachine);
    procedure __CalcQRCodeText(AMachine: TatVirtualMachine);
    procedure __ConvertBU2IBAN(AMachine: TatVirtualMachine);
    procedure __FormatIBAN(AMachine: TatVirtualMachine);
    procedure __RCDatNar(AMachine: TatVirtualMachine);
    procedure __RCToSexCode(AMachine: TatVirtualMachine);
    procedure __Frac2Str(AMachine: TatVirtualMachine);
    procedure __IntPart2Str(AMachine: TatVirtualMachine);
    procedure __Cond(AMachine: TatVirtualMachine);
    procedure __Cond2(AMachine: TatVirtualMachine);
    procedure __Cond3(AMachine: TatVirtualMachine);
    procedure __Cond4(AMachine: TatVirtualMachine);
    procedure __Cond5(AMachine: TatVirtualMachine);
    procedure __CheckFormPosition(AMachine: TatVirtualMachine);
    procedure __GetFontTypes(AMachine: TatVirtualMachine);
    procedure __GetDPIForPDFRender(AMachine: TatVirtualMachine);
    procedure __IsEmailValid(AMachine: TatVirtualMachine);
    procedure __CheckIDDS(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;




implementation



procedure TatFCommonUtilsLibrary.__StartWait(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FCommonUtils.StartWait;
  end;
end;

procedure TatFCommonUtilsLibrary.__StopWait(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FCommonUtils.StopWait;
  end;
end;

procedure TatFCommonUtilsLibrary.__MsgBoxErr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.MsgBoxErr(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__MsgBoxWarn(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.MsgBoxWarn(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__MsgBoxAsk(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.MsgBoxAsk(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__MsgBoxAskButtons(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
5: AResult := Integer(FCommonUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4))));
6: AResult := Integer(FCommonUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5))));
7: AResult := Integer(FCommonUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6))));
8: AResult := Integer(FCommonUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6)),VarToInteger(GetInputArg(7))));
9: AResult := Integer(FCommonUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6)),VarToInteger(GetInputArg(7)),VarToInteger(GetInputArg(8))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__MsgBoxInfo(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.MsgBoxInfo(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IntToHexStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.IntToHexStr(VarToInteger(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__HexStrToInt(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.HexStrToInt(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ColorToHexStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.ColorToHexStr(TColor(VarToInteger(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__HexStrToColor(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.HexStrToColor(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ColorToStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.ColorToStr(TColor(VarToInteger(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__StrToColor(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.StrToColor(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsValidHexStrColor(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsValidHexStrColor(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__LogicColorToStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.LogicColorToStr(TColor(VarToInteger(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__StrToLogicColor(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.StrToLogicColor(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsValidStrLogicColor(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsValidStrLogicColor(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsLogicColor(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsLogicColor(TColor(VarToInteger(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ChangeDiakritic(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.ChangeDiakritic(VarToStr(GetInputArg(0))[1]);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsStringUpperCase(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsStringUpperCase(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsStringLowerCase(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsStringLowerCase(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsStringFirstUpperCase(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsStringFirstUpperCase(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__StringFirstUpperCase(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.StringFirstUpperCase(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ChangeStringCase(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.ChangeStringCase(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RemoveNonLicChar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.RemoveNonLicChar(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__Replace(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
3: AResult := string(FCommonUtils.Replace(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
4: AResult := string(FCommonUtils.Replace(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),GetInputArg(3)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__QuotedStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.QuotedStr(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__Str1250ToANSI(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.Str1250ToANSI(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsInteger(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsInteger(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsFloat(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsFloat(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsCurrencyInt(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsCurrencyInt(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsDate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsDate(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsBoolean(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsBoolean(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsDots(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsDots(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__StrToIntSafe(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.StrToIntSafe(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__StrToFloatSafe(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.StrToFloatSafe(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__StrToBoolSafe(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.StrToBoolSafe(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__StrToDateSafe(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.StrToDateSafe(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__DateToStrNorm(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.DateToStrNorm(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CreateGUIDString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.CreateGUIDString);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__NormalizeDateStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.NormalizeDateStr(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsDigit(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsDigit(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ReplaceLatin2InvalidChar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.ReplaceLatin2InvalidChar(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__AddXMLStrValue(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    FCommonUtils.AddXMLStrValue(Param0,VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatFCommonUtilsLibrary.__ComparePrgVersion(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.ComparePrgVersion(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),GetInputArg(3),GetInputArg(4)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CompareVersion(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.CompareVersion(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__XMLStrToWindows1250(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.XMLStrToWindows1250(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__XMLNormChars(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.XMLNormChars(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__StrCharsetConversion(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.StrCharsetConversion(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__TrimCharsLeft(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.TrimCharsLeft(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__TrimCharsRight(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.TrimCharsRight(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__TrimChars(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.TrimChars(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RemoveChars(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.RemoveChars(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ConCatStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := string(FCommonUtils.ConCatStr(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
3: AResult := string(FCommonUtils.ConCatStr(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__AddStringLine(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    FCommonUtils.AddStringLine(Param0,VarToStr(GetInputArg(1)));
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatFCommonUtilsLibrary.__GetStringLinesCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.GetStringLinesCount(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetStringLine(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FCommonUtils.GetStringLine(VarToStr(GetInputArg(0))));
2: AResult := string(FCommonUtils.GetStringLine(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetStringLineValue(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.GetStringLineValue(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__SaveStringToFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FCommonUtils.SaveStringToFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
  end;
end;

procedure TatFCommonUtilsLibrary.__LoadStringFromFile(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.LoadStringFromFile(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetSection(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.GetSection(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__SetSection(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.SetSection(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__DeleteStringLine(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FCommonUtils.DeleteStringLine(VarToStr(GetInputArg(0))));
2: AResult := string(FCommonUtils.DeleteStringLine(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetStringLineName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := string(FCommonUtils.GetStringLineName(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
3: AResult := string(FCommonUtils.GetStringLineName(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CountListItems(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.CountListItems(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetListItem(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.GetListItem(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__AddValueToList(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := string(FCommonUtils.AddValueToList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
3: AResult := string(FCommonUtils.AddValueToList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RemoveValueFromList(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.RemoveValueFromList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__TrimStringListText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.TrimStringListText(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetGroupWithString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.GetGroupWithString(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsItemInList(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsItemInList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetItemPosition(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.GetItemPosition(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__DecodeIntegerList(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.DecodeIntegerList(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckValidIntegerList(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.CheckValidIntegerList(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetCsvFieldByName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.GetCsvFieldByName(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__VarIsNE(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.VarIsNE(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__VarToDouble(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.VarToDouble(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__VarToInt(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.VarToInt(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__VarToBool(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.VarToBool(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CorrectDateString(AMachine: TatVirtualMachine);
  var
  Param0: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
AResult := FCommonUtils.CorrectDateString(Param0);
    ReturnOutputArg(AResult);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatFCommonUtilsLibrary.__CorrectNumberString(AMachine: TatVirtualMachine);
  var
  Param0: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
case InputArgCount of
1: AResult := FCommonUtils.CorrectNumberString(Param0);
2: AResult := FCommonUtils.CorrectNumberString(Param0,GetInputArg(1));
end;
    ReturnOutputArg(AResult);
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatFCommonUtilsLibrary.__NormalPath(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.NormalPath(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetUniqueFileName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.GetUniqueFileName(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__SetValidFileName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.SetValidFileName(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__SetValidFileNameTrim(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.SetValidFileNameTrim(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__DeleteFiles(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FCommonUtils.DeleteFiles(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
  end;
end;

procedure TatFCommonUtilsLibrary.__RoundAri(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.RoundAri(GetInputArg(0));
2: AResult := FCommonUtils.RoundAri(GetInputArg(0),VarToInteger(GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RoundUp(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.RoundUp(GetInputArg(0));
2: AResult := FCommonUtils.RoundUp(GetInputArg(0),VarToInteger(GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RoundDown(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.RoundDown(GetInputArg(0));
2: AResult := FCommonUtils.RoundDown(GetInputArg(0),VarToInteger(GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RoundHalfAri(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.RoundHalfAri(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RoundHalfUp(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.RoundHalfUp(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__MaxFloat(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.MaxFloat(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__MinFloat(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.MinFloat(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ShellOpen(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FCommonUtils.ShellOpen(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFCommonUtilsLibrary.__ShellExec(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FCommonUtils.ShellExec(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
  end;
end;

procedure TatFCommonUtilsLibrary.__ShellOpenPdf(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.ShellOpenPdf(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),TShellOpenCmdType(VarToInteger(GetInputArg(2))),VarToStr(GetInputArg(3)),GetInputArg(4));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ShellOpenAndWait(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.ShellOpenAndWait(VarToStr(GetInputArg(0)));
2: AResult := FCommonUtils.ShellOpenAndWait(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := FCommonUtils.ShellOpenAndWait(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__SendEmail(AMachine: TatVirtualMachine);
  var
  Param5: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param5 := VarToStr(GetInputArg(5));
AResult := FCommonUtils.SendEmail(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),TStringList(VarToObject(GetInputArg(3))),GetInputArg(4),Param5);
    ReturnOutputArg(AResult);
    SetInputArg(5,string(Param5));
  end;
end;

procedure TatFCommonUtilsLibrary.__GetPrgVersion(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := string(FCommonUtils.GetPrgVersion);
1: AResult := string(FCommonUtils.GetPrgVersion(VarToStr(GetInputArg(0))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetWinUserName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.GetWinUserName);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__SearchFiles(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.SearchFiles(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__TryDeleteDirectory(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.TryDeleteDirectory(VarToStr(GetInputArg(0)));
2: AResult := FCommonUtils.TryDeleteDirectory(VarToStr(GetInputArg(0)),GetInputArg(1));
3: AResult := FCommonUtils.TryDeleteDirectory(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__DefaultPrinter(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.DefaultPrinter);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__SaveStringsToIni(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FCommonUtils.SaveStringsToIni(TStrings(VarToObject(GetInputArg(0))),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)));
  end;
end;

procedure TatFCommonUtilsLibrary.__LoadStringsFromIni(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FCommonUtils.LoadStringsFromIni(TStrings(VarToObject(GetInputArg(0))),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)));
  end;
end;

procedure TatFCommonUtilsLibrary.__SaveMemIni(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.SaveMemIni(TMemIniFile(VarToObject(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckRodneCisloDatNar(AMachine: TatVirtualMachine);
  var
  Param3: TDateTime;
  Param4: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param3 := GetInputArg(3);
Param4 := VarToStr(GetInputArg(4));
AResult := FCommonUtils.CheckRodneCisloDatNar(VarToStr(GetInputArg(0)),GetInputArg(1),GetInputArg(2),Param3,Param4);
    ReturnOutputArg(AResult);
    SetInputArg(3,Param3);
    SetInputArg(4,string(Param4));
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckRodneCisloMsg(AMachine: TatVirtualMachine);
  var
  Param1: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param1 := VarToStr(GetInputArg(1));
case InputArgCount of
2: AResult := FCommonUtils.CheckRodneCisloMsg(VarToStr(GetInputArg(0)),Param1);
3: AResult := FCommonUtils.CheckRodneCisloMsg(VarToStr(GetInputArg(0)),Param1,GetInputArg(2));
4: AResult := FCommonUtils.CheckRodneCisloMsg(VarToStr(GetInputArg(0)),Param1,GetInputArg(2),GetInputArg(3));
end;
    ReturnOutputArg(AResult);
    SetInputArg(1,string(Param1));
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckRodneCislo(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.CheckRodneCislo(VarToStr(GetInputArg(0)));
2: AResult := FCommonUtils.CheckRodneCislo(VarToStr(GetInputArg(0)),GetInputArg(1));
3: AResult := FCommonUtils.CheckRodneCislo(VarToStr(GetInputArg(0)),GetInputArg(1),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckICO(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.CheckICO(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckDIC(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.CheckDIC(VarToStr(GetInputArg(0)));
2: AResult := FCommonUtils.CheckDIC(VarToStr(GetInputArg(0)),GetInputArg(1));
3: AResult := FCommonUtils.CheckDIC(VarToStr(GetInputArg(0)),GetInputArg(1),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckSkDIC(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.CheckSkDIC(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckSkICDPH(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.CheckSkICDPH(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckBU(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.CheckBU(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckIBAN(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.CheckIBAN(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ZipFile(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
3: AResult := FCommonUtils.ZipFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
4: AResult := FCommonUtils.ZipFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__UnzipFile(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := FCommonUtils.UnzipFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := FCommonUtils.UnzipFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetZipFileComment(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.GetZipFileComment(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__LoadMemTableFromZip(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := FCommonUtils.LoadMemTableFromZip(TkbmMemTable(VarToObject(GetInputArg(0))),VarToStr(GetInputArg(1)));
3: AResult := FCommonUtils.LoadMemTableFromZip(TkbmMemTable(VarToObject(GetInputArg(0))),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__LoadTextFromZip(AMachine: TatVirtualMachine);
  var
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
case InputArgCount of
3: AResult := FCommonUtils.LoadTextFromZip(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2);
4: AResult := FCommonUtils.LoadTextFromZip(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2,VarToStr(GetInputArg(3)));
end;
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatFCommonUtilsLibrary.__NactiAdresuZARES(AMachine: TatVirtualMachine);
  var
  Param3: string;
  Param4: string;
  Param5: string;
  Param6: string;
  Param7: string;
  Param8: string;
  Param9: string;
  Param10: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param3 := VarToStr(GetInputArg(3));
Param4 := VarToStr(GetInputArg(4));
Param5 := VarToStr(GetInputArg(5));
Param6 := VarToStr(GetInputArg(6));
Param7 := VarToStr(GetInputArg(7));
Param8 := VarToStr(GetInputArg(8));
Param9 := VarToStr(GetInputArg(9));
Param10 := VarToStr(GetInputArg(10));
AResult := FCommonUtils.NactiAdresuZARES(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),Param3,Param4,Param5,Param6,Param7,Param8,Param9,Param10);
    ReturnOutputArg(AResult);
    SetInputArg(3,string(Param3));
    SetInputArg(4,string(Param4));
    SetInputArg(5,string(Param5));
    SetInputArg(6,string(Param6));
    SetInputArg(7,string(Param7));
    SetInputArg(8,string(Param8));
    SetInputArg(9,string(Param9));
    SetInputArg(10,string(Param10));
  end;
end;

procedure TatFCommonUtilsLibrary.__NactiAdresuZARESD(AMachine: TatVirtualMachine);
  var
  Param3: string;
  Param4: string;
  Param5: string;
  Param6: string;
  Param7: string;
  Param8: string;
  Param9: string;
  Param10: string;
  Param11: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param3 := VarToStr(GetInputArg(3));
Param4 := VarToStr(GetInputArg(4));
Param5 := VarToStr(GetInputArg(5));
Param6 := VarToStr(GetInputArg(6));
Param7 := VarToStr(GetInputArg(7));
Param8 := VarToStr(GetInputArg(8));
Param9 := VarToStr(GetInputArg(9));
Param10 := VarToStr(GetInputArg(10));
Param11 := VarToStr(GetInputArg(11));
AResult := FCommonUtils.NactiAdresuZARESD(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),Param3,Param4,Param5,Param6,Param7,Param8,Param9,Param10,Param11);
    ReturnOutputArg(AResult);
    SetInputArg(3,string(Param3));
    SetInputArg(4,string(Param4));
    SetInputArg(5,string(Param5));
    SetInputArg(6,string(Param6));
    SetInputArg(7,string(Param7));
    SetInputArg(8,string(Param8));
    SetInputArg(9,string(Param9));
    SetInputArg(10,string(Param10));
    SetInputArg(11,string(Param11));
  end;
end;

procedure TatFCommonUtilsLibrary.__WebList2CSV(AMachine: TatVirtualMachine);
  var
  Param4: string;
  Param5: string;
  Param6: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param4 := VarToStr(GetInputArg(4));
Param5 := VarToStr(GetInputArg(5));
Param6 := VarToStr(GetInputArg(6));
AResult := FCommonUtils.WebList2CSV(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),Param4,Param5,Param6);
    ReturnOutputArg(AResult);
    SetInputArg(4,string(Param4));
    SetInputArg(5,string(Param5));
    SetInputArg(6,string(Param6));
  end;
end;

procedure TatFCommonUtilsLibrary.__IsConnectedToInternet(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.IsConnectedToInternet;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetHTTPDocument(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FCommonUtils.GetHTTPDocument(VarToStr(GetInputArg(0))));
2: AResult := string(FCommonUtils.GetHTTPDocument(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
3: AResult := string(FCommonUtils.GetHTTPDocument(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckVAT(AMachine: TatVirtualMachine);
  var
  Param4: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param4 := VarToStr(GetInputArg(4));
AResult := Integer(FCommonUtils.CheckVAT(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),Param4));
    ReturnOutputArg(AResult);
    SetInputArg(4,string(Param4));
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckPlatce(AMachine: TatVirtualMachine);
  var
  Param3: string;
  Param4: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param3 := VarToStr(GetInputArg(3));
Param4 := VarToStr(GetInputArg(4));
AResult := Integer(FCommonUtils.CheckPlatce(GetInputArg(0),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),Param3,Param4));
    ReturnOutputArg(AResult);
    SetInputArg(3,string(Param3));
    SetInputArg(4,string(Param4));
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckPlatceHttps(AMachine: TatVirtualMachine);
  var
  Param3: string;
  Param4: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param3 := VarToStr(GetInputArg(3));
Param4 := VarToStr(GetInputArg(4));
AResult := Integer(FCommonUtils.CheckPlatceHttps(GetInputArg(0),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),Param3,Param4));
    ReturnOutputArg(AResult);
    SetInputArg(3,string(Param3));
    SetInputArg(4,string(Param4));
  end;
end;

procedure TatFCommonUtilsLibrary.__CalcQRCodeText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.CalcQRCodeText(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__ConvertBU2IBAN(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.ConvertBU2IBAN(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__FormatIBAN(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FCommonUtils.FormatIBAN(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RCDatNar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.RCDatNar(VarToStr(GetInputArg(0)));
2: AResult := FCommonUtils.RCDatNar(VarToStr(GetInputArg(0)),GetInputArg(1));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__RCToSexCode(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FCommonUtils.RCToSexCode(VarToStr(GetInputArg(0))));
2: AResult := string(FCommonUtils.RCToSexCode(VarToStr(GetInputArg(0)),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__Frac2Str(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FCommonUtils.Frac2Str(GetInputArg(0)));
2: AResult := string(FCommonUtils.Frac2Str(GetInputArg(0),VarToInteger(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IntPart2Str(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FCommonUtils.IntPart2Str(GetInputArg(0)));
2: AResult := string(FCommonUtils.IntPart2Str(GetInputArg(0),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__Cond(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.Cond(GetInputArg(0),GetInputArg(1),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__Cond2(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.Cond2(GetInputArg(0),GetInputArg(1),GetInputArg(2),GetInputArg(3),GetInputArg(4));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__Cond3(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.Cond3(GetInputArg(0),GetInputArg(1),GetInputArg(2),GetInputArg(3),GetInputArg(4),GetInputArg(5),GetInputArg(6));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__Cond4(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.Cond4(GetInputArg(0),GetInputArg(1),GetInputArg(2),GetInputArg(3),GetInputArg(4),GetInputArg(5),GetInputArg(6),GetInputArg(7),GetInputArg(8));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__Cond5(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.Cond5(GetInputArg(0),GetInputArg(1),GetInputArg(2),GetInputArg(3),GetInputArg(4),GetInputArg(5),GetInputArg(6),GetInputArg(7),GetInputArg(8),GetInputArg(9),GetInputArg(10));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckFormPosition(AMachine: TatVirtualMachine);
  var
  Param0: integer;
  Param1: integer;
begin
  with AMachine do
  begin
Param0 := VarToInteger(GetInputArg(0));
Param1 := VarToInteger(GetInputArg(1));
    FCommonUtils.CheckFormPosition(Param0,Param1,VarToInteger(GetInputArg(2)));
    SetInputArg(0,Integer(Param0));
    SetInputArg(1,Integer(Param1));
  end;
end;

procedure TatFCommonUtilsLibrary.__GetFontTypes(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.GetFontTypes);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__GetDPIForPDFRender(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FCommonUtils.GetDPIForPDFRender);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__IsEmailValid(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := FCommonUtils.IsEmailValid(VarToStr(GetInputArg(0)));
2: AResult := FCommonUtils.IsEmailValid(VarToStr(GetInputArg(0)),GetInputArg(1));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.__CheckIDDS(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FCommonUtils.CheckIDDS(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFCommonUtilsLibrary.Init;
begin
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('StartWait',0,tkNone,nil,__StartWait,false,0,'');
    DefineMethod('StopWait',0,tkNone,nil,__StopWait,false,0,'');
    DefineMethod('MsgBoxErr',3,tkInteger,nil,__MsgBoxErr,false,0,'ACaption: string; AMsg: string; AFlags: longint');
    DefineMethod('MsgBoxWarn',3,tkInteger,nil,__MsgBoxWarn,false,0,'ACaption: string; AMsg: string; AFlags: longint');
    DefineMethod('MsgBoxAsk',3,tkInteger,nil,__MsgBoxAsk,false,0,'ACaption: string; AMsg: string; AFlags: longint');
    DefineMethod('MsgBoxAskButtons',9,tkInteger,nil,__MsgBoxAskButtons,false,4,'ACaption: string; AMsg: string; ABtn1Text: string; ABtn2Text: string; ABtn3Text: string; ADefaultBtn: Integer = 1; ABtnWidth: Integer = 100; ADlgType: integer = 3; ADlgWidth: Integer = 0');
    DefineMethod('MsgBoxInfo',3,tkInteger,nil,__MsgBoxInfo,false,0,'ACaption: string; AMsg: string; AFlags: longint');
    DefineMethod('IntToHexStr',1,tkVariant,nil,__IntToHexStr,false,0,'AValue: integer');
    DefineMethod('HexStrToInt',1,tkInteger,nil,__HexStrToInt,false,0,'AValue: string');
    DefineMethod('ColorToHexStr',1,tkVariant,nil,__ColorToHexStr,false,0,'AColor: TColor');
    DefineMethod('HexStrToColor',1,tkEnumeration,nil,__HexStrToColor,false,0,'AStr: string');
    DefineMethod('ColorToStr',1,tkVariant,nil,__ColorToStr,false,0,'AColor: TColor');
    DefineMethod('StrToColor',1,tkEnumeration,nil,__StrToColor,false,0,'AStr: string');
    DefineMethod('IsValidHexStrColor',1,tkVariant,nil,__IsValidHexStrColor,false,0,'AStr: string');
    DefineMethod('LogicColorToStr',1,tkVariant,nil,__LogicColorToStr,false,0,'AColor: TColor');
    DefineMethod('StrToLogicColor',1,tkEnumeration,nil,__StrToLogicColor,false,0,'AStr: string');
    DefineMethod('IsValidStrLogicColor',1,tkVariant,nil,__IsValidStrLogicColor,false,0,'AStr: string');
    DefineMethod('IsLogicColor',1,tkVariant,nil,__IsLogicColor,false,0,'AColor: TColor');
    DefineMethod('ChangeDiakritic',1,tkVariant,nil,__ChangeDiakritic,false,0,'c: char');
    DefineMethod('IsStringUpperCase',1,tkVariant,nil,__IsStringUpperCase,false,0,'s: string');
    DefineMethod('IsStringLowerCase',1,tkVariant,nil,__IsStringLowerCase,false,0,'s: string');
    DefineMethod('IsStringFirstUpperCase',1,tkVariant,nil,__IsStringFirstUpperCase,false,0,'s: string');
    DefineMethod('StringFirstUpperCase',1,tkVariant,nil,__StringFirstUpperCase,false,0,'s: string');
    DefineMethod('ChangeStringCase',1,tkVariant,nil,__ChangeStringCase,false,0,'s: string');
    DefineMethod('RemoveNonLicChar',1,tkVariant,nil,__RemoveNonLicChar,false,0,'s: string');
    DefineMethod('Replace',4,tkVariant,nil,__Replace,false,1,'ASearch: string; AStr: string; AReplace: string; AIgnoreCase: boolean = FALSE');
    DefineMethod('QuotedStr',1,tkVariant,nil,__QuotedStr,false,0,'AString: string');
    DefineMethod('Str1250ToANSI',1,tkVariant,nil,__Str1250ToANSI,false,0,'AStr: string');
    DefineMethod('IsInteger',1,tkVariant,nil,__IsInteger,false,0,'AStr: string');
    DefineMethod('IsFloat',1,tkVariant,nil,__IsFloat,false,0,'AStr: string');
    DefineMethod('IsCurrencyInt',1,tkVariant,nil,__IsCurrencyInt,false,0,'AStr: string');
    DefineMethod('IsDate',1,tkVariant,nil,__IsDate,false,0,'AStr: string');
    DefineMethod('IsBoolean',1,tkVariant,nil,__IsBoolean,false,0,'AStr: string');
    DefineMethod('IsDots',1,tkVariant,nil,__IsDots,false,0,'s: string');
    DefineMethod('StrToIntSafe',1,tkInteger,nil,__StrToIntSafe,false,0,'AStr: string');
    DefineMethod('StrToFloatSafe',1,tkVariant,nil,__StrToFloatSafe,false,0,'AStr: string');
    DefineMethod('StrToBoolSafe',1,tkVariant,nil,__StrToBoolSafe,false,0,'AStr: string');
    DefineMethod('StrToDateSafe',1,tkVariant,nil,__StrToDateSafe,false,0,'AStr: string');
    DefineMethod('DateToStrNorm',1,tkVariant,nil,__DateToStrNorm,false,0,'ADate: TDateTime');
    DefineMethod('CreateGUIDString',0,tkVariant,nil,__CreateGUIDString,false,0,'');
    DefineMethod('NormalizeDateStr',1,tkVariant,nil,__NormalizeDateStr,false,0,'AStrDate: string');
    DefineMethod('IsDigit',1,tkVariant,nil,__IsDigit,false,0,'AStr: string');
    DefineMethod('ReplaceLatin2InvalidChar',1,tkVariant,nil,__ReplaceLatin2InvalidChar,false,0,'AStr: string');
    DefineMethod('AddXMLStrValue',3,tkNone,nil,__AddXMLStrValue,false,0,'ADoc: string; AKey: string; AValue: string').SetVarArgs([0]);
    DefineMethod('ComparePrgVersion',5,tkInteger,nil,__ComparePrgVersion,false,0,'ver1: string; ver2: string; major: Boolean; minor: Boolean; release: Boolean');
    DefineMethod('CompareVersion',2,tkInteger,nil,__CompareVersion,false,0,'ver1: string; ver2: string');
    DefineMethod('XMLStrToWindows1250',1,tkVariant,nil,__XMLStrToWindows1250,false,0,'AFileOrStr: string');
    DefineMethod('XMLNormChars',1,tkVariant,nil,__XMLNormChars,false,0,'AXmlStr: string');
    DefineMethod('StrCharsetConversion',3,tkVariant,nil,__StrCharsetConversion,false,0,'AStr: string; ACodePageFrom: integer; ACodePageTo: integer');
    DefineMethod('TrimCharsLeft',2,tkVariant,nil,__TrimCharsLeft,false,0,'AStr: string; AChars: string');
    DefineMethod('TrimCharsRight',2,tkVariant,nil,__TrimCharsRight,false,0,'AStr: string; AChars: string');
    DefineMethod('TrimChars',2,tkVariant,nil,__TrimChars,false,0,'AStr: string; AChars: string');
    DefineMethod('RemoveChars',2,tkVariant,nil,__RemoveChars,false,0,'AStr: string; AChars: string');
    DefineMethod('ConCatStr',3,tkVariant,nil,__ConCatStr,false,1,'AStr1: string; AStr2: string; ASeparator: string = '',''');
    DefineMethod('AddStringLine',2,tkNone,nil,__AddStringLine,false,0,'AStr: string; AAddedStrLine: string').SetVarArgs([0]);
    DefineMethod('GetStringLinesCount',1,tkInteger,nil,__GetStringLinesCount,false,0,'AStr: string');
    DefineMethod('GetStringLine',2,tkVariant,nil,__GetStringLine,false,1,'AStr: string; ALineNo: integer = 0');
    DefineMethod('GetStringLineValue',2,tkVariant,nil,__GetStringLineValue,false,0,'AStr: string; AValueName: string');
    DefineMethod('SaveStringToFile',2,tkNone,nil,__SaveStringToFile,false,0,'AStr: string; AFileName: string');
    DefineMethod('LoadStringFromFile',1,tkVariant,nil,__LoadStringFromFile,false,0,'AFileName: string');
    DefineMethod('GetSection',2,tkVariant,nil,__GetSection,false,0,'AData: string; ASection: string');
    DefineMethod('SetSection',3,tkVariant,nil,__SetSection,false,0,'AMainData: string; ASection: string; ASectionData: string');
    DefineMethod('DeleteStringLine',2,tkVariant,nil,__DeleteStringLine,false,1,'AStr: string; ALineNo: integer = 0');
    DefineMethod('GetStringLineName',3,tkVariant,nil,__GetStringLineName,false,1,'AStr: string; AValue: string; CaseSensitive: Boolean = True');
    DefineMethod('CountListItems',1,tkInteger,nil,__CountListItems,false,0,'ACSVList: string');
    DefineMethod('GetListItem',2,tkVariant,nil,__GetListItem,false,0,'ACSVList: string; AItemIndex: integer');
    DefineMethod('AddValueToList',3,tkVariant,nil,__AddValueToList,false,1,'ACSVList: string; AStringItem: string; AAddIfExist: boolean = FALSE');
    DefineMethod('RemoveValueFromList',2,tkVariant,nil,__RemoveValueFromList,false,0,'ACSVList: string; AStringItem: string');
    DefineMethod('TrimStringListText',1,tkVariant,nil,__TrimStringListText,false,0,'AStringListText: string');
    DefineMethod('GetGroupWithString',2,tkVariant,nil,__GetGroupWithString,false,0,'AGroupCSVList: string; AStringItem: string');
    DefineMethod('IsItemInList',2,tkVariant,nil,__IsItemInList,false,0,'ACSVList: string; AStringItem: string');
    DefineMethod('GetItemPosition',2,tkInteger,nil,__GetItemPosition,false,0,'ACSVList: string; AStringItem: string');
    DefineMethod('DecodeIntegerList',2,tkVariant,nil,__DecodeIntegerList,false,0,'ACSVList: string; ALimit: integer');
    DefineMethod('CheckValidIntegerList',1,tkVariant,nil,__CheckValidIntegerList,false,0,'ACSVList: string');
    DefineMethod('GetCsvFieldByName',3,tkVariant,nil,__GetCsvFieldByName,false,0,'ACsvString: string; AFieldName: string; ARecNo: integer');
    DefineMethod('VarIsNE',1,tkVariant,nil,__VarIsNE,false,0,'Value: Variant');
    DefineMethod('VarToDouble',1,tkVariant,nil,__VarToDouble,false,0,'Value: Variant');
    DefineMethod('VarToInt',1,tkInteger,nil,__VarToInt,false,0,'Value: Variant');
    DefineMethod('VarToBool',1,tkVariant,nil,__VarToBool,false,0,'Value: Variant');
    DefineMethod('CorrectDateString',1,tkVariant,nil,__CorrectDateString,false,0,'ADat: string').SetVarArgs([0]);
    DefineMethod('CorrectNumberString',2,tkVariant,nil,__CorrectNumberString,false,1,'ANum: string; AInteger: boolean = FALSE').SetVarArgs([0]);
    DefineMethod('NormalPath',1,tkVariant,nil,__NormalPath,false,0,'APathStr: string');
    DefineMethod('GetUniqueFileName',2,tkVariant,nil,__GetUniqueFileName,false,0,'APath: string; AFileName: string');
    DefineMethod('SetValidFileName',1,tkVariant,nil,__SetValidFileName,false,0,'AFileName: string');
    DefineMethod('SetValidFileNameTrim',1,tkVariant,nil,__SetValidFileNameTrim,false,0,'AFileName: string');
    DefineMethod('DeleteFiles',2,tkNone,nil,__DeleteFiles,false,0,'APath: string; AFileSpec: string');
    DefineMethod('RoundAri',2,tkVariant,nil,__RoundAri,false,1,'AValue: extended; ADigit: integer = -2');
    DefineMethod('RoundUp',2,tkVariant,nil,__RoundUp,false,1,'AValue: extended; ADigit: integer = -2');
    DefineMethod('RoundDown',2,tkVariant,nil,__RoundDown,false,1,'AValue: extended; ADigit: integer = -2');
    DefineMethod('RoundHalfAri',1,tkVariant,nil,__RoundHalfAri,false,0,'AValue: extended');
    DefineMethod('RoundHalfUp',1,tkVariant,nil,__RoundHalfUp,false,0,'AValue: extended');
    DefineMethod('MaxFloat',2,tkVariant,nil,__MaxFloat,false,0,'A: double; B: double');
    DefineMethod('MinFloat',2,tkVariant,nil,__MinFloat,false,0,'A: double; B: double');
    DefineMethod('ShellOpen',1,tkNone,nil,__ShellOpen,false,0,'FileName: string');
    DefineMethod('ShellExec',2,tkNone,nil,__ShellExec,false,0,'AFileName: string; AParams: string');
    DefineMethod('ShellOpenPdf',5,tkVariant,nil,__ShellOpenPdf,false,0,'AReaderExePath: string; ADocumentName: string; ACmdType: TShellOpenCmdType; AIniPath: string; ALicOk: boolean');
    DefineMethod('ShellOpenAndWait',3,tkVariant,nil,__ShellOpenAndWait,false,2,'AFileName: string; AParams: string = ''''; CmdShow: Integer = SW_SHOWNORMAL');
    DefineMethod('SendEmail',6,tkVariant,nil,__SendEmail,false,0,'AAddress: string; ASubject: string; ABody: string; AAttachments: TStringList; AShowDialog: boolean; AErrorMsg: string').SetVarArgs([5]);
    DefineMethod('GetPrgVersion',1,tkVariant,nil,__GetPrgVersion,false,1,'AFileName: string = ''''');
    DefineMethod('GetWinUserName',0,tkVariant,nil,__GetWinUserName,false,0,'');
    DefineMethod('SearchFiles',3,tkVariant,nil,__SearchFiles,false,0,'ADir: string; AMask: string; AWithSubDirs: boolean');
    DefineMethod('TryDeleteDirectory',3,tkVariant,nil,__TryDeleteDirectory,false,2,'ADir: string; AWithSubDirs: boolean = false; AMsg: string = ''''');
    DefineMethod('DefaultPrinter',0,tkVariant,nil,__DefaultPrinter,false,0,'');
    DefineMethod('SaveStringsToIni',4,tkNone,nil,__SaveStringsToIni,false,0,'AStrings: TStrings; AIniFileName: string; ASection: string; AIdent: string');
    DefineMethod('LoadStringsFromIni',4,tkNone,nil,__LoadStringsFromIni,false,0,'AStrings: TStrings; AIniFileName: string; ASection: string; AIdent: string');
    DefineMethod('SaveMemIni',1,tkVariant,nil,__SaveMemIni,false,0,'AIni: TMemIniFile');
    DefineMethod('CheckRodneCisloDatNar',5,tkVariant,nil,__CheckRodneCisloDatNar,false,0,'ARodneCislo: string; ATestProDIC: boolean; ACheckECP: boolean; ADatNar: TDateTime; AMsg: string').SetVarArgs([3,4]);
    DefineMethod('CheckRodneCisloMsg',4,tkVariant,nil,__CheckRodneCisloMsg,false,2,'ARodneCislo: string; AMsg: string; ATestProDIC: boolean = FALSE; ACheckECP: boolean = FALSE').SetVarArgs([1]);
    DefineMethod('CheckRodneCislo',3,tkVariant,nil,__CheckRodneCislo,false,2,'ARodneCislo: string; ATestProDIC: boolean = FALSE; ACheckECP: boolean = FALSE');
    DefineMethod('CheckICO',1,tkVariant,nil,__CheckICO,false,0,'AIC: string');
    DefineMethod('CheckDIC',3,tkVariant,nil,__CheckDIC,false,2,'ADIC: string; APravnickaOsoba: boolean = FALSE; ATestovatTypOsoby: boolean = FALSE');
    DefineMethod('CheckSkDIC',1,tkVariant,nil,__CheckSkDIC,false,0,'ADIC: string');
    DefineMethod('CheckSkICDPH',1,tkVariant,nil,__CheckSkICDPH,false,0,'AICDPH: string');
    DefineMethod('CheckBU',1,tkVariant,nil,__CheckBU,false,0,'ABU: string');
    DefineMethod('CheckIBAN',1,tkVariant,nil,__CheckIBAN,false,0,'IBAN: string');
    DefineMethod('ZipFile',4,tkVariant,nil,__ZipFile,false,1,'ASrcFileName: string; ADstFileName: string; AComment: string; APassword: string = ''''');
    DefineMethod('UnzipFile',3,tkVariant,nil,__UnzipFile,false,1,'ASrcFileName: string; ADstDir: string; APassword: string = ''''');
    DefineMethod('GetZipFileComment',1,tkVariant,nil,__GetZipFileComment,false,0,'AFileName: string');
    DefineMethod('LoadMemTableFromZip',3,tkVariant,nil,__LoadMemTableFromZip,false,1,'AMt: TkbmMemTable; AZipFileName: string; APassword: string = ''''');
    DefineMethod('LoadTextFromZip',4,tkVariant,nil,__LoadTextFromZip,false,1,'AZipFileName: string; ATextFileName: string; AText: string; APassword: string = ''''').SetVarArgs([2]);
    DefineMethod('NactiAdresuZARES',11,tkVariant,nil,__NactiAdresuZARES,false,0,'AICO: string; AProxyServer: string; AProxyPort: string; ATypOsoby: string; ANazevFirmy: string; AUlice: string; ACisloPop: string; ACisloOrientacni: string; AObec: string; APSC: string; AMsg: string').SetVarArgs([3,4,5,6,7,8,9,10]);
    DefineMethod('NactiAdresuZARESD',12,tkVariant,nil,__NactiAdresuZARESD,false,0,'AICO: string; AProxyServer: string; AProxyPort: string; ATypOsoby: string; ANazevFirmy: string; AUlice: string; ACisloPop: string; ACisloOrientacni: string; AObec: string; APSC: string; ADIC: string; AMsg: string').SetVarArgs([3,4,5,6,7,8,9,10,11]);
    DefineMethod('WebList2CSV',7,tkVariant,nil,__WebList2CSV,false,0,'AUrl: string; AColumns: string; AProxyServer: string; AProxyPort: string; AHeader: string; AList: string; AMsg: string').SetVarArgs([4,5,6]);
    DefineMethod('IsConnectedToInternet',0,tkVariant,nil,__IsConnectedToInternet,false,0,'');
    DefineMethod('GetHTTPDocument',3,tkVariant,nil,__GetHTTPDocument,false,2,'AHTTPAdress: string; AProxyHost: string = ''''; AProxyPort: string = ''''');
    DefineMethod('CheckVAT',5,tkInteger,nil,__CheckVAT,false,0,'countrycode: widestring; vatno: widestring; proxyAddress: string; proxyPort: string; vysledek: string').SetVarArgs([4]);
    DefineMethod('CheckPlatce',5,tkInteger,nil,__CheckPlatce,false,0,'vatno: widestring; proxyAddress: string; proxyPort: string; vysledek: string; ucty: string').SetVarArgs([3,4]);
    DefineMethod('CheckPlatceHttps',5,tkInteger,nil,__CheckPlatceHttps,false,0,'vatno: widestring; proxyAddress: string; proxyPort: string; vysledek: string; ucty: string').SetVarArgs([3,4]);
    DefineMethod('CalcQRCodeText',8,tkVariant,nil,__CalcQRCodeText,false,0,'AIBAN: string; ACastka: double; AMenaUctu: string; APlatce: string; AVarSym: string; ASpecSym: string; AKonSym: string; AZpravaPrijemci: string');
    DefineMethod('ConvertBU2IBAN',2,tkVariant,nil,__ConvertBU2IBAN,false,0,'ABU: string; AMenaUctu: string');
    DefineMethod('FormatIBAN',1,tkVariant,nil,__FormatIBAN,false,0,'IBAN: string');
    DefineMethod('RCDatNar',2,tkVariant,nil,__RCDatNar,false,1,'ARC: string; ACheckECP: boolean = FALSE');
    DefineMethod('RCToSexCode',2,tkVariant,nil,__RCToSexCode,false,1,'ARC: string; ACheckECP: boolean = FALSE');
    DefineMethod('Frac2Str',2,tkVariant,nil,__Frac2Str,false,1,'ANum: double; ADigit: integer = -2');
    DefineMethod('IntPart2Str',2,tkVariant,nil,__IntPart2Str,false,1,'ANum: double; AFormatFloat: boolean = TRUE');
    DefineMethod('Cond',3,tkVariant,nil,__Cond,false,0,'ACond1: boolean; AValue1: Variant; AValueElse: Variant');
    DefineMethod('Cond2',5,tkVariant,nil,__Cond2,false,0,'ACond1: boolean; AValue1: Variant; ACond2: boolean; AValue2: Variant; AValueElse: Variant');
    DefineMethod('Cond3',7,tkVariant,nil,__Cond3,false,0,'ACond1: boolean; AValue1: Variant; ACond2: boolean; AValue2: Variant; ACond3: boolean; AValue3: Variant; AValueElse: Variant');
    DefineMethod('Cond4',9,tkVariant,nil,__Cond4,false,0,'ACond1: boolean; AValue1: Variant; ACond2: boolean; AValue2: Variant; ACond3: boolean; AValue3: Variant; ACond4: boolean; AValue4: Variant; AValueElse: Variant');
    DefineMethod('Cond5',11,tkVariant,nil,__Cond5,false,0,'ACond1: boolean; AValue1: Variant; ACond2: boolean; AValue2: Variant; ACond3: boolean; AValue3: Variant; ACond4: boolean; AValue4: Variant; ACond5: boolean; AValue5: Variant; AValueElse: Variant');
    DefineMethod('CheckFormPosition',3,tkNone,nil,__CheckFormPosition,false,0,'ALeft: integer; ATop: integer; AWidth: integer').SetVarArgs([0,1]);
    DefineMethod('GetFontTypes',0,tkInteger,nil,__GetFontTypes,false,0,'');
    DefineMethod('GetDPIForPDFRender',0,tkInteger,nil,__GetDPIForPDFRender,false,0,'');
    DefineMethod('IsEmailValid',2,tkVariant,nil,__IsEmailValid,false,1,'AEmailStr: string; AIsMailList: Boolean = false');
    DefineMethod('CheckIDDS',1,tkVariant,nil,__CheckIDDS,false,0,'AIdds: string');
    AddConstant('ctOpen',ctOpen);
    AddConstant('ctPrintDefault',ctPrintDefault);
    AddConstant('ctPrintDialog',ctPrintDialog);
    AddConstant('ctPrintTo',ctPrintTo);
    AddConstant('cFADecimalSeparator',cFADecimalSeparator);
    AddConstant('cCRLFAlternate',cCRLFAlternate);
    AddConstant('cCRLF',cCRLF);
  end;
end;

class function TatFCommonUtilsLibrary.LibraryName: string;
begin
  result := 'FCommonUtils';
end;

initialization
  RegisterScripterLibrary(TatFCommonUtilsLibrary, True);

{$WARNINGS ON}

end.


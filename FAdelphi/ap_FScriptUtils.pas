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
unit ap_FScriptUtils;

interface

uses
  Dialogs,
  Messages,
  Windows,
  Controls,
  Classes,
  DB,
  FDlg,
  Res_FA,
  DKLicUtils,
  VersyPDF,
  VersyPDFTypes,
  StdCtrls,
  FileCtrl,
  FScriptUtils,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatFScriptUtilsLibrary = class(TatScripterLibrary)
    procedure __Cal(AMachine: TatVirtualMachine);
    procedure __CalN(AMachine: TatVirtualMachine);
    procedure __Ini(AMachine: TatVirtualMachine);
    procedure __Ino(AMachine: TatVirtualMachine);
    procedure __Def(AMachine: TatVirtualMachine);
    procedure __Ena(AMachine: TatVirtualMachine);
    procedure __Chk(AMachine: TatVirtualMachine);
    procedure __Lst(AMachine: TatVirtualMachine);
    procedure __SimpleLst(AMachine: TatVirtualMachine);
    procedure __IsValueInSimpleList(AMachine: TatVirtualMachine);
    procedure __DoOpenSimpleList(AMachine: TatVirtualMachine);
    procedure __GotoFld(AMachine: TatVirtualMachine);
    procedure __GotoAppendix(AMachine: TatVirtualMachine);
    procedure __LstLookup(AMachine: TatVirtualMachine);
    procedure __OpenLst(AMachine: TatVirtualMachine);
    procedure __WebList2CSV(AMachine: TatVirtualMachine);
    procedure __LoadListToWT(AMachine: TatVirtualMachine);
    procedure __ClientParam(AMachine: TatVirtualMachine);
    procedure __GetClientParams(AMachine: TatVirtualMachine);
    procedure __FormExists(AMachine: TatVirtualMachine);
    procedure __GetFormDataText(AMachine: TatVirtualMachine);
    procedure __GetFormField(AMachine: TatVirtualMachine);
    procedure __SetDataFormField(AMachine: TatVirtualMachine);
    procedure __TakeFormFields(AMachine: TatVirtualMachine);
    procedure __GetForms(AMachine: TatVirtualMachine);
    procedure __GetFormCount(AMachine: TatVirtualMachine);
    procedure __GetFormsOrDocuments(AMachine: TatVirtualMachine);
    procedure __GetDoc(AMachine: TatVirtualMachine);
    procedure __RunAsStandalone(AMachine: TatVirtualMachine);
    procedure __ShowChecking(AMachine: TatVirtualMachine);
    procedure __DisplayCheck(AMachine: TatVirtualMachine);
    procedure __GetAlgVykaz(AMachine: TatVirtualMachine);
    procedure __VykazExists(AMachine: TatVirtualMachine);
    procedure __SavePaymentRec(AMachine: TatVirtualMachine);
    procedure __CreatePaymentOrder(AMachine: TatVirtualMachine);
    procedure __CreatePaymentOrderSEPA(AMachine: TatVirtualMachine);
    procedure __CreateOpenNewForm(AMachine: TatVirtualMachine);
    procedure __OpenSavedForm(AMachine: TatVirtualMachine);
    procedure __SaveRepresentationRec(AMachine: TatVirtualMachine);
    procedure __UniParUpdate(AMachine: TatVirtualMachine);
    procedure __FormBind(AMachine: TatVirtualMachine);
    procedure __WriteValue2Form(AMachine: TatVirtualMachine);
    procedure __AddStrLine(AMachine: TatVirtualMachine);
    procedure __EncDate(AMachine: TatVirtualMachine);
    procedure __CalcFullAddress(AMachine: TatVirtualMachine);
    procedure __CalcFullName(AMachine: TatVirtualMachine);
    procedure __CalcPhoneMobil(AMachine: TatVirtualMachine);
    procedure __ExtractBeforeChar(AMachine: TatVirtualMachine);
    procedure __ExtractAfterChar(AMachine: TatVirtualMachine);
    procedure __CalcFullBaAccount(AMachine: TatVirtualMachine);
    procedure __SplitAddress(AMachine: TatVirtualMachine);
    procedure __StreetFromAddress(AMachine: TatVirtualMachine);
    procedure __ZipCodeFromAddress(AMachine: TatVirtualMachine);
    procedure __CityFromAddress(AMachine: TatVirtualMachine);
    procedure __NormalZipCodeCzech(AMachine: TatVirtualMachine);
    procedure __ExtractBankAccount(AMachine: TatVirtualMachine);
    procedure __ExtractBankCode(AMachine: TatVirtualMachine);
    procedure __ExtractStreetFromStreetAndNum(AMachine: TatVirtualMachine);
    procedure __ExtractNumberFromStreetAndNum(AMachine: TatVirtualMachine);
    procedure __NameOfMonth(AMachine: TatVirtualMachine);
    procedure __NameOfMonth2(AMachine: TatVirtualMachine);
    procedure __GetValidDateStr(AMachine: TatVirtualMachine);
    procedure __GetValidDateStrFmt(AMachine: TatVirtualMachine);
    procedure __ValidValue(AMachine: TatVirtualMachine);
    procedure __ClearField(AMachine: TatVirtualMachine);
    procedure __CalcPeriod(AMachine: TatVirtualMachine);
    procedure __PreviewSimpleReport(AMachine: TatVirtualMachine);
    procedure __ShowInstruction(AMachine: TatVirtualMachine);
    procedure __AmountByWords(AMachine: TatVirtualMachine);
    procedure __TryEditValuesRecord(AMachine: TatVirtualMachine);
    procedure __TryPostValuesRecord(AMachine: TatVirtualMachine);
    procedure __MsgBoxErr(AMachine: TatVirtualMachine);
    procedure __MsgBoxWarn(AMachine: TatVirtualMachine);
    procedure __MsgBoxAsk(AMachine: TatVirtualMachine);
    procedure __MsgBoxInfo(AMachine: TatVirtualMachine);
    procedure __MsgBoxAskButtons(AMachine: TatVirtualMachine);
    procedure __Msg(AMachine: TatVirtualMachine);
    procedure __Msgv(AMachine: TatVirtualMachine);
    procedure __InitScriptGVariables(AMachine: TatVirtualMachine);
    procedure __CreatePrintDataForTable(AMachine: TatVirtualMachine);
    procedure __SetFormData(AMachine: TatVirtualMachine);
    procedure __SetChangeFlag(AMachine: TatVirtualMachine);
    procedure __GetChangeFlag(AMachine: TatVirtualMachine);
    procedure __SetLockFlag(AMachine: TatVirtualMachine);
    procedure __GetLockFlag(AMachine: TatVirtualMachine);
    procedure __GetAppendixString(AMachine: TatVirtualMachine);
    procedure __GetNotesString(AMachine: TatVirtualMachine);
    procedure __GetCommentString(AMachine: TatVirtualMachine);
    procedure __SetDoEnableAfterCalculate(AMachine: TatVirtualMachine);
    procedure __GetMTVField(AMachine: TatVirtualMachine);
    procedure __GetMTVFieldValue(AMachine: TatVirtualMachine);
    procedure __GetNestedSection(AMachine: TatVirtualMachine);
    procedure __AddNestedSection(AMachine: TatVirtualMachine);
    procedure __ReplaceNestedSection(AMachine: TatVirtualMachine);
    procedure __DeleteNestedSection(AMachine: TatVirtualMachine);
    procedure __GetFormFieldCompactNested(AMachine: TatVirtualMachine);
    procedure __DoOpenNestedForm(AMachine: TatVirtualMachine);
    procedure __DoPrepareReportNestedForm(AMachine: TatVirtualMachine);
    procedure __NestedState(AMachine: TatVirtualMachine);
    procedure __ReloadListBoxes(AMachine: TatVirtualMachine);
    procedure __GetListBoxItemIndex(AMachine: TatVirtualMachine);
    procedure __SetListBoxItemIndex(AMachine: TatVirtualMachine);
    procedure __GetListBoxItemString(AMachine: TatVirtualMachine);
    procedure __SetListBoxItemString(AMachine: TatVirtualMachine);
    procedure __GetListBoxItemCount(AMachine: TatVirtualMachine);
    procedure __AskInt(AMachine: TatVirtualMachine);
    procedure __AskFloat(AMachine: TatVirtualMachine);
    procedure __AskStr(AMachine: TatVirtualMachine);
    procedure __AskStrV(AMachine: TatVirtualMachine);
    procedure __AskMemo(AMachine: TatVirtualMachine);
    procedure __AskMemoV(AMachine: TatVirtualMachine);
    procedure __AskIntInt(AMachine: TatVirtualMachine);
    procedure __AskDate(AMachine: TatVirtualMachine);
    procedure __AskDateDate(AMachine: TatVirtualMachine);
    procedure __ClearTskpFillingInfo(AMachine: TatVirtualMachine);
    procedure __BinaryFileToStringBase64(AMachine: TatVirtualMachine);
    procedure __StringBase64ToBinaryFile(AMachine: TatVirtualMachine);
    procedure __BinaryFileToStringMime(AMachine: TatVirtualMachine);
    procedure __StringMimeToBinaryFile(AMachine: TatVirtualMachine);
    procedure __SetMultilineOpenDialog(AMachine: TatVirtualMachine);
    procedure __SelectClientAdress(AMachine: TatVirtualMachine);
    procedure __SelectClientPerson(AMachine: TatVirtualMachine);
    procedure __SelectClientBankAccount(AMachine: TatVirtualMachine);
    procedure __SelectAttachments(AMachine: TatVirtualMachine);
    procedure __SetFormUserSettingPrintAppendix(AMachine: TatVirtualMachine);
    procedure __SetFormUserSettingPrintFromPage(AMachine: TatVirtualMachine);
    procedure __PrepareReportFilePages(AMachine: TatVirtualMachine);
    procedure __GetReportSettings(AMachine: TatVirtualMachine);
    procedure __FuncVersion(AMachine: TatVirtualMachine);
    procedure __GetLicProductionNumber(AMachine: TatVirtualMachine);
    procedure __InsertLogoToPDF(AMachine: TatVirtualMachine);
    procedure __GetLogoPath(AMachine: TatVirtualMachine);
    procedure __InsertQRCodeToPDF(AMachine: TatVirtualMachine);
    procedure __InsertQRCodeTextToPDF(AMachine: TatVirtualMachine);
    procedure __InsertBarCodeToPDF(AMachine: TatVirtualMachine);
    procedure __PackPDF(AMachine: TatVirtualMachine);
    procedure __CreateFDFFile(AMachine: TatVirtualMachine);
    procedure __EncodeFDFString(AMachine: TatVirtualMachine);
    procedure __GetTxtFileFromFDR(AMachine: TatVirtualMachine);
    procedure __DoPrintForm(AMachine: TatVirtualMachine);
    procedure __mtWorkSaveToString(AMachine: TatVirtualMachine);
    procedure __mtWorkLoadFromString(AMachine: TatVirtualMachine);
    procedure __GetDirWorkPath(AMachine: TatVirtualMachine);
    procedure __GetExeFilePath(AMachine: TatVirtualMachine);
    procedure __DoCopyFile(AMachine: TatVirtualMachine);
    procedure __VyberCertifikat(AMachine: TatVirtualMachine);
    procedure __FloatFieldIntPartStr(AMachine: TatVirtualMachine);
    procedure __FloatFieldFracPartStr(AMachine: TatVirtualMachine);
    procedure __StartCounterZero(AMachine: TatVirtualMachine);
    procedure __Utf8ToAnsiString(AMachine: TatVirtualMachine);
    procedure __SelectDir(AMachine: TatVirtualMachine);
    procedure __GetPDS(AMachine: TatVirtualMachine);
    procedure __SCheckVAT(AMachine: TatVirtualMachine);
    procedure __SCheckPlatce(AMachine: TatVirtualMachine);
    procedure __SNactiAdresuZARES(AMachine: TatVirtualMachine);
    procedure __SNactiAdresuZARESD(AMachine: TatVirtualMachine);
    procedure __ShowInfoARES(AMachine: TatVirtualMachine);
    procedure __mtValuesClearFields(AMachine: TatVirtualMachine);
    procedure __ReplaceXmlStr(AMachine: TatVirtualMachine);
    procedure __TryEncodeDateTimeEx(AMachine: TatVirtualMachine);
    procedure __DateTimeStrEval(AMachine: TatVirtualMachine);
    procedure __GetFillingInfo(AMachine: TatVirtualMachine);
    procedure __BP(AMachine: TatVirtualMachine);
    procedure __ControlAndSendForm(AMachine: TatVirtualMachine);
    procedure __SaveFormWithoutCheck(AMachine: TatVirtualMachine);
    procedure __SizeOfFile(AMachine: TatVirtualMachine);
    procedure __GetAdrClip(AMachine: TatVirtualMachine);
    procedure __SetGScriptFieldName(AMachine: TatVirtualMachine);
    procedure __IsPaymentInDB(AMachine: TatVirtualMachine);
    procedure __DelPaymentInDB(AMachine: TatVirtualMachine);
    procedure __MsgAskYesNoCancel(AMachine: TatVirtualMachine);
    procedure __SaveDocumentToDB(AMachine: TatVirtualMachine);
    procedure __OpenWebPortalCSSZ(AMachine: TatVirtualMachine);
    procedure __SendFilesByEmailOrDS(AMachine: TatVirtualMachine);
    procedure __SelectEmailOrDS(AMachine: TatVirtualMachine);
    procedure __PDFEditorPath(AMachine: TatVirtualMachine);
    procedure __SetOpenPDFEditorFlag(AMachine: TatVirtualMachine);
    procedure __GetOpenPDFEditorFlag(AMachine: TatVirtualMachine);
    procedure __ShowProgress(AMachine: TatVirtualMachine);
    procedure __CreateWtFields(AMachine: TatVirtualMachine);
    procedure __SaveWtToString(AMachine: TatVirtualMachine);
    procedure __LoadWtFromString(AMachine: TatVirtualMachine);
    procedure __AppProcessMessages(AMachine: TatVirtualMachine);
    procedure __CheckDotNet(AMachine: TatVirtualMachine);
    procedure __RunDotNetStript(AMachine: TatVirtualMachine);
    procedure __SaveAppendixToPDF(AMachine: TatVirtualMachine);
    procedure __IsDotNetDetected(AMachine: TatVirtualMachine);
    procedure __ForceSaveNestedData(AMachine: TatVirtualMachine);
    procedure __ForceCloseFA(AMachine: TatVirtualMachine);
    procedure __SaveNewFormToDB(AMachine: TatVirtualMachine);
    procedure __LoadingStart(AMachine: TatVirtualMachine);
    procedure __LoadingStop(AMachine: TatVirtualMachine);
    procedure __LoadingStep(AMachine: TatVirtualMachine);
    procedure __LoadingBreakRequest(AMachine: TatVirtualMachine);
    procedure __ConvertFR3ToPDF(AMachine: TatVirtualMachine);
    procedure __DoCancelEditForm(AMachine: TatVirtualMachine);
    procedure __EvalScript(AMachine: TatVirtualMachine);
    procedure __EvalMethod(AMachine: TatVirtualMachine);
    procedure __EvalParamMethod(AMachine: TatVirtualMachine);
    procedure __CreateHBWithImportCSV(AMachine: TatVirtualMachine);
    procedure __SendOrderFioAPI(AMachine: TatVirtualMachine);
    procedure __Gsl(AMachine: TatVirtualMachine);
    procedure __GFillMemo(AMachine: TatVirtualMachine);
    procedure __GScriptState(AMachine: TatVirtualMachine);
    procedure __GScriptFieldName(AMachine: TatVirtualMachine);
    procedure __GScriptOldFieldName(AMachine: TatVirtualMachine);
    procedure __SetValueGScriptState(AMachine: TatVirtualMachine);
    procedure __SetValueGScriptFieldName(AMachine: TatVirtualMachine);
    procedure __SetValueGScriptOldFieldName(AMachine: TatVirtualMachine);
    procedure __GGotoFieldName(AMachine: TatVirtualMachine);
    procedure __GScriptPreparedLists(AMachine: TatVirtualMachine);
    procedure __GScriptGetFormsIDDefs(AMachine: TatVirtualMachine);
    procedure __GScriptFldDisplayValue(AMachine: TatVirtualMachine);
    procedure __GScriptZeroValueClear(AMachine: TatVirtualMachine);
    procedure __GScriptFillingInfo(AMachine: TatVirtualMachine);
    procedure __GShowThousandSeparator(AMachine: TatVirtualMachine);
    procedure __GSlaveState(AMachine: TatVirtualMachine);
    procedure __GCheckGotoFldName(AMachine: TatVirtualMachine);
    procedure __GScriptFillingZip(AMachine: TatVirtualMachine);
    procedure __SetValueGScriptFillingZip(AMachine: TatVirtualMachine);
    procedure __GfodFrmID(AMachine: TatVirtualMachine);
    procedure __GfodFrmDefID(AMachine: TatVirtualMachine);
    procedure __GfodDocId(AMachine: TatVirtualMachine);
    procedure __GfodFiles(AMachine: TatVirtualMachine);
    procedure __GfodGUID(AMachine: TatVirtualMachine);
    procedure __SetValueGfodFrmID(AMachine: TatVirtualMachine);
    procedure __SetValueGfodFrmDefID(AMachine: TatVirtualMachine);
    procedure __SetValueGfodDocId(AMachine: TatVirtualMachine);
    procedure __SetValueGfodFiles(AMachine: TatVirtualMachine);
    procedure __SetValueGfodGUID(AMachine: TatVirtualMachine);
    procedure __GetGInternalDataForPrint(AMachine: TatVirtualMachine);
    procedure __SetGInternalDataForPrint(AMachine: TatVirtualMachine);
    procedure __GetGEPOFilePath(AMachine: TatVirtualMachine);
    procedure __SetGEPOFilePath(AMachine: TatVirtualMachine);
    procedure __GetGLoadingBreak(AMachine: TatVirtualMachine);
    procedure __SetGLoadingBreak(AMachine: TatVirtualMachine);
    procedure __GetFSelectedDir(AMachine: TatVirtualMachine);
    procedure __SetFSelectedDir(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;




implementation



procedure TatFScriptUtilsLibrary.__Cal(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.Cal(VarToStr(GetInputArg(0)),GetInputArg(1));
  end;
end;

procedure TatFScriptUtilsLibrary.__CalN(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.CalN(VarToStr(GetInputArg(0)),GetInputArg(1));
  end;
end;

procedure TatFScriptUtilsLibrary.__Ini(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.Ini(VarToStr(GetInputArg(0)),GetInputArg(1));
  end;
end;

procedure TatFScriptUtilsLibrary.__Ino(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.Ino(VarToStr(GetInputArg(0)),GetInputArg(1));
  end;
end;

procedure TatFScriptUtilsLibrary.__Def(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.Def(VarToStr(GetInputArg(0)),GetInputArg(1));
  end;
end;

procedure TatFScriptUtilsLibrary.__Ena(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.Ena(VarToStr(GetInputArg(0)),GetInputArg(1));
  end;
end;

procedure TatFScriptUtilsLibrary.__Chk(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      3: FScriptUtils.Chk(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)));
      4: FScriptUtils.Chk(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__Lst(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      4: FScriptUtils.Lst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)));
      5: FScriptUtils.Lst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)));
      6: FScriptUtils.Lst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__SimpleLst(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      2: FScriptUtils.SimpleLst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
      3: FScriptUtils.SimpleLst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
      4: FScriptUtils.SimpleLst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)));
      5: FScriptUtils.SimpleLst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToStr(GetInputArg(4)));
      6: FScriptUtils.SimpleLst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)));
      7: FScriptUtils.SimpleLst(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__IsValueInSimpleList(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := FScriptUtils.IsValueInSimpleList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := FScriptUtils.IsValueInSimpleList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__DoOpenSimpleList(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := FScriptUtils.DoOpenSimpleList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
3: AResult := FScriptUtils.DoOpenSimpleList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
4: AResult := FScriptUtils.DoOpenSimpleList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)));
5: AResult := FScriptUtils.DoOpenSimpleList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToStr(GetInputArg(4)));
6: AResult := FScriptUtils.DoOpenSimpleList(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GotoFld(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.GotoFld(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__GotoAppendix(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.GotoAppendix;
  end;
end;

procedure TatFScriptUtilsLibrary.__LstLookup(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.LstLookup(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)),GetInputArg(3),VarToStr(GetInputArg(4)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__OpenLst(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
5: AResult := FScriptUtils.OpenLst(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)),GetInputArg(3),VarToStr(GetInputArg(4)));
6: AResult := FScriptUtils.OpenLst(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)),GetInputArg(3),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__WebList2CSV(AMachine: TatVirtualMachine);
  var
  Param2: string;
  Param3: string;
  Param4: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
Param3 := VarToStr(GetInputArg(3));
Param4 := VarToStr(GetInputArg(4));
AResult := FScriptUtils.WebList2CSV(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2,Param3,Param4);
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
    SetInputArg(3,string(Param3));
    SetInputArg(4,string(Param4));
  end;
end;

procedure TatFScriptUtilsLibrary.__LoadListToWT(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.LoadListToWT(VarToStr(GetInputArg(0)),GetInputArg(1),VarToInteger(GetInputArg(2)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ClientParam(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.ClientParam(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.ClientParam(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetClientParams(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetClientParams);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__FormExists(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.FormExists(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetFormDataText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetFormDataText(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetFormField(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetFormField(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetDataFormField(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.SetDataFormField(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__TakeFormFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      2: FScriptUtils.TakeFormFields(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
      3: FScriptUtils.TakeFormFields(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__GetForms(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.GetForms(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.GetForms(VarToStr(GetInputArg(0)),GetInputArg(1)));
3: AResult := string(FScriptUtils.GetForms(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2))));
4: AResult := string(FScriptUtils.GetForms(VarToStr(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetFormCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.GetFormCount(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetFormsOrDocuments(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := FScriptUtils.GetFormsOrDocuments;
1: AResult := FScriptUtils.GetFormsOrDocuments(GetInputArg(0));
2: AResult := FScriptUtils.GetFormsOrDocuments(GetInputArg(0),VarToStr(GetInputArg(1)));
3: AResult := FScriptUtils.GetFormsOrDocuments(GetInputArg(0),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
4: AResult := FScriptUtils.GetFormsOrDocuments(GetInputArg(0),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),GetInputArg(3));
5: AResult := FScriptUtils.GetFormsOrDocuments(GetInputArg(0),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),GetInputArg(3),GetInputArg(4));
6: AResult := FScriptUtils.GetFormsOrDocuments(GetInputArg(0),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),GetInputArg(3),GetInputArg(4),GetInputArg(5));
7: AResult := FScriptUtils.GetFormsOrDocuments(GetInputArg(0),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),GetInputArg(3),GetInputArg(4),GetInputArg(5),GetInputArg(6));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetDoc(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetDoc(VarToInteger(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__RunAsStandalone(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.RunAsStandalone;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ShowChecking(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := FScriptUtils.ShowChecking;
1: AResult := FScriptUtils.ShowChecking(GetInputArg(0));
2: AResult := FScriptUtils.ShowChecking(GetInputArg(0),GetInputArg(1));
3: AResult := FScriptUtils.ShowChecking(GetInputArg(0),GetInputArg(1),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__DisplayCheck(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.DisplayCheck;
  end;
end;

procedure TatFScriptUtilsLibrary.__GetAlgVykaz(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetAlgVykaz(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__VykazExists(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.VykazExists(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SavePaymentRec(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
3: AResult := FScriptUtils.SavePaymentRec(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2));
4: AResult := FScriptUtils.SavePaymentRec(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)));
5: AResult := FScriptUtils.SavePaymentRec(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)));
6: AResult := FScriptUtils.SavePaymentRec(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)));
7: AResult := FScriptUtils.SavePaymentRec(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)));
8: AResult := FScriptUtils.SavePaymentRec(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)));
9: AResult := FScriptUtils.SavePaymentRec(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)));
10: AResult := FScriptUtils.SavePaymentRec(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__CreatePaymentOrder(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      7: FScriptUtils.CreatePaymentOrder(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)));
      8: FScriptUtils.CreatePaymentOrder(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__CreatePaymentOrderSEPA(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      5: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)));
      6: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)));
      7: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)));
      8: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)));
      9: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)));
      10: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)));
      11: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)),VarToStr(GetInputArg(10)));
      12: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)),VarToStr(GetInputArg(10)),VarToStr(GetInputArg(11)));
      13: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)),VarToStr(GetInputArg(10)),VarToStr(GetInputArg(11)),VarToStr(GetInputArg(12)));
      14: FScriptUtils.CreatePaymentOrderSEPA(GetInputArg(0),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)),VarToStr(GetInputArg(10)),VarToStr(GetInputArg(11)),VarToStr(GetInputArg(12)),VarToStr(GetInputArg(13)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__CreateOpenNewForm(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.CreateOpenNewForm(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__OpenSavedForm(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.OpenSavedForm(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SaveRepresentationRec(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SaveRepresentationRec(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),GetInputArg(3),GetInputArg(4),GetInputArg(5),VarToStr(GetInputArg(6)));
  end;
end;

procedure TatFScriptUtilsLibrary.__UniParUpdate(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.UniParUpdate(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)));
  end;
end;

procedure TatFScriptUtilsLibrary.__FormBind(AMachine: TatVirtualMachine);
  var
  Param2: string;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
    FScriptUtils.FormBind(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__WriteValue2Form(AMachine: TatVirtualMachine);
  var
  Param3: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param3 := VarToStr(GetInputArg(3));
AResult := FScriptUtils.WriteValue2Form(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),Param3);
    ReturnOutputArg(AResult);
    SetInputArg(3,string(Param3));
  end;
end;

procedure TatFScriptUtilsLibrary.__AddStrLine(AMachine: TatVirtualMachine);
  var
  Param0: string;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
    FScriptUtils.AddStrLine(Param0,VarToStr(GetInputArg(1)));
    SetInputArg(0,string(Param0));
  end;
end;

procedure TatFScriptUtilsLibrary.__EncDate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := FScriptUtils.EncDate;
1: AResult := FScriptUtils.EncDate(VarToInteger(GetInputArg(0)));
2: AResult := FScriptUtils.EncDate(VarToInteger(GetInputArg(0)),VarToInteger(GetInputArg(1)));
3: AResult := FScriptUtils.EncDate(VarToInteger(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__CalcFullAddress(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.CalcFullAddress(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),GetInputArg(7)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__CalcFullName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
4: AResult := string(FScriptUtils.CalcFullName(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3))));
5: AResult := string(FScriptUtils.CalcFullName(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__CalcPhoneMobil(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.CalcPhoneMobil(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ExtractBeforeChar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.ExtractBeforeChar(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.ExtractBeforeChar(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ExtractAfterChar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.ExtractAfterChar(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.ExtractAfterChar(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__CalcFullBaAccount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := string(FScriptUtils.CalcFullBaAccount(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
3: AResult := string(FScriptUtils.CalcFullBaAccount(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SplitAddress(AMachine: TatVirtualMachine);
  var
  Param1: string;
  Param2: string;
  Param3: string;
begin
  with AMachine do
  begin
Param1 := VarToStr(GetInputArg(1));
Param2 := VarToStr(GetInputArg(2));
Param3 := VarToStr(GetInputArg(3));
    FScriptUtils.SplitAddress(VarToStr(GetInputArg(0)),Param1,Param2,Param3);
    SetInputArg(1,string(Param1));
    SetInputArg(2,string(Param2));
    SetInputArg(3,string(Param3));
  end;
end;

procedure TatFScriptUtilsLibrary.__StreetFromAddress(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.StreetFromAddress(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ZipCodeFromAddress(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.ZipCodeFromAddress(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__CityFromAddress(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.CityFromAddress(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__NormalZipCodeCzech(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.NormalZipCodeCzech(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ExtractBankAccount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.ExtractBankAccount(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ExtractBankCode(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.ExtractBankCode(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ExtractStreetFromStreetAndNum(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.ExtractStreetFromStreetAndNum(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ExtractNumberFromStreetAndNum(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.ExtractNumberFromStreetAndNum(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__NameOfMonth(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.NameOfMonth(VarToInteger(GetInputArg(0))));
2: AResult := string(FScriptUtils.NameOfMonth(VarToInteger(GetInputArg(0)),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__NameOfMonth2(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.NameOfMonth2(VarToInteger(GetInputArg(0))));
2: AResult := string(FScriptUtils.NameOfMonth2(VarToInteger(GetInputArg(0)),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetValidDateStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.GetValidDateStr(GetInputArg(0)));
2: AResult := string(FScriptUtils.GetValidDateStr(GetInputArg(0),VarToStr(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetValidDateStrFmt(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.GetValidDateStrFmt(GetInputArg(0)));
2: AResult := string(FScriptUtils.GetValidDateStrFmt(GetInputArg(0),VarToStr(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ValidValue(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := FScriptUtils.ValidValue(VarToStr(GetInputArg(0)),GetInputArg(1));
3: AResult := FScriptUtils.ValidValue(VarToStr(GetInputArg(0)),GetInputArg(1),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ClearField(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.ClearField(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__CalcPeriod(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.CalcPeriod(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__PreviewSimpleReport(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.PreviewSimpleReport(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__ShowInstruction(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.ShowInstruction(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__AmountByWords(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.AmountByWords(GetInputArg(0)));
2: AResult := string(FScriptUtils.AmountByWords(GetInputArg(0),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__TryEditValuesRecord(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.TryEditValuesRecord;
  end;
end;

procedure TatFScriptUtilsLibrary.__TryPostValuesRecord(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.TryPostValuesRecord;
  end;
end;

procedure TatFScriptUtilsLibrary.__MsgBoxErr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.MsgBoxErr(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__MsgBoxWarn(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.MsgBoxWarn(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__MsgBoxAsk(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.MsgBoxAsk(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__MsgBoxInfo(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.MsgBoxInfo(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__MsgBoxAskButtons(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
5: AResult := Integer(FScriptUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4))));
6: AResult := Integer(FScriptUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5))));
7: AResult := Integer(FScriptUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6))));
8: AResult := Integer(FScriptUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6)),VarToInteger(GetInputArg(7))));
9: AResult := Integer(FScriptUtils.MsgBoxAskButtons(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6)),VarToInteger(GetInputArg(7)),VarToInteger(GetInputArg(8))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__Msg(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.Msg(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__Msgv(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.Msgv(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__InitScriptGVariables(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.InitScriptGVariables;
  end;
end;

procedure TatFScriptUtilsLibrary.__CreatePrintDataForTable(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
4: AResult := string(FScriptUtils.CreatePrintDataForTable(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3))));
5: AResult := string(FScriptUtils.CreatePrintDataForTable(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToInteger(GetInputArg(4))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetFormData(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetFormData(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetChangeFlag(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetChangeFlag(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetChangeFlag(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.GetChangeFlag;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetLockFlag(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetLockFlag(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetLockFlag(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.GetLockFlag;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetAppendixString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetAppendixString);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetNotesString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetNotesString);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetCommentString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetCommentString);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetDoEnableAfterCalculate(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetDoEnableAfterCalculate(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetMTVField(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(FScriptUtils.GetMTVField(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetMTVFieldValue(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.GetMTVFieldValue(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetNestedSection(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetNestedSection(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__AddNestedSection(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.AddNestedSection(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ReplaceNestedSection(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.ReplaceNestedSection(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__DeleteNestedSection(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.DeleteNestedSection(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetFormFieldCompactNested(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetFormFieldCompactNested(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__DoOpenNestedForm(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.DoOpenNestedForm(VarToInteger(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToInteger(GetInputArg(4))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__DoPrepareReportNestedForm(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.DoPrepareReportNestedForm(VarToInteger(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToStr(GetInputArg(4))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__NestedState(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.NestedState;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ReloadListBoxes(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.ReloadListBoxes;
  end;
end;

procedure TatFScriptUtilsLibrary.__GetListBoxItemIndex(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.GetListBoxItemIndex(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetListBoxItemIndex(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetListBoxItemIndex(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetListBoxItemString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetListBoxItemString(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetListBoxItemString(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetListBoxItemString(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToStr(GetInputArg(2)));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetListBoxItemCount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.GetListBoxItemCount(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__AskInt(AMachine: TatVirtualMachine);
  var
  Param2: integer;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToInteger(GetInputArg(2));
AResult := Integer(FScriptUtils.AskInt(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2));
    ReturnOutputArg(AResult);
    SetInputArg(2,Integer(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__AskFloat(AMachine: TatVirtualMachine);
  var
  Param2: double;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := GetInputArg(2);
AResult := Integer(FScriptUtils.AskFloat(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2));
    ReturnOutputArg(AResult);
    SetInputArg(2,Param2);
  end;
end;

procedure TatFScriptUtilsLibrary.__AskStr(AMachine: TatVirtualMachine);
  var
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
AResult := Integer(FScriptUtils.AskStr(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2));
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__AskStrV(AMachine: TatVirtualMachine);
  var
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
AResult := Integer(FScriptUtils.AskStrV(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2,VarToInteger(GetInputArg(3)),VarToInteger(GetInputArg(4)),VarToInteger(GetInputArg(5))));
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__AskMemo(AMachine: TatVirtualMachine);
  var
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
AResult := Integer(FScriptUtils.AskMemo(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2));
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__AskMemoV(AMachine: TatVirtualMachine);
  var
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
AResult := Integer(FScriptUtils.AskMemoV(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2,VarToInteger(GetInputArg(3)),VarToInteger(GetInputArg(4)),VarToInteger(GetInputArg(5))));
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__AskIntInt(AMachine: TatVirtualMachine);
  var
  Param2: integer;
  Param4: integer;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToInteger(GetInputArg(2));
Param4 := VarToInteger(GetInputArg(4));
AResult := Integer(FScriptUtils.AskIntInt(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2,VarToStr(GetInputArg(3)),Param4));
    ReturnOutputArg(AResult);
    SetInputArg(2,Integer(Param2));
    SetInputArg(4,Integer(Param4));
  end;
end;

procedure TatFScriptUtilsLibrary.__AskDate(AMachine: TatVirtualMachine);
  var
  Param2: TDate;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := GetInputArg(2);
AResult := Integer(FScriptUtils.AskDate(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2));
    ReturnOutputArg(AResult);
    SetInputArg(2,Param2);
  end;
end;

procedure TatFScriptUtilsLibrary.__AskDateDate(AMachine: TatVirtualMachine);
  var
  Param2: TDate;
  Param4: TDate;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := GetInputArg(2);
Param4 := GetInputArg(4);
AResult := Integer(FScriptUtils.AskDateDate(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2,VarToStr(GetInputArg(3)),Param4));
    ReturnOutputArg(AResult);
    SetInputArg(2,Param2);
    SetInputArg(4,Param4);
  end;
end;

procedure TatFScriptUtilsLibrary.__ClearTskpFillingInfo(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.ClearTskpFillingInfo;
  end;
end;

procedure TatFScriptUtilsLibrary.__BinaryFileToStringBase64(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.BinaryFileToStringBase64(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__StringBase64ToBinaryFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.StringBase64ToBinaryFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
  end;
end;

procedure TatFScriptUtilsLibrary.__BinaryFileToStringMime(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.BinaryFileToStringMime(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__StringMimeToBinaryFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.StringMimeToBinaryFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetMultilineOpenDialog(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetMultilineOpenDialog(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__SelectClientAdress(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := string(FScriptUtils.SelectClientAdress);
1: AResult := string(FScriptUtils.SelectClientAdress(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.SelectClientAdress(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
3: AResult := string(FScriptUtils.SelectClientAdress(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2)));
4: AResult := string(FScriptUtils.SelectClientAdress(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3))));
5: AResult := string(FScriptUtils.SelectClientAdress(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4))));
6: AResult := string(FScriptUtils.SelectClientAdress(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SelectClientPerson(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := string(FScriptUtils.SelectClientPerson);
1: AResult := string(FScriptUtils.SelectClientPerson(VarToStr(GetInputArg(0))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SelectClientBankAccount(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := string(FScriptUtils.SelectClientBankAccount);
1: AResult := string(FScriptUtils.SelectClientBankAccount(VarToStr(GetInputArg(0))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SelectAttachments(AMachine: TatVirtualMachine);
  var
  Param1: string;
  Param2: string;
  Param3: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param1 := VarToStr(GetInputArg(1));
Param2 := VarToStr(GetInputArg(2));
Param3 := VarToStr(GetInputArg(3));
AResult := FScriptUtils.SelectAttachments(VarToStr(GetInputArg(0)),Param1,Param2,Param3);
    ReturnOutputArg(AResult);
    SetInputArg(1,string(Param1));
    SetInputArg(2,string(Param2));
    SetInputArg(3,string(Param3));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetFormUserSettingPrintAppendix(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetFormUserSettingPrintAppendix(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetFormUserSettingPrintFromPage(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetFormUserSettingPrintFromPage(VarToInteger(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__PrepareReportFilePages(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.PrepareReportFilePages(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.PrepareReportFilePages(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetReportSettings(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetReportSettings);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__FuncVersion(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.FuncVersion);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetLicProductionNumber(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetLicProductionNumber);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__InsertLogoToPDF(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      3: FScriptUtils.InsertLogoToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)));
      4: FScriptUtils.InsertLogoToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)));
      5: FScriptUtils.InsertLogoToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToInteger(GetInputArg(4)));
      6: FScriptUtils.InsertLogoToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToInteger(GetInputArg(4)),VarToStr(GetInputArg(5)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__GetLogoPath(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetLogoPath);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__InsertQRCodeToPDF(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      12: FScriptUtils.InsertQRCodeToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),GetInputArg(5),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)),VarToStr(GetInputArg(10)),VarToStr(GetInputArg(11)));
      13: FScriptUtils.InsertQRCodeToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),GetInputArg(5),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)),VarToStr(GetInputArg(10)),VarToStr(GetInputArg(11)),VarToInteger(GetInputArg(12)));
      14: FScriptUtils.InsertQRCodeToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),GetInputArg(5),VarToStr(GetInputArg(6)),VarToStr(GetInputArg(7)),VarToStr(GetInputArg(8)),VarToStr(GetInputArg(9)),VarToStr(GetInputArg(10)),VarToStr(GetInputArg(11)),VarToInteger(GetInputArg(12)),VarToInteger(GetInputArg(13)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__InsertQRCodeTextToPDF(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      4: FScriptUtils.InsertQRCodeTextToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)));
      5: FScriptUtils.InsertQRCodeTextToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToInteger(GetInputArg(4)));
      6: FScriptUtils.InsertQRCodeTextToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToInteger(GetInputArg(4)),VarToInteger(GetInputArg(5)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__InsertBarCodeToPDF(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      5: FScriptUtils.InsertBarCodeToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)));
      6: FScriptUtils.InsertBarCodeToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)));
      7: FScriptUtils.InsertBarCodeToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6)));
      8: FScriptUtils.InsertBarCodeToPDF(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6)),GetInputArg(7));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__PackPDF(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.PackPDF(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
  end;
end;

procedure TatFScriptUtilsLibrary.__CreateFDFFile(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.CreateFDFFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
  end;
end;

procedure TatFScriptUtilsLibrary.__EncodeFDFString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.EncodeFDFString(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetTxtFileFromFDR(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetTxtFileFromFDR(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__DoPrintForm(AMachine: TatVirtualMachine);
  var
  Param3: string;
begin
  with AMachine do
  begin
Param3 := VarToStr(GetInputArg(3));
    FScriptUtils.DoPrintForm(VarToStr(GetInputArg(0)),GetInputArg(1),GetInputArg(2),Param3);
    SetInputArg(3,string(Param3));
  end;
end;

procedure TatFScriptUtilsLibrary.__mtWorkSaveToString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.mtWorkSaveToString);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__mtWorkLoadFromString(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.mtWorkLoadFromString(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetDirWorkPath(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetDirWorkPath);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetExeFilePath(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetExeFilePath);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__DoCopyFile(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.DoCopyFile(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__VyberCertifikat(AMachine: TatVirtualMachine);
  var
  Param0: string;
  Param1: string;
  Param2: string;
  Param3: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := VarToStr(GetInputArg(0));
Param1 := VarToStr(GetInputArg(1));
Param2 := VarToStr(GetInputArg(2));
Param3 := VarToStr(GetInputArg(3));
AResult := FScriptUtils.VyberCertifikat(Param0,Param1,Param2,Param3);
    ReturnOutputArg(AResult);
    SetInputArg(0,string(Param0));
    SetInputArg(1,string(Param1));
    SetInputArg(2,string(Param2));
    SetInputArg(3,string(Param3));
  end;
end;

procedure TatFScriptUtilsLibrary.__FloatFieldIntPartStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.FloatFieldIntPartStr(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.FloatFieldIntPartStr(VarToStr(GetInputArg(0)),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__FloatFieldFracPartStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.FloatFieldFracPartStr(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.FloatFieldFracPartStr(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__StartCounterZero(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.StartCounterZero;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__Utf8ToAnsiString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.Utf8ToAnsiString(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SelectDir(AMachine: TatVirtualMachine);
  var
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
AResult := FScriptUtils.SelectDir(VarToStr(GetInputArg(0)),GetInputArg(1),Param2);
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetPDS(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := string(FScriptUtils.GetPDS);
1: AResult := string(FScriptUtils.GetPDS(VarToStr(GetInputArg(0))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SCheckVAT(AMachine: TatVirtualMachine);
  var
  Param2: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param2 := VarToStr(GetInputArg(2));
AResult := Integer(FScriptUtils.SCheckVAT(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),Param2));
    ReturnOutputArg(AResult);
    SetInputArg(2,string(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__SCheckPlatce(AMachine: TatVirtualMachine);
  var
  Param1: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param1 := VarToStr(GetInputArg(1));
AResult := Integer(FScriptUtils.SCheckPlatce(VarToStr(GetInputArg(0)),Param1));
    ReturnOutputArg(AResult);
    SetInputArg(1,string(Param1));
  end;
end;

procedure TatFScriptUtilsLibrary.__SNactiAdresuZARES(AMachine: TatVirtualMachine);
  var
  Param1: string;
  Param2: string;
  Param3: string;
  Param4: string;
  Param5: string;
  Param6: string;
  Param7: string;
  Param8: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param1 := VarToStr(GetInputArg(1));
Param2 := VarToStr(GetInputArg(2));
Param3 := VarToStr(GetInputArg(3));
Param4 := VarToStr(GetInputArg(4));
Param5 := VarToStr(GetInputArg(5));
Param6 := VarToStr(GetInputArg(6));
Param7 := VarToStr(GetInputArg(7));
Param8 := VarToStr(GetInputArg(8));
AResult := FScriptUtils.SNactiAdresuZARES(VarToStr(GetInputArg(0)),Param1,Param2,Param3,Param4,Param5,Param6,Param7,Param8);
    ReturnOutputArg(AResult);
    SetInputArg(1,string(Param1));
    SetInputArg(2,string(Param2));
    SetInputArg(3,string(Param3));
    SetInputArg(4,string(Param4));
    SetInputArg(5,string(Param5));
    SetInputArg(6,string(Param6));
    SetInputArg(7,string(Param7));
    SetInputArg(8,string(Param8));
  end;
end;

procedure TatFScriptUtilsLibrary.__SNactiAdresuZARESD(AMachine: TatVirtualMachine);
  var
  Param1: string;
  Param2: string;
  Param3: string;
  Param4: string;
  Param5: string;
  Param6: string;
  Param7: string;
  Param8: string;
  Param9: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param1 := VarToStr(GetInputArg(1));
Param2 := VarToStr(GetInputArg(2));
Param3 := VarToStr(GetInputArg(3));
Param4 := VarToStr(GetInputArg(4));
Param5 := VarToStr(GetInputArg(5));
Param6 := VarToStr(GetInputArg(6));
Param7 := VarToStr(GetInputArg(7));
Param8 := VarToStr(GetInputArg(8));
Param9 := VarToStr(GetInputArg(9));
AResult := FScriptUtils.SNactiAdresuZARESD(VarToStr(GetInputArg(0)),Param1,Param2,Param3,Param4,Param5,Param6,Param7,Param8,Param9);
    ReturnOutputArg(AResult);
    SetInputArg(1,string(Param1));
    SetInputArg(2,string(Param2));
    SetInputArg(3,string(Param3));
    SetInputArg(4,string(Param4));
    SetInputArg(5,string(Param5));
    SetInputArg(6,string(Param6));
    SetInputArg(7,string(Param7));
    SetInputArg(8,string(Param8));
    SetInputArg(9,string(Param9));
  end;
end;

procedure TatFScriptUtilsLibrary.__ShowInfoARES(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.ShowInfoARES(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.ShowInfoARES(VarToStr(GetInputArg(0)),GetInputArg(1)));
3: AResult := string(FScriptUtils.ShowInfoARES(VarToStr(GetInputArg(0)),GetInputArg(1),GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__mtValuesClearFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.mtValuesClearFields;
  end;
end;

procedure TatFScriptUtilsLibrary.__ReplaceXmlStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.ReplaceXmlStr(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__TryEncodeDateTimeEx(AMachine: TatVirtualMachine);
  var
  Param7: TDateTime;
  AResult: variant;
begin
  with AMachine do
  begin
Param7 := GetInputArg(7);
AResult := FScriptUtils.TryEncodeDateTimeEx(VarToInteger(GetInputArg(0)),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)),VarToInteger(GetInputArg(4)),VarToInteger(GetInputArg(5)),VarToInteger(GetInputArg(6)),Param7);
    ReturnOutputArg(AResult);
    SetInputArg(7,Param7);
  end;
end;

procedure TatFScriptUtilsLibrary.__DateTimeStrEval(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.DateTimeStrEval(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetFillingInfo(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetFillingInfo);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__BP(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.BP(GetInputArg(0),VarToStr(GetInputArg(1)),GetInputArg(2),GetInputArg(3),GetInputArg(4),GetInputArg(5),GetInputArg(6),GetInputArg(7),GetInputArg(8),GetInputArg(9),GetInputArg(10));
  end;
end;

procedure TatFScriptUtilsLibrary.__ControlAndSendForm(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.ControlAndSendForm;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SaveFormWithoutCheck(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SaveFormWithoutCheck;
  end;
end;

procedure TatFScriptUtilsLibrary.__SizeOfFile(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.SizeOfFile(VarToStr(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetAdrClip(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GetAdrClip);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetGScriptFieldName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetGScriptFieldName;
  end;
end;

procedure TatFScriptUtilsLibrary.__IsPaymentInDB(AMachine: TatVirtualMachine);
  var
  Param0: integer;
  Param1: integer;
  Param2: integer;
  AResult: variant;
begin
  with AMachine do
  begin
Param0 := VarToInteger(GetInputArg(0));
Param1 := VarToInteger(GetInputArg(1));
Param2 := VarToInteger(GetInputArg(2));
AResult := FScriptUtils.IsPaymentInDB(Param0,Param1,Param2);
    ReturnOutputArg(AResult);
    SetInputArg(0,Integer(Param0));
    SetInputArg(1,Integer(Param1));
    SetInputArg(2,Integer(Param2));
  end;
end;

procedure TatFScriptUtilsLibrary.__DelPaymentInDB(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.DelPaymentInDB;
  end;
end;

procedure TatFScriptUtilsLibrary.__MsgAskYesNoCancel(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.MsgAskYesNoCancel(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),TMsgDlgBtn(VarToInteger(GetInputArg(2)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SaveDocumentToDB(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := string(FScriptUtils.SaveDocumentToDB(VarToStr(GetInputArg(0))));
2: AResult := string(FScriptUtils.SaveDocumentToDB(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1))));
3: AResult := string(FScriptUtils.SaveDocumentToDB(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2))));
4: AResult := string(FScriptUtils.SaveDocumentToDB(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3))));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__OpenWebPortalCSSZ(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.OpenWebPortalCSSZ(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SendFilesByEmailOrDS(AMachine: TatVirtualMachine);
  var
  Param5: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param5 := VarToStr(GetInputArg(5));
AResult := string(FScriptUtils.SendFilesByEmailOrDS(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),TStringList(VarToObject(GetInputArg(3))),GetInputArg(4),Param5));
    ReturnOutputArg(AResult);
    SetInputArg(5,string(Param5));
  end;
end;

procedure TatFScriptUtilsLibrary.__SelectEmailOrDS(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
0: AResult := string(FScriptUtils.SelectEmailOrDS);
1: AResult := string(FScriptUtils.SelectEmailOrDS(GetInputArg(0)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__PDFEditorPath(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.PDFEditorPath);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetOpenPDFEditorFlag(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetOpenPDFEditorFlag(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetOpenPDFEditorFlag(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.GetOpenPDFEditorFlag;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ShowProgress(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      1: FScriptUtils.ShowProgress(VarToInteger(GetInputArg(0)));
      2: FScriptUtils.ShowProgress(VarToInteger(GetInputArg(0)),VarToInteger(GetInputArg(1)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__CreateWtFields(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.CreateWtFields(VarToInteger(GetInputArg(0)),VarToStr(GetInputArg(1)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SaveWtToString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.SaveWtToString(VarToInteger(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__LoadWtFromString(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.LoadWtFromString(VarToInteger(GetInputArg(0)),VarToStr(GetInputArg(1)));
  end;
end;

procedure TatFScriptUtilsLibrary.__AppProcessMessages(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.AppProcessMessages;
  end;
end;

procedure TatFScriptUtilsLibrary.__CheckDotNet(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.CheckDotNet;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__RunDotNetStript(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      1: FScriptUtils.RunDotNetStript(VarToStr(GetInputArg(0)));
      2: FScriptUtils.RunDotNetStript(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)));
      3: FScriptUtils.RunDotNetStript(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2));
      4: FScriptUtils.RunDotNetStript(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),GetInputArg(2),VarToStr(GetInputArg(3)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__SaveAppendixToPDF(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.SaveAppendixToPDF);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__IsDotNetDetected(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.IsDotNetDetected(VarToStr(GetInputArg(0)),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ForceSaveNestedData(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.ForceSaveNestedData;
  end;
end;

procedure TatFScriptUtilsLibrary.__ForceCloseFA(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.ForceCloseFA;
  end;
end;

procedure TatFScriptUtilsLibrary.__SaveNewFormToDB(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.SaveNewFormToDB;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__LoadingStart(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      1: FScriptUtils.LoadingStart(VarToInteger(GetInputArg(0)));
      2: FScriptUtils.LoadingStart(VarToInteger(GetInputArg(0)),GetInputArg(1));
      3: FScriptUtils.LoadingStart(VarToInteger(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)));
      4: FScriptUtils.LoadingStart(VarToInteger(GetInputArg(0)),GetInputArg(1),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)));
    end;
  end;
end;

procedure TatFScriptUtilsLibrary.__LoadingStop(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.LoadingStop;
  end;
end;

procedure TatFScriptUtilsLibrary.__LoadingStep(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.LoadingStep;
  end;
end;

procedure TatFScriptUtilsLibrary.__LoadingBreakRequest(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.LoadingBreakRequest;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__ConvertFR3ToPDF(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.ConvertFR3ToPDF(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__DoCancelEditForm(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.DoCancelEditForm;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__EvalScript(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.EvalScript(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__EvalMethod(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.EvalMethod(VarToStr(GetInputArg(0))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__EvalParamMethod(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.EvalParamMethod(VarToStr(GetInputArg(0)),GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__CreateHBWithImportCSV(AMachine: TatVirtualMachine);
  var
  Param7: string;
  Param8: string;
  AResult: variant;
begin
  with AMachine do
  begin
Param7 := VarToStr(GetInputArg(7));
Param8 := VarToStr(GetInputArg(8));
AResult := FScriptUtils.CreateHBWithImportCSV(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)),VarToStr(GetInputArg(3)),VarToStr(GetInputArg(4)),VarToStr(GetInputArg(5)),VarToStr(GetInputArg(6)),Param7,Param8);
    ReturnOutputArg(AResult);
    SetInputArg(7,string(Param7));
    SetInputArg(8,string(Param8));
  end;
end;

procedure TatFScriptUtilsLibrary.__SendOrderFioAPI(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SendOrderFioAPI(VarToStr(GetInputArg(0)),VarToStr(GetInputArg(1)),VarToStr(GetInputArg(2)));
  end;
end;

procedure TatFScriptUtilsLibrary.__Gsl(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(FScriptUtils.Gsl);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GFillMemo(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GFillMemo);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptState(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.GScriptState);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptFieldName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GScriptFieldName);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptOldFieldName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GScriptOldFieldName);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGScriptState(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGScriptState(TScriptState(VarToInteger(GetInputArg(0))));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGScriptFieldName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGScriptFieldName(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGScriptOldFieldName(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGScriptOldFieldName(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__GGotoFieldName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GGotoFieldName);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptPreparedLists(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GScriptPreparedLists);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptGetFormsIDDefs(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GScriptGetFormsIDDefs);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptFldDisplayValue(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GScriptFldDisplayValue);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptZeroValueClear(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.GScriptZeroValueClear;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptFillingInfo(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GScriptFillingInfo);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GShowThousandSeparator(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.GShowThousandSeparator;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GSlaveState(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(FScriptUtils.GSlaveState);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GCheckGotoFldName(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GCheckGotoFldName);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GScriptFillingZip(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := FScriptUtils.GScriptFillingZip;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGScriptFillingZip(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGScriptFillingZip(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__GfodFrmID(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GfodFrmID);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GfodFrmDefID(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GfodFrmDefID);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GfodDocId(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GfodDocId);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GfodFiles(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GfodFiles);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__GfodGUID(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := string(FScriptUtils.GfodGUID);
    ReturnOutputArg(AResult);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGfodFrmID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGfodFrmID(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGfodFrmDefID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGfodFrmDefID(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGfodDocId(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGfodDocId(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGfodFiles(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGfodFiles(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetValueGfodGUID(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.SetValueGfodGUID(VarToStr(GetInputArg(0)));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetGInternalDataForPrint(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(FScriptUtils.GInternalDataForPrint));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetGInternalDataForPrint(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.GInternalDataForPrint:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetGEPOFilePath(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(FScriptUtils.GEPOFilePath));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetGEPOFilePath(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.GEPOFilePath:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.__GetGLoadingBreak(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(FScriptUtils.GLoadingBreak);
  end;
end;

procedure TatFScriptUtilsLibrary.__SetGLoadingBreak(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.GLoadingBreak:=GetInputArg(0);
  end;
end;

procedure TatFScriptUtilsLibrary.__GetFSelectedDir(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(FScriptUtils.FSelectedDir));
  end;
end;

procedure TatFScriptUtilsLibrary.__SetFSelectedDir(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    FScriptUtils.FSelectedDir:=VarToStr(GetInputArg(0));
  end;
end;

procedure TatFScriptUtilsLibrary.Init;
begin
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('Cal',2,tkNone,nil,__Cal,false,0,'AFieldName: string; AValue: variant');
    DefineMethod('CalN',2,tkNone,nil,__CalN,false,0,'AFieldName: string; AValue: variant');
    DefineMethod('Ini',2,tkNone,nil,__Ini,false,0,'AFieldName: string; AValue: variant');
    DefineMethod('Ino',2,tkNone,nil,__Ino,false,0,'AFieldName: string; AValue: variant');
    DefineMethod('Def',2,tkNone,nil,__Def,false,0,'AFieldName: string; AValue: variant');
    DefineMethod('Ena',2,tkNone,nil,__Ena,false,0,'AFieldName: string; ACond: boolean');
    DefineMethod('Chk',4,tkNone,nil,__Chk,false,1,'AFieldName: string; ACond: boolean; AMsg: string; AKind: integer = 0');
    DefineMethod('Lst',6,tkNone,nil,__Lst,false,2,'AFieldName: string; AListName: string; AForDate: TDateTime; AListFieldName: string; AColumns: string = ''''; AFilter: string = ''''');
    DefineMethod('SimpleLst',7,tkNone,nil,__SimpleLst,false,5,'AFieldName: string; AListValues: string; AColumnsWidth: string = ''''; AResultColumnIndex: integer = 0; ACaption: string = ''''; AColumnNames: string = ''''; AInitValue: string = ''''');
    DefineMethod('IsValueInSimpleList',3,tkVariant,nil,__IsValueInSimpleList,false,1,'AValue: string; AListValues: string; AColumnIndex: integer = 0');
    DefineMethod('DoOpenSimpleList',6,tkVariant,nil,__DoOpenSimpleList,false,4,'AListValues: string; AValue: string; AColumnsWidth: string = ''''; AResultColumnIndex: integer = 0; ACaption: string = ''''; AColumnNames: string = ''''');
    DefineMethod('GotoFld',1,tkNone,nil,__GotoFld,false,0,'AFieldName: string');
    DefineMethod('GotoAppendix',0,tkNone,nil,__GotoAppendix,false,0,'');
    DefineMethod('LstLookup',5,tkVariant,nil,__LstLookup,false,0,'AListName: string; AForDate: TDateTime; AKeyFieldNames: string; AkeyFieldValues: variant; AResultFieldName: string');
    DefineMethod('OpenLst',6,tkVariant,nil,__OpenLst,false,1,'AListName: string; AForDate: TDateTime; AKeyFieldNames: string; AkeyFieldValues: variant; AResultFieldName: string; AColumns: string = ''''');
    DefineMethod('WebList2CSV',5,tkVariant,nil,__WebList2CSV,false,0,'AUrl: string; AColumns: string; AHeader: string; AList: string; AMsg: string').SetVarArgs([2,3,4]);
    DefineMethod('LoadListToWT',3,tkVariant,nil,__LoadListToWT,false,0,'AListName: string; AForDate: TDateTime; AWtNumber: Integer');
    DefineMethod('ClientParam',2,tkVariant,nil,__ClientParam,false,1,'AParamName: string; ABankAccountIndex: integer = 0');
    DefineMethod('GetClientParams',0,tkVariant,nil,__GetClientParams,false,0,'');
    DefineMethod('FormExists',1,tkVariant,nil,__FormExists,false,0,'AFormName: string');
    DefineMethod('GetFormDataText',1,tkVariant,nil,__GetFormDataText,false,0,'AFormName: string');
    DefineMethod('GetFormField',2,tkVariant,nil,__GetFormField,false,0,'AFormName: string; AFieldName: string');
    DefineMethod('SetDataFormField',3,tkVariant,nil,__SetDataFormField,false,0,'ADataString: string; AFieldName: string; AFieldValue: string');
    DefineMethod('TakeFormFields',3,tkNone,nil,__TakeFormFields,false,1,'AFormName: string; AFieldList: string; AExcudeFieldList: string = ''''');
    DefineMethod('GetForms',4,tkVariant,nil,__GetForms,false,3,'ADefID: string; AMultiselect: boolean = FALSE; ACaption: string = ''''; AOrder: string = ''''');
    DefineMethod('GetFormCount',1,tkInteger,nil,__GetFormCount,false,0,'ADefID: string');
    DefineMethod('GetFormsOrDocuments',7,tkVariant,nil,__GetFormsOrDocuments,false,7,'AMultiSelect: boolean = FALSE; ACaption: string = ''''; ASelectDefId: string = ''''; AShowFrm: boolean = true; AShowDoc: boolean = false; AShowOpenDlg: boolean = false; AShowBtnZrusit: Boolean = True');
    DefineMethod('GetDoc',1,tkVariant,nil,__GetDoc,false,0,'AIDDoc: integer');
    DefineMethod('RunAsStandalone',0,tkVariant,nil,__RunAsStandalone,false,0,'');
    DefineMethod('ShowChecking',3,tkVariant,nil,__ShowChecking,false,3,'AShowOK: boolean = FALSE; AShowDifs: boolean = FALSE; AForceTipEP: Boolean = FALSE');
    DefineMethod('DisplayCheck',0,tkNone,nil,__DisplayCheck,false,0,'');
    DefineMethod('GetAlgVykaz',2,tkVariant,nil,__GetAlgVykaz,false,0,'AVykazID: string; AVTisicich: boolean');
    DefineMethod('VykazExists',1,tkVariant,nil,__VykazExists,false,0,'AVykazID: string');
    DefineMethod('SavePaymentRec',10,tkVariant,nil,__SavePaymentRec,false,7,'ADatePayment: TDateTime; AText: string; AValue: double; AAccount: string = ''''; ABank: string = ''''; ASpecSym: string = ''''; AVarSym: string = ''''; AKonSym: string = ''''; AIBAN: string = ''''; ASwift: string = ''''');
    DefineMethod('CreatePaymentOrder',8,tkNone,nil,__CreatePaymentOrder,false,1,'ADatePayment: TDateTime; AValue: double; AAccount: string; AVarSym: string; AConSym: string; ASpecSym: string; AText: string; APaymentOrderDefID: string = ''''');
    DefineMethod('CreatePaymentOrderSEPA',14,tkNone,nil,__CreatePaymentOrderSEPA,false,9,'ADatePayment: TDateTime; AValue: double; AIban: string; ASwift: string; AVarSym: string; AConSym: string = ''''; ASpecSym: string = ''''; APrijemce: string = ''''; AReference: string = ''''; AInformace: string = ''''; ' + 'APlatebniTitul: string = ''''; APaymentOrderDefID: string = ''''; ASenderIban: string = ''''; ASenderSwift: string = ''''');
    DefineMethod('CreateOpenNewForm',2,tkVariant,nil,__CreateOpenNewForm,false,0,'ADefID: string; AData: string');
    DefineMethod('OpenSavedForm',1,tkNone,nil,__OpenSavedForm,false,0,'AGuidOrStandaloneFileName: string');
    DefineMethod('SaveRepresentationRec',7,tkNone,nil,__SaveRepresentationRec,false,0,'AType: string; AForOffice: string; ASubject: string; AGeneration: boolean; AValidityFrom: TDateTime; AValidityTo: TDateTime; AComment: string');
    DefineMethod('UniParUpdate',4,tkNone,nil,__UniParUpdate,false,0,'AParamId: string; ASkupina: string; APopis: string; AHodnota: string');
    DefineMethod('FormBind',3,tkNone,nil,__FormBind,false,0,'AFrmGUID: string; AMasterGUID: string; AMsgErr: string').SetVarArgs([2]);
    DefineMethod('WriteValue2Form',4,tkVariant,nil,__WriteValue2Form,false,0,'AFrmGUID: string; AFieldName: string; AValue: string; AMsgErr: string').SetVarArgs([3]);
    DefineMethod('AddStrLine',2,tkNone,nil,__AddStrLine,false,0,'AStr: string; AAddedStrLine: string').SetVarArgs([0]);
    DefineMethod('EncDate',3,tkVariant,nil,__EncDate,false,3,'AYear: Word = 0; AMonth: Word = 1; ADay: Word = 1');
    DefineMethod('CalcFullAddress',8,tkVariant,nil,__CalcFullAddress,false,0,'AUlice: string; ACisloPopisne: string; APOBox: string; APSC: string; AMisto: string; AOkres: string; AStat: string; AMultiLine: boolean');
    DefineMethod('CalcFullName',5,tkVariant,nil,__CalcFullName,false,1,'ATitul: string; AJmeno: string; APrijmeni: string; ARodnePrijmeni: string; AHodnost: string = ''''');
    DefineMethod('CalcPhoneMobil',2,tkVariant,nil,__CalcPhoneMobil,false,0,'ATelefon: string; AMobil: string');
    DefineMethod('ExtractBeforeChar',2,tkVariant,nil,__ExtractBeforeChar,false,1,'AStr: string; AChar: string = ''/''');
    DefineMethod('ExtractAfterChar',2,tkVariant,nil,__ExtractAfterChar,false,1,'AStr: string; AChar: string = ''/''');
    DefineMethod('CalcFullBaAccount',3,tkVariant,nil,__CalcFullBaAccount,false,1,'ABankAccount: string; ABankCode: string; ASpecSym: string = ''''');
    DefineMethod('SplitAddress',4,tkNone,nil,__SplitAddress,false,0,'AAdresa: string; AUlice: string; APSC: string; AMisto: string').SetVarArgs([1,2,3]);
    DefineMethod('StreetFromAddress',1,tkVariant,nil,__StreetFromAddress,false,0,'AAdresa: string');
    DefineMethod('ZipCodeFromAddress',1,tkVariant,nil,__ZipCodeFromAddress,false,0,'AAdresa: string');
    DefineMethod('CityFromAddress',1,tkVariant,nil,__CityFromAddress,false,0,'AAdresa: string');
    DefineMethod('NormalZipCodeCzech',1,tkVariant,nil,__NormalZipCodeCzech,false,0,'APSC: string');
    DefineMethod('ExtractBankAccount',1,tkVariant,nil,__ExtractBankAccount,false,0,'ABankAccount: string');
    DefineMethod('ExtractBankCode',1,tkVariant,nil,__ExtractBankCode,false,0,'ABankAccount: string');
    DefineMethod('ExtractStreetFromStreetAndNum',1,tkVariant,nil,__ExtractStreetFromStreetAndNum,false,0,'AStreetAndNum: string');
    DefineMethod('ExtractNumberFromStreetAndNum',1,tkVariant,nil,__ExtractNumberFromStreetAndNum,false,0,'AStreetAndNum: string');
    DefineMethod('NameOfMonth',2,tkVariant,nil,__NameOfMonth,false,1,'AMonth: integer; ALowerCase: boolean = FALSE');
    DefineMethod('NameOfMonth2',2,tkVariant,nil,__NameOfMonth2,false,1,'AMonth: integer; ALowerCase: boolean = FALSE');
    DefineMethod('GetValidDateStr',2,tkVariant,nil,__GetValidDateStr,false,1,'ADate: TDateTime; ADateString: string = ''''');
    DefineMethod('GetValidDateStrFmt',2,tkVariant,nil,__GetValidDateStrFmt,false,1,'ADate: TDateTime; AFmt: string = ''DD.MM.YYYY''');
    DefineMethod('ValidValue',3,tkVariant,nil,__ValidValue,false,1,'ASrcFieldNames: string; AValue: Variant; AZeroValueClear: boolean = FALSE');
    DefineMethod('ClearField',1,tkNone,nil,__ClearField,false,0,'AFieldName: string');
    DefineMethod('CalcPeriod',1,tkVariant,nil,__CalcPeriod,false,0,'APeriod: string');
    DefineMethod('PreviewSimpleReport',1,tkNone,nil,__PreviewSimpleReport,false,0,'AReportName: string');
    DefineMethod('ShowInstruction',1,tkNone,nil,__ShowInstruction,false,0,'AFieldName: string');
    DefineMethod('AmountByWords',2,tkVariant,nil,__AmountByWords,false,1,'AValue: extended; AUpperFirstChar: boolean = FALSE');
    DefineMethod('TryEditValuesRecord',0,tkNone,nil,__TryEditValuesRecord,false,0,'');
    DefineMethod('TryPostValuesRecord',0,tkNone,nil,__TryPostValuesRecord,false,0,'');
    DefineMethod('MsgBoxErr',3,tkInteger,nil,__MsgBoxErr,false,0,'ACaption: string; AMsg: string; AFlags: longint');
    DefineMethod('MsgBoxWarn',3,tkInteger,nil,__MsgBoxWarn,false,0,'ACaption: string; AMsg: string; AFlags: longint');
    DefineMethod('MsgBoxAsk',3,tkInteger,nil,__MsgBoxAsk,false,0,'ACaption: string; AMsg: string; AFlags: longint');
    DefineMethod('MsgBoxInfo',3,tkInteger,nil,__MsgBoxInfo,false,0,'ACaption: string; AMsg: string; AFlags: longint');
    DefineMethod('MsgBoxAskButtons',9,tkInteger,nil,__MsgBoxAskButtons,false,4,'ACaption: string; AMsg: string; ABtn1Text: string; ABtn2Text: string; ABtn3Text: string; ADefaultBtn: Integer = 1; ABtnWidth: Integer = 100; ADlgType: integer = 3; ADlgWidth: Integer = 0');
    DefineMethod('Msg',1,tkNone,nil,__Msg,false,0,'AMessage: string');
    DefineMethod('Msgv',1,tkNone,nil,__Msgv,false,0,'AMessage: variant');
    DefineMethod('InitScriptGVariables',0,tkNone,nil,__InitScriptGVariables,false,0,'');
    DefineMethod('CreatePrintDataForTable',5,tkVariant,nil,__CreatePrintDataForTable,false,1,'ATableDataText: string; ADPFFileName: string; ARowsInPriloha: integer; AShiftRows: integer; APageCount: integer = -1');
    DefineMethod('SetFormData',1,tkNone,nil,__SetFormData,false,0,'AData: string');
    DefineMethod('SetChangeFlag',1,tkNone,nil,__SetChangeFlag,false,0,'AWasChange: boolean');
    DefineMethod('GetChangeFlag',0,tkVariant,nil,__GetChangeFlag,false,0,'');
    DefineMethod('SetLockFlag',1,tkNone,nil,__SetLockFlag,false,0,'ALock: boolean');
    DefineMethod('GetLockFlag',0,tkVariant,nil,__GetLockFlag,false,0,'');
    DefineMethod('GetAppendixString',0,tkVariant,nil,__GetAppendixString,false,0,'');
    DefineMethod('GetNotesString',0,tkVariant,nil,__GetNotesString,false,0,'');
    DefineMethod('GetCommentString',0,tkVariant,nil,__GetCommentString,false,0,'');
    DefineMethod('SetDoEnableAfterCalculate',1,tkNone,nil,__SetDoEnableAfterCalculate,false,0,'ADoEnableAfterCalculate: boolean');
    DefineMethod('GetMTVField',1,tkClass,TField,__GetMTVField,false,0,'AFieldName: string');
    DefineMethod('GetMTVFieldValue',2,tkVariant,nil,__GetMTVFieldValue,false,0,'AFieldName: string; AValueType: string');
    DefineMethod('GetNestedSection',2,tkVariant,nil,__GetNestedSection,false,0,'AData: string; ASectionName: string');
    DefineMethod('AddNestedSection',3,tkVariant,nil,__AddNestedSection,false,0,'AData: string; ASectionName: string; ASectionData: string');
    DefineMethod('ReplaceNestedSection',3,tkVariant,nil,__ReplaceNestedSection,false,0,'AData: string; ASectionName: string; ASectionData: string');
    DefineMethod('DeleteNestedSection',2,tkVariant,nil,__DeleteNestedSection,false,0,'AData: string; ASectionName: string');
    DefineMethod('GetFormFieldCompactNested',3,tkVariant,nil,__GetFormFieldCompactNested,false,0,'AData: string; ANestedSectionName: string; AFieldName: string');
    DefineMethod('DoOpenNestedForm',5,tkVariant,nil,__DoOpenNestedForm,false,0,'ANestedFormID: integer; ADefID: string; AData: string; AAddedData: string; ALevel: integer');
    DefineMethod('DoPrepareReportNestedForm',5,tkVariant,nil,__DoPrepareReportNestedForm,false,0,'ANestedFormID: integer; ADefID: string; AData: string; ALevel: integer; ADstFileName: string');
    DefineMethod('NestedState',0,tkVariant,nil,__NestedState,false,0,'');
    DefineMethod('ReloadListBoxes',0,tkNone,nil,__ReloadListBoxes,false,0,'');
    DefineMethod('GetListBoxItemIndex',1,tkInteger,nil,__GetListBoxItemIndex,false,0,'AListBoxName: string');
    DefineMethod('SetListBoxItemIndex',2,tkNone,nil,__SetListBoxItemIndex,false,0,'AListBoxName: string; AItemIndex: integer');
    DefineMethod('GetListBoxItemString',2,tkVariant,nil,__GetListBoxItemString,false,0,'AListBoxName: string; AItemIndex: integer');
    DefineMethod('SetListBoxItemString',3,tkNone,nil,__SetListBoxItemString,false,0,'AListBoxName: string; AItemIndex: integer; AItemString: string');
    DefineMethod('GetListBoxItemCount',1,tkInteger,nil,__GetListBoxItemCount,false,0,'AListBoxName: string');
    DefineMethod('AskInt',3,tkEnumeration,nil,__AskInt,false,0,'ACaption: string; ALabel: string; AValue: integer').SetVarArgs([2]);
    DefineMethod('AskFloat',3,tkEnumeration,nil,__AskFloat,false,0,'ACaption: string; ALabel: string; AValue: double').SetVarArgs([2]);
    DefineMethod('AskStr',3,tkEnumeration,nil,__AskStr,false,0,'ACaption: string; ALabel: string; AValue: string').SetVarArgs([2]);
    DefineMethod('AskStrV',6,tkEnumeration,nil,__AskStrV,false,0,'ACaption: string; ALabel: string; AValue: string; ALeft: integer; ATop: integer; ACorectionWidth: integer').SetVarArgs([2]);
    DefineMethod('AskMemo',3,tkEnumeration,nil,__AskMemo,false,0,'ACaption: string; ALabel: string; AValue: string').SetVarArgs([2]);
    DefineMethod('AskMemoV',6,tkEnumeration,nil,__AskMemoV,false,0,'ACaption: string; ALabel: string; AValue: string; ALeft: integer; ATop: integer; ACorectionWidth: integer').SetVarArgs([2]);
    DefineMethod('AskIntInt',5,tkEnumeration,nil,__AskIntInt,false,0,'ACaption: string; ALabel1: string; AValue1: integer; ALabel2: string; AValue2: integer').SetVarArgs([2,4]);
    DefineMethod('AskDate',3,tkEnumeration,nil,__AskDate,false,0,'ACaption: string; ALabel: string; AValue: TDate').SetVarArgs([2]);
    DefineMethod('AskDateDate',5,tkEnumeration,nil,__AskDateDate,false,0,'ACaption: string; ALabel1: string; AValue1: TDate; ALabel2: string; AValue2: TDate').SetVarArgs([2,4]);
    DefineMethod('ClearTskpFillingInfo',0,tkNone,nil,__ClearTskpFillingInfo,false,0,'');
    DefineMethod('BinaryFileToStringBase64',1,tkVariant,nil,__BinaryFileToStringBase64,false,0,'AFileName: string');
    DefineMethod('StringBase64ToBinaryFile',2,tkNone,nil,__StringBase64ToBinaryFile,false,0,'AStrBase64: string; AFileName: string');
    DefineMethod('BinaryFileToStringMime',1,tkVariant,nil,__BinaryFileToStringMime,false,0,'AFileName: string');
    DefineMethod('StringMimeToBinaryFile',2,tkNone,nil,__StringMimeToBinaryFile,false,0,'AString: string; AFileName: string');
    DefineMethod('SetMultilineOpenDialog',1,tkNone,nil,__SetMultilineOpenDialog,false,0,'AMultiline: boolean');
    DefineMethod('SelectClientAdress',6,tkVariant,nil,__SelectClientAdress,false,6,'AColumns: string = ''''; ATypeOffice: string = ''''; AShowSave2Disc: boolean = false; ADefAdrNazev: string = ''''; ADefAdrIdDs: string = ''''; ADefAdrEmail: string = ''''');
    DefineMethod('SelectClientPerson',1,tkVariant,nil,__SelectClientPerson,false,1,'AColumns: string = ''''');
    DefineMethod('SelectClientBankAccount',1,tkVariant,nil,__SelectClientBankAccount,false,1,'AColumns: string = ''''');
    DefineMethod('SelectAttachments',4,tkVariant,nil,__SelectAttachments,false,0,'AData: string; AIdOut: string; ATypeOut: string; ADataOut: string').SetVarArgs([1,2,3]);
    DefineMethod('SetFormUserSettingPrintAppendix',1,tkNone,nil,__SetFormUserSettingPrintAppendix,false,0,'AValue: boolean');
    DefineMethod('SetFormUserSettingPrintFromPage',1,tkNone,nil,__SetFormUserSettingPrintFromPage,false,0,'AValue: integer');
    DefineMethod('PrepareReportFilePages',2,tkVariant,nil,__PrepareReportFilePages,false,1,'ADstFileName: string; AFromPage: Integer = 0');
    DefineMethod('GetReportSettings',0,tkVariant,nil,__GetReportSettings,false,0,'');
    DefineMethod('FuncVersion',0,tkInteger,nil,__FuncVersion,false,0,'');
    DefineMethod('GetLicProductionNumber',0,tkVariant,nil,__GetLicProductionNumber,false,0,'');
    DefineMethod('InsertLogoToPDF',6,tkNone,nil,__InsertLogoToPDF,false,3,'APDFName: string; APosX: integer; APosY: integer; AWidthMax: integer = 100; AheightMax: integer = 80; AImgPath: string = ''''');
    DefineMethod('GetLogoPath',0,tkVariant,nil,__GetLogoPath,false,0,'');
    DefineMethod('InsertQRCodeToPDF',14,tkNone,nil,__InsertQRCodeToPDF,false,2,'APDFName: string; APosX: integer; APosY: integer; AIBAN: string; ABU: string; ACastka: double; AMenaUctu: string; APlatce: string; AVarSym: string; ASpecSym: string; AKonSym: string; AZpravaPrijemci: string; AWidth: integer = 200; ' + 'AHeight: integer = 200');
    DefineMethod('InsertQRCodeTextToPDF',6,tkNone,nil,__InsertQRCodeTextToPDF,false,2,'APDFName: string; APosX: integer; APosY: integer; AText: string; AWidth: integer = 200; AHeight: integer = 200');
    DefineMethod('InsertBarCodeToPDF',8,tkNone,nil,__InsertBarCodeToPDF,false,3,'APDFName: string; APosX: integer; APosY: integer; ABarCodeText: string; ABarCodeType: string; AWidth: integer = 200; AHeight: integer = 200; AAngle: double = 0.0');
    DefineMethod('PackPDF',2,tkNone,nil,__PackPDF,false,0,'APDFNameIn: string; APDFNameOut: string');
    DefineMethod('CreateFDFFile',3,tkNone,nil,__CreateFDFFile,false,0,'AFDFString: string; APDFFileName: string; ATargetFileName: string');
    DefineMethod('EncodeFDFString',1,tkVariant,nil,__EncodeFDFString,false,0,'AStr: string');
    DefineMethod('GetTxtFileFromFDR',1,tkVariant,nil,__GetTxtFileFromFDR,false,0,'AFileName: string');
    DefineMethod('DoPrintForm',4,tkNone,nil,__DoPrintForm,false,0,'AFormData: string; ASendMail: boolean; AOnlyPrepareFile: boolean; AOutPDFFileName: string').SetVarArgs([3]);
    DefineMethod('mtWorkSaveToString',0,tkVariant,nil,__mtWorkSaveToString,false,0,'');
    DefineMethod('mtWorkLoadFromString',1,tkNone,nil,__mtWorkLoadFromString,false,0,'str: string');
    DefineMethod('GetDirWorkPath',0,tkVariant,nil,__GetDirWorkPath,false,0,'');
    DefineMethod('GetExeFilePath',0,tkVariant,nil,__GetExeFilePath,false,0,'');
    DefineMethod('DoCopyFile',2,tkVariant,nil,__DoCopyFile,false,0,'ASourceFileName: string; ADestinationFileName: string');
    DefineMethod('VyberCertifikat',4,tkVariant,nil,__VyberCertifikat,false,0,'AHash: string; ASubject: string; AFullSubject: string; ACertifikat: string').SetVarArgs([0,1,2,3]);
    DefineMethod('FloatFieldIntPartStr',2,tkVariant,nil,__FloatFieldIntPartStr,false,1,'AFieldName: string; AFormatFloat: boolean = TRUE');
    DefineMethod('FloatFieldFracPartStr',2,tkVariant,nil,__FloatFieldFracPartStr,false,1,'AFieldName: string; ADigit: integer = -2');
    DefineMethod('StartCounterZero',0,tkVariant,nil,__StartCounterZero,false,0,'');
    DefineMethod('Utf8ToAnsiString',1,tkVariant,nil,__Utf8ToAnsiString,false,0,'str: string');
    DefineMethod('SelectDir',3,tkVariant,nil,__SelectDir,false,0,'Caption: string; Root: WideString; Directory: string').SetVarArgs([2]);
    DefineMethod('GetPDS',1,tkVariant,nil,__GetPDS,false,1,'APDSFileName: string = ''''');
    DefineMethod('SCheckVAT',3,tkInteger,nil,__SCheckVAT,false,0,'countrycode: string; vatno: string; vysledek: string').SetVarArgs([2]);
    DefineMethod('SCheckPlatce',2,tkInteger,nil,__SCheckPlatce,false,0,'vatno: string; vysledek: string').SetVarArgs([1]);
    DefineMethod('SNactiAdresuZARES',9,tkVariant,nil,__SNactiAdresuZARES,false,0,'AICO: string; ATypOsoby: string; ANazevFirmy: string; AUlice: string; ACisloPop: string; ACisloOrientacni: string; AObec: string; APSC: string; AMsg: string').SetVarArgs([1,2,3,4,5,6,7,8]);
    DefineMethod('SNactiAdresuZARESD',10,tkVariant,nil,__SNactiAdresuZARESD,false,0,'AICO: string; ATypOsoby: string; ANazevFirmy: string; AUlice: string; ACisloPop: string; ACisloOrientacni: string; AObec: string; APSC: string; ADIC: string; AMsg: string').SetVarArgs([1,2,3,4,5,6,7,8,9]);
    DefineMethod('ShowInfoARES',3,tkVariant,nil,__ShowInfoARES,false,2,'AICO: string; AMsgAsk: Boolean = false; AWithCreditCheck: Boolean = False');
    DefineMethod('mtValuesClearFields',0,tkNone,nil,__mtValuesClearFields,false,0,'');
    DefineMethod('ReplaceXmlStr',1,tkVariant,nil,__ReplaceXmlStr,false,0,'AStr: string');
    DefineMethod('TryEncodeDateTimeEx',8,tkVariant,nil,__TryEncodeDateTimeEx,false,0,'AYear: word; AMonth: word; ADay: word; AHour: word; AMinute: word; ASecond: word; AMilliSecond: word; AValue: TDateTime').SetVarArgs([7]);
    DefineMethod('DateTimeStrEval',2,tkVariant,nil,__DateTimeStrEval,false,0,'DateTimeFormat: string; DateTimeStr: string');
    DefineMethod('GetFillingInfo',0,tkVariant,nil,__GetFillingInfo,false,0,'');
    DefineMethod('BP',11,tkNone,nil,__BP,false,0,'AEnabled: boolean; ABpID: string; AVar1: variant; AVar2: variant; AVar3: variant; AVar4: variant; AVar5: variant; AVar6: variant; AVar7: variant; AVar8: variant; AVar9: variant');
    DefineMethod('ControlAndSendForm',0,tkVariant,nil,__ControlAndSendForm,false,0,'');
    DefineMethod('SaveFormWithoutCheck',0,tkNone,nil,__SaveFormWithoutCheck,false,0,'');
    DefineMethod('SizeOfFile',1,tkVariant,nil,__SizeOfFile,false,0,'AFilePath: string');
    DefineMethod('GetAdrClip',0,tkVariant,nil,__GetAdrClip,false,0,'');
    DefineMethod('SetGScriptFieldName',0,tkNone,nil,__SetGScriptFieldName,false,0,'');
    DefineMethod('IsPaymentInDB',3,tkVariant,nil,__IsPaymentInDB,false,0,'APayCnt: integer; ASendPayCnt: integer; APaidPayCnt: integer').SetVarArgs([0,1,2]);
    DefineMethod('DelPaymentInDB',0,tkNone,nil,__DelPaymentInDB,false,0,'');
    DefineMethod('MsgAskYesNoCancel',3,tkInteger,nil,__MsgAskYesNoCancel,false,0,'ACaption: string; AMsg: string; ADefBtn: TMsgDlgBtn');
    DefineMethod('SaveDocumentToDB',4,tkVariant,nil,__SaveDocumentToDB,false,3,'APath: string; ANazevDokumentu: string = ''''; AComment: string = ''''; ACommentMemo: string = ''''');
    DefineMethod('OpenWebPortalCSSZ',1,tkNone,nil,__OpenWebPortalCSSZ,false,0,'fn: string');
    DefineMethod('SendFilesByEmailOrDS',6,tkVariant,nil,__SendFilesByEmailOrDS,false,0,'AMailAddr: string; ASubject: string; ABody: string; AAttachmentsFileNames: TStringList; AShowDialog: boolean; AErrorMsg: string').SetVarArgs([5]);
    DefineMethod('SelectEmailOrDS',1,tkVariant,nil,__SelectEmailOrDS,false,1,'AOnlyEmail: Boolean = False');
    DefineMethod('PDFEditorPath',0,tkVariant,nil,__PDFEditorPath,false,0,'');
    DefineMethod('SetOpenPDFEditorFlag',1,tkNone,nil,__SetOpenPDFEditorFlag,false,0,'AIsOpen: Boolean');
    DefineMethod('GetOpenPDFEditorFlag',0,tkVariant,nil,__GetOpenPDFEditorFlag,false,0,'');
    DefineMethod('ShowProgress',2,tkNone,nil,__ShowProgress,false,1,'APos: Integer; AMax: Integer = 100');
    DefineMethod('CreateWtFields',2,tkNone,nil,__CreateWtFields,false,0,'ATableNameCis: integer; AFieldNames: string');
    DefineMethod('SaveWtToString',1,tkVariant,nil,__SaveWtToString,false,0,'ATableNameCis: integer');
    DefineMethod('LoadWtFromString',2,tkNone,nil,__LoadWtFromString,false,0,'ATableNameCis: integer; str: string');
    DefineMethod('AppProcessMessages',0,tkNone,nil,__AppProcessMessages,false,0,'');
    DefineMethod('CheckDotNet',0,tkVariant,nil,__CheckDotNet,false,0,'');
    DefineMethod('RunDotNetStript',4,tkNone,nil,__RunDotNetStript,false,3,'AScript: string; AParams: string = ''''; ACscs: Boolean = False; AParamsRef: string = ''''');
    DefineMethod('SaveAppendixToPDF',0,tkVariant,nil,__SaveAppendixToPDF,false,0,'');
    DefineMethod('IsDotNetDetected',2,tkVariant,nil,__IsDotNetDetected,false,0,'version: string; service: integer');
    DefineMethod('ForceSaveNestedData',0,tkNone,nil,__ForceSaveNestedData,false,0,'');
    DefineMethod('ForceCloseFA',0,tkNone,nil,__ForceCloseFA,false,0,'');
    DefineMethod('SaveNewFormToDB',0,tkVariant,nil,__SaveNewFormToDB,false,0,'');
    DefineMethod('LoadingStart',4,tkNone,nil,__LoadingStart,false,3,'AStepCount: Integer; AEnableBreak: Boolean = False; ACaption: string = ''''; AText: string = ''''');
    DefineMethod('LoadingStop',0,tkNone,nil,__LoadingStop,false,0,'');
    DefineMethod('LoadingStep',0,tkNone,nil,__LoadingStep,false,0,'');
    DefineMethod('LoadingBreakRequest',0,tkVariant,nil,__LoadingBreakRequest,false,0,'');
    DefineMethod('ConvertFR3ToPDF',1,tkVariant,nil,__ConvertFR3ToPDF,false,0,'AReportFileNameCsvList: string');
    DefineMethod('DoCancelEditForm',0,tkVariant,nil,__DoCancelEditForm,false,0,'');
    DefineMethod('EvalScript',1,tkVariant,nil,__EvalScript,false,0,'AStrValue: string');
    DefineMethod('EvalMethod',1,tkVariant,nil,__EvalMethod,false,0,'AMethodName: string');
    DefineMethod('EvalParamMethod',2,tkVariant,nil,__EvalParamMethod,false,0,'AMethodName: string; AParam: variant');
    DefineMethod('CreateHBWithImportCSV',9,tkVariant,nil,__CreateHBWithImportCSV,false,0,'ABaUcet: string; AKodBanky: string; AFormatHB: string; APrevPrikCsv: string; APrevPrikPCsv: string; ABoFirmaCsv: string; AFirmaUctCsv: string; AOutText: string; AMsg: string').SetVarArgs([7,8]);
    DefineMethod('SendOrderFioAPI',3,tkNone,nil,__SendOrderFioAPI,false,0,'AXmlFile: string; AFileFormat: string; AToken: string');
    DefineMethod('Gsl',0,tkClass,TStringList,__Gsl,false,0,'');
    DefineMethod('GFillMemo',0,tkVariant,nil,__GFillMemo,false,0,'');
    DefineMethod('GScriptState',0,tkEnumeration,nil,__GScriptState,false,0,'');
    DefineMethod('GScriptFieldName',0,tkVariant,nil,__GScriptFieldName,false,0,'');
    DefineMethod('GScriptOldFieldName',0,tkVariant,nil,__GScriptOldFieldName,false,0,'');
    DefineMethod('SetValueGScriptState',1,tkNone,nil,__SetValueGScriptState,false,0,'value: TScriptState');
    DefineMethod('SetValueGScriptFieldName',1,tkNone,nil,__SetValueGScriptFieldName,false,0,'value: string');
    DefineMethod('SetValueGScriptOldFieldName',1,tkNone,nil,__SetValueGScriptOldFieldName,false,0,'value: string');
    DefineMethod('GGotoFieldName',0,tkVariant,nil,__GGotoFieldName,false,0,'');
    DefineMethod('GScriptPreparedLists',0,tkVariant,nil,__GScriptPreparedLists,false,0,'');
    DefineMethod('GScriptGetFormsIDDefs',0,tkVariant,nil,__GScriptGetFormsIDDefs,false,0,'');
    DefineMethod('GScriptFldDisplayValue',0,tkVariant,nil,__GScriptFldDisplayValue,false,0,'');
    DefineMethod('GScriptZeroValueClear',0,tkVariant,nil,__GScriptZeroValueClear,false,0,'');
    DefineMethod('GScriptFillingInfo',0,tkVariant,nil,__GScriptFillingInfo,false,0,'');
    DefineMethod('GShowThousandSeparator',0,tkVariant,nil,__GShowThousandSeparator,false,0,'');
    DefineMethod('GSlaveState',0,tkEnumeration,nil,__GSlaveState,false,0,'');
    DefineMethod('GCheckGotoFldName',0,tkVariant,nil,__GCheckGotoFldName,false,0,'');
    DefineMethod('GScriptFillingZip',0,tkVariant,nil,__GScriptFillingZip,false,0,'');
    DefineMethod('SetValueGScriptFillingZip',1,tkNone,nil,__SetValueGScriptFillingZip,false,0,'value: boolean');
    DefineMethod('GfodFrmID',0,tkVariant,nil,__GfodFrmID,false,0,'');
    DefineMethod('GfodFrmDefID',0,tkVariant,nil,__GfodFrmDefID,false,0,'');
    DefineMethod('GfodDocId',0,tkVariant,nil,__GfodDocId,false,0,'');
    DefineMethod('GfodFiles',0,tkVariant,nil,__GfodFiles,false,0,'');
    DefineMethod('GfodGUID',0,tkVariant,nil,__GfodGUID,false,0,'');
    DefineMethod('SetValueGfodFrmID',1,tkNone,nil,__SetValueGfodFrmID,false,0,'value: string');
    DefineMethod('SetValueGfodFrmDefID',1,tkNone,nil,__SetValueGfodFrmDefID,false,0,'value: string');
    DefineMethod('SetValueGfodDocId',1,tkNone,nil,__SetValueGfodDocId,false,0,'value: string');
    DefineMethod('SetValueGfodFiles',1,tkNone,nil,__SetValueGfodFiles,false,0,'value: string');
    DefineMethod('SetValueGfodGUID',1,tkNone,nil,__SetValueGfodGUID,false,0,'value: string');
    DefineProp('GInternalDataForPrint',tkVariant,__GetGInternalDataForPrint,__SetGInternalDataForPrint,nil,false,0);
    DefineProp('GEPOFilePath',tkVariant,__GetGEPOFilePath,__SetGEPOFilePath,nil,false,0);
    DefineProp('GLoadingBreak',tkVariant,__GetGLoadingBreak,__SetGLoadingBreak,nil,false,0);
    DefineProp('FSelectedDir',tkVariant,__GetFSelectedDir,__SetFSelectedDir,nil,false,0);
    AddConstant('ssNone',ssNone);
    AddConstant('ssNew',ssNew);
    AddConstant('ssOpen',ssOpen);
    AddConstant('ssNoActive',ssNoActive);
    AddConstant('ssCalculate',ssCalculate);
    AddConstant('ssDefault',ssDefault);
    AddConstant('ssInit',ssInit);
    AddConstant('ssEnable',ssEnable);
    AddConstant('ssCheck',ssCheck);
    AddConstant('ssLists',ssLists);
    AddConstant('ssSysComment',ssSysComment);
    AddConstant('ssCharacteristics',ssCharacteristics);
    AddConstant('ssElFilling',ssElFilling);
    AddConstant('ssPeriod',ssPeriod);
    AddConstant('ssOnValidate',ssOnValidate);
    AddConstant('ssFieldChangeExit',ssFieldChangeExit);
    AddConstant('ssSetMenuFunctions',ssSetMenuFunctions);
    AddConstant('ssMenuFunction',ssMenuFunction);
    AddConstant('ssPaymentInfo',ssPaymentInfo);
    AddConstant('ssPaymentOrder',ssPaymentOrder);
    AddConstant('ssBeforePrint',ssBeforePrint);
    AddConstant('ssBeforeSave',ssBeforeSave);
    AddConstant('ssAfterLoadPage',ssAfterLoadPage);
    AddConstant('ssDoEndShowChecking',ssDoEndShowChecking);
    AddConstant('ssDoClearFillingInfo',ssDoClearFillingInfo);
    AddConstant('ssOnActivate',ssOnActivate);
    AddConstant('cFunctionVersion',cFunctionVersion);
    AddConstant('cMaxInt',cMaxInt);
    AddConstant('WM_USERGotoField',WM_USERGotoField);
    AddConstant('MB_OK',MB_OK);
    AddConstant('MB_OKCANCEL',MB_OKCANCEL);
    AddConstant('MB_ABORTRETRYIGNORE',MB_ABORTRETRYIGNORE);
    AddConstant('MB_YESNOCANCEL',MB_YESNOCANCEL);
    AddConstant('MB_YESNO',MB_YESNO);
    AddConstant('MB_RETRYCANCEL',MB_RETRYCANCEL);
    AddConstant('IDOK',IDOK);
    AddConstant('IDCANCEL',IDCANCEL);
    AddConstant('IDABORT',IDABORT);
    AddConstant('IDRETRY',IDRETRY);
    AddConstant('IDIGNORE',IDIGNORE);
    AddConstant('IDYES',IDYES);
    AddConstant('IDNO',IDNO);
    AddConstant('cFormUserSettingsBankAccountsLabel',cFormUserSettingsBankAccountsLabel);
    AddConstant('cClientParamBankAccountFull',cClientParamBankAccountFull);
    AddConstant('cClientParamBankAccount',cClientParamBankAccount);
    AddConstant('cClientParamBankNumber',cClientParamBankNumber);
    AddConstant('cClientParamBankCode',cClientParamBankCode);
    AddConstant('cClientParamBankSpecSym',cClientParamBankSpecSym);
    AddConstant('cClientParamBankName',cClientParamBankName);
    AddConstant('cClientParamBankCity',cClientParamBankCity);
    AddConstant('cClientParamBankIBAN',cClientParamBankIBAN);
    AddConstant('cClientParamBankSWIFT',cClientParamBankSWIFT);
    AddConstant('cClientParamBankAccounts',cClientParamBankAccounts);
  end;
end;

class function TatFScriptUtilsLibrary.LibraryName: string;
begin
  result := 'FScriptUtils';
end;

initialization
  RegisterScripterLibrary(TatFScriptUtilsLibrary, True);

{$WARNINGS ON}

end.


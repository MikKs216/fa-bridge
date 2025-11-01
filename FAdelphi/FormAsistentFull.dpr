{$I Switches.inc}

program FormAsistentFull;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  Windows,
  SysUtils,
  Main in 'Main.pas' {faMain},
  ERichTextEditor in 'ERichTextEditor.pas' {fmRichTextEditor},
  EPdfView in 'EPdfView.pas' {fmPdfView},
  EPdfPrintDlg in 'EPdfPrintDlg.pas' {fmPdfPrintDlg},
  ESplash in 'ESplash.pas' {fmSplash},
  EDesign in 'EDesign.pas' {fmDesignData},
  EScriptEditor in 'EScriptEditor.pas' {fmScriptEditor},
  EChecking in 'EChecking.pas' {fmChecking},
  EPrintDialog in 'EPrintDialog.pas' {fmPrintDialog},
  FCommonUtils_imp in 'FCommonUtils_imp.pas',
  FUtils in 'FUtils.pas',
  FPdfUtils in 'FPdfUtils.pas',
  FScriptUtils in 'FScriptUtils.pas',
  FScriptUtils_imp in 'FScriptUtils_imp.pas',
  FStoreControls in 'FStoreControls.pas',
  FAPublicUtils in 'FAPublicUtils.pas',
  JclStrings_imp in 'JclStrings_imp.pas',
  fnLookup in '..\SpolecneSeznamy\fnLookup.pas',
  EfmLookup in '..\SpolecneSeznamy\forms\EfmLookup.pas' {fmLookup},
  ECalendar in 'ECalendar.pas' {fmCalendar},
  EfmCalc in '..\Kalkulacka\Forms\EfmCalc.pas' {fmCalc},
  ESimpleList in 'ESimpleList.pas' {fmSimpleList},
  EDefs in 'EDefs.pas' {fmDefs},
  DKMainUtils in '..\DK\DKMainUtils.pas',
  DKLicUtils in '..\DK\DKLicUtils.pas',
  ESelectTskps in 'ESelectTskps.pas' {fmSelectTskps},
  FDlg in 'FDlg.pas',
  EElPodani in 'EElPodani.pas' {fmElPodani},
  EElPodDM in 'EElPodDM.pas' {MFCRModule: TDataModule},
  ENastaveni in 'ENastaveni.pas' {fmNastaveni},
  EElPodPVS in 'EElPodPVS.pas' {fmElPodaniPVS},
  EElPodPvsDM in 'EElPodPvsDM.pas' {CSSZModule: TDataModule},
  EClientParams in 'EClientParams.pas' {fmClientParams},
  Res_FA in 'Res_FA.pas',
  EStoredStrings in 'EStoredStrings.pas' {fmStoredStrings},
  EElPotvrzeni in 'EElPotvrzeni.pas' {fmElPotvrzeni},
  AcroPDFLib_TLB in 'AcroPDFLib_TLB.pas',
  PdfLib_TLB in 'PdfLib_TLB.pas',
  DatovaSchranka in 'DatovaSchranka.pas' {fmDatovaSchranka},
  DatovaSchrankaZprava in 'DatovaSchrankaZprava.pas' {fmDSZprava},
  DatovaSchrankaPrihlaseni in 'DatovaSchrankaPrihlaseni.pas' {fmDSPrihlaseni},
  DatovaSchrankaHledani in 'DatovaSchrankaHledani.pas' {fmDSHledani},
  ESelectAdr in 'ESelectAdr.pas' {fmSelectAdr},
  Res_Kalkulacka in '..\Kalkulacka\Res_Kalkulacka.pas',
  EElPodaniProgress in 'EElPodaniProgress.pas' {fmElPodaniProgress},
  EElPodaniResult in 'EElPodaniResult.pas' {fmElPodaniResult},
  EfmSelAttach in '..\fa\EfmSelAttach.pas' {fmSelAttach},
  FCommonUtils in 'D:\D2007AddOn\CommonUtils\FCommonUtils.pas',
  ESelectAdrs in 'ESelectAdrs.pas' {fmSelectAdrs},
  DatamodFA in 'DatamodFA.pas' {dmFA: TDataModule},
  ELoading in 'Eloading.pas' {fmLoading},
  ManagerISDS_TLB in 'ManagerISDS_TLB.pas',
  IBFSender_TLB in 'IBFSender_TLB.pas',
  DatamodPrevPrik in 'DatamodPrevPrik.pas' {dmPrevPrik: TDataModule},
  QaCPrevPrik in 'QaCPrevPrik.pas',
  EMemTableGridView in 'EMemTableGridView.pas' {fmMemTableGridView},

  ETMSDesigner in 'ETMSDesigner.pas' {tmsDesigner},
  EScriptDebugForm in 'EScriptDebugForm.pas' {ScriptDebugForm},

  {$IFDEF UCURSOR}
  FABridgeMonitor in 'FABridgeMonitor.pas',
  {$ENDIF UCURSOR}

  ap_FCommonUtils in 'ap_FCommonUtils.pas',
  ap_FScriptUtils in 'ap_FScriptUtils.pas',
  ap_JclStrings in 'ap_JclStrings.pas',
  ap_CxDBCheckBoxEx in 'ap_CxDBCheckBoxEx.pas',
  ap_CxDBMemoEx in 'ap_CxDBMemoEx.pas',
  ap_CxListBoxEx in 'ap_CxListBoxEx.pas',
  ap_faEdit in 'ap_faEdit.pas',
  ap_HTMLText in 'ap_HTMLText.pas',
  ap_kbmMemTable in 'ap_kbmMemTable.pas',
  ap_psvWebLabel in 'ap_psvWebLabel.pas';

{$R *.res}

begin
  Application.Initialize;
  //reseni problemu s dateseparatorem na Windows7 OEM na noteboocich
  SetThreadLocale(LOCALE_USER_DEFAULT);
  GetFormatSettings();
  //
  fmSplash := TfmSplash.Create(Application);
  try
    fmSplash.Height:=357;
    fmSplash.Width:=526;
    fmSplash.Show;
    fmSplash.Update;
    {$IFDEF STANDALONE}
    Application.CreateForm(TdmFA, dmFA);
    {$ENDIF STANDALONE}
    Application.Title := 'FORM asistent';
    Application.CreateForm(TfaMain, faMain);
    Application.CreateForm(TfmDefs, fmDefs);
  finally
    fmSplash.Close;
    fmSplash.Free;
    fmSplash:=nil;
  end;
  Application.Run;
end.


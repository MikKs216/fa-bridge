{ 19.2.2024 9:07:52 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 5716 - oprava s dorucenymi zpravami  }
{ 16.2.2024 14:03:24 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 5716 - prace na DS  }
{ 16.2.2024 11:43:20 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 5716 - prace na DS  }
{ 16.2.2024 8:24:42 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 5716 - sMsgDatSchProtPrijata+ rozdeleni do fnc pro tuto podporu  }
{ 24.11.2023 10:19:57 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Doplnene textove konstanty   }
{ 3.5.2018 13:09:29 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Doplneno nastavovani expiration date  }
{ 13.12.2017 9:45:21 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Uprava popisu sCapTxtVz  }
{ 13.12.2017 8:52:35 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 2484 - nove sCapTxtVz  }
{ 11.10.2017 10:43:40 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Zmena predmetu prilohy mailem  }
{ 22.9.2016 9:58:59 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in 1617 - nove sMsgAttchDisabled  }
{ 17.3.2016 14:03:45 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Zmena textu formstudio.cz na kastnersw.cz  }
{ 25.2.2016 14:46:30 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 1181 - cast s ESimpleList  }
{ 19.2.2016 11:14:37 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in Doplneno sLaTipKontrolyCapAll...  }
{ 15.1.2016 14:02:06 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Oprava ukonceni po 100 otevrenych instancich pro designery  }
{ 28.11.2014 9:40:53 (GMT+1:00) > [pinkava on VIRTW7] checked in Doplneni sMsgDSAdrNSave  }
{ 24.10.2014 14:17:10 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Uprava  }
{ 23.10.2013 14:30:24 (GMT+2:00) > [marek on PCMAREK_VPC_V7] checked in Doplnena hlaseni, pouzivana kdyz je pdf na pozadi  }
{ 9/19/2013 9:01:55 AM (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Zasadni predelani formulare - zjednoduseni pro uzivatele  }
{ 7.5.2013 11:01:41 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Oprava preklepu  }
{ 3.10.2012 10:41:41 (GMT+2:00) > [mik] checked in   }
{ 13.6.2012 13:51:02 (GMT+2:00) > [martin on TESTXP-2F67BDE0] checked in Ribbon ve FA  }
{ 3.2.2011 16:23:29 (GMT+1:00) > [mik] checked in Oprava textu hlaseni  }
{ 1.12.2010 10:21:17 (GMT+1:00) > [mik] checked in Doplneno hlaseni pro info jak vymazad datum podani.  }
{ 25.11.2010 13:07:01 (GMT+1:00) > [mik] checked in Zmena textu omezeni licence formularu  }
{ 8.3.2010 10:25:06 (GMT+1:00) > [mik] checked in   }
{ 11.12.2009 15:47:56 (GMT+1:00) > [mik] checked in   }
{ 23.9.2009 15:32:08 (GMT+2:00) > [mik] checked in   }
{ 23.9.2009 11:20:52 (GMT+2:00) > [mik] checked in Zmena udaje Version v definicich z integer na string  }
{ 10.10.2008 12:56:13 (GMT+2:00) > [mik] checked in Doplneno hlaseni chyby AR  }
{ 10.10.2008 11:40:38 (GMT+2:00) > [mik] checked in Zmna texu hlen chyb AR  }
{ 12.7.2007 13:11:55 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 13.6.2007 14:44:55 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 5.6.2007 15:18:09 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 23.3.2007 14:30:02 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 26.10.2006 10:15:41 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 11:25:27 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 10:30:22 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 10:27:38 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 9:19:37 (GMT+2:00) > [mik on PCMIK64] checked in   }
unit Res_FA;

interface

{$I Switches.inc}

//Main
resourcestring
  cDefOpenSaveFilter = 'Definice formuláøù (*.fde)|*.fde';
  cFormOpenSaveFilter = 'Formuláøe aplikace FORM studio (*.frm)|*.frm|Formuláøe aplikace FORM studio (*.frmx)|*.frmx|Všechny soubory (*.*)|*.*';
  cFormOpenSaveFilterFrmFrmx = 'Formuláøe aplikace FORM studio (*.frm; *.frmx)|*.frm;*.frmx|Všechny soubory (*.*)|*.*';
  cFormCompresDefOpenFilter = 'Formuláøe a pøedlohy (*.frm; *.fdc; *.zip)|*.frm;*.fdc;*.zip|Formuláøe aplikace FORM studio(*.frm)|*.frm|Pøedlohy formuláøù aplikace FORM studio(*.fdc;*.zip)|*.fdc;*zip|Všechny soubory (*.*)|*.*';
  cPDFOpenSaveFilter = 'Soubory PDF (*.pdf)|*.pdf|Všechny soubory (*.*)|*.*';
  cFDFOpenSaveFilter = 'Soubory FDF (*.fdf)|*.fdf';
  cRTFOpenSaveFilter = 'Textové soubory RTF (*.rtf)|*.rtf|Textové soubory TXT(*.txt)|*.txt|Všechny soubory (*.*)|*.*';
  cXMLOpenSaveFilter = 'Soubory XML (*.xml)|*.xml|Všechny soubory (*.*)|*.*';
  cFRMXFRMOpenSaveFilter = 'Formuláøe aplikace FORM studio(*.frmx; *.frm; *.xml)|*.frmx;*.frm;*.xml|Všechny soubory (*.*)|*.*';
  cFRMX_PDF_ExportFilter = 'Formuláøe aplikace FORM studio(*.frmx)|*.frmx|Soubory PDF (*.pdf)|*.pdf';
  cFRMX_FRM_PDF_ExportFilter = 'Formuláøe aplikace FORM studio(*.frmx)|*.frmx|Formuláøe aplikace FORM studio - starší formát (*.frm)|*.frm|Soubory PDF (*.pdf)|*.pdf';
  cSpellCheckDictOpenSaveFilter = 'Uivatelské slovníky (*.dic)|*.dic|Distribuèní slovníky (*.dat)|*.dat|Všechny soubory (*.*)|*.*';

  sContentLongCaption = 'O&bsah';
  sContentShortCaption = 'O&b.';
  sCommentLongCaption = '&Poznámka';
  sCommentShortCaption = '&Poz.';
  sNotesCaption = 'Poznámky';
  sNotesShortCaption = 'Pozn.';
  sAppendixCaption = 'Pøílohy';
  sAppendixShortCaption = 'Pøílohy';
  sKopie = 'kopie';

  sReadOnly = '(pro ètení)';
  sReadOnlyOrLocked = '(pro ètení nebo uzamèen hlavní formuláø)';
  sSbHintNeulozeneZmeny = 'Formuláø obsahuje neuloené zmìny'#13#10'Zmìny mùete uloit klávesou Ctrl+S';
  sSbHintUlozeneZmeny = 'Obsah formuláøe nebyl zmìnìn';
  sSbHintReadOnly = 'Formuláø lze pouze prohlíet (zamknutı záznam klienta nebo jej má otevøenı jinı uivatel v síti, nebo omezení práv)';
  sSbHintReadOnlyFile = 'Formuláø lze pouze prohlíet (soubor nastaven jen pro ètení)';
  sSbHintCalcDisabled = 'Všechny automatické vıpoèty jsou vypnuty'#13#10'Zapnout vıpoèty mùete volbou Formuláø | Vypnout vıpoèty';
  sSbHintCalcEnabled = 'Automatické vıpoèty jsou zapnuty';
  sAskDisableCalc = 'Všechny automatické vıpoèty budou vypnuty'#13#10'Chcete opravdu vıpoèty vypnout, zadávat hodnoty údajù ruènì a kontrolovat je?';
  sAskDisableCalcFld ='Automatickı vıpoèet údaje bude vypnut'#13#10'Chcete opravdu vıpoèet vypnout, zadávat hodnotu údaje ruènì a kontrolovat ji?';
  sAskDisableCalcFromSaved = 'V uloeném formuláøi byly vypnuty automatické vıpoèty.'#13#10'Chcete vypnutí vıpoètù ponechat?';
  sAskLockForm = 'Zamknutí formuláøe znemoní provádìt jakékoliv zmìny do doby ne jej opìt odemknete.'#13#10'Chcete opravdu formuláø zamknout?';
  sAskUnLockForm = 'Chcete formuláø odemknout?';
  sAskSaveBeforLock = 'Pøed zamknutím formuláøe je potøeba nejprve uloit zmìny. Chcete uloit zmìny?';
  sSbFormLocked = 'Formuláø je uzamèen proti zmìnám'#13#10'Odemknout jej mùete tlaèítkem v pásu karet nebo volbou z nabídky.';
  sCannotCreateWorkDir = 'Nelze vytvoøit pracovní adresáø %s. Zkontrolujte pøíspupová práva k disku, nebo jej vytvoøte ruènì.';
  sNotExistReportDefFile = 'Formuláø nemá definovanou sestavu. Náhled nebo tisk nelze provést.';
  //sSbHasReportVariants = 'Formuláø obsahuje (jazykové) varianty pro tisk. Variantu vyberete v dialogu tisku (Ctrl+P).';
  sSbHasReportVariants = 'Formuláø obsahuje varianty pro tisk. Variantu vyberete v dialogu tisku (Ctrl+P).';
  sSbHasReportVariantsLng = 'Formuláø obsahuje %s variantu pro tisk. Klepnutím otevøete náhled nebo variantu vyberete v dialogu tisku (Ctrl+P).';
  sSbReportVariantEN = 'anglickou';
  sSbReportVariantDE = 'nìmeckou';
  sSbReportVariantFR = 'francouzkou';
  sSbReportVariantIT = 'italskou';
  sSbHasElFilling = 'Formuláø umoòuje elektronické podání. Podání provedete volbou Funkce | Elektronické podání.';
  sNotExistReportDefFileForPdfBg = 'Formuláø nemá definovanou sestavu. Proveïte aktualizaci pøedloh formuláøù.';
  sNotExistPdfBgFile = 'PDF soubor "%s" pro zobrazení na pozadí není k dispozici nebo má chybnou strukturu.';

  sDefFileOpenErr = 'Nelze otevøít definièní soubor %s. Proveïte aktualizaci pøedloh formuláøù.';
  sDataDefErrOpen = 'Chyba definièního souboru pro datovı soubor %s. Proveïte aktualizaci pøedloh formuláøù.';
  sDataDefNotFound = 'Nenalezen definièní soubor (%s) pro datovı soubor %s. Proveïte aktualizaci pøedloh formuláøù.';
  sFreeVerDataDefNotFound = 'Nenalezen soubor s pøedlohou pro formuláø %s. Vyhledejte nebo stáhnìte z internetu nejprve soubor pøedlohy %s a otevøte jej.';
  sUnsufficientLicence = 'Pro otevøení tohoto souboru nemáte dostateènou licenci. Bude otevøen pouze pro ètení.';
  sStoredStringErr1 = 'Údaj "Text" musí bıt zadanı. Vyplòte jej.';

  sMsgCannotSaveReadOnly = 'Soubor nelze uloit, protoe je nastaven jen pro ètení. Ulote formuláø do jiného souboru volbou Uloit jako...';

  sMsgFavoritesInfo = 'Do oblíbenıch mùete pøidat kterıkoliv vzor, pomocí lokální nabídky nebo klávesou Ctrl+O.';
  sMsgFavoritesOutOfDate = 'Upozornìní: Formuláø má ukonèenou platnost. Je moné, e ji existuje novìjší vzor.';

  sDefInstructionNotExists = 'Formuláø nemá ádné pokyny k vyplnìní';
  sFieldInstructionNotExists = 'Pokyny nejsou k dispozici';
  sDataDefIDInvalid = 'Soubor %s neobsahuje platná data formuláøe';

  sCErrUnknownField = 'Neexistující údaj "%s" v proceduøe %s';
  sCErrUnknownFieldInLine = 'Neexistující údaj "%s" v proceduøe %s na øádku %d';
  sMsgErrNoNameControl = 'Na ukládané stránce je nepojmenovanı údaj. Opravte. Stránku nelze uloit.';
  sMsgErrXMLImportFormat = 'Soubor neobsahuje data formuláøe ve formátu XML. Import nebyl proveden.';
  sMsgErrXMLImportEPO = 'Soubor neobsahuje data formuláøe, ale data pro elektronické podání. Import je monı pomocí funkce v nabídce Elektronické podání.'#13#10'Chcete spustit import souboru teï? (Bude potøeba znovu vybrat soubor.)';
  sMsgErrXMLImportEPOStandalone = 'Soubor neobsahuje data formuláøe, ale data pro elektronické podání. Import je monı pomocí funkce v nabídce Soubor.'#13#10'Chcete spustit import souboru teï? (Bude potøeba znovu vybrat soubor.)';
  sMsgErrXMLImportEPONothing = 'Soubor neobsahuje data formuláøe, ale data pro elektronické podání. Pokud chcete tento soubor importovat, otevøete si nejprve odpovídající formuláø.';
  //sMsgInfoXMLExport = 'Exportovanı soubor XML není moné pouít pro elektronické podání. Soubor je urèenı pro pøenos formuláøe mezi klienty nebo mezi instalacemi FORM studia (XML, FRM). Vıbìrem formátu mùete provést také export do PDF.';
  sMsgErrSaveFDF = 'Pøi ukládání FDF/XDP souboru nelze najít soubor %s v definici sestavy. Kontaktujte technickou podporu.';
  sMsgErrLoadTextFileFromFDR = 'Soubor v FDR neexistuje. Kontaktujte technickou podporu';

  sFormInfoCaption = 'Informace o formuláøi';
  sFieldInfoCaption = 'Informace o údaji';
  sDefName = 'Typ formuláøe';
  sDefVersion = 'Verze pøedlohy';
  sDefID = 'ID pøedlohy';
  sCreateDateCaption = 'Datum a èas vytvoøení';
  sModifiedDateCaption = 'Datum a èas poslední zmìny';
  sModifiedTimeCaption = 'Celková doba editace (provádìní zmìn)';
  sModifiedTimeValueCaption = '%d min %d s';
  sWorkStateCaption = 'Stav zpracování formuláøe';
  sPageCountCaption = 'Poèet stran';
  sFieldCountCaption = 'Poèet údajù';
  sScriptLinesCountCaption = 'Poèet øádkù programového kódu';
  sCharacteristicCaption = 'Charakteristické údaje';
  sAutorCaption = 'Autor';
  sNotExistInfo = 'Informace nejsou k dispozici';
  sFormLockedCaption = 'Formuláø je uzamèen proti zmìnám';
  sFormDisabledCalcCaption = 'Formuláø má vypnuté vıpoèty';
  sFormDisabledCalcSomeFldsCaption = 'Formuláø má vypnuté vıpoèty nìkterıch údajù';
  sFillingDateCaption = 'Podán dne';
  sFillingNumberCaption = 'Elektronicky podán pod èíslem';
  sFillingCertInfo = 'Podpisovım certifikátem';
  sFillingDatovaSchranka = 'Datová schránka';
  sFillingStateCaption = 'Stav elektronického podání';
  sExpirationDateCaption = 'Datum expirace';

  
  sFldTypeString = 'Textovı údaj';
  sFldTypeStringWithLength = 'Textovı údaj. Doporuèenı poèet znakù %d.';
  sFldTypeStringWithLengthRestrict = 'Textovı údaj. Maximální poèet znakù %d.';
  sFldTypeNum = 'Èíselnı údaj. Poèet desetinnıch míst %d. Klávesou F12 mùete otevøít kalkulaèku.';
  sFldTypeDate = 'Datumovı údaj. Klávesou F12 mùete otevøít kalendáø nebo pouít klávesy: * dnes, - vèera, + zítra.';
  sFldTypeBool = 'Údaj typu Ano/Ne (zatrhnuto=Ano, nezatrhnuto=Ne)';
  sFldTypeMemo = 'Víceøádkovı text';
  sFldIsCalculated = 'Hodnota údaje se poèítá (nastavuje) automaticky';
  sFldHasDisableCalc = 'Poèítanı údaj, vıpoèet byl ruènì vypnut'#13#10'Zapnout vıpoèet mùete volbou Formuláø | Vypnout vıpoèet údaje';
  sFldHasDefVal = 'Pro údaj je definována základní hodnota.'#13#10'Mùete ji nastavit stisknutím mezerníku nebo Shift+F4.';
  sFldHasDefValBoolean = 'Pro údaj je definována základní hodnota.'#13#10'Mùete ji nastavit klávesou Shift+F4.';
  sFldHasDifferentDefVal = 'Pro údaj je definována základní hodnota.';
  sFldHasDifferentDefVal1 = 'Aktuální hodnota "%s" je rozdílná od základní hodnoty "%s".';
  sFldHasDifferentDefVal2 = 'Základní hodnotu mùete nastavit nastavit klávesou Shift+F4, nebo stisknutím mezerníku.';
  sFldHasLookup = 'Údaj má definován seznam hodnot'#13#10'Seznam pro vıbìr hodnoty mùete otevøít klávesou F12';
  sFldIsSetForEnabling = 'Editace údaje je povolována na základì jinıch údajù';
  sFldIsNotSetForEnabling = 'Povolení editace na základì jinıch údajù bylo ruènì vypnuto';
  sMsgSendViaEmailOnlyFormOrValues = 'Není nastaveno úplné vytvoøení vyplnìného formuláøe pro PDF (v dialogu tisku sekce Rozsah tisku). Chcete radìji odeslat vyplnìnı formuláø?';
  sMsgCheckOK = 'Formuláø neobsahuje ádné nesrovnalosti';
  sLaTipKontrolyCapAll = 'Obnovit (Ctrl+K)';
  sLaTipKontrolyCapSmall = 'Obnovit (Ctrl+K)';
  sLaTipKontrolyCapHint = 'Automatická aktualizace kontrol je z dùvodu rychlosti vypnutá'+#13#10#13#10+'Provést kontroly - Ctrl+K'+#13#10+'Pøejít do okna kontrol - Alt+K'+#13#10+'Schovat/zobrazit okno - Ctrl+Shit+K';
  sLaPovinnostEPOCapAll = 'Povinnost podat formuláø elektronicky';
  sLaPovinnostEPOCapSmall = 'Povinnost EPO ...';
  sMsgOutLimitInstances = 'Pøekroèen maximální poèet spuštìní programu. Zavøete všechny otevøené programy (editory formuláøù FORM asistent).';
  sMsgDiferentDef = 'Data neodpovídají typu formuláøe, kterı je otevøen. Chcete importovat a otevøít formuláø odpovídající importovanému souboru?';
  sMsgHintTextIsLong = 'Pøekroèen doporuèenı poèet znakù %d. Pøi tisku mùe text pøekroèit délku pole.';
  sMsgOpenOrder = 'Zavøít aktuální formuláø a otevøít formuláø objednávky programu?';
  sMsgCheckSyntaxErr = 'Pøi kontrole syntaxe byla nalezena chyba na øádku %d (ve sloupci %d)';

  sMsgSavePaymentInfo = 'Chcete vytvoøit záznam(y) o plánovanıch platbách do platebního kalendáøe?';
  sMsgCannotOpenFile = 'Nelze otevøít soubor %s';
  sMsgBadFormXMLDataFile = 'Nelze otevøít soubor %s. Neobsahuje odpovídající strukturu formuláøe.';
  sMsgFormLockedBeforeEP = 'Formuláø je zamknutı. Chcete jej takto podat? Pokud ano, budou do nìj zapsány informace o podání a pak bude opìt uzamèen.';

  sMsgChooseDir = 'Vyberte sloku pro uloení souborù';
  sMsgFileNotExistsAsk = 'Soubor %s existuje. Chcete jej pøepsat?';
  sMsgErrDateString = 'Neplatné datum (%s)';
  sMsgErrNumString = 'Neplatná èíselná hodnota (%s)';
  sMsgErrNumIntegerString = 'Neplatná èíselná hodnota pro celé èíslo (%s)';
  sMsgErrLoadmtValues = 'Chyba pøi ètení definice (chyba: %s). Aktualizujte definici formuláøe.';
  sMsgAskSaveFile = 'Chcete uloit soubor';
  sMsgAskSaveChanges = 'Chcete uloit zmìny?';

  //sMsgAskCloseIfPDFEditorOpen = 'Je otevøenı dokument v PDF editoru. Chcete pøesto zavøít formuláø bez uloení zmìn PDF souboru?';
  sMsgAskCloseIfPDFEditorOpen = 'Je otevøenı dokument v PDF editoru. Pøed zavøením formuláøe ukonèete PDF editor.';

  sMsgCloseFA = '&Zavøít';
  sMsgCloseFANested = '&Uloit a zavøít';

  sSbCompilation = 'Probíhá inicializace pøedlohy, vyèkejte prosím ...';

  sMsgErrImportFormat = 'Soubor %s neobsahuje kompatibilní data';

  sNestedCaption = 'Vloenı formuláø:';

  sMsgAskOpenNestedForm='Chcete otevøít vloenı formuláø?';
  sMsgAskInsertNestedForm='Chcete vytvoøit novı vloenı formuláø?';

  sNestedCaptionTo = 'Vloenı formuláø do';
  sNestedCaptionL2To = 'Vloenı formuláø 2. úrovnì do';

  sMsgDiferentDefVal = 'Rozdíl zadané hodnoty (%s) od základní hodnoty (%s), [údaj: %s]';

  sMsgVypnotyVypocet = 'Vıpoèet údaje byl vypnut. Pro dokonèení akce opuste údaj.';

  sMsgWantDifs = 'Chcete zkontrolovat i rozdíly oproti základním hodnotám? Pokud ano, poèítejte s delší dobou trvání kontrol.';

  sMsgWaitingForMaster = 'Program èeká na pøedání dat. Lze pøerušit klávesou Esc.';

  sMsgDisableElFillingStart = 'Ve Start licenci je elektronické podání omezeno. Tato funkce je plnì dostupná v placené licenci, kterou si mùete objednat na www.kastnersw.cz.';
  sMsgDisableElFillingLic = 'U formuláøe nelze provádìt elektronické podání. Buï není obsaen ve vaší licenci nebo nemáte zakoupenou slubu Servis. Pokud chcete formuláø elektronicky podávat, zajistìte si slubu Servis s odpovídající skupinou formuláøù.';
  sMsgDisableFormInLic1 = 'Formuláø není obsaen ve vaší licenci nebo nemáte zakoupenou slubu Servis. Tisk je omezen reklamním textem a nelze jej elektronicky podat.';
  sMsgDisableFormInLic2 = 'Pokud chcete formuláø plnohodnotnì vyuívat, zajistìte si slubu Servis nebo rozšiøte licenci na odpovídající skupinu.';
  sMsgElPodaniCaption = 'Elektronické podání';

  SMsgPaymentInfoSaved = 'Pøenos do platebního kalendáøe byl dokonèen. Pokud byly naplnìny nìjaké hodnoty podle údajù ve formuláøi a podle aktuálního stavu seznamù, zkontrolujte èíslo bankovního úètu pøíjemce, variabilní symbol a další údaje.';
  sMsgRemoveFilling = 'Funkce elektronického podání byla pøesunuta do volby Soubor / Podat elektronicky. V nabídce Funkce bude dostupná jen po omezenou dobu. Chcete spustit elektronické podání nyní?';

  sFldNameCaption = 'Identifikátor údaje';
  sFldTypeCaption = 'Typ údaje';
  sFldTypeStringCaption = 'alfanumerickı';
  sFldTypeNumberCaption = 'èíselnı';
  sFldTypeBooleanCaption = 'logickı';
  sFldTypeDateCaption = 'datumovı';
  sFldTypeMemoCaption = 'víceøádkovı text';
  sFldTypeLengthCaption = 'Délka údaje';
  sFldTypeNumLengthCaption = 'Poèet desetinnıch míst';
  sFldTypeNumLengthIntCaption = 'Celé èíslo';
  sFldRestrictLenght = 'pevnì daná';
  sFldNoRestrictLenght = 'doporuèená';
  sFldHasListCaption = 'Údaj má pøiøazen seznam';
  sFldHasDefValCaption = 'Údaj má definovanou základní hodnotu';
  sFldDefValueCaption = 'Základní hodnota';
  sFldValueCaption = 'Aktuální hodnota údaje';
  sFldDefValDiferentCaption = 'Aktuální hodnota údaje je jiná ne základní hodnota';
  sFldHasCalcCaption = 'Údaj je vypoètenı';
  sFldHasCalcDisableCaption = 'Údaj je vypoètenı, ale vıpoèet je vypnutı';
  sFldHasEnablingCaption = 'Editace údaje je povolována na základì jinıch údajù';
  sFldHasDisableEnablingCaption = 'Editace údaje je povolována na základì jinıch údajù, ale nastavování je vypnuto';

  sMsgAskForCancelSlaveMode = 'Program èeká na pøedání dat z nadøízeného souboru. Chcete èekání ukonèit bez pøevzetí dat?';

  sMsgErrMTVField = 'Chyba GetMTVField, field: %s (%s)';

  sResValueOfStateDocOdeslano = 'Odesláno';
  sResValueOfStateDocPodano = 'Podáno';

  sMsgFillingDateWasSet = 'Datum podání bylo nastaveno na %s';
  sMsgFillingDateWasSetAsk = 'Chcete zapsat do formuláøe datum podání %s?';
  sMsgFillingDateWasSetAskWriteDoc = 'Datum podání bylo nastaveno na %s. Zapsat informaci o podání do archivu dokumentù?';
  sMsgFillingDateWasNotSet = 'Datum podání nebylo zadáno';
  sMsgFillingDateWasNotSetAsk = 'Datum podání nebylo vybráno. Chcete vymazat datum podání %s a pøípadné další informace o podání, které je ve formuláøi uloené?';
  sMsgFillingDateCannotSet = 'Datum podání nelze nastavit (nelze zapsat do formuláøe)';
  sMsgFillingDateAskRewrite = 'Formuláø obsahuje informace o elektronickém podání. Zadáním data podání budou tyto informace smazány. Chcete pøesto zmìnit datum podání?';
  sMsgFillingDateInfoDelete = 'Formuláø obsahuje informace o podání. Pokud chcete tyto informace vymazat, stisknìte v dialogu pro vıbìr data tlaèítko Storno.';
  sMsgFillingDateTimeCaption = 'Zadejte datum a èas podání ve tvaru DD.MM.RRRR hh:mm:ss';
  sMsgExpirationDateInfoDelete = 'Formuláø obsahuje informaci o datu expirace. Pokud chcete datum expirace vymazat, stisknìte v dialogu pro vıbìr data tlaèítko Storno.';
  sMsgExpirationDateWasSetAsk = 'Chcete zapsat do formuláøe datum expirace %s?';
  sMsgExpirationDateWasNotSet = 'Datum expirace nebylo zadáno';
  sMsgExpirationDateWasNotSetAsk = 'Datum expirace nebylo vybráno. Chcete vymazat datum expirace %s, které je ve formuláøi uloené?';
  sMsgExpirationDateCannotSet = 'Datum expirace nelze nastavit (nelze zapsat do formuláøe)';

  sMsgWorkStateSetAsk = 'Stav zpracování formuláøe v %';
  sMsgWorkStateWasNotSet = 'Stav zpracování nebyl zmìnìn';
  sMsgWorkStateIsNotOK = 'Zadaná hodnota je mimo rozsah 0..100. Opravte zadání.';

  sMsgCannotOpenFileInLockedState = 'Formuláø je zamknutı, nelze provádìt zmìny.';

  SSelectEmail = 'Vyberte zpùsob odeslání a adresu';
  SSelectDS = 'Vyberte datovou schránku';
  sMsgSpellCheckAddWord = '&Pøidat slovo "%s" do slovníku';

  sMsgDatSchTab='&Nearchivované zprávy';
  sMsgDatSchProtDorucena = 'doruèená';
  sMsgDatSchProtPrijata = 'pøijatá';
  sMsgDatSchProtOdeslana = 'odeslaná';
  sMsgDatSchProtOd = 'od';
  sMsgDatSchProtPro = 'pro';
  sMsgDatSchProtCap = 'Následující zprávy pøesáhly podporovanou velikost pro staení programem %s a nejsou archivovány.'+#13#10+
    'Tyto velkoobjemové datové zprávy (VoDZ) prohlíejte a archivujte jinım zpùsobem!';
  sMsgDatSchProtAdd = ' - %s zpráva "%d" z %s %s "%s" ve vìci "%s"';

  sMsgErrDefVer = 'Verze definice formuláøe neodpovídá verzi programu. Aktualizujte program.';
  sMsgLoadingSpellCheckDict = 'Probíhá pøíprava slovníku pro kontrolu pravopisu. Vyèkejte';

  sMsgFillingInfo1 = 'Elektronicky podáno';
  sMsgFillingInfo2 = 'Dne:';
  sMsgFillingInfo3 = 'Podací èíslo:';
  sMsgFillingInfo4 = 'Heslo:';
  sMsgFillingInfo5 = 'Do datové schránky';
  sMsgFillingInfo6 = 'ID podání';

  sMsgLock = 'Zamknout';
  sMsgLocked = 'Odemknout';
  sMsgWarnLocked = 'FORMULÁØ JE ZAMKNUTİ';

  sMsgPokyny = 'Pokyny k vyplnìní formuláøe';
  sMsgNejsouPokyny = 'Pro údaj nejsou k dispozici ádné pokyny k vyplnìní';

  sMsgFileNotFound = 'Soubor "%s" neexistuje';
  sMsgNeedVer = 'Formuláø potøebuje novìjší verzi programu, bez toho jej nelze otevøít. Proveïte aktualizaci programu.';
  sMsgPDFEncryptNotExist = 'Nenalezena knihovna pro heslování PDF "%s". Aktualizujte program nebo se obrate na technickou podporu.';
  sMsgSendMailErr = 'Nepodaøilo se vytvoøit e-mailovou zprávu. Chyba: %s';

  cAppDuverne = '_dùvìrné';

  //ESimpleList
  SRMDlgTxtFil = 'Textové soubory';
  SRMDlgAllFil = 'Všechny soubory';
  SRMDlgExcel = 'Tabulka Excel';
  SRMDlgXMLFil = 'XML soubor';
  SRMDlgExpTitl = 'Exportovat jako';
  SMExportCap = 'Export';
  SRMReplFile = 'Soubor ji existuje, chcete jej pøepsat?';
  SHintPokynyAno = 'Pokyny k vyplnìní formuláøe';
  SHintPokynyNe = 'Tento formuláø nemá pokyny k vyplnìní';

//ECalendar
resourcestring
  sBtDateLabel = '&Dnes';

//EDefs
resourcestring
  sMsgFDLNotExist='Nenalezen seznam definic formuláøù. Proveïte aktualizaci programu.';
  sMsgDefsFndFrmNotExist='Není vybrán ádnı formuláø';

  sMsgAktualni = 'Aktuální';
  sMsgAllGroups = 'Vše';
  sMsgFrmGroups = 'Formuláøe';
  sMsgTxtVzGroups = 'Vzory dokumentù';
  sMsgNewFrmFindTxt = 'Zadejte název formuláøe nebo jeho èást';//'Zadejte text, kterı chcete vyhledat';

  sMsgAskTakeAll = 'Opravdu chcete odebrat všechny záznamy ze záloky oblíbené?';

  sCapTxtVz = 'Textovı vzor';
  sCapDef = 'Formuláø';

  sMsgNoTextTemplates = 'Nelze otevøít distribuèní definice textovıch vzorù. Monım øešením by mìla bıt aktualizace.';
  sMsgInfoTextDocument = 'Vzory textovıch dokumentù jsou dostupné pouze v placenıch licencích. V licenci Start si však mùete vyzkoušet práci s textovımi dokumenty na ukázkovém vzoru.';
  sMsgFiktivniDokument1 = 'Ukázkovı vzor dokumentu na vyzkoušení práce s textovımi vzory';
  sMsgFiktivniDokument2 = 'Jméno a pøíjmení';
  sMsgFiktivniDokument3 = 'Ulice';
  sMsgFiktivniDokument4 = 'PSÈ';
  sMsgFiktivniDokument5 = 'Místo';
  sMsgFiktivniDokument6 = 'V licenci Start není dostupnı vlastní obsah textovıch vzorù. Mùete si však vyzkoušet práci s textovımi dokumenty na tomto ukázkovém vzoru.';

  sMsgKopie = 'kopie';

  sMsgDeleteVzor = 'Opravdu chcete smazat vzor?';

  sMsgOblibenePridano = 'Záznam byl pøidán do oblíbenıch';
  sMsgOblibeneOdebrano = 'Záznam byl odebrán z oblíbenıch';

//EElPodani
resourcestring
  sMsgPZPCaption = 'Elektronické podání na Portál zdravotních pojišoven';

  cMsgEPPotvrzeni = 'Soubor potvrzení elektronického podání (p7s). Obsahuje elektronickı podpis daòové správy a je moné jej naèíst a ovìøit na serveru daòové správy.';

  sAskPrint = 'Vytisknout informace?';

  cAllOpenSaveFilter = 'Všechny soubory|*.*';
  cXMLEPOpenSaveFilter = 'XML soubory (*.xml)|*.xml|Všechny soubory|*.*';
  cZIPOpenSaveFilter = 'ZIP soubory (*.zip)|*.zip|Všechny soubory|*.*';
  cRTFTXTOpenSaveFilter = 'Formát RTF (*.rtf)|*.rtf|Textové soubory (*.txt)|*.txt|Všechny soubory|*.*';
  cPDFRTFTXTOpenSaveFilter = 'Formát PDF (*.pdf)|*.pdf|Formát RTF (*.rtf)|*.rtf|Textové soubory (*.txt)|*.txt|Všechny soubory|*.*';

  sMsgSavePotvrzeniFileAsk = 'Chcete uloit originální pøijatı soubor s potvrzením (soubor p7s obsahující el. podpis podatelny)?';
  sMsgSavePotvrzeniFileZPAsk = 'Chcete uloit originální pøijatı soubor s potvrzením (soubor htm)?';
  sMsgErrSadaKlicuNeniDefinovana = 'Chyba pøi podepisování podání: %s Zkontroluje, zda máte vybranı správnı certifikát, nebo pokud máte certifikát na kartì, vyjmìte jej a znovu vlote kartu do èteèky.';

//EElPotvrzeni
resourcestring
  sAskPrintPotv = 'Vytisknout informace?';
  sErrPotvFileNotFound = 'Soubor potvrzení elektronického podání "%s" neexistuje.';

//EElPodPVS
resourcestring
  cMsgEPPotvrzeniPVS = 'Soubor potvrzení elektronického podání (xml). Obsahuje elektronickou znaèku podatelny.';

//EChecking
resourcestring
  sMsgInfoRozdily = 'Pro zobrazení rozdílù hodnot je potøeba zavøít okno kontrol a spustit kontroly znovu. Doba provedení kontrol se touto volbou mùe prodlouit.';

//EChecking
resourcestring
  sMsgAttchDisabled = '(pøíloha je ji pøipojena a nelze pøidat další)';

//ENastaveni
resourcestring
  SRKErrSaveRec = 'Chyba v uloení záznamu';

  sShowErrsDisableWarn = 'Máte potlaèeno hlášení chyb formuláøù. Pokud budete chtít spustit kontroly ve formuláøích, musíte to provést ruènì volbou Formuláø / Zkontrolovat. Nebo mùete znovu otevøít Nastavení programu a parametr zmìnit na stránce Obecné.';

  sSaveParam='Chcete uloit nastavení programu?';

  RSObsahForm = 'Formuláøe';
  RSObsahFormGr = 'Skupiny formuláøù';
  RSObsahAkt = 'Aktualizace';
  RSObsahLic = 'Licence';
  RSObsahDanPor = 'Daòovı poradce';

  sLicSaveOK = 'Licence byla nastavena';
  sLicStartSaveOK = 'Licence Start byla nastavena';
  sLicSaveError = 'Nepodaøilo se uloit licenèní údaje do registrù. Zkontrolujte právo zápisu do sekce HKEY_LOCAL_MACHINE a proveïte nastavení licence znovu.';

  cAskSetLicStart = 'Opravdu chcete nastavit licenci Start';

//EPdefPrintDlg
resourcestring
  sMsgNoPrinter = 'Není nainstalovaná ádná tiskárna';

//EPdfView
resourcestring
  sCaptionNahled = 'Náhled';

  SMsgPrinting = 'Probíhá tisk ...';

  sMsgSignature = 'Dokument obsahuje elektronickı podpis:';

  sPage = 'Strana';
  sMsgIsPrinting = 'Probíhá tisk dokumentu. Vyèkejte na dokonèení tisku.';

//EPrintDialog
resourcestring
  sReportVariantBasic = 'Základní';
  sReportExpandOf = 'Rozšíø&ené';
  sReportExpandOn = 'Zú&ené';

  sReportUseFontInfoArial = 'Vybrané písmo %s není podporováno, bude nahrazeno podobnım písmem Helvetica. Pøi pouití tohoto písma není moné provést prokládání znakù do kolonek.';
  sReportUseFontInfoTrueType = 'Pøi pouití vybraného písma %s není moné provést prokládání znakù do kolonek.';
  sReportUseFontInfoNoSupportedFont = 'Vybrané písmo %s není podporováno, bude nahrazeno písmem Courier. Podporovaná písma jsou Courier, Helvetica a Times.';
  sNoDefaultPrinter = 'Není nastalovaná ádná tiskárna. Pokud chcete z programu tisknout, nainstalujte v Ovládacích panelech Windows tiskárnu.';

  sMsgErrSelectedPages = 'Chybnì zadanı rozsah stran. Chcete pøesto provést náhled nebo tisk?';

  SWarnAcrobat = 'Náhled nebo tisk v oknì programu nemusí v nìkterıch pøípadech správnì fungovat. V pøípadì problémù doporuèujeme otevírat Acrobat jako samostatnou aplikaci.';

//ERichTextEditor
resourcestring
  sPokyny = 'Pokyny';

//ESelectTskps
resourcestring
  sMsgNeexistujeTabulkaTskps = 'Nenalezena data formuláøù pro vıbìr. Aktualizujte nadøízenı program.';

  sSelectTskps = 'Vyberte formuláøe';
  sSelectTskp = 'Vyberte formuláø';

  SRDataFormsNoChoice = 'Nevybrali jste ádnı formuláø k pøevzetí. Chcete pøesto ukonèit vıbìr?';

//ESplash
resourcestring
  sVersionLabel='Verze:';

  sAbout = 'O aplikaci';
  sFrreVerLicCaption = 'Free (k pouití zdarma)';

//EStoredStrings
resourcestring
  RSDeleteRecord = 'Chcete smazat aktuální záznam?';

//FAPublicUtils
resourcestring
  sOrderFileName = 'Objednávka_programu';

//FPDFUtils
resourcestring
  SmsgNeniAsociace = 'Není nainstalován nebo pøiøazen program na zobrazení dokumentù PDF. Dokument nelze zobrazit ani vytisknout.';
  SmsgNeniAsociaceReseni = 'Problém odstraníte zaškrtnutím volby "Pouít interní prohlíeè PDF" nebo "Pouít editor PDF" v dialogu tisku nebo instalací programu na prohlíení souborù PDF (napø. Adobe Reader).';

  SmsgNeniPDFEditor = 'Není k dispozici program na zobrazení dokumentù PDF (PDF-XChange Editor/Viewer - sloka PDFEditorN nebo PDFEditor ve sloce programu). Dokument nelze zobrazit ani vytisknout.';
  SmsgNeniPDFEditorReseni = 'Problém odstraníte zaškrtnutím volby "Pouít interní prohlíeè PDF" v dialogu tisku nebo reinstalací programu.';

  SmsgSestavyReklama = 'Vytvoøeno v programu FORM studio - www.kastnersw.cz';
  SmsgNelzeVytvPracFile = 'Nelze vytvoøit pracovní soubor %s. Ukonèete program, smate adresáø %s a spuste program znovu. Pokud se tím problém nevyøeší, kontaktujte technickou podporu.';
  SmsgChybiParametryReportu = 'Chybí parametry sestavy. Patrnì je chybnı definièní soubor formuláøe. Proveïte aktualizaci definic formuláøù.';
  SmsgReportFileNotFound = 'Nelze naèíst soubor %s. Ukonèete a spuste program znovu, pøípadnì proveïte aktualizaci definic formuláøù. Pokud bude problém nastávat i potom, kontaktujte technickou podporu.';
  SmsgReportFileErrorPack = 'Chyba pøi ètení souboru %s. Tento soubor nebude pøipojen do vısledného dokumentu.';
  SmsgPrintInfo = 'Je pøipraven tisk nejprve lichıch a potom sudıch stran. Vlote do tiskárny %d listù papíru a po vytisknutí papíry obrate pro tisk sudıch stran.';

  SMsgPdfDocWarn = 'Byl zadán poadavek na tisk jen sudıch stran u jednostránkového formuláøe. Pokud má formuláø jen jednu stranu, nelze tisknout jen sudé strany. Zkontrolujte nastavení rozsahu tisku.';
  SMsgPdfDocWarnEmpty = 'Byl zadán poadavek na tisk strany, která v dokumentu neexistuje. Zkontrolujte nastavení rozsahu tisku.';
  SmsgSignatureCaption = 'Dokument obsahuje elektronickı podpis:';
  sMsgErrCannotFindCertificate = 'Dokument nelze elektronicky podepsat. Nebyl vybrán certifikát, nebo døíve vybranı certifikát neexistuje. Je tøeba vybrat certifikát v nastavení tisku nebo zrušit zaškrtnutí volby "Podepsat elektronicky".';
  sMsgErrCannotFindCertificate1 = 'Chcete nyní pokraèovat ve vytvoøení dokumentu bez podpisu?';
  sMsgErrMaybeCorruptFDR = 'Soubor %s neexistuje. Je moné, e je porušenı definièní soubor formuláøe a mohla by pomoct jeho aktualizace. Pokusit se zaktualizovat definici formuláøe?';
  sMsgAfterActualize = 'Probìhla aktualizace. Náhled nebo tisk bude ukonèen, zkuste provést znovu.';

//FDlg
resourcestring
  SYesCz = '&Ano';
  SOKCz = '&OK';
  SCancelCz = '&Storno';
  SHelpCz = 'N&ápovìda';
  SNoCz = '&Ne';
  SCloseCz = '&Zavøít';
  SAbortCz = '&Pøerušit';
  SRetryCz = 'O&pakovat';
  SIgnoreCz = '&Ignorovat';
  SAllCz = '&Vše';
  SYesToAllCz = 'Ano v&šem';
  SNoToAllCz ='N&e všem';

  sMsgNoCorrectDateString='Datum bylo zadáno chybnì. Bude pouito období';

//FScriptUtils
resourcestring
  SmsgNoCorrectDefinition = 'Formuláø %s neodpovídá poadovanému typu, nebude zaøazen do vıbìru.';
  SmsgPOBOX = 'P.O.BOX';
  SmsgRozena = 'rozená';
  SmsgSpecSym = 'spec.sym.';
  sMsgSavePaymentOrder = 'Chcete vytvoøit pøíkaz k úhradì?';
  sMsgSavePaymentOrderNothingTodo = 'Èástka k úhradì je nulová nebo záporná, pøíkaz nelze vytvoøit.';

  sPaymentOrderFileName = 'Pøíkaz_k_úhradì';
  SMsgPaymentOrderCreated ='Pøíkaz k úhradì je pøipraven. Hodnoty byly naplnìny podle údajù ve formuláøi a podle aktuálního stavu seznamù. Zkontrolujte èíslo bankovního úètu pøíjemce, variabilní symbol a další údaje!';

  sMsgEmptyClipboard = 'Schránka je prázná nebo nelze obsah rozpoznat jako text.';
  sMsgAskGetClipboard = 'Pøevzít adresu ze schránky Windows?';
  sMsgAskgetClipboard1 = 'Obsah schránky';

  sMonth1 = 'Leden';
  sMonth2 = 'Únor';
  sMonth3 = 'Bøezen';
  sMonth4 = 'Duben';
  sMonth5 = 'Kvìten';
  sMonth6 = 'Èerven';
  sMonth7 = 'Èervenec';
  sMonth8 = 'Srpen';
  sMonth9 = 'Záøí';
  sMonth10 = 'Øíjen';
  sMonth11 = 'Listopad';
  sMonth12 = 'Prosinec';

  sMonth21 = 'Ledna';
  sMonth22 = 'Února';
  sMonth23 = 'Bøezna';
  sMonth24 = 'Dubna';
  sMonth25 = 'Kvìtna';
  sMonth26 = 'Èervna';
  sMonth27 = 'Èervence';
  sMonth28 = 'Srpna';
  sMonth29 = 'Záøí';
  sMonth210 = 'Øíjna';
  sMonth211 = 'Listopadu';
  sMonth212 = 'Prosince';

  sMonth = 'mìsíc';
  sQrt = 'ètvrtletí';

  s900 = 'devìtset';
  s800 = 'osmset';
  s700 = 'sedmset';
  s600 = 'šestset';
  s500 = 'pìtset';
  s400 = 'ètyøista';
  s300 = 'tøista';
  s200 = 'dvìstì';
  s100 = 'sto';
  s90 = 'devadesát';
  s80 = 'osmdesát';
  s70 = 'sedmdesát';
  s60 = 'šedesát';
  s50 = 'padesát';
  s40 = 'ètyøicet';
  s30 = 'tøicet';
  s20 = 'dvacet';
  s19 = 'devatenáct';
  s18 = 'osmnáct';
  s17 = 'sedmnáct';
  s16 = 'šestnáct';
  s15 = 'patnáct';
  s14 = 'ètrnáct';
  s13 = 'tøináct';
  s12 = 'dvanáct';
  s11 = 'jedenáct';
  s10 = 'deset';
  s9 = 'devìt';
  s8 = 'osm';
  s7 = 'sedm';
  s6 = 'šest';
  s5 = 'pìt';
  s4 = 'ètyøi';
  s3 = 'tøi';
  sdva = 'dva';
  sdve = 'dvì';
  sjeden = 'jeden';
  sjedna = 'jedna';
  sjedno = 'jedno';
  stisic = 'tisíc';
  stisice = 'tisíce';
  smilion = 'milion';
  smiliony = 'miliony';
  smilionu = 'milionu';
  smiliarda = 'miliarda';
  smiliardy = 'miliardy';
  smiliard = 'miliard';
  snula = 'nula';
  sminus = 'mínus';

  SSelectAdress = 'Vyberte adresu';
  SSelectPerson = 'Vyberte osobu';
  SSelectBankAccount = 'Vyberte bankovní úèet';

  SSelectDirButton = 'Vybrat';

  sNeniDotNet =  'Není nainstalován .NET framework (4.5 nebo vyšší), kterı je pro funkci potøebnı. Nainstalujte jej. '+
    'Instalaèní soubor .NET framework najdete na www.microsoft.cz.';

//FUtils
resourcestring
  sMsgNeautorizovanyZip = 'Neautorizovanı definièní soubor formuláøe';

  sObdobiVykazu='Období';
  sOd='Od';
  sDo='do';

//ESelectCertificate  
resourcestring
  sCaptionPlatCert = 'Platné certifikáty';
  sCaptionWait = 'Platné certifikáty - probíhá naèítání certifikátù ... ';

  sCaptionShowRibbon = 'Zobrazit ribbon';
  sHintShowRibbon = 'Zobrazení lišty ribbonu';
  sCaptionShowBars ='Zobrazit menu';
  sHintShowBars='Zobrazit nabídku a nástrojovou lištu';

//EPdfView
resourcestring
  sMsgErrPrinter = 'Chyba: %s Zkuste tisk znovu po restartu Windows a pokud to nepomùe, tak vyberte v dialogu tisku prohlíeè PDF podle instalace v systému.';
  sMsgPrintCaption = 'Tisk';

//DatovaSchrankaZprava
resourcestring
  sMsgErrUlozeniOpisuZpravy = 'Chyba pøi uloení opisu zprávy: %s';
  sMsgAppendixSubject = 'Zpráva z datové schránky - pøíloha %s';
  sMsgAppendixAllSubject = 'Zpráva z datové schránky - pøílohy';

implementation
end.


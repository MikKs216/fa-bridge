{ 19.7.2025 23:47:23 (GMT+2:00) > [martin on VIRTUALFS] checked in uprava cesty pro STEREONX direktiva ve switches.inc  }
{ 15.7.2025 13:46:01 (GMT+2:00) > [martin on VIRTUALFS] checked in opravy cest STEREONX  }
{ 7. 2. 2024 14:56:42 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Do procedury StringToField doplnena normalizace textu u datumovych fieldu.  }
{ 18.2.2022 12:50:23 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Zmena adresy OpenWebBrowser na novy portal Moje dane  }
{ 8.10.2019 13:00:44 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Doplnena funkce OpenWebBrowserPortalCSSZ  }
{ 5.5.2016 16:06:57 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Oprava volani webbrowser  }
{ 10.4.2014 11:55:30 (GMT+2:00) > [martin on WIN-48QDB6JAV23] checked in Odstraneni VCLZipu a nahrada ZipForge  }
{ 18.4.2013 14:29:40 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Zarazeni CreateQRCode  }
{ 16.2.2010 15:38:53 (GMT+1:00) > [mik] checked in Osetreni masky datumu s lomitkama a jinymi formaty  }
{ 10.12.2009 15:27:30 (GMT+1:00) > [mik on MIK-VIRTUAL2007] checked in Hodne novych funkci DS  }
{ 25.11.2009 13:18:38 (GMT+1:00) > [mipi on MP-PC] checked in Presun SaveTableRecordToIniValues do SpolFunc  }
{ 8.7.2009 22:19:13 (GMT+2:00) > [martin on MR64PC] checked in   }
{ 9.6.2009 9:24:47 (GMT+2:00) > [mik] checked in   }
{ 6.11.2008 11:26:00 (GMT+1:00) > [mik] checked in Uprava GetFillingSubjectInfo  }
{ 9.10.2008 14:28:17 (GMT+2:00) > [mik] checked in Doplneni identifikace subjektu v potvrzeni o podani  }
{ 6.5.2008 22:58:12 (GMT+2:00) > [martin on VISTAPC] checked in   }
{ 5.6.2007 15:18:06 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 10.4.2007 9:36:00 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 29.3.2007 14:02:42 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 28.3.2007 11:53:11 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 28.3.2007 9:23:53 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 22.3.2007 9:57:59 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 10:27:34 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 5.6.2005 9:31:14 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 25.11.2003 17:37:37 (GMT+1:00) > [mik on PCMIKHOME] checked in   }
{ 22.10.2003 15:51:00 (GMT+2:00) > [mipi on PINKAVA] checked in V SaveTableRecordToIniValues osetreno neukladani se Blobu  }
{ 22.8.2003 13:34:07 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 30.7.2003 22:51:50 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 2.7.2003 9:11:40 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 12.6.2003 15:07:48 (GMT+2:00) > [mik on MIKPC2] checked in   }
{ 10.6.2003 21:31:38 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 6.6.2003 16:39:04 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
//FORM asistent - spolecne funkce
//

unit FUtils;
{$I Switches.inc}

interface

uses
  Windows, Classes, Graphics, DB, DBClient, kbmMemTable, Res_FA, XMLDoc;

const
  cFADateMask = 'dd.mm.yyyy';
  cFADateTimeMask = 'dd.mm.yyyy hh:mm:ss';
  cFADateSeparator = '.';
  cFADecimalSeparator = '.';

  cStringTypeValue = 'S';
  cNumericTypeValue = 'N';
  cCurrencyTypeValue = 'C';
  cDateTypeValue = 'D';
  cBooleanTypeValue = 'B';
  cMemoTypeValue = 'M';

  cCRLFAlternate = #255'#';
  cCRLFAlternate1 = #183'#';
  cCRLFAlternate2 = #184'#';
  cCRLF = #13#10;

  cDKResultFileName = 'DKresult.txt';

  cExternalPass = 'gI5j9%mP8$#ms';

  sNestedSecID = 'NestedSections';

  cFormXMLRootLabel = 'FORM';
  cFormXMLFormsRootLabel = 'FSFORMS';

  cUSPrintAppendix = 'US_PrintAppendix';
  cUSPrintFromPage = 'US_PrintFromPage';

  cDocumentFolderRecDS = 'Pøijaté zprávy DS';
  cDocumentFolderSentDS = 'Odeslané zprávy DS';
  cDocumentFolderSentMail = 'Odeslané e-maily';
  cDocumentFolderSentMessage = 'Odeslané formuláøe do DS';
  cDocumentFolderSentEP = 'Odeslaná el. podání';
  cDocumentFolderSentEPPot = 'Potvrzení el. podání';

type  
  TReportSettings = record
    PrintForm, //tisknout formular
      PrintValues, //tisknout hodnoty
      RemoveBackground, //*odstranit barvu pozadi
      NoFilledStrike, //*nevyplnene prosktrnout
      ZeroValueClear, //*nulove vyprazdnit
      NulNumValueFillZero, //*nevyplnene ciselne vyplnit nulou
      UseClientIdentification, //*tisknout identifikaci klienta
      UsePrgIdentification, //*tisknout identifikaci programu
      PrintWithDialog, //*otevrit dialog nastaveni pred tiskem
      UseUserFont: boolean; //pouzit vybrany font

    FontName: string;
    FontSize: integer;
    FontBold, FontItalic: boolean;
    FontColor: TColor;
    ShiftX, ShiftY: integer;

    RepPagesAll: boolean;
    RepPagesOdd: boolean;
    RepPagesEven: boolean;
    RepPagesOddThenEven: boolean;
    RepPagesSelected: boolean;
    RepSelectedPages: string;
    RepCopies: integer;
    RepInternalReader: boolean;
    RepEditorReader: boolean;
    RepExternalReader: boolean;
    RepUserDefined:Boolean;

    UseSignature: boolean;
    UseSignatureInText: boolean;
    SignatureHash: string;
    SignatureSubject: string;

    VariantName: string;

    //nastaveni pro primy tisk
    PrinterIndex: integer;
    PrinterName: string;
    //CMD
    CMDShow:string;
    CMDPrint:string;

    PrintNalezato:boolean;

    FDFPrint:boolean;
  end;

//field / string transformation
function FieldToString(AField: TField; ADecimalPlaces: integer = 0): string;
function StringToField(AStringValue: string; var AField: TField): boolean;
function FieldToStringFmt(AField: TField;
  AZeroValueClear, ANulNumValueFillZero: boolean;
  ADecimalPlaces: integer = 0; AThousandSeparator: boolean = TRUE): string;
function FldValueToStringFmt(const AFldType, AStrValue: string;
  ADecimalPlaces: integer = 0; AThousandSeparator: boolean = TRUE): string;
function FieldIsEmpty(AField: Tfield): boolean;
function StringToCompactStr(const AStr: string): string;
function CompactStrToString(const ACompactStr: string): string;

{function ZipFile(const ASrcFileName, ADstFileName, AComment: string;
  const APassword: string = ''): boolean;
function UnzipFile(const ASrcFileName, ADstDir: string;
  APassword: string = ''): boolean;
function GetZipFileComment(const AFileName: string): string;
function LoadTextFromZip(const AZipFileName, ATextFileName: string;
  out AText: string; const APassword: string = ''): boolean;}
function LoadMtFromZip(AMt: TkbmMemTable; const AZipFileName: string;
  const APassword: string = ''): boolean;

procedure CopyRec(ASrcDataSet, ADestDataSet: TDataSet);
procedure CopyTable(ASrc: TClientDataSet; ADst: TkbmMemTable);
procedure CopyMemTable(ASrc: TkbmMemTable; ADst: TkbmMemTable);
function CreateMemTableCopy(ASource: TkbmMemTable): TkbmMemTable;


function FormatInfoString(const ALabel, AValue: string): string;
function RtfToXmlStr(const AValue: string): string;
function XmlStrToRtf(const AValue: string): string;
function GetEnvVar(const Name: string; var Value: string;
  Expand: Boolean): Boolean;

function IsXMLOneForm(const AXMLData: string; AXMLDoc: TXMLDocument): boolean;
function IsXMLForms(const AXMLData: string; AXMLDoc: TXMLDocument): boolean;

function GetFillingSubjectInfo(AParent: TComponent; const AXMLFillingDoc: string;
  const AVetaPAttrName: string; const AVetaTyp: string = 'VetaP'): string;
procedure CreateQRCode(
   const AStream: TStream; //soubor s vytvorenym obrazkem s QRCode
   const AQRText: string;
   AWidth: integer = 200; AHeight: integer = 200);
procedure CreateBarCode(
   const AStream: TStream; //soubor s vytvorenym obrazkem s carovym kodem
   const ABarCodeText: string;
   const ACodeType: string;
   AWidth: integer = 200; AHeight: integer = 200);
function LoadPartReportSettings(const AIniFileName: string): TReportSettings;
procedure OpenPDFFile(const fn: string);
function IsWebBrowser: boolean;
procedure OpenWebBrowser(
  const URL: string;
  const ISDSName: string;
  const ISDSPassword: string;
  const DataFilePath: string;
  const AppAction: string;
  const AppCaption: string;
  const EETname: string = '';
  const EETpassword: string = '');
procedure OpenWebBrowserDanInfSchr(
  const ISDSName: string;
  const ISDSPassword: string;
  const EETname: string = '';
  const EETpassword: string = '');
procedure OpenWebBrowserPortalCSSZ(
  const ISDSName: string;
  const ISDSPassword: string);
function AcceptScriptDirectives(const AScript: string): string;

{$IFDEF STANDALONE}
procedure SaveSlaveRequestVykaz(const AVykazID, AObdobiDo: string;
  AVTisicich: boolean);
procedure SaveSlaveRequestSelForm(const ADefId: string;
  AMultiSelect: boolean; const ACaption: string);

function TranslateDKId(AOldID:string):string;
function CreateDataHeader(AID:Integer;ADefID:string;
  AGroup:string;ASubGroup:string;
  ACreateDate:TDateTime; AModifDate:TDateTime; ALocked: boolean):string;
function TranslateDKRow(ARow:string; APosunRadkuDS: integer = 0):string;
function ConvertTskpDKToFA(const ADKDefID, ADataString: string): string;

{$ENDIF STANDALONE}

implementation

uses
  Controls, Forms, SysUtils, JclGraphUtils, JCLStrings, JCLMapi, ShellAPI,
  Variants, Math, Masks, Dateutils, Printers, fnLookup,
  FCommonUtils, IniFiles, FDlg, Dialogs, JclSysInfo, xmldom, XMLIntf, msxmldom, SpolFunkce,
  psCodeExports, psBarcode, psTypes, psBarcodeComp, ZipForge, JclShell, EPdfView, StrUtils,
  Main, DKLicUtils;

//Nahradi CRLF zastupnym znakem

function ReplaceCRLFtoAllernate(const AString: string): string;
begin
  Result:=Replace(cCRLF,AString,cCRLFAlternate);
end; {ReplaceCRLFtoAllernate}

//Prevede hodnotu udaje na text se zohlednenim poctu des mist, bez oddel.tisicu
//  u typu float je vzdy decimal separator '.'
//  u typu date je format dd.mm.yyyy
//  u typu boolean je format TRUE nebo FALSE

function FieldToString(AField: TField; ADecimalPlaces: integer = 0): string;
var
  i, lnNsID: integer;
  isInNS: boolean;
  strVal,wstr: string;
begin
  if AField is TStringField then
    Result:=TStringField(AField).Value
  else if AField is TIntegerField then
    Result:=IntToStr(TIntegerField(AField).Value)
  else if AField is TFloatField then begin
    Result:=Format('%.'+IntToStr(ADecimalPlaces)+'f',
      [TFloatField(AField).Value]);
    Result:=Replace(DecimalSeparator,Result,cFADecimalSeparator);
  end
  else if AField is TDateField then begin
    DateTimeToString(Result,cFADateMask,TDateTimeField(AField).AsDateTime)
  end
  else if AField is TDateTimeField then begin
    DateTimeToString(Result,cFADateTimeMask,TDateTimeField(AField).AsDateTime)
  end
  else if AField is TBooleanField then
    Result:=BoolToStr(TBooleanField(AField).AsBoolean,TRUE)
  else if AField is TMemoField then begin
    strVal:=TMemoField(AField).AsString;
    lnNsID:=Length(sNestedSecID)+2;
    isInNS:=FALSE;
    if Copy(strVal,1,lnNsID)='['+sNestedSecID+']' then begin
      wstr:=Copy(strVal,1,lnNsID);
      for i:=lnNsID+1 to Length(strVal) do begin
        if Copy(strVal,i,lnNsID)='['+sNestedSecID+']' then
          isInNS:=TRUE;
        if isInNS then //uvnitr vnorene nested sections (to je druha uroven) nenahrazujeme CRLF, musi to zustat v radku
          wstr:=wstr+strVal[i]
        else begin
          if Copy(strVal,i,2)=cCRLF then
            wstr:=wstr+cCRLFAlternate
          else if Copy(strVal,i,2)=cCRLFAlternate then
            wstr:=wstr+cCRLFAlternate1
          else if Copy(strVal,i,2)=cCRLFAlternate1 then
            wstr:=wstr+cCRLFAlternate2
          else if (Copy(strVal,i-1,2)=cCRLF) or
            (Copy(strVal,i-1,2)=cCRLFAlternate) or
            (Copy(strVal,i-1,2)=cCRLFAlternate1) or
            (Copy(strVal,i-1,2)=cCRLFAlternate2) then begin
            //nedelame nic, protoze je to druhy znak z CRLF
          end
          else
            wstr:=wstr+strVal[i];
        end;
        if Copy(strVal,i,lnNsID+1)='[/'+sNestedSecID+']' then
          isInNS:=FALSE;
      end;
      Result:=wstr;
    end
    else
      Result:=Replace(cCRLF,TMemoField(AField).AsString,cCRLFAlternate);
  end
  else
    Result:='';
end; {FieldToString}

//Prevede textovou hodnotu do hodnoty udaje AField. Hodnota se naplni podle typu
//  udaje AField. Pokud konverzi nelze provest, vraci FALSE.

function StringToField(AStringValue: string; var AField: TField): boolean;
var
  i, lnNsID: integer;
  wstr: string;
  isInNS: boolean;
  dt: TDateTime;
  dd,mm,yyyy,str: string;
begin
  Result:=TRUE;
  if AField=nil then
    Result:=FALSE
  else begin
    if SameText(AField.FieldName,'OBDOBI') then
      i := 0;
    if AField is TStringField then
      TStringField(AField).Value:=AStringValue
    else if AStringValue='' then begin
      if AField is TBooleanField then
        TBooleanField(AField).AsBoolean:=FALSE
      else
        AField.Clear;
    end
    else if AField is TIntegerField then begin
      if IsInteger(AStringValue) then
        TIntegerField(AField).Value:=StrToInt(AStringValue)
      //pokud byl udaj ulozen jako float - napr pri prevodu z DK
      else if IsFloat(Replace(',',AStringValue,cFADecimalSeparator)) then
        TFloatField(AField).Value:=
          Round(RoundAri(StrToFloat(Replace(cFADecimalSeparator,
          Replace(',',AStringValue,cFADecimalSeparator),DecimalSeparator))))
      else
        Result:=FALSE;
    end
    else if AField is TFloatField then begin
      if IsFloat(AStringValue) then
        TFloatField(AField).Value:=StrToFloat(Replace(cFADecimalSeparator,
          AStringValue,DecimalSeparator))
      else if IsFloat(Replace(',',AStringValue,cFADecimalSeparator)) then
        TFloatField(AField).Value:=
          StrToFloat(Replace(',',AStringValue,cFADecimalSeparator))
      else
        Result:=FALSE;
    end
    else if AField is TDateField then begin
      AStringValue := NormalizeDateStr(AStringValue);
      if IsDate(AStringValue) then begin
        if IsDigit(Copy(AStringValue,2,1)) then begin
          dd:=Copy(AStringValue,1,2);
          str:=Copy(AStringValue,4,maxint);
        end
        else begin
          dd:='0'+Copy(AStringValue,1,1);
          str:=Copy(AStringValue,3,maxint);
        end;
        if IsDigit(Copy(str,2,1)) then begin
          mm:=Copy(str,1,2);
          yyyy:=Copy(str,4,4);
        end
        else begin
          mm:='0'+Copy(str,1,1);
          yyyy:=Copy(str,3,4);
        end;
        TDateField(AField).AsDateTime:=EncodeDate(
          StrToInt(yyyy),StrToInt(mm),StrToInt(dd));
        //Osetrena chyba Delphi kdy nepochopilo spravne date separator nastaveny v systemu  
        {TDateField(AField).AsDateTime:=StrToDate(Replace(cFADateSeparator,
          AStringValue,DateSeparator));}
      end
      //pokud byl udaj ulozen jako datetime napr. v DK, odstranime time
      else if IsDate(Copy(AStringValue,1,Pos(' ',AStringValue)-1)) then
        TDateField(AField).AsDateTime:=StrToDate(Replace(cFADateSeparator,
        Copy(AStringValue,1,Pos(' ',AStringValue)-1),DateSeparator))
      else
        Result:=FALSE;
    end
    else if AField is TDateTimeField then begin
      AStringValue := NormalizeDateStr(AStringValue);
      if IsDate(AStringValue) then begin
        if IsDigit(Copy(AStringValue,2,1)) then begin
          dd:=Copy(AStringValue,1,2);
          str:=Copy(AStringValue,4,maxint);
        end
        else begin
          dd:='0'+Copy(AStringValue,1,1);
          str:=Copy(AStringValue,3,maxint);
        end;
        if IsDigit(Copy(str,2,1)) then begin
          mm:=Copy(str,1,2);
          yyyy:=Copy(str,4,4);
        end
        else begin
          mm:='0'+Copy(str,1,1);
          yyyy:=Copy(str,3,4);
        end;
        TDateField(AField).AsDateTime:=EncodeDate(
          StrToInt(yyyy),StrToInt(mm),StrToInt(dd));
        try
          dt:=StrToDateTime(Copy(AStringValue,12,8));
        except
          dt:=0;
        end;
        TDateField(AField).Value:=TDateField(AField).Value+dt;
        {TDateTimeField(AField).AsDateTime:=StrToDateTime(Replace(cFADateSeparator,
          AStringValue,DateSeparator));}
      end
      else
        Result:=FALSE;
    end
    else if AField is TBooleanField then begin
      TBooleanField(AField).AsBoolean:=StrToBoolSafe(AStringValue);
    end
    else if AField is TMemoField then begin
      lnNsID:=Length(sNestedSecID)+2;
      isInNS:=FALSE;
      if Copy(AStringValue,1,lnNsID)='['+sNestedSecID+']' then begin
        wstr:=Copy(AStringValue,1,lnNsID);
        for i:=lnNsID+1 to Length(AStringValue) do begin
          if Copy(AStringVAlue,i,lnNsID)='['+sNestedSecID+']' then
            isInNS:=TRUE;
          if isInNS then //uvnitr vnorene nested sections (to je druha uroven) nenahrazujeme CRLF, musi to zustat v radku
            wstr:=wstr+AStringValue[i]
          else begin
            if Copy(AStringValue,i,2)=cCRLFAlternate then
              wstr:=wstr+cCRLF
            else if Copy(AStringValue,i,2)=cCRLFAlternate1 then
              wstr:=wstr+cCRLFAlternate
            else if Copy(AStringValue,i,2)=cCRLFAlternate2 then
              wstr:=wstr+cCRLFAlternate1
            else if (Copy(AStringValue,i-1,2)=cCRLFAlternate) or
              (Copy(AStringValue,i-1,2)=cCRLFAlternate1) or
              (Copy(AStringValue,i-1,2)=cCRLFAlternate2) then begin
              //nedelame nic, protoze je to druhy znak z CRLF
            end
            else
              wstr:=wstr+AStringValue[i];
          end;
          if Copy(AStringVAlue,i,lnNsID+1)='[/'+sNestedSecID+']' then
            isInNS:=FALSE;
        end;
        TMemoField(AField).AsString:=wstr;
      end
      else
        TMemoField(AField).AsString:=
          Replace(cCRLFAlternate,AStringValue,cCRLF);
    end;
  end;
end; {StringToField}

//Prevede hodnotu udaje na text se zohlednenim poctu des mist,
//  s oddelovacem tisicu. K vyuziti pro tisk.

function FieldToStringFmt(AField: TField;
  AZeroValueClear, ANulNumValueFillZero: boolean;
  ADecimalPlaces: integer = 0; AThousandSeparator: boolean = TRUE): string;
var
  f: double;
begin
  if AField is TStringField then
    Result:=TStringField(AField).Value
  else if AField is TIntegerField then begin
    if TIntegerField(AField).IsNull then begin
      if ANulNumValueFillZero then
        Result:='0'
      else
        Result:='';
    end
    else begin
      f:=TIntegerField(AField).Value;
      if AThousandSeparator then
        Result:=Format('%.0n',[f])
      else
        Result:=Format('%.0f',[f]);
    end;
    if AZeroValueClear and (Result='0') then
      Result:='';
  end
  else if AField is TFloatField then begin
    if TIntegerField(AField).IsNull then begin
      if ANulNumValueFillZero then
        Result:='0'
      else
        Result:='';
    end
    else begin
      if AThousandSeparator then
        Result:=Format('%.'+IntToStr(ADecimalPlaces)+'n',
        [TFloatField(AField).Value])
      else
        Result:=Format('%.'+IntToStr(ADecimalPlaces)+'f',
        [TFloatField(AField).Value]);
      if AZeroValueClear and (TFloatField(AField).Value=0) then
        Result:='';
    end;
  end
  else if AField is TDateField then
    Result:=NormalizeDateStr(TDateField(AField).AsString)
  else if AField is TBooleanField then
    Result:=BoolToStr(TBooleanField(AField).AsBoolean,TRUE)
  else if AField is TMemoField then
    Result:=Replace(cCRLF,TMemoField(AField).AsString,cCRLFAlternate)
  else
    Result:='';
end; {FieldToStringFmt}

//Prevede retezcovou hodnotu typu AFldType na text se zohlednenim poctu des mist,
//  s oddelovacem tisicu. K vyuziti pro tisk.

function FldValueToStringFmt(const AFldType, AStrValue: string;
  ADecimalPlaces: integer = 0; AThousandSeparator: boolean = TRUE): string;
begin
  if (AFldType=cStringTypeValue)or(AFldType=cDateTypeValue)or
    (AFldType=cBooleanTypeValue) then
    Result:=AStrValue
  else if (AFldType=cNumericTypeValue)or(AFldType=cCurrencyTypeValue) then begin
    if AThousandSeparator then
      Result:=Format('%.'+IntToStr(ADecimalPlaces)+'n',
        [FCommonUtils.StrToFloatSafe(AStrValue)])
    else
      Result:=Format('%.'+IntToStr(ADecimalPlaces)+'f',
        [FCommonUtils.StrToFloatSafe(AStrValue)]);
  end
  else
    Result:='';
end; {FldValueToStringFmt}

function FieldIsEmpty(AField: TField): boolean;
begin
  Result:=AField.IsNULL or (AField.AsString='');
end; {FieldIsEmpty}

{-----------------------------------------------------------------------------
CompactStr ... string kde jsou konce radku zakodovane, pro potreby ulozeni mema
  do inisouboru
-----------------------------------------------------------------------------}

function StringToCompactStr(const AStr: string): string;
begin
  Result:=Replace(cCRLF,AStr,cCRLFAlternate);
end; {StringToCompactStr}

function CompactStrToString(const ACompactStr: string): string;
begin
  Result:=Replace(cCRLFAlternate,ACompactStr,cCRLF);
end; {CompactStrToString}


{-----------------------------------------------------------------------------
LoadMtFromZip
  Nacte obsah tabulky z definice
-----------------------------------------------------------------------------}
function LoadMtFromZip(AMt: TkbmMemTable; const AZipFileName: string;
  const APassword: string = ''): boolean;
var
  unzipper: TZipForge;
  st: TMemoryStream;
  ArchiveItem: TZFArchiveItem;
begin
  StartWait;
  Result:=False;
  unzipper := TZipForge.Create(nil);
  st:= TMemoryStream.Create;
  try try
    with unzipper do begin
      FileName := AZipFileName;  //Heslo aktualni verze
      //
      Password:=APassword;

      if not IsValidArchiveFile then begin
        Exit;
      end;

      OpenArchive(fmOpenRead);
      try
      // Search text files stored inside the archive
      if (FindFirst('*.*',ArchiveItem,faAnyFile-faDirectory)) then begin

         Result:=unzipper.IsFilePasswordValid(ArchiveItem.FileName, PassWord);

         if not Result then begin
           //Zkusme heslo minule verze
           PassWord:=Password+'$x';
           Result:=unzipper.IsFilePasswordValid(ArchiveItem.FileName, PassWord);
         end;

         //v editacnim modu pro externi strany zkusime s jinym heslem
         if not Result then begin
           PassWord:=cExternalPass;
           Result:=unzipper.IsFilePasswordValid(ArchiveItem.FileName, PassWord);

           {$IFDEF FINALBUILD}
             {$IFNDEF EXTERNALDESIGNER}
               Result:=FALSE;
               MessageErr('',sMsgNeautorizovanyZip,[MBOK]);
             {$ENDIF EXTERNALDESIGNER}
           {$ELSE FINALBUILD}
             {$IFNDEF EXTERNALDESIGNER}
               if Result then
                 MessageInfo('',sMsgNeautorizovanyZip,[MBOK]);
             {$ENDIF EXTERNALDESIGNER}
           {$ENDIF FINALBUILD}
         end;
      end;
      finally
        CloseArchive();
      end;
      
      if Result then begin
         OpenArchive(fmOpenRead);
         try
           try
             ExtractToStream(AMt.Name, st);
           except
             Result:=False;
           end;
         finally
           CloseArchive();
         end;
      end;
      if Result then begin
        st.Seek(0, soFromBeginning);
        AMt.LoadFromStream(st);
      end;
    end;
  finally
    unzipper.Free;
    st.Free;
    StopWait;
  end;
  except
    Result:=False;
  end;
end; {LoadMtFromZip}

procedure CopyRec(ASrcDataSet, ADestDataSet: TDataSet);
var
  i: integer;
  fldSrc, fldDst: TField;
begin
  for i := 0 to ASrcDataSet.Fields.Count - 1 do begin
    fldSrc := ASrcDataSet.Fields[i];
    if not fldSrc.IsNull then begin
      fldDst := ADestDataSet.FindField(fldSrc.FieldName);
      if fldDst <> nil then
        fldDst.Value := fldSrc.Value;
    end;
  end;
end; {CopyRecordByFieldNames}

procedure CopyTable(ASrc: TClientDataSet; ADst: TkbmMemTable);
begin
  StartWait;
  try
    ADst.EmptyTable;
    ASrc.First;
    ADst.DisableControls;
    ASrc.DisableControls;
    while not ASrc.EOF do begin
      ADst.Append;
      CopyRec(ASrc, ADst);
      ADst.Post;
      ASrc.Next;
    end;
  finally
    ADst.EnableControls;
    ASrc.EnableControls;
    StopWait;
  end;
end;

procedure CopyMemTable(ASrc: TkbmMemTable; ADst: TkbmMemTable);
begin
  StartWait;
  try
    ADst.EmptyTable;
    ASrc.First;
    ADst.DisableControls;
    ASrc.DisableControls;
    while not ASrc.EOF do begin
      ADst.Append;
      CopyRec(ASrc, ADst);
      ADst.Post;
      ASrc.Next;
    end;
  finally
    ADst.EnableControls;
    ASrc.EnableControls;
    StopWait;
  end;
end;

function CreateMemTableCopy(ASource: TkbmMemTable): TkbmMemTable;
var
  i: integer;
begin
  Result := TkbmMemTable.Create(nil);
  StartWait;
  try
    with Result do begin
      EmptyTable;
      with FieldDefs do begin
        Clear;
        for i := 0 to ASource.FieldDefs.Count-1 do begin
          with AddFieldDef do begin
            Result.FieldDefs[i].Name := ASource.FieldDefs[i].Name;
            Result.FieldDefs[i].DataType:=ASource.FieldDefs[i].DataType;
          end;
        end;
      end;
      CreateTable;
    end;
  finally
    StopWait;
  end;
end; {CreateMemTableCopy}



function FormatInfoString(const ALabel, AValue: string): string;
begin
  Result:=ALabel+': '+AValue;
end; {FormatInfoString}

//RtfToXmlStr
//vymena znaku zakazanych v XML
function RtfToXmlStr(const AValue: string): string;
begin
  Result := Replace('&', AValue, '&amp;');
  Result := Replace('"', Result, '&quot;');
  Result := Replace('<', Result, '&lt;');
  Result := Replace('>', Result, '&gt;');
end; {RtfToXmlStr}

//XmlStrToRtf
//konverze nahrazenych znaku do rtf
function XmlStrToRtf(const AValue: string): string;
begin
  Result := Replace('&amp;', AValue, '&');
  Result := Replace('&quot;', Result, '"');
  Result := Replace('&lt;', Result, '<');
  Result := Replace('&gt;', Result, '>');
end; {XmlStrToRtf}

//pro pristup k funkci JCL - v main nelze pozit uses JclSysInfo kvuli kolizi nazvu funkci se systemovymi
function GetEnvVar(const Name: string; var Value: string;
  Expand: Boolean): Boolean;
begin
  Result:=GetEnvironmentVar(Name, Value, Expand);
end;

{$IFDEF STANDALONE}
procedure SaveSlaveRequestVykaz(const AVykazID, AObdobiDo: string;
  AVTisicich: boolean);
const
  cIniFaResult = 'FaResult';
  cValNameResult = 'Result';
  cRqRequireVykaz='RequireVykaz';
  cValVykazID='VykazID';
  cValObdobiOd='ObdobiOd';
  cValObdobiDo='ObdobiDo';
  cValVJednotkach='VJednotkach';
var
  ini: TMemIniFile;
  sl: TStringList;
  datumOd, datumDo: TDate;
begin
  ini := TMemIniFile.Create(NormalPath(ExtractFilePath(
    Application.ExeName)) + cDKResultFileName);
  sl := TstringList.Create;
  try
    datumOd:=StrToDateSafe('01.01.'+IntToStr(YearOf(StrToDateSafe(AObdobiDo))));
    datumDo:=StrToDateSafe(AObdobiDo);
    AskDateDate(sObdobiVykazu, mbOKCancel, mbOK,mbCancel,
      sOd, datumOd, sDo, datumDo);
    ini.WriteString(cIniFaResult, cValNameResult, cRqRequireVykaz);
    ini.WriteString(cIniFaResult, cValVykazID, AVykazID);
    ini.WriteString(cIniFaResult, cValObdobiOd, DateToStr(datumOd));
    ini.WriteString(cIniFaResult, cValObdobiDo, DateToStr(datumDo));
    if AVTisicich then
      ini.WriteString(cIniFaResult, cValVJednotkach, 'FALSE')
    else
      ini.WriteString(cIniFaResult, cValVJednotkach, 'TRUE');
    SaveMemIni(ini);
  finally
    ini.Free;
    sl.Free;
  end;
end; {SaveSlaveRequestVykaz}

procedure SaveSlaveRequestSelForm(const ADefId: string;
  AMultiSelect: boolean; const ACaption: string);
const
  cIniFaResult = 'FaResult';
  cValNameResult = 'Result';
  cValSelDefID = 'SelDefID';
  cRqRequireSelectForm='RequireSelectForm';
  cValSelMultiselect='SelMultiSelect';
var
  ini: TMemIniFile;
  sl: TStringList;
begin
  ini := TMemIniFile.Create(NormalPath(ExtractFilePath(
    Application.ExeName)) + cDKResultFileName);
  sl := TstringList.Create;
  try
    ini.WriteString(cIniFaResult, cValNameResult, cRqRequireSelectForm);
    ini.WriteString(cIniFaResult, cValSelDefID, ADefId);
    ini.WriteBool(cIniFaResult, cValSelMultiselect, AMultiSelect);
    ini.WriteString(cIniFaResult, cValSelMultiselect, ACaption);
    SaveMemIni(ini);
  finally
    ini.Free;
    sl.Free;
  end;
end; {SaveSlaveRequestSelForm}


//konverzni funkce pro import z DK

function TranslateDKId(AOldID:string):string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
{$I Konverze.inc}
  try
    Result := sl.Values[AOldId];
  finally
    sl.Free;
  end;
end;{TranslateID}

function CreateDataHeader(AID:Integer;ADefID:string;
  AGroup:string;ASubGroup:string;
  ACreateDate:TDateTime; AModifDate:TDateTime; ALocked: boolean):string;
var ltext:string;
begin
  lTExt:='[FormHead]'+#13#10+
      'ID='+IntToStr(AID)+#13#10+
      'DefID='+ADefId+#13#10+
      'Group='+AGroup+#13#10+
      'SubGroup='+ASubGroup+#13#10+
      'CreateDate='+DateToStr(ACreateDate)+#13#10+
      'ModifiedDate='+DateToStr(AModifDate)+#13#10+
      'ModifiedTime=0'+#13#10+
      'Autor='+'upgrade'+#13#10+
      'Locked='+BoolToStr(ALocked)+#13#10#13#10+
      '[Values]'+#13#10;
  Result:=lText;
end;{GenerateHeader}

function TranslateDKRow(ARow:string; APosunRadkuDS: integer = 0):string;
var lsep:TStringList;
    row:string;
begin
  lSep:=TStringList.Create();
  try
    if APosunRadkuDS>0 then begin
      if (Copy(ARow,1,1)='T') and IsInteger(Copy(ARow,2,4)) then
        ARow:='T'+ StrPadLeft(IntToStr(StrToIntSafe(Copy(ARow,2,4))-
          (25+(APosunRadkuDS-1)*25)),4,'0')+Copy(ARow,6,maxint);
    end;
    StrTokenToStrings(ARow,';',lSep);
    row:=lSep[0];
    row:=copy(lSep[0],1,length(lSep[0])-1);
    if Copy(lSep[0],length(lSep[0]),1)='0' then //prvni parametr=0 -> boolean
      if lSep[1]='1' then
        Result:=row+'True'
      else
        Result:=row+'False'
    else begin
      if (Pos(',',lSep[2])>0) and IsFloat(Replace(',',lSep[2],'.')) then begin
        lSep[2]:=Replace(',',lSep[2],'.');
        lSep[2]:=StrTrimCharRight(lSep[2],'.');
      end;
      Result:=row+lSep[2];
    end;
  finally
    lSep.Free;
  end;
end;{TranslateRow}

//Prevede data z formatu DK do formatu FA
//   ADKDefID ... cislo formulare v DK prevedene na retezec
//   ADataString ... obsah Body v DK
//   Vraci data formatu FA
//
function ConvertTskpDKToFA(const ADKDefID, ADataString: string): string;
var
  sl: TStringList;
  i: integer;
begin
  Result := CreateDataHeader(-1, TranslateDKId(ADKDefID),'','',0,0,FALSE);
  sl:= TStringList.Create;
  try
    sl.Text := ADataString;
    for i := 0 to sl.Count - 1 do
      Result:=Result + TranslateDKRow(sl[i]) + #13#10;
  finally
    sl.Free;
  end;
end;

{$ENDIF STANDALONE}

function IsXMLOneForm(const AXMLData: string; AXMLDoc: TXMLDocument): boolean;
begin
  StartWait;
  try
    AXMLDoc.XML.Text := AXMLData;
    AXMLDoc.Active := TRUE;
    Result:= AXMLDoc.DocumentElement.NodeName = cFormXMLRootLabel;
    AXMLDoc.Active := FALSE;
  finally
    StopWait;
  end;
end; {IsXMLOneForm}

function IsXMLForms(const AXMLData: string; AXMLDoc: TXMLDocument): boolean;
begin
  StartWait;
  try
    AXMLDoc.XML.Text := AXMLData;
    AXMLDoc.Active := TRUE;
    Result:= AXMLDoc.DocumentElement.NodeName = cFormXMLFormsRootLabel;
    AXMLDoc.Active := FALSE;
  finally
    StopWait;
  end;
end; {IsXMLForms}

function GetFillingSubjectInfo(AParent: TComponent; const AXMLFillingDoc: string;
  const AVetaPAttrName: string; const AVetaTyp: string = 'VetaP'): string;
var
  node, node1, node2: IXMLNode;
  XMLDoc: TXMLDocument;
  s: string;
begin
  Result := '';
  XMLDoc:= TXMLDocument.Create(AParent);
  try
    XMLDoc.XML.Text := AXMLFillingDoc;
    XMLDoc.Active := TRUE;
    node := XMLDoc.DocumentElement;
    node1 := node.ChildNodes[0];
    if node1 <> nil then begin
      node2 := node1.ChildNodes[AVetaTyp];
      if node2 <> nil then begin
        if node2.Attributes[AVetaPAttrName]<>null then
          s := VarToStr(node2.Attributes[AVetaPAttrName])
        else
          s:='';
        Result := s;
      end;
    end;
  finally
    XMLDoc.Free;
  end;
end; {GetFillingSubjectInfo}

procedure CreateQRCode(
   const AStream: TStream; //soubor s vytvorenym obrazkem s QRCode
   const AQRText: string;
   AWidth: integer = 200; AHeight: integer = 200);
var
  ex: TpsExportImport;
  bcComp: TpsBarcodeComponent;
begin
  ex := TpsExportImport.Create(nil);
  bcComp := TpsBarcodeComponent.Create(nil);
  try
    ex.BarCode := bcComp;
    bcComp.BarCodeSymbology := bcQRCode;
    bcComp.BarCode := AQRText;
    //ex.SaveToFile(AFileNameQRC, AWidthMax, AheightMax);
    ex.SaveToStreamBmp(AStream, AWidth, Aheight);
  finally
    ex.Free;
    bcComp.Free;
  end;
end;

procedure CreateBarCode(
   const AStream: TStream; //soubor s vytvorenym obrazkem s carovym kodem
   const ABarCodeText: string;
   const ACodeType: string;
   AWidth: integer = 200; AHeight: integer = 200);
var
  ex: TpsExportImport;
  bcComp: TpsBarcodeComponent;
  code: TpsBarcodeSymbology;
begin
  ex := TpsExportImport.Create(nil);
  bcComp := TpsBarcodeComponent.Create(nil);
  try
    if ACodeType='Ean8' then code:=bcEan8
    else if ACodeType='Ean13' then code:=bcEan13
    else if ACodeType='Codabar' then code:=bcCodabar
    else if ACodeType='Code39Standard' then code:=bcCode39Standard
    else if ACodeType='Code39Full' then code:=bcCode39Full
    else if ACodeType='Code93Standard' then code:=bcCode93Standard
    else if ACodeType='Code93Full' then code:=bcCode93Full
    else if ACodeType='Code128' then code:=bcCode128
    else if ACodeType='ABCCodabar' then code:=bcABCCodabar
    else if ACodeType='25Datalogic' then code:=bc25Datalogic
    else if ACodeType='25Interleaved' then code:=bc25Interleaved
    else if ACodeType='25Matrix' then code:=bc25Matrix
    else if ACodeType='25Industrial' then code:=bc25Industrial
    else if ACodeType='25IATA' then code:=bc25IATA
    else if ACodeType='25Invert' then code:=bc25Invert
    else if ACodeType='ITF' then code:=bcITF
    else if ACodeType='ISBN' then code:=bcISBN
    else if ACodeType='ISSN' then code:=bcISSN
    else if ACodeType='ISMN' then code:=bcISMN
    else if ACodeType='UPCA' then code:=bcUPCA
    else if ACodeType='UPCE0' then code:=bcUPCE0
    else if ACodeType='UPCE1' then code:=bcUPCE1
    else if ACodeType='UPCShipping' then code:=bcUPCShipping
    else if ACodeType='SCC14' then code:=bcSCC14
    else if ACodeType='JAN8' then code:=bcJAN8
    else if ACodeType='JAN13' then code:=bcJAN13
    else if ACodeType='MSIPlessey' then code:=bcMSIPlessey
    else if ACodeType='PostNet' then code:=bcPostNet
    else if ACodeType='Planet' then code:=bcPlanet
    else if ACodeType='RoyalMail' then code:=bcRoyalMail
    else if ACodeType='4State' then code:=bc4State
    else if ACodeType='Dutch4StatePostal' then code:=bcDutch4StatePostal
    else if ACodeType='SwissPostal' then code:=bcSwissPostal
    else if ACodeType='Singapore4StatePostalCode' then code:=bcSingapore4StatePostalCode
    else if ACodeType='PostBar' then code:=bcPostBar
    else if ACodeType='PostbarCPC4State' then code:=bcPostbarCPC4State
    else if ACodeType='OPC' then code:=bcOPC
    else if ACodeType='UccEan128' then code:=bcUccEan128
    else if ACodeType='25Coop' then code:=bc25Coop
    else if ACodeType='Code11' then code:=bcCode11
    else if ACodeType='PZN' then code:=bcPZN
    else if ACodeType='PDF417' then code:=bcPDF417
    else if ACodeType='CodablockF' then code:=bcCodablockF
    else if ACodeType='SSCC' then code:=bcSSCC
    else if ACodeType='SISAC' then code:=bcSISAC
    else if ACodeType='Code16K' then code:=bcCode16K
    else if ACodeType='CodabarMonarch' then code:=bcCodabarMonarch
    else if ACodeType='Fim' then code:=bcFim
    else if ACodeType='DataMatrix' then code:=bcDataMatrix
    else if ACodeType='QRCode' then code:=bcQRCode
    else if ACodeType='Aztec' then code:=bcAztec;

    ex.BarCode := bcComp;
    bcComp.BarCodeSymbology := code;
    bcComp.BarCode := ABarCodeText;
    //ex.SaveToFile(AFileNameQRC, AWidthMax, AheightMax);
    ex.SaveToStreamBmp(AStream, AWidth, Aheight);
  finally
    ex.Free;
    bcComp.Free;
  end;
end;

function LoadPartReportSettings(const AIniFileName: string): TReportSettings;
var
  iniFile: TMemIniFile;
  section: string;
const
  cIniRepSetSection = 'ReportSettings';
  cRepInternalReader = 'RepInternalReader';
  cRepExternalReader = 'OpenAcrobatInNewApplication';
  cRepEditorReader = 'RepEditorReader';
  cRepOpenUserDefWindow = 'OpenAcrobatInUserApplication';
  cRepUserCMDPreview = 'UserPreviewCMD';
  cRepUserCMDPrint = 'UserPrintCMD';
  cRepOpenReaderInWindow = 'RepOpenReaderInWindow';
begin
  iniFile := TMemIniFile.Create(AIniFileName);
  try
    with Result do begin
      section:=cIniRepSetSection;
      RepInternalReader := iniFile.ReadBool(section, cRepOpenReaderInWindow,FALSE);
      RepEditorReader := iniFile.ReadBool(section, cRepEditorReader,FALSE);
      RepExternalReader := iniFile.ReadBool(section, cRepExternalReader, FALSE);
      RepUserDefined := iniFile.ReadBool(section, cRepOpenUserDefWindow,FALSE);
      CMDShow:= iniFile.ReadString(section, cRepUserCMDPreview, '');
      CMDPrint:= iniFile.ReadString(section, cRepUserCMDPrint, '');
    end;
  finally
    iniFile.Free;
  end;
end; {LoadPartReportSettings}

procedure OpenPDFFile(const fn: string);
var
  rs: TReportSettings;
  readerExePath : string;
  exeFile,exeParams,cmd:string;
  poziceExe: integer;

  function GetPosLastExecute(radek:string):Integer;
  var
    i,j,k:Integer;
  begin
    Result:=-1;
    i:=Pos('.exe',radek);
    j:=Pos('.bat',radek);
    k:=Pos('.com',radek);
    if i>0 then
      Result:=i
    else if j>0 then
      Result:=j
    else if k>0 then
      Result:=k;
    if Result>0 then
      Result:=Result+3;
  end;

begin
    rs.RepEditorReader:=false;
    rs.RepExternalReader:=false;
    rs.RepUserDefined:=false;
    rs.RepInternalReader:=false;
{$IFDEF STANDALONE}
    {$IFNDEF STEREONX}
    rs:=LoadPartReportSettings(NormalPath(gFUserDataPath) + cFormAsistentExeName + cIniDefaultExt);
    {$ELSE}
      //#MR 2025 onedir u fa.exe, uer/all v podslozce Forms
      rs:= LoadPartReportSettings(NormalPath(gFUserDataPath) + cFormAsistentExeName + cIniDefaultExt);
    {$ENDIF}

{$ELSE STANDALONE}
    rs:=LoadPartReportSettings(GetFormsIniPath);
{$ENDIF STANDALONE}
    if rs.RepEditorReader then begin
      readerExePath:=GetPDFEditor;
      if not ShellOpenPdf(readerExePath, fn, ctOpen, gFUserDataPath, not IsLicStart) then
              MessageWarn('', SmsgNeniPDFEditor+#13#10#13#10+SmsgNeniPDFEditorReseni, [MBOK]);
    end
    else if rs.RepExternalReader then begin
      if ShellFindExecutable(fn, '')<>'' then
        ShellOpen(fn)
      else
        MessageWarn('PDF', SmsgNeniAsociace+#13#10#13#10+SmsgNeniAsociaceReseni, [MBOK]);
    end
    else if rs.RepUserDefined then begin
        cmd:=rs.CMDShow;
        poziceExe:=GetPosLastExecute(cmd);
        exeFile:=Copy(cmd,0,poziceExe);
        exeParams:=Copy(cmd,poziceExe+1,Length(cmd)-length(exeFile));
        exeParams:=ReplaceText(exeParams,'%1',fn);
        if (exeFile='') or (not FileExists(exeFile)) then begin
           MessageErr('PDF','Spustitelný soubor pro náhled PDF dokumentu není definován nebo neexistuje: '+#13#10+exeFile,[MBOK]);
           Exit;
         end;

         try
           ShellExecEx(exeFile, exeParams);
         except
           on E: Exception do
             MessageErr('Náhled PDF','Chyba pøi spouštìní externí aplikace'#13#10+E.Message,[MBOK])
         end;
    end
    else
      ViewPdfFile(fn,rs,'Informace',true)
end;

function IsWebBrowser: boolean;
var
  pozice:Integer;
begin
  {$IFNDEF STEREONX}
    Result:=DirectoryExists(ExtractFilePath(Application.ExeName)+PathDelim+cWebBrowserDir);
  {$ELSE}
    //#MR 2025
   pozice:= Pos('\Forms', Application.ExeName);
   if (pozice>0) then //exe formAsistent je v podslozce Forms
        Result:= DirectoryExists(copy(Application.ExeName, 1, pozice - 1)+PathDelim+cWebBrowserDir)
      else
        Result:= DirectoryExists(ExtractFilePath(Application.ExeName)+PathDelim+cWebBrowserDir);
  {$ENDIF}
end;

{
URL=***URL*** 'https://adisepo.mfcr.cz/adistc/adis/idpr_epo/epo2/spol/soubor_vyber.faces'
ISDSName=***ISDSNAME***
ISDSPassword=***ISDSPASSWORD***
DataFilePath=***DATAFILEPATH***
AppAction=***APPACTION***
AppName=***APPNAME***
}
procedure OpenWebBrowser(
  const URL: string;
  const ISDSName: string;
  const ISDSPassword: string;
  const DataFilePath: string;
  const AppAction: string;
  const AppCaption: string;
  const EETname: string = '';
  const EETpassword: string = '');
var
  pth,inipth,inipths,inistr: string;
begin
  pth:=NormalPath(ExtractFilePath(Application.ExeName))+cWebBrowserDir;
  inipths:=NormalPath(pth)+'FSXWebBrowser.ini';
  {$IFDEF STANDALONE}
  inipth:=NormalPath(GetWorkPath)+'FSXWebBrowser.ini';
  {$ELSE STANDALONE}
  inipth:=NormalPath(GetTempPath)+'FSXWebBrowser.ini';
  {$ENDIF STANDALONE}
  //if not FileExists(inipth) then
  CopyFile(PChar(inipths),PChar(inipth),False);
  if FileExists(inipth) then begin
    inistr:=LoadStringFromFile(inipth);
    inistr:=Replace('***URL***',inistr,URL);
    inistr:=Replace('***ISDSNAME***',inistr,ISDSName);
    inistr:=Replace('***ISDSPASSWORD***',inistr,ISDSPassword);
    inistr:=Replace('***DATAFILEPATH***',inistr,DataFilePath);
    inistr:=Replace('***APPACTION***',inistr,AppAction);
    inistr:=Replace('***APPNAME***',inistr,AppCaption);
    inistr:=Replace('***EETNAME***',inistr,EETname);
    inistr:=Replace('***EETPASSWORD***',inistr,EETpassword);
    SaveStringToFile(inistr,inipth);
    //
    ShellExecute(0, nil, PChar(NormalPath(pth)+'FSXWebBrowser.exe'), PChar('"'+inipth+'"'), nil,
      SW_SHOWNORMAL)
  end;
end;

procedure OpenWebBrowserDanInfSchr(
  const ISDSName: string;
  const ISDSPassword: string;
  const EETname: string = '';
  const EETpassword: string = '');
begin
  OpenWebBrowser(
    //puvodne 'http://adisspr.mfcr.cz/adistc/adis/idpr_pub/dpr/uvod.faces' vezem se s distrib. ini
    'https://adisspr.mfcr.cz/pmd/home',
    ISDSName,ISDSPassword,
    '','LOGIN','Moje danì - Finanèní správa',
    EETname,EETpassword);
end;

procedure OpenWebBrowserPortalCSSZ(
  const ISDSName: string;
  const ISDSPassword: string);
begin
  OpenWebBrowser(
    'https://eportal.cssz.cz/ikr-cas/login?service=https%3A%2F%2Feportal.cssz.cz%2Fc%2Fportal%2Flogin',
    ISDSName,ISDSPassword,
    '','LOGIN','Portál ÈSSZ');
end;

//Vymaze z textu radky podle prepinacu, podmineny preklad
  //{#OFF FILLING}
  //{#OFFBEG FILLING}
  //{#OFFEND FILLING}
function AcceptScriptDirectives(const AScript: string): string;
const
  cSwOff = '{#OFF ';
  cSwBeg = '{#OFFBEG ';
  cSwEnd = '{#OFFEND ';
var
  s: string;
  i,j,n: integer;
  sl1,sl2,slw: TStringList;
  swOn: Boolean;
  wordOff: string;
begin
  Result:=AScript;
{$IFNDEF FINALBUILD}
  sl1:=TStringList.Create();
  sl2:=TStringList.Create();
  slw:=TStringList.Create();
  try
    sl1.Text:=AScript;
    for i := 0 to Min(100,sl1.Count-1) do begin // najdeme v prvnich 100 radcich '{$OFF '
      n:=Pos(cSwOff,AnsiUpperCase(sl1[i]));
      if n>0 then
        slw.Add(Trim(UpperCase(Copy(sl1[i],n+Length(cSwOff),Pos('}',sl1[i])-n-Length(cSwOff)))));
    end;
    swOn:=True;
    for i := 0 to sl1.Count - 1 do begin
       if not swOn then begin
         if Pos(Replace(' ',cSwEnd+wordOff+'}',''),Replace(' ',AnsiUpperCase(sl1[i]),''))>0 then begin
           swOn:=True;
           wordOff:='';
         end;
       end;
       if swOn then
         sl2.Add(sl1[i]);
       for j := 0 to slw.Count - 1 do begin
         if swOn then begin
           if Pos(Replace(' ',cSwBeg+slw[j]+'}',''),Replace(' ',AnsiUpperCase(sl1[i]),''))>0 then begin
             swOn:=False;
             wordOff:=slw[j];
           end;
         end;
       end;
    end;
    //MsgBoxInfo('',sl2.Text,MB_OK);
    Result:=sl2.Text;
  finally
    sl1.Free;
    sl2.Free;
    slw.Free;
  end;
{$ENDIF FINALBUILD}
end;

end.


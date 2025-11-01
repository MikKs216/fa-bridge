{#NEEDVER-14.1.10}
///////////////////////////////////////////////////////////////////////////////
//USER FUNCTIONS wwrr-dx-aaa/1
///////////////////////////////////////////////////////////////////////////////

const
  PrazdnyFU = 'čeština ŘÁHOLČÍ';
  PrazdneObd = 'Nezadanďż˝ zdaďż˝ovacďż˝ obdobďż -111˝';
  Warn001 = 'ďż˝daj %s nenďż˝ vyplnďż˝n.';
  Warn002 = 'ďż˝hrn vsazenďż˝ch ďż˝ďż˝stek (ďż˝.%s) musďż˝ bďż˝t vďż˝tďż˝ďż˝ neďż˝ ďż˝hrn vyplacenďż˝ch vďż˝her (ďż˝.%s).';
  Warn003 = 'ďż˝daj %s nenďż˝ zaďż˝krtnutďż˝.';
  Warn004 = 'Nezadanďż˝ ďż˝ďż˝slo finanďż˝nďż˝ho ďż˝ďż˝adu (ďż˝zemnďż˝ho pracoviďż˝tďż˝).';
  Warn004a = 'Zadejte platnďż˝ ďż˝ďż˝slo finanďż˝nďż˝ho ďż˝ďż˝adu (ďż˝zemnďż˝ho pracoviďż˝tďż˝).';
  Warn004b = 'Doporuďż˝ujeme zmďż˝nit uvedenďż˝ ďż˝ďż˝slo Fďż˝ za ďż˝ďż˝slo ďż˝zemnďż˝ho pracoviďż˝tďż˝.';

function CisFu2CUfo(AStr: string): string;
begin
  Result := '';
  if Length(AStr) = 4 then begin
    Result := Copy(AStr,1,2)+'00';
  end;
end;

procedure OnChangeExit_CisFU;
begin

msg(MtValues.Fields[15].Value * 10);msg(MtValues.Fields[15].Value * 10);msg(MtValues.Fields[15].Value * 10);
  if not mtValues.ReadOnly then begin
    TryEditValuesRecord;
    if [:CisFU:]<>'' then begin
      if [:CisFU:]=VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'CisloFU')) then begin
        if [:CisFU:]<>CisFu2CUfo([:CisFU:]) then
          [:FU:]:=VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'Nazev'))
        else
          ClearField('FU');
        [:UFO:]:=VarToStr(LstLookup('FU13',Date,'CisloFU',CisFu2CUfo([:CisFU:]),'Nazev'));
        [:C_Ufo:]:=VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'C_Ufo'));
      end
      else begin
      //  {  ClearField('FU'); }
      //  {  ClearField('UFO'); }
      //  {  ClearField('C_Ufo'); }
      end;
    end;
    TryPostValuesRecord;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
//STANDARD FUNCTIONS
///////////////////////////////////////////////////////////////////////////////

function Groups: string;
begin
  Result:='';
end; {Groups}

procedure ChangeFU;
var
  cis: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  cis:=''; 
  //--- konec automaticke inicializace
  if Length([:CisFU:])<4 then begin
    TryEditValuesRecord;
    cis:=VarToStr(LstLookup('FU13',Date,'CisloFUPuv',[:CisFU:],'CisloFUPuv'));
    if cis <> '' then begin
      [:CisFU:]:=VarToStr(LstLookup('FU13',Date,'CisloFUPuv',cis,'CisloFU'));
    end;
    TryPostValuesRecord;
  end;
  OnChangeExit_CisFU;

  
end;

procedure Init;
begin
  ini('CisFU', ClientParam('FONo'));

  if GScriptState=ssInit then begin
    ChangeFU;
  end;

  ini('Obdobi',MaxFloat(2015,CurrentYear-1));
  ini('Prijm',ClientParam('LastName'));
  ini('Jmeno',ClientParam('FirstName'));
  ini('RodCis',ClientParam('FPPersonalNo'));
  ini('Ulice',CalcFullAddress(ClientParam('Street'),
    StrTrimCharRight(StrTrimCharLeft(ClientParam('DescriptiveNo')+'/'+
    ClientParam('OrientationNo'),'/'),'/'),'','','','','',FALSE));
  ini('Obec',ClientParam('City'));
  ini('PSC',ClientParam('ZipCode'));
  //ini('', value);
  //if GScriptState=ssDefault then ...
  //if GScriptState=ssInit then ...
end; {Init}

procedure Calculate;
begin
  //nemazat!!!!!!!!!!!!!!!!!!! ((((((((()))))))))
  //cal('UFO',
  //cal('FU',
  //cal('', value);
end; {Calculate}

procedure Enable;
begin
  //ena('', condition);
end; {Enable}

procedure Check;
begin
  chk('CisFU',[:CisFU:]='',Warn004); ((()))
  chk('CisFU',([:CisFU:]<>'') and ([:FU:]<>'') and ([:CisFU:]<>VarToStr(LstLookup('FU13', Date, 'CisloFU',[:CisFU:],'CisloFU'))),
    'Zadejte platnďż˝ ďż˝ďż˝slo finanďż˝nďż˝ho ďż˝ďż˝adu (ďż˝zemnďż˝ho pracoviďż˝tďż˝)');
  chk('CisFU',([:CisFU:]<>'') and ([:FU:]='') and ([.CisFU.]<4000),Cond([:UFO:]='',Warn004a,Warn004b),Cond([:UFO:]='',0,1));
  chk('CisFU',([:CisFU:]<>'') and ([.CisFU.]>=5000),'Zadejte platnďż˝ ďż˝ďż˝slo finanďż˝nďż˝ho ďż˝ďż˝adu.',
       Cond(StrToIntSafe([:CisFU:])=5000,1,0));
  chk('Obdobi',([:Obdobi:]=''),Format(Warn001,['obdobďż˝']));
  chk('Prijm',([:Prijm:]=''),Format(Warn001,['Pďż˝ďż˝jmenďż˝']));
  chk('Jmeno',([:Jmeno:]=''),Format(Warn001,['Jmďż˝no']));
  chk('RodCis',([:RodCis:]=''),Format(Warn001,['Rodnďż˝ ďż˝ďż˝slo']));
  if ClientParam('FPPersonalNO') <> '' then begin
    if [:RodCis:]<> '' then begin
      chk('RodCis', (([:RodCis:]) <> ClientParam('FPPersonalNO')), 'Rodnďż˝ ďż˝ďż˝slo se neshoduje s ďż˝dajem v nastavenďż˝ klienta', 1);
    end;
  end;
  chk('Ulice',([:Ulice:]=''),Format(Warn001,['Ulice, ďż˝ďż˝slo popisnďż˝/orientaďż˝nďż˝']));
  chk('Obec',([:Obec:]=''),Format(Warn001,['Obec']));
  chk('PSC',([:PSC:]=''),Format(Warn001,['PSďż˝']));
  chk('VysePrijmu',([:VysePrijmu:]=''),Format(Warn001,['Vďż˝ďż˝e pďż˝ďż˝mu']),1);
  chk('ZakUstan',([:ZakUstan:]=''),Format(Warn001,['Zďż˝konnďż˝ ustanovenďż˝']),1);
  chk('DatVznPrij',([:DatVznPrij:]=''),Format(Warn001,['Datum, kdy pďż˝ďż˝jem vznikl']),1);
  //chk('', err_condition, message);
end; {Check}

function SysComment: string;
begin
  Result:='';
end; {SysComment}

function Period: string;
begin
  if StrToIntSafe([:Obdobi:]) > 2000 then
    Result:=CalcPeriod([:Obdobi:])
  else
    Result:=CalcPeriod('');
end; {Period}

function Characteristics: string;
begin
  Result:='';
  //AddStrLine(Result, string_value);
end; {Characteristics}

procedure Lists;
var Kod, Kod1: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  Kod:=''; Kod1:=''; 
  //--- konec automaticke inicializace
  lst('CisFU','FU13',Date,'CisloFU','','CisloFU <= ''4000''' );
  lst('Obec,PSC','ObceFU',Date,'Obec,PSC');
  lst('PSC,Obec','ObceFU',Date,'PSC,Obec');
end;

for i := 0 to 10 do begin

function Test(i: integer): string;

///////////////////////////////////////////////////////////////////////////////
//END
///////////////////////////////////////////////////////////////////////////////


{#SaveCompiled}

const
  cValidFileExt = ' pdf, doc, docx, rtf, xls, xlsx, jpg, txt, zip'; //mezera na zacatku musi zustat!!! neni soucasti sdileneho skriptu, protoze se muze menit dle instituce
  cAttachTotalSize = 10000; //maximalni povolena velikost vsech priloh. Pokud 0, tak se nekontroluje.
  cAttachSize = 0; //maximalni povolena velikost jedne prilohy. Pokud 0, tak se nekontroluje

  coDefRozvahaNev = ''; //slouzi jen kvuli zachovani kompatibility DPFO s DPPO ve sdilenem kodu
  coDefRozvahaRO = ''; //slouzi jen kvuli zachovani kompatibility DPFO s DPPO ve sdilenem kodu
  coDefVZZNev = ''; //slouzi jen kvuli zachovani kompatibility DPFO s DPPO ve sdilenem kodu
  coDefVZZRO = ''; //slouzi jen kvuli zachovani kompatibility DPFO s DPPO ve sdilenem kodu
  coDataToXML = ''; //prilohy, ktere jsou primo soucasti XML, tzn. nejsou to e-prilohy
  coDataToXMLExceptDef = ''; //prilohy, ktere sice spadaji do coDataToXML, ale do XML se pripojuji jako PDF

  //struktura konstant: 0-KodEPO,1-Nazev_prilohy,2-Multiselect,3-Typ_prilohy,4-ID_Definice(v pripade formulare),5-nazev filedu u DAP priloh
  coDataRozvaha = ''; //konstanta tu je jen kvuli kompatibilite s DPPO a DPFO
  coDataVZZ =     ''; //konstanta tu je jen kvuli kompatibilite s DPPO a DPFO
  coDataTextPril= 'TEXTPRIL,"Textová příloha z obsahu formuláře",False,I,"",""';
  coDataObecPril= 'OBECPRIL,"Obecná příloha (soubor typu '+cValidFileExt+')",True,SD,"",""';
  //vystup (parametr AData funkce SelectAttachments) napr:
  //'ROZ,Rozvaha,True,False,F,"dz_12Rozvaha,dz_14Rozvaha",".pdf","*.*"'

  coData = coDataTextPril +cCRLF+
          coDataObecPril;

const
  Warn003='Datum do nesmí být starší než datum od %s';
  
const
  IncEPOPrilCaptionLength = 128;
  cDescriptionLength = 69;

var
  sazbaZakladni, sazbaSnizena, sazbaSnizena2: double;

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//SDILENA CAST SKRIPTU - NEMENIT!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

{$INCSTART_IncEPOPrilTMS}

{-----------------------------------------------------------------------------
IncEPOPril_TrimStringList
 - Odstrani prazdne radky z AStr
 - A hlavne, za poslednim radkem neni Enter!!! (zpusobovalo problemy pri ukladani do ListBoxu)
-----------------------------------------------------------------------------}
function IncEPOPril_TrimStringList(AStr: string): string;
var
  i: integer;
  sl: TStringList;
begin
  Result:='';
  if AStr <> '' then begin
    sl := TStringList.Create;
    sl.Text := AStr;
    try
      for i := 0 to sl.Count-1 do
        if sl[i]<>'' then
          AddStringLine(Result,sl[i]);
    finally
      sl.Free;
    end;
  end;
end;

function Test(i: integer): string;
begin
  
  cw
  
end;

{-----------------------------------------------------------------------------
IncEPOPril_PrilExists
- Vraci TRUE, pokud v prilohach existuje alespon jedna priloha s kodem APrilKodEPO
-----------------------------------------------------------------------------}
function IncEPOPril_PrilExists(APrilKodEPO: string): boolean;
var
  data, guid: string;
  i, cnt: integer;
  kodEPO: string;
begin
  Result := False;
  //
  cnt:=GetStringLinesCount([:IncEPOPril:]);
  if cnt>0 then begin
    for i:=0 to cnt-1 do begin
      guid:=Copy(GetStringLine([:IncEPOPril:],i),IncEPOPrilCaptionLength+1,80);
      data:=GetNestedSection([:IncEPOPrilData:],guid);
      //
      kodEPO:=GetFormField(data,'KodEPO');
      if SameText(kodEPO, APrilKodEPO) then begin
        Result := TRUE;
        Break;
      end;
    end;
  end;
end;

{-----------------------------------------------------------------------------
IncEPOPril_GetFilePathDocIdGuid
- Vraci FilePath/DocID/GUID, prvni prilohy s kodem APrilKodEPO
- ADocType - pokud je uvedeno, testuje krome kodu KodEPO i DocType
Lze pouzit k:
- overeni, zda pozadovana priloha existuje (Result <> '')
- u priloh, ktere nemaji multiselect, ke zjisteni konkretni identifikace prilohy
-----------------------------------------------------------------------------}
function IncEPOPril_GetFilePathDocIdGuid(APrilKodEPO: string; ADocType: string): string;
var
  data, guid: string;
  i, cnt: integer;
  kodEPO: string;
begin
  Result := '';
  //
  cnt:=GetStringLinesCount([:IncEPOPril:]);
  if cnt>0 then begin
    for i:=0 to cnt-1 do begin
      guid:=Copy(GetStringLine([:IncEPOPril:],i),IncEPOPrilCaptionLength+1,80);
      data:=GetNestedSection([:IncEPOPrilData:],guid);
      //
      kodEPO:=GetFormField(data,'KodEPO');
      if ((ADocType<>'') and SameText(GetFormField(data,'DocType'), ADocType) and SameText(kodEPO, APrilKodEPO)) or
         ((ADocType='') and SameText(kodEPO, APrilKodEPO)) then begin
        Result := GetFormField(data,'FilePathDocIdGuid');
        Break;
      end;
    end;
  end;
end;

{-----------------------------------------------------------------------------
IncEPOPril_GetFormDefIdByGuid
- Vraci id definice formulare (DefID). ktere ziska z hlavicky formulare (z [FormHead])
-----------------------------------------------------------------------------}
function IncEPOPril_GetFormDefIdByGuid(AGuid: string): string;
var
  data, guid: string;
  i, cnt: integer;
  kodEPO: string;
begin
  Result := '';
  //
  if AGuid <> '' then
    Result := GetStringLineValue(GetSection(GetFormDataText(AGuid),'[FormHead]'), 'DefID');
end;

{-----------------------------------------------------------------------------
IncEPOPril_TransformDocs
 Transformuje dokumenty tak, aby mohly byt zpracovany v procedure IncEPOPril_InsertFiles
 - ADocID: seznam ID dokumentu, ktere chceme nacist (jednotlive ID jsou oddeleny carkou)
 Prochazi jednotlive dokumenty ADocID - pripravuje seznam souboru a seznam ID
 OUT:
 - APrilohy: seznam priloh z dokumentu (cesty do adresare Tem), ktere chceme nacist (prilohy jsou uvedeny na samostatnych radcich)
 - AId: seznam ID dokumentu, stejne jako v ADocID, ale jednotlive ID jsou uvedeny na samostatnych radcich
-----------------------------------------------------------------------------}
procedure IncEPOPril_TransformDocs(ADocID: string; var APrilohy: string; var AId: string);
var
  i, invalidFileCount: integer;
  docId, docIdAll: string;
  sl: TStringList;
begin
  sl:=TStringList.Create;
  try
    docIdAll:='';
    for i:=0 to CountListItems(ADocID)-1 do begin
      docId := GetListItem(ADocID,i);
      if docId <> '' then begin
        sl.Add(GetDoc(StrToIntSafe(docId)));
        AddStringLine(docIdAll, docId);
      end;
    end;
    APrilohy := sl.Text;
    AId := docIdAll;
  finally
    sl.Free;
  end;
end;

{-----------------------------------------------------------------------------
IncEPOPril_InsertFiles
 Zpracuje a ulozi prilohy (dokumenty)
 - APrilohy: seznam priloh, ktere chceme nacist (prilohy jsou uvedeny na samostatnych radcich)
 - ADocID: pokud se jedna o dokument, tak seznam ID dokumentu (jednotlive ID jsou uvedeny na samostatnych radcich)
 - AInvalidFileCount: cislo, ktere udava, kolik souboru bylo spatneho typu (pripona neodpovidala seznamu cValidFileExt)
 Prochazi jednotlive prilohy APrilohy, pokud typ odpovida typum cValidFileExt, tak pokracuje.
 Testuje, zda nejde o duplicitu (u prvniho souboru se zobrazi info o duplicite a duplicitni soubory nenacita)
 Novy soubor nacte, tzn prida zaznam do ListBoxu a do mema zapise informace o souboru
 (cesta, popis, to, zda se jedna o dokument, [v budoucnu velikost])
-----------------------------------------------------------------------------}
procedure IncEPOPril_InsertFiles(AFilePathDocIdGuid: string;
                                 ADocType: string;
                                 APrilKodEPO: string;
                                 APrilName: string;
                                 var AInvalidFileCount: integer);
var
  data, guid: string;
  y, i, cnt, invalidFileCount: integer;
  sl: TStringList;
  fileDesc, listBoxDesc, docId, docIdAll, id, slText: string;
  newfile, duplRec, frmExists: boolean;
begin
  sl:=TStringList.Create;
  invalidFileCount := 0;
  AInvalidFileCount := 0;
  try
    slText := '';
    docIdAll := '';
    if SameText(ADocType, 'I') and (GetAppendixString = '') then begin    //pokud se jedna o textovou prilohu a ta je prazdna, tak konec
      MsgBoxInfo(Caption, 'Textovou přílohu nelze vložit, protože je prázdná.', MB_OK);
      Exit;
    end
    else if SameText(ADocType, 'D') then begin
      IncEPOPril_TransformDocs(AFilePathDocIdGuid, slText, docIdAll); //naplni nam slText a docIdAll
      sl.Text := slText;
    end
    else if SameText(ADocType, 'F') then begin
      sl.Text := Replace(',', AFilePathDocIdGuid, cCRLF);
    end
    else if SameText(ADocType, 'I') then begin
      sl.Text := APrilKodEPO;
    end
    else
      sl.Text := AFilePathDocIdGuid;
    duplRec := False;
    for i := 0 to sl.Count-1 do begin
      guid:='';
      data:='';
      frmExists := (SameText(ADocType, 'F') and (GetFormDataText(sl[i])<>'')); //pouzito testovani data, protoze FormExists (o dva radky nize) nefunguje ve stereu
      if FileExists(sl[i]) or                //pokud soubor/dokument existuji nebo
         frmExists or //(SameText(ADocType, 'F') and FormExists(sl[i])) or //formular existuje nebo
         (SameText(ADocType, 'I')) then begin //nebo se jedna o textovou prilohu, tak zpracovavame
        if IsItemInList(Replace(' ',cValidFileExt,'.'), AnsiLowerCase(ExtractFileExt(sl[i]))) or
           SameText(ADocType, 'F') or SameText(ADocType, 'I') then begin
          newfile:=True;
          docId:=GetStringLine(docIdAll,i);   //id dokumentu aktualni prilohy
          cnt:=GetListBoxItemCount('IncEPOPril');
          //u kazde vkladane prilohy zjistujeme duplicitu
          for y:=0 to cnt-1 do begin
            guid:=Copy(GetListBoxItemString('IncEPOPril',y),IncEPOPrilCaptionLength+1,80);
            data:=GetNestedSection([:IncEPOPrilData:],guid);
            //
            id:= GetFormField(data,'FilePathDocIdGuid');
            if SameText(GetFormField(data,'DocType'), 'D') then
              id := GetDoc(StrToIntSafe(id));
            if ((SameText(ADocType, 'F')) and (SameText(sl[i], id))) or
               (AnsiSameText(ExtractFileName(sl[i]), ExtractFileName(id))) then begin
              newfile:=False;
              if not duplRec then
                MsgBoxWarn(Caption,'Nelze vložit opakovaně přílohu se stejným názvem souboru.'+cCRLF+
                'Soubor(y), které již v seznamu příloh existují, nebudou přidány.',MB_OK);
              duplRec := TRUE;    //Některé soubory již v seznamu existují, proto nebudou přidány.
              Break;
            end;
          end;
          if newfile then begin
            guid:=CreateGUIDString;
            data:='[FormHead]'+cCRLF+'[Values]';   //musi zustat, jinak nefunguji funkce pro praci s vlozenymi formulari a udaji
            //
            //data:=SetDataFormField(data,'Cislo','');//zatim nebudu resit, neni potreba
            data:=SetDataFormField(data,'KodEPO',APrilKodEPO);
            //
            if APrilName <> '' then
              fileDesc := APrilName
            else
              fileDesc := ExtractFileName(sl[i]);
            data:=SetDataFormField(data,'Description',fileDesc);//popis souboru
            if SameText(ADocType, 'D') then begin
              data:=SetDataFormField(data,'FilePathDocIdGuid',docId);//ID dokumentu
              data:=SetDataFormField(data,'DocType','D');//info, jestli se jedna o dokument
            end
            else if SameText(ADocType, 'I') then begin
              data:=SetDataFormField(data,'FilePathDocIdGuid',sl[i]);//kod textove prilohy
              data:=SetDataFormField(data,'DocType','I');//info, jestli se jedna o formular
            end
            else begin
              data:=SetDataFormField(data,'FilePathDocIdGuid',sl[i]);//cesta k souboru nebo guid formulare
              data:=SetDataFormField(data,'DocType',ADocType);
            end;
            data:=SetDataFormField(data,'Velikost',FloatToStr(SizeOfFile(sl[i]))); //velikost v bajtech
            //
            if Length(fileDesc) > cDescriptionLength then
              fileDesc := Copy(fileDesc,1,cDescriptionLength-3)+'...';
            listBoxDesc:=StrPadRight(fileDesc,IncEPOPrilCaptionLength,' ')+guid;
            //
            TryEditValuesRecord;
            if [:IncEPOPril:]='' then
              [:IncEPOPril:]:=listBoxDesc
            else
              [:IncEPOPril:]:=[:IncEPOPril:]+cCRLF+listBoxDesc;
            [:IncEPOPrilData:]:=AddNestedSection([:IncEPOPrilData:],guid,data);
            TryPostValuesRecord;
          end
          else begin //u existujici prilohy jen znovu zapiseme velikost
            data:=SetDataFormField(data,'Velikost',FloatToStr(SizeOfFile(sl[i])));
            TryEditValuesRecord;
            [:IncEPOPrilData:]:=ReplaceNestedSection([:IncEPOPrilData:],guid,data);
            TryPostValuesRecord;
          end;
        end
        else
          Inc(invalidFileCount);
      end;
    end;
    AInvalidFileCount := invalidFileCount;
  finally
    sl.Free;
  end;
end;

{-----------------------------------------------------------------------------
IncEPOPril_GetSeznamKoduPorizenychPriloh
 Prochazi seznam priloh a u kazde vezme hodnotu KoduEPO
Result: vraci seznam porizenych kodu priloh ve formatu CSV
-----------------------------------------------------------------------------}
function IncEPOPril_GetSeznamKoduPorizenychPriloh: string;
var
  data, guid: string;
  i, cnt: integer;
begin
  Result := '';
  if GetStringLinesCount([:IncEPOPril:])>0 then begin
    cnt:=GetStringLinesCount([:IncEPOPril:]);
    for i:=0 to cnt-1 do begin
      guid:=Copy(GetStringLine([:IncEPOPril:],i),IncEPOPrilCaptionLength+1,80);
      data:=GetNestedSection([:IncEPOPrilData:],guid);
      //
      Result:=AddValueToList(Result, GetFormField(data,'KodEPO'));
    end;
  end;
end;

{-----------------------------------------------------------------------------
IncEPOPril_GetSeznamPriloh
 Upravi (naformatuje) seznam priloh AData
 - AData: struktura kazdeho radku: 0-KodEPO,1-Nazev_prilohy,2-Multiselect,3-Typ_prilohy,4-ID_Definice(v pripade formulare)
 - ADefExt: vychozi pripona souboru pro OpenDialog
 - AFilter: vychozi filtr pro OpenDialog
 (ADefExt a AFilter se nastavuji jednotne pro vsechny prilohy, pokud by melo byt ruzne pro kazdou, tak se musi preprogramovat)
 Prochazi jednotlive radky a krome ADefExt a AFilter nastavuje jeste hodnotu "Povolit" (ktera zajisti disablovani radku v dialogu)
Result: struktura kazdeho radku: 0-KodEPO,1-Nazev_prilohy,2-Povolit,3-Multiselect,
                                 4-Typ_prilohy,5-ID_Definice(v pripade formulare),
                                 6-DefeultExt_OpenDialogu,
                                 7-Filtr_OpenDialogu
-----------------------------------------------------------------------------}
function IncEPOPril_GetSeznamPriloh(AData, ADefExt, AFilter: string): string;
var
  kodEPO, kod, radek: string;
  i: integer;
  sl, sl2: TStringList;
  povolit: boolean;
begin
  sl := TStringList.Create;
  sl2 := TStringList.Create;
  try
    kod:='';
    //nachystame si seznam jiz porizenych priloh, resp. vsech kodu
    kodEPO:=IncEPOPril_GetSeznamKoduPorizenychPriloh;
    //
    sl.Text := AData;
    for i:=0 to sl.Count-1 do begin
      kod := GetListItem(sl[i], 0);
      povolit := True;
      if (StrToBoolSafe(GetListItem(sl[i], 2))=False) and //neni povolen multiselect
         (IsItemInList(kodEPO, kod)) then                 //a priloha je jiz porizena
        povolit := False;                                 //tak disablujeme
      //
      radek := '';
      radek:=AddValueToList(radek, kod, True);
      radek:=AddValueToList(radek, GetListItem(sl[i], 1), True);
      radek:=AddValueToList(radek, BoolToStr(povolit, True), True);
      radek:=AddValueToList(radek, GetListItem(sl[i], 2), True);
      radek:=AddValueToList(radek, GetListItem(sl[i], 3), True);
      radek:=AddValueToList(radek, GetListItem(sl[i], 4), True);
      radek:=AddValueToList(radek, ADefExt, True);
      radek:=AddValueToList(radek, AFilter, True);
      sl2.Add(radek);
    end;
    Result := sl2.Text;
  finally
    sl.Free;
    sl2.Free;
  end;
end;

{-----------------------------------------------------------------------------
IncEPOPril_GetPrilItem
 Ze seznamu priloh (z CSV coData) vrati hodnotu identifikovanou pozici AIndex prilohy,
 ktera odpovida kodu APrilKodEPO (index 0)
-----------------------------------------------------------------------------}
function IncEPOPril_GetPrilItem(AData, APrilKodEPO: string; AIndex: integer): string;
var
  sl: TStringList;
  i: integer;
begin
  Result := '';
  sl := TStringList.Create;
  try
    sl.Text := AData;
    for i:=0 to sl.Count-1 do begin
      if AnsiSameText(GetListItem(sl[i], 0), APrilKodEPO) then begin
        Result := GetListItem(sl[i], AIndex);
        Break;
      end;
    end;
  finally
    sl.Free;
  end;
end;

{-----------------------------------------------------------------------------
IncEPOPril_ZapisPrilohuDAP
 Prochazi seznam priloh (coData) a u prilohy, ktera odpovida kodu APrilKodEPO (index 0)
 nastavi hodnotu 0, resp. 1 v casti Prilohy DAP
-----------------------------------------------------------------------------}
procedure IncEPOPril_ZapisPrilohuDAP(APrilKodEPO: string);
var
  fld: string;
begin
  fld:= IncEPOPril_GetPrilItem(coData, APrilKodEPO, 5);
  if (fld <> '') and (mtValues.FindField(fld)<> nil) and (mtValues.FindField(fld).AsInteger <= 1) then begin
    TryEditValuesRecord;
    if IncEPOPril_PrilExists(APrilKodEPO) then
      mtValues.FindField(fld).AsInteger := 1
    else
      mtValues.FindField(fld).AsInteger := 0;
    TryPostValuesRecord;
  end;
end;

function IncEPOPril_GetRozsahUVRoz(ARozsahToSet: string): string;
var
  fld: string;
begin
  Result := '';
  if ARozsahToSet <> '' then begin
    TryEditValuesRecord;
    [.ckUVRozsahP.] := SameText(ARozsahToSet, 'P');
    [.ckUVRozsahZ.] := SameText(ARozsahToSet, 'Z');
    [.ckUVRozsahM.] := SameText(ARozsahToSet, 'M');
    TryPostValuesRecord;
    Result := ARozsahToSet;
  end
  else begin
    if [.ckUVRozsahP.] then
      Result := 'P'
    else if [.ckUVRozsahZ.] then
      Result := 'Z'
    else if [.ckUVRozsahM.] then
      Result := 'M';
  end;
end;

function IncEPOPril_GetRozsahUVVzz(ARozsahToSet: string): string;
var
  fld: string;
begin
  Result := '';
  if ARozsahToSet <> '' then begin
    TryEditValuesRecord;
    [.ckUVRozsahPV.] := SameText(ARozsahToSet, 'P');
    [.ckUVRozsahZV.] := SameText(ARozsahToSet, 'Z');
    TryPostValuesRecord;
    Result := ARozsahToSet;
  end
  else begin
    if [.ckUVRozsahPV.] then
      Result := 'P'
    else if [.ckUVRozsahZV.] then
      Result := 'Z';
  end;
end;

procedure ZapisInfoVykaz(AGuid: string; ADocType: string; APrilKodEPO: string);
var
  rozvahaGuid,vykazGuid, defId: string;
begin
  if (SameText(ADocType, 'F')) then begin
    if (SameText(APrilKodEPO, GetListItem(coDataRozvaha, 0))) then begin //u rozvahy se zjistuje, zda se jedna o plnou nebo zkracenou rozvahu
      if IncEPOPril_GetRozsahUVRoz('') = '' then
        IncEPOPril_GetRozsahUVRoz(Cond2(StrToBoolSafe(GetFormField(AGuid, 'ckFillZkr')), 'Z',
                                   StrToBoolSafe(GetFormField(AGuid, 'ckFillMikro')), 'M', 'P'));
      rozvahaGuid:=IncEPOPril_GetFilePathDocIdGuid(GetListItem(coDataRozvaha, 0), 'F');
      defId := IncEPOPril_GetFormDefIdByGuid(rozvahaGuid);
      TryEditValuesRecord;
      [:edVyhlaska:] := Cond2(IsItemInList(coDefRozvahaNev, defId),'504',IsItemInList(coDefRozvahaRO, defId),'410','500');
      TryPostValuesRecord;
    end;
    if (SameText(APrilKodEPO, GetListItem(coDataVZZ, 0))) then begin //u vykazyZZ se zjistuje, zda se jedna o plnou nebo zkracenou rozvahu
      if IncEPOPril_GetRozsahUVVzz('') = '' then
        IncEPOPril_GetRozsahUVVzz(Cond(StrToBoolSafe(GetFormField(AGuid, 'ckFillZkr')), 'Z', 'P'));
      vykazGuid:=IncEPOPril_GetFilePathDocIdGuid(GetListItem(coDataVZZ, 0), 'F');
      defId := IncEPOPril_GetFormDefIdByGuid(vykazGuid);
      if [:edVyhlaska:]='' then begin
        TryEditValuesRecord;
        [:edVyhlaska:] := Cond2(IsItemInList(coDefVZZNev, defId),'504',IsItemInList(coDefVZZRO, defId),'410','500');
        TryPostValuesRecord;
      end;
    end;
  end;
end;

{-----------------------------------------------------------------------------
OnClick_IncEPOInsert
 Pripravi seznam priloh a otevre okno pro vyber prilohy
 Po vyberu vola proceduru pro zapis priloh do formulare
-----------------------------------------------------------------------------}
procedure OnClick_IncEPOPrilInsert;
var
  invalidFileCount: integer;
  filtr, defExt, inData: string;
  idOut: integer;
  typeOut, dataOut, prilName: string;
begin
  if not mtValues.ReadOnly then begin
    invalidFileCount := 0;
    defExt := '.pdf';
    filtr := 'Akceptované přílohy ('+Replace(' ',cValidFileExt,'*.')+')|'+
                           Replace(',',Replace(' ',cValidFileExt,'*.'),';')+
                          '|Všechny soubory (*.*)|*.*';
    //
    inData := IncEPOPril_GetSeznamPriloh(coData, defExt, filtr);
    idOut := ''; typeOut := ''; dataOut := '';
    if SelectAttachments(inData, idOut, typeOut, dataOut) then begin
      prilName := '';
      if (idOut <> GetListItem(coDataObecPril, 0)) then   //jen u obecne prilohy se v seznamu objevi nazev souboru, u ostatnich nadefinovany nazev
        prilName := IncEPOPril_GetPrilItem(inData, idOut, 1);
      IncEPOPril_InsertFiles(dataOut, typeOut, idOut, prilName, invalidFileCount);
      //msgv(dataOut);msgv(typeOut);msgv(idOut);msgv(prilName);
      ZapisInfoVykaz(dataOut, typeOut, idOut);
      //
      ReloadListBoxes;
      IncEPOPril_ZapisPrilohuDAP(idOut);
      //
      SetListBoxItemIndex('IncEPOPril',GetListBoxItemCount('IncEPOPril')-1);
      SetChangeFlag(TRUE);
      //
      if CompareVersion(GetPrgVersion, '14.1.1') = 1 then
        DisplayCheck;
    end;
    if invalidFileCount > 0 then
      MsgBoxInfo(Caption,
        'Jako přílohy lze vložit jen soubory typu '+UpperCase(cValidFileExt)+'. Ostatní soubory byly z výběru odstraněny.',
        MB_OK);
  end;
  //
  GotoFld('IncEPOPril');
end;

procedure OnClick_btIncEPOPrilTest;
begin
  msgv(IncEPOPril_GetFilePathDocIdGuid('ROZ', 'F'));
end;

{-----------------------------------------------------------------------------
OnClick_IncEPOPrilEdit
 Zobrazi náhled souboru v asociovanem programu
-----------------------------------------------------------------------------}
procedure OnClick_IncEPOPrilEdit;
var
  data, guid, id, dataX, outFile: string;
  i,cnt: integer;
  prilExists: boolean;
begin
  guid:=Copy(GetListBoxItemString('IncEPOPril',GetListBoxItemIndex('IncEPOPril')),
    IncEPOPrilCaptionLength+1,80);
  if (guid<>'') then begin
    data:=GetNestedSection([:IncEPOPrilData:],guid);
    //
    prilExists := True;
    if SameText(GetFormField(data,'DocType'), 'D') then begin
      if not RunAsStandalone then begin                        //ve stereu a designeru dokumenty nejsou
        id := GetDoc(StrToIntSafe(GetFormField(data,'FilePathDocIdGuid')));
        if FileExists(id) then
          ShellOpen(id)
        else
          prilExists := False;
        if not prilExists then                    //id nastavime, aby byl v hlaseni na konci spravne zobrazen nazev dokumentu
          id := GetFormField(data,'Description');
      end;
    end
    else if SameText(GetFormField(data,'DocType'), 'I') then begin
      GotoAppendix;
    end
    else if SameText(GetFormField(data,'DocType'), 'F') then begin
      id:= GetFormField(data,'FilePathDocIdGuid');
      if RunAsStandalone then begin //pro stereo a designer
        dataX:=GetFormDataText(id);
        if (dataX <> '') then begin
          outFile:=SetValidFileName(id)+'Prev.pdf';
          DoPrintForm(dataX,   false,   false,  outFile);
        end
        else
          prilExists := False;
      end
      else begin                    //pro FS
        if FormExists(id) then
          OpenSavedForm(id)
        else
          prilExists := False;
      end;
    end
    else begin
      id:= GetFormField(data,'FilePathDocIdGuid');
      if FileExists(id) then
        ShellOpen(id)
      else
        prilExists := False;
    end;
    //
    if not prilExists then begin
      if SameText(GetFormField(data,'DocType'), 'D') then
        MsgBoxInfo(Caption, Format('Dokument "%s" nelze v dokumentech nalézt.', [ExtractFileName(id)]), MB_OK)
      else if SameText(GetFormField(data,'DocType'), 'F') then
        MsgBoxInfo(Caption, Format('Formulář "%s" nelze nalézt.', [GetFormField(data,'Description')]), MB_OK)
      else
        MsgBoxInfo(Caption, Format('Soubor "%s" nelze v původním umístění nalézt.', [ExtractFileName(id)]), MB_OK);
    end;
  end;
  //
  if not SameText(GetFormField(data,'DocType'), 'I') then  //u textove prilohy jsme se jiz postavili na appendix
    GotoFld('IncEPOPril');
end;

{-----------------------------------------------------------------------------
OnClick_IncEPOPrilDelete
 Smaze aktualni prilohu
-----------------------------------------------------------------------------}
procedure OnClick_IncEPOPrilDelete;
var
  data, guid: string;
  i,x,cnt: integer;
  sl: TStringList;
  kodEPO: string;
begin
  if not mtValues.ReadOnly then begin
    sl:=TStringList.Create;
    try
      guid:=Copy(GetListBoxItemString('IncEPOPril',GetListBoxItemIndex('IncEPOPril')),
        IncEPOPrilCaptionLength+1,80);
      if (guid<>'') and
         (MsgBoxAsk(Caption,'Chcete smazat přílohu?', MB_YESNO) = IDYES) then begin
        sl.Text := [:IncEPOPril:];
        x:=GetListBoxItemIndex('IncEPOPril');
        sl.Delete(x);
        cnt:=sl.Count;
        //
        TryEditValuesRecord;
        data:=GetNestedSection([:IncEPOPrilData:],guid);
        kodEPO:=GetFormField(data,'KodEPO');
        [:IncEPOPrilData:]:=DeleteNestedSection([:IncEPOPrilData:],guid);
        [:IncEPOPril:]:=IncEPOPril_TrimStringList(sl.Text);
        TryPostValuesRecord;
        //
        ReloadListBoxes;
        SetChangeFlag(TRUE);
        IncEPOPril_ZapisPrilohuDAP(kodEPO);
        //
        if x=cnt then
          SetListBoxItemIndex('IncEPOPril',x-1)
        else
          SetListBoxItemIndex('IncEPOPril',x);
        //
        if CompareVersion(GetPrgVersion, '14.1.1') = 1 then
          DisplayCheck;
      end;
      GotoFld('IncEPOPril');
    finally
      sl.Free;
    end;
  end;
end;

{-----------------------------------------------------------------------------
OnClick_IncEPOPrilDeleteAll
 Smaze vsechny prilohy
-----------------------------------------------------------------------------}
procedure OnClick_IncEPOPrilDeleteAll;
begin
  if (GetStringLinesCount([:IncEPOPril:])>0) and
     (MsgBoxWarn(Caption, 'Chcete skutečně smazat všechny načtené přílohy?', MB_YESNO)=IDYES) then begin
    TryEditValuesRecord;
    [:IncEPOPril:] := '';
    [:IncEPOPrilData:] := '';
    ReloadListBoxes;
    TryPostValuesRecord;
  end
end;

{-----------------------------------------------------------------------------
OnClick_IncEPOPrilRename
 Zmeni popisek aktualni prilohy (tento popis se zobrazuje v ListBoxu a pak odesila v EPO)
-----------------------------------------------------------------------------}
procedure OnClick_IncEPOPrilRename;
var
  data, guid: string;
  x: integer;
  fileDesc,fileDescOld, listBoxDesc: string;
  sl: TStringList;
  stisk: word;
begin
  try
    x:=GetListBoxItemIndex('IncEPOPril');
    guid:=Copy(GetListBoxItemString('IncEPOPril',GetListBoxItemIndex('IncEPOPril')),
      IncEPOPrilCaptionLength+1,80);
    if guid<> '' then begin
      data:=GetNestedSection([:IncEPOPrilData:],guid);
      //
      listBoxDesc:=GetListBoxItemString('IncEPOPril',x);
      fileDesc:= GetFormField(data,'Description');
      fileDescOld:=fileDesc;
      repeat
        if CompareVersion(GetPrgVersion, '14.1.2') = 1 then
          stisk:=AskStrV('Nový název přílohy','Zadejte název přílohy',fileDesc,-1,-1, Int(Length(fileDesc)*3.5))
        else
          stisk:=AskStr('Nový název přílohy','Zadejte název přílohy',fileDesc);
        if stisk <> mrCancel then begin
          if (fileDesc='') then
            MsgBoxWarn('', 'Název přílohy musí být vyplněn!', MB_OK);
        end;
      until (fileDesc <>'') or (stisk=mrCancel);
      if stisk = mrCancel then
        Exit;
      //
      if fileDesc <> fileDescOld then begin
        sl:=TStringList.Create;
        try
          sl.Text := [:IncEPOPril:];
          //
          data:=SetDataFormField(data,'Description',fileDesc);
          TryEditValuesRecord;
          [:IncEPOPrilData:]:=ReplaceNestedSection([:IncEPOPrilData:],guid,data);
          TryPostValuesRecord;
          //
          if Length(fileDesc) > cDescriptionLength then
            fileDesc := Copy(fileDesc,1,cDescriptionLength-3)+'...';
          listBoxDesc:=StrPadRight(fileDesc,IncEPOPrilCaptionLength,' ')+Copy(listBoxDesc, IncEPOPrilCaptionLength+1,cMaxInt);
          sl[x] := listBoxDesc;
          TryEditValuesRecord;
          [:IncEPOPril:]:=IncEPOPril_TrimStringList(sl.Text);
          TryPostValuesRecord;
          //
          ReloadListBoxes;
          SetChangeFlag(TRUE);
        finally
          sl.Free;
        end;
      end;
    end;
  finally
    GotoFld('IncEPOPril');
    SetListBoxItemIndex('IncEPOPril',x);
  end;
end;

{-----------------------------------------------------------------------------
OnClick_IncEPOPrilShowInfo
 V dialogu zobrazi informace o priloze (cestu, nazev souboru, pokud se lisi od popisu a velikost souboru)
-----------------------------------------------------------------------------}
procedure OnClick_IncEPOPrilShowInfo;
var
  data, guid: string;
  i,cnt: integer;
  str, id, desc: string;
  size: double;
begin
  guid:=Copy(GetListBoxItemString('IncEPOPril',GetListBoxItemIndex('IncEPOPril')),
    IncEPOPrilCaptionLength+1,80);
  if (guid<>'') then begin
    data:=GetNestedSection([:IncEPOPrilData:],guid);
    //
    desc:= GetFormField(data,'Description');
    id:= GetFormField(data,'FilePathDocIdGuid');
    if SameText(GetFormField(data,'DocType'), 'D') then
      id := GetDoc(StrToIntSafe(id));
    size:= StrToFloatSafe(GetFormField(data,'Velikost'));
    //
    str:='';
    AddStringLine(str, 'Informace o příloze:'+cCRLF);
    if not AnsiSameText(desc, ExtractFileName(id)) then
      AddStringLine(str, 'Popis: ' +desc);
    if SameText(GetFormField(data,'DocType'), 'D') then begin
      AddStringLine(str, 'Jméno dokumentu: ' +ExtractFileName(id));
      AddStringLine(str, 'Umístění přílohy: dokumenty programu');
    end
    else if SameText(GetFormField(data,'DocType'), 'F') then begin
      AddStringLine(str, 'Definice: ' +IncEPOPril_GetFormDefIdByGuid(id));
      AddStringLine(str, 'Umístění přílohy: formuláře programu');
    end
    else if SameText(GetFormField(data,'DocType'), 'I') then begin
      AddStringLine(str, 'Umístění přílohy: textová příloha');
    end
    else begin
      AddStringLine(str, 'Jméno souboru: ' +ExtractFileName(id));
      AddStringLine(str, 'Umístění souboru: ' +ExtractFilePath(id));
    end;
    if size > 0 then
      if size >= 1000 then
        AddStringLine(str, Format('Velikost: %s kB', [FloatToStr(RoundAri(size/1024,-1))]))
       else
        AddStringLine(str, Format('Velikost: %s B', [FloatToStr(RoundAri(size,-1))]));
    //
    MsgBoxInfo(Caption, str, MB_OK);
  end;
  GotoFld('IncEPOPril');
end;

//- kontrola, zda uvedena priloha existuje
//- kontrola, zda velikost jedne priloh nepresahne 2MB, resp. cAttachSize
//- kontrola, zda soucet velikosti priloh nepresahne 4MB, resp. cAttachTotalSize
function IncEPOPril_CheckPrilohy: string;
var
  guid, data, id, idText: string;
  i, cnt: integer;
  size, sizeOne: double;     
  prilExists: boolean;
begin
  if GetStringLinesCount([:IncEPOPril:])>0 then begin
    size := 0;
    cnt:=GetStringLinesCount([:IncEPOPril:]);
    for i:=0 to cnt-1 do begin
      guid:=Copy(GetStringLine([:IncEPOPril:],i),IncEPOPrilCaptionLength+1,80);
      data:=GetNestedSection([:IncEPOPrilData:],guid);
      //      
      prilExists := True; 
      id:= GetFormField(data,'FilePathDocIdGuid');
      if SameText(GetFormField(data,'DocType'), 'D') then begin
        id := GetDoc(StrToIntSafe(id));
        if not FileExists(id) then begin            
          prilExists := False;
          chk('IncEPOPril', True, Format('Příloha el. podání - dokument "%s" nelze v dokumentech nalézt.',
                            [ExtractFileName(id)]));          
        end;
      end
      else if SameText(GetFormField(data,'DocType'), 'F') then begin
        if GetFormDataText(id)='' then begin //if not FormExists(id) then
          prilExists := False;
          chk('IncEPOPril', True, Format('Příloha el. podání - formulář "%s" nelze nalézt.',
                            [GetFormField(data,'Description')]));          
        end;
      end
      else if SameText(GetFormField(data,'DocType'), 'S') then begin
        if not FileExists(id) then begin            
          prilExists := False;
          chk('IncEPOPril', True, Format('Příloha el. podání - soubor "%s" nelze nalézt.',
                            [ExtractFileName(id)]));          
        end;
      end; 
      //  
      if prilExists then begin
        sizeOne := StrToFloatSafe(GetFormField(data,'Velikost'));
        size := size + sizeOne;
        //         
        if (cAttachSize > 0)then
          if (sizeOne/1024) > cAttachSize then begin   
            idText := ExtractFileName(id);
            if not SameText(idText, GetFormField(data,'Description')) then
              idText := idText + Format(' (%s)', [GetFormField(data,'Description')]);
            chk('IncEPOPril', True, Format('%s - velikost přílohy je %s kB, povolená velikost je %s kB.',
                                  [idText, FloatToStr(RoundAri(sizeOne/1024,-1)), IntToStr(cAttachSize)]),4);            
          end;        
      end;               
    end;
    if cAttachTotalSize > 0 then
      if (size/1024) > cAttachTotalSize then
        chk('IncEPOPril', True, Format('Součet velikostí příloh pro elektronické podání je %s kB, povolená velikost je %s kB.',
                              [FloatToStr(RoundAri(size/1024,-1)), IntToStr(cAttachTotalSize)]),4);
  end;
end;

//Slouzi k odeslani opisu exportu EPO emailem (do emailu se jako priloha pripoji
//formular + vsechny prilohy v jednom ZIP souboru)
procedure IncEPOPril_ZpracujOpisPriloh;
var
  i, n: integer;
  data, guid, dataX, outFile, pril, zipFileName, pdfFileName, destDir, email, errMsg: string;
  cnt: integer;
  sl, slPril: TStringList;
  cf, textPrilExists: boolean;
begin
  sl := TStringList.Create;
  slPril := TStringList.Create;
  try
    email := SelectEmailOrDS(True);
    if email = '' then
      Exit;
    //
    n := 0;
    destDir := NormalPath(GetDirWorkPath+CreateGUIDString);
    ForceDirectories(destDir);
    //zpracujeme obecne INC prilohy
    textPrilExists := False;
    if (mtValues.FindField('IncEPOPril')<> nil) and ([:IncEPOPril:]<>'') then begin
      cnt:=GetStringLinesCount([:IncEPOPril:]);
      for i := 0 to cnt - 1 do begin
        guid:=Copy(GetStringLine([:IncEPOPril:],i),IncEPOPrilCaptionLength+1,80);
        data:=GetNestedSection([:IncEPOPrilData:],guid);
        //
        pril:= GetFormField(data,'FilePathDocIdGuid');
        if SameText(GetFormField(data,'DocType'), 'F') then begin
          dataX:=GetFormDataText(pril);
          if (dataX <> '') then begin
            outFile := SetValidFileName(GetFormField(data,'Description'))+'.pdf';
            DoPrintForm(dataX,   false,   true,  outFile);
            if FileExists(outFile) then
              sl.Add(outFile);
          end;
        end
        else if SameText(GetFormField(data,'DocType'), 'D') then begin
          pril := GetDoc(StrToIntSafe(pril));
          if FileExists(pril) then
            sl.Add(pril);
        end
        else if SameText(GetFormField(data,'DocType'), 'I') then begin
          if GetAppendixString <> '' then begin
            outFile := SaveAppendixToPDF;
            if FileExists(outFile) then begin
              sl.Add(outFile);
              textPrilExists := True;
            end;
          end;
        end
        else begin //S
          if FileExists(pril) then
            sl.Add(pril);
        end;
      end;
      //
      if sl.Count > 0 then begin
        for i := 0 to sl.Count - 1 do begin
          outFile := GetUniqueFileName(destDir, ExtractFileName(sl[i]));
          if DoCopyFile(sl[i], outFile) then
            Inc(n);
        end;
      end;
    end;
    //vytvoreni ZIP souboru
    if n > 0 then begin
      zipFileName := SetValidFileName('Přílohy - '+mtDefName.Value) + '.zip';
      //zipFileName := SetValidFileName('Přílohy formuláře') + '.zip'; // pokud budeme chtit jednotny nazev
      if ZipFile(destDir+'*.*', destDir+zipFileName,'') then
        slPril.Add(destDir+zipFileName);
    end;
    //zpracujeme hlavni formular
    data:=GetFormDataText('');
    if (data <> '') then begin
      pril := SetValidFileName(mtDefName.Value)+'.pdf';
      pdfFileName := pril;
      //pdfFileName := 'Formulář.pdf';                               // pokud budeme chtit jednotny nazev
      //pokud je textova priloha v prilohach pro EPO a je u ni zatrzeno "vlozit prilohy do tisku"
      //tak data upravime tak, aby se priloha nevytiskla
      sl.Text := GetSection(data,'[UserSettings]');
      if (textPrilExists) and (StrToBoolSafe(sl.Values['US_PrintAppendix'])) then begin
        sl.Values['US_PrintAppendix'] := BoolToStr(False, True);
        data := SetSection(data, '[UserSettings]', sl.Text);
      end;
      DoPrintForm(data,   false,   true,  pril);
      if DoCopyFile(pril, destDir+pdfFileName) then
        slPril.Insert(0, destDir+pdfFileName);  //aby byla v emailu na prvnim miste
    end;
    //odeslani emailem
    if slPril.Count > 0 then
      SendFilesByEmailOrDS(email, mtDefName.Value, '', slPril, True, errMsg)
    else
      MsgBoxWarn(Caption, 'Během vytváření souborů došlo k chybě, odeslání bylo přerušeno!', MB_OK);
  finally
    sl.Free;
    slPril.Free;
  end;
end;

procedure OnClick_wlEPODalsiInformace;
begin
  ShowInstruction('wlEPODalsiInformace');
end;

{$INCSTOP_IncEPOPrilTMS}

{$INCSTART_IncSpolFunkceTMS}

{-----------------------------------------------------------------------------
  Funkce pro OnChangeExit udaju "PSC" a "Obec"
-----------------------------------------------------------------------------}

function IncSpolFce_GetLstPSCByObec(AListName: string; AKeyFieldValues: variant): string;
var
  pscLst, pscValue: string;
begin
  Result := '';
  if CountListItems(AkeyFieldValues) = 2 then begin                          //jestlize je vyplnena obec i psc, tak
    Result := VarToStr(LstLookup(AListName,Date,'PSC;Obec',
     VarArrayOf([GetListItem(AKeyFieldValues, 0),
                 AnsiUpperCase(GetListItem(AKeyFieldValues, 1))]),'PSC'));  //zkusime vsechna pismena v obce velka
    if Result = '' then
      Result := VarToStr(LstLookup(AListName,Date,'PSC;Obec',
       VarArrayOf([GetListItem(AKeyFieldValues, 0),
                   GetListItem(AKeyFieldValues, 1)]),'PSC'));               //jinak zkusime tak jak uzivatel zapsal
    if Result = '' then
      Result := VarToStr(LstLookup(AListName,Date,'PSC;Obec',
       VarArrayOf([GetListItem(AKeyFieldValues, 0),
                   StringFirstUpperCase(GetListItem(AKeyFieldValues, 1))]),'PSC'));//nebo prvni pismena kazdeho slova obce velka
  end;
  if (Result = '') and                                        //jestlize podle psc a obec nebylo nic nalezeno
     (GetListItem(AKeyFieldValues, 1) <> '') then begin       //a obec je vyplnena, tak
    Result := VarToStr(LstLookup(AListName,Date,'Obec',
     AnsiUpperCase(GetListItem(AKeyFieldValues, 1)),'PSC'));  //zkusime vsechna pismena velka
    if Result = '' then
      Result := VarToStr(LstLookup(AListName,Date,'Obec',
       GetListItem(AKeyFieldValues, 1),'PSC'));               //jinak zkusime tak jak uzivatel zapsal
    if Result = '' then
      Result := VarToStr(LstLookup(AListName,Date,'Obec',
       StringFirstUpperCase(GetListItem(AKeyFieldValues, 1)),'PSC'));//nebo prvni pismena kazdeho slova velka
  end;
end;

procedure IncSpolFce_OnChangeObecSetPSC(AListName: string;
                                        APSCFiledName, AObecFieldName: string);
var
  pscLst, pscValue, obecValue, pscObecValues: string;
begin
  pscValue := mtValues.FindField(APSCFiledName).AsString;
  obecValue := mtValues.FindField(AObecFieldName).AsString;
  pscObecValues := AddValueToList(AddValueToList('', pscValue), obecValue);
  if obecValue <> '' then begin                                                 //jestlize je obec vyplnena, tak
    pscLst := IncSpolFce_GetLstPSCByObec(AListName, pscObecValues);             //podle obce zjistime psc
    if pscLst <> '' then begin                                                  //pokud psc bylo nalezeno, tak zapiseme
      TryEditValuesRecord;
      mtValues.FindField(APSCFiledName).AsString := pscLst;
      TryPostValuesRecord;
    end;
  end;
end;

procedure IncSpolFce_OnChangePSCSetObec(AListName: string;
                                        APSCFiledName, AObecFieldName: string);
var
  s,pscLst, pscValue, obecValue, obecLst, pscObecValues: string;
begin
  pscValue := mtValues.FindField(APSCFiledName).AsString;
  obecValue := mtValues.FindField(AObecFieldName).AsString;
  pscObecValues := AddValueToList(AddValueToList('', pscValue), obecValue);
  if (pscValue <> '') then begin                                                //jestlize je psc vyplneno, tak
    pscLst := IncSpolFce_GetLstPSCByObec(AListName, pscObecValues);             //podle obce zjistime psc
    if Replace(' ',pscValue,'') <> pscLst then begin                            //jestlize je psc ruzne od psc odpovidajici obci, tak pokracujeme
      obecLst := VarToStr(LstLookup(AListName,Date,'PSC;HlavniPosta',VarArrayOf([Replace(' ',pscValue,''),TRUE]),'Obec')); //zkusime zjistit obec podle psc a hlavni posty
      if obecLst = '' then                                                      //pokud obec nenalezena, tak zjistme poze podle psc
        obecLst := VarToStr(LstLookup(AListName,Date,'PSC',Replace(' ',pscValue,''),'Obec'));
      //
      TryEditValuesRecord;
      if obecLst <> '' then                                                     //pokud obec nalezena, tak zapiseme
        mtValues.FindField(AObecFieldName).AsString := obecLst;
      //else
        //mtValues.FindField(AObecFieldName).AsString := '';
      TryPostValuesRecord;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Funkce pro OnChangeExit udaju "KodStatu" a "Stat"
-----------------------------------------------------------------------------}

procedure IncSpolFce_OnChangeKodStatuSetStat(AKodStatuFiledName, AStatFieldName: string;
                                             ALstKodFieldName: string);
var
  kodStatuValue, statLst: string;
begin
  if not mtValues.ReadOnly then begin
    kodStatuValue := mtValues.FindField(AKodStatuFiledName).AsString;
    if kodStatuValue <> '' then begin
      if AnsiUpperCase(kodStatuValue) = 'ČR' then
        kodStatuValue := 'CZ';
      statLst := VarToStr(LstLookup('KodyStatu',Date,ALstKodFieldName,AnsiUpperCase(kodStatuValue),'Nazev'));
      //
      TryEditValuesRecord;
      mtValues.FindField(AKodStatuFiledName).AsString := kodStatuValue;
      if statLst <> '' then
        mtValues.FindField(AStatFieldName).AsString := statLst
      else
        mtValues.FindField(AStatFieldName).AsString := '';
      TryPostValuesRecord;
    end;
  end;
end;

procedure IncSpolFce_OnChangeStatSetKodStatu(AKodStatuFiledName, AStatFieldName: string;
                                             ALstKodFieldName: string);
var
  statValue, kodStatuLst: string;
begin
  if not mtValues.ReadOnly then begin
    statValue := mtValues.FindField(AStatFieldName).AsString;
    TryEditValuesRecord;
    if statValue <> '' then begin
      kodStatuLst := VarToStr(LstLookup('KodyStatu',Date,'Nazev',AnsiUpperCase(statValue),ALstKodFieldName));
      //
      TryEditValuesRecord;
      if kodStatuLst <> '' then
        mtValues.FindField(AKodStatuFiledName).AsString := kodStatuLst
      else
        mtValues.FindField(AKodStatuFiledName).AsString := '';
      TryPostValuesRecord;
    end;
  end;
end;

{$INCSTOP_IncSpolFunkceTMS}
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//KONEC SDILENE CASTI SKRIPTU - NEMENIT!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

///////////////////////////////////////////////////////////////////////////////
//USER FUNCTIONS
///////////////////////////////////////////////////////////////////////////////

//Upravi do tvaru xxxxx, ne na plnou delku
function UnNormOkec(AStr: string): string;
begin
  Result:=AStr;
  Result:=Replace('.',Result,'');
  Result:=Replace(' ',Result,'');
end;

//Normalizuje do tvaru xx / xx.xx / xx.xx.x
function NormOkec(AStr: string): string;
begin
  Result:=UnNormOkec(Astr);
  if Length(Result)>2 then
    Result:=Copy(Result,1,2)+'.'+Copy(Result,3,5);
  if Length(Result)>5 then
    Result:=Copy(Result,1,5)+'.'+Copy(Result,6,5);
end;

//Upravi do tvaru xxxxxx na plnou delku 6 znaku
//- u cinnosti zacinajici nulou odstrani pocatecni 0
//- pokud je uvedena cinnost 0-neurceno, tak pocatecni 0 neodstranujeme
function UnNormOkecEPO(AStr: string): string;
begin
  Result := AStr;
  if (Result <> '0') then begin
    Result:=UnNormOkec(Result);
    Result:=StrPadRight(Result,6,'0');
    Result:=StrTrimCharLeft(Result,'0');    
  end;
end;

//#4338
//Upravena standardni NormOkec s tim, ze u cinnosti, ktere v seznamu OKEC zacinajici nulou, prida 0 na zacatek
//(v XML ma takova cinnost delku 5 znaku, tzn. bez pocatecni 0)
//(problem byl v tom, ze napr. u cinnosti 13000 se naimporovala cinnost 13 a ne 01.3)
//#4346
//Importuji se jen cinnosti, ktere maji v XML delku 5 nebo 6 znaku, 
//nebo jsou jiz zadany v normalizovanem stavu, tedy s teckou "."
//V obou pripadech se cinnost naimportujeme jen v tom pripade, ze existuje v seznamu OKEC 
function NormOkecEPO(AStr: string): string;
begin    
  if Pos('.', AStr) = 0 then begin      
    if Length(AStr)=5 then
      AStr:=StrPadLeft(AStr,6,'0'); 
    if Length(AStr)=6 then begin      
      AStr:=StrTrimCharRight(AStr,'0');
      AStr:=StrPadRight(AStr,2,'0');
      AStr:=NormOkec(AStr);      
    end
    else if (AStr <> '0') then
      AStr:='';      
  end;
  Result:=AStr;     
  //
  if (Result<>'') and (VarToStr(LstLookup('OKEC',Date, 'OKEC',Result,'OKEC'))='') then
    Result := '';  
end;

function ValidMesic: boolean;
begin
  Result := ([:Mesic:]<>'') and (StrToIntSafe([:Mesic:])>=1) and (StrToIntSafe([:Mesic:])<=12);  
end;

function ValidCtvrtleti: boolean;
begin
  Result := ([:Ctvrtleti:]<>'') and (StrToIntSafe([:Ctvrtleti:])>=1) and (StrToIntSafe([:Ctvrtleti:])<=4);  
end;

function ValidRok: boolean;
begin
  Result := ([.Rok.]>=1900);  
end;

function ValidObdobi: boolean;
begin
  Result := ValidRok and (ValidMesic or ValidCtvrtleti);  
end;

function RokObdobi;
begin
  if ValidRok then
    Result:=[.Rok.]
  else if [:ObdobiOd:]<>'' then
    Result:=YearOf([.ObdobiOd.])
  else
    Result:=CurrentYear;
end;

function QuarterOf(ADate: TDateTime): integer;
var
  m: word;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  m:=0; 
  //--- konec automaticke inicializace
  m := MonthOf(ADate);
  if (m >= 1) and (m <=3) then
    Result := 1
  else if (m >= 4) and (m <= 6) then
    Result := 2
  else if (m >= 7) and (m <= 9) then
    Result := 3
  else if (m >= 10) and (m <= 12) then
    Result := 4
  else
    Result := 0;
end;

function LastDayInMonth(AValue: TDateTime): TDateTime;
begin
  Result := EncodeDate(YearOf(AValue), MonthOf(AValue), DaysInMonth(AValue));
end;

//pred volanim musime testovat, zda ma udaj ctvrtleni spravnou hodnotu 1-4
function GetPeriodDate(AGetLastPeriod: boolean);
var mesic: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  mesic:=0; 
  //--- konec automaticke inicializace
  if [.Ctvrtleti.]=1 then
    mesic:=1
  else if [.Ctvrtleti.]=2 then
    mesic:=4
  else if [.Ctvrtleti.]=3 then
    mesic:=7
  else if [.Ctvrtleti.]=4 then
    mesic:=10;
  if AGetLastPeriod then
    mesic:=mesic+2;
  Result:=EncodeDate(RokObdobi,mesic,1);
end;

function DateForObdobi(AGetLastDay: boolean);
begin
  if (StrToIntSafe([:Mesic:])>0) and (StrToIntSafe([:Mesic:])<=12) then begin
    Result:=EncodeDate(RokObdobi,StrToIntSafe([:Mesic:]),1);
  end
  else if ([:Ctvrtleti:]<>'') and ([.Ctvrtleti.]>=1) and ([.Ctvrtleti.]<=4) then begin
    Result:=GetPeriodDate(AGetLastDay);
  end
  else if [.ObdobiOd.]>0 then begin
    Result:=VarToDateTime([.ObdobiOd.]);
  end
  else
    Result:=Date;
  //
  if AGetLastDay then
    Result := LastDayInMonth(Result);
end;

function GetObdobi: TDateTime;
begin
  Result := DateForObdobi(False);  
end;

function GetObdobiLastDay: TDateTime;
begin
  Result := DateForObdobi(True);  
end;

procedure OnChangeExit_Mesic;
begin
  TryEditValuesRecord;
  if [:Mesic:]<>'' then begin
    if (StrToIntSafe([:Mesic:])<=0) or (StrToIntSafe([:Mesic:])>12) then begin
      MsgBoxWarn(Caption,'Měsíc musí být v rozsahu 1-12.', MB_OK);
      ClearField('Mesic');
      GotoFld('Mesic');
      Exit;
    end;
    //
    if [:Rok:] = '' then
      [:Rok:] := CurrentYear;
    ClearField('Ctvrtleti');
  end;
  TryPostValuesRecord;
end;

procedure OnChangeExit_Ctvrtleti;
begin
  TryEditValuesRecord;
  if [:Ctvrtleti:]<>'' then begin
    if ([:Ctvrtleti:]<>'') and (([.Ctvrtleti.]<=0) or ([.Ctvrtleti.]>4)) then begin
      MsgBoxWarn(Caption,'Čtvrtletí musí být v rozsahu 1-4.', MB_OK);
      ClearField('Ctvrtleti');
      GotoFld('Ctvrtleti');
    end;
    //
    if [:Rok:] = '' then
      [:Rok:] := CurrentYear;
    ClearField('Mesic');
  end;
  TryPostValuesRecord;
end;

function CisFu2CUfo(AStr: string): string;
begin
  Result := '';
  if Length(AStr) = 4 then begin
    Result := Copy(AStr,1,2)+'00';
  end;
end;

procedure OnChangeExit_CisFU;
begin
  if not mtValues.ReadOnly then begin
    TryEditValuesRecord;
    if [:CisFU:]<>'' then begin
      if [:CisFU:]=VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'CisloFU')) then begin
        if [:CisFU:]<>CisFu2CUfo([:CisFU:]) then
          [:FU:]:=VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'Nazev'))
        else
          ClearField('FU');
        [:UFO:]:=VarToStr(LstLookup('FU13',Date,'CisloFU',CisFu2CUfo([:CisFU:]),'Nazev'));
        [:C_Ufo:]:=VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'C_Ufo'));
      end
      else begin
        ClearField('FU');
        ClearField('UFO');
        ClearField('C_Ufo');
      end;
    end;
    TryPostValuesRecord;
  end;
end;

procedure OnChangeExit_Obec;
var
  s: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  s:=''; 
  //--- konec automaticke inicializace
  IncSpolFce_OnChangeObecSetPSC('ObceFU','PSC','Obec');
end;

procedure OnChangeExit_PSC;
var
  s: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  s:=''; 
  //--- konec automaticke inicializace
  IncSpolFce_OnChangePSCSetObec('ObceFU','PSC','Obec');
end;

function CalcKoefVProc: boolean;
begin
  Result := (GetObdobi >= EncodeDate(2011,4,1));
end;

function RoundKoef(AKoef: double): double;
begin
  if (not CalcKoefVProc) and (AKoef>=0.95) then Result:=1
  else if (CalcKoefVProc) and (AKoef>=95) then Result:=100
  else Result:=AKoef;
end;

function CalcKoef: double;
var
  citatel, castjmenovatelebeznaroku, jmenovatel: double;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  citatel:=0.0; castjmenovatelebeznaroku:=0.0; jmenovatel:=0.0; 
  //--- konec automaticke inicializace
  citatel:=([.R01z.]+[.VR01z.]) + ([.R02z.]+[.VR02z.]) + ([.R20.]+[.VR20.]) +
           ([.R21.]+[.VR21.]) + ([.R22.]+[.VR22.]) + ([.R23.]+[.VR23.]) +
           ([.R24.]+[.VR24.]) + ([.R25.]+[.VR25.]) + ([.R26.]+[.VR26.]) +
           ([.R31.]+[.VR31.]) -
           ([.R51NarokOdp.]+[.VR51NarokOdp.]);
  castjmenovatelebeznaroku:=([.R50.]+[.VR50.]) - ([.R51BezNarokOdp.]+[.VR51BezNarokOdp.]);
  jmenovatel:=citatel+castjmenovatelebeznaroku;

  if (citatel<=0)and(castjmenovatelebeznaroku>0) then //ze zakona
    Result:=0
  else if (citatel>=0)and(castjmenovatelebeznaroku<=0) then //ze zakona
    Result:=1
  else if jmenovatel=0 then //kvuli deleni nulou
    Result:=0
  else
    Result:=RoundUp(citatel/jmenovatel,-2);

  if CalcKoefVProc then
    Result := Result*100;
  Result := RoundKoef(Result);
end;

function CountryFromKod(AKlicovyUdaj: string; AKod: string): string;
var
  stat: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stat:=''; 
  //--- konec automaticke inicializace
  Result := '';
  stat := AKod;
  if stat = '' then
    stat := ClientParam('Country');
  if AnsiUpperCase(stat) = 'ČR' then
    stat := 'CZ';
  if Length(stat) = 2 then
    Result := LstLookup('KodyStatu',Date,'KodAlpha2',AnsiUpperCase(stat), AKlicovyUdaj);
end;

function VyplnitOprOs: boolean;
begin
  Result := [.ZastPO.] or ([.ckPO.] and (not [.ZastFO.]) and (not [.ZastPO.]));
end;

procedure VisibleDuvodyDDP;
begin
  if mtContent.FindField('Key').AsInteger = 1 then begin
    laDuvodyDPNadpis.Visible := [.ckDodatecne.];
    laDuvodyDPDenZjist.Visible := [.ckDodatecne.];
    laDuvodyDPDuvody.Visible := [.ckDodatecne.];
    meDuvodyDDP.Visible := [.ckDodatecne.];
    btDuvodyDDP.Visible := [.ckDodatecne.];
    DenDuvodu.Visible := [.ckDodatecne.];
    ckTiskDDP.Visible := [.ckDodatecne.];
  end;
end;

procedure OnClick_btDuvodyDDP;
var
  s: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  s:=''; 
  //--- konec automaticke inicializace
  s:= [:meDuvodyDDP:];
  if AskMemo(Caption,'Důvody pro podání dodatečného přiznání',s) <> mrOK then
    EXIT;
  TryEditValuesRecord;
  [:meDuvodyDDP:]:=s;   
  [.ckTiskDDP.]:=True;
  TryPostValuesRecord;
end;

//testuje, zda je uvedene datumu vikend, pokud ano, tak vraci pondelni datum
function DateAfterWeek(ADate: TDateTime): TDateTime;
begin
  Result := ADate;
  if (DayOfTheWeek(Result) = 6) or (DayOfTheWeek(Result) = 7) then begin
    repeat
      Result := Result+1;
    until (DayOfTheWeek(Result) = 1);
  end;
end;

//vraci datum, na ktery spada povinnost podat priznani
//- priznani se podava do 25 dne mesice, ktery nasleduje po zdanovacim obdobi
//- pokud 25 pripada na vikend, tak vraci datum pondeli
//- pokud datum pondeli pripadne na 25.12., resp. 26.12, vraci datum 27.12
function DateOfPayment(ADate: TDateTime): TDateTime;
begin
  Result := DateAfterWeek(EncodeDate(YearOf(ADate), MonthOf(ADate), 25));
  if (Result = EncodeDate(YearOf(Result), 12, 25)) or 
     (Result = EncodeDate(YearOf(Result), 12, 26)) then
    Result := EncodeDate(YearOf(Result), 12, 27);  
end;

//vraci den v mesici, na ktery spada povinnost podat priznani (ostatni viz. DateOfPayment)
function DayOfPayment(ADate: TDateTime): Word;
begin
  Result := DayOf(DateOfPayment(ADate)); 
end;

function IsEPOImportFromKlient: boolean;
begin
  Result := (GEPOFilePath <> '');
end;

function EnaRadky14a48: boolean;
begin
  Result := (StrToInt(RokObdobi) >= 2025) and [.ckDodatecne.];
end;

///////////////////////////////////////////////////////////////////////////////
//STANDARD FUNCTIONS
///////////////////////////////////////////////////////////////////////////////
function IsFaValidForRadioButton: boolean;
begin
  Result := TRUE;
  if CompareVersion(GetPrgVersion, '21.1.2') = -1 then
    Result := False;          
end;


procedure AfterLoadPage;
begin
  try
    if mtContent.FindField('Key').AsInteger = 1 then begin
      VisibleDuvodyDDP;
    end;
  except
  end; 
  if not IsFaValidForRadioButton then begin    
    MsgBoxWarn(Caption, 'Formulář vyžaduje aktualizaci programu na poslední verzi.', MB_OK);    
    Exit;    
  end;

end;

procedure AfterOpen;
begin
  VisibleDuvodyDDP;
end;

procedure OnChangeExit_ckDodatecne;
begin
  VisibleDuvodyDDP;
end;

procedure OnChangeExit_ckRadne;
begin
  VisibleDuvodyDDP;
end;

function Groups: string;
begin
  Result:='ckRadne,ckDodatecne,disableUncheck;'+
    'PlatceDane,IdentifikOsKDani,Skupina95a,NeplatceDane,NeplatceDanePorNDP,NeplatceDaneDodNDP,disableUncheck;'+
    'ZastFO,ZastPO';
end; {Groups}

procedure ChangeFU;
var
  cis: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  cis:=''; 
  //--- konec automaticke inicializace
  if Length([:CisFU:])<4 then begin
    TryEditValuesRecord;
    cis:=VarToStr(LstLookup('FU13',Date,'CisloFUPuv',[:CisFU:],'CisloFUPuv'));
    if cis <> '' then begin
      [:CisFU:]:=VarToStr(LstLookup('FU13',Date,'CisloFUPuv',cis,'CisloFU'));
    end;
    TryPostValuesRecord;
  end;
  OnChangeExit_CisFU;
end;

function IsNeplatceDane: boolean;
begin
  Result := [.NeplatceDane.] or [.NeplatceDanePorNDP.] or [.NeplatceDaneDodNDP.];
end;

procedure Init;
var
  datNar: TDateTime;
  tavCode: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  datNar:=0; 
  tavCode:=''; 
  //--- konec automaticke inicializace
  if IsEPOImportFromKlient then begin
    Exit;
  end;
  //
  ini('CisFU', ClientParam('FONo'));
  if GScriptState=ssInit then begin
    ChangeFU;
  end;

  if GScriptState=ssInit then begin
    tavCode := ClientParam('TAVCode');
    ini('PlatceDane', (tavCode='1') or (tavCode=''));
    ini('IdentifikOsKDani', (tavCode='2'));
    ini('Skupina95a', (tavCode='3'));
    ini('NeplatceDane', (tavCode='4'));
    //ini('PlatceDane',Cond([.PlatceDane.]or[.IdentifikOsKDani.]or[.NeplatceDane.],[.PlatceDane.],True));
  end;

  ino('ckPO',Cond(StrToBoolSafe(ClientParam('Corporation')),True,False));
  ini('DIC',ClientParam('TIN'));
  ini('RodCis',Cond(IsNeplatceDane,Cond([.ckPO.],ClientParam('CIN'),ClientParam('FPPersonalNo')),''));
  ini('ckRadne',Cond([.ckRadne.]or[.ckOpravne.]or[.ckDodatecne.],[.ckRadne.],True));
  ini('Rok',Cond((not IsNeplatceDane)and([:ObdobiOd:]='')and([:ObdobiDo:]=''),CurrentYear,null));

  if [.ckPO.] then begin
    ini('POObchJmeno',ClientParam('CommercialName'));
    ini('PODodatek',ClientParam('AppComName'));
  end
  else begin
    ini('FOPrijmeni',ClientParam('LastName'));
    ini('FOJmeno',ClientParam('FirstName'));
    ini('FOTitul',TrimChars(ClientParam('Prefix')+', '+ClientParam('Suffix'),', '));
  end;

  //Zastupce
  ini('ZastKod',ClientParam('TCCode'));
  if ([:ZastKod:]='4b') or ([:ZastKod:]='1') then begin
    ino('ZastFO',TRUE);
  end
  else if [:ZastKod:]='4c' then begin
    ino('ZastPO',TRUE);
  end;
  if StrToBoolSafe(ClientParam('UseTC')) then begin
    if VarToBool(ClientParam('TCLegalPerson')) then begin
      if [:ZastKod:]='' then begin
        ini('ZastKod','4c');
      end;
      if (not [.ZastPO.]) and (not [.ZastFO.]) then begin
        ini('ZastPO',TRUE);
      end;
    end
    else begin
      if [:ZastKod:]='' then begin
        ini('ZastKod','4b');
      end;
      if (not [.ZastPO.]) and (not [.ZastFO.]) then begin
        ini('ZastFO',TRUE);
      end;
    end;
    //
    if [.ZastFO.] then begin
      ini('ZastJm',ClientParam('TCName'));
      ini('ZastPrijm',ClientParam('TCSurname'));
      ini('ZastTitul',ClientParam('TCTitul'));
      ini('ZastEvCislo',ClientParam('TCEvidenceNumber'));
      datNar:=RCDatNar(ClientParam('FillerAnsiShortString1'));
      if datNar > 0 then begin
        ini('ZastDatNar',datNar);
      end;
    end
    else begin
      ini('ZastIC',ClientParam('TCIdentificationNumber'));
      ini('ZastNazPO',ClientParam('TCLegalPersonName'));
    end;
  end;

  //Opravnena osoba
  if VyplnitOprOs then begin
    if StrToBoolSafe(ClientParam('UseTC')) then begin
      ini('OprOsPrijm',ClientParam('TCSurname'));
      ini('OprOsJm',ClientParam('TCName'));
      ini('OprOsTitul',ClientParam('TCTitul'));
      ini('OprOsPost',ClientParam('TCPosition'));
    end
    else begin
      ini('OprOsPrijm',ClientParam('AgentLastName'));
      ini('OprOsJm',ClientParam('AgentFirstName'));
      ini('OprOsTitul',ClientParam('AgentPrefix'));
      ini('OprOsPost',ClientParam('AgentPosition'));
    end
  end;

  //Sestavil
  if ClientParam('UserName')<>'' then begin
    ini('SestJm', ClientParam('UserFirstName'));
    ini('SestPrijm', ClientParam('UserName'));
    ini('SestTitul', ClientParam('UserPrefix'));
    ini('SestTel',ClientParam('UserPhone'));
  end
  else if StrToBoolSafe(ClientParam('UseTC')) then begin
    ini('SestPrijm',ClientParam('TCSurName'));
    ini('SestJm',ClientParam('TCName'));
    ini('SestTitul',ClientParam('TCTitul'));
    ini('SestTel',ClientParam('TCTelephone'));
  end;

  ini('Obec',ClientParam('City'));
  ini('PSC',Replace(' ',ClientParam('ZipCode'),''));
  ini('Telefon',CalcPhoneMobil(ClientParam('Mobile'), ClientParam('Phone')));

  ini('Ulice',ClientParam('Street'));
  ini('CisloPop',ClientParam('DescriptiveNo'));
  ini('CisloOrient',ClientParam('OrientationNo'));
  ini('Email',ClientParam('Email'));

  ini('Stat',CountryFromKod('Nazev', ''));
  ini('OKEC',ClientParam('OKEC1'));
  ini('HlavniCinnost',ClientParam('MajorArticle'));
  ini('Datum',Date);
     
  //změnila jsem na def, pokud zatrhnu 'UdajeOddC' tak mi to hlási kontrolu (Eva - 30.1.2025)
  def('R52koef', Cond(StrToFloatSafe(ClientParam('ImprestCoef'))<>0,
                 StrToFloatSafe(ClientParam('ImprestCoef')),null));

  def('r01dan', ValidValue('r01z',RoundAri(([.r01z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHz'))/100,0)));
  def('r02dan', ValidValue('r02z',RoundAri(([.r02z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHs'))/100,0)));

  def('r03dan', ValidValue('r03z',RoundAri(([.r03z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHz'))/100,0)));
  def('r04dan', ValidValue('r04z',RoundAri(([.r04z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHs'))/100,0)));

  def('r05dan', ValidValue('r05z',RoundAri(([.r05z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHz'))/100,0)));
  def('r06dan', ValidValue('r06z',RoundAri(([.r06z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHs'))/100,0)));

  def('r07dan', ValidValue('r07z',RoundAri(([.r07z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHz'))/100,0)));
  def('r08dan', ValidValue('r08z',RoundAri(([.r08z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHs'))/100,0)));
    
  def('r09dan', ValidValue('r09z',RoundAri(([.r09z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHz'))/100,0)));    

  def('r10dan', ValidValue('r10z',RoundAri(([.r10z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHz'))/100,0)));
  def('r11dan', ValidValue('r11z',RoundAri(([.r11z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHs'))/100,0)));

  def('r12dan', ValidValue('r12z',RoundAri(([.r12z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHz'))/100,0)));
  def('r13dan', ValidValue('r13z',RoundAri(([.r13z.]*
    LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHs'))/100,0))); 
  if EnaRadky14a48 then begin     
    def('r14dan', ValidValue('r14z',RoundAri(([.r14z.]*
      LstLookupNear('DPH', 'DatumOd',[GetObdobi],'SazbaDPHz'))/100,0)));    
  end;  

  if ([.PlatceDane.]) or ([.Skupina95a.]) then begin  
    def('R43z', ValidValue('R03z,R05z,R07z,R09z,R10z,R12z',([.R03z.]+[.R05z.]+
       [.R07z.]+[.R09z.]+[.R10z.]+[.R12z.])));
    def('R44z', ValidValue('R04z,R06z,R08z,R11z,R13z,',([.R04z.]+[.R06z.]+
       [.R08z.]+[.R11z.]+[.R13z.])));    
  end;
end;

procedure Calculate;
var
  odpocet: double;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  odpocet:=0.0; 
  //--- konec automaticke inicializace
  //nemazat!!!!!!!!!!!!!!!!!!!
  //cal('UFO',
  //cal('FU', 
  if [.IdentifikOsKDani.] then
    cal('UdajeOddC', False)
  else if [.NeplatceDane.] or [.NeplatceDanePorNDP.] or [.NeplatceDaneDodNDP.] then
    cal('UdajeOddC', True);    

  cal('R46danP',[.R40danP.]+[.R41danP.]+[.R42danP.]+[.R43danP.]+[.R44danP.]+
    [.R45danP.]);
  cal('R46danK',[.R40danK.]+[.R41danK.]+[.R42danK.]+[.R43danK.]+[.R44danK.]+
    [.R45danK.]);
  odpocet := Cond(CalcKoefVProc, RoundAri([.R46danK.]*RoundKoef([.R52koef.])/100,0), RoundAri([.R46danK.]*RoundKoef([.R52koef.]), 0));
  cal('R52',ValidValue('R52koef',odpocet));

  if [.fcbPocitatVyporadani.] then begin
    cal('R53koef',CalcKoef);
    odpocet := RoundAri(([.VR46danK.]+[.R46danK.])*(Cond(CalcKoefVProc, RoundAri([.R53koef.]/100,-2), [.R53koef.])),0)-
               ([.VR52.]+[.R52.]);
    cal('R53',odpocet);
  end;

  cal('R62',[.R01dan.]+[.R02dan.]+[.R03dan.]+[.R04dan.]+[.R05dan.]+
    [.R06dan.]+[.R07dan.]+[.R08dan.]+[.R09dan.]+[.R10dan.]+[.R11dan.]+
    [.R12dan.]+[.R13dan.]-[.R61.]+[.R62Dan.]);
  cal('R63',[.R46danP.]+[.R52.]+[.R53.]+[.R60.]);

  if not [.ckDodatecne.] then begin
//    if not [.NeplatceDane.] then begin            //dle testovacího webu, je stejné pro všechny typy osob (Eva - 30.1.2025)
      if ([.R62.]-[.R63.])>0 then begin
        cal('R64',[.R62.]-[.R63.]);
        ClearField('R65');
      end
      else if ([.R63.]-[.R62.])>0 then begin
        cal('R65',[.R63.]-[.R62.]);
        ClearField('R64');
      end
      else begin
        cal('R64',0);
        ClearField('R65');
      end;
//    end;
  end
  else begin
    ClearField('R64');
    ClearField('R65');
  end;

  if [.ckDodatecne.] then begin
    cal('R66',[.R62.]-[.R63.]);//
  end
  else begin
    cal('R66',null);
  end;
end;

function ValidZastKod: boolean;
begin
  Result := ([:ZastKod:]='1') or ([:ZastKod:]='2') or ([:ZastKod:]='3') or
            ([:ZastKod:]='4a') or ([:ZastKod:]='4b') or ([:ZastKod:]='4c') or
            ([:ZastKod:]='5a') or ([:ZastKod:]='5b') or ([:ZastKod:]='6a') or
            ([:ZastKod:]='6b') or ([:ZastKod:]='7a') or ([:ZastKod:]='7b');
end;

procedure Enable;
var
  b: boolean;
begin
  ena('NeplatceDaneNDPDatum',([.NeplatceDanePorNDP.]) or ([.NeplatceDaneDodNDP.]));
  ena('UdajeOddC',([.PlatceDane.]) or ([.IdentifikOsKDani.]) or([.Skupina95a.]));       //dle testovacího webu jsem doplnila 'IdentifikOsKDani' (Eva - 30.1.2025)
  ena('KodZdanObd',([.ckRadne.]) and ([.PlatceDane.]) and ([:Mesic:]='12') or ([:Ctvrtleti:] = '4'));

  ena('POObchJmeno',[.ckPO.]);
  ena('POObchJmeno1',[.ckPO.]);
  ena('PODodatek',[.ckPO.]);
  ena('FOPrijmeni',not [.ckPO.]);
  ena('FOJmeno',not [.ckPO.]);
  ena('FOTitul',not [.ckPO.]);
  ena('DenDuvodu',[.ckDodatecne.]);
  ena('meDuvodyDDP',[.ckDodatecne.]);
  ena('ckTiskDDP',[.ckDodatecne.]);
  
  b := EnaRadky14a48; 
  ena('R14z',b);
  ena('R14dan',b);
  ena('R48z',b);
  ena('R48danP',b);
  ena('R48danK',b);        

  ena('R53',{not [.IdentifikOsKDani.] and} not [.fcbPocitatVyporadani.]);
  ena('R53koef',{not [.IdentifikOsKDani.] and} not [.fcbPocitatVyporadani.]);

//  ena('R64',([.NeplatceDane.]));      //dle testovacího webu, je stejné pro všechny typy osob (Eva - 30.1.2025)
//  ena('R65',([.NeplatceDane.]));      //dle testovacího webu, je stejné pro všechny typy osob (Eva - 30.1.2025)
  ena('RodCis',IsNeplatceDane);

  ena('ZastFO',([:ZastKod:]<>'') and ValidZastKod);
  ena('ZastPO',([:ZastKod:]<>'') and ValidZastKod);

  ena('ZastJm',[.ZastFO.]);
  ena('ZastPrijm',[.ZastFO.]);
  ena('ZastTitul',[.ZastFO.]);
  ena('ZastEvCislo',[.ZastFO.]);
  ena('ZastDatNar',[.ZastFO.]);

  ena('ZastIC',[.ZastPO.]);
  ena('ZastNazPO',[.ZastPO.]);

  ena('OprOsJm', VyplnitOprOs);
  ena('OprOsPrijm', VyplnitOprOs);
  ena('OprOsTitul', VyplnitOprOs);
  ena('OprOsPost', VyplnitOprOs);
end;

procedure CheckZaklxDPH(ARadek,AFieldName: string; AZaklad, ADan: double;
  AZakladni: boolean);
var
  sazba, dif: double;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  sazba:=0.0; dif:=0.0; 
  //--- konec automaticke inicializace
    if AZakladni then begin
      sazba:=sazbaZakladni;
    end
    else begin
      sazba:=sazbaSnizena;
    end;

    dif:=StrToFloatSafe(ClientParam('TAVDiference'));
    if dif=0 then
      dif:=1;
   // if ADan<>0 then begin
      if AZakladni or (sazbaSnizena2 = 0) then
        chk(AFieldName,RoundAri(Abs(AZaklad*sazba/100-ADan),0)>
          (RoundAri(Abs(ADan*dif/100),0)+1),
          Format('Zadaná daň (%s Kč) na řádku %s neodpovídá vypočtené hodnotě %s Kč, rozdíl je %s Kč.',
            [FloatToStr(ADan),ARadek,
            FloatToStr(RoundAri(AZaklad*sazba/100,0)),FloatToStr(RoundAri(Abs(AZaklad*sazba/100-ADan),0))]),1)
      else
        chk(AFieldName,(RoundAri(Abs(AZaklad*sazbaSnizena/100-ADan),0)>(RoundAri(Abs(ADan*dif/100),0)+1)) and
                       (RoundAri(Abs(AZaklad*sazbaSnizena2/100-ADan),0)>(RoundAri(Abs(ADan*dif/100),0)+1)),
          Format('Zadaná daň (%s Kč) na řádku %s neodpovídá vypočtené hodnotě %s Kč pro sazbu %s%% (rozdíl je %s Kč) '+
                 'a hodnotě %s Kč pro sazbu %s%% (rozdíl je %s Kč).',
            [FloatToStr(ADan),ARadek,
            FloatToStr(RoundAri(AZaklad*sazbaSnizena/100,0)),FloatToStr(sazbaSnizena),
            FloatToStr(RoundAri(Abs(AZaklad*sazbaSnizena/100-ADan),0)),
            FloatToStr(RoundAri(AZaklad*sazbaSnizena2/100,0)),FloatToStr(sazbaSnizena2),
            FloatToStr(RoundAri(Abs(AZaklad*sazbaSnizena2/100-ADan),0))]),1)
   // end;
end;

function IsZaklAndDPHFilled(ARadek, AZakladFieldNames, ADanFieldNames: string): boolean;
var
  i: integer;
  fld: string;
  bZ, bD: boolean;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  i:=0; 
  fld:=''; 
  bZ:=False; bD:=False; 
  //--- konec automaticke inicializace
  Result := True;
  bZ := False;
  fld := GetListItem(AZakladFieldNames, 0);
  for i:=0 to CountListItems(AZakladFieldNames)-1 do begin
    if mtValues.FindField(GetListItem(AZakladFieldNames,i)).AsString <> '' then begin
      bZ := True;
      Break;
    end;
  end;
  //
  bD := False;
  if bZ then
    fld := GetListItem(ADanFieldNames, 0);
  for i:=0 to CountListItems(ADanFieldNames)-1 do begin
    if mtValues.FindField(GetListItem(ADanFieldNames,i)).AsString <> '' then begin
      bD := True;   
      Break;
    end;
  end;
  //
  if ((bZ) and (not bD)) or ((not bZ) and (bD)) then begin
    Result := False;
    chk(fld, True,
     Format('Je zadána pouze jedna z hodnot základ daně/daň na řádku %s. Musí být zadány obě tyto hodnoty.',
      [ARadek]), 1);
  end;
end;

procedure CheckOddil4IdentOs;
var
  i, j: integer;   
  fld: TField;
  fldName, fldValue: string; 
  brk: boolean;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  i:=0; j:=0; 
  fldName:=''; fldValue:=''; 
  brk:=False; 
  //--- konec automaticke inicializace
  brk := False;
  for i := 40 to 47 do begin  
    if i <> 46 then begin
      brk := False;
      for j := 1 to 3 do begin
        fldName := Cond2(j=1, 'R'+IntToStr(i)+'z', j=2, 'R'+IntToStr(i)+'danP', 'R'+IntToStr(i)+'danK');
        fld := mtValues.FindField(fldName);
        if (fld <> nil) and (fld.AsCurrency <> 0) then begin        
          brk := True;
          Break;
        end;  
      end;  
    end;
    if brk then
      Break;        
  end;
  //        
  if brk then
    chk(fldName, True, 'Identifikovaná osoba nesmí mít vyplněny řádky 40 - 47 oddílu IV.'); 
end;  

function IsOddil1az6Vyplnen;
var
  i: integer;  
  fld: TField; 
  fldName: string;
begin
  Result := False;
  for i:=0 to mtValues.Fields.Count-1 do begin  
    fld := mtValues.Fields[i];
    fldName := fld.FieldName; 
    if (fldName[0]='R') and (IsDigit(Copy(fldName, 2,2))) then begin
      if fld.AsInteger <> 0 then begin
        Result := TRUE;
        Break;
      end;      
    end;
  end;
end;

function IsOddilC1az5Vyplnen;
var
  i: integer;  
  fld: TField; 
  fldName: string;
begin
  Result := False;
  for i:=0 to mtValues.Fields.Count-1 do begin  
    fld := mtValues.Fields[i];
    fldName := fld.FieldName; 
    if (fldName[0]='R') and (IsDigit(Copy(fldName, 2,2))) and (Copy(fldName, 2,2) < 53) then begin
      if fld.AsInteger <> 0 then begin
        Result := TRUE;
        Break;
      end;      
    end;
  end;
end;

procedure Check;
var
  fld: string;
  obdOd, obdDo: TDateTime;
  dnuVMes: integer;      
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  fld:=''; 
  obdOd:=0; obdDo:=0; 
  dnuVMes:=0; 
  //--- konec automaticke inicializace
  if IsEPOImportFromKlient then begin
    Exit;
  end;
  //
  chk('CisFU',[:CisFU:]='','Nezadané číslo finančního úřadu (územního pracoviště).');

  chk('CisFU',([:CisFU:]<>'') and ([:FU:]<>'') and ([:CisFU:]<>VarToStr(LstLookup('FU13', Date, 'CisloFU',[:CisFU:],'CisloFU'))),
    'Zadejte platné číslo finančního úřadu (územního pracoviště)');
  chk('CisFU',([:CisFU:]<>'') and ([:FU:]='') and (StrToIntSafe([:CisFU:])<4000),
        Cond([:UFO:]='', 'Zadejte platné číslo finančního úřadu (územního pracoviště).',
       'Doporučujeme změnit uvedené číslo FÚ za číslo územního pracoviště.'), Cond([:UFO:]='',0,1));
  chk('CisFU',([:CisFU:]<>'') and (StrToIntSafe([:CisFU:])>=5000),'Zadejte platné číslo finančního úřadu.',
       Cond(StrToIntSafe([:CisFU:])=5000,1,0));

  chk('DIC',([:DIC:]=''),'Nezadané daňové identifikační číslo');
  chk('DIC',not CheckDIC([:DIC:],[.ckPO.],TRUE),Cond([.ckPO.],'Neplatné DIČ právnické osoby','Neplatné DIČ fyzické osoby'),1);
  if ClientParam('TIN') <> '' then begin
    if [:DIC:]<> '' then begin
      chk('DIC', (([:DIC:]) <> ClientParam('TIN')), 'DIČ se neshoduje s údajem v nastavení klienta', 1);
    end;
  end;
  
  //chk('RodCis',([:RodCis:]='') and ([.NeplatceDane.] or [.NeplatceDanePorNDP.] or [.NeplatceDaneDodNDP.]),'Nezadané Rodné číslo/IČ');
  
  chk('RodCis',(([.ckPO.]) and (not CheckICO([:RodCis:]))) or ((not [.ckPO.]) and (not CheckRodneCislo([:RodCis:]))),
               Cond([.ckPO.],'Neplatné IČ právnické osoby','Neplatné Rodné číslo fyzické osoby'),1);

  if (ClientParam('FPPersonalNO') <> '') then begin
    if ([:RodCis:]<> '') and (not [.ckPO.]) then begin
      chk('RodCis', (([:RodCis:]) <> ClientParam('FPPersonalNO')), 'Rodné číslo se neshoduje s údajem v nastavení klienta', 1);
    end;
  end;

  if (ClientParam('CIN') <> '')  then begin
    if (([:RodCis:]<> '') and ([.ckPO.]) and (IsNeplatceDane)) then begin
      chk('RodCis', (([:RodCis:]) <> ClientParam('CIN')), 'IČ se neshoduje s údajem v nastavení klienta', 1);
    end;
  end;

  chk('ckRadne',not([.ckRadne.]or[.ckOpravne.]or[.ckDodatecne.]),'Nezadaný typ přiznání');
  chk('ckRadne',([.ckRadne.]) and ([:Datum:] <> '') and (([:Mesic:]<>'') or ([:Ctvrtleti:]<>'')) and
      ([.Datum.] > DateOfPayment(IncMonth(GetObdobiLastDay))),
      'Ověřte, zda není běžné(opravné) daňové přiznání podáváno po lhůtě pro podání daň. přiznání.',5);
                         
//  if not [.NeplatceDane.] then begin
    chk('Mesic',([:Mesic:]='')and([:Ctvrtleti:]=''),
      'Nezadané zdaňovací období - měsíc nebo čtvrtletí');

    chk('Mesic',(StrToIntSafe([.Mesic.])>=1) and (StrToIntSafe([.Mesic.])<=12) and
                (StrToBoolSafe(ClientParam('TAVQuarter'))) and
                (StrToBoolSafe(ClientParam('PayerAddedValue'))),
      'Vyplňujete přiznání za měsíc, v nastavení klienta je však zaškrtnuto: Čtvrtletní plátce DPH',1);
         
    chk('Mesic',([:Ctvrtleti:]='') and ([.Rok.]>=YearOf(Date)) and (StrToIntSafe([:Mesic:])>=0) and (StrToIntSafe([:Mesic:])<=12) and (StrToIntSafe([:Mesic:])>MonthOf(Date)),
      'Zadaný měsíc je vyšší než aktuální.',1);      
    //chk('Mesic',([:Ctvrtleti:]='') and ValidObdobi and (GetObdobiLastDay>Date),
      //  'Období, za které je KH DPH podáváno, je celé v budoucnosti nebo ještě neskončilo.',1);

    //chk('Ctvrtleti',([:Mesic:]='') and ValidObdobi and (GetObdobiLastDay>Date),
      //  'Období, za které je KH DPH podáváno, je celé v budoucnosti nebo ještě neskončilo.',1);
    chk('Ctvrtleti',([:Mesic:]='') and ([.Rok.]>=YearOf(Date)) and ([.Ctvrtleti.]>0) and ([.Ctvrtleti.]<=4) and ([.Ctvrtleti.]>QuarterOf(Date)),
      'Zadané čtvrtletí je vyšší než aktuální.',1);        
      
    chk('Ctvrtleti',([.Ctvrtleti.]>=1) and ([.Ctvrtleti.]<=4) and
                    (not StrToBoolSafe(ClientParam('TAVQuarter'))) and
                    (StrToBoolSafe(ClientParam('PayerAddedValue'))),
      'Vyplňujete přiznání za čtvrtletí, v nastavení klienta však není zaškrtnuto: Čtvrtletní plátce DPH',1);

    chk('Rok',([:Rok:]=''),
      'Nezadané zdaňovací období - rok');

    chk('ObdobiOd',([:ObdobiOd:]='')and([:ObdobiDo:]<>''),
      'Zadejte oba datumy ve zdaňovacím období od - do');
    chk('ObdobiDo',([:ObdobiOd:]<>'')and([:ObdobiDo:]=''),
      'Zadejte oba datumy ve zdaňovacím období od - do');
    chk('ObdobiDo',([:ObdobiDo:]<>'') and ([.ObdobiDo.]<[.ObdobiOd.]), Format(Warn003,['']));

    obdOd:=0;
    obdDo:=0;
    if [:Rok:]<>'' then begin
      if [:Mesic:]<>'' then begin
        dnuVmes:=DaysInMonth(EncodeDate(StrToIntSafe([.Rok.]),StrToIntSafe([.Mesic.]),1));
        obdOd:=EncodeDate(StrToIntSafe([.Rok.]),StrToIntSafe([.Mesic.]),1);
        obdDo:=EncodeDate(StrToIntSafe([.Rok.]),StrToIntSafe([.Mesic.]),dnuVMes);
      end
      else if ([.Ctvrtleti.]='1') and ([.Rok.]>1900) then begin
        obdOd:=EncodeDate(StrToIntSafe([.Rok.]),1,1);
        obdDo:=EncodeDate(StrToIntSafe([.Rok.]),3,31);
      end
      else if ([.Ctvrtleti.]='2') and ([.Rok.]>1900) then begin
        obdOd:=EncodeDate(StrToIntSafe([.Rok.]),4,1);
        obdDo:=EncodeDate(StrToIntSafe([.Rok.]),6,30);
      end
      else if ([.Ctvrtleti.]='3') and ([.Rok.]>1900) then begin
        obdOd:=EncodeDate(StrToIntSafe([.Rok.]),7,1);
        obdDo:=EncodeDate(StrToIntSafe([.Rok.]),9,30);
      end
      else if ([.Ctvrtleti.]='4') and ([.Rok.]>1900) then begin
        obdOd:=EncodeDate(StrToIntSafe([.Rok.]),10,1);
        obdDo:=EncodeDate(StrToIntSafe([.Rok.]),12,31);
      end;
      if ([:ObdobiOd:]<>'')and(ObdOd>0)and(ObdDo>0) then
        chk('ObdobiOd',([.ObdobiOd.]<obdOd)or([.ObdobiOd.]>obdDo),
          'Začátek zdaňovacího období od nespadá do zadaného měsíce nebo čtvrtletí zadaného roku');
      if ([:ObdobiOd:]<>'')and(ObdOd>0)and(ObdDo>0) then
        chk('ObdobiDo',([.ObdobiDo.]<obdOd)or([.ObdobiDo.]>obdDo),
          'Konec zdaňovacího období od nespadá do zadaného měsíce nebo čtvrtletí zadaného roku');
    end;
{  end
  else begin
    if [:Mesic:]<>'' then
      fld := 'Mesic'
    else if [:Ctvrtleti:]<>'' then
      fld := 'Ctvrtleti'
    else if [:Rok:]<>'' then
      fld := 'Rok'
    else if [:ObdobiOd:]<>'' then
      fld := 'ObdobiOd'
    else if [:ObdobiDo:]<>'' then
      fld := 'ObdobiDo';
    chk(fld, ([:Mesic:]<>'') or ([:Ctvrtleti:]<>'') or ([:Rok:]<>'') or ([:ObdobiOd:]<>'') or ([:ObdobiDo:]<>''), 'Neplátce daně zdaňovací období nevyplňuje!',1);
  end;
  }                     
  {chk('DenDuvodu',([:DenDuvodu:] <> '') and (([:Mesic:]<>'') or ([:Ctvrtleti:]<>'')) and //je vyplneno obdobi a datum zjisteni DDP
       (GetObdobiLastDay = LastDayInMonth(IncMonth(Date, -1))) and //jedna se o priznani za minuly mesic nebo ctvrtleti
       (MonthOf([.DenDuvodu.]) = MonthOf(Date)) and (YearOf([.DenDuvodu.]) = YearOf(Date)) and //datum DDP je tento mesic
       (DayOf([.DenDuvodu.]) <= DayOfPayment([.DenDuvodu.])) and
       ([.DenDuvodu.]<=Date),
      'Datum v položce Důvody pro podání dodatečného daňového přiznání zjištěny dne je v termínu pro podání běžného (opravného) DAP . Je nutné podat běžné (opravné) DAP.',5);}
      
  chk('DenDuvodu',([:DenDuvodu:] <> '') and (ValidObdobi) and //je vyplneno obdobi a datum zjisteni DDP
       ([.DenDuvodu.] <= Date) and //(rozdil oproti KH) - datum zjisteni DDP neni vetsi jak aktualni den
       ([.DenDuvodu.] <= DateOfPayment(IncMonth(GetObdobiLastDay))),//datum zjisteni DDP je mensi/roven terminu pro podani radneho priznani
      'Datum v položce Důvody pro podání dodatečného daňového přiznání zjištěny dne je v termínu pro podání běžného (opravného) DAP . Je nutné podat běžné (opravné) DAP.',5);      

  chk('DenDuvodu',[.ckDodatecne.]and([.DenDuvodu.]=0),
    'U dodatečného přiznání vyplňte den zjištění důvodů pro podání dodatečného přiznání');
  chk('DenDuvodu',[.ckDodatecne.]and([:meDuvodyDDP:]=''),
    'U dodatečného přiznání vyplňte důvody pro podání dodatečného přiznání',5);
  chk('DenDuvodu',([:DenDuvodu:] <> '') and ([.DenDuvodu.] > Date),
      'Datum v položce Důvody pro podání dodatečného daňového přiznání zjištěny dne nesmí být vyšší než aktuální datum.',4);
  chk('DenDuvodu',([:DenDuvodu:] <> '') and ([.DenDuvodu.] > [.Datum.]),
      'Datum v položce Důvody pro podání dodatečného přiznání zjištěny dne by neměl být vyšší než Datum vyhotovení.', 5);
  //chk('DenDuvodu',([:DenDuvodu:] <> '') and ([.DenDuvodu.] < GetObdobi),                                                //31.1.2024 (Marek) - v EPO jsem nenavodil
    //  'Datum v položce Důvody pro podání dodatečného přiznání zjištěny dne je nižší než počátek období v záhlaví.', 5);

  chk('PlatceDane',not ([.PlatceDane.]or[.IdentifikOsKDani.]or [.Skupina95a.] or IsNeplatceDane),'Nezadaný typ osoby');

  chk ('NeplatceDaneNDPDatum',([:NeplatceDaneNDPDatum:]='') and ([.NeplatceDanePorNDP.] or [.NeplatceDaneDodNDP.]),'Datum pořízení/dodání nového dopr. prostředku musí být vyplněno.',4);
  
  if [.IdentifikOsKDani.] then
    CheckOddil4IdentOs;  

  chk('KodZdanObd',(IsNeplatceDane) and ([:KodZdanObd:]<>''),'Neplátce daně kód zdaňovacího období následujícího roku nevyplňuje!',1);
  chk('KodZdanObd',([.ckRadne.]) and ([.PlatceDane.]) and ([:KodZdanObd:]='') and (([:Mesic:]='12') or ([:Ctvrtleti:] = '4')),'Pokud v následujícím kalendářním roce měníte zdaňovací období, vyplňte kód zdaňovacího období.',1);

  if [.ckPO.] then begin
    chk('POObchJmeno',[:POObchJmeno:]='','Nezadané obchodní jméno');
  end
  else begin
    chk('FOPrijmeni',[:FOPrijmeni:]='','Nezadané příjmení fyzické osoby');
    chk('FOJmeno',[:FOJmeno:]='','Nezadané jméno fyzické osoby');
  end;

  chk('Obec',[:Obec:]='','Nezadaná obec');
  chk('Obec',([:Obec:]<>'') and (AnsiUpperCase([:Obec:])<>AnsiUpperCase(VarToStr(LstLookup('ObceFU', Date,'Obec',AnsiUpperCase([:Obec:]),'Obec')))) and
    (([:Stat:]='') or (AnsiUpperCase([:Stat:])='ČESKÁ REPUBLIKA') or (AnsiUpperCase([:Stat:])='ČESKO')),'Zadaná obec není v číselníku obcí ČR (klávesa F12)',2);

  chk('PSC',[:PSC:]='','Nezadané PSČ');
  
  if (AnsiUpperCase([:Stat:]) = '') or (AnsiUpperCase([:Stat:]) = 'ČR') or 
     (AnsiUpperCase([:Stat:]) = 'CZ') or (AnsiUpperCase([:Stat:]) = 'ČESKO') or 
     (AnsiUpperCase([:Stat:]) = 'ČESKÁ REPUBLIKA') then begin
    chk('PSC',([:PSC:]<>'') and ((IsDigit([:PSC:]) = False) or (Length([:PSC:]) <> 5)),
      'PSČ musí mít 5 čísel');
  end;
  
  chk('CisloPop',([:CisloPop:] <> '') and (not IsInteger([:CisloPop:])),'Číslo popisné obsahuje nenumerické znaky. Pokud chcete podat přiznání elektronicky, odstraňte nenumerické znaky.',5);

  chk('Stat',([:Stat:]<>'') and ([:Stat:]<>LstLookup('KodyStatu', Date, 'Nazev',[.Stat.],'Nazev')),
    'Údaj "Stát" neodpovídá číselníku dle Seznamu kódu států (klávesa F12)',1);

  chk('Email',([:Email:]<>'') and (not IsEmailValid ([:Email:],TRUE)),'E-mail nemá správný formát elektronické adresy');
  
  chk('OKEC',([.PlatceDane.] or [.Skupina95a.]) and ([:OKEC:]=''),'Nezadaný kód CZ-NACE pro hlavní ekonomickou činnost. Pokud chcete podat přiznání elektronicky, je potřeba jej vyplnit.',5);
  chk('OKEC',([.OKEC.]<>'') and
     ([.OKEC.]<>LstLookup('OKEC', Date, 'OKEC',[.OKEC.],'OKEC')),'Kód klasifikace činnosti (CZ-NACE) pro hlavní činnost neodpovídá hodnotě z číselníku (klávesa F12)',1);

  //chk('UdajeOddC',([.PlatceDane.] or [.IdentifikOsKDani.] or [.Skupina95a.]) and ([.UdajeOddC.]) and (([.R62.]>0) or ([.R63.]>0)),
  //    'Je označeno, že v období nedošlo k žádnému zdanitelnému plnění, a přitom jsou vyplněny hodnoty v oddílech.');
  
  chk('UdajeOddC', [.UdajeOddC.] and (IsOddilC1az5Vyplnen or ([.R61.]>0)),
      'Je označeno, že v období nedošlo k žádnému zdanitelnému plnění, a přitom jsou vyplněny hodnoty v oddílu C.');        //dle testovacího webu, je stejné pro všechny typy osob (Eva - 30.1.2025)
          
  chk('UdajeOddC',(not [.UdajeOddC.]) and (not IsOddil1az6Vyplnen),
    'Aspoň jedna z položek oddílů I. až VI. musí být nenulová nebo musí být v záhlaví zatrženo, že v období nedošlo k žádnému zdanitelnému plnění');        //dle testovacího webu, je stejné pro všechny typy osob (Eva - 30.1.2025)
//      Format('Aspoň jedna z položek oddílů I. až VI. musí být nenulová%s.',
//             [Cond(not [.IdentifikOsKDani.], ' nebo musí být v záhlaví zatrženo, že v období nedošlo k žádnému zdanitelnému plnění','')]));

  chk('ZastKod',([:ZastKod:]<>'') and (not ValidZastKod),'Neplatný Kód zástupce');
  chk('ZastKod',(ValidZastKod) and ([.ZastFO.]) and (([:ZastKod:]='4c') or ([:ZastKod:]='7a')),'Pro Typ zástupce Fyzická osoba není možné použít Kód zástupce 4c a 7a.');
  chk('ZastKod',(ValidZastKod) and ([.ZastPO.]) and ([:ZastKod:]='4b'),'Pro Typ zástupce Právnická osoba není možné použít Kód zástupce 4b.');
  chk('ZastFO',([:ZastKod:]<>'') and (ValidZastKod) and (not ([.ZastFO.] or [.ZastPO.])),'Pokud je vyplněn údaj Kód zástupce, vyplňte Typ zástupce');
  chk('ZastJm',([.ZastFO.]) and ([:ZastJm:] = ''),'Nezadané Jméno zástupce');
  chk('ZastPrijm',([.ZastFO.]) and ([:ZastPrijm:] = ''),'Nezadané Příjmení zástupce');
  chk('ZastEvCislo',([.ZastFO.]) and ([:ZastEvCislo:] = '') and ([:ZastDatNar:] = ''),'Nezadané Datum narození nebo evidenční číslo zástupce');
  chk('ZastIC',([.ZastPO.]) and (([:ZastIC:] = '') or (not CheckICO([:ZastIC:]))),'IČ zástupce musí být vyplněno a musí být korektní.');
  chk('ZastNazPO',([.ZastPO.]) and ([:ZastNazPO:] = ''),'Nezadaný Název zástupce');

  if VyplnitOprOs then begin
    chk('OprOsJm',([:OprOsJm:]=''),'Nezadané Jméno fyzické osoby oprávněné k podpisu');
    chk('OprOsPrijm',([:OprOsPrijm:]=''),'Nezadané Příjmení fyzické osoby oprávněné k podpisu');
    chk('OprOsPost',([:OprOsPost:]=''),'Nezadaný Vztah FO oprávněné k podpisu vůčí PO');
  end;

  chk('Datum',[:Datum:]='', 'Nezadané datum podání daňového přiznání');
  chk('Datum',([:Datum:] <> '') and
              (([:Mesic:] <> '') or ([:Ctvrtleti:] <> '') or ([:ObdobiOd:] <> '')) and
              ([.Datum.]<=GetObdobiLastDay),
    'Datum podání daňového přiznání je před uplynutím zdaňovacího období',1);

  chk('R52Koef',([.R46danK.]<>0)and([:R52Koef:]=''),
    'Nezadaný zálohový koeficient');        
  chk('R52Koef',(CalcKoefVProc) and ([:R52Koef:]<>'') and (Frac([.R52Koef.])>0),
    'Hodnota zálohového koeficientu musí být celé číslo.',1);    
  chk('R52Koef',(CalcKoefVProc) and ([:R52Koef:]<>'') and 
                (([.R52Koef.]<0) or 
                 //(([.R52Koef.]>=95) and ([.R52Koef.]<100)) or //podminku v komentari osetrujeme v exportu do EPO XML 
                 ([.R52Koef.]>100)), 
    'Hodnota zálohového koeficientu musí být v rozmezí 0 až 94 nebo 100.',1);    


  sazbaZakladni := LstLookupNear('DPH','DatumOd',[GetObdobi],'SazbaDPHz');
  sazbaSnizena := LstLookupNear('DPH','DatumOd',[GetObdobi],'SazbaDPHs');
  sazbaSnizena2 := VarToDouble(LstLookupNear('DPH','DatumOd',[GetObdobi],'SazbaDPHt'));

  if IsZaklAndDPHFilled('1', 'R01z', 'R01dan') then
    CheckZaklxDPH('1','R01dan',[.R01z.],[.R01dan.],TRUE);

  if IsZaklAndDPHFilled('2','R02z','R02dan') then
    CheckZaklxDPH('2','R02dan',[.R02z.],[.R02dan.],FALSE);

  if IsZaklAndDPHFilled('3','R03z','R03dan') then
    CheckZaklxDPH('3','R03dan',[.R03z.],[.R03dan.],TRUE);

  if IsZaklAndDPHFilled('4','R04z','R04dan') then
    CheckZaklxDPH('4','R04dan',[.R04z.],[.R04dan.],FALSE);

  if IsZaklAndDPHFilled('5','R05z','R05dan') then
    CheckZaklxDPH('5','R05dan',[.R05z.],[.R05dan.],TRUE);

  if IsZaklAndDPHFilled('6','R06z','R06dan') then
    CheckZaklxDPH('6','R06dan',[.R06z.],[.R06dan.],FALSE);

  if IsZaklAndDPHFilled('7','R07z','R07dan') then
    CheckZaklxDPH('7','R07dan',[.R07z.],[.R07dan.],TRUE);

  if IsZaklAndDPHFilled('8','R08z','R08dan') then
    CheckZaklxDPH('8','R08dan',[.R08z.],[.R08dan.],FALSE);
                                                 
  if IsZaklAndDPHFilled('9','R09z','R09dan') then  
    CheckZaklxDPH('9','R09dan',[.R09z.],[.R09dan.],TRUE);

  if IsZaklAndDPHFilled('10','R10z','R10dan') then
    CheckZaklxDPH('10','R10dan',[.R10z.],[.R10dan.],TRUE);

  if IsZaklAndDPHFilled('11','R11z','R11dan') then
    CheckZaklxDPH('11','R11dan',[.R11z.],[.R11dan.],FALSE);

  if IsZaklAndDPHFilled('12','R12z','R12dan') then
    CheckZaklxDPH('12','R12dan',[.R12z.],[.R12dan.],TRUE);

  if IsZaklAndDPHFilled('13','R13z','R13dan') then
    CheckZaklxDPH('13','R13dan',[.R13z.],[.R13dan.],FALSE);
                                  
  if EnaRadky14a48 then begin    
    if IsZaklAndDPHFilled('14','R14z','R14dan') then
      CheckZaklxDPH('14','R14dan',[.R14z.],[.R14dan.],TRUE);    
  end;  

  if [.PlatceDane.] or {[.IdentifikOsKDani.] or} [.Skupina95a.] then begin        //dle testovacího webu, je stejné pro první 3 typy osob (Eva - 30.1.2025)
    if IsZaklAndDPHFilled('40','R40z','R40danP,R40danK') then                     //identifikovana osoba nevyplnuje radky 40 - 47 (Marek - 21.2.2025)
      CheckZaklxDPH('40','R40danP',[.R40z.],[.R40danP.]+[.R40danK.],TRUE);

    if IsZaklAndDPHFilled('41','R41z','R41danP,R41danK') then
      CheckZaklxDPH('41','R41danP',[.R41z.],[.R41danP.]+[.R41danK.],FALSE);
      
    if IsZaklAndDPHFilled('42','R42z','R42danP,R42danK') then
      CheckZaklxDPH('42','R42danP',[.R42z.],[.R42danP.]+[.R42danK.],TRUE);      //dle testovacího webu, je kontrola i na ř. 42, podle kontroly vypadá, že je to základní sazba, ale nepodložená (Eva - 30.1.2025)

    if IsZaklAndDPHFilled('43','R43z','R43danP,R43danK') then
      CheckZaklxDPH('43','R43danP',[.R43z.],[.R43danP.]+[.R43danK.],TRUE);
    chk('R43z',{([:R43z:]<>'') and} ([.R43z.]<>([.R03z.]+[.R05z.]+[.R07z.]+[.R09z.]+[.R10z.]+[.R12z.])),
      'Hodnota ř. 43 ve sl. Základ daně neodpovídá součtu řádků 3 + 5 + 7 + 9 + 10 + 12 ve sl. Základ daně.',1);

    if IsZaklAndDPHFilled('44','R44z','R44danP,R44danK') then
      CheckZaklxDPH('44','R44danP',[.R44z.],[.R44danP.]+[.R44danK.],False);
    chk('R44z',{([:R44z:]<>'') and} ([.R44z.]<>([.R04z.]+[.R06z.]+[.R08z.]+[.R11z.]+[.R13z.])),
      'Hodnota ř. 44 ve sl. Základ daně neodpovídá součtu řádků 4 + 6 + 8 + 11 + 13 ve sl. Základ daně.',1);    
  end;  
    
  if not [.UdajeOddC.] then begin 
    chk('R51NarokOdp',([:R51NarokOdp:]<>'') and ([.R51NarokOdp.]>([.R01z.]+[.R02z.]+[.R20.]+[.R21.]+[.R22.]+[.R23.]+[.R24.]+[.R25.]+[.R26.])),
      'Zadaná hodnota v ř.51 je vyšší než součet plnění.');
    chk('R51BezNarokOdp',([.R51BezNarokOdp.]>([.R50.])),
      'Zadaná hodnota v ř. 51 je vyšší než v ř. 50.');          
  end;  
  
  chk('R53Koef',([:R53Koef:]<>'') and (([:Mesic:]<>'12') and ([:Ctvrtleti:] <> '4')),
    ' Ř. 53 se vyplňuje pouze v posledním ZO v roce nebo při ukončení registrace.',1);  
  chk('R53',([:R53:]<>'') and (([:Mesic:]<>'12') and ([:Ctvrtleti:] <> '4')),
    ' Ř. 53 se vyplňuje pouze v posledním ZO v roce nebo při ukončení registrace.',1);    
    

  IncEPOPril_CheckPrilohy;
end; {Check}

function SysComment: string;
begin
  Result:='';
  if [.ckOpravne.] then begin
    if [.ckDodatecne.] then
      Result := 'opravné dodatečné'
    else
      Result := 'opravné';
  end
  else begin
    if [.ckDodatecne.] then
      Result := 'dodatečné'
    else
      Result := 'řádné';
  end;
end; {SysComment}

function Period: string;
begin
  if ([:ObdobiOd:] <> '') and ([:ObdobiDo:] <> '') then
    Result:=CalcPeriod([:ObdobiOd:]+','+[:ObdobiDo:])
  else if [:Mesic:]<>'' then
    if Length([:Mesic:])=1 then
      Result:=CalcPeriod([:Rok:]+',0'+[:Mesic:])
    else
      Result:=CalcPeriod([:Rok:]+','+[:Mesic:])
  else if [:Ctvrtleti:]<>'' then
    Result:=CalcPeriod([:Rok:]+','+[:Ctvrtleti:]+',Q')
  else
    Result:=CalcPeriod([:Rok:]);
end; {Period}

function Characteristics: string;
var obdobi: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  obdobi:=''; 
  //--- konec automaticke inicializace
  Result:='';
  obdobi:='';
  //Obdobi
  if ([:ObdobiOd:] <> '') and ([:ObdobiDo:] <> '') then
    obdobi:='od '+[:ObdobiOd:]+' do '+[:ObdobiDo:]
  else if [:Mesic:]<>'' then
    obdobi:=[:Rok:]+' '+StrPadLeft([:Mesic:],2,'0')+ '. měsíc'
  else if [:Ctvrtleti:]<>'' then
    obdobi:=[:Rok:]+' '+[:Ctvrtleti:]+'. čtvrtletí'
  else
    obdobi:=[:Rok:];
  //Klient
  if [.ckPO.] and ([:POObchJmeno:]<>'') then
    AddStrLine(Result,Format('Právnická osoba: %s', [[:POObchJmeno:]+' '+
      [:POObchJmeno1:]+' '+[:PODodatek:]]))
  else if [:FOPrijmeni:]<>'' then
    AddStrLine(Result,Format('Fyzická osoba: %s', [[:FOPrijmeni:]+' '+
      [:FOJmeno:]+' '+[:FOTitul:]]));
  if obdobi<>'' then
    AddStrLine(Result,Format('Období, typ: %s %s', [obdobi+' ',SysComment]));
  //Charakteristicke udaje
  if [.ckDodatecne.] then begin
    if [.R66.]<>0 then
    AddStrLine(Result,Format('Rozdíl oproti poslední daňové povinnosti (ř. 66) %s',
      [[:R66:]]));
  end
  // radne
  else if [.R65.]<>0 then
    AddStrLine(Result,Format('Nadměrný odpočet (ř. 65): %s',
      [[:R65:]]))
  else if [.R64.]<>0 then
    AddStrLine(Result,Format('Vlastní daňová povinnost (ř. 64): %s',
      [[:R64:]]));
  //El.podani
  if mtTskpFillingNumber.AsString<>'' then begin
    AddStrLine(Result,Format('Elektronicky podáno: %s',
      [mtTskpFillingDate.AsString]));
    AddStrLine(Result,Format('Na FÚ: %s', [[:UFO:]]));
    AddStrLine(Result,Format('Pod číslem: %s',
      [mtTskpFillingNumber.AsString]));
  end
  //datova schranka
  else if Pos('DS-filled',mtTskpFillingTimeStampSignature.AsString)>0 then begin
    AddStrLine(Result,Format('Elektronicky podáno: %s',[mtTskpFillingDate.AsString]));
    AddStrLine(Result,'Do datové schránky '+
    Replace('DS-filled:',mtTskpFillingTimeStampSignature.AsString,''));
  end;
end; {Characteristics}

procedure OnChangeExit_OKEC;
begin
  if not mtValues.ReadOnly then begin
    TryEditValuesRecord;
    [.OKEC.]:=NormOkec([.OKEC.]);
    if [.OKEC.]<>'' then
      [.HlavniCinnost.]:=VarToStr(LstLookup('OKEC',Date,
      'OKEC',[.OKEC.],'Nazev'));
    TryPostValuesRecord;
  end;
end;

procedure OnChangeExit_ZastKod;
begin
  if not mtValues.ReadOnly then begin
    TryEditValuesRecord;
    if ([:ZastKod:]<>'') and (not [.ZastFO.]) and (not [.ZastPO.]) then begin
      if ([:ZastKod:]='1') or ([:ZastKod:]='2') or ([:ZastKod:]='3') or
            ([:ZastKod:]='4a') or ([:ZastKod:]='4b') or ([:ZastKod:]='5a') or
            ([:ZastKod:]='5b') or ([:ZastKod:]='6a') or ([:ZastKod:]='6b') or
            ([:ZastKod:]='7a') or ([:ZastKod:]='7b') then begin
        [.ZastFO.] := TRUE;
        [.ZastPO.] := False;
      end
      else if [:ZastKod:]='4c' then begin
        [.ZastFO.] := False;
        [.ZastPO.] := TRUE;
      end;
    end;
    TryPostValuesRecord;
  end;
end;

procedure Lists;
var sKodZdanObd, Kod, OpravOsoba: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  sKodZdanObd:=''; Kod:=''; 
  //--- konec automaticke inicializace
  sKodZdanObd := 'Q,"zdaň. obdobím pro příslušný kalendářní rok bude kalendářní čtvrtletí (§ 99a odst. 1)";'+
                 'M,"zdaň. obdobím pro příslušný kalendářní rok bude kalendářní měsíc nebo již nesplňuje podmínky pro čtvrtletní zdaňovací období dle § 99a odst. 1.";';

  Kod:='1,"zákonný zástupce nebo opatrovník";'+
       '2,"ustanovený zástupce";'+
       '3,"společný zástupce, společný zmocněnec";'+
       '4a,"obecný zmocněnec – fyzická osoba i právnická osoba";'+
       '4b,"fyzická osoba daňový poradce nebo advokát";'+
       '4c,"právnická osoba vykonávající daňové poradenství";'+
       '5a,"osoba spravující pozůstalost";'+
       '5b,"zástupce osoby spravující pozůstalost";'+
       '6a,"dědic po skončení řízení o pozůstalosti";'+
       '6b,"zástupce dědice po skončení řízení o pozůstalosti";'+
       '7a,"právní nástupce právnické osoby";'+
       '7b,"zástupce právního nástupce právnické osoby"'; 
       
  OpravOsoba:='"Statutární orgán";'+
         '"Likvidátor";'+
         '"Prokurista"';        

  lst('CisFU','FU13',Date,'CisloFU','','CisloFU <= ''4000''' );
  
  if (AnsiUpperCase([:Stat:]) = '') or (AnsiUpperCase([:Stat:]) = 'ČR') or (AnsiUpperCase([:Stat:]) = 'CZ') or 
    (AnsiUpperCase([:Stat:]) = 'ČESKO') or (AnsiUpperCase([:Stat:]) = 'ČESKÁ REPUBLIKA') then begin
    lst('Obec,PSC','ObceFU',Date,'Obec,PSC');
    lst('PSC,Obec','ObceFU',Date,'PSC,Obec');    
  end;

  simplelst('KodZdanObd',sKodZdanObd,'35,800',0,'Kód zdaňovacího období následujícího roku','"Kód","Popis"');
  lst('OKEC','OKEC',Date,'OKEC');
  lst('Stat','KodyStatu',Date,'Nazev');
  simplelst('ZastKod',Kod,'30,280',0,'Kód zástupce','Kód, Popis');
  if not mtValues.ReadOnly then begin
    if GScriptFieldName='OKEC' then begin
      TryPostValuesRecord;
      TryEditValuesRecord;
      [.HlavniCinnost.]:='';
      OnChangeExit_OKEC;
    end;
  end;  
  
  if VyplnitOprOs then
    simplelst('OprOsPost',OpravOsoba,'90',0,'Vztah k právnické osobě','Vztah');
      
  simplelst('OprOsJm','proc SelectSpolOs');
  simplelst('SestJm','proc SelectSestav');
end;

procedure SelectSestav;
var
  s: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  s:=''; 
  //--- konec automaticke inicializace
  s:=SelectClientPerson;
  if s<>'' then begin
    TryEditValuesRecord;
    [:SestJm:]:=GetStringLineValue(s,'FirstName');
    [:SestPrijm:]:=GetStringLineValue(s,'LastName');
    [:SestTitul:]:=GetStringLineValue(s,'Prefix');
    [:SestTel:]:=CalcPhoneMobil(GetStringLineValue(s, 'Mobile'), GetStringLineValue(s, 'Phone'));
    TryPostValuesRecord;
  end;
end;

procedure SelectSpolOs;
var
  s: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  s:=''; 
  //--- konec automaticke inicializace
  s:=SelectClientPerson;
  if s<>'' then begin
    TryEditValuesRecord;
    [:OprOsJm:]:=GetStringLineValue(s,'FirstName');
    [:OprOsPrijm:]:=GetStringLineValue(s,'LastName');
    [:OprOsTitul:]:=GetStringLineValue(s,'Prefix');
    [:OprOsPost:]:=GetStringLineValue(s,'Relation');
    TryPostValuesRecord;
  end;
end;

//CalcVarSymProPlatbyDani
function CalcBUProPlatbyDani(AKod: boolean; APredcisli: boolean): string;
begin
  Result:=VarToStr(LstLookup('FU13', Date, 'CisloFU',CisFu2CUfo([:CisFU:]),'Matrika'));
  if APredcisli then
    Result:='705-'+Result;
  if AKod then
    Result:=Result+'/0710';
  if (Copy(Result, Pos('-',Result)+1,1)='/') or (Copy(Result, Pos('-',Result)+1,1)='') then begin
    Result:='';
  end;
end; {CalcBUProPlatbyDani}

procedure PaymentInfo;
var
  castkaKPlatbe: integer;
  BUPrijemce: string;

  payCnt, sentPayCnt, paidPayCnt, res: integer;
  generovatPlatby: boolean;
  msg: string;

begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  castkaKPlatbe:=0; 
  BUPrijemce:=''; 
  payCnt:=0; sentPayCnt:=0; paidPayCnt:=0; res:=0; 
  generovatPlatby:=False; 
  msg:=''; 
  //--- konec automaticke inicializace
  generovatPlatby:=True;
  if IsPaymentInDB(payCnt, sentPayCnt, paidPayCnt) then begin
    if paidPayCnt>0 then
      msg:='V platebním kalendáři jsou již uhrazené platby z tohoto formuláře. Chcete je přepsat?'+cCRLF+'(Ne - přidá nové záznamy)'
    else if sentPayCnt>0 then
      msg:='V platebním kalendáři jsou již platby z tohoto formuláře, na které byl klient upozorněn e-mailem. Chcete je přepsat?'+cCRLF+'(Ne - přidá nové záznamy)'
    else
      msg:='V platebním kalendáři jsou již platby z tohoto formuláře. Chcete je přepsat?'+cCRLF+'(Ne - přidá nové záznamy)';
    res:=MsgAskYesNoCancel(Caption, msg, MBNO);
    if res = IDYES then
      DelPaymentInDB
    else
      generovatPlatby := (res = IDNO);
  end;
  if generovatPlatby then begin
    castkaKPlatbe:=0;
    BUPrijemce:=CalcBUProPlatbyDani(False, True);

    if [.ckDodatecne.] then begin
      if [.R66.]>0 then
        castkaKPlatbe:=[.R66.];
    end
    else if [.R64.]>0 then
        castkaKPlatbe:=[.R64.];
    if castkaKPlatbe>0 then
      SavePaymentRec(Max(Date,[.Datum.]),'DPH '+GetListItem(Period,3),
        castkaKPlatbe, BUPrijemce,'0710','',
        Replace('CZ',Replace('-',Replace(' ',Replace('/',[:DIC:],''),''),''),''),'1148')
    else if MsgBoxAsk(Caption,'Není žádná částka k platbě, '+
                      'chcete přesto vložit záznam(y) do platebního kalendáře?',MB_YESNO)=IDYES then
      SavePaymentRec(Max(Date,[.Datum.]),'DPH '+GetListItem(Period,3),0);
  end;
end;

procedure PaymentOrder;
var
  castkaKPlatbe: integer;
  BUPrijemce: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  castkaKPlatbe:=0; 
  BUPrijemce:=''; 
  //--- konec automaticke inicializace
  castkaKPlatbe:=0;
  BUPrijemce:=CalcBUProPlatbyDani(True, True);

  if [.ckDodatecne.] then begin
    if [.R66.]>0 then
      castkaKPlatbe:=[.R66.];
  end
  else if [.R64.]>0 then
      castkaKPlatbe:=[.R64.];
  if castkaKPlatbe>0 then
    CreatePaymentOrder(Max(Date,[.Datum.]),castkaKPlatbe,BUPrijemce,
      Replace('CZ',Replace('-',Replace(' ',Replace('/',[:DIC:],''),''),''),''),
      '1148','','DPH '+GetListItem(Period,3))
  else
    MsgBoxInfo('','Není žádná částka k platbě.',MB_OK);
end;

procedure BeforePrint;
begin
  Gsl.Clear;
  Gsl.Values['Obdobi']:=DateToStr(GetObdobi);
end;

procedure SetMenuFunctions;
begin
  MenuFunction1.Caption:='Podání obecné písemnosti';
  MenuFunction1.Visible:=True;
  MenuFunction1.Enabled:=True;

  MenuFunction2.Caption:='Porovnat s formulářem Kontrolní hlášení';
  MenuFunction2.Visible:=True;
  MenuFunction2.Enabled:=True;

  MenuFunction3.Caption:='Porovnat s formulářem Souhrnné hlášení';
  MenuFunction3.Visible:=True;
  MenuFunction3.Enabled:=True;  
end;

function NaplDataProPodaniPisemnosti(AZadost: boolean): string;
var
  xData, cisloFU, fo, po: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  xData:=''; cisloFU:=''; fo:=''; po:=''; 
  //--- konec automaticke inicializace
  cisloFU:=[:CisFU:];
  if [.ckPO.] then begin
    fo:='False';
    po:='True';
  end
  else begin
    fo:='True';
    po:='False';
  end;

  xData:=
    'CkFU=True'+#13#10+ //nechat vzdy True
    'CisFU='+cisloFU+#13#10+ //nemenit
    'UFO='+[:UFO:]+#13#10+ //udaj nazev FU z formulare
    'C_Ufo='+[:C_Ufo:]+#13#10+ //cislo FU z formulare
    'FU='+[:FU:]+#13#10+ //udaj nazev uz. pracoviste FU z formulare
    'PodaniKDani='+'Daň z přidané hodnoty'+#13#10+ //'Daň z příjmů právnických osob', 'Daň z příjmů fyzických osob podávající přiznání' - musi byt presne tyto texty
    'Misto='+[:Obec:]+#13#10+ //misto podle udaje "v" z formulare
    'Datum='+DateToStr(date)+#13#10+ //nemenit

    //informace o danovem poplatnikovi
    'DICPredcis='+cisloFU+#13#10+ //nemenit
    'DICCislo='+[:DIC:]+#13#10+ //DIC z formulare
    'RodneCislo='+[:RodCis:]+#13#10+ //rodne cislo z formulare
    'FyzickaOsoba='+fo+#13#10+ //nemenit
    'PravnickaOsoba='+po+#13#10+ //nemenit
    //pro FO
    'Prijmeni='+[:FOPrijmeni:]+#13#10+
    'Jmeno='+[:FOJmeno:]+#13#10+
    //'RodnePrijmeni='+[:R08RodnePrijmeni:]+#13#10+
    'Titul='+[:FOTitul:]+#13#10+
    //pro PO
    'ObchJmPO='+[:POObchJmeno:]+' '+[:POObchJmeno1:]+#13#10+
    'DodatekObchJmPO='+[:PODodatek:]+#13#10+

    'Ulice='+[:Ulice:]+#13#10+
    'CisOrient='+[:CisloOrient:]+#13#10+
    'CisPop='+[:CisloPop:]+#13#10+
    'Obec='+[:Obec:]+#13#10+
    'PSC='+[:PSC:]+#13#10+
    //'Okres='+[::]+#13#10+
    'Stat='+[:Stat:]+#13#10+
    'Telefon='+[:Telefon:]+#13#10+
    //'Fax='+[:R13gFax:]+#13#10+
    //'Email='+[::]+#13#10+

    {'BuPredcisli1='+ExtractBeforeChar(ExtractBankAccount([:R14BankUcet:]),'-')+#13#10+
    'BuCislo1='+ExtractAfterChar(ExtractBankAccount([:R14BankUcet:]),'-')+#13#10+
    'BuKod1='+ExtractBankCode([:R14BankUcet:])+#13#10+
    'BuPredcisli2='+ExtractBeforeChar(ExtractBankAccount([:R14BankUcet1:]),'-')+#13#10+
    'BuCislo2='+ExtractAfterChar(ExtractBankAccount([:R14BankUcet1:]),'-')+#13#10+
    'BuKod2='+ExtractBankCode([:R14BankUcet1:])+#13#10+}
    //zastupce
    'ZastKod='+[:ZastKod:]+#13#10+
    'ZastFO='+BoolToStr([.ZastFO.])+#13#10+
    'ZastPO='+BoolToStr([.ZastPO.])+#13#10+
    'ZastJm='+[:ZastJm:]+#13#10+
    'ZastPrijm='+[:ZastPrijm:]+#13#10+
    'ZastTitul='+[:ZastTitul:]+#13#10+
    'ZastEvCislo='+[:ZastEvCislo:]+#13#10+
    'ZastDatNar='+[:ZastDatNar:]+#13#10+
    'ZastIC='+[:ZastIC:]+#13#10+
    'ZastNazPO='+[:ZastNazPO:]+#13#10+
    //opravnena osoba
    'JmenoOprOs='+[:OprOsJm:]+#13#10+
    'PrijmeniOprOs='+[:OprOsPrijm:]+#13#10+
    'TitulOprOs='+[:OprOsTitul:]+#13#10+
    'PostaveniOprOs='+[:OprOsPost:]+#13#10+
    //sestavil
    'JmenoSestavil='+[:SestJm:]+#13#10+
    'PrijmeniSestavil='+[:SestPrijm:]+#13#10+
    'TitulSestavil='+[:SestTitul:]+#13#10+
    'TelefonSestavil='+[:SestTel:]+#13#10;

  if AZadost then
    xdata:=xData+
    'Vec='+'ŽÁDOST O VRÁCENÍ PŘEPLATKU, ZÁKON Č. 280/2009 § 155 ODST. 2'+#13#10
  else
    xdata:=xData+
    'Vec='+'OBECNÁ ELEKTRONICKÁ PÍSEMNOST BEZ URČENÍ TYPU'+#13#10;

  Result:=xData;
end;

procedure OnClick_MenuFunction1;
var
  inData, obdobi: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  inData:=''; obdobi:=''; 
  //--- konec automaticke inicializace
  obdobi:='';
  if ([:ObdobiOd:] <> '') and ([:ObdobiDo:] <> '') then
    obdobi:='od '+[:ObdobiOd:]+' do '+[:ObdobiDo:]
  else if [:Mesic:]<>'' then
    obdobi:=[:Rok:]+' '+StrPadLeft([:Mesic:],2,'0')+ '. měsíc'
  else if [:Ctvrtleti:]<>'' then
    obdobi:=[:Rok:]+' '+[:Ctvrtleti:]+'. čtvrtletí'
  else
    obdobi:=[:Rok:];

  inData:=NaplDataProPodaniPisemnosti(FALSE);
  inData:=inData+
    'TextPisemnosti='+
      'Vážení,˙#˙#na základě přiznání k dani '+// nechat
      'z přidané hodnoty'+' '+ //upravit
      'za období '+ // nechat nebo zmenit na obdobi
      obdobi+' ';

  if MsgBoxAsk(Caption, 'Chcete vytvořit podání obecné písemnosti?', MB_YESNO)=IDYES then
    CreateOpenNewForm('ns_13ObecnaPisemnost', inData);
end;

function LoadSumTskpVyporadani: boolean;
var lastFormList: TStringList;
  i: integer;
  pR01z,pR02z,pR20,pR21,pR22,pR23,pR24,pR25,pR26,pR31,pR46danK,pR50,pR51NarokOdp,pR51BezNarokOdp,pR52: integer;
  sl: TStringList;                                 //380K,510,520,530,540,550
  s: string;                                       // 47K, 25,51s, 50,51b, 52
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  i:=0; 
  pR01z:=0; pR02z:=0; pR20:=0; pR21:=0; pR22:=0; pR23:=0; pR24:=0; pR25:=0; pR26:=0; pR31:=0; pR46danK:=0; pR50:=0; pR51NarokOdp:=0; pR51BezNarokOdp:=0; pR52:=0; 
  s:=''; 
  //--- konec automaticke inicializace
  Result:=FALSE;
  if MsgBoxAsk(Caption,
    'Chcete vybrat formuláře dřívějších daňových přiznání pro výpočet vypořádání daně na vstupu?',
    MB_YESNO)=IDYES then begin
    lastFormList:=TStringList.Create;
    mtValues.Edit;
    [.VR01z.]:=0; [.VR02z.]:=0;
    [.VR20.]:=0; [.VR21.]:=0; [.VR22.]:=0; [.VR23.]:=0; [.VR24.]:=0; [.VR25.]:=0; [.VR26.]:=0;
    [.VR31.]:=0; [.VR46danK.]:=0;
    [.VR50.]:=0; [.VR51NarokOdp.]:=0; [.VR51BezNarokOdp.]:=0; [.VR52.]:=0;
    sl:= TStringList.Create;
    try
      lastFormList.Text:=GetForms('dz_15DPH5401_19,dz_21DPH5401_22,dz_21DPH5401_23,dz_23DPH5401_24,dz_25DPH5401_25',TRUE,
        'Vyberte dřívější přiznání k DPH');
      if lastFormList.Count>0 then begin
        Result:=TRUE;
        sl.Add('Protokol o výpočtu vypořádání odpočtu daně ('+DateTimeToStr(Now)+')');
        sl.Add('');
        sl.Add('Období, ř.1[ZD], ř.2[ZD], ř.20, ř.21, ř.22, ř.23, ř.24, ř.25, ř.26, ř.31, ř.46[KO], ř.50, ř.51[s NO], ř.51[bez NO], ř.52[Odp] ');
        sl.Add('Vybraná přiznání:');
        //nascitat hodnoty z tiskopisu za drivejsi obdobi
        for i:=0 to lastFormList.Count-1 do begin
          pR01z:=StrToFloatSafe(GetFormField(lastFormList[i],'R01z'));
          pR02z:=StrToFloatSafe(GetFormField(lastFormList[i],'R02z'));
          pR20:=StrToFloatSafe(GetFormField(lastFormList[i],'R20'));
          pR21:=StrToFloatSafe(GetFormField(lastFormList[i],'R21'));
          pR22:=StrToFloatSafe(GetFormField(lastFormList[i],'R22'));
          pR23:=StrToFloatSafe(GetFormField(lastFormList[i],'R23'));
          pR24:=StrToFloatSafe(GetFormField(lastFormList[i],'R24'));
          pR25:=StrToFloatSafe(GetFormField(lastFormList[i],'R25'));
          pR26:=StrToFloatSafe(GetFormField(lastFormList[i],'R26'));
          pR31:=StrToFloatSafe(GetFormField(lastFormList[i],'R31'));
          pR46danK:=StrToFloatSafe(GetFormField(lastFormList[i],'R46danK'));
          pR50:=StrToFloatSafe(GetFormField(lastFormList[i],'R50'));
          pR51NarokOdp:=StrToFloatSafe(GetFormField(lastFormList[i],'R51NarokOdp'));
          pR51BezNarokOdp:=StrToFloatSafe(GetFormField(lastFormList[i],'R51BezNarokOdp'));
          pR52:=StrToFloatSafe(GetFormField(lastFormList[i],'R52'));

          [.VR01z.]:=[.VR01z.]+pR01z;
          [.VR02z.]:=[.VR02z.]+pR02z;
          [.VR20.]:=[.VR20.]+pR20;
          [.VR21.]:=[.VR21.]+pR21;
          [.VR22.]:=[.VR22.]+pR22;
          [.VR23.]:=[.VR23.]+pR23;
          [.VR24.]:=[.VR24.]+pR24;
          [.VR25.]:=[.VR25.]+pR25;
          [.VR26.]:=[.VR26.]+pR26;
          [.VR31.]:=[.VR31.]+pR31;
          [.VR46danK.]:=[.VR46danK.]+pR46danK;
          [.VR50.]:=[.VR50.]+pR50;
          [.VR51NarokOdp.]:=[.VR51NarokOdp.]+pR51NarokOdp;
          [.VR51BezNarokOdp.]:=[.VR51BezNarokOdp.]+pR51BezNarokOdp;
          [.VR52.]:=[.VR52.]+pR52;

          if (GetFormField(lastFormList[i],'ObdobiOd') <> '') and (GetFormField(lastFormList[i],'ObdobiDo') <> '') then
            s:='od '+GetFormField(lastFormList[i],'ObdobiOd')+' do '+GetFormField(lastFormList[i],'ObdobiDo')
          else if GetFormField(lastFormList[i],'Mesic')<>'' then
            s:=GetFormField(lastFormList[i],'Mesic')+'/'+
              GetFormField(lastFormList[i],'Rok')
          else
            s:=GetFormField(lastFormList[i],'Ctvrtleti')+'Q/'+
              GetFormField(lastFormList[i],'Rok');
          sl.Add(s+': '+FloatToStr(pR01z)+', '+FloatToStr(pR02z)+', '+FloatToStr(pR20)+', '+
            FloatToStr(pR21)+', '+FloatToStr(pR22)+', '+FloatToStr(pR23)+', '+FloatToStr(pR24)+', '+
            FloatToStr(pR25)+', '+FloatToStr(pR26)+', '+FloatToStr(pR31)+', '+FloatToStr(pR46danK)+', '+
            FloatToStr(pR50)+', '+FloatToStr(pR51NarokOdp)+', '+
            FloatToStr(pR51BezNarokOdp)+', '+FloatToStr(pR52));
        end;
        if ([:ObdobiOd:] <> '') and ([:ObdobiDo:] <> '') then
          s:='od '+[:ObdobiOd:]+' do '+[:ObdobiDo:]
        else if [:Ctvrtleti:]<>'' then
          s:=[:Ctvrtleti:]+'Q/'+[:Rok:]
        else
          s:=[:Mesic:]+'/'+[:Rok:];;
        sl.Add('Zpracovávané přiznání:');
        sl.Add(s+': '+FloatToStr([.R01z.])+', '+FloatToStr([.R02z.])+', '+FloatToStr([.R20.])+', '+
          FloatToStr([.R21.])+', '+FloatToStr([.R22.])+', '+FloatToStr([.R23.])+', '+FloatToStr([.R24.])+', '+
          FloatToStr([.R25.])+', '+FloatToStr([.R26.])+', '+FloatToStr([.R31.])+', '+FloatToStr([.R46danK.])+', '+
          FloatToStr([.R50.])+', '+FloatToStr([.R51NarokOdp.])+', '+
          FloatToStr([.R51BezNarokOdp.])+', '+FloatToStr([.R52.]));
        sl.Add('Celkem:');
        sl.Add('Součet'+': '+FloatToStr([.VR01z.]+[.R01z.])+', '+FloatToStr([.VR02z.]+[.R02z.])+', '+
          FloatToStr([.VR20.]+[.R20.])+', '+FloatToStr([.VR21.]+[.R21.])+', '+FloatToStr([.VR22.]+[.R22.])+', '+
          FloatToStr([.VR23.]+[.R23.])+', '+FloatToStr([.VR24.]+[.R24.])+', '+FloatToStr([.VR25.]+[.R25.])+', '+
          FloatToStr([.VR26.]+[.R26.])+', '+FloatToStr([.VR31.]+[.R31.])+', '+FloatToStr([.VR46danK.]+[.R46danK.])+', '+
          FloatToStr([.VR50.]+[.R50.])+', '+FloatToStr([.VR51NarokOdp.]+[.R51NarokOdp.])+', '+
          FloatToStr([.VR51BezNarokOdp.]+[.R51BezNarokOdp.])+', '+FloatToStr([.VR52.]+[.R52.]));
        [.fcbPocitatVyporadani.]:=TRUE;
      end;
      Enable;
      mtValues.Edit;
      Calculate;
      if lastFormList.Count>0 then begin
        sl.Add('');
        sl.Add('Vypořádací koeficient ř.53: '+[:R53koef:]);
        sl.Add('  vypočeten jako: (součet ř.1[ZD] + součet ř.2[ZD] + součet ř.20 až ř.26 + součet ř.31 - součet ř.51[s NO]) '+
               '/ (součet ř.1[ZD] + součet ř.2[ZD] + součet ř.20 až ř.26 + součet ř.31 - součet ř.51[s NO] '+
               '+ součet ř.50 - součet ř.51[bez NO])');
        sl.Add('  za podmínek §76 odst. 4 zákona o DPH');
        sl.Add('Odpočet ř.53: '+[:R53:]);
        sl.Add('  vypočeten jako: (součet ř.46[KO] * koeficinet v ř. 53) - součet ř.52[Odp]');
        sl.Add('');
        sl.Add('Použité zkratky: ZD - základ daně, KO - krácený odpočet, '+
               's NO - s nárokem na odpočet, bez NO - bez nároku na odpočet, Odp - odpočet');
        if MsgBoxAsk(Caption,
          'Chcete uložit protokol o výpočtu vypořádání do poznámek?',
          MB_YESNO)=IDYES then begin
          if mtTskp.State = dsBrowse then
            mtTskp.Edit;
          if mtTskpNotes.Value = '' then
            mtTskpNotes.Value:=sl.Text
          else
            mtTskpNotes.Value:=GetNotesString+cCRLF+cCRLF+sl.Text;
          mtTskp.Post;
        end;
      end;
      finally
      lastFormList.Free;
      sl.Free;
    end;
  end;
end;{LoadSumTskpVyporadani}

procedure OnClick_btVyporadani;
begin
  LoadSumTskpVyporadani;
end; {OnClick_btVyporadani}

procedure PorovnejRozdilKH(ADPHVal, AKHVal: double;
                           var ARozdil: double; var ADPHText: string; var AKHText: string;                          
                           ASl: TStringList); 
var
  roz: double;                           
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  roz:=0.0; 
  //--- konec automaticke inicializace         
  roz := AKHVal-ADPHVal;
  if Abs(roz) > Abs(ARozdil) then begin
    ARozdil := roz;
    ADPHText := ASl[ASl.Count-3]; 
    AKHText := ASl[ASl.Count-2];
  end;    
end;

function CompareWithKH: boolean;
var formListKH, formListDPH: TStringList;
  i, cntDPH: integer;
  pR1,pR2,pR40,pR41,pR25,pR10,pR11,pR3_13: double;
  r1, r2, r40, r41 ,r25, r10, r11, r3_13: double;   
  rozdil: double;
  sl: TStringList;
  dphText, khText: string;
const
  coZahlavi = 'Výsledek kontroly porovnání %s přiznání a %s hlášení ze dne %s:';
  coRozdil = 'Rozdíl: %s';
  coNejRozdil = 'Největší rozdíl: %s';
  coDPH = 'DPH (ř.%s): %s';
  coR3_13DPH = 'DPH (součet řádků 3+4+5+6+9+12+13): %s';
  coR1KH = 'KH (A.4.+A.5. základ daně u základní sazby DPH): %s';
  coR2KH = 'KH (A.4.+A.5. základ daně u snížené sazby DPH): %s';
  coR40KH = 'KH (B.2.+B.3. základ daně u základní sazby DPH): %s';
  coR41KH = 'KH (B.2.+B.3. základ daně u snížené sazby DPH): %s';
  coR25KH = 'KH (A.1. základ daně): %s';
  coR10KH = 'KH (B.1. základ daně u základní sazby DPH): %s';
  coR11KH = 'KH (B.1. základ daně u snížené sazby DPH): %s';
  coR3_13KH = 'KH (A.2. celkem základy daně): %s';    
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  i:=0; cntDPH:=0; 
  pR1:=0.0; pR2:=0.0; pR40:=0.0; pR41:=0.0; pR25:=0.0; pR10:=0.0; pR11:=0.0; pR3_13:=0.0; 
  r1:=0.0; r2:=0.0; r40:=0.0; r41:=0.0; r25:=0.0; r10:=0.0; r11:=0.0; r3_13:=0.0; 
  rozdil:=0.0; 
  dphText:=''; khText:=''; 
  //--- konec automaticke inicializace
  Result:=FALSE; 
  {24.11.2020 (Marek) - odstraneno dle nametu #3873
  if MsgBoxAsk(Caption,
    'Chcete vybrat formulář(e) Kontrolního hlášení pro porovnání?',
    MB_YESNO)=IDYES then begin}
    formListKH:=TStringList.Create; 
    formListDPH := TStringList.Create;
    sl:= TStringList.Create;
    pR1:=0;pR2:=0;pR40:=0;pR41:=0;pR25:=0;pR10:=0;pR11:=0;pR3_13:=0;
    try
      sl.Text:=GetForms('dz_16DPHKH,dz_21DPHKH,dz_24DPHKH5564_2,dz_15DPH5401_19,dz_21DPH5401_22,dz_21DPH5401_23,dz_23DPH5401_24,dz_25DPH5401_25',TRUE,
        'Vyberte formulář(e) Kontrolního hlášení a Přiznání k dani z přidané hodnoty');   
      for i := 0 to sl.Count-1 do begin
        if Copy(GetStringLineValue(GetSection(GetFormDataText(sl[i]),'[FormHead]'), 'DefID'),6,5) = 'DPHKH' then
          formListKH.Add(sl[i])
        else
          formListDPH.Add(sl[i]);          
      end;  
      //
      if formListKH.Count>0 then begin
        if (formListKH.Count>3) and
           (MsgBoxWarn(Caption, 'Vybrali jste víc jak 3 formuláře Kontrolního hlášení,'+cCRLF+
           'chcete skutečně pokračovat?',
           MB_YESNO)=IDNo) then
          Exit;
        //
        Result:=TRUE;
        //
        cntDPH := 0;
        r1:=[.R01z.]; r2:=[.R02z.]; r40:=[.R40z.]; r41:=[.R41z.]; r25:=[.R25.]; r10:=[.R10z.]; r11:=[.R11z.];
        r3_13:=[.R03z.]+[.R04z.]+[.R05z.]+[.R06z.]+[.R09z.]+[.R12z.]+[.R13z.];
        //
        cntDPH := formListDPH.Count;
        if formListDPH.Count>0 then begin
          for i:=0 to formListDPH.Count-1 do begin
            r1:=r1+StrToFloatSafe(GetFormField(formListDPH[i],'R01z'));
            r2:=r2+StrToFloatSafe(GetFormField(formListDPH[i],'R02z'));
            r40:=r40+StrToFloatSafe(GetFormField(formListDPH[i],'R40z'));
            r41:=r41+StrToFloatSafe(GetFormField(formListDPH[i],'R41z'));
            r25:=r25+StrToFloatSafe(GetFormField(formListDPH[i],'R25'));
            r10:=r10+StrToFloatSafe(GetFormField(formListDPH[i],'R10z'));
            r11:=r11+StrToFloatSafe(GetFormField(formListDPH[i],'R11z'));
            r3_13:=r3_13+StrToFloatSafe(GetFormField(formListDPH[i],'R03z'))+
                  StrToFloatSafe(GetFormField(formListDPH[i],'R04z'))+
                  StrToFloatSafe(GetFormField(formListDPH[i],'R05z'))+
                  StrToFloatSafe(GetFormField(formListDPH[i],'R06z'))+
                  StrToFloatSafe(GetFormField(formListDPH[i],'R09z'))+
                  StrToFloatSafe(GetFormField(formListDPH[i],'R12z'))+
                  StrToFloatSafe(GetFormField(formListDPH[i],'R13z'));
          end;
        end;
        //
        for i:=0 to formListKH.Count-1 do begin
          pR1:=pR1+StrToFloatSafe(GetFormField(formListKH[i],'CZaklDan1'));
          pR2:=pR2+StrToFloatSafe(GetFormField(formListKH[i],'CZaklDan2'));
          pR40:=pR40+StrToFloatSafe(GetFormField(formListKH[i],'CZaklDan3'));
          pR41:=pR41+StrToFloatSafe(GetFormField(formListKH[i],'CZaklDan4'));
          pR25:=pR25+StrToFloatSafe(GetFormField(formListKH[i],'CZaklDan5'));
          pR10:=pR10+StrToFloatSafe(GetFormField(formListKH[i],'CZaklDan6'));
          pR11:=pR11+StrToFloatSafe(GetFormField(formListKH[i],'CZaklDan7'));
          pR3_13:=pR3_13+StrToFloatSafe(GetFormField(formListKH[i],'CZaklDan8'));
        end;
        // 
        sl.Clear; 
        rozdil:=0;     
        dphText:=''; khText:='';
        sl.Add(Format(coZahlavi,[Cond(cntDPH>0, 'daňových', 'daňového'),
         Cond(formListKH.Count>1, 'kontrolních', 'kontrolního'), DateTimeToStr(Now)]));
        sl.Add('');

        sl.Add(Format(coDPH, ['1', FormatFloat(',0.00',r1)]));
        sl.Add(Format(coR1KH, [FormatFloat(',0.00',pR1)]));
        sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR1-r1)]));  
        PorovnejRozdilKH(r1, pR1, rozdil, dphText, khText, sl);
        sl.Add('');

        sl.Add(Format(coDPH, ['2', FormatFloat(',0.00',r2)]));
        sl.Add(Format(coR2KH, [FormatFloat(',0.00',pR2)]));
        sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR2-r2)]));        
        PorovnejRozdilKH(r2, pR2, rozdil, dphText, khText, sl);
        sl.Add('');

        sl.Add(Format(coDPH, ['40', FormatFloat(',0.00',r40)]));
        sl.Add(Format(coR40KH, [FormatFloat(',0.00',pR40)]));
        sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR40-r40)])); 
        PorovnejRozdilKH(r40, pR40, rozdil, dphText, khText, sl);
        sl.Add('');

        sl.Add(Format(coDPH, ['41', FormatFloat(',0.00',r41)]));
        sl.Add(Format(coR41KH, [FormatFloat(',0.00',pR41)]));
        sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR41-r41)]));      
        PorovnejRozdilKH(r41, pR41, rozdil, dphText, khText, sl);
        sl.Add('');

        sl.Add(Format(coDPH, ['25', FormatFloat(',0.00',r25)]));
        sl.Add(Format(coR25KH, [FormatFloat(',0.00',pR25)]));
        sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR25-r25)]));      
        PorovnejRozdilKH(r25, pR25, rozdil, dphText, khText, sl);
        sl.Add('');

        sl.Add(Format(coDPH, ['10', FormatFloat(',0.00',r10)]));
        sl.Add(Format(coR10KH, [FormatFloat(',0.00',pR10)]));
        sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR10-r10)]));      
        PorovnejRozdilKH(r10, pR10, rozdil, dphText, khText, sl);
        sl.Add('');

        sl.Add(Format(coDPH, ['11', FormatFloat(',0.00',r11)]));
        sl.Add(Format(coR11KH, [FormatFloat(',0.00',pR11)]));
        sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR11-r11)]));      
        PorovnejRozdilKH(r11, pR11, rozdil, dphText, khText, sl);
        sl.Add('');

        sl.Add(Format(coR3_13DPH, [FormatFloat(',0.00',r3_13)]));
        sl.Add(Format(coR3_13KH, [FormatFloat(',0.00',pR3_13)]));
        sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR3_13-r3_13)]));  
        PorovnejRozdilKH(r3_13, pR3_13, rozdil, dphText, khText, sl);
        //
        if Abs(rozdil) > 0 then begin
          sl.Add('');
          sl.Add('-------------------------------------------------------------');        
          sl.Add(Format(coNejRozdil, [FormatFloat(',0.00',rozdil)]));
          sl.Add(dphText);
          sl.Add(khText);          
        end;
        //
        if MsgBoxAsk(Caption, sl.Text+cCRLF+cCRLF+
          'Chcete uložit výsledek kontroly porovnání do poznámek?',
          MB_YESNO)=IDYES then begin
          if mtTskp.State = dsBrowse then
            mtTskp.Edit;
          if mtTskpNotes.Value = '' then
            mtTskpNotes.Value:=sl.Text
          else
            mtTskpNotes.Value:=GetNotesString+cCRLF+cCRLF+sl.Text;
          mtTskp.Post;
        end;
      end;
    finally
      formListKH.Free;  
      formListDPH.Free;
      sl.Free;
    end;
  //end;
end;

procedure OnClick_MenuFunction2;
begin
  CompareWithKH;
end;

procedure OnClick_btCompareWithKH;
begin
  OnClick_MenuFunction2;
end;

procedure PorovnejRozdilSH(ADPHVal, ASHVal: double;
                           var ARozdil: double; var ADPHText: string; var ASHText: string;                          
                           ASl: TStringList); 
var
  roz: double;                           
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  roz:=0.0; 
  //--- konec automaticke inicializace         
  roz := ASHVal-ADPHVal;
  if Abs(roz) > Abs(ARozdil) then begin
    ARozdil := roz;
    ADPHText := ASl[ASl.Count-3]; 
    ASHText := ASl[ASl.Count-2];
  end;    
end;

function CompareWithSH: boolean;
var 
  formListSH, formListDPH: TStringList;
  data, guid: string;
  i, cntDPH, j, cnt, k: integer;
  pR20,pR21,pR31: double;
  r20, r21, r31: double;   
  rozdil: double;
  sl: TStringList;
  dphText, shText: string;  
  nstBoxValue, nstBoxDataValue: string;
  zn: integer;
const
  coZahlavi = 'Výsledek kontroly porovnání %s přiznání a %s hlášení ze dne %s:';
  coRozdil = 'Rozdíl: %s';
  coNejRozdil = 'Největší rozdíl: %s';
  coDPH = 'DPH (ř.%s): %s';
  coSH01 = 'SH (B. Oddíl, Kódy plnění 0 a 1): %s';
  coSH2 = 'SH (B. Oddíl, Kód plnění 2): %s';
  coSH3 = 'SH (B. Oddíl, Kód plnění 3): %s';   
  a = 25;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  data:=''; guid:=''; 
  i:=0; cntDPH:=0; j:=0; cnt:=0; k:=0; 
  pR20:=0.0; pR21:=0.0; pR31:=0.0; 
  r20:=0.0; r21:=0.0; r31:=0.0; 
  rozdil:=0.0; 
  dphText:=''; shText:=''; 
  nstBoxValue:=''; nstBoxDataValue:='';
  zn:=0;
  //--- konec automaticke inicializace
  Result:=FALSE; 
  //
  formListSH:=TStringList.Create; 
  formListDPH := TStringList.Create;
  sl:= TStringList.Create;
  pR20:=0;pR21:=0;pR31:=0;
  try    
    sl.Text:=GetForms('dz_21DPH5521,dz_10DPH5521,dz_15DPH5401_19,dz_21DPH5401_22,dz_21DPH5401_23,dz_23DPH5401_24,dz_25DPH5401_25',TRUE,
      'Vyberte formulář(e) Souhrnného hlášení a Přiznání k dani z přidané hodnoty');     
    for i := 0 to sl.Count-1 do begin
      if Copy(GetStringLineValue(GetSection(GetFormDataText(sl[i]),'[FormHead]'), 'DefID'),6,7) = 'DPH5521' then
        formListSH.Add(sl[i])
      else
        formListDPH.Add(sl[i]);          
    end;  
    //
    if formListSH.Count>0 then begin
      if (formListSH.Count>3) and
         (MsgBoxWarn(Caption, 'Vybrali jste víc jak 3 formuláře Souhrnného hlášení,'+cCRLF+
         'chcete skutečně pokračovat?',
         MB_YESNO)=IDNo) then
        Exit;
      //
      Result:=TRUE;
      //
      cntDPH := 0;
      r20:=[.R20.]; r21:=[.R21.]; r31:=[.R31.];
      //
      cntDPH := formListDPH.Count;
      if formListDPH.Count>0 then begin
        for i:=0 to formListDPH.Count-1 do begin
          r20:=r20+StrToFloatSafe(GetFormField(formListDPH[i],'R20'));
          r21:=r21+StrToFloatSafe(GetFormField(formListDPH[i],'R21'));
          r31:=r31+StrToFloatSafe(GetFormField(formListDPH[i],'R31'));
        end;
      end;
      //
      for i:=0 to formListSH.Count-1 do begin   
        //data hlavniho formulare v SH
        data := GetFormDataText(formListSH[i]); 
        for j := 1 to 40 do begin 
          zn := 1;
          if StrToBoolSafe(GetFormField(data,'Storno'+IntToStr(j))) then
            zn := -1;     
          if (SameText(GetFormField(data,'KodPln'+IntToStr(j)), '0')) or 
             (SameText(GetFormField(data,'KodPln'+IntToStr(j)), '1')) then           
            pR20:=pR20+(StrToFloatSafe(GetFormField(data,'Hodnota'+IntToStr(j)))*zn)  
          else if (SameText(GetFormField(data,'KodPln'+IntToStr(j)), '3')) then           
            pR21:=pR21+(StrToFloatSafe(GetFormField(data,'Hodnota'+IntToStr(j)))*zn)            
          else if (SameText(GetFormField(data,'KodPln'+IntToStr(j)), '2')) then           
            pR31:=pR31+(StrToFloatSafe(GetFormField(data,'Hodnota'+IntToStr(j)))*zn);                        
        end; 
        //data vlozenych formularu v SH
        nstBoxValue := Replace(cCRLFalternate,GetFormField(GetFormDataText(formListSH[i]), 'PR'),cCRLF);
        nstBoxDataValue := Replace(cCRLFalternate,GetFormField(GetFormDataText(formListSH[i]), 'PRData'),cCRLF);         
        cnt:=GetStringLinesCount(nstBoxValue);
        if cnt>0 then begin
          for k:=0 to cnt-1 do begin
            guid:=Copy(GetStringLine(nstBoxValue,k),128+1,80);
            data:=GetNestedSection(nstBoxDataValue,guid);
            //
            for j := 1 to 40 do begin   
              zn := 1;
              if StrToBoolSafe(GetFormField(data,'Storno'+IntToStr(j))) then
                zn := -1;               
              if (SameText(GetFormField(data,'KodPln'+IntToStr(j)), '0')) or 
                 (SameText(GetFormField(data,'KodPln'+IntToStr(j)), '1')) then           
                pR20:=pR20+(StrToFloatSafe(GetFormField(data,'Hodnota'+IntToStr(j)))*zn)  
              else if (SameText(GetFormField(data,'KodPln'+IntToStr(j)), '3')) then           
                pR21:=pR21+(StrToFloatSafe(GetFormField(data,'Hodnota'+IntToStr(j)))*zn)            
              else if (SameText(GetFormField(data,'KodPln'+IntToStr(j)), '2')) then           
                pR31:=pR31+(StrToFloatSafe(GetFormField(data,'Hodnota'+IntToStr(j)))*zn);                        
            end; 
          end;
        end;        
      end;     
      // 
      sl.Clear; 
      rozdil:=0;     
      dphText:=''; shText:='';
      sl.Add(Format(coZahlavi,[Cond(cntDPH>0, 'daňových', 'daňového'),
       Cond(formListSH.Count>1, 'souhrnných', 'souhrnného'), DateTimeToStr(Now)]));
      sl.Add('');

      sl.Add(Format(coDPH, ['20', FormatFloat(',0.00',r20)]));
      sl.Add(Format(coSH01, [FormatFloat(',0.00',pR20)]));
      sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR20-r20)]));  
      PorovnejRozdilSH(r20, pR20, rozdil, dphText, shText, sl);
      sl.Add('');

      sl.Add(Format(coDPH, ['21', FormatFloat(',0.00',r21)]));
      sl.Add(Format(coSH3, [FormatFloat(',0.00',pR21)]));
      sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR21-r21)]));        
      PorovnejRozdilSH(r21, pR21, rozdil, dphText, shText, sl);
      sl.Add('');

      sl.Add(Format(coDPH, ['31', FormatFloat(',0.00',r31)]));
      sl.Add(Format(coSH2, [FormatFloat(',0.00',pR31)]));
      sl.Add(Format(coRozdil, [FormatFloat(',0.00',pR31-r31)])); 
      PorovnejRozdilSH(r31, pR31, rozdil, dphText, shText, sl);
      //
      if Abs(rozdil) > 0 then begin
        sl.Add('');
        sl.Add('-------------------------------------------------------------');        
        sl.Add(Format(coNejRozdil, [FormatFloat(',0.00',rozdil)]));
        sl.Add(dphText);
        sl.Add(shText);          
      end;
      //
      if MsgBoxAsk(Caption, sl.Text+cCRLF+cCRLF+
        'Chcete uložit výsledek kontroly porovnání do poznámek?',
        MB_YESNO)=IDYES then begin
        if mtTskp.State = dsBrowse then
          mtTskp.Edit;
        if mtTskpNotes.Value = '' then
          mtTskpNotes.Value:=sl.Text
        else
          mtTskpNotes.Value:=GetNotesString+cCRLF+cCRLF+sl.Text;
        mtTskp.Post;
      end;
    end;
  finally
    formListSH.Free;  
    formListDPH.Free;
    sl.Free;
  end;
end;

procedure OnClick_MenuFunction3;
begin
  CompareWithSH;
end;

procedure OnClick_wlbPocitatVyporadani;
begin
  ShowInstruction('wlbPocitatVyporadani');
end;
////////////////////////////////
//Filling - EPO
///////////////////////////////
procedure AddStrValue(var ADoc: string; AKey, AValue: string);
begin
  if AValue<>'' then begin
    AValue:=Replace('&',AValue,'&amp;');
    AValue:=Replace('<',AValue,'&lt;');
    AValue:=Replace('>',AValue,'&gt;');
    AValue:=Replace('''',AValue,'&apos;');
    AValue:=Replace('"',AValue,'&quot;');
    AddStrLine(ADoc,AKey+'="'+StrTrimCharRight(AValue,' ')+'"');
  end;
end;

procedure AddFloatStrValue(var ADoc: string; AKey, AValue: string);
begin
  if AValue<>'' then begin
    AddStrLine(ADoc,AKey+'="'+Replace(DecimalSeparator,AValue,'.')+'"');
  end;
end;

procedure VetaR_TextPril(var ADoc: string; AText, AKodSekce: string);
  var
    r: string;
    sl: TStringList;
    i,j,k,poslPozice,poslMezera: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  r:=''; 
  i:=0; j:=0; k:=0; poslPozice:=0; poslMezera:=0; 
  //--- konec automaticke inicializace
  sl:= TStringList.Create;
  try
    sl.Text:=AText;
    k:=1;
    for i:=0 to sl.Count-1 do begin
      if Length(sl[i])>71 then begin
        r:=sl[i];
        poslMezera:=0;
        poslPozice:=0;
        j:=1;
        while j<=Length(r) do begin
          if Copy(r,j,1)=' ' then
            poslMezera:=j;
          if (((j-poslPozice) mod 71) = 0) or (j>=Length(r)) then begin
            if (poslMezera=0)or(j>=Length(r)) then
              poslMezera:=j;
            //zapis
            AddStrLine(ADoc,'<VetaR ');
            AddStrValue(ADoc,'kod_sekce',AKodSekce);
            AddStrValue(ADoc,'poradi',IntToStr(k));
            AddStrValue(ADoc,'t_prilohy',Copy(r,poslPozice+1,poslMezera-poslPozice));
            AddStrLine(ADoc,'/>');
            //
            poslPozice:=poslMezera;
            poslMezera:=0;
            j:=poslPozice;
            INC(k);
          end;
          INC(j);
        end;
      end
      else begin
        if sl[i]<>'' then begin
          AddStrLine(ADoc,'<VetaR ');
          AddStrValue(ADoc,'kod_sekce',AKodSekce);
          AddStrValue(ADoc,'poradi',IntToStr(k));
          AddStrValue(ADoc,'t_prilohy',sl[i]);
          AddStrLine(ADoc,'/>');
          INC(k);
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

function IDDSForFilling;
var
  idds, email, nazev: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  idds:=''; email:=''; nazev:=''; 
  //--- konec automaticke inicializace
  Result := '';
  idds := VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'IDDS'));
  if idds <> '' then begin
    nazev := VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'NazevFU'));
    email := VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'Email'));
    Result := AddValueToList(Result, idds);
    Result := AddValueToList(Result, email);
    Result := AddValueToList(Result, nazev, True);
  end;
end;

{#EPO-POVINNOST} // NEMAZAT!!!!!

function Filling: string;
var
  doc, koef: string;
  filtr: string;
  i,j: integer;
  cfu: string;
  data, guid, pril: string;
  cnt: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  doc:=''; koef:=''; 
  filtr:=''; 
  i:=0; j:=0; 
  cfu:=''; 
  data:=''; guid:=''; pril:=''; 
  cnt:=0; 
  //--- konec automaticke inicializace
  cfu:=VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'C_Ufo'));
  if cfu <> [:C_Ufo:] then begin
    TryEditValuesRecord;
    [:C_Ufo:]:=VarToStr(LstLookup('FU13',Date,'CisloFU',[:CisFU:],'C_Ufo'));
    TryPostValuesRecord;
  end;

  doc:='';
  AddStrLine(doc,'<?xml version="1.0" encoding="UTF-8"?>');
  AddStrLine(doc,'<Pisemnost>');//xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" xsi:noNamespaceSchemaLocation="C:\mfcr_script\dphdp1.xsd"
  AddStrLine(doc,'<DPHDP3>');

  AddStrLine(doc,'<VetaD ');
  AddStrValue(doc,'d_zjist',[:DenDuvodu:]);
  AddStrValue(doc,'dokument','DP3');
  AddStrValue(doc,'zdobd_od',[:ObdobiOd:]);
  AddStrValue(doc,'ctvrt',[:Ctvrtleti:]);
  if [.PlatceDane.] then
    AddStrValue(doc,'typ_platce','P')
  else if [.IdentifikOsKDani.] then
    AddStrValue(doc,'typ_platce','I')
  else if [.Skupina95a.] then
    AddStrValue(doc,'typ_platce','S')
  else if [.NeplatceDane.] then
    AddStrValue(doc,'typ_platce','N')
  else if [.NeplatceDanePorNDP.] then
    AddStrValue(doc,'typ_platce','R')
  else if [.NeplatceDaneDodNDP.] then
    AddStrValue(doc,'typ_platce','D');
  AddStrValue(doc,'d_por_dod',[:NeplatceDaneNDPDatum:]);            
  if [.ckOpravne.] then begin
    if [.ckRadne.] then
      AddStrValue(doc,'dapdph_forma','O')
    else if [.ckDodatecne.] then
      AddStrValue(doc,'dapdph_forma','E');
  end
  else begin
    if [.ckRadne.] then
      AddStrValue(doc,'dapdph_forma','B')
    else if [.ckDodatecne.] then
      AddStrValue(doc,'dapdph_forma','D');
  end;
  AddStrValue(doc,'c_okec',UnNormOkecEPO([:OKEC:]));
  AddStrValue(doc,'mesic',[:Mesic:]);
  AddStrValue(doc,'d_poddp',[:Datum:]);
  if [.UdajeOddC.] then
    AddStrValue(doc,'trans','N')
  else
    AddStrValue(doc,'trans','A');
  AddStrValue(doc,'kod_zo',[:KodZdanObd:]);
  AddStrValue(doc,'k_uladis','DPH');
  AddStrValue(doc,'rok',[:Rok:]);
  AddStrValue(doc,'zdobd_do',[:ObdobiDo:]);
  AddStrLine(doc,'/>');
//--------------------------
  AddStrLine(doc,'<VetaP ');
  AddStrValue(doc,'ulice',[:Ulice:]);
  if [.ckPO.] then
    AddStrValue(doc,'typ_ds','P')
  else
    AddStrValue(doc,'typ_ds','F');
  AddStrValue(doc,'dic',Copy([.DIC.],3,10));
  AddStrValue(doc,'prijmeni',[:FOPrijmeni:]);
  AddStrValue(doc,'c_telef',[.Telefon.]);
  AddStrValue(doc,'c_orient',Cond([:CisloOrient:]<>'',
                                  Cond(Pos('/',[:CisloOrient:])>0,ExtractAfterChar([:CisloOrient:],'/'),[:CisloOrient:]),
                                  Cond(Pos('/',[:CisloPop:])>0,ExtractAfterChar([:CisloPop:],'/'),'')));
  AddStrValue(doc,'c_ufo',[:C_Ufo:]);
  AddStrValue(doc,'c_pracufo',[:CisFU:]);
  AddStrValue(doc,'naz_obce',[:Obec:]);
  AddStrValue(doc,'jmeno',[:FOJmeno:]);
  AddStrValue(doc,'c_pop',Cond(Pos('/',[:CisloPop:])>0,ExtractBeforeChar([:CisloPop:],'/'),[:CisloPop:]));
  AddStrValue(doc,'zkrobchjm',
    StrTrimCharRight([:POObchJmeno:]+' '+[:POObchJmeno1:],' '));
  AddStrValue(doc,'titul',[:FOTitul:]);
  AddStrValue(doc,'psc',Replace(' ',[:PSC:],''));
//  if ([.Stat.]='CZ') or ([.Stat.]='ČR') or AnsiUpperCase([.Stat.]='ČESKÁ REPUBLIKA') then
  if ([.Stat.]='CZ') or ([.Stat.]='ČR') then
    AddStrValue(doc,'stat',VarToStr(LstLookup('KodyStatu', Date,'KodAlpha2','CZ','Nazev')))
  else
    AddStrValue(doc,'stat',[.Stat.]);
  AddStrValue(doc,'email',[.Email.]);
  //
  AddStrValue(doc,'opr_jmeno',[:OprOsJm:]);
  AddStrValue(doc,'opr_postaveni',[:OprOsPost:]);
  AddStrValue(doc,'opr_prijmeni',[:OprOsPrijm:]);
  AddStrValue(doc,'sest_jmeno',[:SestJm:]);
  AddStrValue(doc,'sest_prijmeni',[:SestPrijm:]);
  AddStrValue(doc,'sest_telef',[:SestTel:]);
  AddStrValue(doc,'zast_dat_nar',[:ZastDatNar:]);
  AddStrValue(doc,'zast_ev_cislo',[:ZastEvCislo:]);
  AddStrValue(doc,'zast_ic',[:ZastIC:]);
  AddStrValue(doc,'zast_jmeno',[:ZastJm:]);
  AddStrValue(doc,'zast_kod',[:ZastKod:]);
  AddStrValue(doc,'zast_nazev',[:ZastNazPO:]);
  AddStrValue(doc,'zast_prijmeni',[:ZastPrijm:]);
  AddStrValue(doc,'zast_typ',Cond2([.ZastFO.],'F',[.ZastPO.],'P',''));
  AddStrLine(doc,'/>');
//-------------------------- dal trideni podle cisla radku
  AddStrLine(doc,'<Veta1 ');
  AddStrValue(doc,'obrat23',[:R01z:]);
  AddStrValue(doc,'dan23',[:R01dan:]);
  AddStrValue(doc,'obrat5',[:R02z:]);
  AddStrValue(doc,'dan5',[:R02dan:]);
  AddStrValue(doc,'p_zb23',[:R03z:]);
  AddStrValue(doc,'dan_pzb23',[:R03dan:]);
  AddStrValue(doc,'p_zb5',[:R04z:]);
  AddStrValue(doc,'dan_pzb5',[:R04dan:]);
  AddStrValue(doc,'p_sl23_e',[:R05z:]);
  AddStrValue(doc,'dan_psl23_e',[:R05dan:]);
  AddStrValue(doc,'p_sl5_e',[:R06z:]);
  AddStrValue(doc,'dan_psl5_e',[:R06dan:]);
  AddStrValue(doc,'dov_zb23',[:R07z:]);
  AddStrValue(doc,'dan_dzb23',[:R07dan:]);
  AddStrValue(doc,'dov_zb5',[:R08z:]);
  AddStrValue(doc,'dan_dzb5',[:R08dan:]);
  AddStrValue(doc,'p_dop_nrg',[:R09z:]);
  AddStrValue(doc,'dan_pdop_nrg',[:R09dan:]);
  AddStrValue(doc,'rez_pren23',[:R10z:]);
  AddStrValue(doc,'dan_rpren23',[:R10dan:]);
  AddStrValue(doc,'rez_pren5',[:R11z:]);
  AddStrValue(doc,'dan_rpren5',[:R11dan:]);
  AddStrValue(doc,'p_sl23_z',[:R12z:]);
  AddStrValue(doc,'dan_psl23_z',[:R12dan:]);
  AddStrValue(doc,'p_sl5_z',[:R13z:]);
  AddStrValue(doc,'dan_psl5_z',[:R13dan:]); 
  
  if EnaRadky14a48 then begin
    AddStrValue(doc,'opr_dane_zd',[:R14z:]);
    AddStrValue(doc,'opr_dane_dan',[:R14dan:]);    
  end;
  AddStrLine(doc,'/>');
//--------------------------
  AddStrLine(doc,'<Veta2 ');
  AddStrValue(doc,'dod_zb',[:R20:]);
  AddStrValue(doc,'pln_sluzby',[:R21:]);
  AddStrValue(doc,'pln_vyvoz',[:R22:]);
  AddStrValue(doc,'dod_dop_nrg',[:R23:]);
  AddStrValue(doc,'pln_zaslani',[:R24:]);
  AddStrValue(doc,'pln_rez_pren',[:R25:]);
  AddStrValue(doc,'pln_ost',[:R26:]);
  AddStrLine(doc,'/>');
//--------------------------
  AddStrLine(doc,'<Veta3 ');
  AddStrValue(doc,'tri_pozb',[:R30:]);
  AddStrValue(doc,'tri_dozb',[:R31:]);
  AddStrValue(doc,'dov_osv',[:R32:]);
  AddStrValue(doc,'opr_verit',[:R33:]);
  AddStrValue(doc,'opr_dluz',[:R34:]);
  AddStrLine(doc,'/>');
//--------------------------
  AddStrLine(doc,'<Veta4 ');
  AddStrValue(doc,'pln23',[:R40z:]);
  AddStrValue(doc,'odp_tuz23_nar',[:R40danP:]);
  AddStrValue(doc,'odp_tuz23',[:R40danK:]);
  AddStrValue(doc,'pln5',[:R41z:]);
  AddStrValue(doc,'odp_tuz5_nar',[:R41danP:]);
  AddStrValue(doc,'odp_tuz5',[:R41danK:]);

  AddStrValue(doc,'dov_cu',[:R42z:]);
  AddStrValue(doc,'odp_cu_nar',[:R42danP:]);
  AddStrValue(doc,'odp_cu',[:R42danK:]);
  AddStrValue(doc,'nar_zdp23',[:R43z:]);
  AddStrValue(doc,'od_zdp23',[:R43danP:]);
  AddStrValue(doc,'odkr_zdp23',[:R43danK:]);

  AddStrValue(doc,'nar_zdp5',[:R44z:]);
  AddStrValue(doc,'od_zdp5',[:R44danP:]);
  AddStrValue(doc,'odkr_zdp5',[:R44danK:]);
  AddStrValue(doc,'odp_rez_nar',[:R45danP:]);
  AddStrValue(doc,'odp_rezim',[:R45danK:]);

  AddStrValue(doc,'odp_sum_nar',[:R46danP:]);
  AddStrValue(doc,'odp_sum_kr',[:R46danK:]);
  AddStrValue(doc,'nar_maj',[:R47z:]);
  AddStrValue(doc,'od_maj',[:R47danP:]);
  AddStrValue(doc,'odkr_maj',[:R47danK:]);
  
  if EnaRadky14a48 then begin
    AddStrValue(doc,'kor_odp_zd',[:R48z:]);
    AddStrValue(doc,'kor_odp_plne',[:R48danP:]);
    AddStrValue(doc,'kor_odp_krac',[:R48danK:]);    
  end;

  AddStrLine(doc,'/>');
//--------------------------
  AddStrLine(doc,'<Veta5 ');
  AddStrValue(doc,'plnosv_kf',[:R50:]);
  AddStrValue(doc,'pln_nkf',[:R51NarokOdp:]);
  AddStrValue(doc,'plnosv_nkf',[:R51BezNarokOdp:]);

  koef:=FloatToStr(RoundKoef([.R52Koef.]));
  AddFloatStrValue(doc,'koef_p20_nov',Cond([:R52Koef:]<>'',koef,''));
  AddStrValue(doc,'odp_uprav_kf',[:R52:]);
  koef:=FloatToStr(RoundKoef([.R53Koef.]));
  AddFloatStrValue(doc,'koef_p20_vypor',Cond([:R53Koef:]<>'',koef,''));
  AddStrValue(doc,'vypor_odp',[:R53:]);
  AddStrLine(doc,'/>');
//--------------------------
  AddStrLine(doc,'<Veta6 ');
  AddStrValue(doc,'uprav_odp',[:R60:]);
  AddStrValue(doc,'dan_vrac',[:R61:]);
  AddStrValue(doc,'dan_zocelk',[:R62:]);
  AddStrValue(doc,'odp_zocelk',[:R63:]);
  AddStrValue(doc,'dano_da',[:R64:]);
  AddStrValue(doc,'dano_no',[:R65:]);
  AddStrValue(doc,'dano',[:R66:]);
  AddStrLine(doc,'/>');
//--------------------------

/////////////////////////////////////////////////////
//Veta R - zaznam o priloze
////////////////////////////////////////////////////
  if [.ckDodatecne.] then
    VetaR_TextPril(doc, [:meDuvodyDDP:], 'D');

  //Obecna textova priloha
  if IncEPOPril_PrilExists(GetListItem(coDataTextPril, 0)) then
    VetaR_TextPril(doc, GetAppendixString, 'O');

/////////////////////////////////////////////////////
//Obecna priloha
////////////////////////////////////////////////////

  if (mtValues.FindField('IncEPOPril')<> nil) and ([:IncEPOPril:]<>'') then begin
    AddStrLine(doc,'<Prilohy>');
    j := 1;
    cnt:=GetStringLinesCount([:IncEPOPril:]);
    for i := 0 to cnt - 1 do begin
      guid:=Copy(GetStringLine([:IncEPOPril:],i),IncEPOPrilCaptionLength+1,80);
      data:=GetNestedSection([:IncEPOPrilData:],guid);
      //
      pril:= GetFormField(data,'FilePathDocIdGuid');
      if pril = '' then
        pril:= GetFormField(data,'FileNamePath'); //kvuli zpetne kompatibilite z predchozi strukturou
      if (SameText(GetFormField(data,'DocType'), 'D')) or
         (StrToBoolSafe(GetFormField(data,'Document'))) then //kvuli zpetne kompatibilite z predchozi strukturou
        pril := GetDoc(StrToIntSafe(pril));
      //
      if FileExists(pril) then begin
        AddStrLine(doc,'<ObecnaPriloha ');
        AddStrLine(doc,'cislo="'+IntToStr(j)+'" '+
          'jm_souboru="'+XMLNormChars(ExtractFileName(pril))+'" '+
          'kodovani="base64" '+
          'nazev="'+XMLNormChars(GetFormField(data,'Description'))+'" >');

        AddStrLine(doc,
          '<![CDATA[ '+
          BinaryFileToStringBase64(pril)+
          ']]>');
        AddStrLine(doc,'</ObecnaPriloha>');
        //
        INC(j);
      end;
    end;
    AddStrLine(doc,'</Prilohy>');
  end;

  AddStrLine(doc,'</DPHDP3>');
  AddStrLine(doc,'</Pisemnost>');
  //
  Result:=AnsiToUTF8(doc);
end;

////////////////////////////////////////////////////////////////////////////////
//Import dat z XML souboru ve formatu EPO (danovy portal MFCR)
////////////////////////////////////////////////////////////////////////////////
(*
PRIKLAD:

<?xml version="1.0" encoding="UTF-8"?>
<Pisemnost nazevSW="EPO MF ČR" verzeSW="31.17.4">
<DPHSHV verzePis="01.01">
<VetaD pln_poc_celk="0" rok="2010" suma_pln="0" k_uladis="DPH" d_poddp="02.02.2010" shvies_forma="R" poc_stran="3" mesic="1" poc_radku="22" dokument="SHV" />
<VetaP typ_ds="F" ulice="Březsko" naz_obce="BŘEZSKO" psc="79852" prijmeni="Bílý" dic="7507264468" c_ufo="326" jmeno="Marek" c_pop="4" />
<VetaR c_rad="1" c_vat="12" por_c_stran="1" k_stat="GB" />
<VetaR c_rad="2" por_c_stran="1" k_stat="DE" />
<VetaR c_rad="3" por_c_stran="1" k_stat="DE" />
.
.
<VetaR c_rad="19" por_c_stran="1" k_stat="LV" />
<VetaR c_rad="20" por_c_stran="1" k_stat="MT" />
<VetaR c_rad="1" por_c_stran="2" k_stat="EE" />
<VetaR c_rad="1" por_c_stran="3" k_stat="FR" />
</DPHSHV>
</Pisemnost>
*)

function TrimCRLF(AStr: string): string;
begin
  Result := Trim(AStr);
  Result := StrTrimCharLeft(Result,cCRLF);
  Result := StrTrimCharLeft(Result,#13);
  Result := StrTrimCharLeft(Result,#10);
  Result := StrTrimCharRight(Result,cCRLF);
  Result := StrTrimCharRight(Result,#13);
  Result := StrTrimCharRight(Result,#10);
  Result := Trim(Result);
end;

//ReplaceXmlStr
//konverze nepripustnych znaku v XML
function ReplaceXmlStr(AStr: string): string;
begin
  Result := Replace('&amp;', AStr, '&');
  Result := Replace('&lt;', Result, '<');
  Result := Replace('&gt;', Result, '>');
  Result := Replace('&apos;', Result, '''');
  Result := Replace('&quot;', Result, '"');
end; {ReplaceXmlStr}

procedure AddStrToStringList(Strings: TStrings; AAddedStrLine: string);
begin
  AddStringToStrings(AAddedStrLine,Strings,False);
end; {AddStrToStringList}

//smaze vsechny udaje na formulari
procedure mtValuesClearFields;
var
  i: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  i:=0; 
  //--- konec automaticke inicializace
  TryEditValuesRecord;
  with mtValues do begin
    for i := 0 to Fields.Count - 1 do begin
      if (Fields[i].DataType=ftBoolean)then
        Fields[i].Value:=False
      else
        Fields[i].Clear;
    end;
  end;
  TryPostValuesRecord;
end;

//z prvniho radku v XML zjisti kodovani, pokud utf8, tak prekoduje text na utf8
function XMLEncode(AXmlFile: string): string;
var
  sl: TStringList;
  i: integer;
  xmlWorkFile: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  i:=0; 
  xmlWorkFile:=''; 
  //--- konec automaticke inicializace
  Result := XMLStrToWindows1250(AXmlFile);
  if (AXmlFile = Result) then begin         //nove 22.6.2015 - pokud je xml soubor v UTF16, tak ho XMLStrToWindows1250 nenacte
    RunDotNetStript(':con',AXmlFile,true);  //proto si pomahame Visual Studiem, ktery UTF16 konvertuje do UTF8 a ulozi do Worku
    xmlWorkFile := NormalPath(GetDirWorkPath)+ExtractFileName(AXmlFile);
    if FileExists(xmlWorkFile) then         //a zde ho nasledne nacitame
      Result := XMLStrToWindows1250(xmlWorkFile); //ale je v UTF8, tak konverze do Win1250
  end;
end;

//vraci nazev zacatku node, napr: <VetaD
function XmlNodeNameStart(AXmlNode, ANodeName: string): string;
begin
  Result := '<'+ANodeName+'>';
  if Pos(Result, AXmlNode) = 0 then begin
    Result := '<'+ANodeName+' ';
    if Pos(Result, AXmlNode) = 0 then begin
      Result := '<'+ANodeName+cCRLF;
      if Pos(Result, AXmlNode) = 0 then begin
        Result := '<'+ANodeName+#13;
        if Pos(Result, AXmlNode) = 0 then begin
          Result := '<'+ANodeName+#10;
          if Pos(Result, AXmlNode) = 0 then begin
            Result := '';//'<'+ANodeName;
          end;
        end;
      end;
    end;
  end;
 // Result := '<'+ANodeName;
end;

//vraci nazev konce node, napr: </VetaD>
function XmlNodeNameEnd(ANodeName: string): string;
begin
  Result := '</'+ANodeName+'>';
end;

//zjisti pocet vyskytu nazvu zacatku node v celem node, tzn napr pocet vyskytu textu <VetaR
//v AXmlNodeName se predava napr text VetaR, ale vraci vyskyt zacatku node <VetaR
function XMLNode_Count(AXmlNode, AXmlNodeName: string): integer;
begin
  Result := StrStrCount(AXmlNode, XmlNodeNameStart(AXmlNode, AXmlNodeName));
end;

//z AStr vraci text nachazejici se mezi StartStr a EndStr (neobsahuje texty StartStr a EndStr)
function StrBetween(AStr: string; StartStr, EndStr: string): string;
var
  posStart, posEnd: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  posStart:=0; posEnd:=0; 
  //--- konec automaticke inicializace
  Result := '';
  posStart := Pos(StartStr, AStr);
  posEnd := Pos(EndStr, AStr);
  if posStart > 0 then
    Result := Copy(AStr,
                     posStart+Length(StartStr),
                     posEnd-(posStart+Length(StartStr)));
end;

//pouziti ve funkcich XMLNode a XMLAttributesLists
//z AXmlNode vraci text od N-teho vyskytu AXmlNodeName po konec AXmlNode
//pokud N-ty vyskyt neni, tak vraci prazdny retezec
//napr pri volani ...(priklad, 'VetaR', 2) vraci vse od '<VetaR c_rad="2"....' az po konec AXmlNode
function XMLOccurNodeText(AXmlNode, AXmlNodeName: string; N: integer): string;
var
  p: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  p:=0; 
  //--- konec automaticke inicializace
  Result := '';
  p := StrNPos(AXmlNode, XmlNodeNameStart(AXmlNode, AXmlNodeName), N);
  if p > 0 then
    Result := Copy(AXmlNode, p, cMaxInt);
end;

//z AXmlNode vraci text (obsah node) N-teho vyskytu AXmlNodeName
//pokud AXmlNode neobsahuje konec '</Konec>', tak vezme konec '/>'
//pokud N-ty vyskyt neni, tak vraci prazdny retezec
//napr pri volani ...(priklad, 'VetaR', 2) vraci ' c_rad="2" por_c_stran="1" k_stat="DE" '
//nebo pri volani ...(priklad, 'DPHSHV') vraci vse mezi '<DPHSHV' a '</DPHSHV>'
// (nebosahuje texty '<DPHSHV' a '</DPHSHV>' a attributy)
function XMLNode(AXmlNode, AXmlNodeName: string; N: integer): string;
var
  str: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  str:=''; 
  //--- konec automaticke inicializace
  Result := '';
  str := XMLOccurNodeText(AXmlNode, AXmlNodeName, N);

  if str <> '' then begin
    Result := StrBetween(str, XmlNodeNameStart(str, AXmlNodeName),       //vezmeme vse mezi zacatkem a koncem
                         XmlNodeNameEnd(AXmlNodeName));
    Result := TrimCRLF(Result);
    if (Result <> '') and (Copy(Result,1,1) <> '<') then begin           //vezmeme text az od >, abysme odstranili atributy (jen pokud atributy jsou = nezacina znakem: <
      Result := Copy(Result, Pos('>',Result)+1, cMaxInt);
    end;
  end;
end;

//zjednodusuje volani XMLNode, kdy nemusime psat nekolikanasobne:
// XMLNode(XMLNode(XMLNode(xml,'node1'),'node2'),'node3')
//ale pouzijeme:
// XMLNodes(xml,'node1,node2,node3')
function XMLNodes(AXmlNode, AXmlNodesName: string): string;
var
  str: string;
  i: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  str:=''; 
  i:=0; 
  //--- konec automaticke inicializace
  Result := '';
  str := AXmlNode;
  for i := 0 to CountListItems(AXmlNodesName) - 1 do begin
    Result := XMLNode(str, GetListItem(AXmlNodesName,i), 1);
    str := Result;
  end;
end;

//z AXmlNode vraci attributy N-teho vyskytu AXmlNodeName
//pokud node attributy nema, tak vraci prazdny retezec
//pokud N-ty vyskyt neni, tak vraci prazdny retezec
//napr pri volani ...(priklad, 'Pisemnost') vraci 'nazevSW="EPO MF ČR" verzeSW="31.17.4"'
function XMLAttributesLists(AXmlNode, AXmlNodeName: string; N: integer): string;
var
  nodeEnd: string;
  str: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  nodeEnd:=''; 
  str:=''; 
  //--- konec automaticke inicializace
  Result := '';
  nodeEnd:='/>';                      //alternativni konec
  str := XMLOccurNodeText(AXmlNode, AXmlNodeName, N);
  if str <> '' then begin
    Result := StrBetween(str, XmlNodeNameStart(str, AXmlNodeName),       //vezmeme vse mezi zacatkem a koncem
                         XmlNodeNameEnd(AXmlNodeName));
    if Result <> '' then begin                                  //vezmeme text od 1 do pozice >, aby zustaly jen atributy
      Result := Copy(Result, 1, Pos('>',Result)-1);
    end;
    if Result = '' then begin                                           //pokud zadny text neni, tak zkusime vzit altrnativni konec
      Result := StrBetween(str, XmlNodeNameStart(str, AXmlNodeName), nodeEnd);
      if (Pos('<',Result) > 0) or (Pos('>',Result) > 0) then           //pokud text obsahuje < nebo >, tzn vzal se alternativni konec jineho node, tak mazeme
        Result := '';
    end;
  end;
end;

//ze seznamu vsech atributu AAttributesLists vraci hodnotu atributu AAttributeName
//napr pri volani ...('nazevSW="EPO MF ČR" verzeSW="31.17.4"', 'nazevSW') vraci 'EPO MF ČR'
//pokud atribut neexistuje nebo je prazdny, tak vraci prazdny retezec
function XMLAttribToStr(AAttributesLists, AAttributeName: string): string;
var
  att: string;
  p: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  att:=''; 
  p:=0; 
  //--- konec automaticke inicializace
  Result := '';
  att := ' '+AAttributeName+'=';
  p := Pos(att, AAttributesLists);
  if p = 0 then begin
    att := AAttributeName+'=';
    p := Pos(att, AAttributesLists);
  end;
  if p > 0 then begin
    att :=  Copy(AAttributesLists, p+Length(att)+1, cMaxInt);
    Result := Trim(Copy(att, 1, Pos('"', att)-1));
    if Result = '' then
      Result := Trim(Copy(att, 1, Pos('''', att)-1));
    Result := ReplaceXmlStr(Result);
  end;
end;

//popis viz. XMLAttribToStr s tim,
//ze testuje, jestli je retezec platne datum
//result je string a pri volani se do udaje zapisuje pomoci [::] z toho duvodu,
//  aby se pri prazdnem atributu neplnilo datum '30.12.1899'
//pokud atribut neni datum, tak se zapise informace do Gsl
function XMLAttribToDate(AAttributesLists, AAttributeName: string): string;
var
  strDatum, str: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  strDatum:=''; str:=''; 
  //--- konec automaticke inicializace
  Result := '';
  strDatum := XMLAttribToStr(AAttributesLists, AAttributeName);
  str := Replace('.', Replace(' ',strDatum ,''), DateSeparator);
  if str <> '' then
    if IsDate(str) then
      Result := str
    else
      AddStrToStringList(Gsl, AAttributeName+Format(': neplatné datum ''%s''',[strDatum]));
end;

//popis viz. XMLAttribToStr s tim,
//ze testuje, jestli je retezec platne cele cislo
//result je string a pri volani se do udaje zapisuje pomoci [::] z toho duvodu,
//  aby se pri prazdnem atributu neplnila '0'
//pokud atribut neni cislo, tak se zapise informace do Gsl
//16.7.2013 - funkce upravena tak, aby brala i float, pokud je jeho desetinna cast rovna 0
function XMLAttribToInt(AAttributesLists, AAttributeName: string): string;
var
  str, strFloat: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  str:=''; strFloat:=''; 
  //--- konec automaticke inicializace
  Result := '';
  str := XMLAttribToStr(AAttributesLists, AAttributeName);
  str := Replace(' ',str ,'');
  strFloat := Replace(',', Replace('.', str, DecimalSeparator), DecimalSeparator);

  if str <> '' then
    if IsDigit(str) then
      Result := str
    else if IsFloat(strFloat) and (Frac(StrToFloat(strFloat)) = 0) then
      Result := FloatToStr(RoundAri(StrToFloat(strFloat),0))
    else
      AddStrToStringList(Gsl, AAttributeName+Format(': neplatná číselná hodnota ''%s''',[str]));
end;

//popis viz. XMLAttribToStr a XMLAttribToInt s tim, ze testujeme, ze se jedna o Float
function XMLAttribToFloat(AAttributesLists, AAttributeName: string): string;
var
  strFloat, str: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  strFloat:=''; str:=''; 
  //--- konec automaticke inicializace
  Result := '';
  strFloat := XMLAttribToStr(AAttributesLists, AAttributeName);
  str := Replace(',', Replace('.', Replace(' ',strFloat ,''), DecimalSeparator), DecimalSeparator);
  if str <> '' then
    if IsFloat(str) then
      Result := str
    else
      AddStrToStringList(Gsl, AAttributeName+Format(': neplatná číselná hodnota ''%s''',[strFloat]));
end;

//popis viz. XMLAttribToStr s tim,
//ze testuje, jestli je retezec platna boolean hodnota
//vraci TRUE, pokud je retezec TRUE, -1, 1 nebo A. V opacnem pripade vraci False
function XMLAttribToBool(AAttributesLists, AAttributeName: string): string;
var
  str: string;
  b: boolean;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  str:=''; 
  b:=False; 
  //--- konec automaticke inicializace
  Result := 'False';
  str := XMLAttribToStr(AAttributesLists, AAttributeName);
  if str <> '' then begin
    b := (Uppercase(str) = 'TRUE') or (str = '-1') or (str = '1') or (str = 'A');
    Result := BoolToStr(b,TRUE);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//KONEC importu dat z XML souboru ve formatu EPO
////////////////////////////////////////////////////////////////////////////////

procedure ImportVetaD(ANode: string);
var
  stVeta, str: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; str:=''; 
  //--- konec automaticke inicializace
  stVeta := XMLAttributesLists(ANode,'VetaD', 1);
  //
  if stVeta <> '' then begin
    TryEditValuesRecord;
    //
    [:DenDuvodu:] := XMLAttribToDate(stVeta,'d_zjist');
    [:ObdobiOd:] := XMLAttribToDate(stVeta,'zdobd_od');

    [:Ctvrtleti:] := XMLAttribToInt(stVeta,'ctvrt');

    str := UpperCase(XMLAttribToStr(stVeta,'typ_platce'));
    [.PlatceDane.] := (str = 'P');
    [.IdentifikOsKDani.] :=  (str = 'I');
    [.Skupina95a.] :=  (str = 'S');
    [.NeplatceDane.] :=  (str = 'N');
    [.NeplatceDanePorNDP.] :=  (str = 'R');
    [.NeplatceDaneDodNDP.] :=  (str = 'D');
    
    [:NeplatceDaneNDPDatum:] := XMLAttribToDate(stVeta,'d_por_dod');

    str := UpperCase(XMLAttribToStr(stVeta,'dapdph_forma'));
    [.ckRadne.] := (str = 'B') or (str = 'O');
    [.ckDodatecne.] := (str = 'D') or (str = 'E');
    [.ckOpravne.] := (str = 'O') or (str = 'E');

    [:OKEC:] := NormOkecEPO(XMLAttribToStr(stVeta,'c_okec'));
    [:Mesic:] := XMLAttribToStr(stVeta,'mesic');
    [:Datum:] := XMLAttribToDate(stVeta,'d_poddp');

    str := UpperCase(XMLAttribToStr(stVeta,'trans'));
    [.UdajeOddC.] := (str = 'N');

    [:KodZdanObd:] := XMLAttribToStr(stVeta,'kod_zo');
    [:Rok:] := XMLAttribToInt(stVeta,'rok');

    [:ObdobiDo:] := XMLAttribToDate(stVeta,'zdobd_do');
    //
    TryPostValuesRecord;
    //
    OnChangeExit_OKEC;
  end;
end;

procedure ImportVetaP(ANode: string);
var
  stVeta, str: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; str:=''; 
  //--- konec automaticke inicializace
  stVeta := XMLAttributesLists(ANode,'VetaP', 1);
  //
  if stVeta <> '' then begin
    TryEditValuesRecord;
    //
    [:Ulice:] := XMLAttribToStr(stVeta,'ulice');

    str := UpperCase(XMLAttribToStr(stVeta,'typ_ds'));
    [.ckPO.] := (str = 'P');

    str := XMLAttribToStr(stVeta,'dic');
    if str <> '' then
      [:DIC:] := 'CZ'+str;

    [:FOPrijmeni:] := XMLAttribToStr(stVeta,'prijmeni');
    [:Telefon:] := XMLAttribToStr(stVeta,'c_telef');
    [:CisloOrient:] := XMLAttribToStr(stVeta,'c_orient');
    [:CisFU:] := XMLAttribToStr(stVeta,'c_pracufo');
    [:C_Ufo:] := XMLAttribToStr(stVeta,'c_ufo');
    ChangeFU;
    TryEditValuesRecord;
    [:Obec:] := XMLAttribToStr(stVeta,'naz_obce');
    [:FOJmeno:] := XMLAttribToStr(stVeta,'jmeno');
    [:CisloPop:] := XMLAttribToStr(stVeta,'c_pop');
    [:POObchJmeno:] := XMLAttribToStr(stVeta,'zkrobchjm');
    [:FOTitul:] := XMLAttribToStr(stVeta,'titul');
    [:PSC:] := XMLAttribToStr(stVeta,'psc');
    [:Stat:] := XMLAttribToStr(stVeta,'stat');
    [:Email:] := XMLAttribToStr(stVeta,'email');

    [:OprOsJm:] := XMLAttribToStr(stVeta,'opr_jmeno');
    [:OprOsPost:] := XMLAttribToStr(stVeta,'opr_postaveni');
    [:OprOsPrijm:] := XMLAttribToStr(stVeta,'opr_prijmeni');
    [:SestJm:] := XMLAttribToStr(stVeta,'sest_jmeno');
    [:SestPrijm:] := XMLAttribToStr(stVeta,'sest_prijmeni');
    [:SestTel:] := XMLAttribToStr(stVeta,'sest_telef');
    [:ZastDatNar:] := XMLAttribToDate(stVeta,'zast_dat_nar');
    [:ZastEvCislo:] := XMLAttribToStr(stVeta,'zast_ev_cislo');
    [:ZastIC:] := XMLAttribToStr(stVeta,'zast_ic');
    [:ZastJm:] := XMLAttribToStr(stVeta,'zast_jmeno');
    [:ZastKod:] := XMLAttribToStr(stVeta,'zast_kod');
    [:ZastNazPO:] := XMLAttribToStr(stVeta,'zast_nazev');
    [:ZastPrijm:] := XMLAttribToStr(stVeta,'zast_prijmeni');
    str := UpperCase(XMLAttribToStr(stVeta,'zast_typ'));
    [.ZastFO.] := (str = 'F');
    [.ZastPO.] :=  (str = 'P');
    //
    TryPostValuesRecord;
    //
    OnChangeExit_CisFU;
  end;
end;

function AddToFld(
  AFieldVal: string;
  AAttributesLists, AAttributeName: string): string;
var
  valXML: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  valXML:=''; 
  //--- konec automaticke inicializace
  Result := '';
  valXML := XMLAttribToInt(AAttributesLists, AAttributeName);

  if (AFieldVal='') and (valXML='')then
    Result := ''
  else
    Result := FloatToStr(VarToDouble(AFieldVal)+VarToDouble(valXML));
end;

procedure ImportVeta1(ANode: string);
var
  stVeta: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; 
  //--- konec automaticke inicializace
  stVeta := XMLAttributesLists(ANode,'Veta1', 1);
  //
  if stVeta <> '' then begin
    TryEditValuesRecord;
    //
    [:R01z:] := AddToFld([:R01z:], stVeta,'obrat23');
    [:R01dan:] := AddToFld([:R01dan:], stVeta,'dan23');
    [:R02z:] := AddToFld([:R02z:], stVeta,'obrat5');
    [:R02dan:] := AddToFld([:R02dan:], stVeta,'dan5');
    [:R03z:] := AddToFld([:R03z:], stVeta,'p_zb23');
    [:R03dan:] := AddToFld([:R03dan:], stVeta,'dan_pzb23');
    [:R04z:] := AddToFld([:R04z:], stVeta,'p_zb5');
    [:R04dan:] := AddToFld([:R04dan:], stVeta,'dan_pzb5');
    [:R05z:] := AddToFld([:R05z:], stVeta,'p_sl23_e');
    [:R05dan:] := AddToFld([:R05dan:], stVeta,'dan_psl23_e');
    [:R06z:] := AddToFld([:R06z:], stVeta,'p_sl5_e');
    [:R06dan:] := AddToFld([:R06dan:], stVeta,'dan_psl5_e');
    [:R07z:] := AddToFld([:R07z:], stVeta,'dov_zb23');
    [:R07dan:] := AddToFld([:R07dan:], stVeta,'dan_dzb23');
    [:R08z:] := AddToFld([:R08z:], stVeta,'dov_zb5');
    [:R08dan:] := AddToFld([:R08dan:], stVeta,'dan_dzb5');
    [:R09z:] := AddToFld([:R09z:], stVeta,'p_dop_nrg');
    [:R09dan:] := AddToFld([:R09dan:], stVeta,'dan_pdop_nrg');
    [:R10z:] := AddToFld([:R10z:], stVeta,'rez_pren23');
    [:R10dan:] := AddToFld([:R10dan:], stVeta,'dan_rpren23');
    [:R11z:] := AddToFld([:R11z:], stVeta,'rez_pren5');
    [:R11dan:] := AddToFld([:R11dan:], stVeta,'dan_rpren5');
    [:R12z:] := AddToFld([:R12z:], stVeta,'p_sl23_z');
    [:R12dan:] := AddToFld([:R12dan:], stVeta,'dan_psl23_z');
    [:R13z:] := AddToFld([:R13z:], stVeta,'p_sl5_z');
    [:R13dan:] := AddToFld([:R13dan:], stVeta,'dan_psl5_z');
    [:R14z:] := AddToFld([:R14z:], stVeta,'opr_dane_zd');
    [:R14dan:] := AddToFld([:R14dan:], stVeta,'opr_dane_dan');
    //
    TryPostValuesRecord;
  end;
end;

procedure ImportVeta2(ANode: string);
var
  stVeta: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; 
  //--- konec automaticke inicializace
  stVeta := XMLAttributesLists(ANode,'Veta2', 1);
  //
  if stVeta <> '' then begin
    TryEditValuesRecord;
    //
    [:R20:] := AddToFld([:R20:], stVeta,'dod_zb');
    [:R21:] := AddToFld([:R21:], stVeta,'pln_sluzby');
    [:R22:] := AddToFld([:R22:], stVeta,'pln_vyvoz');
    [:R23:] := AddToFld([:R23:], stVeta,'dod_dop_nrg');
    [:R24:] := AddToFld([:R24:], stVeta,'pln_zaslani');
    [:R25:] := AddToFld([:R25:], stVeta,'pln_rez_pren');
    [:R26:] := AddToFld([:R26:], stVeta,'pln_ost');
    //
    TryPostValuesRecord;
  end;
end;

procedure ImportVeta3(ANode: string);
var
  stVeta: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; 
  //--- konec automaticke inicializace
  stVeta := XMLAttributesLists(ANode,'Veta3', 1);
  //
  if stVeta <> '' then begin
    TryEditValuesRecord;
    //
    [:R30:] := AddToFld([:R30:], stVeta,'tri_pozb');
    [:R31:] := AddToFld([:R31:], stVeta,'tri_dozb');
    [:R32:] := AddToFld([:R32:], stVeta,'dov_osv');
    [:R33:] := AddToFld([:R33:], stVeta,'opr_verit');
    [:R34:] := AddToFld([:R34:], stVeta,'opr_dluz');
    //
    TryPostValuesRecord;
  end;
end;

procedure ImportVeta4(ANode: string);
var
  stVeta: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; 
  //--- konec automaticke inicializace
  stVeta := XMLAttributesLists(ANode,'Veta4', 1);
  //
  if stVeta <> '' then begin
    TryEditValuesRecord;
    //
    [:R40z:] := AddToFld([:R40z:], stVeta,'pln23');
    [:R40danP:] := AddToFld([:R40danP:], stVeta,'odp_tuz23_nar');
    [:R40danK:] := AddToFld([:R40danK:], stVeta,'odp_tuz23');
    [:R41z:] := AddToFld([:R41z:], stVeta,'pln5');
    [:R41danP:] := AddToFld([:R41danP:], stVeta,'odp_tuz5_nar');
    [:R41danK:] := AddToFld([:R41danK:], stVeta,'odp_tuz5');

    [:R42z:] := AddToFld([:R42z:], stVeta,'dov_cu');
    [:R42danP:] := AddToFld([:R42danP:], stVeta,'odp_cu_nar');
    [:R42danK:] := AddToFld([:R42danK:], stVeta,'odp_cu');
    [:R43z:] := AddToFld([:R43z:], stVeta,'nar_zdp23');
    [:R43danP:] := AddToFld([:R43danP:], stVeta,'od_zdp23');
    [:R43danK:] := AddToFld([:R43danK:], stVeta,'odkr_zdp23');

    [:R44z:] := AddToFld([:R44z:], stVeta,'nar_zdp5');
    [:R44danP:] := AddToFld([:R44danP:], stVeta,'od_zdp5');
    [:R44danK:] := AddToFld([:R44danK:], stVeta,'odkr_zdp5');
    [:R45danP:] := AddToFld([:R45danP:], stVeta,'odp_rez_nar');
    [:R45danK:] := AddToFld([:R45danK:], stVeta,'odp_rezim');

    [:R46danP:] := AddToFld([:R46danP:], stVeta,'odp_sum_nar');
    [:R46danK:] := AddToFld([:R46danK:], stVeta,'odp_sum_kr');
    [:R47z:] := AddToFld([:R47z:], stVeta,'nar_maj');
    [:R47danP:] := AddToFld([:R47danP:], stVeta,'od_maj');
    [:R47danK:] := AddToFld([:R47danK:], stVeta,'odkr_maj');
    
    [:R48z:] := AddToFld([:R48z:], stVeta,'kor_odp_zd');
    [:R48danP:] := AddToFld([:R48danP:], stVeta,'kor_odp_plne');
    [:R48danK:] := AddToFld([:R48danK:], stVeta,'kor_odp_krac');
    //
    TryPostValuesRecord;
  end;
end;

procedure ImportVeta5(ANode: string);
var
  stVeta: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; 
  //--- konec automaticke inicializace
  stVeta := XMLAttributesLists(ANode,'Veta5', 1);
  //
  if stVeta <> '' then begin
    TryEditValuesRecord;
    //
    [:R50:] := AddToFld([:R50:], stVeta,'plnosv_kf');
    [:R51NarokOdp:] := AddToFld([:R51NarokOdp:], stVeta,'pln_nkf');
    [:R51BezNarokOdp:] := AddToFld([:R51BezNarokOdp:], stVeta,'plnosv_nkf');
    [:R52Koef:] := XMLAttribToFloat(stVeta,'koef_p20_nov');
    [:R52:] := AddToFld([:R52:], stVeta,'odp_uprav_kf');
    [:R53Koef:] := XMLAttribToFloat(stVeta,'koef_p20_vypor');
    [:R53:] := AddToFld([:R53:], stVeta,'vypor_odp');
    //
    TryPostValuesRecord;
  end;
end;

procedure ImportVeta6(ANode: string);
var
  stVeta: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; 
  //--- konec automaticke inicializace
  stVeta := XMLAttributesLists(ANode,'Veta6', 1);
  //
  if stVeta <> '' then begin
    TryEditValuesRecord;
    //
    [:R60:] := AddToFld([:R60:], stVeta,'uprav_odp');
    [:R61:] := AddToFld([:R61:], stVeta,'dan_vrac');
    //[:R62:] := AddToFld([:R62:], stVeta,'dan_zocelk');
    [:VR62:] := AddToFld([:VR62:], stVeta,'dan_zocelk');
    Calculate;    
    
    if (([.VR62.]-[.R62.]) <> 0) then
      [:R62Dan:] := [.VR62.]-[.R62.];      
    
    [:R63:] := AddToFld([:R63:], stVeta,'odp_zocelk');
    [:R64:] := AddToFld([:R64:], stVeta,'dano_da');
    [:R65:] := AddToFld([:R65:], stVeta,'dano_no');
    [:R66:] := AddToFld([:R66:], stVeta,'dano');
    //
    TryPostValuesRecord;
  end;
end;

//import textove prilohy, vola se 2x, pro D (duvody pro podani DDP) a pro O (textova priloha, importujeme do appendixu)
procedure ImportVetaR_TextPril(ANode, AKodSekce, AFieldName: string);
var
  stVeta: string;
  i, c: integer;
  sl: TStringList;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; 
  i:=0; c:=0; 
  //--- konec automaticke inicializace
  c := XMLNode_Count(ANode,'VetaR');
  if c > 0 then begin
    sl := TStringList.Create;
    try
      for i := 1 to c do begin
        stVeta := XMLAttributesLists(ANode,'VetaR', i);
        if XMLAttribToStr(stVeta,'kod_sekce') = AKodSekce then
          sl.Add(XMLAttribToStr(stVeta,'t_prilohy'));
      end;
      if AFieldName <> '' then begin
        TryEditValuesRecord;
        mtValues.FindField(AFieldName).Value := sl.Text;
        TryPostValuesRecord;
      end
      else begin
        mtTskp.Edit;
        if mtTskpAppendix.Value = '' then
          mtTskpAppendix.Value:=sl.Text
        else
          mtTskpAppendix.Value:=GetAppendixString+#13#10+sl.Text;
        mtTskp.Post;
      end;
    finally
      sl.Free;
    end;
  end;
end;

//import prilohy (nebo vice priloh) do souboru, uladaji se na disk
procedure ImportObecnePrilohy(ANode: string; ATypPrilohy: string; ASaveFolder: string);
var
  stVeta, stVetaAtt: string;
  i, c, invalidFileCount: integer;
  jmSouboru, kod, nazev: string;
  id, pth, docTyp: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; stVetaAtt:=''; 
  i:=0; c:=0; invalidFileCount:=0; 
  jmSouboru:=''; kod:=''; nazev:=''; 
  id:=''; pth:=''; docTyp:=''; 
  //--- konec automaticke inicializace
  StartWait;
  try
    docTyp := Cond(ASaveFolder<>'', 'S', 'D'); //pokud je uveden adresar pro ulozeni, tedy jedna se RunAsStandalone, tak S-soubor, jinak D-dokument
    //
    c := XMLNode_Count(ANode, ATypPrilohy);
    if c > 0 then begin
      for i := 1 to c do begin
        stVetaAtt := XMLAttributesLists(ANode, ATypPrilohy, i);
        jmSouboru := XMLAttribToStr(stVetaAtt, 'jm_souboru');
        //
        kod := XMLAttribToStr(stVetaAtt, 'kod');
        nazev := XMLAttribToStr(stVetaAtt, 'nazev');
        if (ATypPrilohy = 'ObecnaPriloha') then begin
          kod := 'OBECPRIL';
          //nazev := ''; //povolit, pokud by u obecne prilohy v description melo byt jmeno souboru
        end;
        //
        stVeta := XMLNode(ANode, ATypPrilohy, i);
        if ASaveFolder <> '' then begin
          pth := NormalPath(ASaveFolder)+jmSouboru;
          StringBase64ToBinaryFile(StrBetween(stVeta, '<![CDATA[', ']]>'), pth);
          id := pth;
        end
        else begin
          pth := NormalPath(GetDirWorkPath)+jmSouboru;
          StringBase64ToBinaryFile(StrBetween(stVeta, '<![CDATA[', ']]>'), pth);
          id := SaveDocumentToDB(pth);
        end;
        //
        IncEPOPril_InsertFiles(id, docTyp, kod, nazev, invalidFileCount);
      end;
    end;
  finally
    StopWait;
  end;
end;

function UpravDic(D: string): string;
begin
  Result := UpperCase(D);
  if IsDigit(Copy(Result, 1, 2)) then
    Result := 'CZ'+Result;
end;

function ImportCheckIcoDic(ANode: string): boolean;
var
  stVeta, dic, dicC: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stVeta:=''; dic:=''; dicC:=''; 
  //--- konec automaticke inicializace
  Result := True;
  //
  stVeta := XMLAttributesLists(ANode,'VetaP', 1);
  //
  if stVeta <> '' then begin
    dic := XMLAttribToStr(stVeta,'dic');
    //
    if dic <> '' then begin
      dicC := ClientParam('TIN');
      if dicC <> '' then begin
        if (UpravDic(dic) <> UpravDic(dicC)) and
           (MsgBoxAskButtons(Caption,
              Format('DIČ "%s" v importovaném souboru se liší od DIČ "%s" v nastavení klienta.'+cCRLF+
              'Chcete přesto soubor naimportovat?', [UpravDic(dic), dicC]), '&Ano', '&Ne', '', 2, 75) <> 1) then
          Result := False;
      end;
    end;
  end;
end;

function DoImportXmlDP(
  AFileName: string;
  AIsEPOImportFromKlient: boolean;
  ANo: integer): boolean;
var
  sl: TStringList;
  stDokument, stPrilohy, prilDir: string;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  stDokument:=''; stPrilohy:=''; prilDir:=''; 
  //--- konec automaticke inicializace
  StartWait;
  Result := True;
  sl := TStringList.Create;
  try
    sl.Text := XMLEncode(AFileName);
    stDokument := XMLNode(sl.Text,'DPHDP3', 1);
    if stDokument='' then begin
      MsgBoxWarn(Caption, 'Načtení dat se nezdařilo z důvodu chybné struktury souboru.'+#13#10+
                          'Zkontrolujte načítaný soubor a opakujte akci znovu.', MB_OK);
      Result := False;
      Exit;
    end;
    //

    Application.ProcessMessages;
    if ANo=0 then begin
      if not ImportCheckIcoDic(stDokument) then begin
        Result := False;
        Exit;
      end;
      //
      mtValuesClearFields;
      ImportVetaD(stDokument);
      ImportVetaP(stDokument);
    end;

    ImportVeta1(stDokument);
    ImportVeta2(stDokument);
    ImportVeta3(stDokument);
    ImportVeta4(stDokument);
    ImportVeta5(stDokument);
    ImportVeta6(stDokument);
    ImportVetaR_TextPril(stDokument, 'D', 'meDuvodyDDP');
    ImportVetaR_TextPril(stDokument, 'O', '');

    stPrilohy := XMLNode(stDokument,'Prilohy', 1);
  finally
    sl.Free;
    StopWait;
  end;
  //
  if XMLNode_Count(stPrilohy,'ObecnaPriloha') > 0 then begin
    if (not RunAsStandalone) then begin
      if not AIsEPOImportFromKlient then
        MsgBoxInfo(Caption,
                   Format('Importovaný soubor "%s" obsahuje obecné přílohy.'+#13#10+
                   'Přílohy budou vloženy do dokumentů programu a zařazeny do seznamu příloh v tomto formuláři.', [AFileName]), MB_OK);
      ImportObecnePrilohy(stPrilohy, 'ObecnaPriloha', '');
    end
    else begin
      if MsgBoxAsk(Caption,
        Format('Importovaný soubor "%s" obsahuje obecné přílohy, '+
               'chcete tyto přílohy uložit do složky na disku?', [AFileName]), MB_YESNO)=IDYES then begin
        if SelectDir('Vyberte složku pro uložení příloh:', '', prilDir) then begin
          ImportObecnePrilohy(stPrilohy, 'ObecnaPriloha', prilDir);
        end;
      end;
    end;
  end;
end;

procedure ImportXmlDP;
var
  filtr: string;
  i: integer;
begin
  //--- inicializace vlozena automaticky pri prevodu do TMS ---
  filtr:=''; 
  i:=0; 
  //--- konec automaticke inicializace
  Gsl.Clear;
  if (IsEPOImportFromKlient) and (FileExists(GEPOFilePath)) then begin
    if not DoImportXmlDP(GEPOFilePath, True, 0) then
      DoCancelEditForm;
  end
  else begin
    if mtValues.ReadOnly then begin
      MsgBoxInfo(Caption, 'Formulář je uzamčen proti změnám, načtení dat nelze provést!', MB_OK);
      Exit;
    end;
    // 
    {24.11.2020 (Marek) - odstraneno dle nametu #3873
    if MsgBoxAsk(Caption,'Chcete načíst data ze souboru ve formátu EPO?'+#13#10+
                 'Upozornění: během načtení dojde k přepsání všech údajů ve formuláři.',MB_YESNO)=IDYES then begin}
      filtr:=OpenDialog1.Filter;
      SetMultilineOpenDialog(TRUE);
      OpenDialog1.DefaultExt := '.XML';
      OpenDialog1.Filter := 'Soubory XML (*.xml)|*.xml'+
                            '|Všechny soubory (*.*)|*.*';
      if OpenDialog1.Execute then begin
        //OpenDialog1.Files.Add('D:\Downloads\DPH_2017_12.xml');
        Application.ProcessMessages;

        for i := 0 to OpenDialog1.Files.Count - 1 do begin //pozn.: nelze nijak zjistit, ktery soubor byl vybran prvni
          if not DoImportXmlDP(OpenDialog1.Files[i], False, i) then
            Exit;
        end;
        ReloadListBoxes;

        if Gsl.Text <> '' then
          MsgBoxWarn(Caption, 'Načtení dat ze souboru bylo dokončeno.'+#13#10+
                              'Seznam údajů, které se nepodařilo naimportovat:'+#13#10#13#10+
                     Gsl.Text, MB_OK)
        else
          MsgBoxInfo(Caption, 'Načtení dat ze souboru bylo úspěšně dokončeno.', MB_OK);
      end;

      OpenDialog1.Filter:=filtr;
      SetMultilineOpenDialog(False);
    //end;
  end;
  if IsEPOImportFromKlient then
    GEPOFilePath := '';
end;

procedure OnClick_btImportXmlDP;
begin
  ImportXmlDP;
end;

procedure OnClick_btScript;
begin
  RunDotNetStript(':con','C:\Q Vyvoj\FormAsistent\DataPrg\Defs\DPH_2016_05.xml',true);
end;

(*
:con:
using System;
using System.Xml;
using System.IO;

namespace XMLConversionToUTF8
{
    class Program
    {
        static void Main(string[] args)
        {
            SetCurrentDir();
            string[] p = Environment.GetCommandLineArgs();
            if (p.Length > 1)   //podminka je kvuli Visual studiu, v FA je delka vzdy 4 (a posledni argument je prave xml soubor)
                ConvertXMLEncoding(p[p.Length - 1]);
            //Console.ReadKey();
        }

        private static void SetCurrentDir()
        {
            //D:\Vyvoj\FormStudioFull\FA\Utils\CScript
            //D:\Vyvoj\FormStudioFull\FA\Work
            string path = System.IO.Path.GetDirectoryName(Environment.GetCommandLineArgs()[0]); //cesta ke slozce CScript
            path = Directory.GetParent(path).FullName; //cesta ke slozce Utils
            path = Directory.GetParent(path).FullName; //cesta ke slozce FS
            //
            string instini = path + "\\instparam.ini"; //soubor instparam.ini ve slozce FS
            if (File.Exists(instini))
            {
                string id = GetIniValue(instini, "ONEDIR"); //pokud se jedna o instalaci do Program Files, tak lezi Work v %APPDATA%
                if (String.Equals(id, "0"))
                {
                    string loc = "CZ";
                    instini = path + "\\Localization.ini"; //soubor Localization.ini ve slozce FS
                    if (File.Exists(instini))
                    {
                        id = GetIniValue(instini, "LocalVersion");
                        if (String.Equals(id, "S"))
                            loc = "SK";
                    }
                    path = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + "\\Kastner software\\Form Studio " + loc; //C:\Users\bily\AppData\Roaming+...
                }
            }
            path += "\\Work";
            //Console.WriteLine(path);
            try
            {
                Directory.SetCurrentDirectory(path);
            }
            catch (DirectoryNotFoundException)
            {
                //Console.WriteLine("The specified directory does not exist. {0}", e);
            }
            catch (ArgumentException)
            {
            }
        }

        private static string GetIniValue(string filename, string ident)
        {
            if (File.Exists(filename))
            {
                string line;
                string id;
                Char charRange = '=';
                int startIndex;
                StreamReader file = new StreamReader(filename);
                while ((line = file.ReadLine()) != null)
                {
                    startIndex = line.IndexOf(charRange);
                    if (startIndex > -1)
                    {
                        id = line.Substring(0, line.IndexOf(charRange));
                        if (String.Equals(id, ident))
                            return line.Substring(line.IndexOf(charRange)+1, 1);
                    }
                }

                file.Close();
            }
            return "";
        }

        private static XmlDocument ChangeXmlEncoding(XmlDocument xmlDoc, string newEncoding)
        {
            if (xmlDoc.FirstChild.NodeType == XmlNodeType.XmlDeclaration)
            {
                XmlDeclaration xmlDeclaratitady něvo napíšeme          on = (XmlDeclaration)xmlDoc.FirstChild;
                xmlDeclaration.Encoding = newEncoding;
            }
            return xmlDoc;
        }

        public static void ConvertXMLEncotady něvo napíšeme          ding(string filename)
        {
            tonení nic if (filename.Length > 0)// koment
            tonení nic {// koment
                string sadkooooooooooolen = Path.GetFileName(filename);// koment
                File.DeledkoooooooooooleneFile);
                if (File.dkooooooooooolen(filenatady něvo napíšeme          me))
                {
                    XmlDodkoooogggggggggaagggggoooolen doc = new XmlDocument();tady něvo napíšeme          
                    doc.Ldkoooogggggggggoooooolenlename);
                    doc =dkooooogfffffffoooooleneXmlEncoding(doc, "UTF-8");
                    strindkooooogfffffffooooolenText = doc.OuterXml;
                    if (rdkooooogfffffffooooolent.Length > 0)
                        File.WrigfffffffeAllText(saveFile, readText);
                }
            }
        }
    }
}
:con:
*)

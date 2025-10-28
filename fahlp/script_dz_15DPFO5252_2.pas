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

msg(MtValues.Fields[15].Value * 10);
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
  //nemazat!!!!!!!!!!!!!!!!!!!
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
  chk('CisFU',[:CisFU:]='',Warn004);
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

{ 3.9.2020 13:13:29 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in v CreateExportTextHbABO doplnena podminka pro CS, v CreateExportTextHbMCC doplnen pro Oberbank export udaj "oznaceni prijemce"  }
{ 21.2.2019 14:06:15 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Doplnen novy format CSV Air Bank  }
{ 19.12.2018 15:04:21 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in #2999 - v CreateExportTextHbABO doplnena podminka pro KB  }
{ 13.12.2018 12:57:43 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in zmena Homebanking na Internetbanking  }
{ 3.10.2018 15:05:55 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in uprava resourcestringu  }
{ 3.10.2018 12:38:43 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in doplneny exporty CSV FIO, API FIO a SEPA  }
{ 22.8.2018 10:20:35 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in zarazeni do projektu  }
// QaCPrevPrik
//
// exporty prikazu k uhrade - homebanking
//
//
// autor:  Marek Bily
// historie: 180814 zalozeno (presunuto z ECPrevPrik)
//
{$INCLUDE QGSwitches.inc}

unit QaCPrevPrik;

interface

uses
  Controls, SysUtils, Db, DbTables, Dialogs, Math, Classes, Windows, Forms,
{$IFDEF cdUcetnictvi}
  QaLSpolUtils, SharedUtils, JclDotNet,
{$ELSE}
  IBFSender_TLB,
{$ENDIF}
  JclStrings, JclSysInfo, Registry, ShellApi;

function CreateExportTextHB(const ABaUcet,
  AKodBanky, AFormatHB: string;
  out AOutText, AMsg: string): boolean;
procedure OdeslatPPFioAPI(const AXmlFile, AFileFormat, AToken: string);

implementation

uses
{$IFDEF cdUcetnictvi}
  DatamodC, DataModL, FDialogs, QBoFirma, FSysUtils;
{$ELSE}
  ComObj, DatamodPrevPrik, FCommonUtils, FScriptUtils;
{$ENDIF}

//pouze pro FA
{$IFNDEF cdUcetnictvi}
const
  //formaty homebankingu - prevzato z dmL
  cFormatHbABO='ABO';
  cFormatHbABOOL='ABOOL';
  cFormatHbMBEST='MBEST';
  cFormatHbGEMINI='GEMINI';
  cFormatHbMCC='MCC';
  cFormatHbCITIBANK='CITIBANK';
  cFormatHbXMLCSOB='XML CSOB';
  cFormatHbTXTCSOB='TXT CSOB';
  cFormatHbXMLGEMB='XML GE-MB';
  cFormatHbCSVEQUA='CSV EQUA';
  cFormatHbZB='ZB';
  cFormatHbTXTPBGPE='TXT GPE';
  cFormatHbCITIDIRECT='CITIDIRECT';
  cFormatHbCSVRB='CSV RB';
  cFormatHbCSVCSOB='CSV CSOB';
  cFormatHbCSVFIO='CSV FIO';
  cFormatHbAPIFIO='API FIO';
  cFormatHbSEPA='SEPA';
  cFormatHbCSVAIRBANK='CSV AIR';
{$ENDIF}


resourcestring
  SLmsgPPErrExport = 'Chyba pøi exportu: %s. Export nebyl proveden.';
  SLmsgPPExportBreaked = 'Export pøíkazu k úhradì byl pøerušen uživatelem.';
  SLmsgSEPAChybiFirma = 'Pro export SEPA pøíkazu je nutné ve všech položkách vyplnit údaj %s.';
  SLmsgFioApiMsgCaption = 'Odeslání pøíkazu k úhradì pøes FIO API';
  SLmsgFioApiExportOk = 'Odeslání pøíkazu k úhradì pøes FIO API bylo provedeno. Pøíkaz je tøeba autorizovat v internetovém bankovnictví.';
  SLmsgFioApiErr409 = 'Doporuèený interval mezi jednotlivými pokusy o odeslání pøíkazù je 30 sekund.';
  SLmsgFioApiErr500 = 'Token pro komunikaci pøes FIO API v internetovém bankovnicví neexistuje nebo není aktivní.';
{$IFDEF cdUcetnictvi}
  SLmsgFioApiErrToken = 'Token pro komunikaci pøes FIO API není zadán, nebo má chybnou délku, zkontrolujte jej v Nastavení firmy, v èásti Internetbanking.';  
{$ELSE}
  SLmsgFioApiErrToken = 'Token pro komunikaci pøes FIO API není zadán, nebo má chybnou délku.';
{$ENDIF}
  SLmsgFioApiErrExport = 'Odeslání pøíkazu k úhradì pøes FIO API nebylo provedeno z dùvodu následujících chyb:';
  SLmsgFioApiErrPolozky = 'Chyby v položkách pøíkazu k úhradì:';
  SLmsgFioApiErrPolozka = 'Položka è. %s - %s';

//StrPadLeftZero (puvodne PadLeftZero v FSysUtils)
//  vraci retezec AValue doplneny zleva znakem '0' do delky ALength
function StrPadLeftZero(const AValue: string; ALength: integer): string;
begin
  Result := StrPadLeft(AValue, ALength, '0');
end; {StrPadLeftZero}

function NormBaUcetPP(const AUcet: string): string;
{$IFNDEF cdUcetnictvi}
var
  l: integer;
  predcisli, zaklad: string;
{$ENDIF}
begin
{$IFDEF cdUcetnictvi}
  Result := NormBaUcet(AUcet);
{$ELSE}
  l := Length(AUcet);
  if l >= 4 then //vyhodime pomlcku, ktera je max tri znaky od konce
    zaklad := Copy(AUcet, 1, l - 4) + Replace('-', Copy(AUcet, l - 3, maxint),
      '')
  else
    zaklad := AUcet;
  //
  l := Pos('-', zaklad);
  if l > 0 then begin //kdyz ucet obsahuje nyni pomlcku, ma predcisli
    predcisli := Copy(zaklad, 1, l - 1);
    zaklad := Copy(zaklad, l + 1, maxint);
    Result := StrPadLeftZero(predcisli, 6) + '-' + StrPadLeftZero(zaklad, 10);
  end
  else
    Result := Copy(StrPadLeftZero(zaklad, 16), 1, 6) + '-' +
      Copy(StrPadLeftZero(zaklad, 16), 7, 10);
{$ENDIF}
end; {NormBaUcetPP}

function PrekodujCisloUctuPP(const u: string; AInnerToEdit: boolean): string;
begin
{$IFDEF cdUcetnictvi}
  Result := PrekodujCisloUctu(u, AInnerToEdit);
{$ELSE}
  if Length(u) = 16 then
    if AInnerToEdit then
      Result := u[11] + u[12] + u[13] + u[14] + u[15] + u[16] +
        u[5] + u[6] + u[7] + u[8] + u[9] + u[4] + u[10] + u[2] + u[3] + u[1]
    else
      Result := u[17] + u[15] + u[16] + u[13] + u[8] + u[9] + '-' +
        u[10] + u[11] + u[12] + u[14] + u[1] + u[2] + u[3] + u[4] + u[5] + u[6]
  else
    Result := '';
{$ENDIF}
end; {PrekodujCisloUctuPP}

function LookupExPP(ATable: TTable;
  const AKeyFields: string;
  const AKeyValues: Variant;
  const AResultField: string;
  ADefaultResult: Variant;
  ADisconnectMaster: boolean = TRUE;
  ADisconnectFilter: boolean = TRUE
  ): Variant;
begin
{$IFDEF cdUcetnictvi}
  Result := FSysUtils.LookupEx(ATable, AKeyFields, AKeyValues, AResultField,
    ADefaultResult, ADisconnectMaster, ADisconnectFilter);
{$ELSE}
  Result := '';  //je pouzito jen ve funkci GetNazevPrijemce, ktera se v FA nepouziva
{$ENDIF}
end; {LookupExPP}

function AskIntPP(const ACaption: string;
                const ALabel: string; var AValue: integer): TModalResult;
begin
{$IFDEF cdUcetnictvi}
  Result := AskInt(ACaption,[mbOK,mbCancel],mbOK,mbCancel,ALabel,AValue);
{$ELSE}
  Result := AskInt(ACaption,ALabel,AValue);
{$ENDIF}
end;

function AskStrPP(const ACaption: string;
                const ALabel: string; var AValue: string): TModalResult;
begin
{$IFDEF cdUcetnictvi}
  Result := AskStr(ACaption,[mbOK,mbCancel],mbOK,mbCancel,ALabel,AValue);
{$ELSE}
  Result := AskStr(ACaption,ALabel,AValue);
{$ENDIF}
end;

function TestAndRegisterIBFSender(ASilent: boolean; out AMsg: string): boolean;
{$IFNDEF cdUcetnictvi}
var
  ibSender, ibSender1: TIBFMainLib;
  res, pth, pth1: string;
  resp, code: WideString;

  function IsDotNet2Installed: boolean;
  begin
    Result:=FALSE;
    with TRegistry.Create do try
      try
        RootKey := HKEY_LOCAL_MACHINE;
        //Result:=KeyExists('SOFTWARE\Microsoft\.NETFramework\Policy\v2.0');
        Result:=true; // Je potreba pro beh pod Win 8
      except
      end;
    finally
      Free;
    end;
  end;
{$ENDIF}

begin
{$IFNDEF cdUcetnictvi}
  Result:=FALSE;
  AMsg:='';
  //Framework
  if not IsDotNet2Installed then begin
    AMsg:='Není nainstalován .NET framework (4.5 nebo vyšší) potøebný pro komunikaci s datovou schránkou. Nainstalujte jej. '+
      'Instalaèní soubor .NET framework najdete na www.microsoft.cz.';
    if not ASilent then
      MsgBoxErr(SLmsgFioApiMsgCaption, AMsg, MB_OK);
    EXIT;
  end;
  //ibSender
  ibSender:= TIBFMainLib.Create(nil);
  try try
    res := ibSender.ToString;
    Result:=TRUE;
  except
    //Regasm
    pth:=GetWindowsFolder + '\Microsoft.NET\Framework\v4.0.30319\regasm.exe';
    if not FileExists(pth) then begin
      AMsg:='Nenalezen program Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe. Patrnì není k dispozici .NET framework.';
      if not ASilent then
        MsgBoxErr(SLmsgFioApiMsgCaption, AMsg, MB_OK);
      EXIT;
    end;
    pth1:=ExtractFilePath(Application.ExeName)+'IBFSender.dll';
    if not FileExists(pth1) then begin
      AMsg:='Nenalezena knihovna IBFSender.dll ve složce s programem. Problém patrnì odstraníte reinstalací programu.';
      if not ASilent then
        MsgBoxErr(SLmsgFioApiMsgCaption, AMsg, MB_OK);
      EXIT;
    end;
    ShellExecute(0, nil, PChar('"'+pth+'"'),
      PChar('"'+pth1+'"'), nil, SW_SHOWNORMAL);
    Sleep(3000);

    ibSender1:= TIBFMainLib.Create(nil);
    try try
      res:=ibSender1.ToString;
      if res<>'' then
        Result:=TRUE;
    except
      on E: Exception do begin
        AMsg:='Objekt IBFSender.dll není zaregistrován. Restartujte programu a opakujte odeslání. '+
          'Pokud bude problém pøetrvávat, kontaktujte technickou podporu. Chyba: '+E.Message;
        if not ASilent then
          MsgBoxErr(SLmsgFioApiMsgCaption, AMsg, MB_OK);
      end;
    end
    finally
      ibSender1.Free;
      ibSender1:=nil;
    end;
  end
  finally
    ibSender.Free;
    ibSender:=nil;
  end;
{$ENDIF}
end;

function SendPostFioAPI(const AXmlFile, AFileFormat, AToken: string;
                        out AResponse: string;
                        out AStatusCode: string): boolean;
var
{$IFDEF cdUcetnictvi}
  Host: TJclClrHost;
  Obj: OleVariant;
{$ELSE}
  ibSender: TIBFMainLib;
  res, code: WideString;
{$ENDIF}
begin
  Result := False;
  try
  {$IFDEF cdUcetnictvi}
    Host := TJclClrHost.Create('v4.0.30319');
    try
      Host.Start();
      Obj := Host.DefaultAppDomain.CreateInstance('IBFSender','FIOSender.IBFMainLib').UnWrap();
      Result:=Obj.SendPost(AXmlFile, AFileFormat, AToken, AResponse, AStatusCode);
    finally
      Host.Stop();
      Host.Free;
      Host:=Nil;
    end;
  {$ELSE}
    if TestAndRegisterIBFSender(False, AResponse) then begin
      ibSender:= TIBFMainLib.Create(nil);
      try
        Result:=ibSender.SendPost(AXmlFile, AFileFormat, AToken, res, code);
        AResponse := res;
        AStatusCode := code;
      finally
        ibSender.Free;
      end;
    end;
  {$ENDIF}
  except
    on E : Exception do  begin
      AResponse:='Chyba: Nepodaøila se inicializace'#13#10+E.Message;
      Result := False;
    end;
  end;
end;

procedure OdeslatPPFioAPI(const AXmlFile, AFileFormat, AToken: string);
var
  response, code, errMsg, detNo: string;
  slOD: TStringList; //ordersDetails
  slMsg: TStringList; //message v ordersDetails
  p, i, y: integer;
  odeslano: boolean;

const
  cOddMsg = '||'; //oddelovac jednotlivych chyb (message) - musi byt shodny s oddelovacem v IBFSender.dll
begin
  if Length(AToken) <> 64 then begin
    MsgBoxErr(SLmsgFioApiMsgCaption, SLmsgFioApiErrToken, MB_OK);
    EXIT;
  end;
  try
    StartWait;
    try
      odeslano := SendPostFioAPI(AXmlFile, AFileFormat, AToken, response, code);
    finally
      StopWait;
    end;
    //
    if odeslano then begin
      if GetStringLineValue(response, 'errorCode') = '0' then
        MsgBoxInfo(SLmsgFioApiMsgCaption, SLmsgFioApiExportOk, MB_OK)
      //chybove hlaseni zobrazujeme dle "message" v promenne "response", protoze si nejsme jisti errorCode 1-14
      //(resp tim, pri kterych errorCodech je message v resultu a kdy v ordersDetails)
      else begin
        StartWait;
        slOD := TStringList.Create;
        slMsg := TStringList.Create;
        try
          errMsg := SLmsgFioApiErrExport;
          //message v resultu
          if GetStringLineValue(response, 'message') <> '' then begin
            AddStringLine(errMsg, '');
            AddStringLine(errMsg, Replace(cOddMsg, GetStringLineValue(response, 'message'), cCRLF));
          end;
          //message v ordersDetails
          slOD.Text := GetSection(response, '[ordersDetails]');
          if slOD.Count > 0 then begin
            AddStringLine(errMsg, '');
            AddStringLine(errMsg, SLmsgFioApiErrPolozky);
            for i := 0 to slOD.Count - 1 do begin
              p := Pos('=', slOD[i]);
              if p > 0 then begin
                detNo := Replace('message', Copy(slOD[i], 1, p-1), '');
                slMsg.Text := Replace(cOddMsg, Copy(slOD[i], p+1, MaxInt), cCRLF);
                for y := 0 to slMsg.Count - 1 do
                  if slMsg[y] <> '' then
                    AddStringLine(errMsg, Format(SLmsgFioApiErrPolozka,[detNo, slMsg[y]]));
              end;
            end;
          end;
        finally
          slOD.Free;
          slMsg.Free;
          StopWait;
        end;
        MsgBoxErr(SLmsgFioApiMsgCaption, errMsg, MB_OK);
      end;
    end
    else begin
      if code = '409' then //není dodržen minimální interval 30 sekund mezi stažením dat z banky / uploadem dat do banky u konkrétního tokenu
        MsgBoxErr(SLmsgFioApiMsgCaption, SLmsgFioApiErr409, MB_OK)
      else if code = '500' then //chyba indikuje neexistující nebo neaktivní token
        MsgBoxErr(SLmsgFioApiMsgCaption, SLmsgFioApiErr500, MB_OK)
      else
        raise Exception.Create(response);
    end;
  except
    on E: Exception do
      MsgBoxErr(SLmsgFioApiMsgCaption, Format(SLmsgPPErrExport, [E.Message]), MB_OK);
  end;
end;

function GetNazevPrikazce: string;
begin
{$IFDEF cdUcetnictvi}
  if gBoFirma.Nazev<>'' then
    Result:= AnsiUpperCase(Copy(gBoFirma.Nazev,1,35))
  else
    Result:= AnsiUpperCase(Copy(Trim(gBoFirma.Titul+ ' '+gBoFirma.Jmeno+ ' ' +
                              gBoFirma.Prijmeni),1,35));
{$ELSE}
  with dmPrevPrik do begin
    if gBoFirmaNazev.Value<>'' then
      Result:= AnsiUpperCase(Copy(gBoFirmaNazev.Value,1,35))
    else
      Result:= AnsiUpperCase(Copy(Trim(gBoFirmaTitul.Value+ ' '+gBoFirmaJmeno.Value+ ' ' +
                                gBoFirmaPrijmeni.Value),1,35));
  end;
{$ENDIF}
end; {GetNazevPrikazce}

function GetNazevPrijemce: string;
begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
    if taPrevPrikPFirma.Value<>'' then begin
      if LookupExPP(taAdresy,
           taAdresyFirma.FieldName,taPrevPrikPFirma.Value,
           taAdresyNazev.FieldName,'')<>'' then
        Result:=AnsiUpperCase(LookupExPP(taAdresy,
          taAdresyFirma.FieldName,taPrevPrikPFirma.Value,
          taAdresyNazev.FieldName,''))
      else
        Result:=AnsiUpperCase(Trim(LookupExPP(taAdresy,
          taAdresyFirma.FieldName,taPrevPrikPFirma.Value,
          taAdresyTitul.FieldName,'')+ ' '+
          LookupExPP(taAdresy,
          taAdresyFirma.FieldName,taPrevPrikPFirma.Value,
          taAdresyKrestniJmeno.FieldName,'')+ ' '+
          LookupExPP(taAdresy,
          taAdresyFirma.FieldName,taPrevPrikPFirma.Value,
          taAdresyPrijmeni.FieldName,'')));
      if Result = '' then
        Result := taPrevPrikPFirma.Value;
    end
    else
      Result:='';
  end;    
{$ELSE}
  Result := dmPrevPrik.taPrevPrikPCaFirmaNazev.Value;
{$ENDIF}
end; {GetNazevPrijemce}

function CreateExportTextHbGEMINI(const ABaUcet, AKodBanky: string;
  out AOutText, AMsg: string): boolean;
const
  cGEMINIDateFormat = 'YYMMDD';
var
  dt,dtSp,t,predcisli,baUcet,predcisliVl,baUcetVl,s: string;
  bmp: TBookmarkStr;
  nrecs: integer;
begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
{$ELSE}
  with dmPrevPrik do begin
{$ENDIF}
    AMsg := '';
    Result := TRUE;
    //
    DateTimeToString(dt, cGEMINIDateFormat, Date);
    DateTimeToString(dtSp, cGEMINIDateFormat, taPrevPrikDatumSpl.Value);
    //
    if pos('-', taPrevPrikBaUcet.Value)>0 then begin
      predcisliVl := StrPadLeftZero(
        Copy(taPrevPrikBaUcet.Value,1,pos('-', taPrevPrikBaUcet.Value)-1),6);
      baUcetVl := StrPadLeftZero(
        Copy(taPrevPrikBaUcet.Value,pos('-', taPrevPrikBaUcet.Value)+1,
          length(taPrevPrikBaUcet.Value)-pos('-', taPrevPrikBaUcet.Value)),10);
    end
    else begin
      predcisliVl := StrPadLeftZero('',6);
      baUcetVl := StrPadLeftZero(taPrevPrikBaUcet.Value,10);
    end;
    //polozky
    taPrevPrikP.DisableControls;
    bmp := taPrevPrikP.Bookmark;
    try
      try
        taPrevprikP.First;
        nrecs := 0;
        while not taPrevprikP.EOF do begin
          //
          if taPrevPrikInkaso.Value then
            s := '32'
          else
            s := '11';
          //
          if pos('-', taPrevPrikPBaUcet.Value)>0 then begin
            predcisli := StrPadLeftZero(
              Copy(taPrevPrikPBaUcet.Value,1,pos('-', taPrevPrikPBaUcet.Value)-1),6);
            baUcet := StrPadLeftZero(
              Copy(taPrevPrikPBaUcet.Value,pos('-', taPrevPrikPBaUcet.Value)+1,
                length(taPrevPrikPBaUcet.Value)-pos('-', taPrevPrikPBaUcet.Value)),10);
          end
          else begin
            predcisli := StrPadLeftZero('',6);
            baUcet := StrPadLeftZero(taPrevPrikPBaUcet.Value,10);
          end;
          //
          t := t+Format('%.6d%s%s%-4s%-3s%-4s%-3s%15s%s%10s%10s%10s%6s%10s%6s%10s%s'#13#10,
             [nrecs+1,s,dt,taPrevPrikKodBanky.Value,'',taPrevPrikPKodBanky.Value,'',
             StrPadLeftZero(FloatToStr(taPrevPrikPCastka.Value * 100), 15),dtSp,
             StrPadLeftZero(taPrevPrikPKonSym.Value, 10),
             StrPadLeftZero(taPrevPrikPVarSym.Value, 10),
             StrPadLeftZero(taPrevPrikPSpecSym.Value, 10),predcisliVl,baUcetVl,
             predcisli,baUcet,taPrevPrikPZprava.Value]);
          //
          INC(nrecs);
          taPrevprikP.Next;
        end;
      except
        on E: Exception do begin
          AMsg := Format(SLmsgPPErrExport, [E.Message]);
          Result := FALSE;
          EXIT;
        end;
      end;
    finally
      taPrevPrikP.Bookmark := bmp;
      taPrevPrikP.EnableControls;
    end;
    //
    AOutText :=t;
  end;
end; {CreateExportTextHbGEMINI}
  
function CreateExportTextHbABO(const ABaUcet, AKodBanky: string;
  AVnitrniFormatUctu: boolean;
  out AOutText, AMsg: string): boolean;
const
  cABODateFormat = 'DDMMYY';
  cKodBankyUnionBanka = '3400';
  cKodBankyKB = '0100';
  cKodBankyeBanka = '2400';
  cKodBankyRB = '5500';
  cKodBankyCS = '0800';
  cKodBankyCSOB = '0300';
  cKodBankyFIO = '2010';
var
  t, dt, zprava, baUcet, cisloSouboruKB: string;
  nKB: integer;
  bmp: TBookmarkStr;
begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
{$ELSE}
  with dmPrevPrik do begin
{$ENDIF}
    AMsg := '';
    Result := TRUE;
    //
    DateTimeToString(dt, cABODateFormat, Date);
    //UHL - hlavièka souboru
    if AKodBanky=cKodBankyUnionBanka then
      t := Format('UHL1%-s%-20s0000000000000000000000000000'#13#10, [dt,
        taFirmaUctZkrNazev.Value])
    else if (AKodBanky=cKodBankyeBanka) or (AKodBanky=cKodBankyRB) then
      t := Format('UHL1%-s%-20s1234567890001999111111222222'#13#10, [dt,
        Replace('@',Uppercase(taFirmaUctZkrNazev.Value),#0)])
    else if (AKodBanky=cKodBankyFIO) then
      t := Format('UHL1%-s%-20s0000000000%-3s%-3s'#13#10, [dt,
        taFirmaUctZkrNazev.Value, {taFirmaUctCisloKlienta.Value,}
          StrPadLeftZero(taFirmaUctIntervalOd.Value, 3),
          StrPadLeftZero(taFirmaUctIntervalDo.Value, 3)])
    else if (AKodBanky=cKodBankyKB) then
      t := Format('UHL1%-s%-20s%-10s%-3s%-3s%-6s%-6s'#13#10, [dt,
          taFirmaUctZkrNazev.Value, taFirmaUctCisloKlienta.Value,
          StrPadLeftZero(taFirmaUctIntervalOd.Value, 3),
          Cond(taFirmaUctIntervalDo.AsString <> '', StrPadLeftZero(taFirmaUctIntervalDo.Value, 3), '999'),
          taFirmaUctPevnaCastKlice.Value, ''])          
    else
      t := Format('UHL1%-s%-20s%-10s%-3s%-3s%-6s%-6s'#13#10, [dt,
        taFirmaUctZkrNazev.Value, taFirmaUctCisloKlienta.Value,
          taFirmaUctIntervalOd.Value, taFirmaUctIntervalDo.Value,
          taFirmaUctPevnaCastKlice.Value, '' {tajny kod}]);
    //HSO - hlavièka úèetního souboru
    if taPrevPrikInkaso.Value then
      dt := '1502'
    else
      dt := '1501';
    if (AKodBanky=cKodBankyUnionBanka) or (AKodBanky=cKodBankyCSOB) then
      t := t + Format('1 %-4s 000000 %-4s'#13#10, [dt,
        taPrevPrikKodBanky.Value])
    else if (AKodBanky=cKodBankyeBanka) or (AKodBanky=cKodBankyRB) then
      t := t + Format('1 %-4s 111111 %-4s'#13#10, [dt,
        taPrevPrikKodBanky.Value])
    else if (AKodBanky=cKodBankyKB) or (AKodBanky=cKodBankyFIO) then begin
      nKB:=1;
      if AskIntPP('Zadejte',
                  'Èíslo úèetního souboru (poøadí pøíkazu k úhradì v rámci dne)',
                  nKB)=mrOK then
        cisloSouboruKB:=StrPadLeftZero(IntToStr(nKB),3)
      else begin
        //cisloSouboruKB:='001';
        AMsg := SLmsgPPExportBreaked;
        Result := False;
        EXIT;
      end;
      t := t + Format('1 %-4s %-3s%-3s %-4s'#13#10, [dt,
        cisloSouboruKB,
        taFirmaUctCisloPobocky.Value, taPrevPrikKodBanky.Value]);
    end
    else
      t := t + Format('1 %-4s %-3s%-3s %-4s'#13#10, [dt,
        taFirmaUctIntervalOd.Value,
        taFirmaUctCisloPobocky.Value, taPrevPrikKodBanky.Value]);
    //HSK - hlavièka skupiny
    DateTimeToString(dt, cABODateFormat, taPrevPrikDatumSpl.Value);
    t := t + Format('2 %s %.0f %s'#13#10,
      [NormBaUcetPP(taPrevPrikBaUcet.Value),
      taPrevPrikCelkem.Value * 100, dt]);
    //POL - položky
    taPrevPrikP.DisableControls;
    bmp := taPrevPrikP.Bookmark;
    try
      try
        taPrevprikP.First;
        while not taPrevprikP.EOF do begin
          if taPrevPrikPZprava.Value <> '' then begin
            zprava := taPrevPrikPZprava.Value;
            zprava := Replace('|', zprava, #0);
            zprava := Replace('#', zprava, #0);
            zprava := Replace('~', zprava, #0);
            zprava := 'AV: ' + zprava;
          end
          else
            zprava := '';
          if AVnitrniFormatUctu then
            baUcet := PrekodujCisloUctuPP(taPrevPrikPBaUcet.Value, FALSE)
          else
            baUcet := taPrevPrikPBaUcet.Value;
          if AKodBanky=cKodBankyUnionBanka then
            t := t + Trim(Format('%s %.0f %s %-4s%-4s %s',
              [NormBaUcetPP(baUcet),
               taPrevPrikPCastka.Value * 100,
               taPrevPrikPVarSym.Value,
               taPrevPrikPKodBanky.Value,
               taPrevPrikPKonSym.Value,
               Math.Max(0,StrToIntSafe(taPrevPrikPSpecSym.Value))]))+#13#10
          else if AKodBanky=cKodBankyCS then
            t := t + Trim(Format('%s %.0f %s %-4s%-4s %s %s',
              [NormBaUcetPP(baUcet),
               taPrevPrikPCastka.Value * 100,
               taPrevPrikPVarSym.Value,
               taPrevPrikPKodBanky.Value,
               StrPadLeftZero(taPrevPrikPKonSym.Value,4),
               StrPadLeftZero(taPrevPrikPSpecSym.Value,10), //5.2.2020 - dle uzivatelky nelze prikaz nacist do Sporky, pokud tam neni SS
               zprava]))+#13#10
          else
            t := t + Trim(Format('%s %.0f %s %-4s%-4s %s %s',
              [NormBaUcetPP(baUcet),
               taPrevPrikPCastka.Value * 100,
               taPrevPrikPVarSym.Value,
               taPrevPrikPKodBanky.Value,
               StrPadLeftZero(taPrevPrikPKonSym.Value,4),
               taPrevPrikPSpecSym.Value,
               zprava]))+#13#10;
          //
          taPrevprikP.Next;
        end;
      except
        on E: Exception do begin
          AMsg := Format(SLmsgPPErrExport, [E.Message]);
          Result := FALSE;
          EXIT;
        end;
      end;
    finally
      taPrevPrikP.Bookmark := bmp;
      taPrevPrikP.EnableControls;
    end;
    //KSK - konec skupiny
    t := t + '3 +'#13#10;
    //KSO konec souboru
    t := t + '5 +'#13#10;
    //
    AOutText := t;
  end;
end; {CreateExportTextHbABO}

function CreateExportTextHbMBEST(const ABaUcet, AKodBanky: string;
  out AOutText, AMsg: string): boolean;
const
  cMBESTDateFormat = 'YYMMDD';
  cMBESTFullDateFormat = 'YYYYMMDD';
  cMBESTIsoKodMeny = 'CZK';
var
  t, dt, dtSpl, s, zprava: string;
  bmp: TBookmarkStr;
  nrecs, nKB: integer;
  kontrolniSoucet: double;
begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
{$ELSE}
  with dmPrevPrik do begin
{$ENDIF}
    AMsg := '';
    Result := TRUE;
    //
    DateTimeToString(dt, cMBESTDateFormat, Date);
    //hlavicka
    t := Format('HI000%6s%6s%-30s%-10s%-20s%274s'#13#10, [
      StrPadLeftZero(taFirmaUctCisloStanice.Value, 6),
        dt, '', taFirmaUctCisloKlienta.Value,
        taFirmaUctIdentPorizovatele.Value, '']);
    //polozky
    taPrevPrikP.DisableControls;
    bmp := taPrevPrikP.Bookmark;
    try
      try
        taPrevprikP.First;
        nrecs := 0;
        kontrolniSoucet := 0;
        nKB:=1;
        if AskIntPP('Zadejte',
                    'Poøadí pøíkazu k úhradì v rámci dne (1..99)', nKB)<>mrOK then begin
          AMsg := SLmsgPPExportBreaked;
          Result := False;
          EXIT;
        end;
        while not taPrevprikP.EOF do begin
          if taPrevPrikPZprava.Value <> '' then begin
            zprava := taPrevPrikPZprava.Value;
            zprava := Replace('|', zprava, #0);
            zprava := Replace('#', zprava, #0);
            zprava := Replace('~', zprava, #0);
          end
          else
            zprava := '';
        //detail
          if taPrevPrikInkaso.Value then
            s := '1'
          else
            s := '0';
          DateTimeToString(dt, cMBESTFullDateFormat, Date);
          DateTimeToString(dtSpl, cMBESTFullDateFormat,
            taPrevPrikDatumSpl.Value);
          //
          nKB:=Cond(nKB<1,1,nKB);
          nKB:=Cond(nKB>99,99,nKB);
          //
          t := t + Format('01%.5d%8s%8s%3s%15s%1s0000%10s%-140s000%4s%16s' +
            '%10s%10s%30s000%4s%16s%10s%10s%30s%9s'#13#10,
            [ (nKB-1) * 1000 + nrecs + 1, dt, dtSpl,
              cMBESTIsoKodMeny,
              StrPadLeftZero(FloatToStr(taPrevPrikPCastka.Value * 100), 15),
              s, StrPadLeftZero(taPrevPrikPKonSym.Value, 10), zprava,
              taPrevPrikKodBanky.Value,
              Replace('-', NormBaUcetPP(taPrevPrikBaUcet.Value), ''),
          //
              StrPadLeftZero(taPrevPrikPVarSym.Value, 10),
              StrPadLeftZero(taPrevPrikPSpecSym.Value, 10),
              taPrevPrikPPoznamka.Value,
              taPrevPrikPKodBanky.Value,
              Replace('-', NormBaUcetPP(taPrevPrikPBaUcet.Value), ''),
              StrPadLeftZero(taPrevPrikPVarSym.Value, 10),
              StrPadLeftZero(taPrevPrikPSpecSym.Value, 10),
              '', '']);
          INC(nrecs);
          kontrolniSoucet := kontrolniSoucet + taPrevPrikPCastka.Value;
          taPrevprikP.Next;
        end;
      except
        on E: Exception do begin
          AMsg := Format(SLmsgPPErrExport, [E.Message]);
          Result := FALSE;
          EXIT;
        end;
      end;
    finally
      taPrevPrikP.Bookmark := bmp;
      taPrevPrikP.EnableControls;
    end;
    //paticka
    DateTimeToString(dt, cMBESTDateFormat, Date);
    t := t + Format('TI000%6s%6s%.6d%18s%177s%5s%128s'#13#10, [
      StrPadLeftZero(taFirmaUctCisloStanice.Value, 6),
        dt, nrecs, StrPadLeftZero(FloatToStr(kontrolniSoucet * 100), 18), '',
          '', '']);
    //
    AOutText := t;
  end;
end; {CreateExportTextHbMBEST}

function CreateExportTextHbCITIBANK(const ABaUcet, AKodBanky:
  string;
  out AOutText, AMsg: string): boolean;
const
  cCITIFullDateFormat = 'DDMMYYYY';
var
  t, dtSpl, s, zprava, zprava1, predcisli, baUcet: string;
  z: char;
  bmp: TBookmarkStr;
  nrecs, i: integer;
  kontrolniSoucet: double;
begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
{$ELSE}
  with dmPrevPrik do begin
{$ENDIF}
    AMsg := '';
    Result := TRUE;
    //
    DateTimeToString(dtSpl, cCITIFullDateFormat, taPrevPrikDatumSpl.Value);
    //polozky
    taPrevPrikP.DisableControls;
    bmp := taPrevPrikP.Bookmark;
    try
      try
        taPrevprikP.First;
        nrecs := 0;
        kontrolniSoucet := 0;
        while not taPrevprikP.EOF do begin
          if taPrevPrikPZprava.Value <> '' then begin
            zprava1 := Str1250ToANSI(taPrevPrikPZprava.Value);
            zprava := '';
            for i := 1 to Length(zprava1) do begin
              z := zprava1[i];
              case z of
                'A'..'Z', '0'..'9', '.', '?', '-', '(', ')', '+', ':', '/', ' ':
                  zprava := zprava + z;
                'a'..'z': zprava := zprava + AnsiUpperCase(z);
              end;
            end;
          end
          else
            zprava := '';
        //detail
          if taPrevPrikInkaso.Value then
            s := '2'
          else
            s := '1';
          predcisli := StrTrimCharLeft(Copy(NormBaUcetPP(taPrevPrikPBaUcet.Value), 1, 6), '0');
          baUcet := StrTrimCharLeft(Copy(NormBaUcetPP(taPrevPrikPBaUcet.Value), 8, 10), '0');
          t := t + Format('%s,"%.3d","%10s","","%8s",%s,' +
            '"%s","%s","%s","%s","%s","%s","%s"'#13#10,
            [s, nrecs + 1,
            Copy(Replace('-', NormBaUcetPP(taPrevPrikBaUcet.Value), ''), 7, 10),
              dtSpl, Replace(',', Format('%.2f', [taPrevPrikPCastka.Value]),
                '.'),
              predcisli, baUcet, taPrevPrikPKodBanky.Value,
                taPrevPrikPKonSym.Value,
              taPrevPrikPVarSym.Value, taPrevPrikPSpecSym.Value, zprava]);
          INC(nrecs);
          kontrolniSoucet := kontrolniSoucet + taPrevPrikPCastka.Value;
          taPrevprikP.Next;
        end;
      except
        on E: Exception do begin
          AMsg := Format(SLmsgPPErrExport, [E.Message]);
          Result := FALSE;
          EXIT;
        end;
      end;
    finally
      taPrevPrikP.Bookmark := bmp;
      taPrevPrikP.EnableControls;
    end;
    //paticka
    t := t + Format('9,"%.3d",%s'#13#10,
      [nrecs + 1, Replace(',', Format('%.2f', [kontrolniSoucet]), '.')]);
    //
    AOutText := t;
  end;
end; {CreateExportTextHbCITIBANK}

function CreateExportTextHbCITIDIRECT(const ABaUcet, AKodBanky:
  string;
  out AOutText, AMsg: string): boolean;
const
  cDateFormat = 'dd"/"mm"/"yy';
  cMena = 'CZK';
var
  t, dtSpl, s, zprava, zprava1, predcisli, baUcet: string;
  z: char;
  bmp: TBookmarkStr;
  i: integer;

  procedure AddStrLine(var AStr: string; const AAddedStrLine: string);
  begin
    if AStr = '' then
      AStr := AAddedStrLine
    else
      AStr := AStr + cCRLF + AAddedStrLine;
  end;

  procedure AddStrValue(var AStr: string; AIndex, AValue: string);
  begin
    if AValue<>'' then begin
      AddStrLine(AStr, AIndex + cCRLF + AValue);
    end;
  end;

begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
{$ELSE}
  with dmPrevPrik do begin
{$ENDIF}
    AMsg := '';
    Result := TRUE;
    //
    DateTimeToString(dtSpl, cDateFormat, taPrevPrikDatumSpl.Value);
    //polozky
    taPrevPrikP.DisableControls;
    bmp := taPrevPrikP.Bookmark;
    try
      try
        taPrevprikP.First;
        t := '';
        while not taPrevprikP.EOF do begin
          if taPrevPrikPZprava.Value <> '' then begin
            zprava1 := Str1250ToANSI(taPrevPrikPZprava.Value);
            zprava := '';
            for i := 1 to Length(zprava1) do begin
              z := zprava1[i];
              case z of
                'A'..'Z', 'a'..'z', '0'..'9', '.', '?', '-', '(', ')', '+', ':', '/', ' ':
                  zprava := zprava + z;
              end;
            end;
          end
          else
            zprava := '';
        //detail
          if taPrevPrikInkaso.Value then
            s := '32'
          else
            s := '11';
          predcisli := StrTrimCharLeft(Copy(NormBaUcetPP(taPrevPrikPBaUcet.Value), 1, 6), '0');
          baUcet := StrTrimCharLeft(Copy(NormBaUcetPP(taPrevPrikPBaUcet.Value), 8, 10), '0');
          //
          AddStrValue(t, '0', cMena);
          AddStrValue(t, '1', Replace(DecimalSeparator, Format('%.2f', [taPrevPrikPCastka.Value]), '.'));
          AddStrValue(t, '2', dtSpl);
          AddStrValue(t, '3', Cond(taPrevPrikPDokladS.Value <> '', taPrevPrikPDokladS.Value, '0'));
          AddStrValue(t, '4', Copy(Replace('-', NormBaUcetPP(taPrevPrikBaUcet.Value), ''), 7, 10));
          AddStrValue(t, '10', taPrevPrikPKodBanky.Value);
          AddStrValue(t, '11', baUcet);
          AddStrValue(t, '12', predcisli);
          AddStrValue(t, '13', taPrevPrikPSpecSym.Value);
          AddStrValue(t, '14', taPrevPrikPVarSym.Value);
          AddStrValue(t, '15', predcisli);
          AddStrValue(t, '16', s);
          AddStrValue(t, '17', taPrevPrikPKonSym.Value);
          if zprava <> '' then begin       //zprava pro prijemce ma format 4x35 znaku
            AddStrValue(t, '20', zprava);  //radek 1 obsahuje zpravu
            t := t+cCRLF+cCRLF+cCRLF;      //dalsi 3 radky jsou prazdne
          end;
          AddStrLine(t, '-1');             //kazdy prikaz je zakoncen -1

          taPrevprikP.Next;
        end;
      except
        on E: Exception do begin
          AMsg := Format(SLmsgPPErrExport, [E.Message]);
          Result := FALSE;
          EXIT;
        end;
      end;
    finally
      taPrevPrikP.Bookmark := bmp;
      taPrevPrikP.EnableControls;
    end;
    AOutText := t;
  end;
end; {CreateExportTextHbCITIDIRECT}

function CreateExportTextHbMCC(const ABaUcet, AKodBanky: string;
  out AOutText, AMsg: string): boolean;
const
  cMCCDateFormat = 'YYMMDD';
  cKodBankyCommerz = '6200';
  cKodBankyOberbank = '8040';
var
  dt,dtSp,t,predcisli,baUcet,predcisliVl,baUcetVl,s, specSym, varSym, oznUctu: string;
  NazevPrikazce, NazevPrijemce,sS1, sS3, zprava: string;
  bmp: TBookmarkStr;
  nrecs,nKB: integer;
  xNazevPrikazce, xNazevPrijemce, xbaUcetVl, xpredcisliVl, xpredcisli, xbaUcet, xOznUctuPrikazce, xOznUctuPrijemce: string;
begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
{$ELSE}
  with dmPrevPrik do begin
{$ENDIF}
    AMsg := '';
    Result := TRUE;
    //
    DateTimeToString(dt, cMCCDateFormat, Date);
    DateTimeToString(dtSp, cMCCDateFormat, taPrevPrikDatumSpl.Value);
    //
    if pos('-', taPrevPrikBaUcet.Value)>0 then begin
      predcisliVl := StrTrimCharLeft(
        Copy(taPrevPrikBaUcet.Value,1,pos('-', taPrevPrikBaUcet.Value)-1),'0');
      baUcetVl := StrTrimCharLeft(
        Copy(taPrevPrikBaUcet.Value,pos('-', taPrevPrikBaUcet.Value)+1,
          length(taPrevPrikBaUcet.Value)-pos('-', taPrevPrikBaUcet.Value)),'0');
    end
    else begin
      predcisliVl := '';
      baUcetVl := taPrevPrikBaUcet.Value;
    end;
    oznUctu := taPrevPrikNazevUctu.Value;
    //
    //polozky
    taPrevPrikP.DisableControls;
    bmp := taPrevPrikP.Bookmark;
    try
      try
        taPrevprikP.First;
        nrecs := 0;
        nKB:=1;
        if AskIntPP('Zadejte',
                    'Poøadí pøíkazu k úhradì v rámci dne', nKB)<>mrOK then begin
          AMsg := SLmsgPPExportBreaked;
          Result := False;
          EXIT;
        end;
        while not taPrevprikP.EOF do begin
          //
          if pos('-', taPrevPrikPBaUcet.Value)>0 then begin
            predcisli := StrTrimCharLeft(
              Copy(taPrevPrikPBaUcet.Value,1,pos('-', taPrevPrikPBaUcet.Value)-1),'0');
            baUcet := StrTrimCharLeft(
              Copy(taPrevPrikPBaUcet.Value,pos('-', taPrevPrikPBaUcet.Value)+1,
                length(taPrevPrikPBaUcet.Value)-pos('-', taPrevPrikPBaUcet.Value)),'0');
          end
          else begin
            predcisli := '';
            baUcet :=taPrevPrikPBaUcet.Value;
          end;
          //
          //nazev prikazce u PP/ prijemce u inkasa
          NazevPrikazce:= GetNazevPrikazce;
          if NazevPrikazce = '' then
            NazevPrikazce := ' ';
          //specificky symbol
          if taPrevPrikPSpecSym.Value<> '' then
            specSym:=taPrevPrikPSpecSym.Value
          else
            specSym:='0';
          //variabilni symbol
          if taPrevPrikPVarSym.Value<> '' then
            varSym:=StrPadLeftZero(taPrevPrikPVarSym.Value, 10)
          else
            varSym:='0';
          //
          //nazev prikazce u inkasa/prijemce u PP
          NazevPrijemce:=GetNazevPrijemce;
          NazevPrijemce := Copy(NazevPrijemce,1,35);
          if NazevPrijemce = '' then
            NazevPrijemce := ' ';
          //
          if taPrevPrikPZprava.Value<>'' then
            zprava:=AnsiUpperCase(taPrevPrikPZprava.Value)
          else
            zprava:='';
          //
          if taPrevPrikInkaso.Value then begin
            s := '32'; //inkaso
            xNazevPrikazce:=NazevPrijemce;       // U inkasa se pøehodí informace v
            xNazevPrijemce:=NazevPrikazce;       // polích DI, KI a UD, UK -
            xbaUcetVl:=StrPadLeftZero(baUcet,10);   // pole samotná zùstavají na svých místech
            xbaUcet:=baUcetVl;
            xpredcisliVl:=Trim(predcisli)+' ';
            xpredcisli:=Trim(predcisliVl)+' ';
            xOznUctuPrikazce:='';
            xOznUctuPrijemce:=' '+oznUctu;
          end
          else begin
            s := '11';
            xNazevPrikazce:=NazevPrikazce;
            xNazevPrijemce:=NazevPrijemce;
            xbaUcetVl:=StrPadLeftZero(baUcetVl,10);
            xbaUcet:=baUcet;
            xpredcisliVl:=Trim(predcisliVl)+' ';
            xpredcisli:=Trim(predcisli)+' ';
            xOznUctuPrikazce:=' '+oznUctu;
            xOznUctuPrijemce:='';
          end;
          if AKodBanky<>cKodBankyOberbank then begin //oznaceni uctu exportujeme jen u OberBank
            xOznUctuPrikazce:='';
            xOznUctuPrijemce:='';
          end;
          //
          t:=t+Format('HD:%s %s %-4s %.d %-4s'#13#10+
                      'KC:%s %s %s'#13#10+
                      'UD:%s%s%s'#13#10+
                      //'AD:%s'#13#10+   //30.7.2010 Marek: zmena dle struktury MutiCash v3.2 (pokud nebude problem, tak smazat)
                      'DI:%s'#13#10+
                      'UK:%s%s%s'#13#10+
                      'AK:%s'#13#10+
                      'KI:%s'#13#10+
                      'EC:%s'#13#10+
                      //'ZD:%s'#13#10+
                      'ZK:%s'#13#10+
                      'AV:%s'#13#10,
            [s,dtSp,StrPadLeftZero(taPrevPrikKodBanky.Value,4),nKB,StrPadLeftZero(taPrevPrikPKodBanky.Value,4),
             FloatToStr(taPrevPrikPCastka.Value * 100),'000000','CZK',
             xpredcisliVl,xbaUcetVl,xOznUctuPrikazce,
             //specSym,
             xNazevPrikazce,
             xpredcisli,xbaUcet,xOznUctuPrijemce,
             specSym,
             xNazevPrijemce,
             StrPadLeftZero(taPrevPrikPKonSym.Value, 4),
             //PadLeftZero(taPrevPrikPVarSym.Value, 10),
             varSym,
             zprava]);
          //
          INC(nrecs);
          INC(nKB);
          taPrevprikP.Next;
        end;
      except
        on E: Exception do begin
          AMsg := Format(SLmsgPPErrExport, [E.Message]);
          Result := FALSE;
          EXIT;
        end;
      end;
    finally
      taPrevPrikP.Bookmark := bmp;
      taPrevPrikP.EnableControls;
    end;
    //paticka
    if taPrevPrikInkaso.Value then begin
      sS1:='S1:000000000 000'#13#10;
      sS3:='S3:'+StrPadLeftZero(IntToStr(nrecs), 9)+' '+FloatToStr(taPrevPrikCelkem.Value * 100)+#13#10;
    end
    else begin
      sS1:='S1:'+StrPadLeftZero(IntToStr(nrecs), 9)+' '+FloatToStr(taPrevPrikCelkem.Value * 100)+#13#10;
      sS3:='S3:000000000 000'#13#10;
    end;
    t := t + Format('%s%s',[sS1,sS3]);
    //
    AOutText :=t;
  end;
end; {CreateExportTextHbMCC}

function CreateExportTextHbXMLFIO(const ABaUcet, AKodBanky: string;
  out AOutText, AMsg: string): boolean;
const
  cFIODateFormat = 'YYYY-MM-DD';
  cXML =
    '<?xml version="1.0" encoding="UTF-8"?>'+cCRLF+
    '<Import xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
    'xsi:noNamespaceSchemaLocation="http://www.fio.cz/schema/importIB.xsd">'+cCRLF+
    '<Orders>'+cCRLF+
    '%s'+cCRLF+
    '</Orders>'+cCRLF+
    '</Import>';
  cXMLDomaci =
    '<DomesticTransaction>'+cCRLF+
    '<accountFrom>%s</accountFrom>'+cCRLF+
    '<currency>%s</currency>'+cCRLF+
    '<amount>%s</amount>'+cCRLF+
    '<accountTo>%s</accountTo>'+cCRLF+
    '<bankCode>%s</bankCode>'+cCRLF+
    '<ks>%s</ks>'+cCRLF+
    '<vs>%s</vs>'+cCRLF+
    '<ss>%s</ss>'+cCRLF+
    '<date>%s</date>'+cCRLF+
    '<messageForRecipient>%s</messageForRecipient>'+cCRLF+
    '<comment>%s</comment>'+cCRLF+
    '<paymentType>%s</paymentType>'+cCRLF+
    '</DomesticTransaction>'+cCRLF;
var
  dtSp,t,baUcet,baUcetVl,s, mena: string;
  bmp: TBookmarkStr;
begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
{$ELSE}
  with dmPrevPrik do begin
{$ENDIF}
    AMsg := '';
    Result := TRUE;
    //
    DateTimeToString(dtSp, cFIODateFormat, taPrevPrikDatumSpl.Value);
    //
    baUcetVl := StrTrimCharLeft(Replace('-', NormBaUcetPP(taPrevPrikBaUcet.Value), ''), '0');
    mena := Cond((taPrevPrikMena.Value = 'Kè') or (taPrevPrikMena.Value = ''), 'CZK', taPrevPrikMena.Value);
    //polozky
    taPrevPrikP.DisableControls;
    bmp := taPrevPrikP.Bookmark;
    try
      try
        taPrevprikP.First;
        while not taPrevprikP.EOF do begin
          //
          if taPrevPrikInkaso.Value then
            s := '431022'
          else
            s := '431001';
          //baUcet := StrTrimCharLeft(NormBaUcetPP(taPrevPrikPBaUcet.Value), '0');
          baUcet := NormBaUcetPP(taPrevPrikPBaUcet.Value);
          //
          t := t+Format(cXMLDomaci,
             [baUcetVl, mena, Replace(DecimalSeparator, FloatToStr(taPrevPrikPCastka.Value),'.'),
              baUcet, StrPadLeftZero(taPrevPrikPKodBanky.Value,4),
              taPrevPrikPKonSym.Value, taPrevPrikPVarSym.Value, taPrevPrikPSpecSym.Value,
              dtSp, XMLNormChars(taPrevPrikPZprava.Value), XMLNormChars(taPrevPrikPPoznamka.Value), s]);
          //
          taPrevprikP.Next;
        end;
      except
        on E: Exception do begin
          AMsg := Format(SLmsgPPErrExport, [E.Message]);
          Result := FALSE;
          EXIT;
        end;
      end;
    finally
      taPrevPrikP.Bookmark := bmp;
      taPrevPrikP.EnableControls;
    end;
    //
    AOutText :=AnsiToUTF8(Format(cXML, [t]));
  end;
end; {CreateExportTextHbXMLFIO}

function CreateExportTextHbSEPA(const ABaUcet, AKodBanky: string;
  out AOutText, AMsg: string): boolean;
const
  cDateFormat = 'YYYY-MM-DD';
  cISODateFormat = 'YYYY-MM-DD"T"hh:nn:ss';
  cXMLPP =
    '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'+cCRLF+
    '<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" '+
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
    'xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03 '+
    'pain.001.001.03.xsd">'+cCRLF+
    '<CstmrCdtTrfInitn>'+cCRLF+
    '%s'+cCRLF+  //hlavicka
    '%s'+cCRLF+  //davka
    '</CstmrCdtTrfInitn>'+cCRLF+
    '</Document>';
  cXMLInkaso =
    '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'+cCRLF+
    '<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.008.001.02" '+
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+
    'xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.008.001.02 '+
    'pain.008.001.02.xsd">'+cCRLF+
    '<CstmrDrctDbtInitn>'+cCRLF+
    '%s'+cCRLF+  //hlavicka
    '%s'+cCRLF+  //davka
    '</CstmrDrctDbtInitn>'+cCRLF+
    '</Document>';
  cHlavicka =
    '<GrpHdr>'+cCRLF+                  //zahlavi souboru
    '<MsgId>%s</MsgId>'+cCRLF+         //jednoznacne id souboru
    '<CreDtTm>%s</CreDtTm>'+cCRLF+     //datum vytvoreni platby (souboru)
    '<NbOfTxs>%s</NbOfTxs>'+cCRLF+     //pocet transakci
    '<CtrlSum>%s</CtrlSum>'+cCRLF+     //soucet vsech transakci
    '<InitgPty>'+cCRLF+
      '<Nm>%s</Nm>'+cCRLF+             //jmeno prikazce
    '</InitgPty>'+cCRLF+
    '</GrpHdr>'+cCRLF;
  cDavkaPP =                           //informace o davce
    '<PmtInf>'+cCRLF+
    '<PmtInfId>1</PmtInfId>'+cCRLF+    //jednoznacne id davky - dle popisu struktur muze soubor obsahovat vice davek, u nas ale bude vzdy jen 1
    '<PmtMtd>TRF</PmtMtd>'+cCRLF+      //zpusob platby - povolen pouze kod TRF
    '<NbOfTxs>%s</NbOfTxs>'+cCRLF+     //pocet transakci v davce
    '<CtrlSum>%s</CtrlSum>'+cCRLF+     //soucet castek v davce
    '<ReqdExctnDt>%s</ReqdExctnDt>'+cCRLF+ //datum splatnosti
    '<Dbtr>'+cCRLF+                    //informace o platci
      '<Nm>%s</Nm>'+cCRLF+             //jmeno paltce
    '</Dbtr>'+cCRLF+
    '<DbtrAcct>'+cCRLF+                //identifikace uctu platce
      '<Id>'+cCRLF+                    //identifikace
        '<IBAN>%s</IBAN>'+cCRLF+       //IBAN
      '</Id>'+cCRLF+
      '<Ccy>%s</Ccy>'+cCRLF+           //mena
    '</DbtrAcct>'+cCRLF+
    '<DbtrAgt>'+cCRLF+                 //financni instituce platce
      '<FinInstnId>'+cCRLF+
        '%s'+                          //BIC/SWIFT
      '</FinInstnId>'+cCRLF+
    '</DbtrAgt>'+cCRLF+
    //'%s'+                              //jen kvuli kompatibilite s inkasem
    '%s'+cCRLF+
    '</PmtInf>'+cCRLF;
  cDavkaInkaso =                       //informace o davce
    '<PmtInf>'+cCRLF+
    '<PmtInfId>1</PmtInfId>'+cCRLF+    //jednoznacne id davky - dle popisu struktur muze soubor obsahovat vice davek, u nas ale bude vzdy jen 1
    '<PmtMtd>DD</PmtMtd>'+cCRLF+       //zpusob platby - DD
    '<NbOfTxs>%s</NbOfTxs>'+cCRLF+     //pocet transakci v davce
    '<CtrlSum>%s</CtrlSum>'+cCRLF+     //soucet castek v davce
    '<ReqdColltnDt>%s</ReqdColltnDt>'+cCRLF+ //datum splatnosti
    '<Cdtr>'+cCRLF+                    //informace o prijemci
      '<Nm>%s</Nm>'+cCRLF+             //jmeno prijemce
    '</Cdtr>'+cCRLF+
    '<CdtrAcct>'+cCRLF+                //identifikace uctu prijemce
      '<Id>'+cCRLF+                    //identifikace
        '<IBAN>%s</IBAN>'+cCRLF+       //IBAN
      '</Id>'+cCRLF+
      '<Ccy>%s</Ccy>'+cCRLF+           //mena
    '</CdtrAcct>'+cCRLF+
    '<CdtrAgt>'+cCRLF+                 //financni instituce prijemce
      '<FinInstnId>'+cCRLF+
        '%s'+                          //BIC/SWIFT
      '</FinInstnId>'+cCRLF+
    '</CdtrAgt>'+cCRLF+
    //'%s'+                              //CID – identifikace prijemce
    '%s'+cCRLF+
    '</PmtInf>'+cCRLF;
  cTransakcePP =                       //informace o transakci
    '<CdtTrfTxInf>'+cCRLF+
    '<PmtId>'+cCRLF+                   //identifikace platebni instrukce
      '<InstrId>%s</InstrId>'+cCRLF+   //jedinecna identifikace prirazena stranou vydavajici instrukci
      '<EndToEndId>%s</EndToEndId>'+cCRLF+  //jedinecna identifikace domluvena s partnerem (pokud neni domluveno, tak "NOTPROVIDED")
    '</PmtId>'+cCRLF+
    '<Amt>'+cCRLF+
      '<InstdAmt Ccy="EUR">%s</InstdAmt>'+cCRLF+ //castka + mena (pouze EUR)
    '</Amt>'+cCRLF+
    '%s'+                              //CdtrAgt (BIC/SWIFT)
    '<Cdtr>'+cCRLF+                    //informace o prijemci
      '<Nm>%s</Nm>'+cCRLF+             //jmeno prijemce
    '</Cdtr>'+cCRLF+
    '<CdtrAcct>'+cCRLF+                //identifikace uctu prijemce
      '<Id>'+cCRLF+                    //identifikace
        '<IBAN>%s</IBAN>'+cCRLF+       //IBAN
      '</Id>'+cCRLF+
      '<Ccy>%s</Ccy>'+cCRLF+           //mena
    '</CdtrAcct>'+cCRLF+
    '</CdtTrfTxInf>'+cCRLF;
  cTransakceInkaso =                       //informace o transakci
    '<DrctDbtTxInf>'+cCRLF+
    '<PmtId>'+cCRLF+                   //identifikace platebni instrukce
      '<InstrId>%s</InstrId>'+cCRLF+   //jedinecna identifikace prirazena stranou vydavajici instrukci
      '<EndToEndId>%s</EndToEndId>'+cCRLF+  //jedinecna identifikace domluvena s partnerem (pokud neni domluveno, tak "NOTPROVIDED")
    '</PmtId>'+cCRLF+
    '<InstdAmt Ccy="EUR">%s</InstdAmt>'+cCRLF+ //castka + mena (pouze EUR)
    '<DrctDbtTx>'+cCRLF+                 //financni instituce prijemce
      '<MndtRltdInf>'+cCRLF+
      '</MndtRltdInf>'+cCRLF+
      '<CdtrSchmeId>'+cCRLF+
        '<Id>'+cCRLF+
          '<PrvtId>'+cCRLF+
            '<Othr>'+cCRLF+
              '<Id>CZ25591169</Id>'+cCRLF+
            '</Othr>'+cCRLF+
          '</PrvtId>'+cCRLF+
        '</Id>'+cCRLF+
      '</CdtrSchmeId>'+cCRLF+
    '</DrctDbtTx>'+cCRLF+
    '<DbtrAgt>'+cCRLF+                 //financni instituce platce
      '<FinInstnId>'+cCRLF+            //identifikace
        '<BIC>GIBACZPX</BIC>'+cCRLF+         //BIC/SWIFT
      '</FinInstnId>'+cCRLF+
    '</DbtrAgt>'+cCRLF+
    '%s'+                              //DbtrAgt (BIC/SWIFT)
    '<Dbtr>'+cCRLF+                    //informace o prijemci
      '<Nm>%s</Nm>'+cCRLF+             //jmeno prijemce
    '</Dbtr>'+cCRLF+
    '<DbtrAcct>'+cCRLF+                //identifikace uctu prijemce
      '<Id>'+cCRLF+                    //identifikace
        '<IBAN>%s</IBAN>'+cCRLF+       //IBAN
      '</Id>'+cCRLF+
      '<Ccy>%s</Ccy>'+cCRLF+           //mena
    '</DbtrAcct>'+cCRLF+
    '</DrctDbtTxInf>'+cCRLF;
  cDbtrAgt =
    '<DbtrAgt>'+cCRLF+                 //financni instituce platce
      '<FinInstnId>'+cCRLF+            //identifikace
        '<BIC>%s</BIC>'+cCRLF+         //BIC/SWIFT
      '</FinInstnId>'+cCRLF+
    '</DbtrAgt>'+cCRLF;
  cCdtrAgt =
    '<CdtrAgt>'+cCRLF+                 //financni instituce prijemce
      '<FinInstnId>'+cCRLF+            //identifikace
        '<BIC>%s</BIC>'+cCRLF+         //BIC/SWIFT
      '</FinInstnId>'+cCRLF+
    '</CdtrAgt>'+cCRLF;
  cAgtBIC =
    '<BIC>%s</BIC>'+cCRLF;             //BIC/SWIFT
  cCdtrSchmeId =
    '<CdtrSchmeId>'+cCRLF+
      '<Id>'+cCRLF+
        '<PrvtId>'+cCRLF+
          '<Othr>'+cCRLF+
            '<Id>%s</Id>'+cCRLF+
          '</Othr>'+cCRLF+
        '</PrvtId>'+cCRLF+
      '</Id>'+cCRLF+
    '</CdtrSchmeId>'+cCRLF;
var
  dt, dtSp, t, h: string;
  bmp: TBookmarkStr;
  nrecs: integer;
  castkaCelkem: double;
  stisk: word;
  nKB, NazevPrikazce, NazevPrijemce: string;
  isInkaso: boolean;
begin
{$IFDEF cdUcetnictvi}
  with dmC, dmL do begin
{$ELSE}
  with dmPrevPrik do begin
{$ENDIF}
    AMsg := '';
    Result := TRUE;
    //
    NazevPrikazce:= GetNazevPrikazce;
    DateTimeToString(dt, cISODateFormat, Now);
    DateTimeToString(dtSp, cDateFormat, taPrevPrikDatumSpl.Value);
    //Inkaso, dle domluvy, zatim podporovat nebudeme, protoze to bude ASI vyzadovat zmenu struktur a nemyslime si, ze to bude casty pozadavek.
    //Kod nize je kazdopadne upraven, ale testovani neni dokonceno (mozna bude potreba sahnout jeste do konstant vyse)
    isInkaso := False; //taPrevPrikInkaso.Value;
    //
    //polozky
    taPrevPrikP.DisableControls;
    bmp := taPrevPrikP.Bookmark;
    try
      try
        //test, zda je ve vsech polozkach vyplnen udaj Firma
        taPrevprikP.First;
        while not taPrevprikP.EOF do begin
          if GetNazevPrijemce = '' then begin
          {$IFDEF cdUcetnictvi}
            AMsg := Format(SLmsgSEPAChybiFirma,['Firma']);
          {$ELSE}
            AMsg := Format(SLmsgSEPAChybiFirma,['Jméno pøíjemce']);
          {$ENDIF}
            Result := False;
            EXIT;
          end;
          //
          taPrevprikP.Next;
        end;
        //
        nKB := '1';
        repeat
          stisk:=AskStrPP('Zadejte',
            'Jednoznaèný identifikátor souboru', nKB);
        until (nKB <> '') or (stisk=mrCancel);
        if stisk = mrCancel then begin
          AMsg := SLmsgPPExportBreaked;
          Result := False;
          EXIT;
        end;
        //
        nrecs := 0;
        castkaCelkem := 0;
        taPrevprikP.First;
        while not taPrevprikP.EOF do begin
          Inc(nrecs);
          castkaCelkem := castkaCelkem + taPrevPrikPCastka.Value;
          //
          NazevPrijemce:=GetNazevPrijemce;
          t := t+Format(Cond(isInkaso, cTransakceInkaso, cTransakcePP),
             [IntToStr(nrecs),                                                              //InstrId
              Cond(taPrevPrikPVarSym.Value <> '', taPrevPrikPVarSym.Value, 'NOTPROVIDED'),  //EndToEndId
              Replace(DecimalSeparator, FormatFloat('0.00', taPrevPrikPCastka.Value),'.'),  //Amt/InstdAmt
              Cond(taPrevPrikPSWIFT.Value <> '',
                 Format(Cond(isInkaso, cDbtrAgt, cCdtrAgt), [StrPadRight(taPrevPrikPSWIFT.Value, 11, 'X')]), ''), //CdtrAgt/BIC
              NazevPrijemce,                                                                        //Cdtr/Nm - DOPLNIT PO ZMENE STRUKTUR!!!!!
              Cond(taPrevPrikPIBAN.Value <> '', taPrevPrikPIBAN.Value,
                   ConvertBU2IBAN(taPrevPrikPBaUcet.Value+'/'+taPrevPrikPKodBanky.Value, 'CZ')),//IBAN
              'EUR'                                                                         //CdtrAcct/Ccy - mena, vzdy EUR
              ]);
          //
          taPrevprikP.Next;
        end;
        t := Format(Cond(isInkaso, cDavkaInkaso, cDavkaPP),
           [IntToStr(nrecs),
            Replace(DecimalSeparator, FormatFloat('0.00', castkaCelkem),'.'),
            dtSp,
            NazevPrikazce,                                                                  //Dbtr/Nm - DOPLNIT PO ZMENE STRUKTUR!!!!!
            Cond(taPrevPrikIBAN.Value <> '', taPrevPrikIBAN.Value,
                 ConvertBU2IBAN(taPrevPrikBaUcet.Value+'/'+taPrevPrikKodBanky.Value, 'CZ')),//IBAN
            Cond(taPrevPrikMena.Value = 'Kè', 'CZK',taPrevPrikMena.Value),                  //DbtrAcct/Ccy - mena
            Cond(taPrevPrikSWIFT.Value <> '', Format(cAgtBIC, [taPrevPrikSWIFT.Value]), ''), //DbtrAgt/BIC
            //Cond(isInkaso, Format(cCdtrSchmeId, ['CZ25591169']), ''),
            t
           ]);
        h := Format(cHlavicka,
           [nKB,
            dt,
            IntToStr(nrecs),
            Replace(DecimalSeparator, FormatFloat('0.00', castkaCelkem),'.'),
            NazevPrikazce                                                                    //InitgPty/Nm - DOPLNIT PO ZMENE STRUKTUR!!!!!
           ]);
      except
        on E: Exception do begin
          AMsg := Format(SLmsgPPErrExport, [E.Message]);
          Result := FALSE;
          EXIT;
        end;
      end;
    finally
      taPrevPrikP.Bookmark := bmp;
      taPrevPrikP.EnableControls;
    end;
    //
    AOutText :=AnsiToUTF8(Format(Cond(isInkaso, cXMLInkaso, cXMLPP), [h, t]));
  end;
end; {CreateExportTextHbSEPA}

function CreateExportTextHB(const ABaUcet,
  AKodBanky, AFormatHB: string;
  out AOutText, AMsg: string): boolean;
begin
  if (AFormatHb = cFormatHbABO) or (AFormatHb = cFormatHbABOOL) or
     (AFormatHb = cFormatHbXMLCSOB) or (AFormatHb = cFormatHbTXTCSOB) or
     (AFormatHb = cFormatHbXMLGEMB) or (AFormatHb = cFormatHbCSVEQUA) or
     (AFormatHb = cFormatHbTXTPBGPE) or (AFormatHb = cFormatHbCSVRB) or
     (AFormatHb = cFormatHbCSVCSOB) or (AFormatHb = cFormatHbCSVAIRBANK) then
    Result := CreateExportTextHbABO(ABaUcet, AKodBanky, FALSE, AOutText, AMsg)
  else if AFormatHb = cFormatHbMBEST then
    Result := CreateExportTextHbMBEST(ABaUcet, AKodBanky, AOutText, AMsg)
  else if AFormatHb = cFormatHbCITIBANK then
    Result := CreateExportTextHbCITIBANK(ABaUcet, AKodBanky, AOutText, AMsg)
  else if AFormatHb = cFormatHbGEMINI then
    Result := CreateExportTextHbGEMINI(ABaUcet, AKodBanky, AOutText, AMsg)
  else if AFormatHb = cFormatHbMCC then
    Result := CreateExportTextHbMCC(ABaUcet, AKodBanky, AOutText, AMsg)
  else if AFormatHb = cFormatHbCITIDIRECT then
    Result := CreateExportTextHbCITIDIRECT(ABaUcet, AKodBanky, AOutText, AMsg)
  else if (AFormatHb = cFormatHbCSVFIO) or (AFormatHb = cFormatHbAPIFIO) then
    Result := CreateExportTextHbXMLFIO(ABaUcet, AKodBanky, AOutText, AMsg)
  else if AFormatHb = cFormatHbSEPA then
    Result := CreateExportTextHbSEPA(ABaUcet, AKodBanky, AOutText, AMsg)
  else
    Result := FALSE;
end; {CreateExportTextHB}

end.

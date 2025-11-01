program DS;

uses
  Forms,Windows,SysUtils,Classes,FCommonUtils,
  DatovaSchranka in 'DatovaSchranka.pas' {fmDatovaSchranka},
  DatovaSchrankaZprava in 'DatovaSchrankaZprava.pas' {fmDSZprava},
  DatovaSchrankaHledani in 'DatovaSchrankaHledani.pas' {fmDSHledani},
  DatovaSchrankaPrihlaseni in 'DatovaSchrankaPrihlaseni.pas' {fmDSPrihlaseni};

{$R *.res}

var
  clientInfo: string;
  sl: TStringList;

begin
  Application.Initialize;
  //reseni problemu s dateseparatorem na Windows7 OEM na noteboocich
  SetThreadLocale(LOCALE_USER_DEFAULT);
  GetFormatSettings();
  //
  Application.MainFormOnTaskbar := True;
  Application.Title := 'DS comunicator';
  Application.Run;
  if ParamStr(1) = '' then
    OpenDS(-1,FALSE,'',FALSE,'','')

  //OPEN Test Jmeno Heslo NazevKlienta IDDS Certifikat
  //Prikl.: OPEN "-1" "aaaark" "Ex7+6r2=oz" "Mik test A" "8c3adyx" " "
    else if UpperCase(ParamStr(1)) = 'OPEN' then
    OpenDS(-1,FALSE,'', // parametry klienta
    StrToBoolSafe(ParamStr(2)),Trim(ParamStr(3)),Trim(ParamStr(4)), //test, jmeno, heslo
    ParamStr(5),ParamStr(6),Trim(ParamStr(7))) //nazev klienta, IDDS, hash certifikatu

  //SEND 2Test 3Jmeno 4Heslo 5NazevKlienta 6IDDS 7Certifikat 8CestakOdesilanemuSouboru
  //     9Vec 10IDDSPrijemce 11NazevPrijemce
  //Prikl.: SEND "-1" "aaaark" "Ex7+6r2=oz" "Mik test A" "8c3adyx" " " "R:\Mik\dsoutmsg196363.fo" "Test odeslani"
  else if UpperCase(ParamStr(1)) = 'SEND' then begin
    sl:= TStringList.Create;
    try
      sl.Text:=ParamStr(8);  // je potreba predat ve formatu sl.CommaText namisto sl.Text 
      clientInfo:='[ClientInfo]'+#13#10+
        'ISDSUsrId='+Trim(ParamStr(3))+#13#10+
        'ISDSIdDs='+Trim(ParamStr(6))+#13#10+
        'ISDSPswd='+Trim(ParamStr(4))+#13#10+
        'ISDSIdCert='+Trim(ParamStr(7))+#13#10+
        'ISDSTestBox='+Trim(ParamStr(2))+#13#10+
        'ISDSName='+Trim(ParamStr(5));
      DSNewMessage(-1, FALSE, clientInfo,
      TRUE,
      ParamStr(10),ParamStr(11),ParamStr(9), // IDDSPrijemce, NazevPrijemce, Vec
      sl.CommaText); // seznam souboru
      DeleteFile(ParamStr(8));
    finally
      sl.Free;
    end;
  end;
end.

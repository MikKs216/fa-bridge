{ 4. 1. 2013 11:07:40 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in Opravy v offline podani  }
{ 4. 12. 2012 14:22:20 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in Offline podani  }
{ 29. 11. 2012 15:00:13 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in OfflinePodani  }
{ 29. 11. 2012 9:29:45 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in Doplneni dotazu na offfline i pro systemove volani  }
{ 27. 11. 2012 15:45:59 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in offline podani  }
{ 6.2.2009 10:13:37 (GMT+1:00) > [martin on MR64PC] checked in do chyboveho hlaseni doplnena delka z HEADER sekce http pozadavku  }
{ 2.12.2008 21:10:01 (GMT+1:00) > [martin] checked in Final oprava pro OpenSSl a Synapse, chyba v prevodu streamu do stringu  }
{ 2.12.2008 16:12:25 (GMT+1:00) > [martin on MR64PC] checked in oprava prijeti spravnych dat  }
{ 2.12.2008 11:46:08 (GMT+1:00) > [martin on MR64PC] checked in Upraven program pro SYnapsy a Open SSL posledni verze 0.998  }
{ 2.12.2008 8:58:09 (GMT+1:00) > [martin on MR64PC] checked in Zmena hlaseni chyby v SSL  }
{ 18.11.2008 10:43:36 (GMT+1:00) > [martin on MR64PC] checked in Doplnena identifikace v ShowLastError cislem chyby  }
{ 20.10.2008 19:58:00 (GMT+2:00) > [martin on MR64PC] checked in Odstraneno hlaseni SSL o chybe certifikatu u externiho ssl pomoci WININet  }
{ 9.10.2008 14:52:07 (GMT+2:00) > [mik] checked in Doplneno nastaveni SSL do komponenty HTTP  }
{ 28.1.2008 0:18:41 (GMT+1:00) > [martin on NEWMARTINPC] checked in Odeslani epo bez externiho exe ale pomoci WinInet  }
{ 23.1.2008 22:00:21 (GMT+1:00) > [martin on NEWMARTINPC] checked in Doplnena moznost externiho prenosu dat SSL. Automaticky bude pouzita pokud neni u exe souboru libeay32.dll  }
unit EElPodDM;

{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mfcr_certificate, mfcr_certificate_adapter, xmldom, XMLIntf, msxmldom, XMLDoc, 
  JclShell, JclSysUtils, WinInet, httpsend, ssl_openssl, synautil;

type

  TReceiptError = record
    ErrorType: string;
    ErrorText: string;
  end;

  TReceiptErrors = array of TReceiptError;

  TReceiptInformation = record
    ReceiptNumber: string;
    ReceiptDate: string;
    ReceiptEmail: string;
    ReceiptPassword: string;
    ReceiptCheck: string;
    ReceiptFileName: string;
  end;

  TOffLineInfo = record
    OfflineID:string;
    OfflinePassword:string;
    Datum:TDateTime;
  end;

  TDeliveryState = record
    por_podani: string;
    apl_oblpod: string;
    typ_podani: string;
    c_ufo_prij: string;
    email_ext: string;
    d_podani: string;
    cas_podani: string;
    stav_podpre: string;
    stav_podpre_text: string;
    p_zareppod: string;
    p_platnostpod: string;
    p_chybapod: string;
    stav_podapl: string;
    stav_podapl_text: string;
    d_pripodapl: string;
    pozn_pripodapl: string;
    p_testpod: string;
  end;

  TProxySettings = record
    ProxyServer: string;
    ProxyPort: Integer;
    ProxyUserName: string;
    ProxyPassword: string;
    BasicAuthentication: Boolean;
  end;

  TMFCRModule = class(TDataModule)
    XMLDoc: TXMLDocument;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    {function ParseField(const S, FieldName: String): String;}
    function GetNodeValue(ANode: IXMLNode; AChildNodeName: string): string;
    {function ParseNode(const S, NodeName: String): String;
    function GetMultipleField(var S: String; const Prefix, Sufix: String): String;
    function GetOneField(const S, Prefix, Sufix: String): String;}

    //Test na lokalni SSL, false musime pouzit externi SSL poslani
    function IsLocalSSL(): bool;

    function DeliveryStateE(const ReceiptNumber, ReceiptPassword: string): TDeliveryState;
    function DeliveryStateE2(const ReceiptNumber, ReceiptPassword: string): TDeliveryState;
    function DeliveryStateSy(const ReceiptNumber, ReceiptPassword: string): TDeliveryState;


    function PostToURLQuery(strURL, strParams: string; streamTelo: TMemoryStream; strHeader: string; var answerPOST: string): integer;

    procedure ShowLastError(errCode: DWORD);
    function GetErrorMessage(ErrNo: Cardinal): string;


    // Odesila dokument na server externi SSL
    function SendDocumentE(const SignatureFileName, ReceiptFileName: string;
      const AParams: string; ANaTestovaciServer: boolean = FALSE): TReceiptErrors;
    function SendDocumentE2(const SignatureFileName, ReceiptFileName: string;
      const AParams: string; ANaTestovaciServer: boolean = FALSE): TReceiptErrors;
    function SendDocumentSy(const SignatureFileName, ReceiptFileName: string;
      const AParams: string; ANaTestovaciServer: boolean; ABezPodpisu: boolean): TReceiptErrors;
  public

    FPotvrzeni: string;

    //TimeOut serveru MFCR
    ServerTimeOut: integer;

    // Nastaveni proxy serveru
    ProxySettings: TProxySettings;

    // Platne certifikaty pro podpis (wrapper, ktery podporuje oba zpusoby)
    Certificates: TCertificatesWrapper;

    // Nacteni certifikatu pro podpis
    procedure CertificatesLoad;

    // Uvolneni certifikatu pro podpis
    procedure CertificatesFree;

    // Odesila dokument na server
    function SendDocument(const SignatureFileName, ReceiptFileName: string;
      const AParams: string;
      ANaTestovaciServer: boolean = FALSE;
      AOpenSSLMode:Boolean = TRUE;
      ABezPodpisu: boolean = FALSE): TReceiptErrors;


    // Overit podepsane potvrzeni
    function VerifyReceipt(const ReceiptFileName: string): Boolean;

    // Informace o podani
    function GetRIFromString(Data: string): TReceiptInformation;
    function ReceiptInformation(const ReceiptFileName: string): TReceiptInformation;


    // Stav podani
    function DeliveryState(const ReceiptNumber, ReceiptPassword: string;AOpenSSLMode:Boolean = TRUE): TDeliveryState;
    //Dotaz na stav Offline podani
    function QueryOfflineState(Id: string; Heslo:string; proxyServer:string; proxyPort:Integer; serverTimeout:Integer; out Vystup:string; AOpenSSLMode:Boolean=TRUE; ATest:Boolean=FALSE ):integer;
    //Vrati seznam chyb
    function GetChybyOffline(Data: string):TReceiptErrors;

  end;

var
  MFCRModule: TMFCRModule;
  OfflineInfo:TOffLineInfo;

implementation

{$R *.DFM}

uses
  ComObj, IdException, Variants, synachar, mfcr_consts, mfcr_utils,
  mfcr_resources, FCommonUtils, Main;

function TMFCRModule.GetNodeValue(ANode: IXMLNode; AChildNodeName: string): string;
var
  node1: IXMLNode;
begin
  node1 := ANode.ChildNodes.FindNode(AChildNodeName);
  if node1 <> nil then
    Result := VarToStr(node1.NodeValue);
end;

procedure TMFCRModule.DataModuleCreate(Sender: TObject);
begin
  ProxySettings.ProxyServer := '';
  ProxySettings.ProxyPort := 0;
  ProxySettings.ProxyUserName := '';
  ProxySettings.ProxyPassword := '';
  ProxySettings.BasicAuthentication := FALSE;
  Certificates := nil;
end;

procedure TMFCRModule.DataModuleDestroy(Sender: TObject);
begin
  CertificatesFree;
end;

procedure TMFCRModule.CertificatesLoad;
begin
  StartWait;
  try
    CertificatesFree;
    
    // Wrapper automaticky pouzije spravnou implementaci podle nastaveni
    // Konfigurace se nacita v Main.pas v LoadParamsFromIni
    Certificates := TCertificatesWrapper.Create(GfaMain.UseFCommAPI, GfaMain.FCommBaseUrl);
  finally
    StopWait;
  end;
end;

procedure TMFCRModule.CertificatesFree;
begin
  StartWait;
  try
    if Assigned(Certificates) then begin
      Certificates.Free;
      Certificates := nil;
    end;
  finally
    StopWait;
  end;
end;

// === POMOCNÉ FUNKCE PRO PRÁCI S CERTIFIKÁTY (fungují s oběma typy) ===

function TMFCRModule.SendDocument(const SignatureFileName,
  ReceiptFileName: string; const AParams: string;
  ANaTestovaciServer: boolean = FALSE; AOpenSSLMode:Boolean = TRUE;
  ABezPodpisu: boolean = FALSE): TReceiptErrors;
var
  FSSignature: TFileStream;
  MSResult: TMemoryStream;
  FSReceipt: TFileStream;
  S: string;
  I: Integer;
  node, node1, node2: IXMLNode;
begin

  OfflineInfo.OfflinePassword:='';
  OfflineInfo.OfflineId:='';

  if not AOpenSSLMode then begin
    //Posleme to WinInetAPI
    Result := SendDocumentE2(SignatureFileName, ReceiptFileName, AParams, ANaTestovaciServer);
    Exit;
  end
  else begin
    //Posleme to pomoci synapse a OpenSSL
    Result := SendDocumentSy(SignatureFileName, ReceiptFileName, AParams, ANaTestovaciServer, ABezPodpisu);
  end;
end; {SendDocument}

//Testujeme zda existuje lokalni kopie libeay32.dll

function TMFCRModule.IsLocalSSL(): bool;
begin
  Result := FileExists(ExtractFilePath(Application.ExeName) + 'libeay32.dll');
end; {TestLocalSSL}

//Odeslani dokumentu kanalem SSL ale externim programem
//Program lezi ve slozce /SSL a jmenuje se sendssl.exe

function TMFCRModule.SendDocumentE(const SignatureFileName,
  ReceiptFileName: string; const AParams: string;
  ANaTestovaciServer: boolean = FALSE): TReceiptErrors;
var
  MSResult: TMemoryStream;
  FSReceipt: TFileStream;
  S: string;
  I: Integer;
  node, node1, node2: IXMLNode;
  ResponseCode: Integer;
  FileNameResult, FilenameSrc, ExeName, Command: string;
  TransferLog: TStringList;
begin
  StartWait;
  try
    FPotvrzeni := '';
    SetLength(Result, 0);

    if FileExists(ReceiptFileName) then
      if not DeleteFile(ReceiptFileName) then
        raise Exception.CreateFmt(errReceiptFileExists, [ReceiptFileName]);
    MSResult := TMemoryStream.Create;
    TransferLog := TStringList.Create();
    try
      try

        FilenameResult := ExtractFilePath(Application.ExeName) + 'SSL\result.xml';
        FileNameSrc := SignatureFileName;
        ExeName := '"' + ExtractFilePath(Application.ExeName) + 'SSL\sendssl.exe"';

        if ANaTestovaciServer then begin
          {MessageWarn('', 'Nyn� dojde k odesl�n� pod�n� na testovac� server MF', [MBOK]);}

          Command := '"POST" "' + sMFCREPOSendURLtest + AParams + '" "' + FilenameSrc + '" "' + FileNameResult + '" "' +
            iff(ProxySettings.ProxyServer = '', ' ', ProxySettings.ProxyServer) +
            '" "' +
            IntToStr(ProxySettings.ProxyPort) +
            '" "' +
            Iff(ProxySettings.ProxyUserName = '', ' ', ProxySettings.ProxyUserName) +
            '" "' +
            Iff(ProxySettings.ProxyPassword = '', ' ', ProxySettings.ProxyPassword) +
            '" "' + sContentTypePKCS7 + '"';

          ShellExecAndWait(ExeName, Command, '', SW_HIDE);
          MSResult.LoadFromFile(FileNameResult);

        end
        else begin

          //Ostry server
          Command := '"POST" "' + sMFCREPOSendURL + AParams + '" "' + FilenameSrc + '" "' + FileNameResult + '" "' +
            iff(ProxySettings.ProxyServer = '', ' ', ProxySettings.ProxyServer) +
            '" "' +
            IntToStr(ProxySettings.ProxyPort) +
            '" "' +
            Iff(ProxySettings.ProxyUserName = '', ' ', ProxySettings.ProxyUserName) +
            '" "' +
            Iff(ProxySettings.ProxyPassword = '', ' ', ProxySettings.ProxyPassword) +
            '" "' + sContentTypePKCS7 + '"';

          ShellExecAndWait(ExeName, Command, '', SW_HIDE);
          MSResult.LoadFromFile(FileNameResult);

        end;

        TransferLog.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SSL\Transfer.log');
        if TransferLog.Count > 0 then
          ResponseCode := StrToInt(TransferLog[0])
        else
          ResponseCode := -1;

        SetLength(S, MSResult.Size);
        MSResult.Position := 0;
        MSResult.Read(S[1], MSResult.Size);
      except
        on E: EIdConnClosedGracefully do begin
        end;
        on E: Exception do
          raise Exception.CreateFmt(errWSPostEx, [E.Message]);
      end;

      if ResponseCode <> 200 then
        raise Exception.CreateFmt(errWSPostRC, [ResponseCode]);

      if Length(S) < 10 then
        raise Exception.CreateFmt(errWSXMLDelka, []);
      if Pos(sXMLStart, S) > 10 then begin
        FSReceipt := TFileStream.Create(ReceiptFileName, fmCreate);
        try
          FSReceipt.Write(S[1], Length(S));
          FPotvrzeni := S;
        finally
          FSReceipt.Free;
        end;
      end
      else begin
        XMLDoc.XML.Text := S;
        XMLDoc.Active := TRUE;
        try
          if XMLDoc.DocumentElement.NodeName = 'Chyby' then begin
            node := XMLDoc.DocumentElement;
            SetLength(Result, node.ChildNodes.Count);
            for i := 0 to node.ChildNodes.Count - 1 do begin
              node1 := node.ChildNodes.Nodes[i];
              if node1.NodeName = 'Chyba' then begin
                Result[i].ErrorType := VarToStr(node1.Attributes['Typ']);
                node2 := node1.ChildNodes['Text'];
                if node2 <> nil then
                  Result[i].ErrorText := node2.NodeValue;
              end;
            end;
          end;
        finally
          XMLDoc.Active := FALSE;
        end;
      end;
    finally
      TransferLog.Free;
      MSResult.Free;
    end;
  finally
    StopWait;
  end;
end; {SendDocumentE}


function TMFCRModule.VerifyReceipt(
  const ReceiptFileName: string): Boolean;
var
  FS: TFileStream;
  SignedData: Variant;
begin
  StartWait;
  Result := FALSE;
  try
    if not FileExists(ReceiptFileName) then
      raise Exception.CreateFmt(errReceiptFileNotFound, [ReceiptFileName]);
    FS := TFileStream.Create(ReceiptFileName, fmOpenRead);
    try
      if FS.Size < 1024 then
        raise Exception.CreateFmt(errReceiptFileTooSmall, [ReceiptFileName]);
    finally
      FS.Free;
    end;
    SignedData := CreateOleObject(CAPICOM_SIGNEDDATA);
    try
      Result := SignedData.Verify(FileToWideString(ReceiptFileName));
    finally
      SignedData := null;
    end;
  finally
    StopWait;
  end;
end;

function TMFCRModule.ReceiptInformation(const ReceiptFileName: string): TReceiptInformation;
var
  FS: TFileStream;
  S: string;
  {PomS: String;}
  I: Integer;
  node, node1, node2: IXMLNode;
begin
  Result.ReceiptNumber := '';
  Result.ReceiptDate := '';
  Result.ReceiptEmail := '';
  Result.ReceiptPassword := '';
  Result.ReceiptCheck := '';
  if not FileExists(ReceiptFileName) then
    raise Exception.CreateFmt(errReceiptFileNotFound, [ReceiptFileName]);
  FS := TFileStream.Create(ReceiptFileName, fmOpenRead);
  try
    if FS.Size < 1024 then
      raise Exception.CreateFmt(errReceiptFileTooSmall, [ReceiptFileName]);
    SetLength(S, FS.Size);
    FS.Read(S[1], FS.Size);
    Result:=GetRIFromString(S);
  finally
    FS.Free;
  end;
end;{ReceiptInformation}

function TMFCRModule.GetRIFromString(Data: string): TReceiptInformation;
var
  I: Integer;
  node, node1, node2: IXMLNode;
begin
  Result.ReceiptNumber := '';
  Result.ReceiptDate := '';
  Result.ReceiptEmail := '';
  Result.ReceiptPassword := '';
  Result.ReceiptCheck := '';

  i := Pos('<?xml version=', Data);
  if i < 1 then
    raise Exception.CreateFmt(errReceiptNoXMLData, ['']);
  Delete(Data, 1, i - 1);
  i := Pos('</Pisemnost>', Data);
  if i < 1 then
    raise Exception.CreateFmt(errReceiptBadXMLData, ['']);
  Delete(Data, i + Length('</Pisemnost>'), maxint);

  XMLDoc.XML.Text := Data;
  XMLDoc.Active := TRUE;
  try
    if XMLDoc.DocumentElement.NodeName = 'Pisemnost' then begin
      node := XMLDoc.DocumentElement;
      node1 := node.ChildNodes['Kontrola'];
      if node1 <> nil then begin
        node2 := node1.ChildNodes['Soubor'];
        Result.ReceiptFileName := VarToStr(node2.Attributes['Nazev']);
        Result.ReceiptCheck := VarToStr(node2.Attributes['KC']);
      end;
      node1 := node.ChildNodes['Podani'];
      if node1 <> nil then begin
        Result.ReceiptNumber := VarToStr(node1.Attributes['Cislo']);
        Result.ReceiptDate := VarToStr(node1.Attributes['Datum']);
        Result.ReceiptEmail := VarToStr(node1.Attributes['Email']);
        Result.ReceiptPassword := VarToStr(node1.Attributes['Heslo']);
      end;
    end;
  finally
    XMLDoc.Active := FALSE;
  end;
end;


function TMFCRModule.DeliveryState(const ReceiptNumber,
  ReceiptPassword: string;AOpenSSLMode:Boolean = TRUE): TDeliveryState;
var
  MSResult: TMemoryStream;
  S: string;
  node: IXMLNode;

begin
  if not AOpenSSLMode then begin
    //WININet
    Result := DeliveryStateE2(ReceiptNumber, ReceiptPassword);
    Exit;
  end
  else begin
    //OpenSSL
    Result := DeliveryStateSy(ReceiptNumber, ReceiptPassword);
    Exit;
  end;
end; {DeliveryState}

function TMFCRModule.DeliveryStateE(const ReceiptNumber, ReceiptPassword: string): TDeliveryState;
var
  MSResult: TMemoryStream;
  S: string;
  node: IXMLNode;

  ResponseCode: Integer;
  FileNameResult, FilenameSrc, ExeName, Command: string;
  TransferLog: TStringList;

begin
  StartWait;
  try
    Result.por_podani := '';
    Result.apl_oblpod := '';
    Result.typ_podani := '';
    Result.c_ufo_prij := '';
    Result.email_ext := '';
    Result.d_podani := '';
    Result.cas_podani := '';
    Result.stav_podpre := '';
    Result.stav_podpre_text := '';
    Result.p_zareppod := '';
    Result.p_platnostpod := '';
    Result.p_chybapod := '';
    Result.stav_podapl := '';
    Result.stav_podapl_text := '';
    Result.d_pripodapl := '';
    Result.pozn_pripodapl := '';
    Result.p_testpod := '';
    if (ReceiptNumber = '') or (ReceiptPassword = '') then
      raise Exception.CreateFmt(errBadReceiptLogin, []);
    MSResult := TMemoryStream.Create;
    try

      FilenameResult := ExtractFilePath(Application.ExeName) + 'SSL\result.xml';
      FileNameSrc := ' ';
      ExeName := '"' + ExtractFilePath(Application.ExeName) + 'SSL\sendssl.exe"';

      Command := '"POST" "' + Format(sMFCREPOStateURL, [ReceiptNumber, ReceiptPassword]) + '" "' + FilenameSrc + '" "' + FileNameResult + '" "' +
        iff(ProxySettings.ProxyServer = '', ' ', ProxySettings.ProxyServer) +
        '" "' +
        IntToStr(ProxySettings.ProxyPort) +
        '" "' +
        Iff(ProxySettings.ProxyUserName = '', ' ', ProxySettings.ProxyUserName) +
        '" "' +
        Iff(ProxySettings.ProxyPassword = '', ' ', ProxySettings.ProxyPassword) +
        '" "' + ' ' + '"';

      try
        //HTTP.ReadTimeout := ServerTimeOut * 1000;

        //HTTP.Post(Format(sMFCREPOStateURL, [ReceiptNumber, ReceiptPassword]), st, MSResult);
        ShellExecAndWait(ExeName, Command, '', SW_HIDE);
        MSResult.LoadFromFile(FileNameResult);
        TransferLog.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SSL\Transfer.log');

        SetLength(S, MSResult.Size);
        MSResult.Position := 0;
        MSResult.Read(S[1], MSResult.Size);

        if TransferLog.Count > 0 then
          ResponseCode := StrToInt(TransferLog[0])
        else
          ResponseCode := -1;

      except
        on E: Exception do
          raise Exception.CreateFmt(errWSGetEx, [E.Message]);
      end;

      if ResponseCode <> 200 then
        raise Exception.CreateFmt(errWSGetRC, [ResponseCode]);
      if (Length(S) < 10) or (Pos(sXMLStart, S) > 10) then
        raise Exception.CreateFmt(errWSXMLDelka, []);

      XMLDoc.XML.Text := S;
      XMLDoc.Active := TRUE;
      try
        if XMLDoc.DocumentElement.NodeName = 'Stav' then begin
          node := XMLDoc.DocumentElement;
          if (node.ChildNodes <> nil) and (node.ChildNodes.Count > 0) then begin
            Result.por_podani := GetNodeValue(node, sDeliveryFind_por_podani);
            Result.apl_oblpod := GetNodeValue(node, sDeliveryFind_apl_oblpod);
            Result.typ_podani := GetNodeValue(node, sDeliveryFind_typ_podani);
            Result.c_ufo_prij := GetNodeValue(node, sDeliveryFind_c_ufo_prij);
            Result.email_ext := GetNodeValue(node, sDeliveryFind_email_ext);
            Result.d_podani := GetNodeValue(node, sDeliveryFind_d_podani);
            Result.cas_podani := GetNodeValue(node, sDeliveryFind_cas_podani);
            Result.stav_podpre := GetNodeValue(node, sDeliveryFind_stav_podpre);
            Result.stav_podpre_text := GetNodeValue(node, sDeliveryFind_stav_podpre_text);
            Result.p_zareppod := GetNodeValue(node, sDeliveryFind_p_zareppod);
            Result.p_platnostpod := GetNodeValue(node, sDeliveryFind_p_platnostpod);
            Result.p_chybapod := GetNodeValue(node, sDeliveryFind_p_chybapod);
            Result.stav_podapl := GetNodeValue(node, sDeliveryFind_stav_podapl);
            Result.stav_podapl_text := GetNodeValue(node, sDeliveryFind_stav_podapl_text);
            Result.d_pripodapl := GetNodeValue(node, sDeliveryFind_d_pripodapl);
            Result.pozn_pripodapl := GetNodeValue(node, sDeliveryFind_pozn_pripodapl);
            Result.p_testpod := GetNodeValue(node, sDeliveryFind_p_testpod);
          end;
        end;
      finally
        XMLDoc.Active := FALSE;
      end;

    finally
      MSResult.Free;
    end;
  finally
    StopWait;
  end;
end; {DeliveryStateE}

{-------------------------------------------------------------------------------
  Procedure: GetErrorMessage
  Author:    Martin Radvansk�
  DateTime:  2008.01.27
  Arguments: ErrNo: Cardinal; var ErrMsg: string
  Result:    None
-------------------------------------------------------------------------------}
function TMFCRModule.GetErrorMessage(ErrNo: Cardinal): string;
var
  lpMsgBuf: pChar;
  ModuleHandle: HModule;

  function PRIMARYLANGID(lgid: Word): LongInt;
  begin
    result := lgid and $3FF;
  end; {PRIMARYLANGID}

  function SUBLANGID(lgid: Word): LongInt;
  begin
    result := lgid shr 10;
  end; {SUBLANGID}

  function MAKELANGID(sPrimaryLanguage: Word; sSubLanguage: Word): Word;
  begin
    result := (sSubLanguage shl 10) or sPrimaryLanguage;
  end; {MAKELANGID}

begin
  Result := '';
  ModuleHandle := GetModuleHandle('wininet');
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or
    FORMAT_MESSAGE_FROM_SYSTEM or
    FORMAT_MESSAGE_IGNORE_INSERTS or
    FORMAT_MESSAGE_FROM_HMODULE,
    pointer(ModuleHandle),
    ErrNo,
    MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
    @lpMsgBuf,
    0,
    nil);
  if lpMsgBuf <> nil then begin
    SetLength(Result, StrLen(lpMsgBuf) + 1);
    Result := string(lpMsgBuf);
    LocalFree(Integer(lpMsgBuf));
  end;
end; {GetErrorMessage}


{-------------------------------------------------------------------------------
  Procedure: TMFCRModule.ShowLastError
  Author:    Martin Radvansk�
  DateTime:  2008.01.27
  Arguments: errCode: DWORD
  Result:    None
-------------------------------------------------------------------------------}

procedure TMFCRModule.ShowLastError(errCode: DWORD);
var
  sApiError: string;
begin
  sApiError := GetErrorMessage(errCode);
  sApiError := 'Chybov� k�d Wininet Api: '+IntToStr(errCode)+#13#10+sApiError;
  MessageBox(0, PChar(sApiError), 'Chyba p�i komunikaci s https serverem', MB_OK);
end; {ShowError}

{-------------------------------------------------------------------------------
  Procedure: TMFCRModule.PostToURLQuery
  Author:    Martin Radvansk�
  DateTime:  2008.01.27
  Arguments: strURL, strParams: string; streamTelo: TMemoryStream; strHeader: string; var answerPOST: string
  Result:    integer
-------------------------------------------------------------------------------}

function TMFCRModule.PostToURLQuery(strURL, strParams: string; streamTelo: TMemoryStream; strHeader: string; var answerPOST: string): integer;
const BUFF_SIZE = 4095;
var
  hInet: HINTERNET;
  hConn: HINTERNET;
  hReq: HINTERNET;
  dwLastError: DWORD;
  buf: array[0..BUFF_SIZE] of char; //puvodne 4095
  iBytesRead: Cardinal;

  data: DWORD;
  size, dummy: Cardinal;
  nilptr: Pointer;
  dwRetVal: DWORD;

  bKeepOnLooping: boolean;
  bFlag: boolean;
  port: Integer;
  iInternetFlags: DWORD;
  dwFlags, dwBuffLen: DWORD;
  gbUseSSL: boolean;

  pBufObsah: Pointer;
  delkaObsah: DWORD;

  VysledekStream: TMemoryStream;
  Navrat: WideString;
  hotovo: string;

  function Canonize(vstup: string): string;
  var
    szUrl: string;
    dwLen: dword;
  begin
    SetLength(szUrl, MAX_PATH);
    ZeroMemory(@szUrl[1], length(szUrl));

    dwLen := length(szUrl);
    if (InternetCanonicalizeUrl(PAnsiChar(vstup), @szUrl[1], dwLen, 0)) then
      SetLength(szUrl, strlen(pchar(szUrl)));

    Result := szURL;
  end; {Canonize}

begin

  Result := -1;
  hInet := InternetOpen('FORMASISTENT', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if hInet = nil then begin
    dwLastError := GetLastError();
    ShowLastError(dwLastError);
    exit;
  end;

  if Assigned(streamTelo) then begin
    pBufObsah := streamTelo.Memory;
    delkaObsah := streamTelo.Size;
    streamTelo.Position := 0;
  end
  else begin
    pBufObsah := nil;
    delkaObsah := 0;
  end;

  gbUseSSL := Pos('HTTPS', UpperCase(StrURL)) > 0;

  strURL := StringReplace(strURL, 'https://', '', [rfIgnoreCase]); //odstraneni https
  strURL := StringReplace(strURL, 'http://', '', [rfIgnoreCase]); //odstraneni http

  if gbUseSSL then
    port := INTERNET_DEFAULT_HTTPS_PORT
  else
    port := INTERNET_DEFAULT_HTTP_PORT;

  hConn := InternetConnect(hInet, PChar(Canonize(strURL)), port, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
  if hConn = nil then begin
    dwLastError := GetLastError();
    ShowLastError(dwLastError);
    InternetCloseHandle(hInet);
    exit;
  end;

  iInternetFlags := INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_RELOAD or
    //23.10.08 osetreni chyb v kontrole certifikatu
    SECURITY_FLAG_IGNORE_CERT_CN_INVALID or SECURITY_FLAG_IGNORE_CERT_DATE_INVALID or
    SECURITY_FLAG_IGNORE_CERT_DATE_INVALID;

  if gbUseSSL then iInternetFlags := iInternetFlags or INTERNET_FLAG_SECURE;
  hReq := HttpOpenRequest(hConn, 'POST', PChar(Canonize(strParams)), 'HTTP/1.1', 'FORMASISTENT', nil, iInternetFlags, 0);
  if hReq = nil then begin
    dwLastError := GetLastError();
    ShowLastError(dwLastError);
    InternetCloseHandle(hConn);
    InternetCloseHandle(hInet);
    exit;
  end;

  //#MR 20.10.2008
  bKeepOnLooping := true;
  while bKeepOnLooping do begin
    dwLastError := ERROR_SUCCESS;
    if not HttpSendRequest(hReq, nil, 0, pBufObsah, delkaObsah) then
      dwLastError := GetLastError();

    if (dwLastError = ERROR_INTERNET_INVALID_CA) then begin
      dwBuffLen := sizeof(dwFlags);

      InternetQueryOption(hReq, INTERNET_OPTION_SECURITY_FLAGS, @dwFlags, dwBuffLen);

      dwFlags := dwFlags or SECURITY_FLAG_IGNORE_UNKNOWN_CA;
      InternetSetOption(hReq, INTERNET_OPTION_SECURITY_FLAGS, @dwFlags, sizeof(dwFlags));
      continue;
    end
    else if dwLastError <> ERROR_SUCCESS then
       ShowLastError(dwLastError);

   //Now check whether data is available
    size := sizeof(data);
    dummy := 0;

    HttpQueryInfo(hReq, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @data, size, dummy);

    Result := data;

    if (data = HTTP_STATUS_DENIED) or (data = HTTP_STATUS_PROXY_AUTH_REQ) then begin

      dwRetVal := InternetErrorDlg(Application.Handle, hReq, dwLastError,
        FLAGS_ERROR_UI_FILTER_FOR_ERRORS or
        FLAGS_ERROR_UI_FLAGS_GENERATE_DATA or
        FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS,
        nilptr);

      if dwRetVal = ERROR_INTERNET_FORCE_RETRY then
        continue
      else {//the only reason is user pressed CANCEL} begin
        InternetCloseHandle(hReq);
        InternetCloseHandle(hConn);
        InternetCloseHandle(hInet);
        exit;
      end;
    end
    else
      bKeepOnLooping := false; //Everything was fine now.
  end; //End while looop

  VysledekStream := TMemoryStream.Create();
  try
    while (true) do begin
      bFlag := InternetReadFile(hReq, @buf, BUFF_SIZE, iBytesRead);
      if ((bFlag) and (not (iBytesRead = 0))) then begin
        VysledekStream.Write(buf, iBytesRead);
      end
      else
        break;
    end;

    VysledekStream.Position := 0;
    SetLength(hotovo, VysledekStream.Size);
    ZeroMemory(@hotovo[1], length(hotovo));
    VysledekStream.Read(hotovo[1], VysledekStream.Size);
    //answerPOST := Utf8ToAnsi(hotovo);
    answerPOST := hotovo;
  finally
    VysledekStream.Free;
  end;

  if hConn <> nil then InternetCloseHandle(hConn);
  if hReq <> nil then InternetCloseHandle(hReq);
  if hInet <> nil then InternetCloseHandle(hInet);
end; {PostToURLQuery}

{-------------------------------------------------------------------------------
  Procedure: TMFCRModule.DeliveryStateE2
  Author:    Martin Radvansk�
  DateTime:  2008.01.27
  Arguments: const ReceiptNumber, ReceiptPassword: string
  Result:    TDeliveryState
  Metoda vyvola dotaz na stav podani, pres lokalni volani WinInet
-------------------------------------------------------------------------------}

function TMFCRModule.DeliveryStateE2(const ReceiptNumber, ReceiptPassword: string): TDeliveryState;
var
  odpoved: string;
  node: IXMLNode;

  ResponseCode: Integer;
  state_Params: string;

begin
  StartWait;
  try
    Result.por_podani := '';
    Result.apl_oblpod := '';
    Result.typ_podani := '';
    Result.c_ufo_prij := '';
    Result.email_ext := '';
    Result.d_podani := '';
    Result.cas_podani := '';
    Result.stav_podpre := '';
    Result.stav_podpre_text := '';
    Result.p_zareppod := '';
    Result.p_platnostpod := '';
    Result.p_chybapod := '';
    Result.stav_podapl := '';
    Result.stav_podapl_text := '';
    Result.d_pripodapl := '';
    Result.pozn_pripodapl := '';
    Result.p_testpod := '';
    if (ReceiptNumber = '') or (ReceiptPassword = '') then
      raise Exception.CreateFmt(errBadReceiptLogin, []);

    try
      state_Params := Format(sMFCREPOStateURLParams_2, [ReceiptNumber, ReceiptPassword]);
      ResponseCode := -1;
      ResponseCode := PostToURLQuery(sMFCREPOStateURL_2, state_Params, nil, '', odpoved);

    except
      on E: Exception do
        raise Exception.CreateFmt(errWSGetEx, [E.Message]);
    end;

    if ResponseCode <> 200 then
      raise Exception.CreateFmt(errWSGetRC, [ResponseCode]);

    if (Length(odpoved) < 10) or (Pos(sXMLStart, odpoved) > 10) then
      raise Exception.CreateFmt(errWSXMLDelka, []);

    XMLDoc.XML.Text := odpoved;
    XMLDoc.Active := TRUE;
    try
      if XMLDoc.DocumentElement.NodeName = 'Stav' then begin
        node := XMLDoc.DocumentElement;
        if (node.ChildNodes <> nil) and (node.ChildNodes.Count > 0) then begin
          Result.por_podani := GetNodeValue(node, sDeliveryFind_por_podani);
          Result.apl_oblpod := GetNodeValue(node, sDeliveryFind_apl_oblpod);
          Result.typ_podani := GetNodeValue(node, sDeliveryFind_typ_podani);
          Result.c_ufo_prij := GetNodeValue(node, sDeliveryFind_c_ufo_prij);
          Result.email_ext := GetNodeValue(node, sDeliveryFind_email_ext);
          Result.d_podani := GetNodeValue(node, sDeliveryFind_d_podani);
          Result.cas_podani := GetNodeValue(node, sDeliveryFind_cas_podani);
          Result.stav_podpre := GetNodeValue(node, sDeliveryFind_stav_podpre);
          Result.stav_podpre_text := GetNodeValue(node, sDeliveryFind_stav_podpre_text);
          Result.p_zareppod := GetNodeValue(node, sDeliveryFind_p_zareppod);
          Result.p_platnostpod := GetNodeValue(node, sDeliveryFind_p_platnostpod);
          Result.p_chybapod := GetNodeValue(node, sDeliveryFind_p_chybapod);
          Result.stav_podapl := GetNodeValue(node, sDeliveryFind_stav_podapl);
          Result.stav_podapl_text := GetNodeValue(node, sDeliveryFind_stav_podapl_text);
          Result.d_pripodapl := GetNodeValue(node, sDeliveryFind_d_pripodapl);
          Result.pozn_pripodapl := GetNodeValue(node, sDeliveryFind_pozn_pripodapl);
          Result.p_testpod := GetNodeValue(node, sDeliveryFind_p_testpod);
        end;
      end;
    finally
      XMLDoc.Active := FALSE;
    end;

  finally
    StopWait;
  end;
end; {DeliveryStateE2}

{-------------------------------------------------------------------------------
  Procedure: TMFCRModule.SendDocumentE2
  Author:    Martin Radvansk�
  DateTime:  2008.01.27
  Arguments: const SignatureFileName, ReceiptFileName: string; const AParams: string; ANaTestovaciServer: boolean = FALSE
  Result:    TReceiptErrors

  Odeslani dokumentu kanalem SSL WinINET
  Program lezi ve slozce /SSL a jmenuje se sendssl.exe
-------------------------------------------------------------------------------}

function TMFCRModule.SendDocumentE2(const SignatureFileName, ReceiptFileName: string;
  const AParams: string; ANaTestovaciServer: boolean = FALSE): TReceiptErrors;
var
  FSReceipt: TFileStream;
  streamSignature: TMemoryStream;
  odpoved: string;
  I: Integer;
  node, node1, node2: IXMLNode;
  ResponseCode: Integer;
  state_Params: string;
  id_predani, heslo_predani:string;

begin
  StartWait;
  streamSignature := TMemoryStream.Create();
  try
    FPotvrzeni := '';
    ResponseCode := -1;
    SetLength(Result, 0);

    if FileExists(ReceiptFileName) then
      if not DeleteFile(ReceiptFileName) then
        raise Exception.CreateFmt(errReceiptFileExists, [ReceiptFileName]);

    try
      streamSignature.LoadFromFile(SignatureFileName);
        //ReadTimeout := ServerTimeOut * 1000;
      if ANaTestovaciServer then begin
        {MessageInfo('', 'Nyn� dojde k ov��en� spr�vnosti pod�n� na testovac�m serveru MF', [MBOK]);}

        state_Params := sMFCREPOSendURLtestParams_2 + AParams;
        ResponseCode := PostToURLQuery(sMFCREPOSendURLtest_2, state_Params, streamSignature, '', odpoved);

      end
      else begin
        //Ostry server
        state_Params := sMFCREPOSendURLParams_2 + AParams;
        ResponseCode := PostToURLQuery(sMFCREPOSendURL_2, state_Params, streamSignature, '', odpoved);
      end;

    except
      on E: EIdConnClosedGracefully do begin
      end;
      on E: Exception do
        raise Exception.CreateFmt(errWSPostEx, [E.Message]);
    end;

    if ResponseCode <> 200 then
      raise Exception.CreateFmt(errWSPostRC, [ResponseCode]);

    if Length(odpoved) < 10 then
      raise Exception.CreateFmt(errWSXMLDelka, []);

    if Pos(sXMLStart, odpoved) > 10 then begin
      //Vraceno potvrzeni podani normalni
      FSReceipt := TFileStream.Create(ReceiptFileName, fmCreate);
      try
        FSReceipt.Write(odpoved[1], Length(odpoved));
        FPotvrzeni := odpoved;
      finally
        FSReceipt.Free;
      end;
    end
    else if (Pos('<Chyby', odpoved)>0) then begin
      //vraceny chyby podani normalni
      XMLDoc.XML.Text := odpoved;
      XMLDoc.Active := TRUE;
      try
        if XMLDoc.DocumentElement.NodeName = 'Chyby' then begin
          node := XMLDoc.DocumentElement;
          SetLength(Result, node.ChildNodes.Count);
          for i := 0 to node.ChildNodes.Count - 1 do begin
            node1 := node.ChildNodes.Nodes[i];
            if node1.NodeName = 'Chyba' then begin
              Result[i].ErrorType := VarToStr(node1.Attributes['Typ']);
              node2 := node1.ChildNodes['Text'];
              if node2 <> nil then
                Result[i].ErrorText := node2.NodeValue;
            end;
          end;
        end;
      finally
        XMLDoc.Active := FALSE;
      end;
    end
    else if (Pos('<Odpoved', odpoved)>0) then begin
      //Vraceno odeslani ke zpracovani
      XMLDoc.XML.Text := odpoved;
      XMLDoc.Active := TRUE;

      id_predani:='';
      heslo_predani:='';

      try
        if XMLDoc.DocumentElement.NodeName = 'Odpoved' then begin
          node := XMLDoc.DocumentElement;
          node2 := node.ChildNodes['Potvrzeni'];
          id_predani:=node2.Attributes['ID_predani'];
          heslo_predani:=node2.Attributes['Heslo'];
          OfflineInfo.OfflineID:=id_predani;
          OfflineInfo.OfflinePassword:=heslo_predani;
          OfflineInfo.Datum:=Now;
        end;
      finally
        XMLDoc.Active := FALSE;
      end;
    end;
  finally
    streamSignature.Free;
    StopWait;
  end;
end;{SendDocumentE2}

//Odeslani dokumentu pomoci synapse
function TMFCRModule.SendDocumentSy(const SignatureFileName, ReceiptFileName,
  AParams: string; ANaTestovaciServer: boolean; ABezPodpisu: boolean): TReceiptErrors;
var
  FSReceipt: TFileStream;
  streamSignature: TMemoryStream;
  odpoved: string;
  I: Integer;
  node, node1, node2: IXMLNode;
  ResponseCode: Integer;
  state_Params: string;
  http:THTTPSend;
  odpb:boolean;
  id_predani,heslo_predani:string;
begin
  StartWait;
  streamSignature := TMemoryStream.Create();
  http:=THTTPSend.Create();
  http.Protocol:='1.1';
  http.ProxyHost:=ProxySettings.ProxyServer;
  http.ProxyPort:=IntToStr(ProxySettings.ProxyPort);
  http.ProxyUser:=ProxySettings.ProxyUserName;
  http.ProxyPass:=ProxySettings.ProxyPassword;
  if ABezPodpisu then
    http.MimeType:=sContentTypeXML
  else
    http.MimeType:=sContentTypePKCS7;
  try
    FPotvrzeni := '';
    ResponseCode := -1;
    SetLength(Result, 0);

    if FileExists(ReceiptFileName) then
      if not DeleteFile(ReceiptFileName) then
        raise Exception.CreateFmt(errReceiptFileExists, [ReceiptFileName]);

    try
      streamSignature.LoadFromFile(SignatureFileName);
      streamSignature.Position:=0;
      http.Document.LoadFromStream(streamSignature);

        //ReadTimeout := ServerTimeOut * 1000;
      if ANaTestovaciServer then begin
        {MessageWarn('', 'Nyn� dojde k odesl�n� pod�n� na testovac� server MF', [MBOK]);}

        odpb:=http.HTTPMethod('POST',sMFCREPOSendURLtest + AParams);
        if not odpb then
          Exception.Create('Chyba p�i komunikaci se serverem https')
        else
          odpoved := ReadStrFromStream(http.Document,http.Document.Size);
        ResponseCode:=http.ResultCode;

      end
      else begin
        //Ostry server
        state_Params := sMFCREPOSendURLParams_2 + AParams;

        odpb := http.HTTPMethod('POST',sMFCREPOSendURL + AParams);
        if not odpb then
          Exception.Create('Chyba p�i komunikaci se serverem https')
        else
          odpoved := ReadStrFromStream(http.Document,http.Document.Size);
        ResponseCode:=http.ResultCode;
      end;

    except
      on E: EIdConnClosedGracefully do begin
      end;
      on E: Exception do
        raise Exception.CreateFmt(errWSPostEx, [E.Message]);
    end;

    if ResponseCode <> 200 then
      raise Exception.CreateFmt(errWSPostRC, [ResponseCode]);

    if Length(odpoved) < 10 then
      raise Exception.CreateFmt(errWSXMLDelka+ '('+odpoved+'), delka v sekci HEADER: '+IntToStr(http.DownloadSize), []);

    if Pos(sXMLStart, odpoved) > 10 then begin
      //Vraceno potvrzeni podani normalni
      FSReceipt := TFileStream.Create(ReceiptFileName, fmCreate);
      try
        FSReceipt.Write(odpoved[1], Length(odpoved));
        FPotvrzeni := odpoved;
      finally
        FSReceipt.Free;
      end;
    end
    else if (Pos('<Chyby', odpoved)>0) then begin
      //vraceny chyby podani normalni
      XMLDoc.XML.Text := odpoved;
      XMLDoc.Active := TRUE;
      try
        if XMLDoc.DocumentElement.NodeName = 'Chyby' then begin
          node := XMLDoc.DocumentElement;
          SetLength(Result, node.ChildNodes.Count);
          for i := 0 to node.ChildNodes.Count - 1 do begin
            node1 := node.ChildNodes.Nodes[i];
            if node1.NodeName = 'Chyba' then begin
              Result[i].ErrorType := VarToStr(node1.Attributes['Typ']);
              node2 := node1.ChildNodes['Text'];
              if node2 <> nil then
                Result[i].ErrorText := node2.NodeValue;
            end;
          end;
        end;
      finally
        XMLDoc.Active := FALSE;
      end;
    end
    else if (Pos('<Odpoved', odpoved)>0) then begin
      //Vraceno odeslani ke zpracovani
      XMLDoc.XML.Text := odpoved;
      XMLDoc.Active := TRUE;

      id_predani:='';
      heslo_predani:='';

      try
        if XMLDoc.DocumentElement.NodeName = 'Odpoved' then begin
          node := XMLDoc.DocumentElement;
          id_predani:=node.ChildNodes['Potvrzeni'].Attributes['ID_Predani'].Text;
          heslo_predani:=node.ChildNodes['Potvrzeni'].Attributes['Heslo'].Text;

          OfflineInfo.OfflineID:=id_predani;
          OfflineInfo.OfflinePassword:=heslo_predani;
          OfflineInfo.Datum:=Now;
        end;
      finally
        XMLDoc.Active := FALSE;
      end;
    end;

  finally
    streamSignature.Free;
    FreeAndNil(http);
    StopWait;
  end;
end;{SendDocumentSy}


function TMFCRModule.QueryOfflineState(Id: string; Heslo:string; proxyServer:string; proxyPort:Integer; serverTimeout:Integer; out Vystup:string; AOpenSSLMode:Boolean=TRUE; ATest:Boolean=FALSE):integer;
  var
    odpoved: string;
    node: IXMLNode;
    ResponseCode: Integer;
    state_Params: string;
    http:THTTPSend;
    odpb:boolean;
    stv:Integer;

  function CheckResultQuery():integer;
  begin
    if ResponseCode <> 200 then
       raise Exception.CreateFmt(errWSGetRC, [ResponseCode]);
    //Test toho co p�i�lo
    if (Pos('<Pisemnost',odpoved)>0) then begin
      Result:=4; // 4 - uz je prijato   cFillingStateFilled
      Vystup:=odpoved;
    end
    else if (Pos('<StavZpracovani',odpoved)>0) then begin
      XMLDoc.XML.Text := odpoved;
      XMLDoc.Active := TRUE;
      try
        if XMLDoc.DocumentElement.NodeName = 'StavZpracovani' then begin
          node := XMLDoc.DocumentElement;
          if node.AttributeNodes.Count=0 then
            stv:=3
          else
            stv := StrToInt(node.Attributes['Stav']);
        end;
      finally
        XMLDoc.Active := FALSE;
      end;
      if (stv=1) then
        Result:=1    //1 cFillingStateSent
      else
        Result:=3;    //3 cFillingStateError
      Vystup:=odpoved;
    end;
  end;{CheckResultQuery}

  function QueryOfflineStateE2():integer;
  begin
    Result:=0;
    try

      ResponseCode := -1;

      if ATest then begin
        state_Params := Format(sMFCREPOStateOfflineURLParamsTest, [Id, Heslo]);
        ResponseCode := PostToURLQuery(sMFCREPOSendURLtest_2, state_Params, nil, '', odpoved);
      end
      else begin
        state_Params := Format(sMFCREPOStateOfflineURLParams, [Id, Heslo]);
        ResponseCode := PostToURLQuery(sMFCREPOStateURL_2, state_Params, nil, '', odpoved);
      end;

    except
      on E: Exception do
        raise Exception.CreateFmt(errWSGetEx, [E.Message]);
    end;

    Result := CheckResultQuery();

  end; {QueryOfflinerStateE2}

  function QueryOfflineStateSy():integer;
  begin
    Result:=0;
    StartWait;
    http:=THTTPSend.Create();
    http.Protocol:='1.1';
    http.ProxyHost:=proxyServer;
    http.ProxyPort:=IntToStr(proxyPort);
    http.ProxyUser:='';
    http.ProxyPass:='';
    http.MimeType:=sContentTypeAsk;
    Vystup:='';
    try
      try
        ResponseCode := -1;
        if ATest then
          odpb:=http.HTTPMethod('POST',Format(sMFCREPOStateOfflineURLTest, [id, Heslo]))
        else
          odpb:=http.HTTPMethod('POST',Format(sMFCREPOStateOfflineURL, [id, Heslo]));
        if not odpb then
          Exception.Create('Chyba p�i komunikaci se serverem https')
        else
          odpoved := ReadStrFromStream(http.Document,http.Document.Size);
        ResponseCode:=http.ResultCode;
      except
        on E: Exception do
          raise Exception.CreateFmt(errWSGetEx, [E.Message]);
      end;

      Result := CheckResultQuery();
    finally
      FreeAndNil(http);
      StopWait;
    end;
  end; {QueryOfflinerStateSy}

begin

 if not AOpenSSLMode then begin
    //WININet
    Result := QueryOfflineStateE2();
    Exit;
  end
  else begin
    //OpenSSL
    Result := QueryOfflineStateSy();
    Exit;
  end;
end;{QueryOfflineState}

function TMFCRModule.DeliveryStateSy(const ReceiptNumber, ReceiptPassword: string): TDeliveryState;
var
  odpoved: string;
  node: IXMLNode;

  ResponseCode: Integer;
  state_Params: string;
  http:THTTPSend;
  odpb:boolean;

begin
  StartWait;
  http:=THTTPSend.Create();
  http.Protocol:='1.1';
  http.ProxyHost:=ProxySettings.ProxyServer;
  http.ProxyPort:=IntToStr(ProxySettings.ProxyPort);
  http.ProxyUser:=ProxySettings.ProxyUserName;
  http.ProxyPass:=ProxySettings.ProxyPassword;
  http.MimeType:=sContentTypePKCS7;
  try
    Result.por_podani := '';
    Result.apl_oblpod := '';
    Result.typ_podani := '';
    Result.c_ufo_prij := '';
    Result.email_ext := '';
    Result.d_podani := '';
    Result.cas_podani := '';
    Result.stav_podpre := '';
    Result.stav_podpre_text := '';
    Result.p_zareppod := '';
    Result.p_platnostpod := '';
    Result.p_chybapod := '';
    Result.stav_podapl := '';
    Result.stav_podapl_text := '';
    Result.d_pripodapl := '';
    Result.pozn_pripodapl := '';
    Result.p_testpod := '';
    if (ReceiptNumber = '') or (ReceiptPassword = '') then
      raise Exception.CreateFmt(errBadReceiptLogin, []);

    try

      ResponseCode := -1;
      odpb:=http.HTTPMethod('POST',Format(sMFCREPOStateURL, [ReceiptNumber, ReceiptPassword]));
      if not odpb then
        Exception.Create('Chyba p�i komunikaci se serverem https')
      else
        odpoved := ReadStrFromStream(http.Document,http.Document.Size);
      ResponseCode:=http.ResultCode;

    except
      on E: Exception do
        raise Exception.CreateFmt(errWSGetEx, [E.Message]);
    end;

    if ResponseCode <> 200 then
      raise Exception.CreateFmt(errWSGetRC, [ResponseCode]);

    if (Length(odpoved) < 10) or (Pos(sXMLStart, odpoved) > 10) then
      raise Exception.CreateFmt(errWSXMLDelka, []);

    XMLDoc.XML.Text := odpoved;
    XMLDoc.Active := TRUE;
    try
      if XMLDoc.DocumentElement.NodeName = 'Stav' then begin
        node := XMLDoc.DocumentElement;
        if (node.ChildNodes <> nil) and (node.ChildNodes.Count > 0) then begin
          Result.por_podani := GetNodeValue(node, sDeliveryFind_por_podani);
          Result.apl_oblpod := GetNodeValue(node, sDeliveryFind_apl_oblpod);
          Result.typ_podani := GetNodeValue(node, sDeliveryFind_typ_podani);
          Result.c_ufo_prij := GetNodeValue(node, sDeliveryFind_c_ufo_prij);
          Result.email_ext := GetNodeValue(node, sDeliveryFind_email_ext);
          Result.d_podani := GetNodeValue(node, sDeliveryFind_d_podani);
          Result.cas_podani := GetNodeValue(node, sDeliveryFind_cas_podani);
          Result.stav_podpre := GetNodeValue(node, sDeliveryFind_stav_podpre);
          Result.stav_podpre_text := GetNodeValue(node, sDeliveryFind_stav_podpre_text);
          Result.p_zareppod := GetNodeValue(node, sDeliveryFind_p_zareppod);
          Result.p_platnostpod := GetNodeValue(node, sDeliveryFind_p_platnostpod);
          Result.p_chybapod := GetNodeValue(node, sDeliveryFind_p_chybapod);
          Result.stav_podapl := GetNodeValue(node, sDeliveryFind_stav_podapl);
          Result.stav_podapl_text := GetNodeValue(node, sDeliveryFind_stav_podapl_text);
          Result.d_pripodapl := GetNodeValue(node, sDeliveryFind_d_pripodapl);
          Result.pozn_pripodapl := GetNodeValue(node, sDeliveryFind_pozn_pripodapl);
          Result.p_testpod := GetNodeValue(node, sDeliveryFind_p_testpod);
        end;
      end;
    finally
      XMLDoc.Active := FALSE;
    end;

  finally
    FreeAndNil(http);
    StopWait;
  end;
end; {DeliveryStateSy}

function TMFCRModule.GetChybyOffline(Data: string):TReceiptErrors;
var
  node,node1,node2: IXMLNode;
  i:Integer;
begin

  if (Pos('<StavZpracovani',Data)>0) then begin
    XMLDoc.XML.Text := Data;
    XMLDoc.Active := TRUE;
    try
      node := XMLDoc.DocumentElement;  //root element stav zpracovani  <StavZpracovani><Chyby><Chyba><
      node := node.ChildNodes.Nodes['Chyby'];  //element <Chyby>

      SetLength(Result, node.ChildNodes.Count); //pocet chyb alokace struktury vysledku
      for i := 0 to node.ChildNodes.Count - 1 do begin   //Pres elementy <Chyba>
        node1 := node.ChildNodes.Nodes[i];               //element <Chyba>
        if node1.NodeName = 'Chyba' then begin
          Result[i].ErrorType := VarToStr(node1.Attributes['Typ']);
          node2 := node1.ChildNodes['Text'];
          if node2 <> nil then
            Result[i].ErrorText := node2.NodeValue;
        end;
      end;
    finally
      XMLDoc.Active := FALSE;
    end;
  end;
end;{GetChybyOffline}


end.


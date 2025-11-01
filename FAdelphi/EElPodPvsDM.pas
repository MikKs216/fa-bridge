{ 13.4.2011 12:48:22 (GMT+2:00) > [martin on TESTXP-2F67BDE0] checked in Doplneno odeslani pro VREP  }
{ 4.2.2010 11:26:46 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in Posilani na PVS pomoci SHA2, nutne nove cssz_const a wcript32  }
{ 7.5.2009 15:04:13 (GMT+2:00) > [mik] checked in Osetreni spravneho hlaseni chyby spojeni a aplikace parametru na zpusob prenosu.  }
{ 17.3.2009 15:39:27 (GMT+1:00) > [martin on MR64PC] checked in test na PVS\\  }
{ 6.2.2009 10:13:37 (GMT+1:00) > [martin on MR64PC] checked in do chyboveho hlaseni doplnena delka z HEADER sekce http pozadavku  }
{ 5.2.2009 14:42:27 (GMT+1:00) > [mik] checked in Doplnen vypis odpovedi  }
{ 3.2.2009 14:32:36 (GMT+1:00) > [martin on MR64PC] checked in Oprava podani pres PVS, zmena obalky  }
{ 14.1.2009 22:19:49 (GMT+1:00) > [martin on MR64PC] checked in Oprava v elektronickem podpisu  }
{ 2.12.2008 21:10:02 (GMT+1:00) > [martin] checked in Final oprava pro OpenSSl a Synapse, chyba v prevodu streamu do stringu  }
{ 2.12.2008 16:12:25 (GMT+1:00) > [martin on MR64PC] checked in oprava prijeti spravnych dat  }
{ 2.12.2008 11:46:09 (GMT+1:00) > [martin on MR64PC] checked in Upraven program pro SYnapsy a Open SSL posledni verze 0.998  }
{ 2.12.2008 8:58:23 (GMT+1:00) > [martin on MR64PC] checked in Zmena hlaseni chyby v SSL  }
{ 18.11.2008 10:43:36 (GMT+1:00) > [martin on MR64PC] checked in Doplnena identifikace v ShowLastError cislem chyby  }
{ 13.11.2008 8:48:10 (GMT+1:00) > [martin on MR64PC] checked in Oprava ve funkci PostToURLQuery pro odeslani pre SSL kanal. Osetreny stavy chyb v certifikatu  }
{ 9.10.2008 14:52:19 (GMT+2:00) > [mik] checked in Doplneno nastaveni SSL do komponenty HTTP  }
{ 4.4.2008 13:34:05 (GMT+1:00) > [martin on NEWMARTINPC] checked in na radku 1031 zmena v CryptAcquireContext na\\PROV_RSA_FULL a CRYPT_VERIFYCONTEXT\\  }
{ 28.1.2008 8:44:55 (GMT+1:00) > [martin on NEWMARTINPC] checked in Zmena posilani SSL pouzito je WinInet API  }
{ 23.1.2008 22:00:25 (GMT+1:00) > [martin on NEWMARTINPC] checked in Doplnena moznost externiho prenosu dat SSL. Automaticky bude pouzita pokud neni u exe souboru libeay32.dll  }
{ 24.9.2007 15:18:15 (GMT+2:00) > [martin on NEWMARTINPC] checked in Doplneny Err kody pro identifikaci problemu s podpisem  }
{ 11.4.2007 10:41:29 (GMT+2:00) > [martin on NEWMARTINPC] checked in Opravy v elektronickem podpisu  }
unit EElPodPvsDM;

{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cssz_certificate, OleServer, Wcrypt2, msxml, Variants, JclStrings,
  JclShell, JclSysUtils, WinInet, httpsend, ssl_openssl, synautil, FCommonUtils,
  SpolFunkce, SynaCode;

type

  TProxySettings = record
    ProxyServer: string;
    ProxyPort: Integer;
    ProxyUserName: string;
    ProxyPassword: string;
    BasicAuthentication: Boolean;
  end;

  TServerReponseData = record
    XML: string;
    MsgClass: string;
    MsgQualifier: string;
    MsgFunction: string;
    MsgTransactionID: string;
    MsgCorrelationID: string;
    MsgResponseEndPoint: string;
    MsgResponsePollInterval: Integer;
    MsgTimestamp: string;
    ErrRaisedBy: string;
    ErrNumber: string;
    ErrType: string;
    ErrText: string;
    ErrLocation: string;
    //el. znacka
    TimeStampDate: string; //yyyy-mm-dd a nekdy yyyymmdd
    TimeStampTime: string; //hh:mm:ss
    TimeStampSignatureValue: string;
    //chyby
    ErrListCount: string;
    ErrListCountErr: string;
    ErrListCountWarn: string;
    ErrListNrMainErr: string;
    ErrListMsgMainErr: string;
    ErrListText: string;
  end;

  TCSSZModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    // Pomocne metody pro rozklad XML
    function ParseField(const S, FieldName: string): string;
    function ParseNode(const S, NodeName: string): string;
    function GetMultipleField(var S: string; const Prefix,
      Sufix: string): string;
    function GetOneField(const S, Prefix, Sufix: string): string;

    // Rozlozeni XML odpovedi ze serveru
    procedure ParseResponse(var Response: TServerReponseData);

    function PostToURLQuery(strURL, strParams: string; streamTelo: TMemoryStream; strHeader: string; var answerPOST: string): integer;
    procedure ShowLastError(errCode: DWORD);
    function GetErrorMessage(ErrNo: Cardinal): string;

    function IsLocalSSL():bool;
    function SendXMLDataE(const XML, URL: string): TServerReponseData;
    function SendXMLDataE2(const XML, URL: string): TServerReponseData;
    function SendXMLDataSy(const XML, URL: string): TServerReponseData;

  public

    //TimeOut serveru
    ServerTimeOut: integer;

    // Nastaveni proxy serveru
    ProxySettings: TProxySettings;

    // Platne certifikaty pro podpis
    Certificates: TCertificates;

    // Nacteni certifikatu pro podpis
    procedure CertificatesLoad;

    // Uvolneni certifikatu pro podpis
    procedure CertificatesFree;
    //ELDP ***
    // Sestaveni XML souboru pro odeslani pozadavku
    function MakeELDPSubmissionRequestXML(const WSSig, WSEnc: WideString; const
      ID, Pass, VS: string): string;
    // Sestaveni XML souboru pro odeslani pollu
    function MakeELDPSubmissionPollXML(const CorrelationID: string): string;
    // Sestaveni XML souboru pro pozadavek smazani
    function MakeELDPRequestDeleteXML(const CorrelationID: string): string;

    //ELDP Certificate ****
    function MakeELDPSubmissionRequestXMLCert(const WSSig, WSEnc: Widestring; const WSigID, ID, VS: string; ASHA2:boolean): string;
    // Sestaveni XML souboru pro odeslani pollu
    function MakeELDPSubmissionPollXMLCert(const CorrelationID: string): string;
    // Sestaveni XML souboru pro pozadavek smazani
    function MakeELDPRequestDeleteXMLCert(const CorrelationID: string): string;

    //PRIHL ***
    // Sestaveni XML souboru pro odeslani pozadavku
    function MakePRIHLSubmissionRequestXML(const WSSig, WSEnc: WideString; const
      ID, Pass, VS, TypPodani, ETyp: string): string;
    // Sestaveni XML souboru pro odeslani pollu
    function MakePRIHLSubmissionPollXML(const CorrelationID, TypPodani: string):
      string;
    // Sestaveni XML souboru pro pozadavek smazani
    function MakePRIHLRequestDeleteXML(const CorrelationID, TypPodani: string):
      string;

    //PRIHL Cetificate ****
    // Sestaveni XML souboru pro odeslani pozadavku
    function MakePRIHLSubmissionRequestXMLCert(const WSSig, WSEnc: WideString;
      const WSigID, ID, VS, TypPodani, ETyp: string; ASHA2:boolean): string;
    // Sestaveni XML souboru pro odeslani pollu
    function MakePRIHLSubmissionPollXMLCert(const CorrelationID, TypPodani:
      string): string;
    // Sestaveni XML souboru pro pozadavek smazani
    function MakePRIHLRequestDeleteXMLCert(const CorrelationID, TypPodani:
      string): string;

    // Odeslani XML souboru na server
    function SendXMLData(const XML, URL: string;AUseOpenXML:boolean=true): TServerReponseData;
    function GetSignatureValue(certContext: PCCERT_CONTEXT; const AXml: Utf8String):
      string;
    function FindCertificate(hStore: HCERTSTORE; wSigID: string): PCCERT_CONTEXT;
    function GetDigestValue(const AXml: Utf8String): string;
    function GetDigestValueSHA2(const AXml: Utf8String): string;
    function LoadResponseData(const AFileName: string): TServerReponseData;
    function FormatDateCompact(const ADateStr: string): string;
  end;

  TXmlCanonizer = class
  private
    function BuildXmlString(ARootNode: IXMLDOMNode): string;
    function BuildAttributes(ANode: IXMLDOMNode): string;
    function NormalizeAttributeValue(AValue: string): string;
    function NormalizeText(AText: string): string;
  public
    function Canonicalize(ARootNode: IXMLDOMNode): string;
  end;

var
  CSSZModule: TCSSZModule;

implementation

{$R *.DFM}

uses
  ComObj, IdException, synachar, XMLDoc, XMLIntf,
  cssz_consts, cssz_utils, cssz_resources, JclFileUtils;

procedure TCSSZModule.DataModuleCreate(Sender: TObject);
begin
  ProxySettings.ProxyServer := '';
  ProxySettings.ProxyPort := 0;
  ProxySettings.ProxyUserName := '';
  ProxySettings.ProxyPassword := '';
  ProxySettings.BasicAuthentication := FALSE;
  Certificates := nil;
end;

procedure TCSSZModule.DataModuleDestroy(Sender: TObject);
begin
  CertificatesFree;
end;

function TCSSZModule.ParseField(const S, FieldName: string): string;
var
  I: Integer;
  PomS: string;
begin
  Result := '';
  PomS := S;
  I := Pos(FieldName + '="', PomS);
  if I >= 1 then begin
    Delete(PomS, 1, I + Length(FieldName) + 1);
    I := Pos('"', PomS);
    if I > 1 then
      Result := Copy(PomS, 1, I - 1);
  end;
end;

function TCSSZModule.ParseNode(const S, NodeName: string): string;
var
  PomS: string;
  I: Integer;
begin
  PomS := GetOneField(S, '<' + NodeName + '>', '</' + NodeName + '>');
  if PomS = '' then begin
    PomS := GetOneField(S, '<' + NodeName + ' ', '</' + NodeName + '>');
    I := Pos('>', PomS);
    if I < 1 then
      PomS := ''
    else
      Delete(PomS, 1, I);
  end;
  Result := PomS;
end;

function TCSSZModule.GetMultipleField(var S: string; const Prefix,
  Sufix: string): string;
var
  Index: Integer;
begin
  Result := '';
  S := Trim(S);
  Index := Pos(Prefix, S);
  if Index > 0 then begin
    Delete(S, 1, Index + Length(Prefix) - 1);
    Index := Pos(Sufix, S);
    Result := Trim(Copy(S, 1, Index - 1));
    Delete(S, 1, Index + Length(Sufix) - 1);
  end;
end;

function TCSSZModule.GetOneField(const S, Prefix, Sufix: string): string;
var
  PomStr: string;
begin
  PomStr := S;
  Result := GetMultipleField(PomStr, Prefix, Sufix);
end;

procedure TCSSZModule.ParseResponse(var Response: TServerReponseData);
var
  XMLDoc: TXMLDocument;
  node, node1: IXMLNode;
  i: integer;
  ok: boolean;
  str: string;
begin
  Response.MsgClass := ParseNode(Response.XML, sResponseMsgClass);
  Response.MsgQualifier := ParseNode(Response.XML, sResponseMsgQualifier);
  Response.MsgFunction := ParseNode(Response.XML, sResponseMsgFunction);
  Response.MsgTransactionID := ParseNode(Response.XML,
    sResponseMsgTransactionID);
  Response.MsgCorrelationID := ParseNode(Response.XML,
    sResponseMsgCorrelationID);
  Response.MsgResponseEndPoint := ParseNode(Response.XML,
    sResponseMsgResponseEndPoint);
  try
    Response.MsgResponsePollInterval := StrToIntSafe(
      ParseField(Response.XML, sResponseMsgPollInterval));
  except
    Response.MsgResponsePollInterval := 0;
  end;
  Response.MsgTimestamp := ParseNode(Response.XML, sResponseMsgTimestamp);
  Response.ErrRaisedBy := ParseNode(Response.XML, sResponseErrRaisedBy);
  Response.ErrNumber := ParseNode(Response.XML, sResponseErrNumber);
  Response.ErrType := ParseNode(Response.XML, sResponseErrType);
  Response.ErrText := ParseNode(Response.XML, sResponseErrText);
  Response.ErrLocation := ParseNode(Response.XML, sResponseErrLocation);
  //el. znacka

  Response.TimeStampDate:='';
  Response.TimeStampTime:='';
  Response.TimeStampSignatureValue:='';
  Response.ErrListCount:='';
  Response.ErrListCountErr:='';
  Response.ErrListCountWarn:='';
  Response.ErrListNrMainErr:='';
  Response.ErrListMsgMainErr:='';
  Response.ErrListText:='';

  XMLDoc := TXMLDocument.Create(Self);
  try
    XMLDoc.XML.Text := Response.XML;
    XMLDoc.Active := TRUE;
{    node := XMLDoc.DocumentElement;
    if node <> nil then begin
      node := node.ChildNodes.FindNode('Body');
      if node <> nil then begin
        node1 := nil;
        for i := 0 to node.ChildNodes.Count - 1 do
          if node.ChildNodes.Nodes[i].NodeName = 'Signature' then
            node1 := node.ChildNodes.Nodes[i];
      end;
      node := node1;
      if node <> nil then begin
        node1 := nil;
        for i := 0 to node.ChildNodes.Count - 1 do
          if node.ChildNodes.Nodes[i].NodeName = sResponseTimeStampSignatureValue
            then begin
            node1 := node.ChildNodes.Nodes[i];
            Response.TimeStampSignatureValue := node1.NodeValue;
          end;
      end;
      if node <> nil then begin
        node1 := nil;
        for i := 0 to node.ChildNodes.Count - 1 do
          if node.ChildNodes.Nodes[i].NodeName = 'TimeStamp' then
            node1 := node.ChildNodes.Nodes[i];
      end;
      node := node1;
      if node <> nil then begin
        node1 := nil;
        for i := 0 to node.ChildNodes.Count - 1 do
          if node.ChildNodes.Nodes[i].NodeName = sResponseTimeStampDate then
          begin
            node1 := node.ChildNodes.Nodes[i];
            Response.TimeStampDate := node1.NodeValue;
          end;
        for i := 0 to node.ChildNodes.Count - 1 do
          if node.ChildNodes.Nodes[i].NodeName = sResponseTimeStampTime then
          begin
            node1 := node.ChildNodes.Nodes[i];
            Response.TimeStampTime := node1.NodeValue;
          end;
      end;
    end;}
    //nacteni chyb
    node := XMLDoc.DocumentElement;
    if node <> nil then begin
      node := node.ChildNodes.FindNode('Body');
      if node<>nil then begin
        for i := 0 to node.ChildNodes.Count - 1 do begin
          ok:=false;
          if node.ChildNodes.Nodes[i].NodeName='Message' then begin
            node:=node.ChildNodes.Nodes[i];
            ok:=true;
            break;
          end;
        end;
        if ok and (node<>nil) then begin
          for i := 0 to node.ChildNodes.Count - 1 do begin
            ok:=false;
            if node.ChildNodes.Nodes[i].NodeName='Header' then begin
              node:=node.ChildNodes.Nodes[i];
              ok:=true;
              break;
            end;
          end;
        end;
        if ok and (node<>nil) then begin
          for i := 0 to node.ChildNodes.Count - 1 do begin
            ok:=false;
            if node.ChildNodes.Nodes[i].NodeName='Signature' then begin
              node:=node.ChildNodes.Nodes[i];
              ok:=true;
              break;
            end;
          end;
        end;
        if ok and (node<>nil) then begin
          for i := 0 to node.ChildNodes.Count - 1 do begin
            ok:=false;
            if node.ChildNodes.Nodes[i].NodeName='TimeStamp' then begin
              node:=node.ChildNodes.Nodes[i];
              ok:=true;
              break;
            end;
          end;
        end;
        if ok and (node<>nil) then begin
          for i := 0 to node.ChildNodes.Count - 1 do begin
            if node.ChildNodes.Nodes[i].NodeName='date' then begin
              Response.TimeStampDate := node.ChildNodes.Nodes[i].NodeValue;
            end;
            if node.ChildNodes.Nodes[i].NodeName='time' then begin
              Response.TimeStampTime := node.ChildNodes.Nodes[i].NodeValue;
            end;
          end;
        end;
      end;
    end;
    //
    node := XMLDoc.DocumentElement;
    if node <> nil then begin
      node := node.ChildNodes.FindNode('Body');
      if node<>nil then begin
        for i := 0 to node.ChildNodes.Count - 1 do begin
          ok:=false;
          if node.ChildNodes.Nodes[i].NodeName='Message' then begin
            node:=node.ChildNodes.Nodes[i];
            ok:=true;
            break;
          end;
        end;
        if ok and (node<>nil) then begin
          for i := 0 to node.ChildNodes.Count - 1 do begin
            ok:=false;
            if node.ChildNodes.Nodes[i].NodeName='Body' then begin
              node:=node.ChildNodes.Nodes[i];
              ok:=true;
              break;
            end;
          end;
        end;
        if ok and (node<>nil) then begin
          for i := 0 to node.ChildNodes.Count - 1 do begin
            ok:=false;
            if node.ChildNodes.Nodes[i].NodeName='ProcessingResult' then begin
              node:=node.ChildNodes.Nodes[i];
              Response.ErrListCount:=node.Attributes['count'];
              Response.ErrListCountErr:=node.Attributes['countErr'];
              Response.ErrListCountWarn:=node.Attributes['countWar'];
              Response.ErrListNrMainErr:=node.Attributes['errNumber'];
              Response.ErrListMsgMainErr:=node.Attributes['errMsg'];
              ok:=true;
              break;
            end;
          end;
        end;
        if ok and (node<>nil) then begin
          for i := 0 to node.ChildNodes.Count - 1 do begin
            ok:=false;
            if node.ChildNodes.Nodes[i].NodeName='Details' then begin
              node:=node.ChildNodes.Nodes[i];
              ok:=true;
              break;
            end;
          end;
        end;
        Response.ErrListText:='';
        if ok and (node<>nil) then begin
          for i := 0 to node.ChildNodes.Count - 1 do begin
            if node.ChildNodes.Nodes[i].NodeName='Item' then begin
              node1:=node.ChildNodes.Nodes[i];
              if node1.Attributes['sqnr']<>'' then begin
                if node1.Attributes['result']='ERROR' then
                  str:='CHYBA'
                else
                  str:=node1.Attributes['result'];
                Response.ErrListText:=Response.ErrListText+
                  node1.Attributes['sqnr']+': '+
                  node1.Attributes['identifier']+' '+
                  str+#13#10+
                  node1.Attributes['errMsg']+#13#10#13#10;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    XMLDoc.Active := FALSE;
    XMLDoc.Free;
  end;
end;

procedure TCSSZModule.CertificatesLoad;
begin
  CertificatesFree;
  Certificates := TCertificates.Create;
end;

procedure TCSSZModule.CertificatesFree;
begin
  if Assigned(Certificates) then
    Certificates.Free;
end;

//ELDP ******

function TCSSZModule.MakeELDPSubmissionRequestXML(const WSSig, WSEnc:
  WideString;
  const ID, Pass, VS: string): string;
begin
  Result := sXMLSubmissionRequestELDP1 + ID + sXMLSubmissionRequestELDP2 + Pass
    +
    sXMLSubmissionRequestELDP3 + VS + sXMLSubmissionRequestELDP4 + WSSig +
    sXMLSubmissionRequestELDP5 + WSEnc + sXMLSubmissionRequestELDP6;
end;

function TCSSZModule.MakeELDPSubmissionPollXML(const CorrelationID: string):
  string;
begin
  Result := sXMLSubmissionPollELDP1 + CorrelationID + sXMLSubmissionPollELDP2;
end;

function TCSSZModule.MakeELDPRequestDeleteXML(const CorrelationID: string):
  string;
begin
  Result := sXMLRequestDeleteELDP1 + CorrelationID + sXMLRequestDeleteELDP2;
end;

//PRIHL ****** pripraveno na univerzalni podani vice typu tiskopisu

function TCSSZModule.MakePRIHLSubmissionRequestXML(const WSSig, WSEnc:
  WideString;
  const ID, Pass, VS, TypPodani, ETyp: string): string;
begin
  Result := sXMLSubmissionRequestPRIHL1 + TypPodani +
    sXMLSubmissionRequestPRIHL1a +
    ID + sXMLSubmissionRequestPRIHL2 + Pass +
    sXMLSubmissionRequestPRIHL3 + VS + sXMLSubmissionRequestPRIHL4 + ETyp+
    sXMLSubmissionRequestPRIHL4a + WSSig +
    sXMLSubmissionRequestPRIHL5 + WSEnc + sXMLSubmissionRequestPRIHL6;
end;

function TCSSZModule.MakePRIHLSubmissionPollXML(const CorrelationID,
  TypPodani: string): string;
begin
  Result := sXMLSubmissionPollPRIHL1 + TypPodani + sXMLSubmissionPollPRIHL1a +
    CorrelationID + sXMLSubmissionPollPRIHL2;
end;

function TCSSZModule.MakePRIHLRequestDeleteXML(const CorrelationID,
  TypPodani: string): string;
begin
  Result := sXMLRequestDeletePRIHL1 + TypPodani + sXMLRequestDeletePRIHL1a +
    CorrelationID + sXMLRequestDeletePRIHL2;
end;
// ******

//Testujeme zda existuje lokalni kopie libeay32.dll
function TCSSZModule.IsLocalSSL():bool;
begin
  Result:= FileExists(ExtractFilePath(Application.ExeName) + 'libeay32.dll');
end; {TestLocalSSL}

function TCSSZModule.SendXMLData(const XML, URL: string; AUseOpenXML:boolean = true): TServerReponseData;
var
  FSXML: TMemoryStream;
  MSResult: TMemoryStream;
  S,pth: string;
  sl:TStringList;
begin

  {$IFDEF STANDALONE}
     pth:=NormalPath(GetWorkPath);
  {$ELSE STANDALONE}
     pth:=NormalPath(GetTempPath);
  {$ENDIF STANDALONE}

 {$IFDEF PVSTEST}
   sl:=TStringList.Create();
   try
     sl.Add('URL: '+URL+#13#10);
     sl.Add(XML);
     sl.SaveToFile(pth+'submission.txt');
   finally
     FreeAndNil(sl);
   end;
  {$ENDIF}

  if not AUseOpenXML then begin
    //Posleme to WinInetAPI
    Result := SendXMLDataE2(XML, URL);
    Exit;
  end
  else begin
    //Posleme to OpenSSL
    Result := SendXMLDataSy(XML, URL);
    Exit;
  end;

  (*
  Result.XML := '';
  ParseResponse(Result);
  Result.ErrText := '';
    //pouzito na predani textu vyjimek pro zapracovani v protokolu
  MSResult := TMemoryStream.Create;
  try
    FSXML := TMemoryStream.Create;
    try
      FSXML.Write(XML[1], Length(XML));
      FSXML.Position := 0;
      HTTP.ProxyParams.ProxyServer := ProxySettings.ProxyServer;
      HTTP.ProxyParams.ProxyPort := ProxySettings.ProxyPort;
      HTTP.ProxyParams.ProxyUsername := ProxySettings.ProxyUserName;
      HTTP.ProxyParams.ProxyPassword := ProxySettings.ProxyPassword;
      HTTP.ProxyParams.BasicAuthentication := ProxySettings.BasicAuthentication;
      HTTP.Request.ContentType := sContentTypeTextXML;
      HTTP.Request.Referer := '';
{$IFDEF VER130}
      HTTP.ConnectTimeout := ServerTimeOut * 1000;
{$ELSE VER130}
      HTTP.ReadTimeout := ServerTimeOut * 1000;
{$ENDIF VER130}
      try
        CSSZModule.HTTP.Post(URL, FSXML, MSResult);
        SetLength(S, MSResult.Size);
        MSResult.Position := 0;
        MSResult.Read(S[1], MSResult.Size);
      except
        on E: EIdConnClosedGracefully do begin
        end;
        on E: Exception do begin
          Result.ErrText := Format(errWSPostEx, [E.Message]);
          EXIT;
          {raise Exception.CreateFmt(errWSPostEx, [E.Message]);}
        end;
      end;
      if CSSZModule.HTTP.ResponseCode <> 200 then begin
        Result.ErrText := Format(errWSPostRC, [CSSZModule.HTTP.ResponseCode]);
        {raise Exception.CreateFmt(errWSPostRC, [CSSZModule.HTTP.ResponseCode]);}
      end;
      if Length(S) < 10 then begin
        Result.ErrText := Format(errWSXMLDelka, []);
        {raise Exception.CreateFmt(errWSXMLDelka, []);}
      end;
      if Result.ErrText = '' then begin
        Result.XML := S;
        ParseResponse(Result);
      end;
    finally
      FSXML.Free;
    end;
  finally
    MSResult.Free;
  end;
  *)
end;{SendXMLData}

//Odeslani dat na https server pomoci externiho procesu
//Program lezi ve slozce /SSL a jmenuje se sendssl.exe
function TCSSZModule.SendXMLDataE(const XML, URL: string): TServerReponseData;
var
  FSXML: TMemoryStream;
  MSResult: TMemoryStream;
  S: string;
  ResponseCode:Integer;
  FileNameResult, FilenameSrc, ExeName, Command: string;
  TransferLog:TStringList;

begin
  Result.XML := '';
  ParseResponse(Result);
  Result.ErrText := '';
    //pouzito na predani textu vyjimek pro zapracovani v protokolu
  MSResult := TMemoryStream.Create;
  TransferLog:=TStringList.Create();
  try
    FSXML := TMemoryStream.Create;
    try
      FileNameSrc:=ExtractFilePath(Application.ExeName) + 'SSL\dataxml.xml';
      DeleteFile(FilenameSrc);
      FSXML.Write(XML[1], Length(XML));
      FSXML.Position := 0;
      FSXML.SaveToFile(FileNameSrc);

      FilenameResult := ExtractFilePath(Application.ExeName) + 'SSL\result.xml';
      ExeName := '"' + ExtractFilePath(Application.ExeName) + 'SSL\sendssl.exe"';

      try
        //CSSZModule.HTTP.Post(URL, FSXML, MSResult);
        Command := '"POST" "' + URL + '" "' + FilenameSrc + '" "' + FileNameResult + '" "' +
           iff(ProxySettings.ProxyServer='',' ',ProxySettings.ProxyServer)+
           '" "'+
           IntToStr(ProxySettings.ProxyPort)+
           '" "'+
           Iff(ProxySettings.ProxyUserName='',' ',ProxySettings.ProxyUserName)+
           '" "'+
           Iff(ProxySettings.ProxyPassword='',' ',ProxySettings.ProxyPassword)+
           '" "'+sContentTypeTextXML+'"';

        ShellExecAndWait(ExeName, Command, '', SW_HIDE);
        MSResult.LoadFromFile(FileNameResult);

        TransferLog.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SSL\Transfer.log');
        if TransferLog.Count>0 then
          ResponseCode:= StrToInt(TransferLog[0])
        else
          ResponseCode:=-1;

        SetLength(S, MSResult.Size);
        MSResult.Position := 0;
        MSResult.Read(S[1], MSResult.Size);
      except
        on E: EIdConnClosedGracefully do begin
        end;
        on E: Exception do begin
          Result.ErrText := Format(errWSPostEx, [E.Message]);
          EXIT;
        end;
      end;

      if ResponseCode <> 200 then begin
        Result.ErrText := Format(errWSPostRC, [ResponseCode]);
        {raise Exception.CreateFmt(errWSPostRC, [CSSZModule.HTTP.ResponseCode]);}
      end;
      if Length(S) < 10 then begin
        Result.ErrText := Format(errWSXMLDelka, [])+ '('+S+')';
        {raise Exception.CreateFmt(errWSXMLDelka, []);}
      end;
      if Result.ErrText = '' then begin
        Result.XML := S;
        ParseResponse(Result);
      end;
    finally
      FSXML.Free;
    end;
  finally
    MSResult.Free;
    TransferLog.Free;
  end;
end;{SendXMLDataE}

function TCSSZModule.LoadResponseData(const AFileName: string): TServerReponseData;
var resp: TServerReponseData;
  s: string;
begin
  if FileExists(AFileName) then begin
    s:=LoadStringFromFile(AFileName);
    Result.XML := s;
    ParseResponse(Result);
  end;
end;

{-------------------------------------------------------------------------------
  Procedure: GetErrorMessage
  Author:    Martin Radvanský
  DateTime:  2008.01.27
  Arguments: ErrNo: Cardinal;
  Result:    string
-------------------------------------------------------------------------------}
function TCSSZModule.GetErrorMessage(ErrNo: Cardinal): string;
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
  Procedure: TCSSZModule.ShowLastError
  Author:    Martin Radvanský
  DateTime:  2008.01.27
  Arguments: errCode: DWORD
  Result:    None
-------------------------------------------------------------------------------}
procedure TCSSZModule.ShowLastError(errCode: DWORD);
var
  sApiError: string;
begin
  sApiError := GetErrorMessage(errCode);
  sApiError := 'Chybový kód Wininet Api: '+IntToStr(errCode)+#13#10+sApiError;
  MessageBox(0, PChar(sApiError), 'Chyba pøi komunikaci s https serverem', MB_OK);
end; {ShowError}


{-------------------------------------------------------------------------------
  Procedure: TCSSZModule.PostToURLQuery
  Author:    Martin Radvanský
  DateTime:  2008.01.27
  Arguments: strURL, strParams: string; streamTelo: TMemoryStream; strHeader: string; var answerPOST: string
  Result:    integer
-------------------------------------------------------------------------------}
function TCSSZModule.PostToURLQuery(strURL, strParams: string; streamTelo: TMemoryStream; strHeader: string; var answerPOST: string): integer;
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
  test:string;
  hotovo: string;

  AcceptType: LPStr;


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
    //13.11.08 osetreni chyb v kontrole certifikatu
    SECURITY_FLAG_IGNORE_CERT_CN_INVALID or SECURITY_FLAG_IGNORE_CERT_DATE_INVALID or
    SECURITY_FLAG_IGNORE_CERT_DATE_INVALID;

  AcceptType := PChar('Accept:*/* ');

  if gbUseSSL then iInternetFlags := iInternetFlags or INTERNET_FLAG_SECURE;
  hReq := HttpOpenRequest(hConn, 'POST', PChar(Canonize(strParams)), 'HTTP/1.1', 'FORMASISTENT',@AcceptType, iInternetFlags, 0);
  if hReq = nil then begin
    dwLastError := GetLastError();
    ShowLastError(dwLastError);
    InternetCloseHandle(hConn);
    InternetCloseHandle(hInet);
    exit;
  end;
  //#MR 13.11.2008
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
    //Zkusime WideString
    //VysledekStream.Position := 0;
    //SetLength(Navrat,(VysledekStream.Size div 2)-1);
    //VysledekStream.Read(Navrat[1], (VysledekStream.Size div 2)-1);
    // NAvrat:=UTF8Decode(hotovo);
    //answerPOST := Utf8ToAnsi(hotovo);
     //answerPOST := UTF8Decode(hotovo);
    answerPOST := hotovo;
  finally
    VysledekStream.Free;
  end;

  if hConn <> nil then InternetCloseHandle(hConn);
  if hReq <> nil then InternetCloseHandle(hReq);
  if hInet <> nil then InternetCloseHandle(hInet);
end; {PostToURLQuery}

{-------------------------------------------------------------------------------
  Procedure: TCSSZModule.SendXMLDataE2
  Author:    Martin Radvanský
  DateTime:  2008.01.28
  Arguments: const XML, URL: string
  Result:    TServerReponseData
  Odeslani dat na https server pomoci WinInet API
-------------------------------------------------------------------------------}
function TCSSZModule.SendXMLDataE2(const XML, URL: string): TServerReponseData;
var
  FSXML: TMemoryStream;
  odpoved: string;
  ResponseCode:Integer;
  adresa,param:string;
  adr:string;
  ix,iy,iz,delka:Integer;
  workFileName: string;
begin
  adresa:=URL;
  param:='';
  delka:=Length(adresa);
  ix:=Pos('://',adresa);
  if ix>0 then begin //je to adresa
    ix:=ix+3; //ukazujeme na : ,musime pricist 3 :a lomitka
    adr:=Copy(adresa,ix,delka);
    iy:=Pos('/',adr);
    if iy>0 then begin //je tady nejaka podslozka
       param:=Copy(adr,iy,length(adr));
       adresa:=Copy(adresa,1,ix+iy-2);
    end;
  end;

  if URL=sCSSZSubmissionURLtest then begin
     adresa:= sCSSZSubmissionURLtest_2;
     param:= sCSSZSubmissionTestParam_2;
  end
  else if URL=sCSSZSubmissionURL then begin
     adresa:= sCSSZSubmissionURL_2;
     param:= sCSSZSubmissionParam_2;
  end
  else if URL=sCSSZSubmissionURLtest_VREP then begin
     adresa:= sCSSZSubmissionURLtest_2_VREP;
     param:= sCSSZSubmissionTestParam_2_VREP;
  end
  else if URL=sCSSZSubmissionURL_VREP then begin
     adresa:= sCSSZSubmissionURL_2_VREP;
     param:= sCSSZSubmissionParam_2_VREP;
  end;

// pro testovani chyby na ostrem serveru
  workFileName:=FindUnusedFileName(GetWorkPath+'CSSZXML','xml','');
  SaveStringToFile(XML,workFileName);
  workFileName:=ChangeFileExt(workFileName,'txt');
  SaveStringToFile(adresa+#13#10+param,workFileName);
//

  Result.XML := '';
  ParseResponse(Result);
  Result.ErrText := '';
  ResponseCode:=-1;
  //pouzito na predani textu vyjimek pro zapracovani v protokolu
  FSXML := TMemoryStream.Create;
  try
    FSXML.Write(XML[1], Length(XML));
    FSXML.Position := 0;

    try
      //CSSZModule.HTTP.Post(URL, FSXML, MSResult);
      ResponseCode:=PostToURLQuery(adresa,param,FSXML,'',odpoved);
    except
      on E: EIdConnClosedGracefully do begin
      end;
      on E: Exception do begin
        Result.ErrText := Format(errWSPostEx, [E.Message]);
        EXIT;
      end;
    end;

    if ResponseCode <> 200 then begin
      Result.ErrText := Format(errWSPostRC, [ResponseCode]);
      {raise Exception.CreateFmt(errWSPostRC, [CSSZModule.HTTP.ResponseCode]);}
    end;
    if Length(odpoved) < 10 then begin
      Result.ErrText := Format(errWSXMLDelka, [])+ '('+odpoved+')';
      {raise Exception.CreateFmt(errWSXMLDelka, []);}
    end;
    if Result.ErrText = '' then begin
      Result.XML := odpoved;
      ParseResponse(Result);

    end;
  finally
    FSXML.Free;
  end;
end;{SendXMLDataE2}


// ****************** Autentifikace pomoci certifikatu ************************

//Hledame stejny hash SHA1
function TCSSZModule.FindCertificate(hStore: HCERTSTORE; wSigID: string): PCCERT_CONTEXT;
var
  I: Integer;
  pCert, oldCert, testCert: PCCERT_CONTEXT;
  nameString: Pchar;
  blob: CERT_NAME_BLOB;
  blobSerial: CRYPT_INTEGER_BLOB;
  cryptHash:Crypt_HASH_BLOB;
  size: DWORD;
  pbData:PByte;
  cbSizeData:DWORD;
  rData:PByte;
  ixPData:PByte;
  ixPSrc:PByte;
  datahash:string;
  lastErr: Cardinal;

procedure ConvertStrToBinStr();
var
  i,ix:Integer;
  znak:string;
  bajt:Byte;
begin
  ix:=1;
  i:=1;
  repeat
     znak:=wSigID[i];
     if Char (UpperCase(znak)[1]) in ['0'..'9'] then
       bajt:= ((ord(Char(UpperCase(znak)[1]))-ord('0'))shl 4)
     else if Char(UpperCase(znak)[1]) in ['A'..'F'] then
       bajt:= (((ord(Char(UpperCase(znak)[1]))-ord('A'))+10) shl 4);
     Inc(i);
     znak:=wSigID[i];
     if Char(UpperCase(znak)[1]) in ['0'..'9'] then
       bajt:= bajt + (ord(Char(UpperCase(znak)[1]))-ord('0'))
     else if Char(UpperCase(znak)[1]) in ['A'..'F'] then
       bajt:= bajt + (ord(Char(UpperCase(znak)[1]))-ord('A'))+10;
     datahash[ix]:=Char(bajt);
     Inc(ix);
     Inc(i);
  until (i > Length(wSigID));

end;

begin
  pCert := nil;
  oldCert := nil;

    testCert := nil;

    SetLength(dataHash,Length(wSigID) div 2);
    ConvertStrToBinStr();

    //dataHash := #81#137#39#18#30#127#202#242#99#07#101#185#95#152#103#73#81#254#164#71;
    cryptHash.cbData:=length(dataHash);

    //Naplnit data hashe
    cryptHash.pbData := Pointer(dataHash);
    testCert := CertFindCertificateInStore(hstore,
      (PKCS_7_ASN_ENCODING or X509_ASN_ENCODING),
       0,
       CERT_FIND_HASH,
       @cryptHash,
       nil);

    if testCert=nil then begin
       lastErr:= GetLastError();
       ShowMessage('Nelze najít cerifikát (CertFindCertificateInStore): '+ intToStr(lastErr));
    end;

    result:= testCert;
    (*
    repeat
      pCert := CertEnumCertificatesInStore(hStore, oldCert);
      if pCert = nil then
        Break;

      oldCert := pCert;
      blob := pCert^.pCertInfo^.Subject;
      blobSerial := pCert^.pCertInfo^.SerialNumber;
      pbData := blobSerial.pbData;
      cbSizeData := blobSerial.cbData;
      GetMem(rData, cbSizeData);
      //Naplnime strukturu opacne nez je ulozeny zdroj
      ixPData:=rData;
      inc(ixPData,cbSizeData-1);
      ixPSrc:=pbData;
      for I := 0 to cbSizeData - 1 do    // Iterate
      begin
        ixPData^:=(ixPsrc)^;
        inc(ixPSrc);
        dec(ixPData);
      end;    // for

      size := CertNameToStr((PKCS_7_ASN_ENCODING or X509_ASN_ENCODING), @blob,
        CERT_X500_NAME_STR, nameString, 512);
      if size > 1 then begin

        if Pos(WSigID, nameString) > 0 then begin
          //test na cislo certifikatu
          result := pCert;
          Exit;
        end;
      end;
    until (pCert = nil);
    Result := nil;
    pCert := nil;
  finally
    StrDispose(nameString);
  end;
  *)
end; {FindCertificate}

function TCSSZModule.GetSignatureValue(certContext: PCCERT_CONTEXT; const AXml: Utf8string): string;
var
  ok: Boolean;
  i, j: Integer;
  strSignature, strSignatureR: string;
  CryptProv: HCRYPTPROV;
  keySpec: DWORD;
  HHash: HCRYPTHASH;
  signature: PByte;
  signVelikost: DWord;
  errCode:Cardinal;
begin

  signature:=nil;
  HHASH:=0;
  CryptProv:=0;

  //Ziskat privatni klic
  ok := CryptAcquireCertificatePrivateKey(certContext, 0, nil, @CryptProv, @keySpec, nil);
  try

    if not ok then begin
      errCode := GetLastError();
      ShowMessage('Nelze získat pøístup k privátnímu klíèi (CryptAcquireCertificatePrivateKey): '+ intToStr(errCode));
      Result:='';
      Exit;
    end;

    //hash SHA
    ok := CryptCreateHash(CryptProv, CALG_SHA1, 0, 0, @HHASH);
    if (not ok) then begin
      errCode := GetLastError();
      ShowMessage('Chyba pøi vytvoøení Hash (CryptCreateHash) '+ intToStr(errCode));
      result:='';
      EXIT;
    end;
    ok := CryptHashData(HHASH, Pointer(AXml), length(Axml), 0);
    if (not ok) then begin
      errCode := GetLastError();
      ShowMessage('Chyba pøi vytvoøení Hash (CryptHashData) '+ intToStr(errCode));
      result:='';
      EXIT;
    end;
 {   //Testovaci hash
     try
      dwordSize := SizeOf(DWORD);
      if not CryptGetHashParam(hhash, HP_HASHSIZE, @hashSize, @dwordSize, 0) then
      begin
        raise Exception.Create('Chyba GetHashParams');
      end;
      GetMem(pdata, hashSize);
      if not CryptGetHashParam(hhash, HP_HASHVAL, pdata, @hashSize, 0) then begin
        raise Exception.Create('Chyba Get Params');
      end;
      SetLength(testhash, hashSize);
      system.Move(pdata^, testHash[1], hashSize);
    finally
      FreeMem(pdata);
    end;
  }
    //Podepsat hash1
    ok := CryptSignHash(HHASH, keySpec {AT_SIGNATURE}, nil, 0 , nil, @signVelikost);

    if (not ok) then begin
      errCode := GetLastError();
      ShowMessage('Chyba pøi zjištìní velikosti signatury (CryptSignHash) '+ intToStr(errCode));
      result:='';
      EXIT;
    end;
    GetMem(signature, signVelikost);

    ok := CryptSignHash(HHASH, keySpec{AT_SIGNATURE}, nil, 0 , signature, @signVelikost);

    if (not ok) then begin
      errCode := GetLastError();
      ShowMessage('Chyba pøi vytváøení podpisu SHA1 signatury (CryptSignHash) '+intToStr(errCode));
      result:='';
      EXIT;
    end;

    setlength(strSignature, signVelikost);
    setlength(strSignatureR, signVelikost);

    system.Move(signature^, Pointer(strSignature)^, signVelikost);

    //Reverzovat
    j := 1;
    for i := signVelikost downto 1 do begin
      strSignatureR[j] := strSignature[i];
      Inc(j);
    end;

  finally
    if signature <> nil then
      FreeMem(signature);
    if HHash <> 0 then
      CryptDestroyHash(HHASH);
    if CryptProv <> 0 then
      CryptReleaseContext(CryptProv, 0);
  end;
  result := strSignatureR;
end;

//Hash SHA1 pro element Axml vraci string

function TCSSZModule.GetDigestValue(const AXml: UTF8String): string;
var
  context: HCRYPTPROV;
  hash: HCRYPTHASH;
  pdata: PByte;
  hashSize, dwordSize: DWORD;
  errCode : cardinal;
begin
  pdata := nil;
  //if not CryptAcquireContext(@context, nil, nil, PROV_RSA_SCHANNEL, 0) then begin
  if not CryptAcquireContext(@context, nil, nil, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) then begin
    errCode := GetLastError();
    raise Exception.Create('Chyba Digest value (CryptAcquireContext): '+ intToStr(errCode));
  end;
  try
    if not CryptCreateHash(context, CALG_SHA1, 0, 0, @hash) then begin
      errCode := GetLastError();
      raise Exception.Create('Chyba CryptCreateHash '+ intToStr(errCode));
    end;
    if not CryptHashData(hash, Pointer(AXml), Length(AXml), 0) then begin
      errCode := GetLastError();
      raise Exception.Create('Chyba CryptHashData' + intToStr(errCode));
    end;

    try
      dwordSize := SizeOf(DWORD);
      if not CryptGetHashParam(hash, HP_HASHSIZE, @hashSize, @dwordSize, 0) then
      begin
        errCode := GetLastError();
        raise Exception.Create('Chyba_1 CryptGetHashParam '+ intToStr(errCode));
      end;
      GetMem(pdata, hashSize);

      if not CryptGetHashParam(hash, HP_HASHVAL, pdata, @hashSize, 0) then begin
        errCode := GetLastError();
        raise Exception.Create('Chyba_2 CryptGetHashParam' + intToStr(errCode));
      end;
      SetLength(Result, hashSize);
      system.Move(pdata^, Result[1], hashSize);
    finally
      if Assigned(pdata) then
        FreeMem(pdata);
      CryptDestroyHash(hash);
    end;
  finally
    CryptReleaseContext(context, 0);
  end;
end; {GetDigestValue}

//Hash SHA1 pro element Axml vraci string

function TCSSZModule.GetDigestValueSHA2(const AXml: UTF8String): string;
var
  context: HCRYPTPROV;
  hash: HCRYPTHASH;
  pdata: PByte;
  hashSize, dwordSize: DWORD;
  errCode : cardinal;
begin
  pdata := nil;
  //if not CryptAcquireContext(@context, nil, nil, PROV_RSA_SCHANNEL, 0) then begin
  if not CryptAcquireContext(@context, nil, nil, PROV_RSA_AES, CRYPT_VERIFYCONTEXT) then begin
    errCode := GetLastError();
    raise Exception.Create('Chyba Digest value (CryptAcquireContext): '+ intToStr(errCode));
  end;
  try
    if not CryptCreateHash(context, CALG_SHA_256, 0, 0, @hash) then begin
      errCode := GetLastError();
      raise Exception.Create('Chyba CryptCreateHash SHA 256'+ intToStr(errCode));
    end;
    if not CryptHashData(hash, Pointer(AXml), Length(AXml), 0) then begin
      errCode := GetLastError();
      raise Exception.Create('Chyba CryptHashData' + intToStr(errCode));
    end;

    try
      dwordSize := SizeOf(DWORD);
      if not CryptGetHashParam(hash, HP_HASHSIZE, @hashSize, @dwordSize, 0) then
      begin
        errCode := GetLastError();
        raise Exception.Create('Chyba_1 CryptGetHashParam '+ intToStr(errCode));
      end;
      GetMem(pdata, hashSize);

      if not CryptGetHashParam(hash, HP_HASHVAL, pdata, @hashSize, 0) then begin
        errCode := GetLastError();
        raise Exception.Create('Chyba_2 CryptGetHashParam' + intToStr(errCode));
      end;
      SetLength(Result, hashSize);
      system.Move(pdata^, Result[1], hashSize);
    finally
      if Assigned(pdata) then
        FreeMem(pdata);
      CryptDestroyHash(hash);
    end;
  finally
    CryptReleaseContext(context, 0);
  end;
end; {GetDigestValueSha2}

//ELDP ******

function TCSSZModule.MakeELDPSubmissionRequestXMLCert(const WSSig, WSEnc: Widestring; const WSigID, ID, VS: string; ASHA2:boolean): string;

const
  CERT_STORE_NAME: WideString = 'MY';

var
  body: string;
  utfBody: Utf8string;
  encHashB64: string;
  signedInfoElement: string;
  utf8SignedInfo: UTF8String;
  signatureValue: string;
  sPodpisB64: string;
  privateCertB64: string;
  pCertContext:  PCCERT_CONTEXT;
  hStoreHandle: HCERTSTORE;

  delkaCert: Dword;
  strCert, vysledek: string;
  testExp: TStringList;
  dataHash: string;
  podpis: string;
  xmlCanonizer: TXmlCanonizer;
  doc: IXMLDOMDocument;
  node: IXMLDOMNode;
  podpise, kodovani: string;
  Saver: TStringList;
  text:string;
begin
{$IFDEF ELPODANITEST}
  Saver := TStringList.CREATE();
  try
{$ENDIF}
    xmlCanonizer := TXmlCanonizer.Create();
    podpise := StringReplace(WSSig, #13#10, '', [rfReplaceAll]);
    kodovani := StringReplace(WSEnc, #13#10, '', [rfReplaceAll]);
    //body dokumentu
    //musime kanonizov
    body := sEsXMLSubmissionRequestELDP4 + podpise + sEsXMLSubmissionRequestELDP5
      +
      kodovani + sEsXMLSubmissionRequestELDP6;

{$IFDEF ELPODANITEST}
    Saver.Text := body;
    Saver.SaveToFile(ExtractFilePath(Application.ExeName) + '_BodyBefore.xml');
{$ENDIF}

    doc := CoDOMDocument.Create();
    try
      doc.loadXML(body);
      node := doc.SelectSingleNode('Body');
      text := xmlCanonizer.Canonicalize(node);
      utfBody := UTF8Encode(text);
    finally
      doc := nil;
    end;
    //kanonizujeme /Govtalkmessage/body v utf8

{$IFDEF ELPODANITEST}
    Saver.Text := utfBody;
    Saver.SaveToFile(ExtractFilePath(Application.ExeName) +
      '_BodyCanonize.xml');
{$ENDIF}

    if not ASHA2 then begin

    //Vypocet SHA1 z utfBody
    dataHash := GetDigestValue(utfBody); //vypocist hash sha1
    encHashB64 := EncodeBase64(dataHash); //zakodovat do base 64

    //Signatuere element a vlozit do nej vypocteny SHA1
    signedInfoElement :=
      sEsXMLSubmissionRequestELDPSignature_1a +
      encHashB64 +
      sEsXMLSubmissionRequestELDPSignature_2; //vytvorit node Signed info a vlozit tam ten hash do elementu Digest Value
   end
   else begin
     //Vypocet SHA2 z utfBody
     dataHash := GetDigestValueSHA2(utfBody); //vypocist hash sha1
     encHashB64 := EncodeBase64(dataHash); //zakodovat do base 64

     //Signatuere element a vlozit do nej vypocteny SHA2
     signedInfoElement :=
       sEsXMLSubmissionRequestELDPSignatureSHA2_1a +
       encHashB64 +
       sEsXMLSubmissionRequestELDPSignature_2; //vytvorit node Signed info a vlozit tam ten hash do elementu Digest Value
   end;


{$IFDEF ELPODANITEST}
    Saver.Text := signedInfoElement;
    Saver.SaveToFile(ExtractFilePath(Application.ExeName) + '_SignedInfo.xml');
{$ENDIF}
   //Podepsat SignedinfoElement prihlasovacim certifikatem a do B64
    //Kanonizovat SignedInfo element
    doc := CoDOMDocument.Create();
    try
      doc.loadXML(signedInfoElement);

      node := doc.SelectSingleNode('SignedInfo');
      text := xmlCanonizer.Canonicalize(node);
    finally
      doc:= nil;
    end;
    utf8SignedInfo := UTF8Encode(text);
{$IFDEF ELPODANITEST}
    Saver.Text := utf8SignedInfo;
    Saver.SaveToFile(ExtractFilePath(Application.ExeName) +
      '_SignedInfoCanonize.xml');
{$ENDIF}

    //Otevreni uloziste
    hStoreHandle := CertOpenSystemStore(0, 'MY');
    try
      //Najit certifikat
      pCertContext := FindCertificate(hStoreHandle, WSigID);

      if pCertContext = nil then begin
        ShowMessage('Nenalezen vybraný certifikát pro pøihlášení');
        Exit;
      end;

      //Podepsat SignedInfo
      podpis := GetSignatureValue(pCertContext, utf8SignedInfo);
      if podpis <> '' then begin
        sPodpisB64 := EncodeBase64(podpis);

        //Vlozit podpis data do signatureValue
        SignatureValue :=
          sEsXMLSubmissionRequestELDPSignature_2a +
          sPodpisB64 +
          sEsXMLSubmissionRequestELDPSignature_3;
        //
{$IFDEF ELPODANITEST}
        Saver.Text := signatureValue;
        Saver.SaveToFile(ExtractFilePath(Application.ExeName) +
          '_SignatureValue.xml');
{$ENDIF}
        //Ziskat X509 certifikat do B64 - OK
        delkaCert := pCertContext^.cbCertEncoded;
        setlength(strCert, delkacert);
        MoveMemory(@strCert[1], pCertContext.pbCertEncoded, delkaCert);
        privateCertB64 := EncodeBase64(strCert);
      end
      else begin
        result := '';
        ShowMessage('Chyba pøi podepisovani');
        Exit;
      end;
      vysledek :=
        sEsXMLSubmissionRequestELDP1 +
        sEsXMLSubmissionRequestELDPSignature_1 +
        signedInfoElement +
        signatureValue +
        sEsXMLSubmissionRequestELDPSign +
        privateCertB64 +
        sEsXMLSubmissionRequestELDP3 +
        VS +
        sEsXMLSubmissionRequestELDP3a +
        body +
        sEsXMLSubmissionRequestELDP6a;

{$IFDEF ELPODANITEST}
      testExp := TStringList.Create();
      try
        testExp.Text := vysledek;
        testExp.SaveToFile(ExtractFilePath(Application.ExeName) +
          'PodaniXml.xml');
      finally
        FreeAndNil(testExp);
      end;
{$ENDIF}
    finally
      if hStoreHandle <> nil then
        CertCloseStore(hStoreHandle, 0);
      if doc <> nil then
        doc := nil;
    end;
{$IFDEF ELPODANITEST}
  finally
    Saver.Free;
  end;
{$ENDIF}
  Result := vysledek;
end;

function TCSSZModule.MakeELDPSubmissionPollXMLCert(const CorrelationID: string):
  string;
begin
  Result := sXMLSubmissionPollELDP1 + CorrelationID + sXMLSubmissionPollELDP2;
end;

function TCSSZModule.MakeELDPRequestDeleteXMLCert(const CorrelationID: string):
  string;
begin
  Result := sXMLRequestDeleteELDP1 + CorrelationID + sXMLRequestDeleteELDP2;
end;

//PRIHL ****** pripraveno na univerzalni podani vice typu tiskopisu

function TCSSZModule.MakePRIHLSubmissionRequestXMLCert(const WSSig, WSEnc:
  WideString; const WSigID, ID, VS, TypPodani,ETyp: string; ASHA2:boolean): string;

const
  CERT_STORE_NAME: WideString = 'MY';

var
  body: string;
  utfBody: Utf8string;
  encHashB64: string;
  signedInfoElement: string;
  utf8SignedInfo: UTF8String;
  signatureValue: string;
  sPodpisB64: string;
  privateCertB64: string;
  pCertContext:  PCCERT_CONTEXT;
  hStoreHandle: HCERTSTORE;

  delkaCert: Dword;
  strCert, vysledek: string;
  testExp: TStringList;
  dataHash: string;
  podpis: string;
  xmlCanonizer: TXmlCanonizer;
  doc: IXMLDOMDocument;
  node: IXMLDOMNode;
  podpise, kodovani: string;
  Saver: TStringList;

  text:string;
begin
{$IFDEF ELPODANITEST}
  Saver := TStringList.CREATE();
  try
{$ENDIF}
    xmlCanonizer := TXmlCanonizer.Create();
    podpise := StringReplace(WSSig, #13#10, '', [rfReplaceAll]);
    kodovani := StringReplace(WSEnc, #13#10, '', [rfReplaceAll]);
    //body dokumentu
    //musime kanonizov
    body := sEsXMLSubmissionRequestPRIHL4+ETyp+sEsXMLSubmissionRequestPRIHL4a +
            podpise + sEsXMLSubmissionRequestPRIHL5 +
            kodovani + sEsXMLSubmissionRequestPRIHL6;

{$IFDEF ELPODANITEST}
    Saver.Text := body;
    Saver.SaveToFile(ExtractFilePath(Application.ExeName) + '_BodyBefore.xml');
{$ENDIF}

    doc := CoDOMDocument.Create();
    try
      doc.loadXML(body);
      node := doc.SelectSingleNode('Body');
      text := xmlCanonizer.Canonicalize(node);
      utfBody := UTF8Encode(text);
    finally
      doc := nil;
    end;
    //kanonizujeme /Govtalkmessage/body v utf8

{$IFDEF ELPODANITEST}
    Saver.Text := utfBody;
    Saver.SaveToFile(ExtractFilePath(Application.ExeName) +
      '_BodyCanonize.xml');
{$ENDIF}
   if not ASHA2 then begin

    //Vypocet SHA1 z utfBody
    dataHash := GetDigestValue(utfBody); //vypocist hash sha1
    encHashB64 := EncodeBase64(dataHash); //zakodovat do base 64

    //Signatuere element a vlozit do nej vypocteny SHA1
    signedInfoElement :=
      sEsXMLSubmissionRequestELDPSignature_1a +
      encHashB64 +
      sEsXMLSubmissionRequestELDPSignature_2; //vytvorit node Signed info a vlozit tam ten hash do elementu Digest Value

   end
   else begin
     //Vypocet SHA2 z utfBody
    dataHash := GetDigestValueSHA2(utfBody); //vypocist hash sha1
    encHashB64 := EncodeBase64(dataHash); //zakodovat do base 64

    //Signatuere element a vlozit do nej vypocteny SHA1
    signedInfoElement :=
      sEsXMLSubmissionRequestELDPSignatureSHA2_1a +
      encHashB64 +
      sEsXMLSubmissionRequestELDPSignature_2; //vytvorit node Signed info a vlozit tam ten hash do elementu Digest Value
   end;
{$IFDEF ELPODANITEST}
    Saver.Text := signedInfoElement;
    Saver.SaveToFile(ExtractFilePath(Application.ExeName) + '_SignedInfo.xml');
{$ENDIF}
   //Podepsat SignedinfoElement prihlasovacim certifikatem a do B64
    //Kanonizovat SignedInfo element
    doc := CoDOMDocument.Create();
    try
      doc.loadXML(signedInfoElement);

      node := doc.SelectSingleNode('SignedInfo');
      text := xmlCanonizer.Canonicalize(node);
    finally
      doc:= nil;
    end;
    utf8SignedInfo := UTF8Encode(text);
{$IFDEF ELPODANITEST}
    Saver.Text := utf8SignedInfo;
    Saver.SaveToFile(ExtractFilePath(Application.ExeName) +
      '_SignedInfoCanonize.xml');
{$ENDIF}

    //Otevreni uloziste
    hStoreHandle := CertOpenSystemStore(0, 'MY');
    try
      //Najit certifikat
      pCertContext := FindCertificate(hStoreHandle, WSigID);

      if pCertContext = nil then begin
        ShowMessage('Nenalezen vybraný certifikát pro pøihlášení');
        Exit;
      end;

      //Podepsat SignedInfo
      podpis := GetSignatureValue(pCertContext, utf8SignedInfo);
      if podpis <> '' then begin
        sPodpisB64 := EncodeBase64(podpis);

        //Vlozit podpis data do signatureValue
        SignatureValue :=
          sEsXMLSubmissionRequestELDPSignature_2a +
          sPodpisB64 +
          sEsXMLSubmissionRequestELDPSignature_3;
        //
{$IFDEF ELPODANITEST}
        Saver.Text := signatureValue;
        Saver.SaveToFile(ExtractFilePath(Application.ExeName) +
          '_SignatureValue.xml');
{$ENDIF}
        //Ziskat X509 certifikat do B64 - OK
        delkaCert := pCertContext^.cbCertEncoded;
        setlength(strCert, delkacert);
        MoveMemory(@strCert[1], pCertContext.pbCertEncoded, delkaCert);
        privateCertB64 := EncodeBase64(strCert);
      end
      else begin
        result := '';
        ShowMessage('Chyba pøi podepisovani');
        Exit;
      end;
      vysledek :=
        sEsXMLSubmissionRequestPRIHL1_a +
        TypPodani +
        sEsXMLSubmissionRequestPRIHL1_b +
        sEsXMLSubmissionRequestELDPSignature_1 +
        signedInfoElement +
        signatureValue +
        sEsXMLSubmissionRequestELDPSign +
        privateCertB64 +
        sEsXMLSubmissionRequestELDP3 +
        VS +
        sEsXMLSubmissionRequestELDP3a +
        body +
        sEsXMLSubmissionRequestPRIHL6a;

{$IFDEF ELPODANITEST}
      testExp := TStringList.Create();
      try
        testExp.Text := vysledek;
        testExp.SaveToFile(ExtractFilePath(Application.ExeName) +
          'PodaniXml.xml');
      finally
        FreeAndNil(testExp);
      end;
{$ENDIF}
    finally
      if hStoreHandle <> nil then
        CertCloseStore(hStoreHandle, 0);
      if doc <> nil then
        doc := nil;
    end;
{$IFDEF ELPODANITEST}
  finally
    Saver.Free;
  end;
{$ENDIF}
  Result := vysledek;
end;{MakePRIHLSubmissionRequestXMLCert}

function TCSSZModule.MakePRIHLSubmissionPollXMLCert(const CorrelationID,
  TypPodani: string): string;
begin
  Result := sXMLSubmissionPollPRIHL1 + TypPodani + sXMLSubmissionPollPRIHL1a +
    CorrelationID + sXMLSubmissionPollPRIHL2;
end;

function TCSSZModule.MakePRIHLRequestDeleteXMLCert(const CorrelationID,
  TypPodani: string): string;
begin
  Result := sXMLRequestDeletePRIHL1 + TypPodani + sXMLRequestDeletePRIHL1a +
    CorrelationID + sXMLRequestDeletePRIHL2;

end;

//Odesle data pomoci SYnapse a OpenSSL
function TCSSZModule.SendXMLDataSy(const XML, URL: string): TServerReponseData;
var
  FSXML: TMemoryStream;
  odpoved: string;
  ResponseCode:Integer;
  adresa,param:string;
  http:THTTPSend;
  odpb:boolean;
begin
  adresa:=URL;
  param:='';

  if URL=sCSSZSubmissionURLtest then begin
     adresa:= sCSSZSubmissionURLtest_2;
     param:= sCSSZSubmissionTestParam_2;
  end
  else if URL=sCSSZSubmissionURL then begin
     adresa:= sCSSZSubmissionURL_2;
     param:= sCSSZSubmissionParam_2;
  end
  else if URL=sCSSZSubmissionURLtest_VREP then begin
     adresa:= sCSSZSubmissionURLtest_2_VREP;
     param:= sCSSZSubmissionTestParam_2_VREP;
  end
  else if URL=sCSSZSubmissionURL_VREP then begin
     adresa:= sCSSZSubmissionURL_2_VREP;
     param:= sCSSZSubmissionParam_2_VREP;
  end;

  Result.XML := '';
  ParseResponse(Result);
  Result.ErrText := '';
  ResponseCode:=-1;
  //pouzito na predani textu vyjimek pro zapracovani v protokolu
  FSXML := TMemoryStream.Create;
  http:=THTTPSend.Create();
  http.Protocol:='1.1';
  http.ProxyHost:=ProxySettings.ProxyServer;
  http.ProxyPort:=IntToStr(ProxySettings.ProxyPort);
  http.ProxyUser:=ProxySettings.ProxyUserName;
  http.ProxyPass:=ProxySettings.ProxyPassword;
  http.MimeType:='application/xml';
  try
    FSXML.Write(XML[1], Length(XML));
    FSXML.Position := 0;

    try
      //CSSZModule.HTTP.Post(URL, FSXML, MSResult);
      // ResponseCode:=PostToURLQuery(adresa,param,FSXML,'',odpoved);
      http.Document.LoadFromStream(FSXML);
      odpb:=http.HTTPMethod('POST',URL);
      ResponseCode:=http.ResultCode;
      if not odpb then
        raise Exception.Create('Chyba pøi komunikaci se serverem https, URL:'+
        URL+' ('+IntToStr(ResponseCode)+')')
      else
        odpoved := ReadStrFromStream(http.Document,http.Document.Size);

    except
      on E: EIdConnClosedGracefully do begin
      end;
      on E: Exception do begin
        Result.ErrText := Format(errWSPostEx, [E.Message]);
        EXIT;
      end;
    end;

    if ResponseCode <> 200 then begin
      Result.ErrText := Format(errWSPostRC, [ResponseCode]);
      {raise Exception.CreateFmt(errWSPostRC, [CSSZModule.HTTP.ResponseCode]);}
    end;
    if Length(odpoved) < 10 then begin
      Result.ErrText := Format(errWSXMLDelka, [])+ '('+odpoved+'), delka v sekci HEADER: '+IntToStr(http.DownloadSize);
      {raise Exception.CreateFmt(errWSXMLDelka, []);}
    end;
    if Result.ErrText = '' then begin
      Result.XML := odpoved;
      ParseResponse(Result);
    end;
  finally
    FreeAndNil(http);
    FSXML.Free;
  end;
end;{SendXMLDataSy}



// ****************** Autentifikace pomoci certifikatu ************************

{ TXmlCanonizer }

function TXmlCanonizer.NormalizeAttributeValue(AValue: string): string;
begin
  Result := AValue;
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  Result := StringReplace(Result, #9, #32, [rfReplaceAll]);
  Result := StringReplace(Result, #13#10, #32, [rfReplaceAll]);
  Result := StringReplace(Result, #13, #32, [rfReplaceAll]);
  Result := StringReplace(Result, #10, #32, [rfReplaceAll]);
end;

function TXmlCanonizer.NormalizeText(AText: string): string;
begin
  Result := AText;
  Result := StringReplace(Result, #13#10, #10, [rfReplaceAll]);
  Result := StringReplace(Result, #13, #10, [rfReplaceAll]);
end;

function TXmlCanonizer.BuildAttributes(ANode: IXMLDOMNode): string;
var
  i: Integer;
  attributes, namespaces: TStringList;
  element: IXMLDOMElement;
  Temp: Pointer;
begin
  Result := '';
  if not Supports(ANode, IXMLDOMElement, Temp) then
    Exit;
  attributes := nil;
  namespaces := nil;
  try
    attributes := TStringList.Create();
    attributes.Sorted := True;

    namespaces := TStringList.Create();
    namespaces.Sorted := True;

    element := (ANode as IXMLDOMElement);
    for i := 0 to element.attributes.length - 1 do begin
      if (system.Pos('xmlns', LowerCase(element.attributes.item[i].nodeName)) =
        1) then begin
        namespaces.Add(element.attributes.item[i].nodeName + '="'
          +
          NormalizeAttributeValue(VarToStr(element.attributes.item[i].nodeValue))
          + '"');
      end
      else begin
        attributes.Add(element.attributes.item[i].nodeName + '="'
          +
          NormalizeAttributeValue(VarToStr(element.attributes.item[i].nodeValue))
          + '"');
      end;
    end;
    for i := 0 to namespaces.Count - 1 do begin
      Result := Result + ' ' + Trim(namespaces[i]);
    end;
    for i := 0 to attributes.Count - 1 do begin
      Result := Result + ' ' + Trim(attributes[i]);
    end;
  finally
    namespaces.Free();
    attributes.Free();
  end;
end;

function TXmlCanonizer.BuildXmlString(ARootNode: IXMLDOMNode): string;
var
  i: Integer;
  Temp: Pointer;
begin
  if Supports(ARootNode, IXMLDOMText, Temp) then begin
    Result := Result + NormalizeText(VarToStr(ARootNode.nodeValue));
  end
  else begin
    Result := '<' + ARootNode.nodeName + BuildAttributes(ARootNode) + '>';
    for i := 0 to ARootNode.childNodes.length - 1 do begin
      Result := Result + BuildXmlString(ARootNode.childNodes.item[i]);
    end;
    Result := Result + '</' + ARootNode.nodeName + '>';
  end;
end;

function TXmlCanonizer.Canonicalize(ARootNode: IXMLDOMNode): string;
begin
  Result := AnsiToUtf8(BuildXmlString(ARootNode));
end;

function TCSSZModule.FormatDateCompact(const ADateStr: string): string;
begin
  Result := StrTrimCharLeft(Copy(ADateStr, 7, 2), '0') + DateSeparator +
    StrTrimCharLeft(Copy(ADateStr, 5, 2), '0') + DateSeparator +
    Copy(ADateStr, 1, 4);
  //20040803
end;

end.


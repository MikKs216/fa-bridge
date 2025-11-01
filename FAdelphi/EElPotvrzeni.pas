{ 13.9.2019 12:10:15 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 16.10.2012 14:18:12 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 16.10.2012 12:00:44 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 12.10.2012 15:33:22 (GMT+2:00) > [mik] checked in   }
{ 6.11.2008 11:24:31 (GMT+1:00) > [mik] checked in Opraveno zobrazeni potvrzeni  }
{ 9.10.2008 14:28:03 (GMT+2:00) > [mik] checked in Doplneni identifikace subjektu v potvrzeni o podani  }
unit EElPotvrzeni;

{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, xmldom, XMLIntf, msxmldom, XMLDoc, cxControls,
  cxContainer, cxListBox, RVScroll, RichView, PtblRV, RVStyle, Menus,
   cxButtons, cxLookAndFeelPainters, cxGraphics, cxLookAndFeels, cxEdit,
  dxSkinsCore, dxSkinCaramel, dxSkinFoggy, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, EElPodPvsDM, gtCstDocEng,
  gtCstPlnEng, gtCstPDFEng, gtExPDFEng, gtPDFEng, gtClasses3, gtXportIntf,
  gtRichViewIntf, RVReport;

procedure OpenElPotvrzeni(const APotvrzeniFileName: string; const ATempFolder: string;
  ALeft: Integer = 0; ATop: Integer = 0);
procedure ShowElPotvrzeniInRichView(const APotvrzeniFileName: string;
      ARichView: TRichView);

type
  TfmElPotvrzeni = class(TForm)
    cxListBox1: TcxListBox;
    rvStyle: TRVStyle;
    RVPrint1: TRVPrint;
    rvInfo: TRichView;
    Label1: TLabel;
    rvOpis: TRichView;
    Label7: TLabel;
    Label6: TLabel;
    PopupMenu1: TPopupMenu;
    miShowXML: TMenuItem;
    miSaveInfo: TMenuItem;
    btLoadPotvrzeni: TcxButton;
    btPrint: TcxButton;
    btFunction: TcxButton;
    btClose: TcxButton;
    btUlozitPrilohu: TcxButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    miOpenPotvrzeni: TMenuItem;
    RVReportHelper: TRVReportHelper;
    gtRichViewInterface: TgtRichViewInterface;
    gtPDFEngine: TgtPDFEngine;
    procedure cxListBox1DblClick(Sender: TObject);
    procedure btLoadPotvrzeniClick(Sender: TObject);
    procedure cxListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btUlozitPrilohuClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btFunctionClick(Sender: TObject);
    procedure miSaveInfoClick(Sender: TObject);
    procedure miShowXMLClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure miOpenPotvrzeniClick(Sender: TObject);
  private
    FPotvrzeniFileName, FXmlOrig, FTempFolder: string;
    procedure LoadPotvrzeniFromStream(APotvrzeniStream: TStream;
      ARichView: TRichView; AShowOpis: boolean);
    procedure LoadPotvrzeniFromFile(APotvrzeniFileName: string;
      ARichView: TRichView; AShowOpis: boolean);

    procedure OpenPotvrzeni;
    procedure Init;
    procedure OpenParamFile;
    procedure SavePriloha;
    function SaveInfoToPDF(const AFileName: string = ''): string;
    procedure LoadVysledekPodaniZCSSZ(const AFileName: string);
    procedure ParseResponse(var Response: TServerReponseData);
    function LoadResponseData(const AFileName: string): TServerReponseData;
  public
  end;

var
  fmElPotvrzeni: TfmElPotvrzeni;

implementation

{$R *.dfm}

uses FCommonUtils, JCLStrings, mfcr_utils, mfcr_resources, Res_FA, FScriptUtils,
  SpolFunkce, ShellApi, FUtils, EPdfView, Main,
  cssz_certificate, cssz_utils, cssz_consts;

procedure OpenElPotvrzeni(const APotvrzeniFileName: string; const ATempFolder: string;
  ALeft: Integer; ATop: Integer);
begin
  fmElPotvrzeni:=TfmElPotvrzeni.Create(nil);
  try
    with fmElPotvrzeni do begin
      FPotvrzeniFileName:=APotvrzeniFileName;
      FTempFolder:=ATempFolder;
      Left:=ALeft;
      Top:=ATop;
      if (ALeft=0) and (ATop=0) then
        Position := poMainFormCenter;
      ShowModal;
    end;
  finally
    fmElPotvrzeni.Free;
    fmElPotvrzeni:=nil;
  end;
end; {OpenElPotvrzeni}

procedure ShowElPotvrzeniInRichView(const APotvrzeniFileName: string;
      ARichView: TRichView);
begin
  fmElPotvrzeni:=TfmElPotvrzeni.Create(nil);
  try
    with fmElPotvrzeni do begin
      LoadPotvrzeniFromFile(APotvrzeniFileName, ARichView, false);
    end;
  finally
    fmElPotvrzeni.Free;
    fmElPotvrzeni:=nil;
  end;
end;

type TDataFileString = class(TObject)
  private
    FDataString: string;
  public
    constructor Create(Owner: TComponent; ADataString: string);
    function DataString: string;
end;

constructor TDataFileString.Create(Owner: TComponent; ADataString: string);
begin
  inherited Create;
  FDataString:=ADataString;
end;

function TDataFileString.DataString: string;
begin
  Result:=FDataString;
end;

procedure TfmElPotvrzeni.LoadPotvrzeniFromStream(APotvrzeniStream: TStream;
  ARichView: TRichView; AShowOpis: boolean);
var
  hexData, S, str: string;
  i,z,k: integer;
  node, node1, node2, node3: IXMLNode;
  slPrilohy, doc: TStringList;

  XMLDoc: TXMLDocument;

  ReceiptNumber: string;
  ReceiptDate: string;
  ReceiptEmail: string;
  ReceiptPassword: string;
  ReceiptCheck: string;
  ReceiptFileName: string;

  function FormatDate(const ADateStr: string): string;
  begin
    Result:=StrTrimCharLeft(Copy(ADateStr,9,2),'0') + DateSeparator +
      StrTrimCharLeft(Copy(ADateStr,6,2),'0') + DateSeparator +
      Copy(ADateStr,1,4) + ' ' + Copy(ADateStr,12,8);
    //2004-08-03T10:26:29
  end;

  function FormatCheck(const AStr: string): string;
  begin
    if Length(AStr)<>32 then
      Result:=AStr
    else
      Result:=Copy(AStr,1,5) + '-' + Copy(AStr,6,5) + '-' + Copy(AStr,11,5) + '-' +
        Copy(AStr,16,2) + '-' +
        Copy(AStr,18,5) + '-' + Copy(AStr,23,5) + '-' + Copy(AStr,28,5);
    //5441360bf6515e92674f93f968a1e558
  end;

begin
  StartWait;
  try
    if AShowOpis then begin
      rvOpis.Clear;
      rvOpis.Format;
    end;
    ARichView.Clear;
    ARichView.AddNL('Probíhá ètení souboru potvrzení ...',0,0);
    ARichView.Format;
    if AShowOpis then begin
      Invalidate;
      Refresh;
    end;

    slPrilohy:= TStringList.Create;

    XMLDoc:= TXMLDocument.Create(self);
    doc:= TStringList.Create;
    try
      ReceiptNumber := '';
      ReceiptDate := '';
      ReceiptEmail := '';
      ReceiptPassword := '';
      ReceiptCheck := '';

      SetLength(S, APotvrzeniStream.Size);
      APotvrzeniStream.Read(S[1], APotvrzeniStream.Size);
      i := Pos('<?xml version=', S);
      Delete(S, 1, i - 1);
      i := Pos('</Pisemnost>', S);
      Delete(S, i + Length('</Pisemnost>'), maxint);

      FXmlOrig:='';
      XMLDoc.XML.Text := S;
      XMLDoc.Active := TRUE;
      try
        if XMLDoc.DocumentElement.NodeName = 'Pisemnost' then begin //XML soubor potvrzeni
          node := XMLDoc.DocumentElement;

            node1 := node.ChildNodes['Kontrola'];
            if node1 <> nil then begin
              node2 := node1.ChildNodes['Soubor'];
              ReceiptFileName := VarToStr(node2.Attributes['Nazev']);
              ReceiptCheck := VarToStr(node2.Attributes['KC']);
            end;
            node1 := node.ChildNodes['Podani'];
            if node1 <> nil then begin
              ReceiptNumber := VarToStr(node1.Attributes['Cislo']);
              ReceiptDate := VarToStr(node1.Attributes['Datum']);
              ReceiptEmail := VarToStr(node1.Attributes['Email']);
              ReceiptPassword := VarToStr(node1.Attributes['Heslo']);
            end;

          node1 := node.ChildNodes['Data']; //vraceny puvodni soubor je v uzlu DATA, hexadecimalne zakodovany
          hexData:=VarToStr(node1.NodeValue);
          z:=Pos('3c3f786d6c2076657273696f6e3d22312e3022',hexData); //najit zacatek XML
          {k:=Pos('3c2f506973656d6e6f73743e0d0a',hexData); //najit konc XML se nekdy nedari, zruseno, hleda se az v prekodovanem
          FXmlOrig:=StrToHex(Copy(hexData,z,k+28-z)); //prekodovat}
          FXmlOrig:=StrToHex(Copy(hexData,z,maxint)); //prekodovat
          k:=Pos('</Pisemnost>',FXmlOrig);
          FXmlOrig:=Copy(FXmlOrig,1,k+12);
          //SaveStringToFile(FXmlOrig,'xmlorig.txt'); //pro ladeni

          if AShowOpis then begin
            rvOpis.Clear;
            doc.Text:=FXmlOrig;
            for i:=0 to doc.Count-1 do
              rvOpis.AddNL(doc[i],0,0);
            rvOpis.Format;
          end;

        end;
      finally
        XMLDoc.Active := FALSE;
      end;
      if FXmlOrig<>'' then begin
        XMLDoc.XML.Text := FXmlOrig;
        XMLDoc.Active := TRUE;
        try
          if XMLDoc.DocumentElement.NodeName = 'Pisemnost' then begin
            node := XMLDoc.DocumentElement;
            node1 := node.ChildNodes[0];
            node2 := node1.ChildNodes['Prilohy'];
            cxListBox1.Clear;
            for i:=0 to node2.ChildNodes.Count-1 do begin
              node3 := node2.ChildNodes[i];
              cxListBox1.AddItem(node3.attributes['jm_souboru'],
                TDataFileString.Create(self,node3.NodeValue));
            end;
            if node2.ChildNodes.Count>0 then begin
              cxListBox1.ItemIndex:=0;
              btUlozitPrilohu.Enabled:=TRUE;
            end
            else
              btUlozitPrilohu.Enabled:=FALSE;
          end;
        finally
          XMLDoc.Active := FALSE;
        end;
      end;

      ARichView.Clear;
      ARichView.AddNL('Opis potvrzení elektronického podání',1,0);
      ARichView.AddNL('',0,0);

      if FXmlOrig<>'' then begin
        str:=GetFillingSubjectInfo(self,FXmlOrig, 'c_ufo');//u nekterych podani fu neni
        if str<>'' then
          ARichView.AddNL('Finanènímu úøadu: '+
            LstLookup('FU', Date, 'CisloFU',str,'Nazev'),3,0);
        str:=GetFillingSubjectInfo(self,FXmlOrig,'dic');
        if str<>'' then
          ARichView.AddNL('DIÈ: CZ'+str,3,0);
        {if GetFillingSubjectInfo(self,FXmlOrig, 'rod_c')<>'' then
          ARichView.AddNL('Rodné èíslo: '+GetFillingSubjectInfo(self,FXmlOrig, 'rod_c'),3,0);}
        ARichView.AddNL('Název daòového subjektu: '+
          Trim(GetFillingSubjectInfo(self,FXmlOrig, 'titul')+' '+
          GetFillingSubjectInfo(self,FXmlOrig, 'jmeno')+' '+
          GetFillingSubjectInfo(self,FXmlOrig, 'prijmeni')+' '+
          GetFillingSubjectInfo(self,FXmlOrig, 'zkrobchjm')),3,0);
        ARichView.AddNL('Ulice a èíslo: '+GetFillingSubjectInfo(self,FXmlOrig, 'ulice')+' '+
          GetFillingSubjectInfo(self,FXmlOrig, 'c_pop'),3,0);
        ARichView.AddNL('PSÈ, obec: '+Trim(GetFillingSubjectInfo(self,FXmlOrig, 'psc')+' '+
          GetFillingSubjectInfo(self,FXmlOrig, 'naz_obce')),3,0);

        ARichView.AddNL('',0,0);
        ARichView.AddNL('Písemnost: '+GetFillingSubjectInfo(self,FXmlOrig, 'k_uladis','VetaD'),3,0);
      end;
      ARichView.AddNL('Identifikace zaøízení: Spoleèné technické zaøízení správcù danì',3,0);
      ARichView.AddNL('Datum a èas podání: '+FormatDate(ReceiptDate),3,0);
      ARichView.AddNL('Podací èíslo, heslo: '+ReceiptNumber+', '+ReceiptPassword,3,0);
      ARichView.AddNL('Název souboru: '+ReceiptFileName,3,0);
      ARichView.AddNL('Kontrolní èíslo: '+FormatCheck(ReceiptCheck),3,0);
      ARichView.Format;

      //btPrint.Enabled:=FXmlOrig<>'';
      //btFunction.Enabled:=FXmlOrig<>'';
    finally
      slPrilohy.Free;
      XMLDoc.Free;
      doc.Free;
    end;
  finally
    if AShowOpis then begin
      Invalidate;
      Refresh;
    end;
    StopWait;
  end;
end;

procedure TfmElPotvrzeni.LoadPotvrzeniFromFile(APotvrzeniFileName: string;
  ARichView: TRichView; AShowOpis: boolean);
var
  FS: TFileStream;
begin
  if Pos('.p7s',APotvrzeniFileName)>0 then begin
    FS := TFileStream.Create(APotvrzeniFileName, fmOpenRead);
    try
      LoadPotvrzeniFromStream(FS,ARichView,AShowOpis);
    finally
      FS.Free;
    end;
  end
  else
    LoadVysledekPodaniZCSSZ(FPotvrzeniFileName);
end;

procedure TfmElPotvrzeni.SavePriloha;
var s: string;
begin
  if cxListBox1.ItemObject<>nil then begin
    with SaveDialog1 do begin
      FileName:=cxListBox1.Items[cxListBox1.ItemIndex];
      if Execute then begin
        s:=TDataFileString(cxListBox1.ItemObject).DataString;
        StringBase64ToBinaryFile(s, FileName);
      end;
    end;
  end;
end;

procedure TfmElPotvrzeni.Init;
begin
  btUlozitPrilohu.Enabled:=FALSE;
  btPrint.Enabled:=TRUE;
  btFunction.Enabled:=TRUE;
  Invalidate;
  Refresh;
end;

procedure TfmElPotvrzeni.OpenParamFile;
begin
  if FPotvrzeniFileName<>'' then begin
    if FileExists(FPotvrzeniFileName) then
      LoadPotvrzeniFromFile(FPotvrzeniFileName, rvInfo, true)
    else
      MessageWarn(Caption,Format(sErrPotvFileNotFound,[FPotvrzeniFileName]), [MBOK]);
  end
  else
    OpenPotvrzeni;
end;

procedure TfmElPotvrzeni.OpenPotvrzeni;
begin
  if OpenDialog1.Execute then begin
    Invalidate;
    Refresh;
    FPotvrzeniFileName:=OpenDialog1.FileName;
    if Pos('.p7s',FPotvrzeniFileName)>0 then
      LoadPotvrzeniFromFile(FPotvrzeniFileName, rvInfo, true)
    else if Pos('.xml',FPotvrzeniFileName)>0 then begin
      rvOpis.Clear;
      rvOpis.Format;
      rvInfo.Clear;
      rvInfo.AddNL('Probíhá ètení souboru potvrzení ...',0,0);
      rvInfo.Format;
      LoadVysledekPodaniZCSSZ(FPotvrzeniFileName);
    end;
  end;
end;

procedure TfmElPotvrzeni.btLoadPotvrzeniClick(Sender: TObject);
begin
  OpenPotvrzeni;
end;

procedure TfmElPotvrzeni.cxListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then
    SavePriloha;
end;

procedure TfmElPotvrzeni.btUlozitPrilohuClick(Sender: TObject);
begin
  SavePriloha;
end;

procedure TfmElPotvrzeni.btPrintClick(Sender: TObject);
var
  fn: string;
  rs: TReportSettings;
begin
  StartWait;
  try
    {RVPrint1.AssignSource(rvInfo);
    RVPrint1.FormatPages(rvdoAll);
    RVPrint1.Print(Caption,1,FALSE);}

    fn:=SaveInfoToPDF;
    OpenPDFFile(fn);
    //ViewPdfFile(fn,rs,'Informace o podání',true);
   finally
    StopWait;
  end;
end;

procedure TfmElPotvrzeni.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmElPotvrzeni.btFunctionClick(Sender: TObject);
var
  oldAlignment: TPopupAlignment;
  p: TPoint;
begin
  Application.ProcessMessages;
  PostMessage(Handle, WM_KEYDOWN, VK_DOWN, 0);
  with PopupMenu1 do begin
    oldAlignment := Alignment;
    try
      //Alignment:=paRight;
      PopupComponent := nil;
      p := ClientToScreen(Point(btFunction.Left,
        btFunction.Top + btFunction.Height));
      Popup(p.x, p.y);
    finally
      Alignment := oldAlignment;
    end;
  end;
end;

procedure TfmElPotvrzeni.miOpenPotvrzeniClick(Sender: TObject);
begin
  OpenPotvrzeni;
end;

procedure TfmElPotvrzeni.miSaveInfoClick(Sender: TObject);
begin
  with SaveDialog1 do begin
    FileName := ChangeFileExt(FPotvrzeniFileName,'');
    DefaultExt := cPDFDefaultExt;
    Filter := cPDFRTFTXTOpenSaveFilter;
    if Execute then begin
      if not FileExists(FileName) or
        (MessageAsk(Caption,
        Format(sMsgFileNotExistsAsk, [FileName]), [MBYES, MBNO]) = IDYES) then
      if ExtractFileExt(FileName)=cPDFDefaultExt then begin
        if FileExists(FileName) then
          DeleteFile(FileName);
        SaveInfoToPDF(FileName);
      end
      else if ExtractFileExt(FileName)='.txt' then
        rvInfo.SaveText(FileName, 80)
      else
        rvInfo.SaveRTF(FileName, FALSE);
    end;
  end;
end;

procedure TfmElPotvrzeni.miShowXMLClick(Sender: TObject);
var
  pth: string;
begin
  {$IFDEF STANDALONE}
  pth:=NormalPath(GetWorkPath);
  {$ELSE STANDALONE}
  pth:=NormalPath(GetTempPath);
  {$ENDIF STANDALONE}
  SaveStringToFile(FXmlOrig,pth + 'EPodani.xml');
  ShellExecute(0, nil,
    PChar(pth + 'EPodani.xml'),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TfmElPotvrzeni.cxListBox1DblClick(Sender: TObject);
var
  fileName,s: string;
  pth: string;
begin
  if cxListBox1.ItemObject<>nil then begin
    {$IFDEF STANDALONE}
    pth:=NormalPath(GetWorkPath);
    {$ELSE STANDALONE}
    pth:=NormalPath(GetTempPath);
    {$ENDIF STANDALONE}
    fileName:=pth + cxListBox1.Items[cxListBox1.ItemIndex];
    s:=TDataFileString(cxListBox1.ItemObject).DataString;
    StringBase64ToBinaryFile(s, fileName);
    ShellExecute(0, nil, PChar(fileName), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TfmElPotvrzeni.FormActivate(Sender: TObject);
begin
  Init;
  OpenParamFile;
  Invalidate;
  Refresh;
end;

procedure TfmElPotvrzeni.FormCreate(Sender: TObject);
begin
  FTempFolder:='';
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
end;

procedure TfmElPotvrzeni.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then
    Close;
end;

// pripravi opis informaci do pdf a vrati jeho nazev
function TfmElPotvrzeni.SaveInfoToPDF(const AFileName: string = ''): string;
var
  fnrtf: string;
  st: TMemoryStream;
  resol: Integer;
begin
  StartWait;
  st := TMemoryStream.Create;
  try
    rvInfo.SaveRVFToStream(st, FALSE);
    st.Seek(0, soFromBeginning);
    RVReportHelper.RichView.LoadRVFFromStream(st);
    // nastaveni rozliseni
    resol:=GetDPIForPDFrender;
    gtPDFEngine.InputXRes:=resol;
    gtPDFEngine.InputYRes:=resol;
    //
    if AFileName<>'' then
      Result:=AFileName
    else begin
      if not GfaMain.PrepareDirWork then
         MessageErr(Caption, Format(sCannotCreateWorkDir, [GfaMain.DirWorkPath]), [MBOK]);
      Result := GetUniqueFileName(GfaMain.DirWorkPath, 'Informace o podání.pdf');
    end;
    gtPDFEngine.FileName := Result;
    gtRichViewInterface.RenderDocument(RVReportHelper);
    RVReportHelper.Clear;
  finally
    st.Free;
    StopWait;
  end;
end;

procedure TfmElPotvrzeni.LoadVysledekPodaniZCSSZ(const AFileName: string);
var
  Response: TServerReponseData;
  sl: TstringList;
  j: integer;
  str: string;
const
  s = '<GovTalkMessage xmlns="http://www.govtalk.gov.uk/CM/envelope"';
begin
  str:=LoadStringFromFile(AFileName);
  rvOpis.Clear;
  rvOpis.Add(XMLStrToWindows1250(str),0);
  rvOpis.Format;
  if Pos(s,str)=0 then
    MessageErr(Caption, 'Soubor neobsahuje protokol o elektronickém podání na ÈSSZ', [MBOK])
  else begin
    Response := LoadResponseData(AFileName);
    if (Response.ErrListCountErr <> '0') and (Response.ErrListCountErr <> '') then begin
      rvInfo.Clear;
      rvInfo.AddNL('Podání na ÈSSZ nebylo pøijato', 1, 0);
      rvInfo.AddNL('', 0, 0);
      rvInfo.AddNL('Dokument obsahuje chyby.', 3, 0);
      rvInfo.AddNL('Datum a èas doruèení: '+ CSSZModule.FormatDateCompact(Response.TimeStampDate)+' '+Response.TimeStampTime , 3, 0);
      rvInfo.AddNL('', 0, 0);
      rvInfo.AddNL('Hlavní chyba: '+Response.ErrListMsgMainErr, 3, 0);
      rvInfo.AddNL('', 0, 0);
      rvInfo.AddNL('Položky:', 0, 0);
      rvInfo.AddNL('', 0, 0);
      sl:=TStringList.Create;
      try
        sl.Text:=Response.ErrListText;
        for j := 0 to sl.Count - 1 do
          rvInfo.AddNL(sl[j], 0, 0);
      finally
        sl.Free;
      end;
      rvInfo.Format;
    end
    else if (Response.ErrNumber <>'')and(Response.ErrNumber <>'0') then begin
      rvInfo.Clear;
      rvInfo.AddNL('Podání na ÈSSZ nebylo pøijato', 1, 0);
      rvInfo.AddNL('', 0, 0);
      rvInfo.AddNL('Dokument obsahuje chyby.', 3, 0);
      rvInfo.AddNL('Datum a èas doruèení: '+ CSSZModule.FormatDateCompact(Response.TimeStampDate)+' '+Response.TimeStampTime , 3, 0);
      rvInfo.AddNL('', 0, 0);
      rvInfo.AddNL('Hlavní chyba: '+Response.ErrText, 3, 0);
      rvInfo.Format;
    end
    else begin
      rvInfo.Clear;
      rvInfo.AddNL('Podání na ÈSSZ bylo pøijato', 1, 0);
      rvInfo.Format;
    end;
  end;
end;

function TfmElPotvrzeni.LoadResponseData(const AFileName: string): TServerReponseData;
var resp: TServerReponseData;
  s: string;
begin
  if FileExists(AFileName) then begin
    s:=LoadStringFromFile(AFileName);
    Result.XML := s;
    ParseResponse(Result);
  end;
end;

function ParseField(const S, FieldName: string): string;
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

function GetMultipleField(var S: string; const Prefix,
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

function GetOneField(const S, Prefix, Sufix: string): string;
var
  PomStr: string;
begin
  PomStr := S;
  Result := GetMultipleField(PomStr, Prefix, Sufix);
end;

function ParseNode(const S, NodeName: string): string;
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

procedure TfmElPotvrzeni.ParseResponse(var Response: TServerReponseData);
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
  Response.ErrText := ParseNode(XMLStrToWindows1250(Response.XML), sResponseErrText);
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

end.

{ 14.7.2016 14:11:43 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in V procedure PridejNodeValue doplnena podminka, ktera zajisti, ze se formular ulozi v normalizovanem stavu, pokud radku v ListBoxu neodpovidaji data v Memu (do ted se ukladal v puvodnim frm formatu)  }
unit XMLNormalize;

interface

uses
  SysUtils, Classes, Variants, XMLIntf, XMLDoc, JclAnsiStrings,
  Dialogs;

  function NormalizeXML(AXML: string): string;
  function UnNormalizeXML(AXML: string): string;

implementation

uses
  FCommonUtils;

var
  XMLDocTmp: IXMLDocument;

const
  cNstDataText = 'DATA=[NestedSections]';
  cNstSectStart = '[NestedSections]';
  cNstSectEnd = '[/NestedSections]';
  cNstSectNodeName = 'NESTEDSECTIONS';
  cDefPosGuid = 129;
  cCRLFAlternate1 = #183'#';

procedure msgv(AMsg: variant);
begin
  ShowMessage(VarToStr(AMsg));
end;

function ConCatExpr(const AStr1, AStr2, ASurfix: string): string;
begin
  if (AStr1<>'') and (AStr2<>'') then
    Result:= AStr1+ASurfix+AStr2
  else if (AStr1<>'') then
    Result:= AStr1
  else if (AStr2<>'') then
    Result:= AStr2
  else
    Result := '';
end;{ConCatExpr}

{-----------------------------------------------------------------------------
AnsiLowerCaseUpFirst
  zmeni case stringu S na prvni pismeno velke a zbytek mala 
-----------------------------------------------------------------------------}
function AnsiLowerCaseUpFirst(const S: string): string;
var
  Temp: string[1];
begin
  Result := AnsiLowerCase(S);
  if S <> '' then begin
    Temp := Result[1];
    Temp := AnsiUpperCase(Temp);
    Result[1] := Temp[1];
  end;
end;

{-----------------------------------------------------------------------------
SlStringName
  ze stringu AStr ve tvaru Name=Value vraci Name
-----------------------------------------------------------------------------}
function SlStringName(const AStr: string): string;
begin
  Result := Copy(AStr,1,Pos('=',Astr)-1);
end;

{-----------------------------------------------------------------------------
SlStringValue
  ze stringu AStr ve tvaru Name=Value vraci Value
-----------------------------------------------------------------------------}
function SlStringValue(const AStr: string): string;
begin
  Result := Copy(AStr,Pos('=',AStr)+1, maxint);
end;

{-----------------------------------------------------------------------------
GetNodeByName
  z ANode ziska jeho ChildNode (dle jmena NodeName)
  - je CaseInsesitive, tzn. NodeName muze byt ve tvaru VALUE, Value nebo value
-----------------------------------------------------------------------------}
function GetNodeByName(ANode: IXMLNode; NodeName: string): IXMLNode;
begin
  Result := nil;
  if ANode.ChildNodes.FindNode(AnsiUpperCase(NodeName)) <> nil then
    Result := ANode.ChildNodes.Nodes[AnsiUpperCase(NodeName)]
  else if ANode.ChildNodes.FindNode(AnsiLowerCaseUpFirst(NodeName)) <> nil then
    Result := ANode.ChildNodes.Nodes[AnsiLowerCaseUpFirst(NodeName)]
  else if ANode.ChildNodes.FindNode(AnsiLowerCase(NodeName)) <> nil then
    Result := ANode.ChildNodes.Nodes[AnsiLowerCase(NodeName)];
end;

{-----------------------------------------------------------------------------
GetNstDataFieldNames
  v ANode predavame celou sekci (VALUES) v zakodovanem tvaru
  na samostatnych radcich vraci seznam nazvu udaju, kde jsou ulozeny vlozene formulare
  napr. NSDATA, NPDATA apod.
-----------------------------------------------------------------------------}
function GetNstDataFieldNames(ANode: IXMLNode): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to ANode.ChildNodes.Count - 1 do begin    //zjistime jmena vlozenych formularu 1 urovne (napr. NSDATA, R16DATA apod.)
    if (Copy(ANode.ChildNodes.Nodes[i].NodeName,Length(ANode.ChildNodes.Nodes[i].NodeName)-3,4) = 'DATA') then
      if (ANode.ChildNodes.Nodes[i].NodeValue <> null) and
         (Copy(ANode.ChildNodes.Nodes[i].NodeValue,1,16) = '[NestedSections]') then
        AddStringLine(Result, ANode.ChildNodes.Nodes[i].NodeName);
  end;
end;

{-----------------------------------------------------------------------------
GetPosGuidAtListBox
  ze stringu AListBoxRow (vlastne radek ListBoxu, kde je ulozen popis prilohy + guid)
    vraci pozici guidu
  pokud je AListBoxIndex=0 (jedna o prvni radek ListBoxu)
    a pozice guidu <> 129 (v 99% je formularich pozice prave 129),
    tak se do nodu ANode prida atribut PosGuid
-----------------------------------------------------------------------------}
function GetPosGuidAtListBox(const AListBoxRow: string; const AListBoxIndex: integer;
                             ANode: IXMLNode; const APos: integer): integer;
begin
  Result := APos;
  if Result = 0 then begin
    Result := Length(AListBoxRow);
    repeat
      Dec(Result);
    until (Copy(AListBoxRow,Result,1)='{') or (Result = 0);
    //
    if AListBoxIndex = 0 then //zjistime pozici guidu v ListBoxu (pouze u prvniho, ostatni jsou stejne)
      if Result <> cDefPosGuid then  //v 99% je guid na pozici 129, zapisujeme jen pokud je pozice jina (aby to uzivatele nematlo)
        ANode.Attributes['PosGuid'] := IntToStr(Result);
  end;
end;

{-----------------------------------------------------------------------------
GetLBValue
  ze zakodovane nested sekce 1.urovne (AStr) vraci hodnotu udaje AFldName (napr. R16 - jde vlastne o ListBox 2.urovne)
-----------------------------------------------------------------------------}
function GetLBValue(const AStr, AFldName: string): string;
var
  p,pk: integer;
  s: string;
begin
  Result := '';
  p := Pos(cCRLFAlternate+AFldName, AStr);
  if p > 0 then begin
    s := Copy(AStr,p, maxint);
    p := Pos(AFldName, s);
    s := Copy(s,p, maxint);
    pk := StrNPos(s,'=',2); //druhy vyskyt = tzn zacina dalsi udaj
    repeat
      Dec(pk);
    until (not StrIsAlphaNumUnderscore(Copy(s,pk,1))) or (pk = p);
    if pk > p then
      Result := Copy(s,1,pk-p+1);
  end;
end;

{-----------------------------------------------------------------------------
PosAndNameNstData
  ze zakodovane nested sekce 1.urovne (AStr) vraci pozici sekce 2.urovne
   (vlastne udaje, kde jsou ulozeny vlozene formulare, napr. R16DATA)
  v out AFldName vraci prave nazev udaje, napr. R16DATA
  - hledani se provadi dle konstanty cNstDataText ( DATA=[NestedSections] )
    a jejiho n-teho vyskytu, uvedeneho v OccurNo
-----------------------------------------------------------------------------}
function PosAndNameNstData(const AStr: string; OccurNo: integer; out AFldName: string): integer;
var
  p,pk: integer;
begin
  Result := 0;
  AFldName := '';
  p:=StrNPos(AStr,cNstDataText,OccurNo);
  pk := p;
  repeat
    Dec(p);
  until (not StrIsAlphaNumUnderscore(Copy(AStr,p,1))) or (p = 0);
  if p > 0 then begin
    Result := p+1;
    AFldName := Copy(AStr,Result,pk-Result+4);
  end;
end;

{-----------------------------------------------------------------------------
GetNstSection
  ze zakodovaneho nested formulare AData (vlastne cely vlozeny FRM formular, ale zakodovany)
    vraci rozkodovany formular zacinajici [FORMHEAD] (vraci vlastne rozkodovany FRM formular)
    - vlozene formulare 2 urovne jsou stale zakodovany
  ASectionName obsahuje guid formulare
-----------------------------------------------------------------------------}
function GetNstSection(const AData, ASectionName: string): string;
var
  sl, sl1: TStringList;
  i,ii,c,p: integer;
  s, ss, fldDataName, r:string;
  lb: string;

  function TrimCRLFAlternate(const AStr: string): string;
  begin
    Result := StrTrimCharsLeft(AStr,[#255, '#']);
    Result := StrTrimCharsRight(Result,[#255, '#']);
  end;

begin
  Result := '';
  sl := TStringList.Create;
  sl1 := TStringList.Create;
  try
    s := StrMid(AData,  //do "s" naplnime data, ohranicena guidem ASectionName (uz bez guidu)
                Pos('['+ASectionName+']',AData)+Length('['+ASectionName+']'),
                Pos('[/'+ASectionName+']',AData)-(Pos('['+ASectionName+']',AData)+Length('['+ASectionName+']')));
    /////////////////////////////////////////////////////////////////////////////
    c := StrStrCount(s,cNstDataText);  //zjistime pocet formularu 2.urovne
    //do SringListu si na jednotlive radky naplnime udaje dat a listboxu 2.urovne (napr. R16DATA a R16) - zakodovane!!!!!
    for i := 1 to c do begin
      p := PosAndNameNstData(s, i, fldDataName);    //zjistime pozici i-teho vyskytu udaje (napr. R16DATA) a jeho nazev
      ss := Copy(s,p,maxint);                       //do "ss" naplnime data z "s" od pozice "p" po konec
      sl.Add(Copy(ss,1,Pos(cNstSectEnd,ss)+Length(cNstSectEnd)-1)); //"ss" pridame do sl, ale uz jen konkretni udaj (napr. R16DATA)
      lb := GetLBValue(s,Replace('DATA',fldDataName,'')+'='); //do "lb" naplnime udaj ListBoxu (napr. R16)
      sl.Add(lb);                                             //a pridame do sl
    end;
    //prochazime jednotlive radky StringListu a radky odstranujeme z puvodnich dat "s"
    for i := 0 to sl.Count - 1 do
      if sl[i] <> '' then
        s := Replace(sl[i],s,'');
    /////////////////////////////////////////////////////////////////////////////
    //rozkodujeme "s", tim ziskame klasickou strukturu (pripadne dalsi NST sekce, ktere ale nejsou vlozenymi formulari, zustanou zakodovany (napr. nc_09ELDPHromEP))
    repeat
      s:=TrimCRLFAlternate(s);  //odstranime cCRLFAlternate ze zacatku a konce
      p:=Pos(cCRLFAlternate,s); //zjistime pozici cCRLFAlternate
      r:=Copy(s,1,p-1);         //zapiseme radek
      if r='' then              //pokud je r prazdny (tzn. cCRLFAlternate neexistuje),
        r:=Copy(s,1,maxint);    //tak zapiseme cely zbytek radku
      if Pos('='+cNstSectStart,r) > 0 then begin  //pokud radek obsahuje "=[NestedSection]"
        c := StrStrCount(s,'='+cNstSectStart);    //zapiseme pocet vyskytu v selem "s"
        r := StrMid(s,1, StrNPos(s,cNstSectEnd,c)+Length(cNstSectEnd)-1);  //a do "r" zapiseme celou nested sekci
      end;
      sl1.Add(r);                                 //radek pridame do StrigListu
      //
      if Copy(s, 1, Length(r)) = r then           //a odstranime z "s"
        s := Copy(s, Length(r) + 1, maxint);
    until Length(s) = 0;
    /////////////////////////////////////////////////////////////////////////////    
    //do sekce Values vratime zakodovane formulare 2.urovne
    for i := 0 to sl1.Count - 1 do
      if UpperCase(sl1[i]) = '[VALUES]' then begin
        for ii := 0 to sl.Count - 1 do
          sl1.Insert(i+1,sl[ii]);
        Break;
      end;
    Result := sl1.Text;
  finally
    sl.Free;
    sl1.Free;
  end;
end; {GetNstSection}

{-----------------------------------------------------------------------------
PridejNodeValue
  - vlastni zpracovani node Values
  - z node Values (ANodeValues) vezme udaj NodeName, kde jsou vlozene formulare (napr. NPDATA)
    a prevede do struktury XML
  - tohle XML prida do nadrazeneho node (ANodeRoot) a zaroven je tohle node navratovou hodnotou
  ANodeValues: node Values, ve kterem je udaj se zakodovanym vlozenym formularem
  NodeName: jmeno udaje, ve kterem je zakodovany formular napr. NPDATA)
  ARecIndex: cislo zaznamu v ListBoxu (zatim SE NEPOUZIVA)
  AGuid: guid, kterym je "propojeny" ListBox a Data
  ACaption: popis vlozeneho formulaze v ListBoxu
-----------------------------------------------------------------------------}
function PridejNodeValue(ANodeValues: IXMLNode; NodeName: string;
                                ANodeRoot: IXMLNode;
                                ARecIndex: integer;
                                AGuid: string;
                                ACaption: string): IXMLNode;
var
  slNstSection1, slTemp: TStringList;
  nodeNstLevel1, nodeNstLevel1XML: IXMLNode;
  y: integer;
  validNode: boolean;

const
  cValidNode = '[FORMHEAD],[VALUES],[USERSETTINGS]';
begin
  Result := nil;
  slNstSection1 := TStringList.Create;
  slTemp := TStringList.Create;
  validNode := TRUE;
  try
    slNstSection1.Text := GetNstSection(ANodeValues.ChildNodes.Nodes[NodeName].NodeValue, AGuid); //do StringListu naplnime rozkodovany FRM formular (dle guidu)
    if slNstSection1.Count > 0 then begin
      nodeNstLevel1 := ANodeRoot.AddChild('FORM');     //v nadrazenem node vytvorime node FORM
      nodeNstLevel1.ChildValues['RecIndex'] := IntToStr(ARecIndex);             //pridame poradove cislo
      nodeNstLevel1.ChildValues['Guid'] := AGuid;                               //pridame guid
      nodeNstLevel1.ChildValues['Caption'] := ACaption;                         //pridame popis v ListBoxu
      if slNstSection1.Count = 1 then begin                             //14.7.16 (Marek) - pokud formular obsahuje jen jeden radek,
        try                                                             //(coz neni mozne - vznikne pouze v pripade, ze pro radek v ListBoxu nemame data v Memu)
          nodeNstLevel1XML := nodeNstLevel1.AddChild('FORMHEAD');       //tak pridame prazdne sekce, cimz zajistime spravne ulozeni
          nodeNstLevel1XML := nodeNstLevel1.AddChild('VALUES');         //(v opracnem pripade dojde v PridejNode k AV a data se ulozi ve FRM formatu)
        except
        end;
      end
      else begin
        for y := 0 to slNstSection1.Count - 1 do begin                            //prevedeme StringList na XML
          if Copy(slNstSection1[y],1,1) = '[' then begin                          //zacatel sekce v SL pozname podle "[", nize budeme vytvaret nadrazene Node
            if (not validNode) and (slTemp.Count > 0) then begin                  //pokud se jedna o "rich" sekce (Comment, Notes, Appendix)
              nodeNstLevel1XML.NodeValue := slTemp.Text;                          //tak zapisujeme primo do Node
              slTemp.Clear;
            end;
            try                                                                   //vytvarime nadrazene Node
              nodeNstLevel1XML := nodeNstLevel1.AddChild(Replace(']',Replace('[',UpperCase(slNstSection1[y]),''),''));
            except
            end;
            validNode := Pos(UpperCase(slNstSection1[y]),cValidNode)>0;           //nastavime, zda se jedna o "normalni" sekce (FormHead, Values, UserSettings)
          end
          else if nodeNstLevel1XML <> nil then begin                              //zapis jednotlivych udaju
            if validNode then begin                                               //pokud se jedna o "normalni" sekce, zapisujeme node
              if (slNstSection1[y] <> '') then try
                nodeNstLevel1XML.ChildValues[SlStringName(slNstSection1[y])] := SlStringValue(slNstSection1[y]);
              except
              end;
            end
            else begin
              slTemp.Add(slNstSection1[y]);                                       //jinak zapisujeme jednotlive radky do slTemp
              if y = (slNstSection1.Count - 1) then                               //pokud se jedna o posledni radek, tak zapiseme
                nodeNstLevel1XML.NodeValue := slTemp.Text;
            end;
          end;
        end;
      end;
      Result := nodeNstLevel1;
    end;
  finally
    slNstSection1.Free;
    slTemp.Free;
  end;
end;

{-----------------------------------------------------------------------------
SmazOldNstData
  z XML, resp. node VALUES, odstrani vlozene sekce (napr. NS a NSDATA)
-----------------------------------------------------------------------------}
procedure SmazOldNstData(ANodeValues: IXMLNode; NodeName: string);
begin
  ANodeValues.ChildNodes.Remove(ANodeValues.ChildNodes.Nodes[NodeName]);
  ANodeValues.ChildNodes.Remove(ANodeValues.ChildNodes.Nodes[Replace('DATA',NodeName,'')]);
end;

{-----------------------------------------------------------------------------
PridejNode
  - z node Values (ANodeValues) vezme udaj NodeName, kde jsou vlozene formulare (napr. NPDATA)
    a prevede do struktury XML (viz. PridejNodeValue)
-----------------------------------------------------------------------------}
function PridejNode(ANodeValues: IXMLNode; NodeName: string): IXMLNode;
var
  iXML: IXMLDocument;
  iRoot, nodeNstLevel1,nnn: IXMLNode;
  slNstListBox1: TStringList;
  i, posGuid: integer;
  guid: string;
  //
  slNstDataFieldNames2: TStringList;
  nodeValues2, nodeNstSec2: IXMLNode;
  i2: integer;
begin
  slNstListBox1 := TStringList.Create;
  //
  XMLDocTmp.Active := False;
  XMLDocTmp.XML.Text := '';
  XMLDocTmp.Active := True;
  try
    //
    iXML := XMLDocTmp;
    iRoot := iXML.AddChild(NodeName);
    //
    if ANodeValues.ChildNodes.Nodes[Replace('DATA',NodeName,'')].NodeValue <> null then begin
      slNstListBox1.Text := Replace(cCRLFAlternate,  //do StringListu si naplnime seznam "ListBoxu"
                              Replace(cCRLFAlternate1,
                                      ANodeValues.ChildNodes.Nodes[Replace('DATA',NodeName,'')].NodeValue,
                                      cCRLF),
                                    cCRLF);
      posGuid := 0;
      for i := 0 to slNstListBox1.Count - 1 do begin  //prochazime jednotlive radky
        slNstListBox1[i] := Replace('[/NestedSections]', //v nekterych pripadech ListBox obsahuje string NestedSections, tak odstranime
                              Replace('[NestedSections]',slNstListBox1[i],'',TRUE),'',TRUE);
        //
        posGuid := GetPosGuidAtListBox(slNstListBox1[i], i, iRoot, posGuid);  //zjistime pozici guidu
        //
        if posGuid > 0 then begin
          guid := Trim(Copy(slNstListBox1[i],posGuid,maxint));                //zapiseme nazev guidu
          //
          //provedeme vlastni zpracovani
          nodeNstLevel1 := PridejNodeValue(ANodeValues, NodeName, iRoot, i, guid, Trim(Copy(slNstListBox1[i],1,posGuid-1)));
          //zacatek zpracovani 2 urovne (popis viz. fce NormalizeXML)///////////////////////////////////////
          if nodeNstLevel1 <> nil then begin
            slNstDataFieldNames2 := TStringList.Create;
            try
              nodeValues2 := GetNodeByName(nodeNstLevel1, 'Values'); //schvalne neosetruji nil, aby se v pripade vyjimky vyexportovalo puvodni XML
              //if nodeValues2 <> nil then begin
                slNstDataFieldNames2.Text := GetNstDataFieldNames(nodeValues2);
                if slNstDataFieldNames2.Count > 0 then begin
                  nodeNstSec2 := nodeValues2.AddChild(cNstSectNodeName);  //vytvorime sekci pro VSECHNY vlozene formulare
                  for i2 := 0 to slNstDataFieldNames2.Count - 1 do begin
                    nodeNstSec2.ChildNodes.Add(PridejNode(nodeValues2, slNstDataFieldNames2[i2]));
                    SmazOldNstData(nodeValues2, slNstDataFieldNames2[i2]);
                  end;
                end;
              //end;
            finally
              slNstDataFieldNames2.Free;
            end;
          end;
          //konec zpracovani 2 urovne///////////////////////////////////////
        end;
      end;
    end;
    Result := iRoot;
  finally
    slNstListBox1.Free;
  end;
end;

{-----------------------------------------------------------------------------
NormalizeXML
  - prevede vlozene formulare ze zakodovaneho (FRM) formatu do normalizovaneho
    a puvodni zakodovane smaze
  - pokud XML neobsahuje zakodovane formulare, vraci puvodni XML
-----------------------------------------------------------------------------}
function NormalizeXML(AXML: string): string;
var
  XMLDoc: IXMLDocument;
  nodeValues: IXMLNode;
  nodeNstSec1: IXMLNode;
  slNstDataFieldNames1: TStringList;
  i: integer;
begin
  //Nahrada nepovolenych znaku
  for i:=1 to Length(AXML) do
    if (AXML[i]<#32)and(AXML[i]<>#9)and(AXML[i]<>#10)and(AXML[i]<>#13) then
      AXML[i]:=#32;
  //
  Result := AXML;
  XMLDocTmp := TXMLDocument.Create(nil) ; //vytvorime globalni XMLDocument
  XMLDoc := TXMLDocument.Create(nil) ;    //vytvorime lokalni XMLDocument
  XMLDoc.XML.Text := AXML;                //a naplnime ho
  XMLDoc.Active := TRUE;
  //
  slNstDataFieldNames1 := TStringList.Create;
  try
    try
      nodeValues := GetNodeByName(XMLDoc.DocumentElement, 'Values'); //z XML ziskame sekci (node) Values
      if nodeValues <> nil then begin
        slNstDataFieldNames1.Text := GetNstDataFieldNames(nodeValues); //zjistime jmena vlozenych formularu 1 urovne (napr. NSDATA, NPDATA apod.)
        if slNstDataFieldNames1.Count > 0 then begin             //pokud obsahuje vlozene formulare, tak
          nodeNstSec1 := nodeValues.AddChild(cNstSectNodeName);  //vytvorime sekci pro VSECHNY vlozene formulare
          for i := 0 to slNstDataFieldNames1.Count - 1 do begin  //prochazime vlozene formulare 1.urovne
            nodeNstSec1.ChildNodes.Add(PridejNode(nodeValues, slNstDataFieldNames1[i])); //a zpracujeme je
            SmazOldNstData(nodeValues, slNstDataFieldNames1[i]);                //nakonec vlozenou sekci smazeme
          end;
          Result := XMLDoc.XML.Text;
        end;
      end;
    except
    end;
  finally
    slNstDataFieldNames1.Free;
    XMLDoc.Active := FALSE;//
    XMLDoc := nil;//
    XMLDocTmp.Active := FALSE;//
    XMLDocTmp := nil;//
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{-----------------------------------------------------------------------------
UnNormNodeDataListBox
  Z normalizovaneho formulare ANode vraci zakodovany (FRM) udaj (node)
    (jedna se vlastne o ListBox, napr. R16)
  - pokud XML neobsahuje zakodovany udaj, vraci nil
-----------------------------------------------------------------------------}
//!!!!!!!!!!!!!!!zvazit doplneni trideni listboxu podle RecIndex
//!!!!!!!!!!!!!!!(plnit do SL recindex a st, setridit podle RecIndex a pak teprve result)
function UnNormNodeDataListBox(ANode: IXMLNode; ACRLFStr: string): IXMLNode;
var
  iXML: IXMLDocument;
  nodeForm1, iRoot: IXMLNode;
  i, posGuid: integer;
  guid, popis,st: string;
begin
  Result := nil;
  if ANode.ChildNodes.Count > 0 then begin
    st:='';
    //
    XMLDocTmp.Active := False;
    XMLDocTmp.XML.Text := '';
    XMLDocTmp.Active := True;
    //
    iXML := XMLDocTmp;
    iRoot := iXML.AddChild(Replace('DATA', ANode.NodeName,'',TRUE));
    //
    posGuid := VarToInt(ANode.Attributes['PosGuid']);
    if posGuid = 0 then
      posGuid := cDefPosGuid;
    //
    for i := 0 to ANode.ChildNodes.count - 1 do begin
      nodeForm1 := ANode.ChildNodes.Nodes[i]; //nacteme node FORM
      if nodeForm1 <> nil then begin
        guid := '';
        if GetNodeByName(nodeForm1, 'Guid') <> nil then
          guid := GetNodeByName(nodeForm1, 'Guid').NodeValue;
        popis := '';
        if GetNodeByName(nodeForm1, 'Caption') <> nil then
          popis := GetNodeByName(nodeForm1, 'Caption').NodeValue;
        //
        st := ConCatExpr(st, StrPadRight(popis,posGuid-1,' ')+guid, ACRLFStr);
      end;
    end;
    iRoot.NodeValue := st;
    //
    Result := iRoot;
  end;
end;

{-----------------------------------------------------------------------------
UnNormNodeData
  Z normalizovaneho formulare ANode vraci zakodovany (FRM) udaj (node)
    (jedna se vlastne o data, napr. R16DATA)
  - pokud XML neobsahuje zakodovany udaj, vraci nil
-----------------------------------------------------------------------------}
function UnNormNodeData(ANode: IXMLNode): IXMLNode;
var
  iXML: IXMLDocument;
  nodeForm1, iRoot, nodeSect1: IXMLNode;
  i, y, x, posGuid: integer;
  guid, popis,st,stTmp: string;
  slTemp: TStringList;

const
  cValidNode = 'FORMHEAD,VALUES,USERSETTINGS,COMMENT,NOTES,APPENDIX';
begin
  Result := nil;
  if ANode.ChildNodes.Count > 0 then begin
    slTemp := TStringList.Create;
    st:='';
    //
    XMLDocTmp.Active := False;
    XMLDocTmp.XML.Text := '';
    XMLDocTmp.Active := True;
    try
      iXML := XMLDocTmp;
      iRoot := iXML.AddChild(ANode.NodeName);
      //
      for i := 0 to ANode.ChildNodes.count - 1 do begin
        nodeForm1 := ANode.ChildNodes.Nodes[i]; //nacteme node FORM
        if nodeForm1 <> nil then begin
          stTmp := '';
          guid := '';
          if GetNodeByName(nodeForm1, 'Guid') <> nil then    //zjistime Guid
            guid := GetNodeByName(nodeForm1, 'Guid').NodeValue;
          for y := 0 to nodeForm1.ChildNodes.count - 1 do begin //prochazime node FORM
            if Pos(UpperCase(nodeForm1.ChildNodes.Nodes[y].NodeName), cValidNode) > 0 then begin  //pokud je jmeno node platna sekce
              stTmp := ConCatExpr(stTmp, '['+AnsiLowerCaseUpFirst(nodeForm1.ChildNodes.Nodes[y].NodeName)+']', cCRLFAlternate); //tak vlozime nazev sekce do hranatych zavorek
              if stTmp = '[Formhead]' then
                stTmp := '[FormHead]';
              if nodeForm1.ChildNodes.Nodes[y].IsTextElement then begin         //pokud se jedna o single node, vlastne "rich" sekce (Comment, Notes, Appendix)
                slTemp.Text := VarToStr(nodeForm1.ChildNodes.Nodes[y].NodeValue);//tak zapiseme do StringListu (zakodovani primo NodeValue nefunguje!!!!!!!!!!!!!!!!!)
                slTemp.Text := Replace(cCRLF, slTemp.Text,cCRLFAlternate);      // a zakodujeme
                stTmp := ConCatExpr(stTmp, slTemp.Text, cCRLFAlternate);              //a pridame do stringu "stTemp"
              end
              else begin
                nodeSect1 := nodeForm1.ChildNodes.Nodes[y];                     //pokud se nejedna o single node (jde o FormHead, Values, UserSettings)
                for x := 0 to nodeSect1.ChildNodes.Count - 1 do begin           //tak prochazime jednotlive radky a zapisujeme ve tvaru value=hodnota
                  if nodeSect1.ChildNodes.Nodes[x].IsTextElement then
                    stTmp := ConCatExpr(stTmp, nodeSect1.ChildNodes.Nodes[x].NodeName+'='+VarToStr(nodeSect1.ChildNodes.Nodes[x].NodeValue), cCRLFAlternate);
                end;
              end;
            end;
          end;
          if stTmp <> '' then begin
            stTmp := ConCatExpr('['+guid+']', stTmp, cCRLFAlternate);                   //na zacatek vlozime guid
            stTmp := ConCatExpr(stTmp, '[/'+guid+']', cCRLFAlternate);                  //a na konec jeho ukonceni
            //
            st := ConCatExpr(st, stTmp, cCRLFAlternate);                                //a cele to vlozime do puvodniho "st"
          end;
        end;
      end;
      if st <> '' then begin
        st := ConCatExpr(cNstSectStart, st, cCRLFAlternate);                    //na zacatek vlozime nested text
        st := ConCatExpr(st, cNstSectEnd, cCRLFAlternate);                      //a na konec jeho ukonceni
      end;

      slTemp.Text := st;                                                        //"st" zapiseme do StringListu (Replace primo v "st" nefunguje!!!!!!!!!!!!!!!!!)
      slTemp.Text := Replace(cCRLF, slTemp.Text,cCRLFAlternate);                // a zakodujeme
      iRoot.NodeValue := slTemp.Text;
      //
      Result := iRoot;
    finally
      slTemp.Free;
    end;
  end;
end;

{-----------------------------------------------------------------------------
UnNormalizeXML
  - prevede vlozene formulare z normalizovaneho formatu (XML) do zakodovaneho (FRM) formatu
    a puvodni normalizovane smaze
  - pokud XML neobsahuje zakodovane formulare, vraci puvodni XML
  Pozn. Nacte vlozenou sekci (1. urovne), ale napred zpracuje pripadne vlozene formulare 2. urovne a pak teprve 1. urovne
-----------------------------------------------------------------------------}
function UnNormalizeXML(AXML: string): string;
var
  XMLDoc: IXMLDocument;
  nodeValues1, nodeNstSec1, nodeForm1: IXMLNode;
  nodeValues2, nodeNstSec2: IXMLNode;
  nodeTmp: IXMLNode;
  slNstDataFieldNames1: TStringList;
  i, i2, y: integer;
begin
  Result := AXML;
  XMLDocTmp := TXMLDocument.Create(nil) ; //vytvorime globalni XMLDocument
  XMLDoc := TXMLDocument.Create(nil) ;    //vytvorime lokalni XMLDocument
  XMLDoc.XML.Text := AXML;                //a naplnime ho
  XMLDoc.Active := TRUE;
  //
  slNstDataFieldNames1 := TStringList.Create;
  try
    try
      nodeValues1 := GetNodeByName(XMLDoc.DocumentElement, 'Values'); //z XML ziskame sekci (node) Values 1 urovne
      if nodeValues1 <> nil then begin
        nodeNstSec1 := nodeValues1.ChildNodes.FindNode(cNstSectNodeName); //zjistime, jestli existuje sekce (node) s vlozenymi formulari (NESTEDSECTION)
        if nodeNstSec1 <> nil then begin
          for i := 0 to nodeNstSec1.ChildNodes.Count - 1 do begin //v NESTEDSECTION prochazime sekce NPDATA, NSDATA (+ R16DATA+R30DATA 1 urovne)
            //zacatek zpracovani 2 urovne///////////////////////////////////////
            for y := 0 to nodeNstSec1.ChildNodes.Nodes[i].ChildNodes.Count - 1 do begin //v NPDATA, NSDATA atd prochazime sekce FORM
              nodeValues2 := GetNodeByName(nodeNstSec1.ChildNodes.Nodes[i].ChildNodes.Nodes[y], 'Values'); //ziskame sekci (node) Values 2 urovne (pomoci FORM)
              if nodeValues2 <> nil then begin
                nodeNstSec2 := nodeValues2.ChildNodes.FindNode(cNstSectNodeName); //zjistime, jestli existuje sekce (node) s vlozenymi formulari (NESTEDSECTION)
                if nodeNstSec2 <> nil then begin
                  for i2 := 0 to nodeNstSec2.ChildNodes.Count - 1 do begin
                  //vlastni zpracovani 2 urovne!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    nodeTmp := UnNormNodeDataListBox(nodeNstSec2.ChildNodes.Nodes[i2], cCRLFAlternate1);
                    if nodeTmp <> nil then begin
                      nodeValues2.ChildNodes.Add(nodeTmp);
                      nodeTmp := UnNormNodeData(nodeNstSec2.ChildNodes.Nodes[i2]);
                      if nodeTmp <> nil then
                        nodeValues2.ChildNodes.Add(nodeTmp);
                    end;
                  end;
                  for i2 := nodeNstSec2.ChildNodes.Count - 1 downto 0 do
                    SmazOldNstData(nodeNstSec2, nodeNstSec2.ChildNodes.Nodes[i2].NodeName);                //nakonec vlozenou sekci smazeme
                  SmazOldNstData(nodeValues2, cNstSectNodeName);
                end;
              end;
            end;
            //konec zpracovani 2 urovne/////////////////////////////////////////

            //vlastni zpracovani 1 urovne!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            nodeTmp := UnNormNodeDataListBox(nodeNstSec1.ChildNodes.Nodes[i], cCRLFAlternate);
            if nodeTmp <> nil then begin
              nodeValues1.ChildNodes.Add(nodeTmp);
              //SaveStringToFile(nodeNstSec1.ChildNodes.Nodes[i].XML,'C:\QN Vyvoj\XML IntFrmToXmlFrm\XML UnNormal\sl.xml');
              nodeTmp := UnNormNodeData(nodeNstSec1.ChildNodes.Nodes[i]);
              if nodeTmp <> nil then
                nodeValues1.ChildNodes.Add(nodeTmp);
            end;
          end;
          for i := nodeNstSec1.ChildNodes.Count - 1 downto 0 do
            SmazOldNstData(nodeNstSec1, nodeNstSec1.ChildNodes.Nodes[i].NodeName);                //nakonec vlozenou sekci smazeme
          SmazOldNstData(nodeValues1, cNstSectNodeName);
          //
          Result := XMLDoc.XML.Text;
        end;
      end;
    except
    end;
  finally
    slNstDataFieldNames1.Free;
    XMLDoc.Active := FALSE;//
    XMLDoc := nil;//
    XMLDocTmp.Active := FALSE;//
    XMLDocTmp := nil;//
  end;
end;
end.

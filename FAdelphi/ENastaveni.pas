{ 24.10.2012 10:43:47 (GMT+2:00) > [mik] checked in   }
{ 16.10.2012 12:02:47 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 26.9.2012 14:42:28 (GMT+2:00) > [pinkava on PINKAVA-XP1] checked in Uprava v  MsgBox  }
{ 29.9.2009 11:43:02 (GMT+2:00) > [mik] checked in Moznost nastaveni prazdne licence.  }
{ 24.9.2009 16:06:11 (GMT+2:00) > [mik] checked in   }
{ 23.9.2009 11:20:51 (GMT+2:00) > [mik] checked in Zmena udaje Version v definicich z integer na string  }
{ 25.10.2006 10:27:20 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 17.10.2006 13:12:48 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 13.10.2006 16:01:11 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 11.8.2006 14:39:51 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 11.8.2006 14:23:39 (GMT+2:00) > [mik on PCMIK64] checked in Doplnen checkbox kontroly rozdilu  }
{ 25.10.2005 15:04:23 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 4.10.2005 17:38:41 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 21.9.2005 15:59:30 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 7.9.2005 16:17:32 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 7.9.2005 16:01:28 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 2.9.2005 15:57:07 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 26.6.2005 20:43:20 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 10:55:14 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 10:19:29 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:35:32 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 3.5.2005 14:12:31 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
unit ENastaveni;

interface

{$I Switches.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxTextEdit, cxDBEdit, StdCtrls, cxButtons, ExtCtrls, cxPC,
  cxControls, mxStatusBar,Db, cxMemo, cxCheckBox, Mask, DBCtrls,
  cxLookAndFeels, cxRadioGroup, cxMaskEdit, cxSpinEdit, cxDropDownEdit,
  cxMRUEdit, JCLStrings,
  cxImageComboBox, cxGraphics, cxCustomData, cxStyles, cxTL,
  cxInplaceContainer, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxClasses,
  cxGridCustomView, cxGrid, kbmMemTable, kbmMemCSVStreamFormat,
  Res_FA,
{$IFNDEF STANDALONE}
  EfmAbsDB,DataModMain,
{$ENDIF STANDALONE}
  Menus, dxSkinsCore, dxSkinCaramel, dxSkinOffice2007Blue,
  dxSkinOffice2010Black, dxSkinscxPCPainter, cxTLdxBarBuiltInMenu,
  cxPCdxBarPopupMenu, cxNavigator, dxBarBuiltInMenu;

procedure OpenNastaveniDialog;

type
  TProcAktualizace = function(AWinState: TWindowState = wsnormal): boolean;
  //TProcAktualizace = function(const AUpdateFromDir: boolean): boolean;

  TfmNastaveni = class(TForm)
    Panel1: TPanel;
    btOK: TcxButton;
    btCancel: TcxButton;
    pcParametry: TcxPageControl;
    cxTabLicence: TcxTabSheet;
    Label34: TLabel;
    btLicSet: TcxButton;
    edLicName: TcxTextEdit;
    edLicSerialNum: TcxTextEdit;
    Label37: TLabel;
    meLicInfo: TcxMemo;
    btCalcLic: TcxButton;
    Shape6: TShape;
    RadioGroup4: TRadioGroup;
    Panel2: TPanel;
    Label6: TLabel;
    Label13: TLabel;
    OpenDialog: TOpenDialog;
    paLeft: TPanel;
    paLeftTop: TPanel;
    Label32: TLabel;
    Panel11: TPanel;
    cxTabFormulare: TcxTabSheet;
    RadioGroup15: TRadioGroup;
    cxDBCheckBox5: TcxDBCheckBox;
    cxDBCheckBox6: TcxDBCheckBox;
    cxDBCheckBox7: TcxDBCheckBox;
    cxDBCheckBox8: TcxDBCheckBox;
    cxDBCheckBox9: TcxDBCheckBox;
    cbShowErrs: TcxDBCheckBox;
    cbShowWarns: TcxDBCheckBox;
    cbShowTips: TcxDBCheckBox;
    Shape8: TShape;
    RadioGroup1: TRadioGroup;
    cxDBCheckBox1: TcxDBCheckBox;
    dxtlContentcxTreeListColumn1: TcxTreeListColumn;
    cxDBCheckBox4: TcxDBCheckBox;
    cxTabSkupinyForm: TcxTabSheet;
    cxMainGrid: TcxGrid;
    mgDBBandedView: TcxGridDBBandedTableView;
    mgDBBandedViewDefID: TcxGridDBBandedColumn;
    mgDBBandedViewName: TcxGridDBBandedColumn;
    mgDBBandedViewModel: TcxGridDBBandedColumn;
    mgDBBandedViewVersion: TcxGridDBBandedColumn;
    mgDBBandedViewVersionPrg: TcxGridDBBandedColumn;
    mgDBBandedViewDate: TcxGridDBBandedColumn;
    mgDBBandedViewGroup: TcxGridDBBandedColumn;
    mgDBBandedViewComment: TcxGridDBBandedColumn;
    mgDBBandedViewValidFrom: TcxGridDBBandedColumn;
    mgDBBandedViewValidTo: TcxGridDBBandedColumn;
    mgDBBandedViewDef: TcxGridDBBandedColumn;
    cxMainGridDBBandedTableView1: TcxGridDBBandedTableView;
    cxMainGridDBBandedTableView1Group: TcxGridDBBandedColumn;
    cxMainGridDBBandedTableView1Select: TcxGridDBBandedColumn;
    mgLevelMain: TcxGridLevel;
    cxDBCheckBox10: TcxDBCheckBox;
    dxTlContent: TcxTreeList;
    Panel14: TPanel;
    Label43: TLabel;
    cxDBSpinEdit5: TcxDBSpinEdit;
    Panel15: TPanel;
    Label44: TLabel;
    cxTreeList1: TcxTreeList;
    cxTreeListColumn1: TcxTreeListColumn;
    dsParam: TDataSource;
    mtParam: TkbmMemTable;
    mtParamAutoStartKalendar: TBooleanField;
    mtParamAutoStartAdresar: TBooleanField;
    mtParamAutoStartMax: TBooleanField;
    mtParamForms: TBlobField;
    mtParampaBlob: TBlobField;
    mtParamShowHistDlgSave: TBooleanField;
    mtParamShowThousandSeparator: TBooleanField;
    mtParamClearFldAtDisable: TBooleanField;
    mtParamDisableCalc: TBooleanField;
    mtParamSavePrintParams: TBooleanField;
    mtParamOpenCheckWithErr: TBooleanField;
    mtParamOpenCheckWithWarn: TBooleanField;
    mtParamOpenCheckWithInfo: TBooleanField;
    mtParamAktualizaceOdRoku: TIntegerField;
    mtParamSavePohl: TBooleanField;
    mtParamLastPohl: TIntegerField;
    mtParamUseCompleteText: TBooleanField;
    mtParamCompleteTextNumChars: TIntegerField;
    mtParamStoreTexts: TBooleanField;
    mtParamPohledy: TBlobField;
    mtParamUsrSkup1: TStringField;
    mtParamUsrSkup2: TStringField;
    mtParamUsrSkup3: TStringField;
    mtParamUsrSkup4: TStringField;
    mtParamUsrSkup5: TStringField;
    mtParamUsrSkup6: TStringField;
    mtParamUsrSkup7: TStringField;
    mtParamUsrSkup8: TStringField;
    mtParamUsrSkup9: TStringField;
    mtParamShowHint: TBooleanField;
    mtParamFastScroll: TBooleanField;
    mtParamMakeUpdateFromDir: TBooleanField;
    mtParamUpdateDir: TStringField;
    mtParamDateLastUpdate: TDateTimeField;
    mtParamPeriodicityUpdate: TSmallintField;
    mtParamUpdateDefsFromYear: TIntegerField;
    mtParamSkDefColor: TBooleanField;
    mtParamAlgPositiveCorrection: TBooleanField;
    mtParamPayWarnBefore: TIntegerField;
    mtParamPayWarnAfterStart: TBooleanField;
    mtParamPaySubject: TStringField;
    mtParamPayTextBefore: TMemoField;
    mtParamPayTextAfter: TMemoField;
    mtParamPayShowEmail: TBooleanField;
    mtParamPayWarn: TBooleanField;
    mtParamFillerB1: TBooleanField;
    mtParamFillerB2: TBooleanField;
    mtParamFillerN1: TIntegerField;
    mtParamFillerA1: TStringField;
    mtParamAdrFormState: TIntegerField;
    mtGroups: TkbmMemTable;
    mtGroupsGroup: TStringField;
    mtGroupsSelect: TBooleanField;
    dsGroups: TDataSource;
    CsvFormat: TkbmCSVStreamFormat;
    mtDefs: TkbmMemTable;
    mtDefsDefID: TStringField;
    mtDefsAktualizovat: TBooleanField;
    mtDefsPlatnostOd: TDateTimeField;
    mtDefsPlatnostDo: TDateTimeField;
    mtDefsSkupina: TStringField;
    mtDefsPodskupina: TStringField;
    mtDefsNazev: TStringField;
    mtDefsPopisZmen: TStringField;
    mtDefsVariantySestav: TStringField;
    mtDefsVelikost: TIntegerField;
    mtDefsBezTisku: TBooleanField;
    mtDefsVerzeRep: TIntegerField;
    mtDefsBarva: TStringField;
    cbShowDifs: TcxDBCheckBox;
    mtParamOpenCheckWithDif: TBooleanField;
    mtDefsVerze: TStringField;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fldsParamKeyPress(Sender: TObject; var Key: Char);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btLicSetClick(Sender: TObject);
    procedure edLicNamePropertiesChange(Sender: TObject);
    procedure edLicSerialNumPropertiesChange(Sender: TObject);
    procedure btCalcLicClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure dxtlContent1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure dxTlContentFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
  private
    FAskForSave: boolean;
    FOpenLicencePage: boolean;
    procedure InitObsah;
    procedure SaveMtParam;
    procedure LoadMtParam;
    procedure SaveMtGroups;
    procedure LoadMtGroups;
  public
    function ShowParametry(AOpenLicenceTab: boolean = FALSE):boolean;
    procedure SetEnabledLicButton;
  end;

var
  fmNastaveni: TfmNastaveni;

implementation

{$R *.dfm}

uses
  IniFiles, FCommonUtils, DKLicUtils, Main, SpolFunkce;

procedure OpenNastaveniDialog;
begin
  if fmNastaveni = nil then
    fmNastaveni:=TfmNastaveni.Create(nil);
  try
    with fmNastaveni do
      ShowParametry;
  finally
    fmNastaveni.Free;
    fmNastaveni := nil;
  end;
end; {OpenNastaveniDialog}

procedure TfmNastaveni.FormCreate(Sender: TObject);
begin
  inherited;
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
  pcParametry.HideTabs:=TRUE;
  pcParametry.TabStop:=FALSE;
  FAskForSave:=TRUE;
  InitObsah;
  mtParam.Open;
  mtGroups.Open;
end;

procedure TfmNastaveni.FormDestroy(Sender: TObject);
begin
  mtParam.Close;
  mtGroups.Close;
end;

procedure TfmNastaveni.FormShow(Sender: TObject);
begin
  {if mtParamMakeUpdateFromDir.Value then
    rbUpdateFromDir.Checked:=TRUE
  else
    rbUpdateFromWeb.Checked:=TRUE;
  edUpdateDir.Text:=mtParamUpdateDir.Value;
  //
  edUpdateDir.Enabled:=rbUpdateFromDir.Checked;}

  pcParametry.ActivePage:=cxTabFormulare;
  dxTlContent.Items[pcParametry.ActivePageIndex].Focused := TRUE;
  LoadMtParam;
  LoadMtGroups;
end;

function TfmNastaveni.ShowParametry(AOpenLicenceTab: boolean = FALSE): boolean;
var
  licName,licSerialNum: string;
begin
  Result:=TRUE;
  //Inicilaizace zalozky licence
  if ReadLicence(licName, licSerialNum) then begin
    edLicName.Text:=licName;
    if licSerialNum<>'' then begin
      edLicSerialNum.Text:=ExtractProductionNumber(licSerialNum)+'******';
      meLicInfo.Lines.Text:=CalcLicInfo(ExtractProductionNumber(edLicSerialNum.Text));
    end
    else begin
      edLicSerialNum.Text:='';
      meLicInfo.Lines.Text:=CalcLicInfo('');
    end;
  end
  else begin
    edLicName.Text:=licName;
    edLicSerialNum.Text:='';
  end;
{$IFDEF FINALBUILD}
  btCalcLic.Visible:=FALSE;
{$ELSE  FINALBUILD}
  btCalcLic.Visible:=TRUE;
{$ENDIF FINALBUILD}

  FOpenLicencePage:=AOpenLicenceTab;
  //
  if fmNastaveni.ShowModal=MROK then begin
    {if mtParam.State = dsEdit then
      mtParam.Post;}
  end;
end;{ShowParametry}

procedure TfmNastaveni.fldsParamKeyPress(Sender: TObject;
  var Key: Char);
  function FindFirst(AParent: TWinControl): TWinControl;
  var
    c: TComponent;
    i: integer;
  begin
    Result := nil;
    for i := 0 to ComponentCount - 1 do begin
      c := Components[i];
      if (c <> nil) and (TWinControl(c).Parent = AParent) and
        (TWinControl(c).TabOrder = 0) then begin
        Result := TWinControl(c);
        Exit;
      end;
    end;
  end;

  //GoToNext
  function GoToNext(ASender: TWinControl; ATabOrder: integer = -1): boolean;
  var
    c: TComponent;
    i, findTabOrder: integer;
    prnt, fc: TWinControl;
  begin
    Result := True;
    if ASender = nil then
      Exit;
    if ATabOrder > -1 then
      findTabOrder := ATabOrder
    else
      findTabOrder := ASender.TabOrder + 1;

    prnt := ASender.Parent;
    for i := 0 to ComponentCount - 1 do begin
      c := Components[i];
      if (c <> nil) then begin
        if ((c is TcxDBTextEdit) or (c is TcxDBCheckBox)or
          (c is TcxTextEdit) or (c is TcxDBSpinEdit)) and
          (TWinControl(c).Parent = prnt) and
          (TWinControl(c).TabOrder = findTabOrder) then begin
          TWinControl(c).SetFocus;
          Result := False;
          Exit;
        end
        else if (c is TcxPageControl) and
          (TWinControl(c).Parent = prnt) and
          (TWinControl(c).TabOrder = findTabOrder) then begin
          fc := FindFirst(TcxPageControl(c).ActivePage);
          GoToNext(fc, 0);
        end;
      end;
    end;
  end; {GoToNext}

begin
  inherited;
  if (Ord(Key) = VK_RETURN) and
    ((Sender is TWinControl){ or (Sender is TcxDBCheckBox)}) then begin
    GoToNext(TWinControl(Sender));
  end;
end;

procedure TfmNastaveni.btOKClick(Sender: TObject);
begin
  inherited;
  if not cbShowErrs.Checked then
    MessageWarn(Caption,sShowErrsDisableWarn,[MBOK]);
  Application.ShowHint := TRUE;
  //ulozeni sdilenych parametru do komponent, ktere nejsou databazove kvuli vzhledu
  FAskForSave:=FALSE;
  SaveMtParam;
  SaveMtGroups;
  GFaMain.LoadParamsFromIni;
end;{cxButton1Click}

procedure TfmNastaveni.btCancelClick(Sender: TObject);
begin
  FAskForSave:=FALSE;
  mtParam.Cancel;
  inherited;
end;{cxButton2Click}

procedure TfmNastaveni.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then
    Close;
end;

procedure TfmNastaveni.dxtlContent1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    PostMessage(Self.Handle, WM_KEYDOWN, VK_TAB, 0);
end;

procedure TfmNastaveni.dxTlContentFocusedNodeChanged(Sender: TcxCustomTreeList;
  APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  pcParametry.ActivePageIndex:=AFocusedNode.AbsoluteIndex;
end;

procedure TfmNastaveni.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  res: integer;
begin
  if not FAskForSave then
    CanClose:=TRUE
  else if mtParam.State<>dsBrowse then begin
    res:=MessageAsk(Caption,sSaveParam,[MBYES, MBNO, MBCANCEL]);
    if res=ID_Yes then
      SaveMtParam
    else if res=ID_Cancel then
      CanClose:=FALSE
    else
      mtParam.Cancel;
  end;
end;

procedure TfmNastaveni.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key=VK_RETURN) and (GetKeyState(VK_CONTROL) < 0) then begin
    btOKClick(nil);
    Close;
  end;
end;

procedure TfmNastaveni.InitObsah;
begin
  dxtlContent.Items[0].Texts[0] := RSObsahForm;
  dxtlContent.Items[1].Texts[0] := RSObsahFormGr;
  dxtlContent.Items[2].Texts[0] := RSObsahLic;
//  dxtlContent.Items[3].Texts[0] := RSObsahPlatby;
//  dxtlContent.Items[4].Texts[0] := RSObsahAkt;
//  dxtlContent.Items[9].Texts[0] := RSObsahDanPor;
end;

//LICENCE ----------------------------------------------------------------
procedure TfmNastaveni.btLicSetClick(Sender: TObject);
begin
  if edLicSerialNum.Text='' then // je to Start
    edLicName.Text:='';
  if SaveLicence(Trim(edLicName.Text),Trim(edLicSerialNum.Text)) then begin
    if edLicSerialNum.Text<>'' then //hvezdicky zobrazime jen pro zadanou licenci
      edLicSerialNum.Text:=ExtractProductionNumber(edLicSerialNum.Text)+'******';
    meLicInfo.Lines.Text:=CalcLicInfo(ExtractProductionNumber(edLicSerialNum.Text));
    MessageInfo(Caption,sLicSaveOK,[MBOK]);
  end
  else begin
    edLicName.Text:='';
    edLicSerialNum.Text:='';
    meLicInfo.Lines.Text:=CalcLicInfo('');
    MessageInfo(Caption,sLicSaveError,[MBOK]);
  end;
end;

procedure TfmNastaveni.SetEnabledLicButton;
begin
  btLicSet.Enabled:= IsLicInfoValid(Trim(edLicName.Text),
    Trim(edLicSerialNum.Text)) or
    (UpperCase(edLicName.Text)='START') and (edLicSerialNum.Text='');
end;

procedure TfmNastaveni.edLicNamePropertiesChange(Sender: TObject);
begin
  inherited;
  SetEnabledLicButton;
end;

procedure TfmNastaveni.edLicSerialNumPropertiesChange(Sender: TObject);
begin
  inherited;
  SetEnabledLicButton;
end;

procedure TfmNastaveni.btCalcLicClick(Sender: TObject);
begin
  if edLicSerialNum.Text='' then
    edLicSerialNum.Text:=cTestLicNo;
  edLicSerialNum.Text:=ExtractProductionNumber(edLicSerialNum.Text)+
    CalcLicInfoCheckSum(Trim(edLicName.Text),
    ExtractProductionNumber(Trim(edLicSerialNum.Text)));
end;

//SaveMtParam
//  ulozi tabulku mtParam do ini
procedure TfmNastaveni.SaveMtParam;
var
  ini: TMemIniFile;
  i: integer;
  f: TField;
begin
  ini := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    for i := 0 to mtParam.FieldCount - 1 do begin
      f := mtParam.Fields[i];

      if (f.DataType = ftBoolean) then
        ini.WriteBool(mtParam.Name, f.FieldName, f.AsBoolean)
      else if (f.DataType = ftInteger) then
        ini.WriteInteger(mtParam.Name, f.FieldName, f.AsInteger)
      else if (f.DataType = ftString) then
        ini.WriteString(mtParam.Name, f.FieldName, f.AsString)
      else if (f.DataType = ftFloat) then
        ini.WriteString(mtParam.Name, f.FieldName, f.AsString);
      SaveMemIni(ini);
    end;
  finally
    ini.Free;
  end;
end;

procedure TfmNastaveni.LoadMtParam;
var
  ini: TMemIniFile;
  i: integer;
  f: TField;
begin
  ini := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    if mtParam.RecordCount=0 then
      mtParam.Append
    else
      mtParam.Edit;

    for i := 0 to mtParam.FieldCount - 1 do begin
      f := mtParam.Fields[i];

      if (f.DataType = ftBoolean) then
        f.AsBoolean:=ini.ReadBool(mtParam.Name, f.FieldName, FALSE)
      else if (f.DataType = ftInteger) then
        f.AsInteger:=ini.ReadInteger(mtParam.Name, f.FieldName, 0)
      else if (f.DataType = ftString) then
        f.AsString:=ini.ReadString(mtParam.Name, f.FieldName, '')
      else if (f.DataType = ftFloat) then
        f.AsString:=ini.ReadString(mtParam.Name, f.FieldName, '')
    end;
    //nektere nastavime znovu s default hodnotou
    with GfaMain do begin
      mtParamShowThousandSeparator.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamShowThousandSeparator.FieldName,
        FParamShowThousandSeparator);
      {nepouziva se
      mtParamClearFldAtDisable.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamClearFldAtDisable.FieldName,
        FParamClearFldAtDisable);
      }
      mtParamDisableCalc.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamDisableCalc.FieldName,
        FParamDisableCalcFieldEnabled);
      mtParamSavePrintParams.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamSavePrintParams.FieldName,
        FParamSavePrintParamsForDefinitions);
      {mtParamFastScroll.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamFastScroll.FieldName,
        FParamFastScroll);}
      mtParamSkDefColor.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamSkDefColor.FieldName,
        FParamDefColor);
      mtParamOpenCheckWithErr.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamOpenCheckWithErr.FieldName, TRUE);
      mtParamOpenCheckWithWarn.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamOpenCheckWithWarn.FieldName, TRUE);
      mtParamOpenCheckWithInfo.AsBoolean:=
        ini.ReadBool(mtParam.Name, mtParamOpenCheckWithInfo.FieldName, TRUE);
    end;

    mtParam.Post;
  finally
    ini.Free;
  end;
end;

//SaveMtGroups
//  ulozi tabulku mtGroups do csv
procedure TfmNastaveni.SaveMtGroups;
begin
  if mtGroups.State=dsEdit then
    mtGroups.Post;
  mtGroups.SaveToFile(NormalPath(GetCurrentUserRootPath)+cGroupsFileName);
end;

procedure TfmNastaveni.LoadMtGroups;
var
  sl: TStringList;
  k: integer;
begin
  if FileExists(NormalPath(GetCurrentUserRootPath)+cGroupsFileName) then
    mtGroups.LoadFromFile(NormalPath(GetCurrentUserRootPath)+cGroupsFileName);
  mtDefs.Open;
  sl:= TStringList.Create;
  try
    if FileExists(NormalPath(GfaMain.DirDefsPath)+cFormDefinitionList) then
      mtDefs.LoadFromFile(NormalPath(GfaMain.DirDefsPath)+cFormDefinitionList);
    mtDefs.First;
    while not mtDefs.EOF do begin
      sl.Sorted:=TRUE;
      if not sl.Find(mtDefsSkupina.Value,k) then
        sl.Add(mtDefsSkupina.Value);
      mtDefs.Next;
    end;
    for k:=0 to sl.Count-1 do begin
      if not mtGroups.Locate(mtGroupsGroup.FieldName,sl[k],
      [loCaseInsensitive]) then begin
        mtGroups.Append;
        mtGroupsGroup.Value:=sl[k];
        mtGroupsSelect.Value:=TRUE;
        mtGroups.Post;
      end;
    end;
    mtGroups.First;
  finally
    sl.Free;
    mtDefs.Close;
  end;
end;

end.

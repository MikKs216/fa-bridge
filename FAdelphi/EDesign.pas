{ 19.11.2019 13:18:39 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Do dsinspDef doplnena readonly polozka LinkedForm (TMS script/design), ve ktere je hodnota "ok", pokud je formular preveden do nove TMS struktury  }
{ 28.11.2017 10:35:03 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Doplnena procedura CheckFormVersion pro kontrolu verze formulare  }
{ 23.10.2013 14:25:22 (GMT+2:00) > [marek on PCMAREK_VPC_V7] checked in Zpristupnen udaj ExportScripts, ktery se nyni pouziva pro zadani nazvu pdf souboru pro pouziti jako pozadi designeru  }
{ 23.9.2009 11:20:51 (GMT+2:00) > [mik] checked in Zmena udaje Version v definicich z integer na string  }
{ 5.6.2005 9:28:58 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 31.5.2005 12:40:03 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 21.4.2005 15:38:20 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 8.10.2003 22:36:56 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 3.9.2003 19:28:40 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 13:34:20 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 17.6.2003 14:27:44 (GMT+2:00) > [mik on MIKPC2] checked in   }
{ 6.6.2003 16:38:55 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.5.2003 13:35:12 (GMT+2:00) > [mik on MIKPC2] checked in   }
//FORM asistent, formular definice formulare
//
//vytvoreno 10.1.2003
//

unit EDesign;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, oinspect, dbinsp,
  ComCtrls, dcDTree, DcTree, DcDbTree,
  StdCtrls, DCGen, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxEdit, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGrid, Menus, cxDataStorage, cxLookAndFeels, cxLookAndFeelPainters,
  cxNavigator;

procedure OpenDesignData;

type
  TfmDesignData = class(TForm)
    paDef: TPanel;
    Splitter1: TSplitter;
    paFields: TPanel;
    Splitter2: TSplitter;
    dsinspDef: TDataSetInspector;
    Label1: TLabel;
    paFieldsInsp: TPanel;
    dsinspFields: TDataSetInspector;
    Label2: TLabel;
    OpenDialog: TOpenDialog;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Name: TcxGridDBColumn;
    cxGrid1DBTableView1DataType: TcxGridDBColumn;
    cxGrid1DBTableView1DataTypeLength: TcxGridDBColumn;
    cxGrid1DBTableView1Caption: TcxGridDBColumn;
    cxGrid1DBTableView1IsCalculated: TcxGridDBColumn;
    cxGrid1DBTableView1DBKey: TcxGridDBColumn;
    ColorDialog: TColorDialog;
    cxGrid1DBTableView1RepInfoPage: TcxGridDBColumn;
    cxGrid1DBTableView1RepInfoPosX: TcxGridDBColumn;
    cxGrid1DBTableView1RepInfoPosY: TcxGridDBColumn;
    cxGrid1DBTableView1RepInfoLength: TcxGridDBColumn;
    cxGrid1DBTableView1RepInfoRightAlignment: TcxGridDBColumn;
    cxGrid1DBTableView1RepInfoFontSize: TcxGridDBColumn;
    cxGrid1DBTableView1RepInfoTrueText: TcxGridDBColumn;
    cxGrid1DBTableView1RepInfoFalseText: TcxGridDBColumn;
    PopupMenu1: TPopupMenu;
    miGenOdkazy: TMenuItem;
    SaveDialog: TSaveDialog;
    miSeznamUdaju: TMenuItem;
    procedure dsinspDefExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dsinspDefEditButtonClick(Sender: TObject;
      const PropEdit: TDCDsgnProperty; var Processed: Boolean);
    procedure dsinspFieldsChangePropValue(Sender: TObject;
      const PropEdit: TDCDsgnProperty; var newval: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miGenOdkazyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dsinspDefChangePropValue(Sender: TObject;
      const PropEdit: TDCDsgnProperty; var newval: String);
    procedure cxGrid1DBTableView1DblClick(Sender: TObject);
    procedure miSeznamUdajuClick(Sender: TObject);
  private
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    procedure SelectEdit;
    function BeforeCloseActions(AShowMsg: Boolean = True): boolean;
  end;

var
  fmDesignData: TfmDesignData;

implementation

uses
  Main, EScriptEditor, IniFiles, FCommonUtils, FUtils,
  ERichTextEditor, JclStrings;

{$R *.dfm}


procedure TfmDesignData.FormCreate(Sender: TObject);
begin
  LoadFormStateFromIni;
end; {FormCreate}

procedure TfmDesignData.FormDestroy(Sender: TObject);
begin
  BeforeCloseActions(False);
end; {FormDestroy}

procedure OpenDesignData;
var
  ctrlsDisabled: boolean;
begin
  ctrlsDisabled:=GfaMain.mtFields.ControlsDisabled;
  if GfaMain.mtFields.ControlsDisabled then
    GfaMain.mtFields.EnableControls;
  try
    if fmDesignData = nil then
      fmDesignData:=TfmDesignData.Create(nil);
    fmDesignData.ShowModal;
    GfaMain.SetChangeFlag(TRUE);
  finally
    fmDesignData.Free;
    fmDesignData:=nil;
    if ctrlsDisabled then
      GfaMain.mtFields.DisableControls;
  end;
end; {OpenDesignData}

function CheckFormVersion(AVer: string; AShowMsg: Boolean = True): Boolean;
var
  s: string;
  c: Integer;

  function StrIsNumDot(AStr: string): Boolean;
  var
    i: Integer;
    zn: string;
  begin
    Result := True;
    for i := 1 to Length(AStr) do begin
      zn := Copy(AStr, i, 1);
      if (not StrIsDigit(zn)) and (zn <> '.') then
        Result := False;
    end;
  end;

  function CopyAndDel(var AStr: string): string;
  var
    p: integer;
  begin
    Result := '';
    p := Pos('.',AStr);
    if p > 0 then begin
      Result := Copy(AStr, 1, p-1);
      AStr := Copy(AStr, p+1, MaxInt);
    end;
  end;

begin
  Result := True;
  if (AVer = '') then begin
    if AShowMsg then
      MsgBoxInfo('', 'Verze formuláøe není zadána.', MB_OK);
    Exit;
  end;
  //
  Result := (StrIsNumDot(AVer)) and (StrStrCount(AVer, '.') = 3);
  if Result then begin
    s := AVer+'.';
    for c := 1 to 4 do begin
      Result := StrIsDigit(CopyAndDel(s));
        if not Result then
          Break;
    end;
  end;
  //
  if not Result then
    if AShowMsg then
      MsgBoxErr('', 'Verze formuláøe má neplatný formát.', MB_OK);
end;

procedure TfmDesignData.dsinspDefExit(Sender: TObject);
begin
  //pri opusteni inspectora zkuntroluje verzi formulare a ulozi zaznam dsDef
  if GfaMain.mtDef.State = dsEdit then begin
    if CheckFormVersion(GfaMain.mtDefFormVersion.AsString) then
      GfaMain.mtDef.Post;
  end;
end; {dsinspDefExit}

function TfmDesignData.BeforeCloseActions(AShowMsg: Boolean = True): boolean;
begin
  GfaMain.mtDef.Refresh;
  Result := CheckFormVersion(GfaMain.mtDefFormVersion.AsString, AShowMsg);
  if GfaMain.mtDef.State = dsEdit then
      GfaMain.mtDef.Post;
  SaveFormStateToIni;
end; {BeforeCloseActions}

procedure TfmDesignData.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not BeforeCloseActions then begin
    Action := caNone;
    dsinspDef.SetFocus;
  end;
end; {FormClose}

//pro sestavu otevre dialog pro nacteni - doplnit ulozeni a vymazani

procedure TfmDesignData.dsinspDefEditButtonClick(Sender: TObject;
  const PropEdit: TDCDsgnProperty; var Processed: Boolean);
begin
  if PropEdit.GetName = 'Barva pozadí' then begin
    if IsValidHexStrColor(GfaMain.mtDefBkColor.Value) then
      ColorDialog.Color := StrToColor(GfaMain.mtDefBkColor.Value);
    if ColorDialog.Execute then begin
      GfaMain.mtDef.Edit;
      GfaMain.mtDefBkColor.Value := ColorToHexStr(ColorDialog.Color);
      GfaMain.mtDef.Post;
    end;
    Processed := TRUE;
  end
  else if PropEdit.GetName = 'Script sestavy' then begin
    GfaMain.EditReportScript;
    Processed := TRUE;
  end
  else if PropEdit.GetName = 'Script formuláøe' then begin
    GfaMain.EditFormScript;
    Processed := TRUE;
  end
  else if PropEdit.GetName = 'Informace' then begin
    GfaMain.EditInstruction;
    Processed := TRUE;
  end;
end; {dsinspDefEditButtonClick}

procedure TfmDesignData.dsinspFieldsChangePropValue(Sender: TObject;
  const PropEdit: TDCDsgnProperty; var newval: string);
begin
  //pri zmene zaznamu mtDef nastavit priznak zmeny
  GfaMain.dxBarButtonSave.Enabled := TRUE;
end; {dsinspFieldsChangePropValue}

procedure TfmDesignData.SaveFormStateToIni;
var
  iniFile: TMemIniFile;
begin
  if not GfaMain.CanWriteToIniFile then EXIT;
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    iniFile.WriteInteger(Name, 'Left', Left);
    iniFile.WriteInteger(Name, 'Top', Top);
    iniFile.WriteInteger(Name, 'Width', Width);
    iniFile.WriteInteger(Name, 'Height', Height);
    //
    iniFile.WriteInteger(Name, 'PaDefWidth', paDef.Width);
    iniFile.WriteInteger(Name, 'PaFieldsInspHeight', paFieldsInsp.Height);
    SaveMemIni(iniFile);
  finally
    iniFile.Free;
  end;
end; {SaveStateFormToIni}

procedure TfmDesignData.LoadFormStateFromIni;
var
  iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    Left := iniFile.ReadInteger(Name, 'Left', 30);
    Top := iniFile.ReadInteger(Name, 'Top', 160);
    Width := iniFile.ReadInteger(Name, 'Width', 826);
    Height := iniFile.ReadInteger(Name, 'Height', 298);
    //
    paDef.Width := iniFile.ReadInteger(Name, 'PaDefWidth', 272);
    paFieldsInsp.Height := iniFile.ReadInteger(Name, 'PaFieldsInspHeight', 128);
  finally
    iniFile.Free;
  end;
end; {LoadStateFormIni}

procedure TfmDesignData.SelectEdit;
var
  i: integer;
begin
  with GfaMain do begin
    if mtContent.Locate(mtContentKey.FieldName,
      mtFieldsContentKey.Value, []) then begin
      for i := 0 to sbForm.ControlCount - 1 do
        if AnsiSameText(sbForm.Controls[i].Name,mtFieldsName.Value) and
          sbForm.Controls[i].InheritsFrom(TWinControl) and
          TWinControl(sbForm.Controls[i]).CanFocus then begin
          TWinControl(sbForm.Controls[i]).SetFocus;
          GfaMain.BringToFront;
        end
    end;
  end;
end; {SelectEdit}

{Generovani odkazu pro priparvu pokynu}

procedure TfmDesignData.miGenOdkazyClick(Sender: TObject);
var
  sl:TStringList;
  ixName: string;
  key: integer;
begin
  sl:=TStringList.Create;
  try
    with SaveDialog do begin
      if Execute then with GfaMain,mtFields do begin
        sl.Add(cBegRtf1);
        sl.Add(cBegRtf2);
        ixName:=IndexName;
        IndexName:='';
        IndexFieldNames:='ContentKey;Name';
        First;
        key:=mtFieldsContentKey.Value;
        sl.Add('Stránka '+IntToStr(mtFieldsContentKey.Value)+'\par'+cCRLF);
        sl.Add('\par'+cCRLF);
        while not EOF do begin
          sl.Add('[_'+mtFieldsCaption.Value+'_]\par'+cCRLF);
          if key<>mtFieldsContentKey.Value then begin
            sl.Add('\par'+cCRLF);
            sl.Add('Stránka '+IntToStr(mtFieldsContentKey.Value)+'\par'+cCRLF);
            sl.Add('\par'+cCRLF);
            key:=mtFieldsContentKey.Value;
          end;
          Next;
        end;
        sl.Add('\par'+cCRLF);
        sl.Add('[_/_]\par'+cCRLF);
        sl.Add(cEndRtf);
        sl.SaveToFile(SaveDialog.FileName);
        IndexFieldNames:='';
        IndexName:=ixName;
      end;
    end;
  finally
    sl.Free;
  end;
end; {miGenOdkazyClick}

procedure TfmDesignData.FormActivate(Sender: TObject);
begin
  // cxGrid1DBTableView1.DataController.DataSource:=
  //  GfaMain.dsrcFields;
//  GfaMain.mtFields.Refresh;
end;

procedure TfmDesignData.dsinspDefChangePropValue(Sender: TObject;
  const PropEdit: TDCDsgnProperty; var newval: String);
begin
  GfaMain.SetChangeFlag(TRUE);
end;

procedure TfmDesignData.cxGrid1DBTableView1DblClick(Sender: TObject);
begin
  SelectEdit;
end;

procedure TfmDesignData.miSeznamUdajuClick(Sender: TObject);
var
  sl:TStringList;
  ixName: string;
  key: integer;
begin
  sl:=TStringList.Create;
  try
    with SaveDialog do begin
      if Execute then with GfaMain,mtFields do begin
        ixName:=IndexName;
        IndexName:='';
        IndexFieldNames:='ContentKey;Name';
        First;
        key:=mtFieldsContentKey.Value;
        while not EOF do begin
          if not mtFieldsHasCalc.Value then
            sl.Add(Format('%3d',[mtFieldsContentKey.Value])+','+mtFieldsCaption.Value);
          Next;
        end;
        sl.Sorted:=TRUE;
        sl.SaveToFile(SaveDialog.FileName);
        IndexFieldNames:='';
        IndexName:=ixName;
      end;
    end;
  finally
    sl.Free;
  end;
end;

end.


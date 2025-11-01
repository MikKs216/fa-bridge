{ 19.7.2025 23:47:22 (GMT+2:00) > [martin on VIRTUALFS] checked in uprava cesty pro STEREONX direktiva ve switches.inc  }
{ 15.7.2025 13:46:00 (GMT+2:00) > [martin on VIRTUALFS] checked in opravy cest STEREONX  }
{ 18. 4. 2023 13:52:16 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Doplnena funkce GetTskpsCount, ktera vraci pocet vytvorenych formularu ve Stereu  }
{ 13.9.2019 12:10:21 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 26.9.2012 15:54:39 (GMT+2:00) > [pinkava on PINKAVA-XP1] checked in Uprava v  MsgBox  }
{ 27.8.2007 15:59:16 (GMT+2:00) > [mipi on MP] checked in    }
{ 25.10.2006 10:27:25 (GMT+2:00) > [mik on PCMIK64] checked in   } 
{ 13.10.2005 8:57:21 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 7.9.2005 16:16:44 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:34:54 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
unit ESelectTskps;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RVStyle, RVScroll, RichView, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, ExtCtrls, cxDataStorage, ImgList,
  cxImageComboBox, kbmMemTable, kbmMemBinaryStreamFormat,
  cxLookAndFeelPainters, cxGridCustomPopupMenu, cxGridPopupMenu, Menus,
  cxGridBandedTableView, cxGridDBBandedTableView, cxButtons, Res_FA,
  cxLookAndFeels, cxNavigator;

function DoSelectTskps(out AIdDefs: string; const AOnlyDefsId: string = '';
  AMultiSelect: boolean = FALSE; ACaption: string = ''): string;
function GetTskpsCount(const AOnlyDefsId: string): Integer;

function GetFormFromTskps(ATskpKey: integer; var ASt: TMemoryStream): boolean;

type
  TfmSelectTskps = class(TForm)
    paHeader: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel4: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    gDBBandedTV: TcxGridDBBandedTableView;
    pmMain: TPopupMenu;
    pmItemCustomize: TMenuItem;
    cxGridPMain: TcxGridPopupMenu;
    laMultiSelInfo: TLabel;
    mtSelTskps: TkbmMemTable;
    mtSelTskpsKlic: TIntegerField;
    mtSelTskpsTskp: TIntegerField;
    mtSelTskpsUsrLock: TBooleanField;
    mtSelTskpsRokZdanovaciObdobi: TIntegerField;
    mtSelTskpsRokPodani: TIntegerField;
    mtSelTskpsSysPozn: TStringField;
    mtSelTskpsUsrPozn: TStringField;
    mtSelTskpsVyber: TBooleanField;
    mtSelTskpsBody: TMemoField;
    mtSelTskpsCaption: TStringField;
    mtFormat: TkbmBinaryStreamFormat;
    dsSelTskps: TDataSource;
    gDBBandedTVRokZdanovaciObdobi: TcxGridDBBandedColumn;
    gDBBandedTVRokPodani: TcxGridDBBandedColumn;
    gDBBandedTVSysPozn: TcxGridDBBandedColumn;
    gDBBandedTVUsrPozn: TcxGridDBBandedColumn;
    gDBBandedTVVyber: TcxGridDBBandedColumn;
    gDBBandedTVCaption: TcxGridDBBandedColumn;
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure gDBBandedTVKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gDBBandedTVDblClick(Sender: TObject);
    procedure pmItemCustomizeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMultiSelect: boolean;
    procedure GetSelected;
    procedure AddData2Grid(const AOnlyDefsId: string);
    procedure VyberCancel;
    procedure VyberOk;
    procedure SetRecord(const ANextRecord: boolean);
    function ZadanVyber: boolean;
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
  public
    { Public declarations }
    FIDTskps: string;
    FIdDefs: string;
    procedure Init(AMultiSelect: boolean = FALSE; ACaption: string = '';
      const AOnlyDefsId: string = '');
  end;

var
  fmSelectTskps: TfmSelectTskps;

implementation

uses
  cxDataUtils, FCommonUtils, JclStrings, IniFiles,
  SpolFunkce, DateUtils, DbUtils, Main, FUtils;

{$R *.dfm}

const
  cTskpsTableFileName = 'Tskps.mtd';

//Otevre dialog pro vyber formulare z tabulky Tskps.mtd
//  (memory table v binarnim formatu) v rezimu podle AMultiSelect.
//  Vraci ID formularu prevedene na retezec. Pri vicenasobnem vyberu oddelene
//  carkami. True pokud uzivatel neco vybral jinak false.
//
function DoSelectTskps(out AIdDefs: string; const AOnlyDefsId: string = '';
  AMultiSelect: boolean = FALSE; ACaption: string = ''): string;
begin
  Result:='';
  AIdDefs:='';
  with TfmSelectTskps.Create(nil) do
  try
    Init(AMultiSelect, ACaption, AOnlyDefsId);
    if ACaption<>'' then
      Caption := ACaption;
    if ShowModal = mrOK then begin
      Result := FIDTskps;
      AIdDefs := FIDDefs;
    end;
  finally
    Free;
  end;
end; {DoSelectTskps}

//#5211
//Vraci pocet formularu z tabulky Tskps.mtd
// odpovidajici zadanemu ID definice
//Pozn.: nezohlednuje sebe sameho, tzn. v celkovem souctu je i formular,
//       ze ktereho se funkce vola (pokud je formular ulozen)
function GetTskpsCount(const AOnlyDefsId: string): Integer;
var
  fileName: string;
  sl: TStringList;
  i, c: integer;
begin
  with TfmSelectTskps.Create(nil) do begin
    sl:= TStringList.Create;
    Result:=0;
    mtSelTskps.Active;
    mtSelTskps.DisableControls;
    try
      mtSelTskps.EmptyTable;

      {$IFNDEF STEREONX}
        fileName:=NormalPath(ExtractFilePath(Application.ExeName))+cTskpsTableFileName;
      {$ELSE}
        //#MR 2025
        fileName:=NormalPath(SpolFunkce.gFUserDataPath)+cTskpsTableFileName;
      {$ENDIF}
      if FileExists(fileName) then begin
        try
          mtSelTskps.LoadFromFile(fileName);
        except
        end;
        c := 0;
        mtSelTskps.First;
        while not mtSelTskps.EOF do begin
          sl.Text:=mtSelTskpsBody.Value;
          for i:=0 to CountListItems(AOnlyDefsId)-1 do begin
            if (sl.Values['DefID']=GetListItem(AOnlyDefsId,i)) or
              (TranslateDKId(IntToStr(mtSelTskpsTskp.Value))=
              GetListItem(AOnlyDefsId,i)) then begin
              Inc(c);
              BREAK;
            end;
          end;
          mtSelTskps.Next;
        end;
        Result := c;
      end;
    finally
      mtSelTskps.EnableControls;
      sl.Free;
      Free;
    end;
  end;
end;

//Vraci data formulare s klicem (ve formatu FA) z tabulky Tskps.mtd
//  (memory table v binarnim formatu)
//
function GetFormFromTskps(ATskpKey: integer; var ASt: TMemoryStream): boolean;
var
  fileName: string;
  sl: TStringList;
begin
  with TfmSelectTskps.Create(nil) do begin
    sl:= TStringList.Create;
    try
      Result:=FALSE;
      mtSelTskps.Active;
      mtSelTskps.DisableControls;
      mtSelTskps.EmptyTable;
      {$IFNDEF  STEREONX}
        fileName:=NormalPath(ExtractFilePath(Application.ExeName))+ cTskpsTableFileName;
      {$ELSE}
        //#MR 2025
        fileName:=NormalPath(SpolFunkce.gFUserDataPath) + cTskpsTableFileName;
      {$ENDIF}

      if FileExists(fileName) then begin
        try
          mtSelTskps.LoadFromFile(fileName);
        except
        end;
        if mtSelTskps.Locate(mtSelTskpsKlic.FieldName,ATskpKey,[]) then begin
          sl.Text:=mtSelTskpsBody.Value;
          if (sl.Count>0) and (sl[0]<>cFormHeadLabel) then
            sl.Text:=ConvertTskpDKToFA(IntToStr(mtSelTskpsTskp.Value),sl.Text);
          sl.SaveToStream(Ast);
          Result:=TRUE;
        end;
      end;
      mtSelTskps.EnableControls;
    finally
      sl.Free;
      Free;
    end;
  end;
end; {GetFormFromTskps}

procedure TfmSelectTskps.AddData2Grid(const AOnlyDefsId: string);
var
  i: integer;
  fileName: string;
  sl: TStringList;
  ok: boolean;
begin
  mtSelTskps.Active;
  mtSelTskps.DisableControls;
  sl:= TStringList.Create;
  try
    mtSelTskps.EmptyTable;
    fileName:=NormalPath(ExtractFilePath(Application.ExeName))+
      cTskpsTableFileName;
    if FileExists(fileName) then begin
      mtSelTskps.LoadFromFile(NormalPath(ExtractFilePath(Application.ExeName))+
        cTskpsTableFileName);
      mtSelTskps.First;
      while not mtSelTskps.EOF do begin
        sl.Text:=mtSelTskpsBody.Value;
        ok:=FALSE;
        for i:=0 to CountListItems(AOnlyDefsId)-1 do begin
          if (sl.Values['DefID']=GetListItem(AOnlyDefsId,i)) or
            (TranslateDKId(IntToStr(mtSelTskpsTskp.Value))=
            GetListItem(AOnlyDefsId,i)) then begin
            {(mtSelTskpsTskp.Value=
            TranslateDefID(GetListItem(AOnlyDefsId,i))) then begin}
            ok:=TRUE;
            BREAK;
          end;
        end;
        if ok then begin
          mtSelTskps.Edit;
          mtSelTskpsVyber.Value:=FALSE;
          mtSelTskps.Post;
          mtSelTskps.Next;
        end
        else
          mtSelTskps.Delete;
      end;
    end
    else
      MessageWarn(Caption, sMsgNeexistujeTabulkaTskps, [MBOK]);
  finally
    mtSelTskps.EnableControls;
    sl.Free;
  end;
  gDBBandedTV.DataController.Groups.FullExpand;
end;

procedure TfmSelectTskps.Init(AMultiSelect: boolean = FALSE; ACaption: string = '';
  const AOnlyDefsId: string = '');
begin
  StartWait;
  AddData2Grid(AOnlyDefsId);
  StopWait;

  FMultiSelect := AMultiSelect;

  laMultiSelInfo.Visible := AMultiSelect;
  gDBBandedTVVyber.Visible := AMultiSelect;

  if AMultiSelect then
    paHeader.Caption := '  '+sSelectTskps+':'
  else
    paHeader.Caption := '  '+sSelectTskp+':';
end;


procedure TfmSelectTskps.VyberCancel;
begin
  inherited;
  FIDTskps := '';
  FIDDefs := '';
  Close;
  Self.ModalResult := mrCancel;
end;

procedure TfmSelectTskps.btnCancelClick(Sender: TObject);
begin
  inherited;
  VyberCancel;
end;

procedure TfmSelectTskps.FormDestroy(Sender: TObject);
begin
  inherited;
  fmSelectTskps := nil;
end;

procedure TfmSelectTskps.FormCreate(Sender: TObject);
begin
  inherited;
  FIDTskps := '';
  FIDDefs := '';
end;

//GetSelected
procedure TfmSelectTskps.GetSelected;
var
  def: string;
begin
  FIDTskps := '';
  FIDDefs := '';

  if mtSelTskps.State = dsEdit then
    mtSelTskps.Post;
  if FMultiSelect then begin
    mtSelTskps.First;
    while not mtSelTskps.EOF do begin
      if mtSelTskpsVyber.Value=true then begin
        if FIDTskps='' then
          FIDTskps := mtSelTskpsKlic.AsString
        else
          FIDTskps := FIDTskps + #13#10 + mtSelTskpsKlic.AsString;
        def:=TranslateDKId(mtSelTskpsTskp.AsString);
        if def='' then
          def:=GetStringLineValue(mtSelTskpsBody.Value,'DefID');
        if FIDDefs='' then
          FIDDefs := def
        else
          FIDDefs := FIDDefs + #13#10 +def;
      end;
      mtSelTskps.Next;
    end;
  end
  else begin
    FIDTskps := mtSelTskpsKlic.AsString;
    def:=TranslateDKId(mtSelTskpsTskp.AsString);
    if def='' then
      def:=GetStringLineValue(mtSelTskpsBody.Value,'DefID');
    FIDDefs := def;
  end;
end;{GetSelected}

function TfmSelectTskps.ZadanVyber: boolean;
var
  id: integer;
begin
  Result := FALSE;
  id := mtSelTskpsKlic.Value;
  with mtSelTskps do begin
    DisableControls;
    First;
    while not EOF do begin
      if mtSelTskpsVyber.Value then begin
        Result := TRUE;
        Exit;
      end;
      Next;
    end;
    EnableControls;
    mtSelTskps.Locate(mtSelTskpsKlic.FieldName, id,[]);
  end;
end;

procedure TfmSelectTskps.VyberOk;
begin
  if FMultiselect and not ZadanVyber then begin
    if (MessageAsk(Caption, SRDataFormsNoChoice,
      [MBYES, MBNO], MBNO) = mrYes) then begin
      GetSelected;
      Close;
      Self.ModalResult := mrOK;
    end
    else
      Self.ModalResult := mrNone;
  end
  else begin
    GetSelected;
    Close;
    Self.ModalResult := mrOK;
  end;
end;

procedure TfmSelectTskps.btnOKClick(Sender: TObject);
begin
  inherited;
  VyberOk;
end;

procedure TfmSelectTskps.gDBBandedTVKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Shift=[]) then begin
    if (Key=Vk_Escape) then
      VyberCancel
    else if (Key=Vk_F8) then
      SetRecord(true)
    else if (Key=VK_SPACE) then
      SetRecord(false);
    {else if (Key=Vk_Return) then
      VyberOk}
  end;

end;

procedure TfmSelectTskps.SetRecord(const ANextRecord: boolean);
var
  cch: boolean;
begin
  mtSelTskps.Edit;
  mtSelTskpsVyber.Value := not mtSelTskpsVyber.Value;
  mtSelTskps.Post;
  if ANextRecord then
    gDBBandedTV.Controller.FocusNextRecord(
      gDBBandedTV.Controller.FocusedRecordIndex, true, cch, true, true);
    //mtSelTskps.Next;
end;

procedure TfmSelectTskps.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift=[]) and (Key=Vk_Escape) then begin
    VyberCancel;
  end;
end;

procedure TfmSelectTskps.gDBBandedTVDblClick(Sender: TObject);
begin
  inherited;
  if FMultiSelect then
    SetRecord(false)
  else
    VyberOk;
end;

procedure TfmSelectTskps.pmItemCustomizeClick(Sender: TObject);
begin
  inherited;
  if cxGrid1Level1.GridView is TcxGridDBBandedTableView then
    TcxGridDBBandedTableView(cxGrid1Level1.GridView).Controller.Customization:=True;
end;

procedure TfmSelectTskps.FormShow(Sender: TObject);
begin
  inherited;
  LoadFormStateFromIni;
  mtSelTskps.Last;//(mtDataFormsPeriodYear.FieldName, YearOf(now)+1,[]);
end;

procedure TfmSelectTskps.SaveFormStateToIni;
var iniFile: TMemIniFile;
begin
  if not GfaMain.CanWriteToIniFile then EXIT;
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    iniFile.WriteInteger(Name, 'Left', Left);
    iniFile.WriteInteger(Name, 'Top', Top);
    iniFile.WriteInteger(Name, 'Width', Width);
    iniFile.WriteInteger(Name, 'Height', Height);
    SaveMemIni(iniFile);
  finally
    iniFile.Free;
  end;
end;

procedure TfmSelectTskps.LoadFormStateFromIni;
var iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    Left := iniFile.ReadInteger(Name, 'Left', GfaMain.Left + 5);
    Top := iniFile.ReadInteger(Name, 'Top', GfaMain.Top + 30);
    Width := iniFile.ReadInteger(Name, 'Width', 412);
    Height := iniFile.ReadInteger(Name, 'Height', 300);
  finally
    iniFile.Free;
  end;
end;

procedure TfmSelectTskps.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormStateToIni;
end;

end.

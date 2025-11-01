{ 13.9.2019 12:10:17 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 12.5.2017 9:25:17 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Zmena v InitRecNo  }
{ 20.4.2017 10:07:36 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in 2191 - doplnena udalost grSelAttchTVCellClick  }
{ 20.4.2017 10:06:52 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in 2191 - doplnena udalost grSelAttchTVCellClick  }
{ 14.3.2017 10:11:25 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 2130 - zmena v InitRecNo  }
{ 8.11.2016 13:26:17 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 1617 - nove IsBtnInsEnb  }
{ 24.10.2016 13:39:47 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in 1617 - prace na zneviditelneni tlacitek  }
{ 27.9.2016 12:50:47 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in 1631 - nove InitBtns  }
{ 27.9.2016 10:18:23 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Synchronizace  }
{ 22.9.2016 9:59:57 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in 1617 - nove btnIns }
{ 20.9.2016 10:35:46 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Zruseno poradi a doplneno Id - string  }
{ 19.9.2016 14:41:52 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Zmena v ChoiceFrm  }
{ 19.9.2016 14:14:08 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Presun TfmSelAttach z Adres do FA  }
{ 19.9.2016 10:04:21 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Doplneni mtDataFileDefaultEx a Filter  }
{ 14.9.2016 13:54:54 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in Unit pro vyber priloh formularu  }
{ 16.10.2009 15:46:40 (GMT+2:00) > [mipi on MP-PC] checked in Zmena struktury v qData  }
{ 4.8.2008 16:06:19 (GMT+2:00) > [mipi on MP-PC] checked in    }
{$I Switches.inc}
unit EfmSelAttach;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,  
  Dialogs, Menus, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxClasses, cxControls,
  cxGridCustomView, cxGrid, StdCtrls, cxButtons, ExtCtrls, nxdb,
  cxLookAndFeels, cxNavigator, kbmMemTable;

type
  TfmSelAttach = class(TForm)
    Panel2: TPanel;
    Panel4: TPanel;
    btnCancel: TcxButton;
    grSelAttch: TcxGrid;
    grSelAttchTV: TcxGridDBBandedTableView;
    grSelAttchLevel1: TcxGridLevel;
    dsData: TDataSource;
    mtData: TkbmMemTable;
    mtDataPriloha: TStringField;
    mtDataTyp: TStringField;
    mtDataPovolen: TBooleanField;
    grSelAttchTVPriloha: TcxGridDBBandedColumn;
    grSelAttchTVPovolen: TcxGridDBBandedColumn;
    grSelAttchTVTyp: TcxGridDBBandedColumn;
    paDoc: TPanel;
    btnDoc: TcxButton;
    paFile: TPanel;
    btnFile: TcxButton;
    paFrm: TPanel;
    btnFrm: TcxButton;
    mtDataMultiselect: TBooleanField;
    grSelAttchTVMultiselect: TcxGridDBBandedColumn;
    mtDataDefsId: TStringField;
    mtDataFileDefaultEx: TStringField;
    mtDataFileFilter: TStringField;
    mtDataId: TStringField;
    paIns: TPanel;
    btnIns: TcxButton;
    procedure btnCancelClick(Sender: TObject);
    procedure grSelAttchTVKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grSelAttchTVFocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure grSelAttchTVCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure btnFrmClick(Sender: TObject);
    procedure btnFileClick(Sender: TObject);
    procedure btnDocClick(Sender: TObject);
    procedure btnInsClick(Sender: TObject);
    procedure grSelAttchTVSelectionChanged(Sender: TcxCustomGridTableView);
    procedure grSelAttchTVCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    FpaDocVisible: boolean;
    FpaFrmVisible: boolean;
    FpaFileVisible: boolean;
    FpaInsVisible: boolean;

    procedure VyberCancel;
    procedure VyberOk;
    procedure InitCtrls;
    procedure LoadData(const AData: string);
    procedure InitRecNo;
    procedure SaveRecNo;
    procedure ChoiceFile;
    procedure ChoiceDoc;
    procedure ChoiceFrm;
    function GetIniFileName: string;
    procedure InitDisabled;
    procedure InitBtns;
    function IsFoundType(const AType: string): boolean;
    function IsBtnInsEnb: Boolean;
    { Private declarations }
  public
    { Public declarations }
    FIdOut: string; //
    FTypeOut: string; //vrace typ dat
    FDataOut: string;

    FClientID: integer;

    procedure Init(
      const AClientID: integer;
      const AData: string);
  end;

var
  fmSelAttach: TfmSelAttach;

implementation

uses
  IniFiles, FCommonUtils, FScriptUtils, Main, SpolFunkce, Res_FA;

const
  coTypeDoc = 'D';
  coTypeFile = 'S';
  coTypeFrm = 'F';
  coTypeIns = 'I';

{$R *.dfm}

procedure TfmSelAttach.btnCancelClick(Sender: TObject);
begin
  inherited;
  VyberCancel;
end;

procedure TfmSelAttach.LoadData(
  const AData: string);
var
  sl: TStringList;
  ms: TMemoryStream;
begin
  sl := TStringList.Create;
  ms := TMemoryStream.Create;
  try
    sl.Text := AData;
    sl.SaveToStream(ms);
    ms.Seek(0, soFromBeginning);
    mtData.Open;
    mtData.LoadFromStream(ms);
  finally
    ms.Free;
    sl.Free;
  end;
end;
                                                                          
function TfmSelAttach.GetIniFileName: string;
begin
{$IFDEF STANDALONE}
  Result := GfaMain.GetIniFileName; 
{$ELSE STANDALONE}
  Result := SpolFunkce.GetLocalIniFileName;
{$ENDIF STANDALONE}
end;

procedure TfmSelAttach.InitRecNo;
var
  ini: TMemIniFile;
  //id: string;
  l, t: Integer;
begin
  ini := TMemIniFile.Create(GetIniFileName);
  try
    mtData.First;
    if mtData.RecordCount=1 then                         
      Self.ActiveControl := grSelAttch
    else
      grSelAttchTV.DataController.FocusedRowIndex := -1;

    { namet 2130 - nebudeme si pamatovat
    id := ini.ReadString(Self.Name+'_'+mtDataId.FieldName, 'recno', '');
    if id<>'' then begin
      mtData.Locate(mtDataId.FieldName, id, []);
      Self.ActiveControl := grSelAttch;
    end;}

    if GfaMain<>nil then begin
      l:=ini.ReadInteger(Name, 'Left', GfaMain.Left+5);
      t:=ini.ReadInteger(Name, 'Top', GfaMain.Top+30);
    end
    else begin
      l:=ini.ReadInteger(Name, 'Left', 0);
      t:=ini.ReadInteger(Name, 'Top', 0);
    end;

    Width:=ini.ReadInteger(Name, 'Width', 952);
    Height:=ini.ReadInteger(Name, 'Height', 532);

    CheckFormPosition(l,t,Width);
    Left:=l;
    Top:=t;
  finally
    ini.Free;
  end;
end;

procedure TfmSelAttach.Init(
  const AClientID: integer;
  const AData: string);
begin
  FIdOut := '';
  FTypeOut := '';
  FDataOut := '';


  FClientId := AClientID;
  LoadData(AData);
  InitDisabled;
  //InitBtns;

  FpaDocVisible := IsFoundType(coTypeDoc);
  FpaFrmVisible := IsFoundType(coTypeFrm);
  FpaFileVisible := IsFoundType(coTypeFile);
  FpaInsVisible := IsFoundType(coTypeIns);
  
  InitCtrls;
  //LoadGridForView(grSelAttch.ActiveView);
  InitRecno;
end;


function TfmSelAttach.IsFoundType(const AType: string): boolean;
begin
  Result := false;

  mtData.First;
  while not mtData.EOF do begin
    if Pos(AType, mtDataTyp.AsString)>0 then begin
      Result := true;
      mtData.Last;
    end;
    mtData.Next;
  end;
end;

procedure TfmSelAttach.InitBtns;
var
  enb: Boolean;
begin
  enb := IsBtnInsEnb;
  paDoc.Visible := FpaDocVisible and (enb=False);
  paFrm.Visible := FpaFrmVisible and (enb=False);
  paFile.Visible := FpaFileVisible and (enb=False);
  paIns.Visible := FpaInsVisible and (enb=true);
end;

procedure TfmSelAttach.InitDisabled;
begin
  mtData.First;
  while not mtData.EOF do begin
    if mtDataPovolen.AsBoolean=false then begin
      mtData.Edit;
      mtDataPriloha.AsString := mtDataPriloha.AsString + ' '+sMsgAttchDisabled;
      mtData.Post;
    end;

    mtData.Next;
  end;
end;

function TfmSelAttach.IsBtnInsEnb:Boolean;
begin
  Result := (Pos(coTypeIns, UpperCase(mtDataTyp.AsString))>0)
end;

procedure TfmSelAttach.InitCtrls;
var
  btns: string;
  enbl: Boolean;
begin
  enbl := mtDataPovolen.AsBoolean and grSelAttch.IsFocused;
  btns := UpperCase(mtDataTyp.AsString);

  btnFrm.Enabled := enbl and (Pos(coTypeFrm, btns)>0);
  btnFile.Enabled := enbl and (Pos(coTypeFile, btns)>0);
  btnDoc.Enabled := enbl and (Pos(coTypeDoc, btns)>0);
  btnIns.Enabled := enbl and IsBtnInsEnb;

  InitBtns;
  {$IFDEF STANDALONE}
  paDoc.Visible := false;
  {$ENDIF STANDALONE}
end;

procedure TfmSelAttach.VyberOk;
begin
  Close;
  Self.ModalResult := mrOK;
end;

procedure TfmSelAttach.VyberCancel;
begin
  inherited;
  Close;
  Self.ModalResult := mrCancel;
end;

procedure TfmSelAttach.grSelAttchTVCellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  InitCtrls;
end;

procedure TfmSelAttach.grSelAttchTVCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  povolen: variant;
  bStrPism: string;
begin
  inherited;
  if (AViewInfo.Selected=false) then begin
    povolen := AViewInfo.GridRecord.Values[grSelAttchTVPovolen.Index];
    if not VarIsNull(povolen) then begin
      if VarToStr(povolen) = 'False' then
        ACanvas.Canvas.Font.Color:=clGrayText;
    end;
  end;
end;

procedure TfmSelAttach.grSelAttchTVFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  inherited;
  InitCtrls;
end;

procedure TfmSelAttach.grSelAttchTVKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift=[]) then begin
    if (Key=Vk_Escape) then
      VyberCancel;
  end;
end;

procedure TfmSelAttach.grSelAttchTVSelectionChanged(
  Sender: TcxCustomGridTableView);
begin
//
end;

procedure TfmSelAttach.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift=[]) and (Key=Vk_Escape) then begin
    VyberCancel;
  end;
end;

procedure TfmSelAttach.SaveRecNo;
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName);
  try
    ini.WriteString(Self.Name+'_'+mtDataId.FieldName, 'recno', mtDataId.AsString);

    ini.WriteInteger(Name, 'Left', Left);
    ini.WriteInteger(Name, 'Top', Top);
    ini.WriteInteger(Name, 'Width', Width);
    ini.WriteInteger(Name, 'Height', Height);

    SaveMemIni(ini);
  finally
    ini.Free;
  end;
end;

procedure TfmSelAttach.btnDocClick(Sender: TObject);
begin
  inherited;
  ChoiceDoc;
end;

procedure TfmSelAttach.ChoiceFile;
begin
  with TOpenDialog.Create(nil) do begin
    if mtDataFileDefaultEx.AsString<>'' then
      DefaultExt := mtDataFileDefaultEx.AsString
    else
      DefaultExt := '*.*';
 
    if mtDataFileFilter.AsString<>'' then
      Filter := mtDataFileFilter.AsString
    else
      Filter := SRMDlgAllFil+' (*.*)|*.*';

    FileName := '';
    Options := [ofHideReadOnly, ofEnableSizing, ofAllowMultiSelect, ofFileMustExist];
    if mtDataMultiselect.AsBoolean then
      Options := Options+[ofAllowMultiSelect]
    else
      Options := Options-[ofAllowMultiSelect];


    if Execute then begin
      FIdOut := mtDataId.AsString;
      FTypeOut := coTypeFile;
      FDataOut := Files.Text;
    end;
  end;
end;

procedure TfmSelAttach.btnFileClick(Sender: TObject);
begin
  inherited;
  ChoiceFile;
end;

{procedure TfmSelAttach.ChoiceDoc;
var
  ds, docId: string;
begin
  docId := '';
  if DoVyberDataDlgFDF(
      FClientID,
      ds, ds, ds, docId, ds,
      mtDataMultiselect.AsBoolean,
      mtDataPriloha.AsString,
      '', -1, false, true, false,
      false) then begin
    FIdOut := mtDataPoradi.AsInteger;
    FTypeOut := coTypeDoc;
    FDataOut := docId;
  end;
end;
}
procedure TfmSelAttach.ChoiceDoc;
var
  ds: string;
begin
  GfaMain.FfodFrmID := '';
  GfaMain.FfodGUID := '';
  GfaMain.FfodFrmDefID := '';
  GfaMain.FfodDocId := '';
  GfaMain.FfodFiles := '';

  if GetFormsOrDocuments(
      mtDataMultiselect.AsBoolean,
      mtDataPriloha.AsString,
      '',
      false, true, false,
      false) then begin
    FIdOut := mtDataId.AsString;
    FTypeOut := coTypeDoc;
    FDataOut := GfaMain.FfodDocId;
  end;
end;

procedure TfmSelAttach.ChoiceFrm;  
var
  ds, defsId: string;
begin
  defsId := mtDataDefsId.AsString;

  GfaMain.FfodFrmID := '';
  GfaMain.FfodGUID := '';
  GfaMain.FfodFrmDefID := defsId;
  GfaMain.FfodDocId := '';
  GfaMain.FfodFiles := '';
  if GetFormsOrDocuments(
      mtDataMultiselect.AsBoolean,
      mtDataPriloha.AsString,
      defsId, true, false, false,
      false) then begin
    FIdOut := mtDataId.AsString;
    FTypeOut := coTypeFrm;
{$IFDEF STANDALONE}
    FDataOut := GfaMain.FfodFrmID;
{$ELSE STANDALONE}
    FDataOut := GfaMain.FfodGUID;
{$ENDIF STANDALONE}
  end;
end;

procedure TfmSelAttach.btnFrmClick(Sender: TObject);
begin
  inherited;
  ChoiceFrm;
end;

procedure TfmSelAttach.btnInsClick(Sender: TObject);
begin
  FIdOut := mtDataId.AsString;
  FTypeOut := coTypeIns;
end;

procedure TfmSelAttach.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveRecNo;
end;

end.

{ 13.9.2019 12:10:22 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 27.1.2016 15:14:25 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Upraven caption sloupce poznamka pro slovenskou lokalizaci  }
{ 19.1.2016 13:46:50 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Oprava sloupcu  }
{ 16.10.2012 13:22:10 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 13.10.2008 10:48:45 (GMT+2:00) > [mik] checked in Opravena chyba zapisu do forms.ini  }
{ 25.10.2006 10:27:27 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 6.10.2006 11:22:13 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 26.10.2005 9:08:11 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 25.10.2005 14:33:47 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 17.10.2005 11:50:49 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 13.10.2005 14:57:43 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 13.10.2005 14:03:25 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 2.9.2005 15:57:15 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 10:12:12 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:44:30 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 7.10.2004 18:59:50 (GMT+2:00) > [mipi on PCPINKAVA] checked in    }
unit EStoredStrings;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxEdit,
  DB, cxDBData, cxGridLevel, cxGridBandedTableView,
  cxGridDBBandedTableView, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  kbmMemTable, Grids, DBGrids, cxDataStorage, ExtCtrls, Menus,
  cxLookAndFeelPainters, StdCtrls, cxButtons, Res_FA, cxLookAndFeels,
  dxSkinsCore, dxSkinCaramel, dxSkinFoggy, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinscxPCPainter, cxNavigator;

function OpenStrings(const AFieldName, AValue: string; const ACaption: string = '';
  ALeft: Integer = 0; ATop: Integer = 0): variant;

type
  TfmStoredStrings = class(TForm)
    dsStrings: TDataSource;
    grStrings: TcxGrid;
    grStringsBandedView: TcxGridDBBandedTableView;
    grStringsBandedViewDBBandedColumn1: TcxGridDBBandedColumn;
    grStringsLevel: TcxGridLevel;
    grStringsBandedViewDBBandedColumn2: TcxGridDBBandedColumn;
    Panel2: TPanel;
    Panel4: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    grStringsBandedViewPoznamka: TcxGridDBBandedColumn;
    grStringsBandedViewZkratka: TcxGridDBBandedColumn;
    btNovy: TcxButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure grStringsBandedViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grStringsBandedViewDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure btNovyClick(Sender: TObject);
  private
    FInsertState: Boolean;
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    function KbdStandard(AGrid: TcxGrid; var Key: Word;
      Shift: TShiftState): boolean;
  public
    FResultColumnIndex: integer;
    FResultValue: variant;
  end;

var
  fmStoredStrings: TfmStoredStrings;

implementation

{$R *.dfm}

uses
  Main, IniFiles,
  SpolFunkce,
  {$IFNDEF STANDALONE}
  DatamodGlobObj,
  {$ENDIF STANDALONE}
  FCommonUtils;

function OpenStrings(const AFieldName, AValue: string; const ACaption: string = '';
  ALeft: Integer = 0; ATop: Integer = 0): variant;
begin
  fmStoredStrings:=TfmStoredStrings.Create(nil);
  GFaMain.mtStoredStrings.Filter:='('+
    GFaMain.mtStoredStringsFieldName.FieldName+
    '='''+AFieldName+''')or('+GFaMain.mtStoredStringsForAllFields.FieldName+')';
  GFaMain.mtStoredStrings.Filtered:=TRUE;
  GFaMain.FStoredStringsFieldName:=AFieldName;
  try
    with fmStoredStrings do begin
      FResultValue:=null;
      GFaMain.mtStoredStrings.Locate(
        GFaMain.mtStoredStringsText.FieldName,AValue,[loPartialKey]);
      if ACaption<>'' then
        Caption:=ACaption;
      GFaMain.mtStoredStrings.ReadOnly:=GFaMain.mtValues.ReadOnly;
      dsStrings.DataSet:=GFaMain.mtStoredStrings;
      Left:=ALeft;
      Top:=ATop;
      ShowModal;
      GFaMain.mtStoredStrings.ReadOnly:=FALSE;
      Result := FResultValue;
    end;
  finally
    GFaMain.mtStoredStrings.Filtered:=FALSE;
    GFaMain.FStoredStringsFieldName:='';
    fmStoredStrings.Free;
    fmStoredStrings:=nil;
  end;
end; {OpenStrings}

procedure TfmStoredStrings.FormShow(Sender: TObject);
begin
  GFaMain.mtStoredStrings.Refresh;
end;

procedure TfmStoredStrings.LoadFormStateFromIni;
var
  iniFile: TMemIniFile;
  l,t: Integer;
begin
  grStringsBandedView.RestoreFromIniFile(GfaMain.GetIniFileName, TRUE, FALSE,
    [gsoUseFilter]);
  //
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    if Left=0 then
      Left:=iniFile.ReadInteger(Name, 'Left', 0);
    if Top=0 then
      Top:=iniFile.ReadInteger(Name, 'Top', 0);
    Width:=iniFile.ReadInteger(Name, 'Width', 623);
    Height:=iniFile.ReadInteger(Name, 'Height', 260);
    l:=Left; t:=Top;
    CheckFormPosition(l,t,Width);
    Left:=l; Top:=t;
  finally
    iniFile.Free;
  end;
end;

procedure TfmStoredStrings.SaveFormStateToIni;
var
  iniFile: TMemIniFile;
begin
  if not GfaMain.CanWriteToIniFile then EXIT;
  grStringsBandedView.StoreToIniFile(GfaMain.GetIniFileName, FALSE,
    [gsoUseFilter]);
  //
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

procedure TfmStoredStrings.FormCreate(Sender: TObject);
begin
  FInsertState:=false;
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
  LoadFormStateFromIni;
end;

procedure TfmStoredStrings.btNovyClick(Sender: TObject);
begin
  FInsertState:=true;
  GFaMain.mtStoredStrings.Append;
  GfaMain.mtStoredStringsForAllFields.Value := TRUE;
  grStrings.SetFocus;
end;

procedure TfmStoredStrings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FInsertState:=False;
  SaveFormStateToIni;
end;

procedure TfmStoredStrings.FormResize(Sender: TObject);
begin
  //spatne pocitalo - zruseno
  {grStringsBandedViewDBBandedColumn1.Width:=grStrings.Width-
    grStringsBandedView.OptionsView.IndicatorWidth-
    grStringsBandedViewDBBandedColumn2.Width-
    grStringsBandedViewPoznamka.Width;}
end;

function TfmStoredStrings.KbdStandard(AGrid: TcxGrid; var Key: Word;
  Shift: TShiftState): boolean;

  procedure SaveRec;
  begin
    if (dceEdit in AGrid.ActiveView.DataController.EditState)  or
       (dceInsert in AGrid.ActiveView.DataController.EditState) then begin
      AGrid.ActiveView.ViewData.DataController.Post;
      Key:=0;
      Result:=TRUE;
      FInsertState:=False;
    end;
  end;

  function KeyDelete(AGrid: TcxGrid; var Key: Word): boolean;
  begin
    if MRYES=MessageAsk(Caption, RSDeleteRecord, [MBYES,MBNO],MBNO) then
       AGrid.ActiveView.ViewData.DataController.DeleteFocused;
    Key:=0;
    Result:=TRUE;
  end;{KeyDelete}

  function KeyInsert(AGrid: TcxGrid; var Key: Word): boolean;
  begin
    AGrid.ActiveView.ViewData.DataController.Insert;
    Key:=0;
    Result:=TRUE;
  end;{KeyInsert}

begin
  Result:=FALSE;
  if Assigned(AGrid) then begin //Pokud je grid tak reaguj jinak nic nedelej
    if (Shift=[]) and (Key=VK_Insert) then begin
     if  AGrid.ActiveView.Site.Focused then
        Key:=VK_F2;
    end
    else if (Shift=[]) and (Key=VK_Delete) then begin
      if not TcxCustomGridTableController(AGrid.ActiveView.Controller).IsEditing then begin
        Key:=0;
        Result:=TRUE;
      end;
    end
    else if (Shift=[]) and (Key=VK_F9) then begin
      SaveRec;
    end
    else if (Shift=[ssCtrl]) then begin
      if Key=VK_Insert then begin
        Result:=KeyInsert(AGrid,Key);
      end
      else if Key=VK_Delete then begin
        Result:=KeyDelete(AGrid,Key);
      end
      else if Key=VK_Return then begin
        SaveRec;
      end;
    end
    else if (Shift=[]) and (Key=VK_Return) then begin
      if not FInsertState and TcxCustomGridTableController(AGrid.ActiveView.Controller).IsEditing then
        SaveRec;
    end;    
  end;
end;{KbdStandard}

procedure TfmStoredStrings.grStringsBandedViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not KbdStandard(grStrings,Key,Shift) then
    inherited;
end;

//nefunguje dblclick
procedure TfmStoredStrings.grStringsBandedViewDblClick(Sender: TObject);
begin
  if GFaMain.mtStoredStrings.State in [dsEdit,dsInsert] then
    GFaMain.mtStoredStrings.Post;
  FResultValue:=GFaMain.mtStoredStringsText.Value;
  Close;
end;

procedure TfmStoredStrings.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not (GFaMain.mtStoredStrings.State in [dsEdit,dsInsert]) then begin
    if Key=#13 then begin
      FResultValue:=GFaMain.mtStoredStringsText.Value;
      Key:=#0;
      Close;
    end
    else if Key=#27 then begin
      Key:=#0;
      Close;
    end;
  end;
end;

procedure TfmStoredStrings.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$IFNDEF STANDALONE}
  if Key=VK_F1 then
    Application.HelpSystem.ShowTopicHelp(Name,GetDataPrgPath+'FormStudio.chm')
  else  
  {$ENDIF STANDALONE}
  if not KbdStandard(grStrings,Key,Shift) then
    inherited;
end;



procedure TfmStoredStrings.btnOKClick(Sender: TObject);
begin
  FResultValue:=GFaMain.mtStoredStringsText.Value;
end;

end.

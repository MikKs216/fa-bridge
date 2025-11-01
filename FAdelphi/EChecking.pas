{ 12.10.2025 13:53:11 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Uprava LogStat  }
{ 11.10.2025 16:47:15 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Logovani statistik  }
{ 13.9.2019 12:10:17 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 7.4.2017 11:02:12 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Oprava #2038 viditelnost tlacitek na velkych fontech  }
{ 18.2.2016 14:22:49 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Odstraneno nemodalni zobrazovani  }
{ 19.9.2014 11:10:31 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Upraveny ikony  }
{ 16.10.2012 10:59:39 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 26.10.2006 10:47:41 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 10:27:19 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 11.8.2006 14:39:49 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 17.10.2005 11:45:55 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 13.10.2005 14:57:45 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 13.10.2005 13:57:43 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 7.9.2005 16:16:42 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 2.9.2005 15:57:05 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:52:05 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 25.10.2003 16:26:22 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 8.10.2003 22:32:12 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 9.9.2003 23:39:41 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 4.9.2003 0:46:13 (GMT+2:00) > [mik on PCMIKHOME] checked in   }

{ 22.8.2003 13:34:22 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 13:29:32 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
unit EChecking;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RVStyle, RVScroll, RichView, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, ExtCtrls, cxDataStorage, ImgList,
  cxImageComboBox, cxContainer, cxCheckBox, Res_FA, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinCaramel, dxSkinFoggy,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinscxPCPainter, cxNavigator, dxGDIPlusClasses;

function ShowMsgs(AForceTipsEP: Boolean; ALeft: Integer; ATop: Integer): boolean;

type
  TfmChecking = class(TForm)
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    dsChecking: TDataSource;
    paBottom: TPanel;
    cxGrid1DBTableView1Message: TcxGridDBColumn;
    ImageList1: TImageList;
    cxGrid1DBTableView1Kind: TcxGridDBColumn;
    paButtons: TPanel;
    paSettings: TPanel;
    Image1: TImage;
    Image2: TImage;
    imRozdil: TImage;
    Image5: TImage;
    cbChyba: TcxCheckBox;
    cbUpozorneni: TcxCheckBox;
    cbTip: TcxCheckBox;
    cbRozdil: TcxCheckBox;
    paButtonIn: TPanel;
    btIgnore: TButton;
    btRepair: TButton;
    procedure btRepairClick(Sender: TObject);
    procedure btIgnoreClick(Sender: TObject);
    procedure cxGrid1DBTableView1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SettingsClick(Sender: TObject);
    procedure cbRozdilClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FIsInCreating: boolean;
    FShowDifs: boolean;
    FForceTipsEP: Boolean;
    FModalWindow: Boolean;
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    procedure SetFilter;
    procedure CallScriptOnEndShowChecking;
  public
  end;

var
  fmChecking: TfmChecking;
  GSelectedResult: boolean;

implementation

uses
  Main, IniFiles, SpolFunkce, FCommonUtils, FScriptUtils
  {$IFNDEF STANDALONE}
  ,DataModGlobObj
  {$ENDIF STANDALONE}
  ;

{$R *.dfm}

function ShowMsgs(AForceTipsEP: Boolean; ALeft: Integer; ATop: Integer): boolean;
begin
  if fmChecking = nil then begin
    fmChecking:=TfmChecking.Create(nil);
    try
      fmChecking.FForceTipsEP:=AForceTipsEP;
      fmChecking.FModalWindow:=True;
      fmChecking.Left:=ALeft;
      fmChecking.Top:=ATop;
      fmChecking.ShowModal;
      Result := GSelectedResult;
    finally
      fmChecking.Free;
      fmChecking := nil;
    end;
  end else begin //okno uz existuje otevrene funkci ShowMsgsUnmodal - zavreme a otevreme modalne
    fmChecking.Close;
    fmChecking.Free;
    fmChecking := nil;
    fmChecking:=TfmChecking.Create(nil);
    try
      fmChecking.FForceTipsEP:=AForceTipsEP;
      fmChecking.FModalWindow:=True;
      fmChecking.Left:=ALeft;
      fmChecking.Top:=ATop;
      fmChecking.ShowModal;
      Result := GSelectedResult;
    finally
      fmChecking.Free;
      fmChecking := nil;
    end;
  end;
end; {ShowMsgs}

procedure TfmChecking.btRepairClick(Sender: TObject);
begin
  GSelectedResult := TRUE;
  CallScriptOnEndShowChecking;
  Close;
  if not FModalWindow then begin
    GfaMain.GotoField(GfaMain.mtCheckingFieldName.Value);
    GfaMain.SetFocus;
    fmChecking.Free;
    fmChecking := nil;
  end;
end;

procedure TfmChecking.btIgnoreClick(Sender: TObject);
begin
  GSelectedResult := FALSE;
  Close;
  if not FModalWindow then begin
    fmChecking.Free;
    fmChecking := nil;
  end;
end;

procedure TfmChecking.cxGrid1DBTableView1DblClick(Sender: TObject);
begin
  if FModalWindow then begin
    GSelectedResult := TRUE;
    CallScriptOnEndShowChecking;
    Close;
  end
  else begin
    CallScriptOnEndShowChecking;
    GfaMain.GotoField(GfaMain.mtCheckingFieldName.Value);
    GfaMain.SetFocus;
  end;
end;

procedure TfmChecking.FormCreate(Sender: TObject);
begin
  FIsInCreating:=TRUE;
  GSelectedResult := FALSE;
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
end;

procedure TfmChecking.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then begin
    GSelectedResult := FALSE;
    Close;
    if not FModalWindow then begin
      fmChecking.Free;
      fmChecking := nil;
    end;
  end
  else if Key = #13 then begin
    GSelectedResult := TRUE;
    CallScriptOnEndShowChecking;
    if not FModalWindow then begin
      GfaMain.GotoField(GfaMain.mtCheckingFieldName.Value);
      GfaMain.SetFocus;
    end;
    Close;
    if not FModalWindow then begin
      fmChecking.Free;
      fmChecking := nil;
    end;
  end;
end;

procedure TfmChecking.FormResize(Sender: TObject);
begin
  if Width<580 then begin
    paButtons.Align:=alBottom;
    paBottom.Height:=110;
    paButtons.Height:=55;
  end
  else begin
    paButtons.Align:=alRight;
    paBottom.height:=55;
    paButtons.Width:=220;
  end;
end;

procedure TfmChecking.LoadFormStateFromIni;
var iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    if Left=0 then
      Left := iniFile.ReadInteger(Name, 'Left',GfaMain.Left + 5);
    if Top=0 then
      Top := iniFile.ReadInteger(Name, 'Top',GfaMain.Top + 30);
    Width := iniFile.ReadInteger(Name, 'Width', 559);
    Height := iniFile.ReadInteger(Name, 'Height', 336);
    //CheckFormPosition(l,t,Width);
    //
    cbChyba.Checked := iniFile.ReadBool(cIniMtParam, cIniOpenCheckWithErr, TRUE);
    cbUpozorneni.Checked := iniFile.ReadBool(cIniMtParam, cIniOpenCheckWithWarn, TRUE);
    if FForceTipsEP then
      cbTip.Checked:=True
    else
      cbTip.Checked := iniFile.ReadBool(cIniMtParam, cIniOpenCheckWithInfo, TRUE);
    FShowDifs := iniFile.ReadBool(cIniMtParam, cIniOpenCheckWithDif, FALSE);
    cbRozdil.Checked := FShowDifs;
    imRozdil.Visible := TRUE;
  finally
    iniFile.Free;
  end;
end;

procedure TfmChecking.SaveFormStateToIni;
var iniFile: TMemIniFile;
begin
  LogStat('B:1.'+Cond(cbChyba.Checked,'1','0')+',2.'+Cond(cbUpozorneni.Checked,'1','0')+',3.'+Cond(cbTip.Checked,'1','0')+',4.'+Cond(cbRozdil.Checked,'1','0'), true);
  if not GfaMain.CanWriteToIniFile then EXIT;
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    iniFile.WriteInteger(Name, 'Left', Left);
    iniFile.WriteInteger(Name, 'Top', Top);
    iniFile.WriteInteger(Name, 'Width', Width);
    iniFile.WriteInteger(Name, 'Height', Height);
    //
    iniFile.WriteBool(cIniMtParam, cIniOpenCheckWithErr, cbChyba.Checked);
    iniFile.WriteBool(cIniMtParam, cIniOpenCheckWithWarn, cbUpozorneni.Checked);
    iniFile.WriteBool(cIniMtParam, cIniOpenCheckWithInfo, cbTip.Checked);
    iniFile.WriteBool(cIniMtParam, cIniOpenCheckWithDif, cbRozdil.Checked);
    //
    SaveMemIni(iniFile);
  finally
    iniFile.Free;
  end;
end;

procedure TfmChecking.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormStateToIni;
end;

procedure TfmChecking.FormShow(Sender: TObject);
begin
  LoadFormStateFromIni;
  dsChecking.DataSet := GfaMain.mtChecking;
  SetFilter;
  if CanFocus then begin
    try
      SetFocus;
    except
    end;
  end;
  FIsInCreating:=FALSE;
  BringToFront;
end;

procedure TfmChecking.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=Ord('K') then begin //Ctrl+Shift+K
    if not FModalWindow and (GetKeyState(VK_SHIFT)<0) and (GetKeyState(VK_CONTROL)<0) then begin
      CallScriptOnEndShowChecking;
      GfaMain.GotoField(GfaMain.mtCheckingFieldName.Value);
      GfaMain.SetFocus;
    end;
  end;
  {$IFNDEF STANDALONE}
  if Key=VK_F1 then
    Application.HelpSystem.ShowTopicHelp(Name,GetDataPrgPath+'FormStudio.chm');
  {$ENDIF STANDALONE}
end;

procedure TfmChecking.CallScriptOnEndShowChecking;
begin
  GfaMain.DoEndShowChecking;
end;

procedure TfmChecking.SetFilter;
begin
  with GfaMain,mtChecking do begin
    DisableControls;
    try
      Filter := '';
      if cbChyba.Checked then
        Filter := Filter + '(' + mtCheckingKind.FieldName + '=0)';
      if cbUpozorneni.Checked then begin
        if Filter<>'' then
          Filter := Filter + ' or ('+ mtCheckingKind.FieldName + '=1) or ('+ mtCheckingKind.FieldName + '=2)'
        else
          Filter := '('+ mtCheckingKind.FieldName + '=1) or ('+ mtCheckingKind.FieldName + '=2)';
      end;
      if cbTip.Checked then begin
        if Filter<>'' then
          Filter := Filter + ' or ('+ mtCheckingKind.FieldName + '=4) or ('+ mtCheckingKind.FieldName + '=5)'
        else
          Filter := '('+ mtCheckingKind.FieldName + '=4) or ('+ mtCheckingKind.FieldName + '=5)';
      end;
      if FShowDifs then begin
        if Filter<>'' then
          Filter := Filter + ' or ('+ mtCheckingKind.FieldName + '=3)'
        else
          Filter := '('+ mtCheckingKind.FieldName + '=3)';
      end;
      if Filter='' then //aby se nezobrazilo nic
        Filter := '(' + mtCheckingKind.FieldName + '=999)';
      Filtered := TRUE;
    finally
      EnableControls;
    end;
  end;
end;

procedure TfmChecking.SettingsClick(Sender: TObject);
begin
  SetFilter;
end;

procedure TfmChecking.cbRozdilClick(Sender: TObject);
begin
  if not FIsInCreating then begin
    if cbRozdil.Checked then
      MessageInfo(Caption,sMsgInfoRozdily,[MBOK]);
    SetFilter;
  end;
end;

end.


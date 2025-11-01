{ 16.10.2012 12:23:42 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 3.9.2012 10:51:38 (GMT+2:00) > [mik] checked in   }
{ 15.1.2009 10:10:00 (GMT+1:00) > [mik] checked in Oprava prirazeni akci k RV  }
{ 25.10.2006 10:27:24 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 23.8.2006 10:31:16 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 2.9.2005 15:57:13 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:27:33 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 17.11.2003 17:32:50 (GMT+1:00) > [mik on PCMIKHOME] checked in   }
{ 12.11.2003 16:07:04 (GMT+1:00) > [mik on PCMIKHOME] checked in   }
{ 26.10.2003 17:24:30 (GMT+1:00) > [mik on PCMIKHOME] checked in   }
{ 16.10.2003 23:17:57 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 13.10.2003 21:50:45 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 8.10.2003 22:36:27 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 21.9.2003 12:16:56 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 21.9.2003 12:16:15 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 4.9.2003 0:46:15 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 3.9.2003 19:28:44 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 13:34:24 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 17.6.2003 14:27:49 (GMT+2:00) > [mik on MIKPC2] checked in   }

unit ERichTextEditor;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mxStatusBar, RVStyle, RVScroll, RichView, RVEdit, Menus,
  ImgList, RichViewActions, ActnList, PtblRV, Res_FA;

function EditRichText(const ARichText, ACaption: string): string;
procedure OpenRichText(const ARichText, ACaption: string);

type
  TfmRichTextEditor = class(TForm)
    mxStatusBar1: TmxStatusBar;
    rvText: TRichViewEdit;
    RVStyle1: TRVStyle;
    PopupMenu1: TPopupMenu;
    miOpenFile: TMenuItem;
    OpenDialog1: TOpenDialog;
    ActionList1: TActionList;
    rvActionNew1: TrvActionNew;
    rvActionOpen1: TrvActionOpen;
    rvActionSave1: TrvActionSave;
    rvActionSaveAs1: TrvActionSaveAs;
    rvActionExport1: TrvActionExport;
    rvActionPrintPreview1: TrvActionPrintPreview;
    rvActionPrint1: TrvActionPrint;
    rvActionQuickPrint1: TrvActionQuickPrint;
    rvActionCut1: TrvActionCut;
    rvActionCopy1: TrvActionCopy;
    rvActionPaste1: TrvActionPaste;
    rvActionParagraph1: TrvActionParagraph;
    rvActionIndentInc1: TrvActionIndentInc;
    rvActionIndentDec1: TrvActionIndentDec;
    rvActionPasteSpecial1: TrvActionPasteSpecial;
    rvActionSelectAll1: TrvActionSelectAll;
    rvActionUndo1: TrvActionUndo;
    rvActionRedo1: TrvActionRedo;
    rvActionFonts1: TrvActionFonts;
    rvActionFontEx1: TrvActionFontEx;
    rvActionFontBold1: TrvActionFontBold;
    rvActionFontItalic1: TrvActionFontItalic;
    rvActionFontUnderline1: TrvActionFontUnderline;
    rvActionFontStrikeout1: TrvActionFontStrikeout;
    rvActionFontGrow1: TrvActionFontGrow;
    rvActionFontShrink1: TrvActionFontShrink;
    rvActionFontGrowOnePoint1: TrvActionFontGrowOnePoint;
    rvActionFontShrinkOnePoint1: TrvActionFontShrinkOnePoint;
    rvActionWordWrap1: TrvActionWordWrap;
    rvActionAlignLeft1: TrvActionAlignLeft;
    rvActionAlignRight1: TrvActionAlignRight;
    rvActionAlignCenter: TrvActionAlignCenter;
    rvActionAlignJustify1: TrvActionAlignJustify;
    rvActionInsertTable1: TrvActionInsertTable;
    rvActionTableInsertRowsAbove1: TrvActionTableInsertRowsAbove;
    rvActionTableInsertRowsBelow1: TrvActionTableInsertRowsBelow;
    rvActionTableInsertColLeft1: TrvActionTableInsertColLeft;
    rvActionTableInsertColRight1: TrvActionTableInsertColRight;
    rvActionTableDeleteRows1: TrvActionTableDeleteRows;
    rvActionTableDeleteCols1: TrvActionTableDeleteCols;
    rvActionTableDeleteTable1: TrvActionTableDeleteTable;
    rvActionTableMergeCells1: TrvActionTableMergeCells;
    rvActionTableSplitCells1: TrvActionTableSplitCells;
    rvActionTableSelectTable1: TrvActionTableSelectTable;
    rvActionTableSelectRows1: TrvActionTableSelectRows;
    rvActionTableSelectCols1: TrvActionTableSelectCols;
    rvActionTableSelectCell1: TrvActionTableSelectCell;
    rvActionFontAllCaps1: TrvActionFontAllCaps;
    rvActionFontOverline1: TrvActionFontOverline;
    rvActionFind1: TrvActionFind;
    rvActionFindNext1: TrvActionFindNext;
    rvActionReplace1: TrvActionReplace;
    rvActionFontColor1: TrvActionFontColor;
    rvActionFontBackColor1: TrvActionFontBackColor;
    rvActionParaColor1: TrvActionParaColor;
    rvActionColor1: TrvActionColor;
    rvActionFillColor1: TrvActionFillColor;
    rvActionInsertFile1: TrvActionInsertFile;
    rvActionInsertPicture1: TrvActionInsertPicture;
    rvActionLineSpacing1001: TrvActionLineSpacing100;
    rvActionLineSpacing1501: TrvActionLineSpacing150;
    rvActionLineSpacing2001: TrvActionLineSpacing200;
    rvActionInsertPageBreak1: TrvActionInsertPageBreak;
    rvActionRemovePageBreak1: TrvActionRemovePageBreak;
    rvActionTableCellVAlignTop1: TrvActionTableCellVAlignTop;
    rvActionTableCellVAlignMiddle1: TrvActionTableCellVAlignMiddle;
    rvActionTableCellVAlignBottom1: TrvActionTableCellVAlignBottom;
    rvActionTableCellVAlignDefault1: TrvActionTableCellVAlignDefault;
    rvActionParaBorder1: TrvActionParaBorder;
    rvActionItemProperties1: TrvActionItemProperties;
    rvActionInsertHLine1: TrvActionInsertHLine;
    rvActionInsertHyperlink1: TrvActionInsertHyperlink;
    rvActionTableProperties1: TrvActionTableProperties;
    rvActionTableGrid1: TrvActionTableGrid;
    rvActionParaList1: TrvActionParaList;
    rvActionInsertSymbol1: TrvActionInsertSymbol;
    rvActionTableCellLeftBorder1: TrvActionTableCellLeftBorder;
    rvActionTableCellRightBorder1: TrvActionTableCellRightBorder;
    rvActionTableCellTopBorder1: TrvActionTableCellTopBorder;
    rvActionTableCellBottomBorder1: TrvActionTableCellBottomBorder;
    rvActionTableCellAllBorders1: TrvActionTableCellAllBorders;
    rvActionTableCellNoBorders1: TrvActionTableCellNoBorders;
    rvActionParaBullets1: TrvActionParaBullets;
    rvActionParaNumbering1: TrvActionParaNumbering;
    rvActionBackground1: TrvActionBackground;
    ImageList1: TImageList;
    RVPrint1: TRVPrint;
    Najt1: TMenuItem;
    PrintPreview1: TMenuItem;
    Print1: TMenuItem;
    N1: TMenuItem;
    FindNext1: TMenuItem;
    procedure BringToFrontEx;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rvTextChange(Sender: TObject);
    procedure miOpenFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    procedure Init(const ARichText, ACaption: string);
  public
  end;

var
  fmRichTextEditor: TfmRichTextEditor;

implementation

uses
  Main,
  {$IFNDEF STANDALONE}
  DataModGlobObj,
  SpolFunkce,
  {$ENDIF STANDALONE}
  IniFiles, FCommonUtils,

  CRVFData, RVTable, RVItem, CRVData, RVFuncs, RVALocalize;

{$I RV_Defs.inc}

{$R *.dfm}

function EditRichText(const ARichText, ACaption: string): string;
var
  s: string;
  sl: TStringList;
  st: TStringStream;
begin
  if fmRichTextEditor<>nil then begin
    fmRichTextEditor.Free;
    fmRichTextEditor:=nil;
  end;
  fmRichTextEditor:=TfmRichTextEditor.Create(nil);
  try
    with fmRichTextEditor do begin
      Caption := ACaption;
      GfaMain.dxBarButtonSave.Enabled := FALSE;
      st:=TStringStream.Create(s);
      try
        st.WriteString(ARichText);
        st.Seek(0, soFromBeginning);
        rvText.Clear;
        rvText.LoadRTFFromStream(st);
        rvText.Format;
      finally
        st.Free;
      end;
      rvText.ReadOnly:=FALSE;
      fmRichTextEditor.ShowModal;
    end;
    //potrebujeme zjistit, jestli je neco v textu
    st:= TStringStream.Create('');
    try
      fmRichTextEditor.rvText.SaveTextToStream('',st,0,FALSE,TRUE);
      s:=st.DataString;
    finally
      st.Free;
    end;
    if Length(s)>0 then begin
      st:=TStringStream.Create(s);
      sl:=TStringList.Create;
      try
        fmRichTextEditor.rvText.SaveRTFToStream(st, FALSE);
        st.Seek(0, soFromBeginning);
        sl.LoadFromStream(st);
        Result:=sl.Text;
      finally
        st.Free;
        sl.Free;
      end;
    end
    else
      Result:='';
  finally
    fmRichTextEditor.Free;
    fmRichTextEditor:=nil;
  end;
end; {EditRichText}

procedure OpenRichText(const ARichText, ACaption: string);
begin
  if fmRichTextEditor <> nil then begin
    fmRichTextEditor.Init(ARichText,ACaption);
    fmRichTextEditor.BringToFrontEx;
  end
  else begin
    fmRichTextEditor:=TfmRichTextEditor.Create(nil);
    fmRichTextEditor.Init(ARichText,ACaption);
    fmRichTextEditor.Show;
  end;
end; {OpenRichText}

procedure TfmRichTextEditor.Init(const ARichText, ACaption: string);
var
  s: string;
  st: TStringStream;
begin
  Caption := ACaption;
  st:=TStringStream.Create(s);
  StartWait;
  try
    st.WriteString(ARichText);
    st.Seek(0, soFromBeginning);
    rvText.Clear;
    rvText.LoadRTFFromStream(st);
    rvText.Format;
  finally
    st.Free;
    StopWait;
  end;
  rvText.ReadOnly:=TRUE;
end; {Init}

procedure TfmRichTextEditor.BringToFrontEx;
begin
  SaveFormStateToIni;
  Show;
  if IsIconic(Handle) then
    ShowWindow(Handle, SW_RESTORE)
  else
    BringToFront;
  if CanFocus then
    SetFocus;
end; {BringToFrontEx}

procedure TfmRichTextEditor.rvTextChange(Sender: TObject);
begin
  //pri zmene zaznamu dsDef nastavit priznak zmeny
  GfaMain.dxBarButtonSave.Enabled := TRUE;
end; {rvEditChange}


procedure TfmRichTextEditor.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Close;
end; {FormKeyPress}

procedure TfmRichTextEditor.SaveFormStateToIni;
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
    SaveMemIni(iniFile);
  finally
    iniFile.Free;
  end;
end; {SaveStateFormToIni}

procedure TfmRichTextEditor.LoadFormStateFromIni;
var
  iniFile: TMemIniFile;
  l,t: Integer;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    Left:=iniFile.ReadInteger(Name, 'Left', GfaMain.Left+50);
    Top:=iniFile.ReadInteger(Name, 'Top', GfaMain.Top+50);
    Width:=iniFile.ReadInteger(Name, 'Width', GfaMain.Width);
    Height:=iniFile.ReadInteger(Name, 'Height', GfaMain.Height);
    l:=Left; t:=Top; CheckFormPosition(l,t,Width); Left:=l; Top:=t;
  finally
    iniFile.Free;
  end;
end; {LoadStateFormIni}

procedure TfmRichTextEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormStateToIni;
  {$IFNDEF STANDALONE}
  //zruseni ikony v outlookbaru
  dmGlobObj.gFAllWindow.RemoveObj(Self);
  Application.MainForm.Perform(Msg_UpdateListWindow, 2, 0);
  {$ENDIF STANDALONE}
end; procedure TfmRichTextEditor.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
end;

{FormClose}

procedure TfmRichTextEditor.miOpenFileClick(Sender: TObject);
begin
  with OpenDialog1 do begin
    if Execute then begin
      rvText.Clear;
      rvText.LoadRTF(FileName);
      rvText.Format;
    end;
  end;
end; {miOpenFileClick}

procedure TfmRichTextEditor.FormShow(Sender: TObject);
{$IFNDEF STANDALONE}
var
  lObj: TWinObj;
{$ENDIF STANDALONE}
begin
{$IFNDEF STANDALONE}
  //vytvoreni ikony v outlookbaru
  lObj := TWinObj.Create;
  lObj.Window := self;
  lObj.WindowText := Caption;
  lObj.WindowIcon := 15;
  lObj.WindowIconText := sPokyny;
  dmGlobObj.gFAllWindow.AddObj(lObj);
  Application.MainForm.Perform(Msg_UpdateListWindow, 1, 0);
  miOpenFile.Visible:=FALSE;
{$ELSE STANDALONE}
  {$IFDEF FINALBUILD}
  miOpenFile.Visible:=FALSE;
  {$ELSE FINALBUILD}
  miOpenFile.Visible:=TRUE;
  {$ENDIF FINALBUILD}
{$ENDIF STANDALONE}

  LoadFormStateFromIni;
  RVA_SwitchLanguage('Czech');
  RVA_LocalizeForm(Self);
end;

end.

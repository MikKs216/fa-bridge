


unit EfmRvEditor;

interface


{$I RV_Defs.inc}          // contains defines about Delphi compiler versions

{.$DEFINE USE_GIFIMAGE}
{.$DEFINE USE_PNGOBJECT}


uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,
  ActnList, StdActns, ImgList,
  Menus, ShellApi, Printers, ToolWin, RVUni,

  {$IFDEF USE_GIFIMAGE}
  GifImage, // Change to GifImg in Delphi/C++Builder 2007
  {$ENDIF}
  {$IFDEF USE_PNGOBJECT}
  PngImage,
  {$ENDIF}

  RVMisc, RVScroll, RichView, RVEdit,
  RVStyle, CRVFData, RVTable, RVItem, CRVData, RVFuncs,

  // RVAAddictLanguages,

  RichViewActions, RVALocRuler, RVFontCombos, RVALocalize, Ruler, RVRuler,
  SRVToolBar, SRVToolWindow, SclRView, SclRVRuler, ExtCtrls, SRVPageScroll,
  dxBar, cxClasses, dxBarExtItems;

type
  TfrmRVEditor = class(TForm)
    RVAControlPanel1: TRVAControlPanel;
    RVAPopupMenu1: TRVAPopupMenu;
    ColorDialog1: TColorDialog;
    pmFakeDropDown: TPopupMenu;
    srvtlwndw1: TSRVToolWindow;
    il1: TImageList;
    ilMenuV: TImageList;
    ilMenuH: TImageList;
    Panel1: TPanel;
    Panel3: TPanel;
    SclRVRuler1: TSclRVRuler;
    Panel4: TPanel;
    RVRulerItemSelector1: TRVRulerItemSelector;
    fd: TFindDialog;
    rd: TReplaceDialog;
    HintTableMenu: TPopupMenu;
    SampleHintTablemenu1: TMenuItem;
    PrintDialog1: TPrintDialog;
    OpenDialog1: TOpenDialog;
    SRVPageScroll1: TSRVPageScroll;
    stat1: TStatusBar;
    SclRVRuler2: TSclRVRuler;
    SRichViewEdit1: TSRichViewEdit;
    Splitter1: TSplitter;
    dxBarManagerRV: TdxBarManager;
    dxBarManagerRVBar1: TdxBar;
    New1: TdxBarButton;
    Load1: TdxBarButton;
    Save1: TdxBarButton;
    SaveAs1: TdxBarButton;
    Export1: TdxBarButton;
    mitPageSetup: TdxBarButton;
    mitPrint: TdxBarButton;
    mitExit: TdxBarButton;
    mitFile: TdxBarSubItem;
    Undo1: TdxBarButton;
    Redo1: TdxBarButton;
    Cut1: TdxBarButton;
    Copy1: TdxBarButton;
    n2: TdxBarButton;
    PasteSpecial1: TdxBarButton;
    Find1: TdxBarButton;
    FindNext1: TdxBarButton;
    Replace1: TdxBarButton;
    CharacterCase1: TdxBarButton;
    InsertPageBreak1: TdxBarButton;
    RemovePageBreak1: TdxBarButton;
    SelectAll1: TdxBarButton;
    mitEdit: TdxBarSubItem;
    Changefont1: TdxBarButton;
    Bold1: TdxBarButton;
    Italic1: TdxBarButton;
    Underline1: TdxBarButton;
    Strikeout1: TdxBarButton;
    rvActionSubscript11: TdxBarButton;
    rvActionSuperscript11: TdxBarButton;
    AllCapitals1: TdxBarButton;
    Overline1: TdxBarButton;
    mitFontStyle: TdxBarSubItem;
    ShrinkFont1: TdxBarButton;
    GrowFont1: TdxBarButton;
    ShrinkFontByOnePoint1: TdxBarButton;
    GrowFontByOnePoint1: TdxBarButton;
    mitFontSize: TdxBarSubItem;
    extColor1: TdxBarButton;
    extBackgroundColor1: TdxBarButton;
    mitFont: TdxBarSubItem;
    rvActionParagraph11: TdxBarButton;
    ParagraphBorders1: TdxBarButton;
    AlignLeft1: TdxBarButton;
    AlignCenter1: TdxBarButton;
    AlignRight1: TdxBarButton;
    Justify1: TdxBarButton;
    BulletsandNumbering1: TdxBarButton;
    Bullets1: TdxBarButton;
    Numbering1: TdxBarButton;
    Leftjustify1: TdxBarButton;
    DecreaseIndent1: TdxBarButton;
    IncreaseIndent1: TdxBarButton;
    SingleLineSpacing1: TdxBarButton;
    N15LineSpacing1: TdxBarButton;
    DoubleLineSpacing1: TdxBarButton;
    ParagraphBackgroundColor1: TdxBarButton;
    mitPara: TdxBarSubItem;
    Background1: TdxBarButton;
    BackgroundColor1: TdxBarButton;
    FillColor1: TdxBarButton;
    Properties1: TdxBarButton;
    mitFormat: TdxBarSubItem;
    File1: TdxBarButton;
    Picture1: TdxBarButton;
    HorizontalLine1: TdxBarButton;
    HypertextLink1: TdxBarButton;
    InsertSymbol1: TdxBarButton;
    miFSHelpStart: TdxBarButton;
    miFSHelpEnd: TdxBarButton;
    mitInsert: TdxBarSubItem;
    InsertTable1: TdxBarButton;
    InsertColumnLeft1: TdxBarButton;
    InsertColumnRight1: TdxBarButton;
    InsertRowAbove1: TdxBarButton;
    InsertRowBelow1: TdxBarButton;
    DeleteRows1: TdxBarButton;
    rvActionTableDeleteCols11: TdxBarButton;
    DeleteTable1: TdxBarButton;
    SelectTable1: TdxBarButton;
    SelectColumns1: TdxBarButton;
    SelectRows1: TdxBarButton;
    SelectCell1: TdxBarButton;
    mitTableSelect: TdxBarSubItem;
    AlignCellToTheTop1: TdxBarButton;
    AlignCellToTheMiddle1: TdxBarButton;
    AlignCellToTheBottom1: TdxBarButton;
    DefaultCellVerticalAlignment1: TdxBarButton;
    mitTableAlignCellContents: TdxBarSubItem;
    LeftBorder1: TdxBarButton;
    rvActionTableCellTopBorder11: TdxBarButton;
    rvActionTableCellRightBorder11: TdxBarButton;
    rvActionTableCellBottomBorder11: TdxBarButton;
    rvActionTableCellAllBorders11: TdxBarButton;
    rvActionTableCellNoBorders11: TdxBarButton;
    mitTableCellBorders: TdxBarSubItem;
    SplitCells1: TdxBarButton;
    MergeCells1: TdxBarButton;
    ShowGridLines1: TdxBarButton;
    ableProperties1: TdxBarButton;
    mitTable: TdxBarSubItem;
    dxBarManagerRVBar2: TdxBar;
    dxBarManagerRVBar3: TdxBar;
    dxBarManagerRVBar4: TdxBar;
    dxBarManagerRVBar5: TdxBar;
    dxBarManagerRVBar6: TdxBar;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxFakeDropDown: TdxBarPopupMenu;
    dxBarButton3: TdxBarButton;
    dxBtnMiniatury: TdxBarButton;
    dxBtnNahled: TdxBarButton;
    dxFont: TdxBarFontNameCombo;
    dxFontSize: TdxBarCombo;
    dxListZoom: TdxBarCombo;
    dxListFormat: TdxBarCombo;
    dxBarButton4: TdxBarButton;
    dxListUnits: TdxBarCombo;
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
    rvActionPageSetup1: TrvActionPageSetup;
    rvActionTextRTL1: TrvActionTextRTL;
    rvActionTextLTR1: TrvActionTextLTR;
    rvActionParaRTL1: TrvActionParaRTL;
    rvActionParaLTR1: TrvActionParaLTR;
    rvActionCharCase1: TrvActionCharCase;
    rvActionShowSpecialCharacters1: TrvActionShowSpecialCharacters;
    rvActionSubscript1: TrvActionSubscript;
    rvActionSuperscript1: TrvActionSuperscript;
    ImageList1: TImageList;
    dxBarBtnPrevzit: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mitExitClick(Sender: TObject);
    procedure RichViewEdit1_Jump(Sender: TObject; id: Integer);
    procedure RichViewEdit1_ReadHyperlink(Sender: TCustomRichView;
      const Target, Extras: String; DocFormat: TRVLoadFormat; var StyleNo,
      ItemTag: Integer; var ItemName: String);
    procedure cmbFontClick(Sender: TObject);
    procedure cmbKeyPress(Sender: TObject; var Key: Char);
    procedure RichViewEdit1_CurTextStyleChanged(Sender: TObject);
    procedure cmbFontSizeClick(Sender: TObject);
    procedure RichViewEdit1_WriteHyperlink(Sender: TCustomRichView;
      id: Integer; RVData: TCustomRVData; ItemNo: Integer;
      SaveFormat: TRVSaveFormat; var Target, Extras: String);
    procedure RVAControlPanel1MarginsChanged(Sender: TrvAction;
      Edit: TCustomRichViewEdit);
    procedure RVAControlPanel1Download(Sender: TrvAction;
      const Source: String);
    procedure RichViewEdit1_KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RichViewEdit1_KeyPress(Sender: TObject; var Key: Char);
    procedure ListZoomChange(Sender: TObject);
    procedure ListFormatChange(Sender: TObject);
    procedure SRichViewEdit1CurrentPageChange(Sender: TObject);
    procedure SRichViewEdit1HMenuClickButton(Sender: TObject;
      ToolButton: TSRVToolButton);
    procedure SRichViewEdit1PageScrolled(Sender: TObject);
    procedure SRichViewEdit1VMenuClickButton(Sender: TObject;
      ToolButton: TSRVToolButton);
    procedure SRichViewEdit1CaretMove(Sender: TObject);
    procedure srvtlwndw1ClickButton(Sender: TObject;
      ToolButton: TSRVToolButton);
    procedure fdFind(Sender: TObject);
    procedure SclRVRuler1MarginDblClick(Sender: TObject;
      Margin: TMarginType);
    procedure mitPageSetupClick(Sender: TObject);
    procedure mitPrintClick(Sender: TObject);
    procedure btnQuickPrintClick(Sender: TObject);
    procedure RVAControlPanel1BackgroundChange(Sender: TrvAction;
      Edit: TCustomRichViewEdit);
    procedure SRichViewEdit1HintTableClick(Sender: TSRichViewEdit;
      Button: TMouseButton; Shift: TShiftState; X, Y, PageNo: Integer);
    procedure ListUnitsChange(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnThumbnailsClick(Sender: TObject);
    procedure miFSHelpStartClick(Sender: TObject);
    procedure miFSHelpEndClick(Sender: TObject);
    procedure dxFakeDropDownPopup(Sender: TObject);
    procedure dxBarBtnPrevzitClick(Sender: TObject);
  private
    { Private declarations }
    HToolButton, VToolButton: TSRVToolButton;
    UpdatingCombos: Boolean;
    procedure ColorPickerShow(Sender: TObject);
    procedure ColorPickerHide(Sender: TObject);
    procedure rvActionSave1DocumentFileChange(Sender: TObject;
      Editor: TCustomRichViewEdit; const FileName: String;
      FileFormat: TrvFileSaveFilter; IsNew: Boolean);
    procedure ApplicationHint(Sender: TObject);
    procedure ToggleThumbnails(Show: Boolean);
  public
    { Public declarations }
    procedure FillEditor(obsah:TMemoryStream);
    function GetValue():TMemoryStream;
  end;

var
  frmRVEditor: TfrmRVEditor;
  gPixelsPerInch:Integer;

implementation

uses Math, f_PageProperty;
{$R *.dfm}

var
  RememberZoomMode : TRVZoomMode;
  RememberZoomPercent : Single;

procedure ShowInfo(const msg,cpt: String);
begin
  Application.MessageBox(PChar(msg),PChar(cpt),MB_OK or MB_ICONINFORMATION);
end;

{----------------------------- View Modes -------------------------------------}
// Normal view mode (as one long page)
procedure PageMode(srve : TSRichViewEdit);
begin
  srve.PageProperty.AutoWidth := False;
  srve.PageProperty.FormatMode := srvfmA4;
//  srve.PageProperty.BreakPage := False;
  srve.PageProperty.BoundLeftRight := 0;
  srve.PageProperty.MinPageBreakHeight := 0;
  srve.PageProperty.MaxPageBreakHeight := 0;
  srve.PageProperty.BorderPen.Style := psClear;
  srve.BackgroundProperty.Visible := False;
  srve.Color := clWhite;
  srve.ViewProperty.HintPage := True;
//  srve.ViewProperty.AlignPageH := srvaphLeft;
//  srve.ViewProperty.AlignPageV := srvapvTop;
  srve.ViewProperty.ZoomPercent := RememberZoomPercent;
  srve.ViewProperty.ZoomMode := RememberZoomMode;
end;
// Web view mode
procedure WebMode(srve : TSRichViewEdit);
begin
  RememberZoomPercent := srve.ViewProperty.ZoomPercent;
  RememberZoomMode := srve.ViewProperty.ZoomMode;
  srve.PageProperty.BreakPage := False;
  srve.ViewProperty.HintPage := False;
  srve.BackgroundProperty.Visible := False;
  srve.Color := clWhite;
  srve.PageProperty.BoundLeftRight := 0;
  srve.PageProperty.MinPageBreakHeight := 0;
  srve.PageProperty.MaxPageBreakHeight := 0;
  srve.ViewProperty.AlignPageH := srvaphLeft;
  srve.ViewProperty.AlignPageV := srvapvTop;
  srve.PageProperty.BorderPen.Style := psClear;
  srve.PageProperty.AutoWidth := True;
  srve.ViewProperty.ZoomPercent := RememberZoomPercent;
end;
// Page view mode
procedure PagesMode(srve : TSRichViewEdit);
begin
  srve.PageProperty.AutoWidth := False;
  srve.PageProperty.BreakPage := True;
  srve.PageProperty.FormatMode := srvfmA4;
  srve.ViewProperty.HintPage := True;
  srve.BackgroundProperty.Visible := True;
  srve.Color := $0099A8AC;
  srve.PageProperty.BoundLeftRight := 20;
  srve.PageProperty.MinPageBreakHeight := 5;
  srve.PageProperty.MaxPageBreakHeight := 25;
  srve.PageProperty.BorderPen.Style := psSolid;
  srve.ViewProperty.AlignPageH := srvaphCenter;
  srve.ViewProperty.AlignPageV := srvapvCenter;
  srve.ViewProperty.ZoomPercent := RememberZoomPercent;
  srve.ViewProperty.ZoomMode := RememberZoomMode;
end;
{------------------------------------------------------------------------------}
procedure TfrmRVEditor.FormCreate(Sender: TObject);
begin
  // Almost all these assignments could be done at design time in the Object Inspector
  // But in this demo we do not want to modify rvActionsItems
  // (and we recommend to use a copy of it in your applications)

  rvActionSave1.OnDocumentFileChange := rvActionSave1DocumentFileChange;

  // Code for making color-picking buttons stay pressed while a
  // color-picker window is visible.
  rvActionColor1.OnShowColorPicker := ColorPickerShow;
  rvActionColor1.OnHideColorPicker := ColorPickerHide;
  rvActionParaColor1.OnShowColorPicker := ColorPickerShow;
  rvActionParaColor1.OnHideColorPicker := ColorPickerHide;
  rvActionFontColor1.OnShowColorPicker := ColorPickerShow;
  rvActionFontColor1.OnHideColorPicker := ColorPickerHide;
  rvActionFontBackColor1.OnShowColorPicker := ColorPickerShow;
  rvActionFontBackColor1.OnHideColorPicker := ColorPickerHide;

  // Delphi 4 and 5 do not have ActionComponent property for actions.
  // Coloring actions have a substitution - CallerControl property
  // It is ignored in Delphi 6 and 7
  //*MR
  //rvActionParaColor1.CallerControl := ToolButton39;
  //rvActionFontBackColor1.CallerControl := ToolButton38;
  //rvActionFontColor1.CallerControl := ToolButton36;

  {$IFDEF RICHVIEWDEF6}
  // AutoComplete feature causes OnClick generation when editing combo-box's text.
  // Since in OnClick we move input focus in RichViewEdit1, this effect is
  // undesirable
  //dxcmbFont.AutoComplete := False;
  //cmbFontSize.AutoComplete := False;
  {$ENDIF}

  //Localize;

  // Displaying hints on the status bar
  Application.OnHint := ApplicationHint;

  // Loading initial file via ActionOpen (allowing to update user interface)
  //rvActionOpen1.LoadFile(SRichViewEdit1.RichViewEdit,
    //ExtractFilePath(Application.ExeName)+'readme.rvf', ffiRVF);

  btnThumbnailsClick(dxBtnMiniatury);
  {
  // alternative way to start
    rvActionNew1.ExecuteTarget(SRichViewEdit1.RichViewEdit);
  }


  VToolButton := nil;
  dxListZoom.ItemIndex:= dxListZoom.Items.IndexOf('Na šíøku');
  dxListFormat.ItemIndex:= dxListFormat.Items.IndexOf('A4');
  dxListUnits.ItemIndex:= dxListUnits.Items.IndexOf('cm');
  ListZoomChange(nil);
  ListFormatChange(nil);
  ListUnitsChange(nil);
end;

function TfrmRVEditor.GetValue: TMemoryStream;
var
  str:TMemoryStream;
begin
   str:=TMemoryStream.Create();
   SRichViewEdit1.RichViewEdit.SaveRTFToStream(str,false);
   Result:= str;
end;{GetValue}

{------------------- Working with document ------------------------------------}

// When document is created, saved, loaded...
procedure TfrmRVEditor.rvActionSave1DocumentFileChange(Sender: TObject;
  Editor: TCustomRichViewEdit; const FileName: String;
  FileFormat: TrvFileSaveFilter; IsNew: Boolean);
var s: String;
begin
  s := ExtractFileName(FileName);
  rvActionPrint1.Title := s;
  rvActionQuickPrint1.Title := s;
  if IsNew then
    s := s+' (*)';
  Caption := s + '';
end;

// Prompt for saving...
procedure TfrmRVEditor.FillEditor(obsah: TMemoryStream);
begin
   obsah.Position:=0;
   if obsah.size=0 then
     exit;
   SRichViewEdit1.RichViewEdit.Clear;
   //SRichViewEdit1.RichViewEdit.ClearUndo;
   //SRichViewEdit1.RichViewEdit.LoadRTFFromStream(obsah);
   if SRichViewEdit1.RichViewEdit.CanPasteRVF then
     SRichViewEdit1.RichViewEdit.PasteRVF;
   SRichViewEdit1.RichViewEdit.RefreshAll;
end;

procedure TfrmRVEditor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := rvActionSave1.CanCloseDoc(SRichViewEdit1.RichViewEdit);
end;

procedure TfrmRVEditor.miFSHelpEndClick(Sender: TObject);
begin
   SRichViewEdit1.RichViewEdit.InsertText('[_/_]');
end;

procedure TfrmRVEditor.miFSHelpStartClick(Sender: TObject);
begin
   SRichViewEdit1.RichViewEdit.InsertText('[__]');
end;

procedure TfrmRVEditor.mitExitClick(Sender: TObject);
begin
  Close;
end;

{--------------- Working with color-picking buttons ---------------------------}

// Code for making color-picking buttons pressed while
// a color-picker window is visible.
procedure TfrmRVEditor.ColorPickerShow(Sender: TObject);
begin
  {$IFDEF RICHVIEWDEF6}
  if (Sender as TAction).ActionComponent is TToolButton then
    TToolButton(TAction(Sender).ActionComponent).Down := True;
  {$ELSE}
  if TrvActionCustomColor(Sender).CallerControl<>nil then
    TToolButton(TrvActionCustomColor(Sender).CallerControl).Down := True;
  {$ENDIF};
end;

procedure TfrmRVEditor.dxBarBtnPrevzitClick(Sender: TObject);
begin
  Self.ModalResult:=MrOK;
  //Close();
end;

procedure TfrmRVEditor.dxFakeDropDownPopup(Sender: TObject);
begin
  Exit;
  rvActionInsertTable1.ShowTableSizeDialog(SRichViewEdit1.RichViewEdit, nil);

end;


function EnumFontSizes(var EnumLogFont: TEnumLogFont;
  PTextMetric: PNewTextMetric; FontType: Integer; Data: LPARAM): Integer;
  export; stdcall;
var s: String;
    i,v,v2: Integer;
begin
  if (FontType and TRUETYPE_FONTTYPE)<>0 then begin
    TdxBarCombo(Data).Items.Add('8');
    TdxBarCombo(Data).Items.Add('9');
    TdxBarCombo(Data).Items.Add('10');
    TdxBarCombo(Data).Items.Add('11');
    TdxBarCombo(Data).Items.Add('12');
    TdxBarCombo(Data).Items.Add('14');
    TdxBarCombo(Data).Items.Add('16');
    TdxBarCombo(Data).Items.Add('18');
    TdxBarCombo(Data).Items.Add('20');
    TdxBarCombo(Data).Items.Add('22');
    TdxBarCombo(Data).Items.Add('24');
    TdxBarCombo(Data).Items.Add('26');
    TdxBarCombo(Data).Items.Add('28');
    TdxBarCombo(Data).Items.Add('36');
    TdxBarCombo(Data).Items.Add('48');
    TdxBarCombo(Data).Items.Add('72');
    Result := 0;
    end
  else begin
    v := Round((EnumLogFont.elfLogFont.lfHeight-PTextMetric.tmInternalLeading)*72 /
      gPixelsPerInch);
    s := IntToStr(v);
    Result := 1;
    for i := 0 to TdxBarCombo(Data).Items.Count-1 do begin
      v2 := StrToInt(TdxBarCombo(Data).Items[i]);
      if v2=v then
        exit;
      if v2>v then begin
        TdxBarCombo(Data).Items.Insert(i,s);
        exit;
      end;
    end;
    TdxBarCombo(Data).Items.Add(s);
  end;
end;

procedure BuildFontSize(fontName:string; cmb:TdxBarCombo);
var
  DC: HDC;
  OC: TNotifyEvent;
begin
  DC := GetDC(0);
  cmb.Items.BeginUpdate;
  try
    cmb.Items.Clear;
    if FontName<>'' then begin
      gPixelsPerInch := GetDeviceCaps(DC, LOGPIXELSY);
      EnumFontFamilies(DC, PChar(fontName), @EnumFontSizes, Longint(cmb));
      OC := cmb.OnChange;
      cmb.OnChange := nil;
      cmb.ItemIndex := cmb.Items.IndexOf(cmb.Text);
      cmb.OnChange := OC;
      if Assigned(cmb.OnChange) then
        cmb.OnChange(cmb);
    end;
  finally
    cmb.Items.EndUpdate;
    ReleaseDC(0, DC);
  end;
end;

procedure TfrmRVEditor.ColorPickerHide(Sender: TObject);
begin
  {$IFDEF RICHVIEWDEF6}
  if (Sender as TAction).ActionComponent is TToolButton then
    TToolButton(TAction(Sender).ActionComponent).Down := False;
  {$ELSE}
  if TrvActionCustomColor(Sender).CallerControl<>nil then
    TToolButton(TrvActionCustomColor(Sender).CallerControl).Down := False;
  {$ENDIF}
end;

{-------------- Set of events for processing hypertext links ------------------}

// Hyperlink click
procedure TfrmRVEditor.RichViewEdit1_Jump(Sender: TObject; id: Integer);
begin
  rvActionInsertHyperlink1.GoToLink(SRichViewEdit1.RichViewEdit, id);
end;

// Importing hyperlink
procedure TfrmRVEditor.RichViewEdit1_ReadHyperlink(Sender: TCustomRichView;
  const Target, Extras: String; DocFormat: TRVLoadFormat; var StyleNo,
  ItemTag: Integer; var ItemName: String);
var URL: String;
begin
  if DocFormat=rvlfURL then
    StyleNo :=
      rvActionInsertHyperlink1.GetHyperlinkStyleNo(SRichViewEdit1.RichViewEdit);
  URL := rvActionInsertHyperlink1.EncodeTarget(Target);
  ItemTag := Integer(StrNew(PChar(URL)));
end;

// Exporting hyperlink to RTF and HTML
procedure TfrmRVEditor.RichViewEdit1_WriteHyperlink(Sender: TCustomRichView;
  id: Integer; RVData: TCustomRVData; ItemNo: Integer;
  SaveFormat: TRVSaveFormat; var Target, Extras: String);
begin
  Target := PChar(RVData.GetItemTag(ItemNo));
end;

// URL detection on typing
procedure TfrmRVEditor.RichViewEdit1_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_SPACE, VK_RETURN, VK_TAB] then begin
    {
      // uncomment if you use Addict3
      RVA_Addict3AutoCorrect(RichViewEdit1);
    }
    rvActionInsertHyperlink1.DetectURL(SRichViewEdit1.RichViewEdit);
    rvActionInsertHyperlink1.TerminateHyperlink(SRichViewEdit1.RichViewEdit);
  end;
end;

procedure TfrmRVEditor.RichViewEdit1_KeyPress(Sender: TObject; var Key: Char);
begin
  {
  // uncomment if you use Addict3
  if (Key='''') or ((Key<>' ') and (Pos(Key, RichViewEdit1.Delimiters)<>0)) then
    RVA_Addict3AutoCorrect(RichViewEdit1);
  }
end;

{--------------------- Working with font combo-boxes --------------------------}

// Current font is changed. Updating the combo-boxes.
procedure TfrmRVEditor.RichViewEdit1_CurTextStyleChanged(Sender: TObject);
var CurStyle: TFontInfo;
begin
  UpdatingCombos := True;
  try
    CurStyle := SRichViewEdit1.RichViewEdit.Style.TextStyles[SRichViewEdit1.RichViewEdit.CurTextStyleNo];
    dxFont.Text := CurStyle.FontName;
    dxFont.OnClick(Sender);
    //dxFontSize.FontName := CurStyle.FontName;
    BuildFontSize(CurStyle.FontName,dxFontSize);
    dxFontSize.Text := IntToStr(CurStyle.Size);
  finally
    UpdatingCombos := False;
  end;
end;

// Applying the font name
procedure TfrmRVEditor.cmbFontClick(Sender: TObject);
var FontName: String;
begin


    if dxFont.ItemIndex<0 then
      FontName := dxFont.Text
    else
      FontName := dxFont.Items[dxFont.ItemIndex];


  if UpdatingCombos then
    exit;
  UpdatingCombos := True;

  BuildFontSize(dxFont.Text,dxFontSize);

  UpdatingCombos := False;

    if dxFont.ItemIndex<0 then
        dxFont.ItemIndex := dxFont.Items.IndexOf(FontName);

      if dxFont.ItemIndex<0 then begin
          if Visible then beep
        end
      else
        with rvActionFontEx1 do begin
          UserInterface := False;
          ValidProperties := [rvfimFontName];
          Font.Name := FontName;
          Execute;
          UserInterface := True;
        end;
  
  SRichViewEdit1.RichViewEdit.SetFocus;
end;

// Changing the font size
procedure TfrmRVEditor.cmbFontSizeClick(Sender: TObject);
var FontSize: Integer;
begin
  if UpdatingCombos then
    exit;
  try
    FontSize := StrToInt(dxFontSize.Text);
    with rvActionFontEx1 do begin
      UserInterface := False;
      ValidProperties := [rvfimSize];
      Font.Size := FontSize;
      Execute;
      UserInterface := True;
    end;
  except
    if Visible then beep;
  end;
  SRichViewEdit1.RichViewEdit.SetFocus;
end;

procedure TfrmRVEditor.cmbKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then begin
    Key := #0;
    TComboBox(Sender).OnClick(Sender);
  end;
end;

{------- Synchronizing ScaleRichView after non-editing operations -------------}
// Returns paper format name
function GetPaperFormatName(PaperFormat: TSRVFormatMode): String;
begin
  case PaperFormat of
    srvfmA0:
      Result := 'A0';
    srvfmA1:
      Result := 'A1';
    srvfmA2:
      Result := 'A2';
    srvfmA3:
      Result := 'A3';
    srvfmA4:
      Result := 'A4';
    srvfmA5:
      Result := 'A5';
    srvfmA6:
      Result := 'A6';
    srvfmLetter:
      Result := 'Letter';
    srvfmLegal:
      Result := 'Legal';
    else
      Result := '';
  end;
end;
// Returns name for measurement units
function GetUnitsName(Units: TRVUnits): String;
begin
  case Units of
    rvuMillimeters:
      Result := 'mm';
    rvuCentimeters:
      Result := 'cm';
    rvuPicas:
      Result := 'picas';
    rvuPixels:
      Result := 'pixels';
    rvuPoints:
      Result := 'body';
    rvuInches:
      Result := 'palce';
    else
      Result := '';
  end;
end;

procedure TfrmRVEditor.RVAControlPanel1MarginsChanged(Sender: TrvAction;
  Edit: TCustomRichViewEdit);
begin
  SRichViewEdit1.SetRVMargins;
  SRichViewEdit1.RichViewEdit.Modified := False;

  case SRichViewEdit1.ViewProperty.ZoomMode of
    rvzmPageWidth:
      dxListZoom.ItemIndex := dxListZoom.Items.IndexOf('Na šíøku');
    rvzmFullPage:
      dxListZoom.ItemIndex := dxListZoom.Items.IndexOf('Celá strana');
    rvzmCustom:
      dxListZoom.ItemIndex := dxListZoom.Items.IndexOf(
        IntToStr(Round(SRichViewEdit1.ViewProperty.ZoomPercent)));
  end;

  if SRichViewEdit1.PageProperty.FormatMode = srvfmA0 then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('A0')
  else if SRichViewEdit1.PageProperty.FormatMode = srvfmA1 then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('A1')
  else if SRichViewEdit1.PageProperty.FormatMode = srvfmA2 then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('A2')
  else if SRichViewEdit1.PageProperty.FormatMode = srvfmA3 then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('A3')
  else if SRichViewEdit1.PageProperty.FormatMode = srvfmA4 then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('A4')
  else if SRichViewEdit1.PageProperty.FormatMode = srvfmA5 then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('A5')
  else if SRichViewEdit1.PageProperty.FormatMode = srvfmA6 then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('A6')
  else if SRichViewEdit1.PageProperty.FormatMode = srvfmLetter then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('Letter')
  else if SRichViewEdit1.PageProperty.FormatMode = srvfmLegal then
    dxListFormat.ItemIndex := dxListFormat.Items.IndexOf('Legal');

  dxListFormat.ItemIndex :=
    dxListFormat.Items.IndexOf(GetPaperFormatName(SRichViewEdit1.PageProperty.FormatMode));

  dxListUnits.ItemIndex :=
    dxListUnits.Items.IndexOf(GetUnitsName(SRichViewEdit1.UnitsProgram));

  SclRVRuler1.UnitsDisplay := TRulerUnits(SRichViewEdit1.UnitsProgram);
  SclRVRuler2.UnitsDisplay := TRulerUnits(SRichViewEdit1.UnitsProgram);
end;

procedure TfrmRVEditor.RVAControlPanel1BackgroundChange(Sender: TrvAction;
  Edit: TCustomRichViewEdit);
begin
  SRichViewEdit1.Repaint;
end;

{---------------------------- Localization ------------------------------------}


{-------------------------------- Misc. ---------------------------------------}

procedure TfrmRVEditor.RVAControlPanel1Download(Sender: TrvAction;
  const Source: String);
begin
  if Source='' then
    Application.Hint := ''
  else
    Application.Hint := 'Downloading '+Source+'...';
end;

procedure TfrmRVEditor.SRichViewEdit1HintTableClick(Sender: TSRichViewEdit;
  Button: TMouseButton; Shift: TShiftState; X, Y, PageNo: Integer);
begin
  SRichViewEdit1.getHintTableItem.SelectRows(0, SRichViewEdit1.getHintTableItem.RowCount);
  SRichViewEdit1.Repaint;
end;

{---------------------- Live spelling with Addict 3 ---------------------------}
(*
// Add these events if you use Addict3
// (Assuming that you have RVAddictSpell31: TRVAddictSpell3 on the form)

// RichViewEdit1.OnSpellingCheck event
procedure TfrmRVEditor.RichViewEdit1SpellingCheck(Sender: TCustomRichView;
  const AWord: String; StyleNo: Integer; var Misspelled: Boolean);
begin
  Misspelled := not RVAddictSpell31.WordAcceptable(AWord);
end;

// RVAddictSpell31.OnParserIgnoreWord: if Ignore All or Add buttons were pressed
// in spellchecker dialog, removing underlines from the ignored word
procedure TfrmRVEditor.RVAddictSpell31ParserIgnoreWord(Sender: TObject;
  Before: Boolean; State: Integer);
begin
  if not Before and (State in [IgnoreState_IgnoreAll, IgnoreState_Add]) then
    RichViewEdit1.LiveSpellingValidateWord(RVAddictSpell31.CurrentWord);
end;

// Besides, if you want spelling check starting when loading document, call
// RichViewEdit1.StartLiveSpelling in rvActionFileOpen.OnOpenFile event
*)

{------------------ Zoom, paper format, units combo-boxes ---------------------}
// Applying zooming
procedure TfrmRVEditor.ListZoomChange(Sender: TObject);
var procent : Integer;
begin
  procent:= StrToIntDef(dxListZoom.Text, 0);
  if procent > 0 then
    SRichViewEdit1.ViewProperty.ZoomPercent:= procent
  else
    if dxListZoom.Text = 'Na šíøku' then
      SRichViewEdit1.ViewProperty.ZoomMode:= rvzmPageWidth
    else if dxListZoom.Text = 'Celá strana' then
      SRichViewEdit1.ViewProperty.ZoomMode:= rvzmFullPage;
  RememberZoomMode := SRichViewEdit1.ViewProperty.ZoomMode;
  RememberZoomPercent := SRichViewEdit1.ViewProperty.ZoomPercent;
end;
// Applying paper format
procedure TfrmRVEditor.ListFormatChange(Sender: TObject);
var text : String;
begin
  text:= trim(dxListFormat.Text);
  if text = 'A0' then SRichViewEdit1.PageProperty.FormatMode:= srvfmA0;
  if text = 'A1' then SRichViewEdit1.PageProperty.FormatMode:= srvfmA1;
  if text = 'A2' then SRichViewEdit1.PageProperty.FormatMode:= srvfmA2;
  if text = 'A3' then SRichViewEdit1.PageProperty.FormatMode:= srvfmA3;
  if text = 'A4' then SRichViewEdit1.PageProperty.FormatMode:= srvfmA4;
  if text = 'A5' then SRichViewEdit1.PageProperty.FormatMode:= srvfmA5;
  if text = 'A6' then SRichViewEdit1.PageProperty.FormatMode:= srvfmA6;
  if text = 'Letter' then SRichViewEdit1.PageProperty.FormatMode:= srvfmLetter;
  if text = 'Legal' then SRichViewEdit1.PageProperty.FormatMode:= srvfmLegal;
end;
// Applying units
procedure TfrmRVEditor.ListUnitsChange(Sender: TObject);
var
     RulerUnit : TRulerUnits;
     SRVUnit : TRVUnits;
begin
  case dxListUnits.ItemIndex of
    1 :
      begin
        RulerUnit := ruMillimeters;
        SRVUnit := rvuMillimeters;
      end;
    2 :
      begin
        RulerUnit := ruCentimeters;
        SRVUnit := rvuCentimeters;
      end;
    3 :
      begin
        RulerUnit := ruPicas;
        SRVUnit := rvuPicas;
      end;
    4 :
      begin
        RulerUnit := ruPixels;
        SRVUnit := rvuPixels;
      end;
    5 :
      begin
        RulerUnit := ruPoints;
        SRVUnit := rvuPoints;
      end;
  else
    begin
      RulerUnit := ruInches;
      SRVUnit := rvuInches;
    end;
  end;
  SRichViewEdit1.UnitsProgram := SRVUnit;
  SclRVRuler1.UnitsDisplay := RulerUnit;
  SclRVRuler2.UnitsDisplay := RulerUnit;
end;
{------------------------------ Status bar ------------------------------------}
procedure TfrmRVEditor.SRichViewEdit1CurrentPageChange(Sender: TObject);
begin
  stat1.Panels.Items[1].Text :=
    'Strana '+IntToStr(SRichViewEdit1.CurrentPage) + ' z ' +
    IntToStr(SRichViewEdit1.PageCount);
end;

procedure TfrmRVEditor.SRichViewEdit1PageScrolled(Sender: TObject);
begin
  stat1.Panels.Items[0].Text  := 'Strana ' + IntToStr(SRichViewEdit1.ScrolledPage);
end;

procedure TfrmRVEditor.SRichViewEdit1CaretMove(Sender: TObject);
var Line, Column : Integer;
begin
  SRichViewEdit1.GetCurrentLineCol(Line, Column);
  stat1.Panels.Items[2].Text := 'Øádek ' + IntToStr(Line);
  stat1.Panels.Items[3].Text := 'Sloupec ' + IntToStr(Column);
end;
{--------------------- Buttons on scroll-bars ---------------------------------}
// On horizontal scroll bar (view modes)
procedure TfrmRVEditor.SRichViewEdit1HMenuClickButton(Sender: TObject;
  ToolButton: TSRVToolButton);
begin
  HToolButton := ToolButton;
  if ToolButton = nil then Exit;
  SRichViewEdit1.CanUpdate := False;
  case (ToolButton.Index) of
    0 : PageMode(SRichViewEdit1);
    1 : WebMode(SRichViewEdit1);
    2 : PagesMode(SRichViewEdit1);
  end;
  SRichViewEdit1.CanUpdate := True;
end;
// On vertical scroll bar
procedure TfrmRVEditor.SRichViewEdit1VMenuClickButton(Sender: TObject;
  ToolButton: TSRVToolButton);
var
     sbX, sbY, W, H : Integer;
     p : TPoint;
begin
  if ToolButton = nil then Exit;
  case ToolButton.Index of
    0 :  // "Up arrows" button, performs search to the top
      begin
        if VToolButton = nil then
          SRichViewEdit1.PriorCurPage
        else
          case VToolButton.Index of
            0 : SRichViewEdit1.PriorCurPage;
            1 : SRichViewEdit1.PriorCurItem([rvsTable]);
            2 : SRichViewEdit1.PriorCurItem([rvsPicture, rvsHotspot, rvsHotPicture]);
            3 : SRichViewEdit1.PriorCurItem([rvsHeading]);
            4 : SRichViewEdit1.PriorCurHyperlink;
            6 :
              begin
                fd.Options := fd.Options - [frDown];
                fdFind(nil);
              end;
          end;
      end;
    1 : // "Circle" button, shows tool window
      begin
        W := srvtlwndw1.getWidth;
        H := srvtlwndw1.getHeight;
        sbX := SRichViewEdit1.MenuVertical.SRVToolBar.Width;
        sbY := SRichViewEdit1.MenuVertical.SRVToolBar.Height div 3;

        p := SRichViewEdit1.MenuVertical.SRVToolBar.ClientToScreen(Point(0, 0));
        p.Y := p.Y + sbY;
        if p.X + W < Screen.DesktopWidth then
          begin
            if p.Y + H < Screen.DesktopHeight then
              begin
                // top left
                p.Y := p.Y + sbY;
                srvtlwndw1.AlignText := srvatBottom;
              end
            else
              begin
                // bottom left
                p.Y := p.Y - H;
                srvtlwndw1.AlignText := srvatTop;
              end;
          end
        else
          begin
            p.X := p.X - (W - sbX);
            if p.Y + H < Screen.DesktopHeight then
              begin
                // top right
                p.Y := p.Y + sbY;
                srvtlwndw1.AlignText := srvatBottom;
              end
            else
              begin
                // bottom right
                p.Y := p.Y - H;
                srvtlwndw1.AlignText := srvatTop;
              end;
          end;
        srvtlwndw1.Execute(p.X, p.Y);
      end;
    2 : // "Down arrows" button, performs search to the bottom
      begin
        if VToolButton = nil then
          SRichViewEdit1.NextCurPage
        else
          case VToolButton.Index of
            0 : SRichViewEdit1.NextCurPage;
            1 : SRichViewEdit1.NextCurItem([rvsTable]);
            2 : SRichViewEdit1.NextCurItem([rvsPicture, rvsHotspot, rvsHotPicture]);
            3 : SRichViewEdit1.NextCurItem([rvsHeading]);
            4 : SRichViewEdit1.NextCurHyperlink;
            6 :
              begin
                fd.Options := fd.Options + [frDown];
                fdFind(nil);
              end;
          end;
      end;
  end;
end;

// Button on the tool window is clicked
procedure TfrmRVEditor.srvtlwndw1ClickButton(Sender: TObject;
  ToolButton: TSRVToolButton);
var
     s: String;
     posit: Integer;
begin
  VToolButton := ToolButton;
  if ToolButton = nil then Exit;
  if ToolButton.Index = 6 then // starting text search
    begin
      SRichViewEdit1.SetFocus;
      fd.CloseDialog;
      if SRichViewEdit1.RichViewEdit.SelectionExists then
        begin
          s := SRichViewEdit1.RichViewEdit.GetSelText;
          posit := Pos(#13,s);
          if posit<>0 then
            s := Copy(s,1,posit-1);
          fd.FindText := s;
        end;
      fd.Execute;
    end
  else // starting search
    SRichViewEdit1VMenuClickButton(Sender,
      TSRVToolButton(SRichViewEdit1.MenuVButtons.Items[2]));
end;
// text search
procedure TfrmRVEditor.fdFind(Sender: TObject);
begin
  if not SRichViewEdit1.RichViewEdit.SearchText(fd.FindText,GetRVESearchOptions(fd.Options)) then
    ShowInfo('String not found','Search and Replace');
  SRichViewEdit1.Repaint;
end;
{------------------------------- Printing -------------------------------------}
//  Double clicking on the rulers' margins shows the page setup dialog
procedure TfrmRVEditor.SclRVRuler1MarginDblClick(Sender: TObject;
  Margin: TMarginType);
begin
  mitPageSetupClick(nil);
end;

// File | Page Setup
procedure TfrmRVEditor.mitPageSetupClick(Sender: TObject);
begin
  SRichViewEdit1.CanUpdate := FALSE;

  With FPageProperty do
    begin
      PageLeft.Text := FloatToStr(Round(SRichViewEdit1.PageProperty.PageLeft * 100) * 0.01);
      PageRight.Text := FloatToStr(Round(SRichViewEdit1.PageProperty.PageRight * 100) * 0.01);

      PageTop.Text := FloatToStr(Round(SRichViewEdit1.PageProperty.PageTop * 100) * 0.01);
      PageBottom.Text := FloatToStr(Round(SRichViewEdit1.PageProperty.PageBottom * 100) * 0.01);

      if SRichViewEdit1.PageProperty.Orientation = poPortrait then
        begin
          RadioGroup1.ItemIndex := 0;
        end
      else
        begin
          RadioGroup1.ItemIndex := 1;
        end;

      case SRichViewEdit1.PageProperty.FormatMode of
        srvfmA4: ListPaper.ItemIndex := 0;
        srvfmA5: ListPaper.ItemIndex := 1;
      else
        ListPaper.ItemIndex := 0;
      end;
    end;

  if FPageProperty.ShowModal = mrOK then
    begin
      With FPageProperty do
        begin
          SRichViewEdit1.SetMarginUnit(StrToFloat(Trim(PageLeft.Text)),
                                       StrToFloat(Trim(PageTop.Text)),
                                       StrToFloat(Trim(PageRight.Text)),
                                       StrToFloat(Trim(PageBottom.Text)));
{          SRichViewEdit1.SetMarginMM(Round(PageLeft.Value),
                                 Round(PageTop.Value),
                                 Round(PageRight.Value),
                                 Round(PageBottom.Value));}
          SclRVRuler1.Scrolled;
          SclRVRuler2.Scrolled;

          if RadioGroup1.ItemIndex = 0 then
            begin
              if SRichViewEdit1.PageProperty.Orientation <> poPortrait then
                SRichViewEdit1.PageProperty.Orientation := poPortrait;
            end
          else
            begin
              if SRichViewEdit1.PageProperty.Orientation <> poLandscape then
                SRichViewEdit1.PageProperty.Orientation := poLandscape;
            end;

          case ListPaper.ItemIndex of
            0 : if SRichViewEdit1.PageProperty.FormatMode <> srvfmA4 then
                  SRichViewEdit1.PageProperty.FormatMode := srvfmA4;
            1 : if SRichViewEdit1.PageProperty.FormatMode <> srvfmA5 then
                  SRichViewEdit1.PageProperty.FormatMode := srvfmA5;
          end;
        end;
    end;
  SRichViewEdit1.CanUpdate := TRUE;
end;
// File | Print
procedure TfrmRVEditor.mitPrintClick(Sender: TObject);
begin
  if PrintDialog1.Execute then
    btnQuickPrintClick(nil);
end;
// "Quick Print" tool button
procedure TfrmRVEditor.btnQuickPrintClick(Sender: TObject);
begin
  if HToolButton <> nil then
    begin
      SRichViewEdit1.CanUpdate := False;
      PagesMode(SRichViewEdit1);
      SRichViewEdit1.PrintAll;
      SRichViewEdit1HMenuClickButton(SRichViewEdit1, HToolButton);
    end
  else
    SRichViewEdit1.PrintAll;
end;
// "Preview" tool button
procedure TfrmRVEditor.btnPreviewClick(Sender: TObject);
begin
  if SRichViewEdit1.ViewProperty.ViewMode = srvvmEditMode then
    SRichViewEdit1.ViewProperty.ViewMode := srvvmPreviewMode
  else
    SRichViewEdit1.ViewProperty.ViewMode := srvvmEditMode;
  dxBtnNahled.Down := SRichViewEdit1.ViewProperty.ViewMode = srvvmPreviewMode;
end;

// Displaying hints in status bar
procedure TfrmRVEditor.ApplicationHint(Sender: TObject);
var s: String;
begin
  s := GetLongHint(Application.Hint);
  stat1.SimplePanel := s<>'';
  stat1.SimpleText := s;
  stat1.Repaint;
end;
// Showing/hiding page scroller
procedure TfrmRVEditor.ToggleThumbnails(Show: Boolean);
begin
  if Show then
    SRVPageScroll1.SRichViewEdit := SRichViewEdit1
  else
    SRVPageScroll1.SRichViewEdit := nil;
  SRVPageScroll1.Visible := Show;
  Splitter1.Visible := Show;
end;

procedure TfrmRVEditor.btnThumbnailsClick(Sender: TObject);
begin
  ToggleThumbnails(dxBtnMiniatury.Down);
end;

initialization

{$IFDEF USE_GIFIMAGE}
  RegisterClasses([TGifImage]);
  // uncomment the line below if Gif does not appear in Insert | Image
  //TPicture.RegisterFileFormat('gif', 'Gif Image', TGifImage);
  RV_RegisterHTMLGraphicFormat(TGifImage);
{$ENDIF}
{$IFDEF USE_PNGOBJECT}
  RegisterClass(TPngObject);
  RV_RegisterHTMLGraphicFormat(TPngObject);
  RV_RegisterPngGraphic(TPngObject);
{$ENDIF}
  RVA_GetRichViewEditFromPopupComponent := 
   SRVGetRichViewEditFromPopupComponent;

end.

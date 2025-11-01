
{*******************************************************}
{                                                       }
{       RichViewActions                                 }
{       Datamodule with RichViewActions.                }
{       Used to set default property values for         }
{       actions.                                        }
{                                                       }
{       Copyright (c) 2002-2007, Sergey Tkachenko       }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

{
  It's not recommended to use this module in your applications directly -
  create your own ActionManager with richviewactions instead.
}

unit dmActionsRV;

interface

uses
  SysUtils, Classes, Forms, ActnList, ImgList, Controls, StdActns, RichViewActions;

type
  TrvActionsItems = class(TDataModule)
    ActionList1: TActionList;
    rvActionCut1: TrvActionCut;
    rvActionCopy1: TrvActionCopy;
    rvActionPaste1: TrvActionPaste;
    rvActionUndo1: TrvActionUndo;
    rvActionRedo1: TrvActionRedo;
    rvActionFontBold1: TrvActionFontBold;
    rvActionFontItalic1: TrvActionFontItalic;
    rvActionInsertTable1: TrvActionInsertTable;
    rvActionFontUnderline1: TrvActionFontUnderline;
    rvActionFontStrikeout1: TrvActionFontStrikeout;
    rvActionPrintPreview1: TrvActionPrintPreview;
    rvActionPrint1: TrvActionPrint;
    rvActionWordWrap1: TrvActionWordWrap;
    rvActionNew1: TrvActionNew;
    ImageList1: TImageList;
    rvActionFonts1: TrvActionFonts;
    rvActionAlignLeft1: TrvActionAlignLeft;
    rvActionAlignRight1: TrvActionAlignRight;
    rvActionAlignCenter: TrvActionAlignCenter;
    rvActionSelectAll1: TrvActionSelectAll;
    rvActionIndentInc1: TrvActionIndentInc;
    rvActionIndentDec1: TrvActionIndentDec;
    rvActionTableInsertRowsAbove1: TrvActionTableInsertRowsAbove;
    rvActionTableInsertRowsBelow1: TrvActionTableInsertRowsBelow;
    rvActionAlignJustify1: TrvActionAlignJustify;
    rvActionTableInsertColLeft1: TrvActionTableInsertColLeft;
    rvActionTableInsertColRight1: TrvActionTableInsertColRight;
    rvActionTableDeleteRows1: TrvActionTableDeleteRows;
    rvActionTableDeleteCols1: TrvActionTableDeleteCols;
    rvActionQuickPrint1: TrvActionQuickPrint;
    rvActionTableMergeCells1: TrvActionTableMergeCells;
    rvActionTableSplitCells1: TrvActionTableSplitCells;
    rvActionTableSelectTable1: TrvActionTableSelectTable;
    rvActionTableSelectRows1: TrvActionTableSelectRows;
    rvActionTableSelectCols1: TrvActionTableSelectCols;
    rvActionTableSelectCell1: TrvActionTableSelectCell;
    rvActionFontGrow1: TrvActionFontGrow;
    rvActionFontShrink1: TrvActionFontShrink;
    rvActionFontGrowOnePoint1: TrvActionFontGrowOnePoint;
    rvActionFontShrinkOnePoint1: TrvActionFontShrinkOnePoint;
    rvActionFontAllCaps1: TrvActionFontAllCaps;
    rvActionFontOverline1: TrvActionFontOverline;
    rvActionFind1: TrvActionFind;
    rvActionFindNext1: TrvActionFindNext;
    rvActionReplace1: TrvActionReplace;
    rvActionFontColor1: TrvActionFontColor;
    rvActionFontBackColor1: TrvActionFontBackColor;
    rvActionParaColor1: TrvActionParaColor;
    rvActionColor1: TrvActionColor;
    rvActionTableDeleteTable1: TrvActionTableDeleteTable;
    rvActionParagraph1: TrvActionParagraph;
    rvActionFontEx1: TrvActionFontEx;
    rvActionFillColor1: TrvActionFillColor;
    rvActionSave1: TrvActionSave;
    rvActionSaveAs1: TrvActionSaveAs;
    rvActionOpen1: TrvActionOpen;
    rvActionExport1: TrvActionExport;
    rvActionInsertFile1: TrvActionInsertFile;
    rvActionInsertPicture1: TrvActionInsertPicture;
    rvActionPasteSpecial1: TrvActionPasteSpecial;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  rvActionsItems: TrvActionsItems;

implementation

{$R *.dfm}



end.

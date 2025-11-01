{ 11.5.2021 11:27:10 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in 4268 - zmeny v btnSaveFileClick  }
{ 11.1.2017 14:28:46 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 1912 - zmena v btnSaveFileClick  }
{ 26.9.2016 14:42:15 (GMT+2:00) > [pinkava on WIN-48QDB6JAV23] checked in 1628 - nove EIInitOpenDlgImport  }
{ 17.10.2012 13:17:12 (GMT+2:00) > [marek] checked in Vymena ImageListu za cxImageList, vymena ikony.  }
{ 26.9.2012 15:54:37 (GMT+2:00) > [pinkava on PINKAVA-XP1] checked in Uprava v  MsgBox  }
{ 14.4.2009 15:51:34 (GMT+2:00) > [mik] checked in Oprava odeslani mailem cizojazycne varianty  }
{ 3.11.2008 11:46:00 (GMT+1:00) > [mik on MIK-VIRTUAL2007] checked in Oprava odeslani e-mailu  }
{ 21.12.2006 9:45:49 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 6.11.2006 16:08:57 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 11:25:19 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 10:27:22 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 17.10.2005 11:43:55 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 12.10.2005 16:21:18 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 6.10.2005 10:48:12 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 3.10.2005 11:20:09 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 26.9.2005 15:03:02 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 25.9.2005 18:47:48 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 20.9.2005 14:53:17 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 2.9.2005 15:57:11 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 25.8.2005 11:19:10 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 20.8.2005 10:41:50 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 24.6.2005 14:36:48 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 14.6.2005 10:16:11 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:28:01 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 3.6.2005 9:35:51 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
unit EPdfView;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ActnList, OleCtrls,  FPDFView, FUtils,
  ImgList, dxBar, mxStatusBar, ExtCtrls, XPMan, Main, Res_FA, cxClasses,
  dxSkinsCore, dxSkinCaramel, dxSkinFoggy, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinsdxBarPainter, cxGraphics;

procedure ViewPdfFile(const AFileName: string; AReportSettings: TReportSettings;
  const ACaption: string =''; AStandaloneFile: Boolean =false);
procedure PrintPdfFile(const AFileName, ACaption: string; AWithDialog: boolean);

type
  TfmPdfViewer = class(TForm)
    StatusBar: TmxStatusBar;
    dxBarManager1: TdxBarManager;
    btnPrint: TdxBarButton;
    btnNext: TdxBarButton;
    btnPrev: TdxBarButton;
    btnFirst: TdxBarButton;
    btnLast: TdxBarButton;
    btnActualSize: TdxBarButton;
    btnZoom: TdxBarCombo;
    btnFitPage: TdxBarButton;
    btnFitWidth: TdxBarButton;
    btnPrintDialog: TdxBarButton;
    ScrollBox1: TScrollBox;
    paRender: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    PaintBox: TPaintBox;
    miFirstPage: TdxBarButton;
    miPrevPage: TdxBarButton;
    miNextPage: TdxBarButton;
    miLastPage: TdxBarButton;
    btnSendEmail: TdxBarButton;
    btnSaveFile: TdxBarButton;
    SaveDialog1: TSaveDialog;
    cxImageList1: TcxImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnZoomChange(Sender: TObject);
    procedure btnActualSizeClick(Sender: TObject);
    procedure btnFitPageClick(Sender: TObject);
    procedure btnFitWidthClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnPrintDialogClick(Sender: TObject);
    procedure btnSendEmailClick(Sender: TObject);
    procedure btnSaveFileClick(Sender: TObject);
    procedure SetBtnDown(ABtnIndex: integer);
  private
    FIsPrinting:boolean;
    FTestInfo: string;
    FPageZoom: integer; //0...FitPage, 1...FitWidth, >1...proc.size
    FIsRendering: boolean;

    procedure SetRenderAreaPosition;
    procedure RenderPage;
    procedure UpdateToolBar;
    procedure UpdateStatusBar;
    procedure GoFirstPage;
    procedure GoPrevPage;
    procedure GoNextPage;
    procedure GoLastPage;
    procedure ShowFitPage;
    procedure ShowFitWidth;
    procedure ShowActualSize(AProcSize: integer);

    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;

    procedure PrintPdf(AWithDialog: boolean = FALSE);
    //test
    {function CreateTestInfoEmail(): boolean;}
  public
    FFileName: string;
    FStandaloneFile: Boolean;
    procedure OpenFile(const AFileName: string;
      AReportSettings: TReportSettings);
  end;

var
  fmPdfViewer: TfmPdfViewer;

  FPdfDoc:Pointer;
  FPageList:TList;
  FCurrPage:Integer;
  FMaxPage:Integer;
  FFileName:string;

implementation


uses
  IniFiles, Variants,
  {$IFNDEF STANDALONE}
  DataModGlobObj,
  {$ENDIF STANDALONE}
  ComObj, ShellApi, FCommonUtils, JCLMApi, Math, Printers, EPdfPrintDlg,
  SpolFunkce, JclFileUtils;

{$R *.dfm}

const
  sNoDefZoom = '----';
  cZoom100Index = 5;

procedure OpenPdfFile(const AFileName: string);
var
  i:integer;
begin
  FPdfDoc:=FPDF_LoadDocument(PChar(AFileName),'');
  FPageList.Clear;
  FMaxPage:=FPDF_GetPageCount(FPdfDoc)-1;
  for i:=0 to FPDF_GetPageCount(FPdfDoc)-1 do
    FPageList.Add(FPDF_LoadPage(FPdfDoc,i));
  FCurrPage:=0;
end;

procedure ClosePdfFile;
var
  i: integer;
begin
  for i :=0 to FPageList.Count-1 do
    FPDF_ClosePage(FPageList[i]);
  FPDF_CloseDocument(FPdfDoc);
  FMaxPage:=-1;
  FCurrPage:=-1;
end;

procedure ViewPdfFile(const AFileName: string; AReportSettings: TReportSettings;
  const ACaption: string =''; AStandaloneFile: Boolean =false);
begin
  fmPdfViewer:=TfmPdfViewer.Create(nil);
  try
    fmPdfViewer.Caption:=sCaptionNahled;
    if ACaption<>'' then
      fmPdfViewer.Caption:=sCaptionNahled+': '+ACaption;
    fmPdfViewer.FFileName := AFileName;
    fmPdfViewer.FStandaloneFile := AStandaloneFile;
    fmPdfViewer.FPageZoom := 100;
    fmPdfViewer.OpenFile(AFileName,AReportSettings);
    fmPdfViewer.ShowModal;
  finally
    fmPdfViewer.Free;
    fmPdfViewer:=nil;
  end;
end;

procedure SetPagesSL(var APagesString: string; var sl: TstringList);
var
  a,b,c: string;
  i,j: integer;
begin
  sl.Clear;
  if APagesString = '-1' then begin //vsechny
    for i:=0 to FMaxPage do
      sl.Add(IntToStr(i+1));
  end
  else if APagesString = '-2' then begin //aktualni
     sl.Add(IntToStr(FCurrPage+1));
  end
  else if APagesString = '-3' then begin //liche
    for i:=0 to (FMaxPage div 2) do
      sl.Add(IntToStr(i*2+1));
  end
  else if APagesString = '-4' then begin //sude
    for i:=0 to (FMaxPage div 2) do
      sl.Add(IntToStr(i*2+2));
  end
  else begin
    APagesString:=Replace(' ',APagesString,'');
    for i:=0 to CountListItems(APagesString)-1 do begin
      if IsInteger(GetListItem(APagesString,i)) then
        sl.Add(GetListItem(APagesString,i))
      else begin
        a:=GetListItem(APagesString,i);
        if Pos('-',a)>0 then begin
          b:=Copy(a,1,Pos('-',a)-1);
          c:=Copy(a,Pos('-',a)+1,maxint);
          if IsInteger(b) and IsInteger(c) then
            for j:=StrToInt(b) to StrToInt(c) do
              sl.Add(IntToStr(j));
        end;
      end;
    end;
  end;
end;

procedure PrintPdfDirect(AWithDialog: boolean; const ACaption: string);
var
  i, size_x,size_y,pgListIndexMax:integer;
  page_width,page_height:double;
  logpx,logpy:double;
  viewx,viewy,posunx,posuny:integer;
  APagesString: string;
  sl: TstringList;
  procedure GetDeviceInformation;
  begin
    try
      logpx := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
      logpy := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
      viewx := Printer.PageWidth;
      viewy := Printer.PageHeight;
    except
      on E: EPrinter do begin
        MessageErr(sMsgPrintCaption, Format(sMsgErrPrinter,[E.Message]), [MBOK]);
      end;
    end;
  end;
begin
  APagesString:='-1';
  if not AWithDialog or OpenPdfPrintDlg(APagesString, FALSE) then begin
    StartWait;
    sl:= TstringList.Create;
    try try
      Printer.Title:=ACaption;
      SetPagesSL(APagesString,sl);
      pgListIndexMax:=FPageList.Count-1;
      //nastaveni orientace
      if sl.Count>0 then begin
        page_height:=FPDF_GetPageHeight(FPageList[Min(StrToInt(sl[0])-1,pgListIndexMax)]);
        page_width:=FPDF_GetPageWidth(FPageList[Min(StrToInt(sl[0])-1,pgListIndexMax)]);
        if page_height>=page_width then
          Printer.Orientation := poPortrait
        else
          Printer.Orientation := poLandscape;
      end;
      GetDeviceInformation;
      Printer.BeginDoc;
      for i:= 0 to sl.Count-1 do begin
        page_height:=FPDF_GetPageHeight(FPageList[Min(StrToInt(sl[i])-1,pgListIndexMax)]);
        page_width:=FPDF_GetPageWidth(FPageList[Min(StrToInt(sl[i])-1,pgListIndexMax)]);
        if (page_height>=page_width) and
          (Printer.Orientation<>poPortrait) then begin
          Printer.EndDoc;
          Printer.Orientation := poPortrait;
          GetDeviceInformation;
          Printer.BeginDoc;
        end
        else if (page_height<page_width) and
          (Printer.Orientation<>poLandscape) then begin
          Printer.EndDoc;
          Printer.Orientation := poLandscape;
          GetDeviceInformation;
          Printer.BeginDoc;
        end
        else if i>0 then
          Printer.NewPage;
        // convert points into pixels
        size_x := Round((page_width / 72) * logpx);
        size_y := Round((page_height / 72) * logpy);
        posunx:= round((size_x-viewx) / 2);
        posuny:= round((size_y-viewy) / 2);
        FPDF_RenderPage(Printer.Canvas.Handle,FPageList[Min(StrToInt(sl[i])-1,pgListIndexMax)],-posunx,-posuny,size_x,size_y,0,FPDF_PRINT);
      end;
      Printer.EndDoc;
      //
    except
      on E: EPrinter do begin
        MessageErr(sMsgPrintCaption, Format(sMsgErrPrinter,[E.Message]), [MBOK]);
      end;
    end;
    finally
      sl.Free;
      StopWait;
    end;
  end;
end;

procedure PrintPdfFile(const AFileName, ACaption: string; AWithDialog: boolean);
begin
  fmPdfViewer:=TfmPdfViewer.Create(nil);
  FPageList:=TList.Create();
  try
    fmPdfViewer.Caption:=sCaptionNahled;
    if ACaption<>'' then
      fmPdfViewer.Caption:=sCaptionNahled+': '+ACaption;
    //
    FCurrPage:=-1;
    FMaxPage:=-1;
    OpenPdfFile(AFileName);
    try
      PrintPdfDirect(AWithDialog, ACaption);
    finally
      ClosePdfFile;
    end;
  finally
    FPageList.Free;
    FPageList:=nil;
    fmPdfViewer.Free;
    fmPdfViewer:=nil;
  end;
end;

procedure TfmPdfViewer.FormCreate(Sender: TObject);
var
  sz: integer;
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
  FTestInfo:='';
  sz := GetSizeOfFile(NormalPath(ExtractFilePath(ParamStr(0)))+'fpdfview.dll');
  if sz = 1839104 then
    FPDF_UnlockDLL('SDKRDYX1615','2F8E0A082996A46F554DA3ECC8490D8713D85285') //2007
  else
    FPDF_UnlockDLL('SDKRDYX1615','6BA5915AE99622C57073B1DE779B20390543EAEC');
  FPageList:=TList.Create();
  FCurrPage:=-1;
  FIsPrinting:=FALSE;
  FIsRendering:=FALSE;
end;

procedure TfmPdfViewer.FormDestroy(Sender: TObject);
begin
  FPageList.Free;
  FPageList:=nil;
end;

procedure TfmPdfViewer.SetRenderAreaPosition;
const
  cFrameSize = 4;
begin
  ScrollBox1.VertScrollBar.Position:=0;
  ScrollBox1.HorzScrollBar.Position:=0;
  if (FPageZoom=1) or (paRender.Width>
    (ScrollBox1.ClientRect.Right-ScrollBox1.ClientRect.Left+
    cFrameSize*2)) then begin
    paRender.Left:=cFrameSize;
    paRender.Top:=cFrameSize;
  end
  else begin
    paRender.Left:=((ScrollBox1.ClientRect.Right-ScrollBox1.ClientRect.Left+
    cFrameSize)-paRender.Width) div 2;
    paRender.Top:=cFrameSize;
  end;
  ScrollBox1.VertScrollBar.Position:=0;
  ScrollBox1.HorzScrollBar.Position:=0;
end;

procedure TfmPdfViewer.RenderPage;
const
  cBorderSize = 2;
  cFrameSize = 4;
var size_x,size_y:integer;
  pageWidth,pageHeight, m, m1, m2:double;
  logpx,logpy:double;

  (*procedure RenderPaintBox;
  var
    dc:HDC;
    notused:HWND;
    tempCanvas:TCanvas;
    sourceRect, destRect: TRect;
    cap,capo:integer;
    puffer :HBitmap;
  begin
    tempCanvas:=TCanvas.Create();
    dc:=GetDC(0);
    try
      destRect := Rect(0,0,PaintBox.Width,PaintBox.Height);
      sourceRect := Rect(0,0,PaintBox.Width,PaintBox.Height);
      tempCanvas.Handle:=CreateCompatibleDC(dc);
      puffer := CreateCompatibleBitmap(dc,PaintBox.Width,PaintBox.Height);
      SelectObject(tempCanvas.Handle,puffer);
      ReleaseDC(0,dc);
      tempCanvas.Brush.Color:=clWhite;
      tempCanvas.FillRect(destRect);
      tempCanvas.CopyMode := cmSrcCopy;
      {FPDF_RenderPage(tempCanvas.Handle,FPageList[FCurrPage],0,0,
        PaintBox.Width,PaintBox.Height,0,0);}
      PaintBox.Canvas.CopyRect(destRect,tempCanvas,sourceRect);
    finally
      DeleteObject(puffer);
      DeleteDC(tempCanvas.Handle);
      tempCanvas.Free();
    end;
  end;*)

begin
  if FCurrPage>=0 then begin
    FIsRendering:=TRUE;
    try
      logpx := GetDeviceCaps(PaintBox.Canvas.Handle, LOGPIXELSX);
      logpy := GetDeviceCaps(PaintBox.Canvas.Handle, LOGPIXELSY);
      pageWidth := FPDF_GetPageWidth(FPageList[FCurrPage]);
      pageHeight := FPDF_GetPageHeight(FPageList[FCurrPage]);
      size_x := Round((pageWidth / 72) * logpx);
      size_y := Round((pageHeight / 72) * logpy);
      if FPageZoom=100 then begin //originalni velikost
        paRender.Width:=size_x + cBorderSize*2;
        paRender.Height:=size_y + cBorderSize*2;
      end
      else if FPageZoom>1 then begin //zvetseni/zmenseni
        paRender.Width:=(size_x*FPageZoom) div 100 + cBorderSize*2;
        paRender.Height:=(size_y*FPageZoom) div 100 + cBorderSize*2;
      end
      else if FPageZoom=1 then begin // fitWidth
        paRender.Width:=ScrollBox1.Width - cBorderSize*2 - cFrameSize*2 -16;
        paRender.Height:=Round(paRender.Width*size_y/size_x);
      end
      else if FPageZoom=0 then begin //fitPage
        m1:=size_x/(ScrollBox1.Width-cBorderSize*2-cFrameSize*2);
        m2:=size_y/(ScrollBox1.Height-cBorderSize*2-cFrameSize*2);
        m:=Max(m1,m2);
        paRender.Width:=Round(size_x/m);
        paRender.Height:=Round(size_y/m);
      end;
      {RenderPaintBox;}
      FPDF_RenderPage(PaintBox.Canvas.Handle,FPageList[FCurrPage],
        0,0,PaintBox.Width,PaintBox.Height,0,0);
    finally
      FIsRendering:=FALSE;
    end;
  end;
end;

procedure TfmPdfViewer.GoFirstPage;
begin
  FCurrPage:=0;
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
  UpdateToolBar;
  UpdateStatusBar;
end;

procedure TfmPdfViewer.GoPrevPage;
begin
  Dec(FCurrPage);
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
  UpdateToolBar;
  UpdateStatusBar;
end;

procedure TfmPdfViewer.GoNextPage;
begin
  Inc(FCurrPage);
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
  UpdateToolBar;
  UpdateStatusBar;
end;

procedure TfmPdfViewer.GoLastPage;
begin
  FCurrPage:=FMaxPage;
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
  UpdateToolBar;
  UpdateStatusBar;
end;

procedure TfmPdfViewer.ShowFitPage;
begin
  btnZoom.Text:=sNoDefZoom;
  FPageZoom:=0;
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
end;

procedure TfmPdfViewer.ShowFitWidth;
begin
  btnZoom.Text:=sNoDefZoom;
  FPageZoom:=1;
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
end;

procedure TfmPdfViewer.ShowActualSize(AProcSize: integer);
begin
  btnZoom.Text:=sNoDefZoom;
  FPageZoom:=AProcSize;
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
end;

procedure TfmPdfViewer.UpdateToolBar;
begin
  btnFirst.Enabled:=FCurrPage>0;
  btnPrev.Enabled:=FCurrPage>0;
  btnNext.Enabled:=FCurrPage<FMaxPage;
  btnLast.Enabled:=FCurrPage<FMaxPage;
end;

procedure TfmPdfViewer.OpenFile(const AFileName: string;
  AReportSettings: TReportSettings);
begin
  StartWait;
  try
    OpenPdfFile(AFileName);
    if FPageZoom=0 then
      ShowFitPage
    else if FPageZoom=1 then
      ShowFitWidth
    else
      ShowActualSize(FPageZoom);
    PaintBox.Visible:=TRUE;
    UpdateStatusBar;
    UpdateToolBar;
    {btnZoom.ItemIndex:=btnZoom.Items.Count-1;}
    StatusBar.Panels[3].ProgressBar.BoxCount:=FMaxPage+1;
    StatusBar.Panels[3].ProgressBar.Max:=FMaxPage+1;
    StatusBar.Panels[3].ProgressBar.Min:=0;
    StatusBar.Panels[3].ProgressBar.Position:=0;
    StatusBar.Panels[2].ImageIndex:=-1;
    if not FStandaloneFile and AReportSettings.UseSignature then begin
      StatusBar.Panels[1].ImageIndex:=12;
      StatusBar.Panels[1].Hint:=sMsgSignature+' '+
        AReportSettings.SignatureSubject;
    end
    else begin
      StatusBar.Panels[1].ImageIndex:=-1;
      StatusBar.Panels[1].Hint:='';
    end;
    // test
    AddStringLine(FTestInfo,AFileName);
  finally
    StopWait;
  end;
end;

procedure TfmPdfViewer.PrintPdf(AWithDialog: boolean);
var
  i, size_x,size_y,pgListIndexMax:integer;
  page_width,page_height:double;
  logpx,logpy:double;
  viewx,viewy,posunx,posuny:integer;
  APagesString: string;
  sl: TstringList;
  procedure GetDeviceInformation;
  begin
    logpx := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
    logpy := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
    viewx := Printer.PageWidth;
    viewy := Printer.PageHeight;
  end;
begin
  APagesString:='-1';
  if not AWithDialog or OpenPdfPrintDlg(APagesString, TRUE) then begin
    FIsPrinting:=TRUE;
    StartWait;
    sl:= TstringList.Create;
    try try
      StatusBar.Panels[3].ProgressBar.BoxCount:=FMaxPage+1;
      StatusBar.Panels[3].ProgressBar.Max:=FMaxPage+1;
      StatusBar.Panels[3].ProgressBar.Min:=0;
      StatusBar.Panels[3].ProgressBar.Position:=0;
      StatusBar.Panels[2].ImageIndex:=11;
      StatusBar.Panels[4].Alignment:=taLeftJustify;
      StatusBar.Panels[4].Text:=SMsgPrinting;
      //
      Printer.Title:=Caption;
      SetPagesSL(APagesString,sl);
      pgListIndexMax:=FPageList.Count-1;
      //nastaveni orientace
      if sl.Count>0 then begin
        page_height:=FPDF_GetPageHeight(FPageList[Min(StrToInt(sl[0])-1,pgListIndexMax)]);
        page_width:=FPDF_GetPageWidth(FPageList[Min(StrToInt(sl[0])-1,pgListIndexMax)]);
        if page_height>=page_width then
          Printer.Orientation := poPortrait
        else
          Printer.Orientation := poLandscape;
      end;
      GetDeviceInformation;
      Printer.BeginDoc;
      for i:= 0 to sl.Count-1 do begin
        StatusBar.Panels[3].ProgressBar.Position:=
          StatusBar.Panels[3].ProgressBar.Position+1;
        page_height:=FPDF_GetPageHeight(FPageList[Min(StrToInt(sl[i])-1,pgListIndexMax)]);
        page_width:=FPDF_GetPageWidth(FPageList[Min(StrToInt(sl[i])-1,pgListIndexMax)]);
        if (page_height>=page_width) and
          (Printer.Orientation<>poPortrait) then begin
          Printer.EndDoc;
          Printer.Orientation := poPortrait;
          GetDeviceInformation;
          Printer.BeginDoc;
        end
        else if (page_height<page_width) and
          (Printer.Orientation<>poLandscape) then begin
          Printer.EndDoc;
          Printer.Orientation := poLandscape;
          GetDeviceInformation;
          Printer.BeginDoc;
        end
        else if i>0 then
          Printer.NewPage;
        // convert points into pixels
        size_x := Round((page_width / 72) * logpx);
        size_y := Round((page_height / 72) * logpy);
        posunx:= round((size_x-viewx) / 2);
        posuny:= round((size_y-viewy) / 2);
        FPDF_RenderPage(Printer.Canvas.Handle,FPageList[Min(StrToInt(sl[i])-1,pgListIndexMax)],-posunx,-posuny,size_x,size_y,0,FPDF_PRINT);
      end;
      Printer.EndDoc;
      //
      StatusBar.Panels[3].ProgressBar.Position:=0;
      StatusBar.Panels[2].ImageIndex:=-1;
    except
      on E: EPrinter do begin
        MessageErr(Caption, Format(sMsgErrPrinter,[E.Message]), [MBOK]);
      end;
    end;
    finally
      StatusBar.Panels[4].Text:='';
      StatusBar.Panels[4].Alignment:=taRightJustify;
      FIsPrinting:=FALSE;
      sl.Free;
      StopWait;
    end;
  end;
end;

procedure TfmPdfViewer.LoadFormStateFromIni;
var iniFile: TMemIniFile;
  l,t: Integer;
begin
  if not FStandaloneFile then begin
    iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
    try
      Left:=iniFile.ReadInteger(Name, 'Left', GfaMain.Left);
      Top:=iniFile.ReadInteger(Name, 'Top', GfaMain.Top);
      Width:=iniFile.ReadInteger(Name, 'Width', GfaMain.Width);
      Height:=iniFile.ReadInteger(Name, 'Height', GfaMain.Height);
      l:=Left; t:=Top; CheckFormPosition(l,t,Width); Left:=l; Top:=t;
      FPageZoom:=iniFile.ReadInteger(Name, 'PageZoom', 1);
      if FPageZoom=0 then  //FitPage
        SetBtnDown(2)
      else if FPageZoom=1 then //FitWidth
        SetBtnDown(3)
      else begin
        if FPageZoom=100 then
          btnZoom.ItemIndex:=cZoom100Index;
    end;
    finally
      iniFile.Free;
    end;
  end
  else begin
    FPageZoom:=100;
    SetBtnDown(1);
    btnSendEmail.Visible:=ivNever;
  end;
end;

procedure TfmPdfViewer.SaveFormStateToIni;
var iniFile: TMemIniFile;
begin
  if not FStandaloneFile then begin
    if not GfaMain.CanWriteToIniFile then EXIT;
    iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
    try
      iniFile.WriteInteger(Name, 'Left', Left);
      iniFile.WriteInteger(Name, 'Top', Top);
      iniFile.WriteInteger(Name, 'Width', Width);
      iniFile.WriteInteger(Name, 'Height', Height);
      iniFile.WriteInteger(Name, 'PageZoom', FPageZoom);
      SaveMemIni(iniFile);
    finally
      iniFile.Free;
    end;
  end;
end;

procedure TfmPdfViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FIsRendering:=TRUE; //zakaze prekreslovani
  SaveFormStateToIni;
  PaintBox.Visible:=FALSE;
  ClosePdfFile;
  {$IFNDEF STANDALONE}
  //zruseni ikony v outlookbaru
  dmGlobObj.gFAllWindow.RemoveObj(Self);
  Application.MainForm.Perform(Msg_UpdateListWindow, 2, 0);
  {$ENDIF STANDALONE}
end;

procedure TfmPdfViewer.FormShow(Sender: TObject);
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
  lObj.WindowIcon := 14;
  lObj.WindowIconText := sCaptionNahled;
  dmGlobObj.gFAllWindow.AddObj(lObj);
  Application.MainForm.Perform(Msg_UpdateListWindow, 1, 0);
  {$ENDIF STANDALONE}
  LoadFormStateFromIni;
end;

procedure TfmPdfViewer.UpdateStatusBar;
begin
  StatusBar.Panels[0].Text:=format(sPage+' %d/%d',[FCurrPage+1,FMaxPage+1]);
end;

procedure TfmPdfViewer.btnFirstClick(Sender: TObject);
begin
  GoFirstPage;
end;

procedure TfmPdfViewer.btnLastClick(Sender: TObject);
begin
  GoLastPage;
end;

procedure TfmPdfViewer.btnPrevClick(Sender: TObject);
begin
  GoPrevPage;
end;

procedure TfmPdfViewer.btnNextClick(Sender: TObject);
begin
  GoNextPage;
end;

procedure TfmPdfViewer.btnZoomChange(Sender: TObject);
begin
  if btnZoom.Text<>sNoDefZoom then begin
    FPageZoom:=StrToInt(Replace('%',btnZoom.Text,''));
    paRender.Visible:=FALSE;
    try
      RenderPage;
      SetRenderAreaPosition;
    finally
      paRender.Visible:=TRUE;
    end;
  end;
  SetBtnDown(1);
end;

procedure TfmPdfViewer.btnActualSizeClick(Sender: TObject);
begin
  SetBtnDown(1);
  //
  btnZoom.ItemIndex:=cZoom100Index;
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
end;

procedure TfmPdfViewer.btnFitPageClick(Sender: TObject);
begin
  btnZoom.Text:=sNoDefZoom;
  FPageZoom:=0;
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
  SetBtnDown(2);
end;

procedure TfmPdfViewer.btnFitWidthClick(Sender: TObject);
begin
  btnZoom.Text:=sNoDefZoom;
  FPageZoom:=1;
  paRender.Visible:=FALSE;
  try
    RenderPage;
    SetRenderAreaPosition;
  finally
    paRender.Visible:=TRUE;
  end;
  SetBtnDown(3);
end;

procedure TfmPdfViewer.SetBtnDown(ABtnIndex: integer);
begin
  btnActualSize.Down:=false;
  btnFitPage.Down:=false;
  btnFitWidth.Down:=false;
  if ABtnIndex=1 then
    btnActualSize.Down:=true
  else if ABtnIndex=2 then
    btnFitPage.Down:=true
  else if ABtnIndex=3 then
    btnFitWidth.Down:=true;
end;

procedure TfmPdfViewer.btnPrintClick(Sender: TObject);
begin
  PrintPDF;
end;

procedure TfmPdfViewer.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if FIsPrinting then begin
    MessageInfo(Caption,sMsgIsPrinting,[MBOK]);
    CanClose:=FALSE;
  end
  else begin
    CanClose:=TRUE;
    FIsRendering:=TRUE; //nedovoli prekreslovani pri zavirani
  end;
end;

{function TfmPdfViewer.CreateTestInfoEmail(): boolean;
begin
  Result := TRUE;
  with TJclEmail.Create do try
    try
      Subject := 'Zprava o testovani prohlizece PDF';
//      Body := FTestInfo+#13#10#13#10+CreateProgramInfo;
      Recipients.Add('hotline@stereo.cz');
      Send(TRUE);
    except
      Result := FALSE;
    end;
  finally
    Free;
  end;
end;}

procedure TfmPdfViewer.PaintBoxPaint(Sender: TObject);
begin
  if not FIsRendering then
    RenderPage;
end;

procedure TfmPdfViewer.FormResize(Sender: TObject);
begin
  if PaintBox.Visible then begin
    paRender.Visible:=FALSE;
    try
      RenderPage;
      SetRenderAreaPosition;
    finally
      paRender.Visible:=TRUE;
    end;
  end;
end;

procedure TfmPdfViewer.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=Chr(27) then
   Close;
end;

procedure TfmPdfViewer.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  incr=5;
var
  pos,i: integer;
begin
  with ScrollBox1.VertScrollBar do begin
    if Visible then begin
      case Key of
        //Down
        40: begin
          if Position<Range then
            Position:=Position+incr;
        end;
        //Up
        38: begin
          if Position>1 then
            Position:=Position-incr;
        end;
        //PgDn
        34: begin
          pos:=Position;
          if Position<Range then
            Position:=Position+
              Round(((ScrollBox1.Height-10)/PaintBox.Height)*Range);
          if (Position=pos) and (FCurrPage<FMaxPage) then
            GoNextPage;
        end;
        //PgUp
        33: begin
          if (Position=0) and (FCurrPage>0) then begin
            GoPrevPage;
            Position:=Range;
          end
          else if Position>1 then
            Position:=Position-
              Round(((ScrollBox1.Height-10)/PaintBox.Height)*Range);
        end;
      end;
    end;
  end;
  with ScrollBox1.HorzScrollBar do begin
    if Visible then begin
      case Key of
        //Ctrl+Right
        39: begin
          if (GetKeyState(VK_CONTROL)<0) and (Position<Range) then
            Position:=Position+incr;
        end;
        //Ctrl+Left
        37: begin
          if (GetKeyState(VK_CONTROL)<0) and (Position>0) then
            Position:=Position-incr;
        end;
      end;
    end;
  end;
  {$IFNDEF STANDALONE}
  if Key=VK_F1 then
    Application.HelpSystem.ShowTopicHelp(Name,GetDataPrgPath+'FormStudio.chm');
  {$ENDIF STANDALONE}
  //
  case Key of
    //Ctrl+ Num+
    VK_ADD: begin
        if GetKeyState(VK_CONTROL)<0 then begin
          //kdyz neni velikost z komba tak nastavime 100%
          if btnZoom.Text=sNoDefZoom then
            btnZoom.ItemIndex:=cZoom100Index;
          //
          if btnZoom.ItemIndex>0 then
            btnZoom.ItemIndex:=btnZoom.ItemIndex-1;
        end;
      end;
    //Ctrl+ Num-
    VK_SUBTRACT: begin
        if GetKeyState(VK_CONTROL)<0 then begin
          //kdyz neni velikost z komba tak nastavime 100%
          if btnZoom.Text=sNoDefZoom then
            btnZoom.ItemIndex:=cZoom100Index;
          //
          if btnZoom.ItemIndex<btnZoom.Items.Count-2 then
            btnZoom.ItemIndex:=btnZoom.ItemIndex+1;
        end;
      end;
    //Ctrl+ Num0
    VK_NUMPAD0: begin
        btnZoom.ItemIndex:=cZoom100Index;
      end;
  end;

end;

procedure TfmPdfViewer.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const
  incr=5;
var
  pos: integer;
begin
  with ScrollBox1.VertScrollBar do begin
    if Visible then begin
      if WheelDelta<0 then begin
        pos:=Position;
        if Position<Range then
          Position:=Position+
            Round(((ScrollBox1.Height-10)/PaintBox.Height)*Range);
        if (Position=pos) and (FCurrPage<FMaxPage) then
          GoNextPage;
      end
      else begin
        if (Position=0) and (FCurrPage>0) then begin
          GoPrevPage;
          Position:=Range;
        end
        else if Position>1 then
          Position:=Position-
            Round(((ScrollBox1.Height-10)/PaintBox.Height)*Range);
      end;
    end;
  end;
end;

procedure TfmPdfViewer.btnPrintDialogClick(Sender: TObject);
begin
  PrintPdf(TRUE);
end;

procedure TfmPdfViewer.btnSendEmailClick(Sender: TObject);
var
  sl: TstringList;
  msg,mailadr,outfilename: string;
  isIdds: boolean;
  sel: Boolean;
begin
  sl := TstringList.Create;
  try
    sl.Add(FFileName);
    sel := GfaMain.SelectEmail(mailadr);
    if sel then begin
      isIdds:=Copy(mailadr,1,Length(cIDDS))=cIDDS;
      GfaMain.SendISDSOrEmail(mailadr, ChangeFileExt(ExtractFileName(FFileName),''),
        '', sl, TRUE, msg, outfilename);
     {$IFNDEF STANDALONE}
      GfaMain.WritePdfToDocs(SetValidFileNameTrim(GfaMain.mtDefName.Value),FFileName,
      FALSE,'',isIdds);
      {$ENDIF STANDALONE}
    end;
  finally
    sl.Free;
  end;
end;

procedure TfmPdfViewer.btnSaveFileClick(Sender: TObject);
var
  ms: TMemoryStream;
  comm, clientName: string;
begin
  with SaveDialog1 do begin
    if (GfaMain<>nil) and (GfaMain.FClientParam<>nil) then begin
      EIInitSaveDlgExport(SaveDialog1, VarToStr(GfaMain.FClientParam.Values['Description']));
    end;

    if FStandaloneFile then
      FileName:=ExtractFileName(FFileName)
    else begin
      //FileName:=SetValidFileNameTrim(GfaMain.mtDefName.Value)+cPDFDefaultExt;

      comm := '';
      clientName := '';
      if (GfaMain<>nil) and (GfaMain.mtValues.Active) then begin
        comm := GetListItem(GfaMain.GetPeriod, 3) + ' ' + GfaMain.GetSysComment;
        if comm <> '' then
          comm := ', ' + comm;
        clientName:=Copy(GfaMain.PrepareClientAdress,1,40);
      end;

      if (GfaMain<>nil) then
        FileName := SetValidFileNameTrim(Copy(GfaMain.mtDefName.Value,1,60) + comm + ' - ' + clientName + cPDFDefaultExt);
    end;
    if Execute then begin
      StartWait;
      ms:= TMemoryStream.Create;
      try
        ms.LoadFromFile(FFileName);
        ms.Seek(0, soFromBeginning);
        if ExtractFileExt(FileName)='' then
          FileName:=FileName+cPDFDefaultExt;
          if not FileExists(FileName) or
            (MessageAsk(Caption,Format(sMsgFileNotExistsAsk, [FileName]),
            [MBYES, MBNO]) = IDYES) then
            ms.SaveToFile(FileName);
      finally
        ms.Free;
        StopWait;
      end;
    end;
  end;
end;

end.

{ 13.9.2019 12:10:18 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 3.11.2006 16:27:44 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 3.11.2006 16:25:18 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 10:27:21 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 26.9.2005 15:02:59 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 24.9.2005 12:04:59 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 7.9.2005 16:12:37 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 2.9.2005 15:57:09 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 14.6.2005 10:33:39 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 3.6.2005 9:35:30 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
unit EPdfPrintDlg;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, cxMaskEdit, cxDropDownEdit, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxRadioGroup, cxGraphics, Res_FA,
  cxLookAndFeels, cxLookAndFeelPainters;

function OpenPdfPrintDlg(var APagesString: string; AIsCurrentPage: boolean): boolean;

type
  TfmPdfPrintDlg = class(TForm)
    btTisk: TButton;
    btStorno: TButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    GroupBox2: TGroupBox;
    rbVse: TcxRadioButton;
    rbVybrane: TcxRadioButton;
    edVybrane: TcxTextEdit;
    rbLiche: TcxRadioButton;
    rbSude: TcxRadioButton;
    rbAktualni: TcxRadioButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    btVlastnostiTiskarny: TButton;
    edTiskarna: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure btVlastnostiTiskarnyClick(Sender: TObject);
    procedure edVybraneEnter(Sender: TObject);
  private
  public
  end;

var
  fmPdfPrintDlg: TfmPdfPrintDlg;

implementation
{$R *.dfm}

uses Printers, Math, SpolFunkce;

function OpenPdfPrintDlg(var APagesString: string; AIsCurrentPage: boolean): boolean;
begin
  fmPdfPrintDlg:=TfmPdfPrintDlg.Create(nil);
  try
    fmPdfPrintDlg.rbAktualni.Enabled:=AIsCurrentPage;
    Result := fmPdfPrintDlg.ShowModal=MROK;
    if fmPdfPrintDlg.rbVse.Checked then
      APagesString:='-1'
    else if fmPdfPrintDlg.rbAktualni.Checked then
      APagesString:='-2'
    else if fmPdfPrintDlg.rbLiche.Checked then
      APagesString:='-3'
    else if fmPdfPrintDlg.rbSude.Checked then
      APagesString:='-4'
    else if fmPdfPrintDlg.rbVybrane.Checked then
      APagesString:=fmPdfPrintDlg.edVybrane.Text;
  finally
    fmPdfPrintDlg.Free;
    fmPdfPrintDlg:=nil;
  end;
end;

procedure TfmPdfPrintDlg.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
  if Printer.Printers.Count>1 then
    edTiskarna.Text := Printer.Printers[Printer.PrinterIndex];
end;

procedure TfmPdfPrintDlg.btVlastnostiTiskarnyClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
  try
    if Printer.Printers.Count>1 then
      edTiskarna.Text := Printer.Printers[Printer.PrinterIndex];
  except
    on E: EPrinter do begin
      MessageErr(Caption, Format(sMsgErrPrinter,[E.Message]), [MBOK]);
    end;
  end;
end;

procedure TfmPdfPrintDlg.edVybraneEnter(Sender: TObject);
begin
  rbVybrane.Checked := TRUE;
end;

end.
 

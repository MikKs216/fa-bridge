unit ESelectAdr;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RVStyle, RVScroll, RichView, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, ExtCtrls, cxDataStorage, ImgList,
  cxImageComboBox, cxContainer, cxCheckBox, Res_FA,
  Menus, cxLookAndFeelPainters,
  cxButtons, cxGridBandedTableView, cxGridDBBandedTableView, cxRadioGroup,
  cxLookAndFeels, cxTextEdit;

function SelectAdr(const ACaption: string;
  AShowMail: boolean; AShowDS: Boolean; AShowSave: Boolean;
  const APswdInit: string = ''): integer;

type
  TfmSelectAdr = class(TForm)
    dsAdr: TDataSource;
    Panel1: TPanel;
    btSaveToDisk: TcxButton;
    btMailMessage: TcxButton;
    btDSMessage: TcxButton;
    btStorno: TcxButton;
    paPswd: TPanel;
    cbPDFPswd: TcxCheckBox;
    edPDFPswd: TcxTextEdit;
    btPDFPswd: TcxButton;
    imgLst: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btSaveToDiskClick(Sender: TObject);
    procedure btMailMessageClick(Sender: TObject);
    procedure btDSMessageClick(Sender: TObject);
    procedure btPDFPswdClick(Sender: TObject);
  private
    procedure Init(AShowMail: boolean; AShowDS: Boolean; AShowSave: Boolean;
      const APswdInit: string);
    procedure SetPDFPswdCtrls(AedPDFPswd: TcxCustomTextEdit;
      AbtKlPDFPswd: TcxButton);
  public
    FPswdOut: string;
  end;

var
  fmSelectAdr: TfmSelectAdr;
  GSelectedResult: integer;

implementation

uses
  Main, IniFiles, SpolFunkce, FCommonUtils
  {$IFNDEF STANDALONE}
  ,DataModGlobObj
  {$ENDIF STANDALONE}
  ;

{$R *.dfm}

//Otevre dialog na vyber zpusobu odeslani nebo ulozeni souboru
//Result //1 - email, 2 - DS, 3 - ulozit
//
function SelectAdr(const ACaption: string;
  AShowMail: boolean; AShowDS: Boolean; AShowSave: Boolean;
  const APswdInit: string = ''): integer;
begin
  if fmSelectAdr = nil then
    fmSelectAdr:=TfmSelectAdr.Create(nil);
  try
    if ACaption<>'' then
    fmSelectAdr.Caption:=ACaption;
    fmSelectAdr.Init(AShowMail,AShowDS,AShowSave,APswdInit);
    fmSelectAdr.ShowModal;
    Result := GSelectedResult;
    GfaMain.FPdfPassword := fmSelectAdr.FPswdOut;
  finally
    fmSelectAdr.Free;
    fmSelectAdr := nil;
  end;
end; {}

procedure TfmSelectAdr.btDSMessageClick(Sender: TObject);
begin
  GSelectedResult := 2;
  if cbPDFPswd.Checked then
    FPswdOut := edPDFPswd.Text;
  Close;
end;

procedure TfmSelectAdr.btMailMessageClick(Sender: TObject);
begin
  GSelectedResult := 1;
  if cbPDFPswd.Checked then
    FPswdOut := edPDFPswd.Text;
  Close;
end;

procedure TfmSelectAdr.btPDFPswdClick(Sender: TObject);
begin
  SetPDFPswdCtrls(edPDFPswd, btPDFPswd);
end;

procedure TfmSelectAdr.btSaveToDiskClick(Sender: TObject);
begin
  GSelectedResult := 3;
  if cbPDFPswd.Checked then
    FPswdOut := edPDFPswd.Text;
  Close;
end;

procedure TfmSelectAdr.FormCreate(Sender: TObject);
begin
  GSelectedResult := 0;
  FPswdOut := '';
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
end;

procedure TfmSelectAdr.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then begin
    GSelectedResult := 0;
    Close;
  end;
end;

procedure TfmSelectAdr.Init(AShowMail: boolean; AShowDS: Boolean; AShowSave: Boolean;
  const APswdInit: string);
begin
  FPswdOut := '';
  btSaveToDisk.Visible:=AShowSave;
  btDSMessage.Visible:=AShowDS;
  btMailMessage.Visible:=AShowMail;
  if APswdInit<>'' then begin
    paPswd.Visible:=True;
    cbPDFPswd.Checked:=True;
    edPDFPswd.Text:=APswdInit;
  end
  else begin
    paPswd.Visible:=False;
    cbPDFPswd.Checked:=False;
    edPDFPswd.Text:='';
  end;
end;

procedure TfmSelectAdr.SetPDFPswdCtrls(
  AedPDFPswd: TcxCustomTextEdit;
  AbtKlPDFPswd: TcxButton);
begin
  if (AedPDFPswd.Properties.EchoMode = eemNormal) then begin
    AedPDFPswd.Properties.EchoMode := eemPassword;
    AbtKlPDFPswd.OptionsImage.ImageIndex := 1
  end
  else begin
    AedPDFPswd.Properties.EchoMode := eemNormal;
    AbtKlPDFPswd.OptionsImage.ImageIndex := 0
  end;
end;

end.


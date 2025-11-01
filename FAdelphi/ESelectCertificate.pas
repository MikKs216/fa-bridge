{ 13.9.2019 12:10:21 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 16.10.2012 13:19:13 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 26.9.2012 15:54:38 (GMT+2:00) > [pinkava on PINKAVA-XP1] checked in Uprava v  MsgBox  }
{ 25.10.2006 11:25:20 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 10:30:29 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 23.8.2006 13:10:19 (GMT+2:00) > [mik on PCMIK64] checked in Zmena informacnich textu el. podani  }
{ 31.10.2005 13:38:13 (GMT+1:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 29.10.2005 18:10:12 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 17.10.2005 11:43:38 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
unit ESelectCertificate;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxEdit,
  DB, cxDBData, cxGridLevel, cxGridBandedTableView,
  cxGridDBBandedTableView, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  kbmMemTable, Grids, DBGrids, cxDataStorage, cssz_certificate, Menus,
  cxLookAndFeelPainters, StdCtrls, cxButtons, ExtCtrls, Res_FA, cxLookAndFeels,
  dxSkinsCore, dxSkinCaramel, dxSkinFoggy, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinscxPCPainter, cxNavigator;

function SelectCertificate(const AHash: string; var ASubjectName: string;
  ALeft: Integer; ATop: Integer): string;

type
  TfmSelectCertificate = class(TForm)
    mtCertificates: TkbmMemTable;
    dsCertificates: TDataSource;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    mtCertificatesIssuerName: TStringField;
    mtCertificatesSubjectName: TStringField;
    mtCertificatesValidTo: TDateField;
    mtCertificatesThumbprint: TStringField;
    cxGrid1DBTableView1SubjectName: TcxGridDBColumn;
    cxGrid1DBTableView1IssuerName: TcxGridDBColumn;
    cxGrid1DBTableView1ValidTo: TcxGridDBColumn;
    Panel2: TPanel;
    Panel4: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    procedure cxGrid1DBTableView1DblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FHash, FSubjectName: string;
    Certificates: TCertificates;
    procedure FillTable;
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    procedure CertificatesLoad;
    procedure CertificatesFree;
  end;

var
  fmSelectCertificate: TfmSelectCertificate;

implementation

{$R *.dfm}

uses
  Main, IniFiles, FCommonUtils, ShellApi ,ComObj, IdException, SpolFunkce
  ;

procedure TfmSelectCertificate.FillTable;
var
  CertCount: Integer;
  I, nSelect: Integer;
begin
  StartWait;
  mtCertificates.DisableControls;
  try
    // Pocet certifikatu
    CertCount := Certificates.Count;
    if CertCount > 0 then
    begin
        // Nacteni vsech certifikatu, obe Common Name jako text
      for I := 0 to Certificates.Count - 1 do begin
        mtCertificates.Append;
        mtCertificatesSubjectName.Value:=
          Certificates.Certificate(I).SubjectFieldCommonName;
        mtCertificatesIssuerName.Value:=
          Certificates.Certificate(I).IssuerFieldCommonName;
        mtCertificatesValidTo.Value:=
          Certificates.Certificate(I).ValidToDate;
        mtCertificatesThumbprint.Value:=
          Certificates.Certificate(I).Thumbprint;
        mtCertificates.Post;
      end;
      if not mtCertificates.Locate(mtCertificatesThumbprint.FieldName,
        FHash, []) then
        mtCertificates.First;
    end;
  finally
    mtCertificates.EnableControls;
    StopWait;
  end;
end;

function SelectCertificate(const AHash: string; var ASubjectName: string;
  ALeft: Integer; ATop: Integer): string;
begin
  Application.CreateForm(TfmSelectCertificate, fmSelectCertificate);
  try
    with fmSelectCertificate do begin
      FHash := AHash;
      FSubjectName := ASubjectName;
      Left:=Left;
      Top:=ATop;
      ShowModal;
      Result := FHash;
      ASubjectName := FSubjectName;
    end;
  finally
    fmSelectcertificate.Free;
    fmSelectcertificate:=nil;
  end;
end; {OpenCertificates}

procedure TfmSelectCertificate.cxGrid1DBTableView1DblClick(Sender: TObject);
begin
  FHash:=mtCertificatesThumbprint.Value;
  FSubjectName:=mtCertificatesSubjectName.Value;
  Close;
end;

procedure TfmSelectCertificate.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then begin
    FHash:=mtCertificatesThumbprint.Value;
    FSubjectName:=mtCertificatesSubjectName.Value;
    Key:=#0;
    Close;
  end
  else if Key=#27 then begin
    Key:=#0;
    Close;
  end;
end;

procedure TfmSelectCertificate.LoadFormStateFromIni;
var
  iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    if Left=0 then
      Left:=iniFile.ReadInteger(Name, 'Left', 0);
    if Top=0 then
      Top:=iniFile.ReadInteger(Name, 'Top', 0);
    Width:=iniFile.ReadInteger(Name, 'Width', 505);
    Height:=iniFile.ReadInteger(Name, 'Height', 260);
  finally
    iniFile.Free;
  end;
end;

procedure TfmSelectCertificate.SaveFormStateToIni;
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
end;

procedure TfmSelectCertificate.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
  LoadFormStateFromIni;
end;

procedure TfmSelectCertificate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormStateToIni;
end;

procedure TfmSelectCertificate.CertificatesLoad;
begin
  StartWait;
  try
    CertificatesFree;
    Certificates := TCertificates.Create;
  finally
    StopWait;
  end;
end;

procedure TfmSelectCertificate.CertificatesFree;
begin
  StartWait;
  try
    if Assigned(Certificates) then begin
      Certificates.Free;
      Certificates:=nil;
    end;
  finally
    StopWait;
  end;
end;


procedure TfmSelectCertificate.FormDestroy(Sender: TObject);
begin
  CertificatesFree;
end;

procedure TfmSelectCertificate.FormActivate(Sender: TObject);
begin
  inherited;
  Caption := sCaptionWait;
  mtCertificates.Open;
  mtCertificates.Refresh;
  Refresh;
  try
    CertificatesLoad;
  except
    ShellExecute(Handle, nil, PChar('regsvr32'), PChar('/s capicom.dll'), nil,
      SW_SHOWNORMAL);
    Sleep(2000);
    try
      CertificatesLoad;
    except
      on E: EOleSysError do begin
        MessageErr(Caption, Format('Chyba pøi ètení certifikátù: %s. Pøíèinou mùže být chybìjící knihovna capicom.dll. Zkuste spustit dávku comobjreg.bat v adresáøi programu a pak vybrat certifikát znovu.',
          [E.Message]), [MBOK]);
      end;
    end;
  end;
  FillTable;
  mtCertificates.Refresh;
  Caption := sCaptionPlatCert;
end;

procedure TfmSelectCertificate.btnOKClick(Sender: TObject);
begin
  FHash:=mtCertificatesThumbprint.Value;
  FSubjectName:=mtCertificatesSubjectName.Value;
end;

end.

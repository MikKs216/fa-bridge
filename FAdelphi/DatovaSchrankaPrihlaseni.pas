{ 28.11.2017 14:27:15 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Zmena fontu Tahoma na MS Sans Serif  }
{ 16.6.2014 11:46:17 (GMT+2:00) > [martin on WIN-48QDB6JAV23] checked in povoleno prihlaseni certifikatem  }
{ 18.10.2012 10:22:48 (GMT+2:00) > [mik] checked in   }
{ 16.10.2012 11:17:45 (GMT+2:00) > [mik] checked in Doplneno Esc  }
{ 16.10.2012 10:53:23 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 1.3.2011 9:59:59 (GMT+1:00) > [mik] checked in Zmena poradi tlacitek  }
{ 25.8.2010 10:55:27 (GMT+2:00) > [martin on TESTXP-2F67BDE0] checked in zruseni skynu a nastaveni ManagerISDS objektu  }
{ 10.12.2009 15:27:29 (GMT+1:00) > [mik on MIK-VIRTUAL2007] checked in Hodne novych funkci DS  }
{ 23.11.2009 9:55:39 (GMT+1:00) > [mik] checked in Uprava pro certifikat  }
{ 5.11.2009 10:36:21 (GMT+1:00) > [mik] checked in   }
{ 3.11.2009 16:41:12 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in oprava prihlaseni klasicke  }
{ 3.11.2009 16:06:24 (GMT+1:00) > [mik] checked in   }
{ 3.11.2009 15:45:04 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in vbr certifiktu  }
{ 3.11.2009 14:42:57 (GMT+1:00) > [mik] checked in Uprava designu a veci kolem prihl certifikatem.  }
{ 14.7.2009 14:25:40 (GMT+2:00) > [mik] checked in   }
//Check box na zapamatovani prihlasovacich udaju

unit DatovaSchrankaPrihlaseni;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, cxGraphics, cxMaskEdit, cxDropDownEdit,
  StdCtrls, cxButtons, cxControls, cxContainer, cxEdit, cxTextEdit, cxCheckBox,
  mfcr_certificate, ShellAPI, ComObj, cxRadioGroup, cxLookAndFeels, dxSkinsCore,
  dxSkinCaramel, dxSkinFoggy, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2007Blue;

type
  TfmDSPrihlaseni = class(TForm)
    GroupBox1: TGroupBox;
    Label14: TLabel;
    edPrihlJmeno: TcxTextEdit;
    Label2: TLabel;
    edPrihlHeslo: TcxTextEdit;
    btPrihlasit: TcxButton;
    cbCertificates: TcxComboBox;
    Label1: TLabel;
    btNaplnTest: TcxButton;
    cbTest: TcxCheckBox;
    cbZobrazitHeslo: TcxCheckBox;
    cbCertifikat: TcxCheckBox;
    btStorno: TcxButton;
    procedure btNaplnTestClick(Sender: TObject);
    procedure btPrihlasitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edPrihlHesloKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbZobrazitHesloClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbCertifikatClick(Sender: TObject);
    procedure btStornoClick(Sender: TObject);
  private
    FCertificates: TCertificates;
    FHash:string;
    FSerialNumber:string;
    FVybrano: boolean;

    function TestPrihlasovacichUdaju: boolean;
    function GetHashCert:string;
    procedure CertificateComboLoad;
    procedure CertificateComboDisplay;
    procedure CertificatesFree();
    procedure CertificatesLoad;
    procedure Init;
    procedure SetControls;
{$IFDEF STANDALONE}
    procedure SaveIni;
    procedure LoadIni;
{$ENDIF STANDALONE}
  public
    { Public declarations }
  end;

var
  fmDSPrihlaseni: TfmDSPrihlaseni;

function ZadejPrihlasovaciUdaje(var AJmeno, AHeslo: string;
  var ATest: boolean; var AHash:string): boolean;

implementation

{$R *.dfm}

uses
  FCommonUtils, ManagerISDS_TLB, IniFiles,
{$IFDEF STANDALONE}
  {$IFNDEF DSAPP}
  Main,
  {$ENDIF DSAPP}
{$ENDIF STANDALONE}
  DatovaSchranka, SpolFunkce;

const
  cTestJmeno = 'aaaark';
  cTestHeslo = 'Ex7+6r2=oz';
  cTestIDDS = '8c3adyx';

function ZadejPrihlasovaciUdaje(var AJmeno, AHeslo: string;
  var ATest: boolean; var AHash:string): boolean;
begin
  fmDSPrihlaseni:=TfmDSPrihlaseni.Create(nil);
  try
    with fmDSPrihlaseni do begin
      {$IFDEF FINALBUILD}
      btNaplnTest.Visible:=FALSE;
      cbTest.Visible:=FALSE;
      {$ELSE FINALBUILD}
      btNaplnTest.Visible:=TRUE;
      cbTest.Visible:=TRUE;
      {$ENDIF FINALBUILD}
      edPrihlJmeno.Text:=AJmeno;
      edPrihlHeslo.Text:=AHeslo;
      FHash:=AHash;
      FVybrano:=FALSE;
      Init;
      ShowModal;
      Result:=FVybrano and
        ((not cbCertifikat.Checked and(edPrihlJmeno.Text<>'')and(edPrihlJmeno.Text<>''))or
        (cbCertifikat.Checked and (edPrihlJmeno.Text<>'')and
         (edPrihlJmeno.Text<>'')and(cbCertificates.SelectedItem>=0)));
      if Result then begin
        AJmeno:=edPrihlJmeno.Text;
        AHeslo:=edPrihlHeslo.Text;
        ATest:=cbTest.Checked;
        AHash:=GetHashCert();
      end;
    end;
  finally
    fmDSPrihlaseni.Free;
    fmDSPrihlaseni:=nil;
  end;
end;

procedure TfmDSPrihlaseni.Init;
begin
  cbZobrazitHeslo.Enabled := edPrihlHeslo.Text='';
  cbCertificates.Enabled:= FALSE;
  SetControls;
end;

procedure TfmDSPrihlaseni.SetControls;
begin
  cbZobrazitHeslo.Enabled:=TRUE;
  cbCertificates.Enabled:=cbCertifikat.Checked;
end;

procedure TfmDSPrihlaseni.btPrihlasitClick(Sender: TObject);
begin
  FVybrano:=TRUE;
  Close;
end;

procedure TfmDSPrihlaseni.btStornoClick(Sender: TObject);
begin
  Close;
end;

procedure TfmDSPrihlaseni.cbCertifikatClick(Sender: TObject);
begin
  SetControls;
end;

procedure TfmDSPrihlaseni.cbZobrazitHesloClick(Sender: TObject);
begin
  if cbZobrazitHeslo.Checked then
    edPrihlHeslo.Properties.EchoMode:=eemNormal
  else
    edPrihlHeslo.Properties.EchoMode:=eemPassword;
end;

procedure TfmDSPrihlaseni.btNaplnTestClick(Sender: TObject);
begin
  edPrihlJmeno.Text:=cTestJmeno;
  edPrihlHeslo.Text:=cTestHeslo;
  cbTest.Checked:=TRUE;
end;

function TfmDSPrihlaseni.GetHashCert:string;
var
   crt:TCertificate;
begin
  if cbCertifikat.Checked then begin

    if cbCertificates.ItemIndex>=0 then begin
      crt:= TCertificate(CbCertificates.Properties.Items.Objects[CbCertificates.ItemIndex]);
      Result:= crt.Thumbprint;
    end
    else
      Result:= '';
    end
  else
   Result:= '';
end;{GetHashCert}

function TfmDSPrihlaseni.TestPrihlasovacichUdaju: boolean;
var
  retCode, retMsg: WideString;
  res: WordBool;
  ISDSManager: TISDSManager;
  msg: string;
begin
  if TestAndRegisterISDSManager(FALSE, msg) then begin
    ISDSManager:= TISDSManager.Create(nil);
    try
      //zkusime najit neexstujici schranku, pokud se vrati text obsahujici "nenalezena",
      //  tak jsou spravne prihlasovaci udaje
      StartWait;
      try
        Result:=ISDSManager.DostupnostSchranky(cbTest.Checked,
          edPrihlJmeno.Text, edPrihlHeslo.Text,GetHashCert, true ,'x', retCode, retMsg);
        if Result then
          Result:=Pos('nenalezena',retMsg)>0;
      finally
        StopWait;
      end;
    finally
      ISDSManager.Free;
    end;
  end
  else
    Close;
end;

// Zobrazeni detailu certifikatu na formular

procedure TfmDSPrihlaseni.CertificateComboDisplay;
var
  Cert: TCertificate;
begin
  if CbCertificates.Properties.Items.Count < 1 then
    begin
      // Pokud je combo box prazdny, nic se nezobrazuje
      //LabelCertificate.Caption := '';
    end
  else
    begin
      // Nacteni certifikatu z combo boxu do promenne
      Cert := TCertificate(CbCertificates.Properties.Items.Objects[CbCertificates.ItemIndex]);
      // Zobrazeni nekterych hodnot
      {
        LabelCertificate.Caption :=
       'Sériové èíslo: ' + Cert.SerialNumber + #13#10 +
       'Subjekt: ' + Cert.SubjectFieldCommonName + #13#10 +
       'Organizace: '+ Cert.SubjectOrganization + #13#10 +
       'Vystavitel: ' + Cert.IssuerFieldCommonName + #13#10 +
       'Platnost od: ' + DateTimeToStr(Cert.ValidFromDate) + #13#10 +
       'Platnost do: ' + DateTimeToStr(Cert.ValidToDate) + #13#10;
       }
    end;
end;

procedure TfmDSPrihlaseni.CertificatesFree;
begin
StartWait;
  try
    if Assigned(FCertificates) then begin
      FCertificates.Free;
      FCertificates := nil;
    end;
  finally
    StopWait;
  end;
end; {Uvolnìní certifikátù}

procedure TfmDSPrihlaseni.CertificatesLoad;
begin
  StartWait;
  try
    CertificatesFree;
    FCertificates := TCertificates.Create;
  finally
    StopWait;
  end;
end;


procedure TfmDSPrihlaseni.edPrihlHesloKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edPrihlHeslo.Text='' then
    cbZobrazitHeslo.Enabled := TRUE;
end;

// Nacteni certifikatu do combo boxu
procedure TfmDSPrihlaseni.CertificateComboLoad;
var
  CertCount: Integer;
  I, nSelect: Integer;
  org:string;
begin
  StartWait;
  try
    nSelect:=0;
    // Pocet certifikatu
    CertCount := FCertificates.Count;
    // Smazani hodnot
    CbCertificates.Clear;
    if CertCount > 0 then
      begin
        // Pokud existuji nejake certifikaty, povolit combo box
        CbCertificates.Enabled := TRUE;
        // Nacteni vsech certifikatu, obe Common Name jako text
        for I := 0 to FCertificates.Count - 1 do begin

          if FCertificates.Certificate(I).SubjectOrganization<>'' then
            org:=' - '+ FCertificates.Certificate(I).SubjectOrganization
          else
            org:='';
          CbCertificates.Properties.Items.AddObject(
           FCertificates.Certificate(I).SubjectFieldCommonName + org +
           ' --- ' +
           FCertificates.Certificate(I).IssuerFieldCommonName,
           FCertificates.Certificate(I));
           if FCertificates.Certificate(I).Thumbprint = FHash then
             nSelect:=I;
        end;
        // Nastaveni vyberu podle posledniho nastaveneho nebo na prvni
        CbCertificates.ItemIndex := nSelect;
        // Zobrazeni prvniho certifikatu na formular
        //CerfificateComboDisplay;
      end
    else
      CbCertificates.Enabled := FALSE;
   //
   //btShowCertificate.Enabled:=CbCertificates.Properties.Items.Count>0;
   //btSend.Enabled:=CertCount>0;
   //btAskState.Enabled:=(CertCount>0) and (edCislo.Text<>'') and
     //(edHeslo.Text<>'') and not cbTestovaciServer.Checked;
   finally
     //btSave.Enabled:=TRUE;
     StopWait;
   end;
end;

procedure TfmDSPrihlaseni.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{$IFDEF STANDALONE}
  SaveIni;
{$ENDIF STANDALONE}
end;{FormClose}

procedure TfmDSPrihlaseni.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
  FCertificates:=nil;
end;

procedure TfmDSPrihlaseni.FormDestroy(Sender: TObject);
begin
  CertificatesFree();
end;

procedure TfmDSPrihlaseni.FormShow(Sender: TObject);
var
  certLoaded:Boolean;
  pth:string;
begin
{$IFDEF STANDALONE}
  LoadIni;
{$ENDIF STANDALONE}

  cbCertificates.Visible := true;
  try
    certLoaded:=FALSE;
    try
      CertificatesLoad;
      certLoaded:=TRUE;
    except
      pth:=NormalPath(ExtractFilePath(Application.ExeName))+'capicom.dll';
      if FileExists(pth) then begin
        ShellExecute(Handle, nil, PChar('regsvr32'),
          PChar('/s "'+pth+'"'), nil,SW_SHOWNORMAL);
        Sleep(2000);
      end
      else begin
        MessageErr(Caption, 'Nenalezena knihovna capicom.dll. Problém patrnì odstraníte reinstalací programu.',
          [MBOK]);
        EXIT;
      end;
      try
        CertificatesLoad;
        certLoaded:=TRUE;
      except
        on E: EOleSysError do begin
          MessageErr(Caption, Format('Chyba pøi ètení certifikátù: %s. Pøíèinou mùže být chybìjící knihovna capicom.dll. Zkuste spustit dávku comobjreg.bat v adresáøi programu, zavøít dialog elektronického podání a zkusit el. podání znovu.',
            [E.Message]), [MBOK]);
        end;
      end;
    end;

    if certLoaded then begin
      CertificateComboLoad;
      //
    end
    else begin
      cbCertificates.Clear;
      cbCertificates.Enabled := false;
    end;
    cbCertificates.Enabled:=cbCertifikat.Checked;
  finally
    StopWait;
  end;
end;

{$IFDEF STANDALONE}
procedure TfmDSPrihlaseni.SaveIni;
var
  iniFile: TMemIniFile;
begin
  {$IFNDEF DSAPP}
  if not GfaMain.CanWriteToIniFile then EXIT;
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    iniFile.WriteString(Name, 'CertificateHash', FHash);
  finally
    iniFile.Free;
  end;
  {$ENDIF DSAPP}
end;

procedure TfmDSPrihlaseni.LoadIni;
var
  iniFile: TMemIniFile;
begin
  {$IFNDEF DSAPP}
  if not GfaMain.CanWriteToIniFile then EXIT;
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    FHash := iniFile.ReadString(Name, 'CertificateHash', '');
  finally
    iniFile.Free;
  end;
  {$ENDIF DSAPP}
end;

{$ENDIF STANDALONE}

end.

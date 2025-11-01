{ 2.2.2011 15:46:22 (GMT+1:00) > [martin on TESTXP-2F67BDE0] checked in Dialog vyberu certifikatu  }

unit EELVyberCertifikat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mfcr_certificate, mfcr_utils, mfcr_consts, cxGraphics, SpolFunkce,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,{ FSysUtils,
  WUBase64,} Wcrypt2, synacode ,cxLookAndFeels, cxLookAndFeelPainters;

type
  TfmVyberCertifikat = class(TForm)
    lbl1: TLabel;
    btnDetail: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    cbCertificates: TcxComboBox;
    procedure btnDetailClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCertificatesPropertiesChange(Sender: TObject);
    procedure cbCertificatesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

    // Platne certifikaty pro podpis
    Certificates: TCertificates;

    //Vrati Base64 verejnou cast certifikatu
    function GetCertificate(AHash:string):string;

    function FindCertificate(hStore: HCERTSTORE; wSigID: string): PCCERT_CONTEXT;
    // Nacteni certifikatu pro podpis
    procedure CertificatesLoad;

    // Uvolneni certifikatu pro podpis
    procedure CertificatesFree;

    { Private declarations }
    procedure CerfificateComboDisplay;
    procedure CertificateComboLoad;
  public
    FHash: string;
    FSubject: string;
    FFullSubject: string;
    FCertifikatStr:string;
    { Public declarations }
  end;

var
  fmVyberCertifikat: TfmVyberCertifikat;

  function VyberCertifikat(AOwner:TForm; var AHash:string; var ASubject:string; var AFullSubject:string; var ACertifikat:string):TModalResult;
implementation

{$R *.dfm}

function VyberCertifikat(AOwner:TForm; var AHash:string; var ASubject:string; var AFullSubject:string; var ACertifikat:string):TModalResult;
var
  dr:TModalResult;
begin
  fmVyberCertifikat:=TfmVyberCertifikat.Create(nil);
  try
    fmVyberCertifikat.FHash:=AHash;
    fmVyberCertifikat.CertificateComboLoad;
    fmVyberCertifikat.Parent:=AOwner;
    dr:= fmVyberCertifikat.ShowModal();
    if fmVyberCertifikat.ModalResult = MROK then begin
       AHash:=fmVyberCertifikat.FHash;
       ASubject:=fmVyberCertifikat.FSubject;
       AFullSubject:=fmVyberCertifikat.FFullSubject;
       ACertifikat:=fmVyberCertifikat.FCertifikatStr;
    end
    else begin
      AHash:='';
      ASubject:='';
    end;
    Result:=fmVyberCertifikat.ModalResult;
  finally
    fmVyberCertifikat.Free;
  end;
end;{VyberCertifikat}


procedure TfmVyberCertifikat.CerfificateComboDisplay;
var
  Cert: TCertificate;
begin
  if CbCertificates.Properties.Items.Count < 1 then
    begin

    end
  else
    begin
      // Nacteni certifikatu z combo boxu do promenne
      Cert := TCertificate(CbCertificates.Properties.Items.Objects[CbCertificates.ItemIndex]);
    end;
end;

// Nacteni certifikatu do combo boxu

procedure TfmVyberCertifikat.CertificateComboLoad;
var
  CertCount: Integer;
  I, nSelect: Integer;
  org:string;
begin
  StartWait;
  CbCertificates.Reset;
  try
    nSelect:=0;
    // Pocet certifikatu
    CertCount := Certificates.Count;
    // Smazani hodnot
    CbCertificates.Clear;
    if CertCount > 0 then
      begin
        // Pokud existuji nejake certifikaty, povolit combo box
        CbCertificates.Enabled := TRUE;
        // Nacteni vsech certifikatu, obe Common Name jako text
        for I := 0 to Certificates.Count - 1 do begin

          if Certificates.Certificate(I).SubjectOrganization<>'' then
            org:=' - '+ Certificates.Certificate(I).SubjectOrganization
          else
            org:='';
          CbCertificates.Properties.Items.AddObject(
           Certificates.Certificate(I).SubjectFieldCommonName + org +
           ' --- ' +
           Certificates.Certificate(I).IssuerFieldCommonName,
           Certificates.Certificate(I));
           if Certificates.Certificate(I).Thumbprint = FHash then
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
   if CertCount<>1 then
     cbCertificates.ItemIndex:=-1
    else
     cbCertificates.ItemIndex:=0;

   finally
    // btnOK.Enabled:=(cbCertificates.SelectedItem>=0) and (CbCertificates.Properties.Items.Count>0);
    // btnDetail.Enabled:=(cbCertificates.SelectedItem>=0) and (CbCertificates.Properties.Items.Count>0);
     StopWait;
   end;
   cbCertificates.Refresh();
end;

procedure TfmVyberCertifikat.btnCancelClick(Sender: TObject);
begin
 ModalResult:=mrCancel;
end;

procedure TfmVyberCertifikat.btnDetailClick(Sender: TObject);
begin
  Certificates.Display(CbCertificates.ItemIndex);
end;

//Hledame stejny hash SHA1
function TfmVyberCertifikat.FindCertificate(hStore: HCERTSTORE; wSigID: string): PCCERT_CONTEXT;
var
  I: Integer;
  pCert, oldCert, testCert: PCCERT_CONTEXT;
  nameString: Pchar;
  blob: CERT_NAME_BLOB;
  blobSerial: CRYPT_INTEGER_BLOB;
  cryptHash:Crypt_HASH_BLOB;
  size: DWORD;
  pbData:PByte;
  cbSizeData:DWORD;
  rData:PByte;
  ixPData:PByte;
  ixPSrc:PByte;
  datahash:string;
  lastErr: Cardinal;

procedure ConvertStrToBinStr();
var
  i,ix:Integer;
  znak:string;
  bajt:Byte;
begin
  ix:=1;
  i:=1;
  repeat
     znak:=wSigID[i];
     if Char (UpperCase(znak)[1]) in ['0'..'9'] then
       bajt:= ((ord(Char(UpperCase(znak)[1]))-ord('0'))shl 4)
     else if Char(UpperCase(znak)[1]) in ['A'..'F'] then
       bajt:= (((ord(Char(UpperCase(znak)[1]))-ord('A'))+10) shl 4);
     Inc(i);
     znak:=wSigID[i];
     if Char(UpperCase(znak)[1]) in ['0'..'9'] then
       bajt:= bajt + (ord(Char(UpperCase(znak)[1]))-ord('0'))
     else if Char(UpperCase(znak)[1]) in ['A'..'F'] then
       bajt:= bajt + (ord(Char(UpperCase(znak)[1]))-ord('A'))+10;
     datahash[ix]:=Char(bajt);
     Inc(ix);
     Inc(i);
  until (i > Length(wSigID));

end;

begin
  pCert := nil;
  oldCert := nil;

    testCert := nil;

    SetLength(dataHash,Length(wSigID) div 2);
    ConvertStrToBinStr();

    //dataHash := #81#137#39#18#30#127#202#242#99#07#101#185#95#152#103#73#81#254#164#71;
    cryptHash.cbData:=length(dataHash);

    //Naplnit data hashe
    cryptHash.pbData := Pointer(dataHash);
    testCert := CertFindCertificateInStore(hstore,
      (PKCS_7_ASN_ENCODING or X509_ASN_ENCODING),
       0,
       CERT_FIND_HASH,
       @cryptHash,
       nil);

    if testCert=nil then begin
       lastErr:= GetLastError();
       ShowMessage('Nelze najít cerifikát (CertFindCertificateInStore): '+ intToStr(lastErr));
    end;

    result:= testCert;
end; {FindCertificate}


function TfmVyberCertifikat.GetCertificate(AHash: string): string;
var
  certB64: string;
  pCertContext:  PCCERT_CONTEXT;
  hStoreHandle: HCERTSTORE;
  delkaCert: Dword;
  strCert, vysledek: string;
begin
//Otevreni uloziste
    hStoreHandle := CertOpenSystemStore(0, 'MY');
    try
      //Najit certifikat
      pCertContext := FindCertificate(hStoreHandle, AHash);

      if pCertContext = nil then begin
        ShowMessage('Nenalezen vybraný certifikát');
        Exit;
      end;

      //Ziskat X509 certifikat do B64 - OK
      delkaCert := pCertContext^.cbCertEncoded;
      setlength(strCert, delkacert);
      MoveMemory(@strCert[1], pCertContext.pbCertEncoded, delkaCert);
      CertB64 := EncodeBase64(strCert);
      Result:=CertB64
    finally
      if hStoreHandle <> nil then
        CertCloseStore(hStoreHandle, 0);
    end;
end;{GetCertificate}

procedure TfmVyberCertifikat.btnOKClick(Sender: TObject);
begin
  FHash:= TCertificate(CbCertificates.Properties.Items.Objects[CbCertificates.ItemIndex]).Thumbprint;
  FCertifikatStr:=GetCertificate(FHash);
  FSubject:= Format('%s %s %s',
  [TCertificate(CbCertificates.Properties.Items.Objects[CbCertificates.ItemIndex]).SerialNumber,
  TCertificate(CbCertificates.Properties.Items.Objects[CbCertificates.ItemIndex]).SubjectFieldCommonName,
  TCertificate(CbCertificates.Properties.Items.Objects[CbCertificates.ItemIndex]).SubjectOrganization]);
  FFullSubject:=TCertificate(CbCertificates.Properties.Items.Objects[CbCertificates.ItemIndex]).SubjectName;
  ModalResult:=mrOk;
end;

procedure TfmVyberCertifikat.cbCertificatesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    cbCertificates.DroppedDown:=True;
end;

procedure TfmVyberCertifikat.cbCertificatesPropertiesChange(Sender: TObject);
begin
   btnDetail.Enabled:=(cbCertificates.ItemIndex>=0) and (CbCertificates.Properties.Items.Count>0);
   btnOK.Enabled:=(cbCertificates.ItemIndex>=0) and (CbCertificates.Properties.Items.Count>0);
end;

procedure TfmVyberCertifikat.CertificatesLoad;
begin
  StartWait;
  try
    CertificatesFree;
    Certificates := TCertificates.Create;
  finally
    StopWait;
  end;
end;

procedure TfmVyberCertifikat.FormCreate(Sender: TObject);
begin
  CertificatesLoad();
end;

procedure TfmVyberCertifikat.FormDestroy(Sender: TObject);
begin
   CertificatesFree;
end;


procedure TfmVyberCertifikat.CertificatesFree;
begin
  StartWait;
  try
    if Assigned(Certificates) then begin
      Certificates.Free;
      Certificates := nil;
    end;
  finally
    StopWait;

  end;
end;

end.

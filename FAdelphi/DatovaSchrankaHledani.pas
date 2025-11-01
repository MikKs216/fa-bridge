{ 15.12.2022 11:20:15 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 4831 - zmena v btUlozitAdresuClick  }
{ 28.11.2017 14:27:14 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Zmena fontu Tahoma na MS Sans Serif  }
{ 25.9.2017 16:36:29 (GMT+2:00) > [martin on WIN-48QDB6JAV23] checked in uprava hgledani v datov� schr�nce, osetreni chybovyxh stravu   }
{ 16.10.2012 10:52:51 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 25.8.2010 10:55:25 (GMT+2:00) > [martin on TESTXP-2F67BDE0] checked in zruseni skynu a nastaveni ManagerISDS objektu  }
{ 23.2.2010 9:12:25 (GMT+1:00) > [mik] checked in Osetreni viditelnosti tlacitka pro ulozeni do adres  }
{ 14.12.2009 13:11:13 (GMT+1:00) > [mik] checked in   }
{ 14.12.2009 12:03:45 (GMT+1:00) > [mik] checked in   }
{ 10.12.2009 15:29:25 (GMT+1:00) > [mik on MIK-VIRTUAL2007] checked in   }
{ 10.12.2009 15:27:28 (GMT+1:00) > [mik on MIK-VIRTUAL2007] checked in Hodne novych funkci DS  }
{ 19.10.2009 10:03:20 (GMT+2:00) > [mik] checked in Odstraneno pracovni tlacitko  }
{ 14.7.2009 14:25:38 (GMT+2:00) > [mik] checked in   }
unit DatovaSchrankaHledani;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, cxCheckBox, StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, DB, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGridLevel, cxClasses, cxGridCustomView, cxGrid,
  kbmMemTable, cxLookAndFeels, dxSkinsCore, dxSkinCaramel, dxSkinFoggy,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinscxPCPainter, cxNavigator;

function HledejSchranku(ATest: boolean; const AJmeno, AHeslo, ACertif: string;
  APrihlasit:Boolean; out ANazevAdresata: string): string;
function HledejSchrankuSUlozenim(ATest: boolean;
  const AJmeno, AHeslo, ACertif: string;
  APrihlasit:Boolean; out ANazevAdresata: string;
  AClientID: integer): string;

type
  TfmDSHledani = class(TForm)
    GroupBox1: TGroupBox;
    Label14: TLabel;
    edIDDS: TcxTextEdit;
    btVyhledat: TcxButton;
    cbOVM: TcxCheckBox;
    Label1: TLabel;
    edIC: TcxTextEdit;
    Label2: TLabel;
    edNazev: TcxTextEdit;
    Label3: TLabel;
    edJmeno: TcxTextEdit;
    Label4: TLabel;
    edPrijmeni: TcxTextEdit;
    Label5: TLabel;
    edobec: TcxTextEdit;
    Label6: TLabel;
    edUlice: TcxTextEdit;
    Label7: TLabel;
    edCislo: TcxTextEdit;
    cbPO: TcxCheckBox;
    cbPFO: TcxCheckBox;
    cbFO: TcxCheckBox;
    GroupBox2: TGroupBox;
    cbPodtypy: TcxCheckBox;
    mtAdresy: TkbmMemTable;
    grAdresy: TcxGrid;
    grAdresyView1: TcxGridDBBandedTableView;
    mgLevelMain: TcxGridLevel;
    mtAdresyIDDS: TStringField;
    mtAdresyAdresa: TStringField;
    dsAdresy: TDataSource;
    grAdresyView1IDDS: TcxGridDBBandedColumn;
    grAdresyView1Adresa: TcxGridDBBandedColumn;
    Memo1: TMemo;
    btPrevzit: TcxButton;
    laInfo: TLabel;
    btUlozitAdresu: TcxButton;
    procedure btVyhledatClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btPrevzitClick(Sender: TObject);
    procedure grAdresyView1DblClick(Sender: TObject);
    procedure grAdresyView1EditKeyDown(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
      Shift: TShiftState);
    procedure btUlozitAdresuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FTest: boolean;
    FPrihlJmeno, fPrihlHeslo: string;
    FVysledek, FNazevAdresata: string;
    FCertif:string;
    FPrihlasit:Boolean;
    FClientID: integer;
    procedure SetEnable;
    procedure Init;
    procedure StartW(const AStatusText: string);
    procedure StopW;
  public
    { Public declarations }
  end;

var
  fmDSHledani: TfmDSHledani;

implementation

{$R *.dfm}

uses
  DatovaSchranka, ManagerISDS_TLB, FCommonUtils,
  {$IFNDEF STANDALONE}
  FAPublicUtils,
  {$ENDIF}
  JCLStrings, SpolFunkce;

function HledejSchranku(ATest: boolean; const AJmeno, AHeslo, ACertif: string;
  APrihlasit:Boolean; out ANazevAdresata: string): string;
begin
  fmDSHledani:=TfmDSHledani.Create(nil);
  try
    with fmDSHledani do begin
      FPrihlJmeno:=AJmeno;
      FPrihlHeslo:=AHeslo;
      FCertif:=ACertif;
      FPrihlasit:=APrihlasit;
      FTest:=ATest;
      FClientID:=-1;
      btUlozitAdresu.Visible:=FALSE;
      ShowModal;
      Result:=FVysledek;
      ANazevAdresata:=FNazevAdresata;
    end;
  finally
    fmDSHLedani.Free;
    fmDSHledani:=nil;
  end;
end;

function HledejSchrankuSUlozenim(ATest: boolean;
  const AJmeno, AHeslo, ACertif: string;
  APrihlasit:Boolean; out ANazevAdresata: string;
  AClientID: integer): string;
begin
  fmDSHledani:=TfmDSHledani.Create(nil);
  try
    with fmDSHledani do begin
      FPrihlJmeno:=AJmeno;
      FPrihlHeslo:=AHeslo;
      FCertif:=ACertif;
      FPrihlasit:=APrihlasit;
      FTest:=ATest;
      FClientID:=AClientID;
      btUlozitAdresu.Visible:=FClientID>-1;
      ShowModal;
      Result:=FVysledek;
      ANazevAdresata:=FNazevAdresata;
    end;
  finally
    fmDSHLedani.Free;
    fmDSHledani:=nil;
  end;
end;

procedure TfmDSHledani.btPrevzitClick(Sender: TObject);
var
  i, n: integer;
begin
  n:=0;
  for i:=0 to grAdresyView1.ViewData.RecordCount-1 do begin
    if grAdresyView1.ViewData.Records[i].Selected then
      n:=n+1;
  end;
  if n>0 then begin
    for i:=0 to grAdresyView1.Controller.SelectedRowCount-1 do begin
      grAdresyView1.Controller.SelectedRows[i].Focused:=TRUE;
      FVysledek := FVysledek + mtAdresyIDDS.Value+',';
      FNazevAdresata := mtAdresyAdresa.Value;
    end;
    FVysledek := StrTrimCharRight(FVysledek,',');
    if n>1 then
      FNazevAdresata := 'Více příjemců';
  end;
  Close;
end;

procedure TfmDSHledani.FormActivate(Sender: TObject);
begin
  mtAdresy.Open;
  FVysledek:='';
  FNazevAdresata:='';
  {$IFDEF STANDALONE}
  btUlozitAdresu.Visible:=FALSE;
  {$ELSE STANDALONE}
  btUlozitAdresu.Visible:=TRUE;
  {$ENDIF STANDALONE}
end;

procedure TfmDSHledani.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mtAdresy.Close;
end;

procedure TfmDSHledani.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
end;

procedure TfmDSHledani.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then begin
    Key:=#0;
    Close;
  end;
end;

procedure TfmDSHledani.grAdresyView1DblClick(Sender: TObject);
begin
  FVysledek := mtAdresyIDDS.Value;
  FNazevAdresata := mtAdresyAdresa.Value;
  Close;
end;

procedure TfmDSHledani.grAdresyView1EditKeyDown(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then begin
    FVysledek := mtAdresyIDDS.Value;
    FNazevAdresata := mtAdresyAdresa.Value;
    Close;
  end;
end;

procedure TfmDSHledani.Init;
begin
  cbOVM.Checked:=TRUE;
  cbPO.Checked:=TRUE;
  cbPFO.Checked:=TRUE;
  cbFO.Checked:=TRUE;
  setEnable;
end;

procedure TfmDSHledani.SetEnable;
begin
  edIC.Enabled:=cbOVM.Checked or cbPO.checked or cbPFO.Checked;
  edNazev.Enabled:=cbOVM.Checked or cbPO.checked;
  edJmeno.Enabled:=cbPFO.Checked or cbFO.Checked;
  edPrijmeni.Enabled:=cbPFO.Checked or cbFO.Checked;
  edObec.Enabled:=cbPFO.Checked or cbFO.Checked;
  edUlice.Enabled:=cbPFO.Checked or cbFO.Checked;
  edCislo.Enabled:=cbPFO.Checked or cbFO.Checked;
end;

//Vysledek hledani OVM
//sbID,dbType,ic,pnFirstName,pnLastName,firmName,adCity,adStreet,adNumberInStreet,adNumberInMunicipality,adZipCode,adState
//"jjmajhd","OVM","10073825","","","Ing. Miloš Kastner","Kostelec na Hané","","","","79841","CZ"

procedure TfmDSHledani.btUlozitAdresuClick(Sender: TObject);
{$IFNDEF STANDALONE}
var
  i, n: integer;
  jmeno, psc, misto, ico: string;
  ok: boolean;
{$ENDIF STANDALONE}
begin
{$IFNDEF STANDALONE}
  n:=0;
  for i:=0 to grAdresyView1.ViewData.RecordCount-1 do begin
    if grAdresyView1.ViewData.Records[i].Selected then
      n:=n+1;
  end;
  if n>0 then begin
    for i:=0 to grAdresyView1.Controller.SelectedRowCount-1 do begin
      grAdresyView1.Controller.SelectedRows[i].Focused:=TRUE;
      RozdelAdresu(mtAdresyAdresa.Value, jmeno, psc, misto, ico);
      if FClientID>=0 then begin
        ok:=AdresyWUByIdDS(FClientID,ico,mtAdresyIDDS.Value,jmeno,
          jmeno,'','','','','','','',psc,misto,'','');
        if ok then
          MessageInfo(Caption,'Informace o adresátovi a jeho ID datové schránky byly uložené do adresáře klienta', [MBOK])
        else
          MessageInfo(Caption,'Informace o adresátovi již v adresáři klienta existují', [MBOK]);
      end
      else
        MessageInfo(Caption,'Informace o adresátovi není možné uložit do adresáře klienta při otevření datové schránky z nastavení programu nebo z nastavení uživatele.', [MBOK]);
    end;
  end;
{$ENDIF STANDALONE}
end;

procedure TfmDSHledani.btVyhledatClick(Sender: TObject);
var
  res, retCode, retMsg: WideString;
  ISDSManager: TISDSManager;
  ok: boolean;
  sl: TStringList;
  i,code: integer;
  msg: string;
begin
  ok:=FALSE;
  if TestAndRegisterISDSManager(FALSE, msg) then begin
    StartW('Probíhá hledání ...');
    ISDSManager:= TISDSManager.Create(nil);
    sl:= TStringList.Create;
    try
      mtAdresy.EmptyTable;
      Refresh;
      if cbOVM.Checked then begin
        if ISDSManager.NajdiSchrankuOVM(FTest, FPrihlJmeno, FPrihlHeslo, FCertif, FPrihlasit,
          edIDDS.Text, edIC.Text, edNazev.Text, '10', res, retCode, retMsg) then begin
          //memo1.Lines.Text:=res;
          sl.Text:=res;
          ok:=sl.Count>1; // copunt 100, ret code 3 + text moc obecne, count 1 + retcode 2 +text
          code := StrToInt(retCode);
          if code=0 then begin  //je to OK je return 0
            for i:=1 to sl.Count-1 do begin
              mtAdresy.Append;
              mtAdresyIDDS.Value:=GetCsvFieldByName(sl[0]+#13#10+sl[i],'sbID', 1);
              mtAdresyAdresa.Value:=
                GetCsvFieldByName(sl[0]+#13#10+sl[i],'firmName', 1)+', '+
                GetCsvFieldByName(sl[0]+#13#10+sl[i],'adZipCode', 1)+' '+
                GetCsvFieldByName(sl[0]+#13#10+sl[i],'adCity', 1)+', IČ: '+
                GetCsvFieldByName(sl[0]+#13#10+sl[i],'ic', 1);
              mtAdresy.Post;
            end;
            btVyhledat.Default:=FALSE;
            btPrevzit.Default:=TRUE;
          end
          else if(code=2) then begin
            MessageInfo(Caption, 'Nebyla nalezena žádná datová schránka v seznamech'#13#10'OVM (orgány veřejné moci).', [MBOK]);
          end
          else if(code=3) then begin
            MessageInfo(Caption, 'Příliš obecné zadání pro hledání.'#13#10'Upřesněte hledaný subjekt.', [MBOK]);
          end
          else begin
            MessageErr(Caption, 'Chyba při hledání datové schránky, '+ retCode + ': '#13#10+ retMsg, [MBOK]);
          end;

        end
        else begin
          if CheckMsgUnauthorized(retMsg) then
            MessageErr(Caption, 'Chyba při přihlášení k datové schránce. Nesprávné přihlašovací údaje.',[MBOK])
          else
            MessageErr(Caption, 'Chyba při hledání, '+ retCode + ': ' +
              retMsg, [MBOK]);
        end;
      end;

      {if not ok then begin
        if ISDSManager.NajdiSchrankuPO(FTest, FPrihlJmeno, FPrihlHeslo,
          edIDDS.Text, edIC.Text,'', edNazev.Text, '0', res, retCode, retMsg) then begin
          edVysledek.Text:=res;
          memo1.Lines.Text:=res;
          sl.Text:=res;
        end
        else
          MessageErr(Caption, 'Chyba při hledání schránky, '+ retCode + ': ' + retMsg,
            [MBOK]);
      end;}

      grAdresyView1.Controller.ClearSelection;
      if grAdresyView1.ViewData.RecordCount>0 then begin
        grAdresyView1.ViewData.Records[0].Focused := True;
        grAdresyView1.Controller.FocusedRecord.Selected := True;
        if grAdresy.CanFocus then
          grAdresy.SetFocus;
      end;
    finally
      sl.Free;
      ISDSManager.Free;
      StopW;
    end;
  end
  else
    Close;
end;

procedure TfmDSHledani.StartW(const AStatusText: string);
begin
  StartWait;
  laInfo.Caption:=AStatusText;
  Refresh;
end;

procedure TfmDSHledani.StopW;
begin
  StopWait;
  laInfo.Caption:='';
  Refresh;
end;

end.

{ 24.2.2021 13:10:12 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in V DoSelectAdrs odstraneni warningu  }
{ 13.9.2019 12:10:20 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 16.3.2016 11:27:09 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in Vyber adres pro samostatny FA  }
unit ESelectAdrs;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RVStyle, RVScroll, RichView, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, ExtCtrls, cxDataStorage, ImgList,
  cxImageComboBox, kbmMemTable, kbmMemBinaryStreamFormat,
  cxLookAndFeelPainters, cxGridCustomPopupMenu, cxGridPopupMenu, Menus,
  cxGridBandedTableView, cxGridDBBandedTableView, cxButtons, Res_FA,
  cxLookAndFeels, cxNavigator;

function DoSelectAdrs(out AIdDS, ANazev: string): boolean;

type
  TfmSelectAdrs = class(TForm)
    paHeader: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel4: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    gDBBandedTV: TcxGridDBBandedTableView;
    pmMain: TPopupMenu;
    pmItemCustomize: TMenuItem;
    cxGridPMain: TcxGridPopupMenu;
    mtSelAdrs: TkbmMemTable;
    dsSelAdrs: TDataSource;
    mtSelAdrsIdDS: TStringField;
    mtSelAdrsNazev: TStringField;
    mtSelAdrsJmeno: TStringField;
    mtSelAdrsPrijmeni: TStringField;
    mtSelAdrsMisto: TStringField;
    gDBBandedTVIdDS: TcxGridDBBandedColumn;
    gDBBandedTVNazev: TcxGridDBBandedColumn;
    gDBBandedTVJmeno: TcxGridDBBandedColumn;
    gDBBandedTVPrijmeni: TcxGridDBBandedColumn;
    gDBBandedTVMisto: TcxGridDBBandedColumn;
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure gDBBandedTVKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gDBBandedTVDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure VyberCancel;
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    procedure Init;
    procedure VyberOK;
    procedure NaplnData;
  public
    { Public declarations }
  end;

var
  fmSelectAdrs: TfmSelectAdrs;

implementation

uses
  cxDataUtils, FCommonUtils, JclStrings, IniFiles,
  SpolFunkce, DateUtils, DbUtils, Main, FUtils;

{$R *.dfm}

procedure TfmSelectAdrs.Init;
begin
  mtSelAdrs.Open;
  NaplnData;
end;

function DoSelectAdrs(out AIdDS, ANazev: string): boolean;
begin
  AIdDS:='';
  with TfmSelectAdrs.Create(nil) do
  try
    Init;
    Result := ShowModal = mrOK;
    if Result then begin
      AIdDS := mtSelAdrsIdDS.AsString;

      if mtSelAdrsNazev.AsString<>'' then
        ANazev := mtSelAdrsNazev.AsString
      else
        ANazev := Trim(mtSelAdrsJmeno.AsString + ' ' + mtSelAdrsPrijmeni.AsString);
    end;
  finally
    Free;
  end;
end; {DoSelectTskps}



procedure TfmSelectAdrs.VyberCancel;
begin
  inherited;
  Close;
  Self.ModalResult := mrCancel;
end;


procedure TfmSelectAdrs.btnCancelClick(Sender: TObject);
begin
  inherited;
  VyberCancel;
end;

procedure TfmSelectAdrs.FormDestroy(Sender: TObject);
begin
  inherited;
  fmSelectAdrs := nil;
end;

procedure TfmSelectAdrs.gDBBandedTVKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Shift=[]) then begin
    if (Key=Vk_Escape) then
      VyberCancel
    {else if (Key=Vk_Return) then
      VyberOk}
  end;
end;


procedure TfmSelectAdrs.VyberOK;
begin
  Close;
  Self.ModalResult := mrOK;
end;

procedure TfmSelectAdrs.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift=[]) and (Key=Vk_Escape) then begin
    VyberCancel;
  end;
end;

procedure TfmSelectAdrs.gDBBandedTVDblClick(Sender: TObject);
begin
  inherited;
  VyberOk;
end;

procedure TfmSelectAdrs.FormShow(Sender: TObject);
begin
  inherited;
  LoadFormStateFromIni;
end;

procedure TfmSelectAdrs.SaveFormStateToIni;
var iniFile: TMemIniFile;
begin
  if not GfaMain.CanWriteToIniFile then
    EXIT;

  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    iniFile.WriteInteger(Name, 'Left', Left);
    iniFile.WriteInteger(Name, 'Top', Top);
    iniFile.WriteInteger(Name, 'Width', Width);
    iniFile.WriteInteger(Name, 'Height', Height);
    iniFile.WriteString(Name, 'IDDS', mtSelAdrsIdDS.AsString);
    SaveMemIni(iniFile);
  finally
    iniFile.Free;
  end;
end;

procedure TfmSelectAdrs.LoadFormStateFromIni;
var
  iniFile: TMemIniFile;
  idDs: string;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    Left := iniFile.ReadInteger(Name, 'Left', GfaMain.Left + 5);
    Top := iniFile.ReadInteger(Name, 'Top', GfaMain.Top + 30);
    Width := iniFile.ReadInteger(Name, 'Width', 412);
    Height := iniFile.ReadInteger(Name, 'Height', 300);

    idDS := iniFile.ReadString(Name, 'IDDS', '');
    if (idDs<>'') then
      mtSelAdrs.Locate(mtSelAdrsIdDS.FieldName, idDs, []);
  finally
    iniFile.Free;
  end;
end;

procedure TfmSelectAdrs.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormStateToIni;
end;


(*

function ClientParam(AParamName: string; ABankAccountIndex: integer = 0):
  string;
var
  ba: TStringList;
  bucet, bkod, bspecSym, bnazev, bmisto, biban, bswift: string;

  procedure ExtractFromBaUcet(const ARow: string);
  var
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      if ARow<>'' then begin
        sl.CommaText := ARow;
        if sl.Count>0 then
          bucet := sl[0];
        if sl.Count>1 then
          bkod := sl[1];
        if sl.Count>2 then
          bspecSym := sl[2];
        if sl.Count>3 then
          bnazev := sl[3];
        if sl.Count>4 then
          bmisto := sl[4];
        if sl.Count>5 then
          biban := sl[5];
        if sl.Count>6 then
          bswift := sl[6];
      end
      else begin
        bucet := '';
        bkod := '';
        bspecSym := '';
        bnazev := '';
        bmisto := '';
        biban := '';
        bswift := '';
      end;
    finally
      sl.Free;
    end;
  end;
begin
  Result := GfaMain.FClientParam.Values[AParamName];
  if Result = '' then begin
    //aby se neprovadelo zbytecne 5 testu
    if (Copy(UpperCase(AParamName), 1, 4) =
      Copy(UpperCase(cClientParamBankAccount), 1, 4)) then begin
      ba := TStringList.Create;
      try
        ba.Text := GetSection(GfaMain.FClientParam.Text,
          cFormUserSettingsBankAccountsLabel);
        if (ba.Count > 0) and (ABankAccountIndex < ba.Count) then begin
          ExtractFromBaUcet(ba[ABankAccountIndex]);
          //BankAccountFull
          {if (UpperCase(AParamName) = UpperCase(cClientParamBankAccountFull))} //opt
          if AnsiSameText(AParamName,cClientParamBankAccountFull)
            then
          begin
            Result := StrTrimCharRight(bucet + '/' + bkod, '/');
            if bspecSym <> '' then
              Result := Result + ' ' + {SmsgSpecSym + ' ' +} bspecSym;
          end
          //BankAccount
          else if AnsiSameText(AParamName,cClientParamBankAccount)
            then
            Result := StrTrimCharRight(bucet + '/' + bkod, '/')
          //BankAccountNumber
          else if AnsiSameText(AParamName,cClientParamBankNumber)
            then
            Result := bucet
          //BankCode
          else if AnsiSameText(AParamName,cClientParamBankCode) then
            Result := bkod
          //BankSpecSym
          else if AnsiSameText(AParamName,cClientParamBankSpecSym)
            then
            Result := bspecsym
          //BankName
          else if AnsiSameText(AParamName,cClientParamBankName) then
            Result := bnazev
          //BankCiti
          else if AnsiSameText(AParamName,cClientParamBankCity) then
            Result := bmisto
          //BankIBAN
          else if AnsiSameText(AParamName,cClientParamBankIBAN) then
            Result := biban
          //BankSWIFT
          else if AnsiSameText(AParamName,cClientParamBankSWIFT) then
            Result := bswift
          //BankAccounts
          else if AnsiSameText(AParamName,cClientParamBankAccounts)
            then
            Result := ba.CommaText;
        end
        else
          Result := '';
      finally
        ba.Free;
      end;
    end
    else begin
      if AnsiSameText(AParamName,'FPPrefix') or
        AnsiSameText(AParamName,'FPFirstName') or
        AnsiSameText(AParamName,'FPLastName') then
        AParamName := Copy(AParamName, 3, maxint);
      Result := GfaMain.FClientParam.Values[AParamName];
    end;
  end;
end; {ClientParam}
*)

procedure TfmSelectAdrs.NaplnData;

  procedure AddRec(
    const ARow: string;
    AR: TStringList);
  begin
    AR.CommaText := ARow;
    if (AR.Count>0) AND (AR.Count<=5) then begin
      mtSelAdrs.Insert;
      mtSelAdrsIdDS.AsString := AR[0];
      mtSelAdrsNazev.AsString := AR[1];
      mtSelAdrsJmeno.AsString := AR[2];
      mtSelAdrsPrijmeni.AsString := AR[3];
      mtSelAdrsMisto.AsString := AR[4];
      mtSelAdrs.Post;
    end;
  end;

const
  cAdresIDDSGr = '[AdresIDDS]';
var
  adr, r: TStringList;
  i: integer;
begin
  mtSelAdrs.EmptyTable;

  adr := TStringList.Create;
  r := TStringList.Create;
  try
    adr.Text := GetSection(GfaMain.FClientParam.Text, cAdresIDDSGr);
    for i := 0 to adr.Count - 1 do begin
      AddRec(adr[i], r);
    end;
  finally
    adr.Free;
    r.Free;
  end;
end;

end.

{ 3.10.2018 12:27:11 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in uprava procedury ImportRowFromCSV  }
{ 22.8.2018 10:21:31 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in zarazeni do projektu  }
{ 20.8.2018 10:19:30 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in   }
unit DatamodPrevPrik;

interface

uses
  SysUtils, Classes, cxClasses, DB, kbmMemTable
  ;

type
  TdmPrevPrik = class(TDataModule)
    taFirmaUct: TkbmMemTable;
    taFirmaUctCaNazevBanky: TStringField;
    taFirmaUctCaNazevCisloUc: TStringField;
    taFirmaUctCaNazevDoklRady: TStringField;
    taFirmaUctNazevUctu: TStringField;
    taFirmaUctBaUcet: TStringField;
    taFirmaUctKodBanky: TStringField;
    taFirmaUctSpecSym: TStringField;
    taFirmaUctHlavni: TBooleanField;
    taFirmaUctMisto: TStringField;
    taFirmaUctZmeneno: TDateTimeField;
    taFirmaUctVyber: TStringField;
    taFirmaUctPouzivaHB: TBooleanField;
    taFirmaUctFormatHB: TStringField;
    taFirmaUctZkrNazev: TStringField;
    taFirmaUctZkrIdentifikace: TStringField;
    taFirmaUctCisloKlienta: TStringField;
    taFirmaUctCisloPobocky: TStringField;
    taFirmaUctIntervalOd: TStringField;
    taFirmaUctIntervalDo: TStringField;
    taFirmaUctPevnaCastKlice: TStringField;
    taFirmaUctCestaProPP: TStringField;
    taFirmaUctCestaKVypisu: TStringField;
    taFirmaUctDoklRada: TStringField;
    taFirmaUctCisloStanice: TStringField;
    taFirmaUctIdentPorizovatele: TStringField;
    taFirmaUctPresunoutVypisPoZprac: TBooleanField;
    taFirmaUctCestaProPresunVypisu: TStringField;
    taFirmaUctCestaKeKomunikSW: TStringField;
    taFirmaUctUID: TIntegerField;
    taFirmaUctIBAN: TStringField;
    taFirmaUctSWIFT: TStringField;
    taFirmaUctAdresaBanky: TStringField;
    taFirmaUctFormatHBP: TStringField;
    taPrevPrik: TkbmMemTable;
    taPrevPrikP: TkbmMemTable;
    taPrevPrikDoklRada: TStringField;
    taPrevPrikDoklCislo: TStringField;
    taPrevPrikDoklad: TStringField;
    taPrevPrikDatum: TDateField;
    taPrevPrikDatumSpl: TDateField;
    taPrevPrikNazevUctu: TStringField;
    taPrevPrikBaUcet: TStringField;
    taPrevPrikKodBanky: TStringField;
    taPrevPrikKonSym: TStringField;
    taPrevPrikSpecSym: TStringField;
    taPrevPrikBanka: TStringField;
    taPrevPrikMena: TStringField;
    taPrevPrikCelkem: TFloatField;
    taPrevPrikProVnitPotreby: TStringField;
    taPrevPrikInkaso: TBooleanField;
    taPrevPrikPocetPolozek: TIntegerField;
    taPrevPrikPoznamka: TStringField;
    taPrevPrikPoznKlic: TIntegerField;
    taPrevPrikZmeneno: TDateTimeField;
    taPrevPrikVyber: TStringField;
    taPrevPrikUID: TIntegerField;
    taPrevPrikIBAN: TStringField;
    taPrevPrikSWIFT: TStringField;
    taPrevPrikAdresaBanky: TStringField;
    taPrevPrikPCaFirmaNazev: TStringField;
    taPrevPrikPCaDatumSpl: TDateField;
    taPrevPrikPDoklRada: TStringField;
    taPrevPrikPDoklCislo: TStringField;
    taPrevPrikPKlic: TIntegerField;
    taPrevPrikPDoklSRada: TStringField;
    taPrevPrikPDoklSCislo: TStringField;
    taPrevPrikPDokladS: TStringField;
    taPrevPrikPFirma: TStringField;
    taPrevPrikPBaUcet: TStringField;
    taPrevPrikPKodBanky: TStringField;
    taPrevPrikPSpecSym: TStringField;
    taPrevPrikPCastka: TFloatField;
    taPrevPrikPVarSym: TStringField;
    taPrevPrikPKonSym: TStringField;
    taPrevPrikPZprava: TStringField;
    taPrevPrikPPoznamka: TStringField;
    taPrevPrikPZmeneno: TDateTimeField;
    taPrevPrikPVyber: TStringField;
    taPrevPrikPUID: TIntegerField;
    taPrevPrikPIBAN: TStringField;
    taPrevPrikPSWIFT: TStringField;
    taPrevPrikPAdresaBanky: TStringField;
    gBoFirma: TkbmMemTable;
    gBoFirmaNazev: TStringField;
    gBoFirmaTitul: TStringField;
    gBoFirmaJmeno: TStringField;
    gBoFirmaPrijmeni: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure CloseTables;
    function InitTable(ATable: TkbmMemTable): boolean;
    procedure ImportRowFromCSV(ACsvRow: TStringList; ATable: TkbmMemTable);
    procedure ImportFirmaUcFromCSV(ACsvRow: string; ATable: TkbmMemTable);
    procedure ImportDataFromCSV(const ACsvData: string; ATable: TkbmMemTable);
  public
    { Public declarations }
    //procedure LoadTablesFromCSV(const APrevPrikCsv, APrevPrikPCsv, AFirmaUctCsv: string);
    function CreateHBWithImportCSV(const ABaUcet,
      AKodBanky, AFormatHB: string;
      const APrevPrikCsv, APrevPrikPCsv, ABoFirmaCsv, AFirmaUctCsv: string;
      var AOutText, AMsg: string): boolean;
  end;

var
  dmPrevPrik: TdmPrevPrik;

implementation

uses
  QaCPrevPrik, FCommonUtils;

{$R *.dfm}

procedure TdmPrevPrik.CloseTables;
begin
  taFirmaUct.Close;
  taPrevPrikP.Close;
  taPrevPrik.Close;
  gBoFirma.Close;
end;

procedure TdmPrevPrik.DataModuleDestroy(Sender: TObject);
begin
  CloseTables;
end;

function TdmPrevPrik.InitTable(ATable: TkbmMemTable): boolean;
begin
  if ATable.Active then
    ATable.Close;
  ATable.EmptyTable;
  ATable.Open;
  //
  Result := ATable.Active;
end;

procedure TdmPrevPrik.ImportRowFromCSV(ACsvRow: TStringList; ATable: TkbmMemTable);

  function GetVal(AItemIndex: integer): string;
  begin
    Result := '';
    if (AItemIndex >= 0) and (AItemIndex < ACsvRow.Count) then
      Result := ACsvRow[AItemIndex];
  end;

begin
  ATable.Append;
  if ATable = taPrevPrik then begin
    ATable.FindField('BaUcet').Value := GetVal(0);
    ATable.FindField('KodBanky').Value := GetVal(1);
    ATable.FindField('Celkem').Value := StrToFloatSafe(GetVal(2));
    ATable.FindField('DatumSpl').Value := StrToDateSafe(GetVal(3));
    ATable.FindField('Inkaso').Value := StrToBoolSafe(GetVal(4));
    ATable.FindField('Mena').Value := GetVal(5);
  end;
  if ATable = taPrevPrikP then begin
    ATable.FindField('BaUcet').Value := GetVal(0);
    ATable.FindField('KodBanky').Value := GetVal(1);
    ATable.FindField('Castka').Value := StrToFloatSafe(GetVal(2));
    ATable.FindField('KonSym').Value := GetVal(3);
    ATable.FindField('VarSym').Value := GetVal(4);
    ATable.FindField('SpecSym').Value := GetVal(5);
    ATable.FindField('CaFirmaNazev').Value := GetVal(6); //nelze pouzit udaj Firma, protoze je jen na 10 znaku
  end;
  if ATable = gBoFirma then begin
    ATable.FindField('Nazev').Value := GetVal(0);
    ATable.FindField('Titul').Value := GetVal(1);
    ATable.FindField('Jmeno').Value := GetVal(2);
    ATable.FindField('Prijmeni').Value := GetVal(3);
  end;
  if ATable = taFirmaUct then begin
    ATable.FindField('IntervalOd').Value := GetVal(0);
    ATable.FindField('IntervalDo').Value := GetVal(1);
    ATable.FindField('CisloKlienta').Value := GetVal(2);
    ATable.FindField('CisloPobocky').Value := GetVal(3);
  end;
  ATable.Post;
end;

//- pro tabulku taFirmaUc nejsou v FA ve formulari prikazu k uhrade podklady,
//  pritom ale nektere (nize vyjmenovane) potrebuji mit defaultni hodnotu
//  proto zde plnime
//- funguje ale i v pripade, ze csv bude z formulare naplnene 
procedure TdmPrevPrik.ImportFirmaUcFromCSV(ACsvRow: string; ATable: TkbmMemTable);
var
  slCsv: TStringList;
begin
  if not InitTable(ATable) then
    Exit;
  //
  slCsv:=TStringList.Create;
  try
    if ACsvRow <> '' then    
      slCsv.CommaText := ACsvRow
    else begin
      slCsv.Add('001');  //IntervalOd
      slCsv.Add('999');  //IntervalDo
      slCsv.Add('000');  //CisloKlienta
      slCsv.Add('000');  //CisloPobocky
    end;  
    ImportRowFromCSV(slCsv, ATable);
  finally
    slCsv.Free;
  end;
end;

//naimportuje data z CSV do tabulky
procedure TdmPrevPrik.ImportDataFromCSV(const ACsvData: string; ATable: TkbmMemTable);
var
  i: Integer;
  sl, slCsv: TStringList;
begin
  if ACsvData = '' then
    Exit;
  //
  if not InitTable(ATable) then
    Exit;
  //
  slCsv:=TStringList.Create;
  sl:=TStringList.Create;
  sl.Text:=Replace(';',ACsvData,cCRLF);
  try
    for i:=0 to sl.Count-1 do begin
      slCsv.CommaText := sl[i];
      ImportRowFromCSV(slCsv, ATable);
    end;
  finally
    slCsv.Free;
    sl.Free;
  end;
end;

function TdmPrevPrik.CreateHBWithImportCSV(const ABaUcet,
  AKodBanky, AFormatHB: string;
  const APrevPrikCsv, APrevPrikPCsv, ABoFirmaCsv, AFirmaUctCsv: string;
  var AOutText, AMsg: string): boolean;
begin
  ImportDataFromCSV(APrevPrikCsv, taPrevPrik);
  ImportDataFromCSV(APrevPrikPCsv, taPrevPrikP);
  ImportDataFromCSV(ABoFirmaCsv, gBoFirma);
  ImportFirmaUcFromCSV(AFirmaUctCsv, taFirmaUct);
  //
  Result := CreateExportTextHB(ABaUcet, AKodBanky, AFormatHB, AOutText, AMsg);
end;  

end.

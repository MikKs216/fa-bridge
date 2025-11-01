{ 26.10.2017 15:43:20 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Doplneni nekolika funkci  }
{ 10.10.2017 14:19:10 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Pridani designeru FR3 reportu  }
unit FastRepFunc;
 
interface
 
implementation
 
uses Forms, SysUtils, Classes, fs_iinterpreter, FScriptUtils, FCommonUtils;

type
 TFunctions = class(TfsRTTIModule)
private
  function CallMethod(Instance: TObject; ClassType: TClass;
                      const MethodName: String; var Params: Variant): Variant;
public
  constructor Create(AScript: TfsScript); override;
end;
 
function FrNormalZipCodeCzech(APSC: string): string;
begin
  Result := FScriptUtils.NormalZipCodeCzech(APSC);
end;

function FrLstLookup(const AListName: string; AForDate: TDateTime;
  AKeyFieldNames: string; AkeyFieldValues: variant;
  const AResultFieldName: string): variant;
begin
  Result := FScriptUtils.LstLookup(AListName, AForDate, AKeyFieldNames,
                                   AkeyFieldValues, AResultFieldName);
end;

function FrReplace(const ASearch, AStr, AReplace: string;
  AIgnoreCase: boolean = FALSE): string;
begin
  Result := FCommonUtils.Replace(ASearch, AStr, AReplace, AIgnoreCase);
end;

function FrCalcQRCodeText(
  const AIBAN, ABU: string;
  const ACastka: double;
  const AMenaUctu, APlatce, AVarSym, ASpecSym, AKonSym, AZpravaPrijemci: string): string;
var
  iban: string;
begin
  iban := Cond(AIBAN <> '', AIBAN, ConvertBU2IBAN(ABU, AMenaUctu));
  Result := FCommonUtils.CalcQRCodeText(iban, ACastka, AMenaUctu,
              APlatce, AVarSym, ASpecSym, AKonSym, AZpravaPrijemci);
end;

function FrGetLogoPath: string;
begin
  Result := FScriptUtils.GetLogoPath;
end;

function FrCompareVersion(ver1:string; ver2:string):integer;
begin
  Result := FCommonUtils.CompareVersion(ver1, ver2);
end;

function FrGetPrgVersion(AFileName: string = ''): string;
begin
  Result := FCommonUtils.GetPrgVersion(AFileName);
end;

function FrCalcFullAddress(const AUlice, ACisloPopisne, APOBox,
  APSC, AMisto, AOkres, AStat: string;
  AMultiLine: boolean): string;
begin
  Result := FScriptUtils.CalcFullAddress(AUlice, ACisloPopisne, APOBox,
    APSC, AMisto, AOkres, AStat, AMultiLine);
end;

function FrCalcFullBaAccount(const ABankAccount, ABankCode: string;
  ASpecSym: string = ''): string;
begin
  Result := FScriptUtils.CalcFullBaAccount(ABankAccount, ABankCode, ASpecSym);
end;

function FrCalcFullName(const ATitul, AJmeno, APrijmeni,
  ARodnePrijmeni: string; AHodnost: string = ''): string;
begin
  Result := FScriptUtils.CalcFullName(ATitul, AJmeno, APrijmeni, ARodnePrijmeni, AHodnost);
end;

{ TFunctions }

constructor TFunctions.Create;
begin
  inherited Create(AScript);
  with AScript do begin
     AddMethod('function FrNormalZipCodeCzech(APSC: string): string', CallMethod,
               'UserFunctions', 'Upraví PSC na tvar XXX XX');

     AddMethod('function FrLstLookup(const AListName: string; AForDate: TDateTime;'+
                 'AKeyFieldNames: string; AkeyFieldValues: variant;'+
                 'const AResultFieldName: string): variant', CallMethod,
               'UserFunctions', 'Naète hodnoty ze seznamu');

     AddMethod('function FrReplace(const ASearch, AStr, AReplace: string;'+
                'AIgnoreCase: boolean = FALSE): string', CallMethod,
               'UserFunctions', 'Nahradí text jiným textem.');

     AddMethod('function FrCalcQRCodeText(const AIBAN, ABU: string;'+
                'const ACastka: double;'+
                'const AMenaUctu, APlatce, AVarSym, ASpecSym, AKonSym, AZpravaPrijemci: string): string', CallMethod,
               'UserFunctions', 'Vypoèítá QR kód pro platbu.');

     AddMethod('function FrGetLogoPath: string', CallMethod,
               'UserFunctions', 'Vrací sestu k logo souboru.');

     AddMethod('function FrCompareVersion(ver1:string; ver2:string):integer', CallMethod,
               'UserFunctions', 'Porovná ver1 a ver2.');

     AddMethod('function FrGetPrgVersion(AFileName: string = ''): string', CallMethod,
               'UserFunctions', 'Vrací verzi AFileName. Pokud AFileName není vyplnìno, vrací verzi aplikace.');

     AddMethod('function FrCalcFullAddress(const AUlice, ACisloPopisne, APOBox,'+
                'APSC, AMisto, AOkres, AStat: string; AMultiLine: boolean): string', CallMethod,
               'UserFunctions', 'Spojí èásti adresy do jednoho øetìzce.');

     AddMethod('function FrCalcFullBaAccount(const ABankAccount, ABankCode: string; '+
               'ASpecSym: string = ''): string', CallMethod,
               'UserFunctions', 'Spojí bankovní úèet, kód banky a pøíp. spec. symbol do jednoho øetìzce.');

     AddMethod('function FrCalcFullName(const ATitul, AJmeno, APrijmeni,'+
                'ARodnePrijmeni: string; AHodnost: string = ''): string', CallMethod,
               'UserFunctions', 'Spojí jméno, pøíjmení a další èásti do jednoho øetìzce.');
  end;
end;
 
function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
                              const MethodName: String;
                              var Params: Variant): Variant;
begin
  if MethodName = 'FRNORMALZIPCODECZECH' then
     Result := FrNormalZipCodeCzech(Params[0])
  else if MethodName = 'FRLSTLOOKUP' then
     Result := FrLstLookup(Params[0], Params[1], Params[2], Params[3], Params[4])
  else if MethodName = 'FRREPLACE' then
     Result := FrReplace(Params[0], Params[1], Params[2], Params[3])
  else if MethodName = 'FRCALCQRCODETEXT' then
     Result := FrCalcQRCodeText(Params[0], Params[1], Params[2], Params[3], Params[4],
                              Params[5], Params[6], Params[7], Params[8])
  else if MethodName = 'FRGETLOGOPATH' then
     Result := FrGetLogoPath()
  else if MethodName = 'FRCOMPAREVERSION' then
     Result := FrCompareVersion(Params[0], Params[1])
  else if MethodName = 'FRGETPRGVERSION' then
     Result := FrGetPrgVersion(Params[0])
  else if MethodName = 'FRCALCFULLADDRESS' then
     Result := FrCalcFullAddress(Params[0], Params[1], Params[2], Params[3], Params[4],
                              Params[5], Params[6], Params[7])
  else if MethodName = 'FRCALCFULLBAACCOUNT' then
     Result := FrCalcFullBaAccount(Params[0], Params[1], Params[2])
  else if MethodName = 'FRCALCFULLNAME' then
     Result := FrCalcFullName(Params[0], Params[1], Params[2], Params[3], Params[4]);
end;
 
initialization
 fsRTTIModules.Add(TFunctions);
 
end.

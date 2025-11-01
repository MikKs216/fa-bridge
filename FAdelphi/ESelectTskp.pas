{$INCLUDE QGSwitches.inc}
unit ESelectTskp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Db, Grids, DBGrids, FDBGrids, kbmMemTable, QFAbs,
  kbmMemBinaryStreamFormat;

function SelectTskp(const ADefID: string;
  AMultiselect: boolean; const ACaption: string): string;

type
  TfmKSelectTskp = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOK: TButton;
    btCancel: TButton;
    dsSelTskps: TDataSource;
    mtSelTskps: TkbmMemTable;
    mtSelTskpsKlic: TIntegerField;
    mtSelTskpsTskp: TIntegerField;
    mtSelTskpsUsrLock: TBooleanField;
    mtSelTskpsRokZdanovaciObdobi: TIntegerField;
    mtSelTskpsRokPodani: TIntegerField;
    mtSelTskpsSysPozn: TStringField;
    mtSelTskpsUsrPozn: TStringField;
    mtSelTskpsVyber: TBooleanField;
    mtSelTskpsBody: TMemoField;
    mtSelTskpsCaption: TStringField;
    mtFormat: TkbmBinaryStreamFormat;
  private
    procedure Init(const ADefID: string; AMultiselect: boolean;
      const ACaption: string);
    function IsEqualDefInCurrentTskp(const ADefID: string): boolean;
  public
  end;

var
  fmKSelectTskp: TfmKSelectTskp;

implementation

uses
  FSysUtils, DataModK;

{$R *.DFM}

function SelectTskp(const ADefID: string;
  AMultiselect: boolean; const ACaption: string): string;
begin
  Result := '';
  if fmKSelectTskp=nil then
    Application.CreateForm(TfmKSelectTskp, fmKSelectTskp);
  if fmKSelectTskp<>nil then with fmKSelectTskp do begin
    Init(ADefID, AMultiselect, ACaption);
    if ShowModal=mrOK then
      Result:='';//doplnit vysledek
    ShowModal;
    Free;
    fmKSelectTskp:=nil;
  end;
end;

procedure TfmKSelectTskp.Init(const ADefID: string; AMultiselect: boolean;
  const ACaption: string);
var
  sl: TStringList;
  id: integer;
  fltd: boolean;
  ixName: string;
begin
  if ACaption<>'' then
    Caption:=ACaption;
  //
  with dmK do begin
    StartWait;
    taTskp.DisableControls;
    id := taTskpKlic.Value;
    fltd := taTskp.Filtered;
    taTskp.Filtered := FALSE;
    ixName:=taTskp.IndexName;
    taTskp.IndexName := 'ixDisplayByObdobi';
    sl:= TStringList.Create;
    mtSelTskps.Open;
    try
      taTskp.First;
      while not taTskp.EOF do begin
        if IsEqualDefInCurrentTskp(ADefID) then begin
          mtSelTskps.Append;
          CopyRecordByFieldNames(taTskp,mtSelTskps);
          mtSelTskpsVyber.Clear;
          mtSelTskpsCaption.Value:=taTskpCaNazev.Value;
          mtSelTskps.Post;
        end;
        taTskp.Next;
      end;
      mtSelTskps.First;
    finally
      sl.Free;
      taTskp.IndexName := ixName;
      taTskp.Filtered := fltd;
      taTskp.Locate(taTskpKlic.FieldName, id, []);
      taTskp.EnableControls;
      StopWait;
    end;
  end;
end;

function TfmKSelectTskp.IsEqualDefInCurrentTskp(const ADefID: string): boolean;

  function TranslateDefID(const ADefID: string): integer;
  var
    sl: TStringList;
    s: string;
  begin
    sl:= TStringList.Create;
    try
      //1997
      sl.Add('dz_97DPFOA5405A_1=9701');
      sl.Add('dz_97DPFOB5405_4=9702');
      sl.Add('dz_97DPPO5404_7=9703');
      sl.Add('dz_97DPH5401_8=9704');
      sl.Add('dz_97DS5407_6=9705');
      sl.Add('dz_97OSSZ=9706');
      sl.Add('dz_97ZP=9707');

      //1998
      sl.Add('dz_98DPFOA5405A_2=9801');
      sl.Add('dz_98DPFOB5405_5=9802');
      sl.Add('dz_98DPFOC5488_1=9808');
      sl.Add('dz_98DPPO5404_8=9803');
      sl.Add('dz_97DPH5401_8=9804');
      sl.Add('dz_97DS5407_6=9805');
      sl.Add('dz_98OSSZ=9806');
      sl.Add('dz_98ZP=9807');
      sl.Add('dz_98VykazZS=9809');
      sl.Add('dz_98VykazZSZkr=9810');
      sl.Add('dz_98CashFlow=9811');
      sl.Add('dz_98Rozvaha=9812');
      sl.Add('dz_98RozvahaZkr=9813');

      //1999
      sl.Add('dz_99DPFOA5405A_3=9901');
      sl.Add('dz_99DPFOB5405_6=9902');
      sl.Add('dz_99DPPO5404_9=9903');
      sl.Add('dz_97DPH5401_8=9904');
      sl.Add('dz_99DS5407_7=9905');
      sl.Add('dz_99OSSZ=9906');
      sl.Add('dz_99ZP=9907');
      sl.Add('dz_99DPFOC5488_1=9908');
      sl.Add('dz_98VykazZS=9909');
      sl.Add('dz_98VykazZSZkr=9910');
      sl.Add('dz_98CashFlow=9911');
      sl.Add('dz_98Rozvaha=9912');
      sl.Add('dz_98RozvahaZkr=9913');
      sl.Add('dz_99DPH5401_9=9914');

      //2000
      sl.Add('dz_00DPFOA5405A_4=1');
      sl.Add('dz_00DPFOB5405_7=2');
      sl.Add('dz_00DS5407_8=5');
      sl.Add('dz_00OSSZ=6');
      sl.Add('dz_00ZP=7');
      sl.Add('dz_00DPFOC5488_3=8');
      sl.Add('dz_98VykazZS=9');
      sl.Add('dz_98VykazZSZkr=10');
      sl.Add('dz_98CashFlow=11');
      sl.Add('dz_98Rozvaha=12');
      sl.Add('dz_98RozvahaZkr=13');
      sl.Add('dz_99DPH5401_9=14');
      sl.Add('dz_00DPH5401_10=15');

      sl.Add('df_00DPFOZ5457_11=30');
      sl.Add('df_00DPFOZ5459_8=31');

      sl.Add('df_00DPFOZ5460_9=32');
      sl.Add('df_00DPFOZ54601_6=33');
      sl.Add('df_00DPFOZ5490_1=34');
      sl.Add('df_00DPFOZ5466_5=37');
      sl.Add('df_00DPFOZ54901_1=36');

      sl.Add('dz_00ZPMA=35');
      sl.Add('dz_00DPPO5404_10=38');

      //2001
      sl.Add('dz_01DPFOA5405A_5=101');
      sl.Add('dz_01DPFOB5405_8=102');
      sl.Add('dz_01OSSZ=103');
      sl.Add('dz_01ZP=104');
      sl.Add('dz_01ZPMA=105');
      sl.Add('dz_01DS5407_9=110');
      sl.Add('dz_01DPH5401_11=116');

      sl.Add('dr_01Reg5101_9=120');
      sl.Add('dr_01Reg5102_9=122');
      sl.Add('dr_01Reg51041_7=123');
      sl.Add('dr_01Reg51042_6=124');
      sl.Add('dr_01Reg5105_5=125');
      sl.Add('dr_01Reg5107_1=126');
      sl.Add('dr_01Reg5108_1=128');
      sl.Add('dr_01Reg51121_5=129');

      sl.Add('df_01DPFOZ5459_9=131');
      sl.Add('df_00DPFOZ5460_9=180');
      sl.Add('df_00DPFOZ5466_5=181');
      sl.Add('df_01DPFOZ54901_2=182');
      sl.Add('df_01DPFOZ54601_7=183');
      sl.Add('df_01DPFOZ5490_2=184');
      sl.Add('df_01DPFOZ5457_12=185');

      sl.Add('dl_01SD5402PF_3=135');
      sl.Add('dl_01SD5480_6=136');
      sl.Add('dl_01SD5505_2=137');
      sl.Add('dl_01SD5506_1=138');

      sl.Add('dt_01MAJ5410_5=144');
      sl.Add('dt_01MAJ5402_2=145');
      sl.Add('dt_01MAJ5409_5=146');
      sl.Add('dt_01MAJ54091_5=147');
      sl.Add('dt_01MAJ5433_3=148');

      sl.Add('dz_01DPPO5404_11=150');
      sl.Add('dz_01DPPO5404B5_11=155');

      sl.Add('dz_01DPPO5404C1_11=179');
      sl.Add('dz_01VykazZS=151');
      sl.Add('dz_01VykazZSZkr=152');
      sl.Add('dz_01Rozvaha=153');
      sl.Add('dz_01RozvahaZkr=154');
      sl.Add('dz_98CashFlow=156');

      sl.Add('dl_01SD5505_3=160');
      sl.Add('dl_01SD5506_2=161');
      sl.Add('dl_01SD5402PF_4=162');

      sl.Add('dr_01Reg5101_10=163');
      sl.Add('dr_01Reg5102_10=164');
      sl.Add('dr_01Reg5107_2=165');

      sl.Add('dl_01SD5518_1=170');

      sl.Add('dt_01MAJ5410_6=174');
      sl.Add('dt_01MAJ5402_3=175');
      sl.Add('dt_01MAJ5409_6=176');
      sl.Add('dt_01MAJ54091_6=177');
      sl.Add('dt_01MAJ5433_4=178');

      //2002

      sl.Add('dz_02DPFOA5405A_6=2001');
      sl.Add('dz_02DPFOB5405_9=2002');
      sl.Add('dz_02OSSZ=2003');
      sl.Add('dz_02ZP=2004');
      sl.Add('dz_02ZPMA=2005');
      sl.Add('dz_02DPPO5404_12=250');
      sl.Add('dz_01DS5407_9=2040');
      sl.Add('dz_01DPH5401_11=2050');

      sl.Add('dz_01VykazZS=2101');
      sl.Add('dz_01VykazZSZkr=2102');
      sl.Add('dz_01Rozvaha=2103');
      sl.Add('dz_01RozvahaZkr=2104');
      sl.Add('dz_98CashFlow=2105');

      sl.Add('dz_02VykazZS=2111');
      sl.Add('dz_02VykazZSZkr=2112');
      sl.Add('dz_02Rozvaha=2113');
      sl.Add('dz_02RozvahaZkr=2114');
      sl.Add('dz_02CashFlow=2115');

      sl.Add('dr_01Reg51041_7=2303');
      sl.Add('dr_01Reg51042_6=2304');
      sl.Add('dr_01Reg5105_5=2305');
      sl.Add('dr_01Reg5108_1=2307');
      sl.Add('dr_01Reg51121_5=2308');
      sl.Add('dr_01Reg5101_10=2309');
      sl.Add('dr_01Reg5102_10=2310');
      sl.Add('dr_01Reg5107_2=2311');

      sl.Add('dl_01SD5480_6=2402');
      sl.Add('dl_01SD5505_3=2407');
      sl.Add('dl_01SD5506_2=2408');
      sl.Add('dl_01SD5402PF_4=2409');
      sl.Add('dl_01SD5518_1=2410');

      sl.Add('dt_01MAJ5402_3=2505');
      sl.Add('dt_01MAJ5410_6=2510');
      sl.Add('dt_01MAJ5409_6=2512');
      sl.Add('dt_01MAJ54091_6=2513');
      sl.Add('dt_01MAJ5433_4=2514');

      sl.Add('df_02DPFOZ5459_9=2131');
      sl.Add('df_02DPFOZ5460_10=2180');
      sl.Add('df_02DPFOZ5466_6=2181');
      sl.Add('df_02DPFOZ5466A_1=2186');
      sl.Add('df_01DPFOZ54901_2=2182');
      sl.Add('df_01DPFOZ54601_7=2183');
      sl.Add('df_02DPFOZ5490_3=2184');
      sl.Add('df_02DPFOZ5457_13=2185');

      //2003

      sl.Add('dz_01DPH5401_11=3050');

      sl.Add('dz_03VykazZS=3111');
      sl.Add('dz_03VykazZSUC=3112');
      sl.Add('dz_03Rozvaha=3115');
      sl.Add('dz_02CashFlow=3117');

      sl.Add('dr_01Reg51041_7=3303');
      sl.Add('dr_01Reg51042_6=3304');
      sl.Add('dr_01Reg5105_5=3305');
      sl.Add('dr_01Reg5108_1=3307');
      sl.Add('dr_01Reg51121_5=3308');
      sl.Add('dr_01Reg5101_10=3309');
      sl.Add('dr_01Reg5102_10=3310');
      sl.Add('dr_01Reg5107_2=3311');

      sl.Add('dl_01SD5480_6=3402');
      sl.Add('dl_01SD5505_3=3407');
      sl.Add('dl_01SD5506_2=3408');
      sl.Add('dl_01SD5402PF_4=3409');
      sl.Add('dl_01SD5518_1=3410');

      sl.Add('dt_01MAJ5402_3=3505');
      sl.Add('dt_03MAJ5410_7=3510');
      sl.Add('dt_01MAJ5409_6=3512');
      sl.Add('dt_03MAJ54091_7=3513');
      sl.Add('dt_03MAJ5433_5=3514');
      //
      s:=sl.Values[ADefID];
      if IsInteger(s) then
        Result:=StrToInt(sl.Values[ADefID])
      else
        Result:=0;  
    finally
      sl.Free;
    end;
  end;

  {-----------------------------------------------------------------------------
  CountListItems
    Vraci pocet polozek v seznamu textu oddelenych carkou
  -----------------------------------------------------------------------------}

  function CountListItems(const ACSVList: string): integer;
  var
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      sl.CommaText := ACSVList;
      Result := sl.Count;
    finally
      sl.Free;
    end;
  end; {CountListItems}

  {-----------------------------------------------------------------------------
  GetListItem
    Vraci polozku seznamu identifikovanou poradim AItemIndex (pocitano od nuly).
    Kdyz neexistuje nebo ACSVList je prazdny, vraci prazdny string
  -----------------------------------------------------------------------------}

  function GetListItem(const ACSVList: string; AItemIndex: integer): string;
  var
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      sl.CommaText := ACSVList;
      if (AItemIndex >= 0) and (AItemIndex < sl.Count) then
        Result := sl[AItemIndex]
      else
        Result := '';
    finally
      sl.Free;
    end;
  end; {GetListItem}


var
  sl: TStringList;
  i: integer;
begin
  with dmK do begin
    sl:= TStringList.Create;
    try
      sl.Text:=taTskpBody.Value;
      for i:=0 to CountListItems(ADefID)-1 do begin
        Result:=sl.Values['DefID']=GetListItem(ADefID,i);
        if Result then
          BREAK;
      end;
      if not Result then begin
        for i:=0 to CountListItems(ADefID)-1 do begin
          Result:=taTskpTskp.Value=TranslateDefID(GetListItem(ADefID,i));
          if Result then
            BREAK;
        end;
      end;
    finally
      sl.Free;
    end;
  end;
end;

end.


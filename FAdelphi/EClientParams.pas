{ 13.9.2019 12:10:11 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 16.10.2012 11:41:57 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 16.11.2006 16:52:40 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 3.11.2006 16:23:05 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 13.10.2006 16:00:31 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 7.9.2005 16:16:27 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 24.6.2005 14:36:09 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
unit EClientParams;
{$I Switches.inc}

//Unit pro ukladani a zobrazovani parametru. Ulozeni v rozsirenem ini formatu
//  [NazevSekce]
//  NazevUdaje = HodnotaUdaje //PopisUdajeCaption

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxContainer, cxEdit, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, kbmMemTable, kbmMemBinaryStreamFormat,
  cxGridBandedTableView, cxGridCustomPopupMenu, cxGridPopupMenu,
  cxGridDBBandedTableView, Menus, FCommonUtils, IniFiles, cxDataStorage,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinCaramel,
  dxSkinFoggy, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinscxPCPainter, cxNavigator;

procedure DoOpenClientParams( ALeft: Integer; ATop: Integer);
function GetParamName(const AParamRow: string): string;
function GetParamValue(const AParamRow: string): string;
function GetParamCaption(const AParamRow: string): string;

type
  TfmClientParams = class(TForm)
    mtClientParam: TkbmMemTable;
    dsClientParam: TDataSource;
    mtClientParamName: TStringField;
    mtClientParamValue: TStringField;
    mtClientParamCaption: TStringField;
    DBBandedTableView1: TcxGridDBBandedTableView;
    Level1: TcxGridLevel;
    DBBandedTableView1Name: TcxGridDBBandedColumn;
    DBBandedTableView1Value: TcxGridDBBandedColumn;
    DBBandedTableView1Caption: TcxGridDBBandedColumn;
    mtClientParamGroup: TStringField;
    DBBandedTableView1Group: TcxGridDBBandedColumn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxGridDBViewDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SaveFormStateToIni(AfaIniFile:string=''; ACanWriteToFaIni:boolean=true);
    procedure LoadFormStateFromIni(AfaIniFile:string='';AfaDefLeft:integer = 0;
                 AfaDefTop:integer=0);
  public
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
    procedure EditClientParams;
  end;

var
  fmClientParams: TfmClientParams;

implementation

uses
  SpolFunkce;

{$R *.dfm}

procedure DoOpenClientParams( ALeft: Integer; ATop: Integer);
begin
  if fmClientParams = nil then
    fmClientParams:=TfmClientParams.Create(nil);
    fmClientParams.Left:=ALeft;
    fmClientParams.Top:=ATop;
  try
    fmClientParams.ShowModal;
  finally
    fmClientParams.Free;
    fmClientParams := nil;
  end;
end;

procedure TfmClientParams.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormStateToIni;
  {SaveToFile('D:\Vyvoj\FS2006\FA\ClientParam1.ini');}
end;{FormClose}

procedure TfmClientParams.cxGridDBViewDblClick(Sender: TObject);
begin
  //
end;{cxGridDBViewDblClick}

procedure TfmClientParams.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then begin
    Key:=0;
    ModalResult:=mrOK;
  end
  else if Key=VK_Escape then begin
    Key:=0;
    ModalResult:=mrCancel;
  end
  else
    inherited;
end;{FormKeyDown}

procedure TfmClientParams.LoadFormStateFromIni(AfaIniFile:string='';AfaDefLeft:integer = 0;
  AfaDefTop:integer=0);
var
  iniFile: TMemIniFile;
  l,t: Integer;
begin
{$IFDEF STANDALONE}
  if AfaIniFile<>'' then begin
    iniFile := TMemIniFile.Create(AfaIniFile);
    try
      l:=iniFile.ReadInteger(Name, 'Left',AfaDefLeft);
      t:=iniFile.ReadInteger(Name, 'Top', AfaDefTop);
      Width:=iniFile.ReadInteger(Name, 'Width', 471);
      Height:=iniFile.ReadInteger(Name, 'Height', 332);
    finally
      iniFile.Free;
    end;
  end
  else begin
    l:=100;
    t:=80;
    Width:=471;
    Height:=332;
  end;
  CheckFormPosition(l,t,Width);
  Left:=l;
  Top:=t;
{$ELSE}
  iniFile := TMemIniFile.Create(GetFormsIniPath);
  try
    if Left=0 then
      Left:=iniFile.ReadInteger(Name, 'Left', 100);
    if Top=0 then
      Top:=iniFile.ReadInteger(Name, 'Top',80);
    Width:=iniFile.ReadInteger(Name, 'Width', 471);
    Height:=iniFile.ReadInteger(Name, 'Height', 332);
  finally
    iniFile.Free;
  end;
{$ENDIF}
end;

procedure TfmClientParams.SaveFormStateToIni(AfaIniFile:string=''; ACanWriteToFaIni:boolean=true);
var iniFile: TMemIniFile;
begin
{$IFDEF STANDALONE}
  if AfaIniFIle<>'' then begin
    if not ACanWriteToFaIni then EXIT;
    iniFile := TMemIniFile.Create(AfaIniFile);
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
{$ELSE}
  iniFile := TMemIniFile.Create(GetFormsIniPath);
  try
    iniFile.WriteInteger(Name, 'Left', Left);
    iniFile.WriteInteger(Name, 'Top', Top);
    iniFile.WriteInteger(Name, 'Width', Width);
    iniFile.WriteInteger(Name, 'Height', Height);
    SaveMemIni(iniFile);
  finally
    iniFile.Free;
  end;
{$ENDIF}
end;

procedure TfmClientParams.FormActivate(Sender: TObject);
begin
  LoadFormStateFromIni;
end;

procedure TfmClientParams.FormShow(Sender: TObject);
begin
  LoadFormStateFromIni;
  mtClientParam.Open;
  {LoadFromFile('D:\Vyvoj\FS2006\FA\ClientParam.ini');}
end;{FormShow}

procedure TfmClientParams.LoadFromFile(const AFileName: string);
var
  sl: TStringList;
  i: integer;
  group: string;
begin
  sl:=TStringList.Create;
  mtClientParam.DisableControls;
  try
    sl.LoadFromFile(AFileName);
    mtClientParam.EmptyTable;
    group:='';
    for i:=0 to sl.Count-1 do begin
      if Copy(Trim(sl[i]),1,1)='[' then
        group:=Copy(Trim(sl[i]),2,Length(Trim(sl[i]))-2);
      if GetParamName(sl[i])<>'' then begin
        mtClientParam.Append;
        mtClientParamGroup.Value:=group;
        mtClientParamName.Value:=GetParamName(sl[i]);
        mtClientParamValue.Value:=GetParamValue(sl[i]);
        mtClientParamCaption.Value:=GetParamCaption(sl[i]);
        mtClientParam.Post;
      end;
    end;
  finally
    mtClientParam.EnableControls;
    mtClientParam.Refresh;
    sl.Free;
  end;
end;

procedure TfmClientParams.SaveToFile(const AFileName: string);
var
  sl: TStringList;
  i: integer;
  group: string;
begin
  sl:=TStringList.Create;
  mtClientParam.DisableControls;
  try
    mtClientParam.First;
    group:='$$$'; //aby se na zacatku zapsala sekce
    while not mtClientParam.EOF do begin
      if mtClientParamGroup.Value<>group then
        sl.Add('['+mtClientParamGroup.Value+']');
      sl.Add(mtClientParamName.Value+'='+mtClientParamValue.Value+'//'+mtClientParamCaption.Value);
      group:=mtClientParamGroup.Value;
      mtClientParam.Next;
    end;
    sl.SaveToFile(AFileName);
  finally
    sl.Free;
    mtClientParam.EnableControls;
  end;
end;

procedure TfmClientParams.EditClientParams;
begin
end;

function GetParamName(const AParamRow: string): string;
begin
  if Pos('=',AParamRow)>0 then
    Result:=Copy(AParamRow,1,Pos('=',AParamRow)-1)
  else
    Result:='';
end;

function GetParamValue(const AParamRow: string): string;
begin
  if Pos('//',AParamRow)>0 then
    Result:=Copy(AParamRow,1,Pos('//',AParamRow)-1);
  if Pos('=',Result)>0 then
    Result:=Copy(Result,Pos('=',Result)+1,maxint)
  else
    Result:='';
end;

function GetParamCaption(const AParamRow: string): string;
begin
  if Pos('//',AParamRow)>0 then
    Result:=Copy(AParamRow,Pos('//',AParamRow)+2,maxint)
  else
    Result:='';
end;

procedure TfmClientParams.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
end;

end. 

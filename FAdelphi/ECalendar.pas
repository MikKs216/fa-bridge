{ 24.10.2012 12:52:43 (GMT+2:00) > [mik] checked in   }
{ 16.10.2012 10:54:51 (GMT+2:00) > [marek] checked in Vymena ikony  }
{ 25.10.2006 10:27:08 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 21.10.2005 8:39:55 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:51:59 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 25.10.2003 16:26:21 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 8.10.2003 22:31:57 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 4.9.2003 0:46:07 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 13:34:19 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 19.6.2003 15:01:20 (GMT+2:00) > [mik on MIKPC2] checked in   }
{ 19.6.2003 13:03:09 (GMT+2:00) > [mik on MIKPC2] checked in   }

unit ECalendar;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxGraphics, cxSchedulerStorage,
  cxSchedulerCustomControls, cxSchedulerDateNavigator,
  cxLookAndFeelPainters, StdCtrls, cxButtons, cxControls, cxContainer,
  cxDateNavigator, ExtCtrls, Menus, Res_FA, cxLookAndFeels, dxSkinsCore,
  dxSkinCaramel, dxSkinFoggy, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, psvBasiclbl, psvWebLabel;

function OpenCalendar(const ADateString: string; ALeft: Integer = 0; ATop: Integer = 0): string;

type
  TfmCalendar = class(TForm)
    cxDateNavigator1: TcxDateNavigator;
    Panel1: TPanel;
    cxButton1: TcxButton;
    Panel4: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    laOpenCalendarHelp: TpsvWebLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxDateNavigator1DblClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxDateNavigator1MouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure laOpenCalendarHelpClick(Sender: TObject);
  private
    FDate: TDateTime;
    FY: integer;
    Fleft: integer;
    FTop: integer;
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
  public
    { Public declarations }
  end;

var
  fmCalendar: TfmCalendar;

implementation

uses
  FCommonUtils, IniFiles, Main, SpolFunkce;

{$R *.dfm}

function OpenCalendar(const ADateString: string; ALeft: Integer = 0; ATop: Integer = 0): string;
begin
  if fmCalendar = nil then
    fmCalendar:=TfmCalendar.Create(nil);
  try
    with fmCalendar do begin
      if ADateString<>'' then
        cxDateNavigator1.Date:=StrToDateSafe(ADateString);
      FDate:=0;
      Fleft:=ALeft;
      FTop:=ATop;
      ShowModal;
      if FDate=0 then
        Result:=''
      else
        Result := DateToStr(FDate);
    end;
  finally
    fmCalendar.Free;
    fmCalendar:=nil;
  end;
end;

procedure TfmCalendar.LoadFormStateFromIni;
var iniFile: TMemIniFile;
  l,t: Integer;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    if FLeft<>0 then
      l:=FLeft
    else
      l:=iniFile.ReadInteger(Name, 'Left', GfaMain.Left+GfaMain.paLeft.Width+5);
    if FTop<>0 then
      t:=FTop
    else
      t:=iniFile.ReadInteger(Name, 'Top', GfaMain.Top+80);
    Width:=iniFile.ReadInteger(Name, 'Width', 336);
    Height:=iniFile.ReadInteger(Name, 'Height', 263);
    CheckFormPosition(l,t,Width);
    Left:=l;
    Top:=t;
  finally
    iniFile.Free;
  end;
end;

procedure TfmCalendar.SaveFormStateToIni;
var iniFile: TMemIniFile;
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

procedure TfmCalendar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormStateToIni;
end;

procedure TfmCalendar.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
  FLeft:=0;
  FTop:=0;
end;

procedure TfmCalendar.cxDateNavigator1DblClick(Sender: TObject);
begin
  if FY>32 then begin
    FDate:=cxDateNavigator1.Date;
    Close;
  end;
end;

procedure TfmCalendar.cxButton1Click(Sender: TObject);
begin
  cxDateNavigator1.Date:=Date;
  if cxDateNavigator1.CanFocus then
    cxDateNavigator1.SetFocus;
end;

procedure TfmCalendar.cxDateNavigator1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  FY:=Y;
end;

procedure TfmCalendar.FormShow(Sender: TObject);
begin
  inherited;
  LoadFormStateFromIni;
  cxButton1.Caption := sBtDateLabel + ': ' +DateToStr(Date);
end;

procedure TfmCalendar.laOpenCalendarHelpClick(Sender: TObject);
begin
  Application.HelpSystem.ShowTopicHelp('KlavesoveZkratkyDatum',GetDataPrgPath+'FormStudio.chm');
end;

procedure TfmCalendar.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then begin
    FDate:=cxDateNavigator1.Date;
    Close;
  end
  else if Key=#27 then begin
    FDate:=0;
    Close;
  end;
end;

procedure TfmCalendar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  d,m,y: word;
begin
  //PageUp
  if Key=33 then begin
    DecodeDate(cxDateNavigator1.Date, y, m, d);
    if m=1 then
      DEC(y)
    else
      DEC(m);
    cxDateNavigator1.Date:=EncodeDate(y,m,d);
  end
  else if Key=34 then begin
    DecodeDate(cxDateNavigator1.Date, y, m, d);
    if m=12 then
      INC(y)
    else
      INC(m);
    cxDateNavigator1.Date:=EncodeDate(y,m,d);
  end;
end;

procedure TfmCalendar.btnOKClick(Sender: TObject);
begin
  FDate:=cxDateNavigator1.Date;
end;

end.

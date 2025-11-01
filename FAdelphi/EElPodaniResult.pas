{ 13.9.2019 12:10:13 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Nastavovani pozic modalnich dialogu nad okno FA  }
{ 24.10.2012 12:55:54 (GMT+2:00) > [mik] checked in   }
unit EElPodaniResult;

{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, cxControls, cxContainer, cxEdit, cxProgressBar, StdCtrls,
  Menus, cxLookAndFeelPainters, cxButtons, cxGraphics, cxLookAndFeels,
  dxSkinsCore, dxSkinFoggy;

type
  TfmElPodaniResult = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    btNe: TcxButton;
    btAno: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure btAnoClick(Sender: TObject);
    procedure btNeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FResultAno: boolean;
    FAsk: boolean;
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
  public
  end;

function EpShowResult(const ACaption: string; const AText: string; AAsk: boolean): boolean;

var
  fmElPodaniResult: TfmElPodaniResult;

implementation

{$R *.dfm}

uses
  FCommonUtils, IniFiles, Main, SpolFunkce;

function EpShowResult(const ACaption: string; const AText: string; AAsk: boolean): boolean;
begin
  fmElPodaniResult:=TfmElPodaniResult.Create(nil);
  with fmElPodaniResult do begin
    Caption:=ACaption;
    Memo1.Lines.Text:=AText;
    FAsk:=AAsk;
    ShowModal;
    Result:=FResultAno;
  end;
  fmElPodaniResult.Free;
  fmElPodaniResult:=nil;
end; {EpShowResult}

procedure TfmElPodaniResult.btAnoClick(Sender: TObject);
begin
  FResultAno:=TRUE;
  Close;
end;

procedure TfmElPodaniResult.btNeClick(Sender: TObject);
begin
  FResultAno:=FALSE;
  Close;
end;

procedure TfmElPodaniResult.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormStateToIni;
end;

procedure TfmElPodaniResult.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
  FResultAno:=FALSE;
end;

procedure TfmElPodaniResult.FormShow(Sender: TObject);
begin
  LoadFormStateFromIni;
  btAno.Visible:=FAsk;
  if FAsk then begin
    btNe.Caption:='&Ne';
    btAno.Default:=TRUE;
    btNe.Default:=FALSE;
  end
  else begin
    btNe.Caption:='&OK';
    btAno.Default:=FALSE;
    btNe.Default:=TRUE;
  end;
  BringToFront;
end;

procedure TfmElPodaniResult.SaveFormStateToIni;
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

procedure TfmElPodaniResult.LoadFormStateFromIni;
var iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    //Left := iniFile.ReadInteger(Name, 'Left',GfaMain.Left + 5);
    //Top := iniFile.ReadInteger(Name, 'Top',GfaMain.Top + 30);
    Left := GfaMain.Left + 5;
    Top := GfaMain.Top + 30;
    Width := iniFile.ReadInteger(Name, 'Width', 412);
    Height := iniFile.ReadInteger(Name, 'Height', 300);
  finally
    iniFile.Free;
  end;
end;

procedure TfmElPodaniResult.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key=Ord('A')) or (Key=Ord('a'))) and ((GetKeyState(VK_CONTROL)<0)) then
    Memo1.SelectAll
  else if Key=27 then begin
    FResultAno:=FALSE;
    Close;
  end;
end;

end.

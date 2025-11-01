{ 19.1.2015 13:09:52 (GMT+1:00) > [mik on WIN-48QDB6JAV23] checked in Zmena center screen  }
{ 30.10.2012 11:00:32 (GMT+1:00) > [mik] checked in   }
{ 30.8.2012 11:22:25 (GMT+2:00) > [mik] checked in   }
{ 13.10.2011 12:25:14 (GMT+2:00) > [mik] checked in   }
{ 13.10.2011 10:34:38 (GMT+2:00) > [mik] checked in Obrazek pro 2012  }
{ 20.1.2011 12:34:55 (GMT+1:00) > [mik] checked in Copyrigt 2011  }
{ 12.12.2008 10:17:29 (GMT+1:00) > [mik] checked in Zmeny pro eXpress  }
{ 25.1.2007 11:51:07 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 16.11.2006 16:41:25 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 25.10.2006 10:27:26 (GMT+2:00) > [mik on PCMIK64] checked in   }
{ 23.6.2005 11:49:26 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 22.6.2005 11:52:30 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:38:37 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 2.11.2003 17:05:32 (GMT+1:00) > [mik on PCMIKHOME] checked in   }
{ 2.11.2003 16:54:13 (GMT+1:00) > [mik on PCMIKHOME] checked in   }
{ 10.10.2003 0:09:07 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 13.9.2003 21:33:32 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 11.9.2003 22:44:31 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 11.9.2003 22:33:51 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 13:34:27 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 13:28:53 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 1.8.2003 15:24:53 (GMT+2:00) > [mik on MIKPC2] checked in   }
{ 30.7.2003 22:51:35 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 18.6.2003 14:46:22 (GMT+2:00) > [mik on MIKPC2] checked in   }
{ 18.6.2003 14:36:08 (GMT+2:00) > [mik on MIKPC2] checked in   }

unit ESplash;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, cxLookAndFeelPainters, cxButtons,
  Menus, Res_FA, Res_DK, cxGraphics, cxLookAndFeels, dxSkinsCore, dxSkinFoggy;

procedure ShowAbout(const ACaption: string);

type
  TfmSplash = class(TForm)
    paAbout: TPanel;
    laUserName: TLabel;
    laLicence: TLabel;
    Panel1: TPanel;
    laAlert: TLabel;
    imFA: TImage;
    btOK: TcxButton;
    shpDiakr: TShape;
    Panel2: TPanel;
    laVersion: TLabel;
    laBeta: TLabel;
    paCopyright: TPanel;
    laCopyR: TLabel;
    imFS: TImage;
    laImports1: TLabel;
    laImports: TLabel;
    laPDFReader: TLabel;
    laFoxit: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure laFoxitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    function GetLocalVer: string;
    function GetImports: string;
  public
    { Public declarations }
  end;

var
  fmSplash: TfmSplash;

implementation

uses
  FCommonUtils, FUtils, DKLicUtils, Main, IniFiles, ShellApi;

{$R *.dfm}

function TfmSplash.GetLocalVer: string;
const
  cIniSectionLocal = 'Local';
  cIniLocalVersion = 'LocalVersion';
var
  iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(NormalPath(ExtractFilePath(
    Application.ExeName)) + 'Localization.ini');
  try
    Result := iniFile.ReadString(cIniSectionLocal, cIniLocalVersion, '');
  finally
    iniFile.Free;
  end;
end; {GetLocalVer}

function TfmSplash.GetImports: string;
const
  cConversionConst = 'CONVERSIONCONST';
  cImportPrgName = '$ImportPrgName';
var
  iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(NormalPath(ExtractFilePath(
    Application.ExeName)) + 'import.idf');
  try
    Result := iniFile.ReadString(cConversionConst, cImportPrgName, '');
  finally
    iniFile.Free;
  end;
end; {GetImports}

procedure TfmSplash.FormActivate(Sender: TObject);
begin
  Refresh;  
end;

procedure TfmSplash.FormCreate(Sender: TObject);
begin
  BorderStyle:=bsNone;
  Height:=ImFA.Height;
  Width:=ImFA.Width;
  laVersion.Caption:=sVersionLabel+' '+GetPrgVersion(Application.ExeName);
{$IFDEF BETA}
  laBeta.Visible:=TRUE;
{$ELSE BETA}
  laBeta.Visible:=FALSE;
{$ENDIF BETA}
  shpDiakr.Visible:=GetLocalVer=cLocalVersionSK;
  if GetImports<>'' then begin
    imFA.Visible:=FALSE;
    imFS.Visible:=TRUE;
    laImports.Caption:=GetImports;
    laImports.Visible:=TRUE;
    laImports1.Visible:=TRUE;
  end
  else begin
    imFA.Visible:=TRUE;
    imFS.Visible:=FALSE;
    laImports.Visible:=FALSE;
    laImports1.Visible:=FALSE;
  end;
end;

procedure ShowAbout(const ACaption: string);
begin
  fmSplash:=TfmSplash.Create(nil);
  try
    with fmSplash do begin
      Position:=poMainFormCenter;
      BorderStyle:=bsDialog;
      Caption := sAbout+' '+ACaption;
      btOk.Visible:=TRUE;
      paAbout.Visible:=TRUE;
      laPDFReader.Visible:=TRUE;
      laFoxit.Visible:=TRUE;
      Height:=357-6-(ClientHeight-291); //uprava pro klasicky typ zobrazeni - uzky titulek
      Width:=526-6;
      ImFA.Left:=-2;
      ImFA.Top:=-2;
      ImFS.Left:=-2;
      ImFS.Top:=-2;
      shpDiakr.Top:=186;
      laAlert.Visible:=TRUE;
      laUserName.Caption:=sUserNameCaption+' '+GetLicUserName;
      laLicence.Caption:=sLicenceCaption+' '+GetLicNumber +' '+GetLicCaption;
      fmSplash.ShowModal;
      fmSplash.Free;
      fmSplash:=nil;
    end;
  finally
    fmSplash.Free;
    fmSplash:=nil;
  end;
end; {ShowAbout}

procedure TfmSplash.FormShow(Sender: TObject);
begin
  if BorderStyle=bsNone then begin
    Height:=ImFA.Height;
    Width:=ImFA.Width;
  end;
end;

procedure TfmSplash.laFoxitClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar('http://www.foxitsoftware.com'), nil, nil,
    SW_SHOWNORMAL);
end;

end.

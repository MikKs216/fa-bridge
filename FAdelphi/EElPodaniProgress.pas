{ 23.10.2017 11:00:22 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Oprava labelu  }
{ 22.9.2017 14:53:35 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Design okna Loading a veci kolem pozic oken  }
{ 24.10.2012 12:55:20 (GMT+2:00) > [mik] checked in   }
unit EElPodaniProgress;

{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, cxControls, cxContainer, cxEdit, cxProgressBar, StdCtrls,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinFoggy;

type
  TfmElPodaniProgress = class(TForm)
    pb1: TcxProgressBar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

function EpProgressStart(const ACaption: string; const AText: string): TfmElPodaniProgress;
procedure EpProgressStop(fmElPodaniProgress: TfmElPodaniProgress);

var
  fmElPodaniProgress: TfmElPodaniProgress;

implementation

{$R *.dfm}

uses
  FCommonUtils, SpolFunkce;

function EpProgressStart(const ACaption: string; const AText: string): TfmElPodaniProgress;
begin
  fmElPodaniProgress:=TfmElPodaniProgress.Create(nil);
  with fmElPodaniProgress do begin
    Caption:=ACaption;
    Label1.Caption:=AText;
    pb1.Position:=50;
    Show;
    Invalidate;
    Refresh;
  end;
  StartWait;
  Result:=fmElPodaniProgress;
end; {EpProgressStart}

procedure EpProgressStop(fmElPodaniProgress: TfmElPodaniProgress);
begin
  fmElPodaniProgress.Close;
  fmElPodaniProgress.Free;
  fmElPodaniProgress:=nil;
  StopWait;
end;


procedure TfmElPodaniProgress.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
end;

end.

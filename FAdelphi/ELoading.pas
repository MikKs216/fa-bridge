{ 30.7.2018 15:43:35 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in do procedury LoadingStep vlozeno volani BringToFront formulare  }
{ 11.10.2017 10:23:01 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in zmena step progressbaru  }
{ 26.9.2017 13:21:53 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Oprava  }
{ 13.9.2017 15:31:01 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Vytvoreno  }
unit ELoading;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GIFImg, Main, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxProgressBar,
  Menus, cxButtons, AppEvnts;

type
  TfmLoading = class(TForm)
    ApplicationEvents: TApplicationEvents;
    pbLoading: TcxProgressBar;
    laText: TLabel;
    laBreak: TLabel;
    procedure ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
  private
    FBreakRequest: Boolean;
  public
  end;

var
  fmLoading: TfmLoading;

  procedure LoadingStart(AStepCount: Integer; AEnableBreak: Boolean = False;
    const ACaption: string = ''; const AText: string = '');
  procedure LoadingStop;
  procedure LoadingStep;
  function LoadingBreakRequest: boolean;

implementation

uses FCommonUtils, FScriptUtils;

{$R *.dfm}

procedure TfmLoading.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if Msg.message = WM_KEYDOWN then begin
    if Msg.wParam = VK_ESCAPE then
         fmLoading.FBreakRequest:=true;
  end;
end;

procedure LoadingStart(AStepCount: Integer; AEnableBreak: Boolean = False;
  const ACaption: string = ''; const AText: string = '');
begin
  GLoadingBreak:=false;
  if fmLoading=nil then begin
    fmLoading:=TfmLoading.Create(nil);
    fmLoading.Left:=GfaMain.Left + GfaMain.Width div 2 - (fmLoading.Width div 2);
    fmLoading.Top:=GfaMain.Top + GfaMain.Height div 2 - (fmLoading.Height div 2) + 12;
    fmLoading.FBreakRequest:=false;
    if AStepCount=0 then
      fmLoading.pbLoading.Properties.Max:=1
    else
      fmLoading.pbLoading.Properties.Max:=AStepCount;
    fmLoading.pbLoading.Position:=0;
    fmLoading.laBreak.Visible:=AEnableBreak;
    if ACaption<>'' then
      fmLoading.Caption:=ACaption;
    if AText<>'' then
      fmLoading.laText.Caption:=AText;
    fmLoading.Visible:=true;
    fmLoading.Show;
    fmLoading.Invalidate;
    fmLoading.Refresh;
  end;
end;

procedure LoadingStop;
begin
  if fmLoading<>nil then begin
    fmLoading.Close;
    fmLoading.Free;
    fmLoading:=nil;
  end;
end;

procedure LoadingStep;
begin
  if fmLoading<>nil then with fmLoading do begin
    fmLoading.pbLoading.Position:=fmLoading.pbLoading.Position+1;
    fmLoading.BringToFront;    
    Refresh;
  end;
end;

function LoadingBreakRequest: boolean;
begin
  if fmLoading<>nil then with fmLoading do begin
    Result:= fmLoading.FBreakRequest;
    GLoadingBreak:=Result;
  end
  else
    Result:= false;
end;

end.

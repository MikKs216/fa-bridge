{ 29.1.2007 10:11:46 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 25.1.2007 9:36:31 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 27.10.2006 10:04:38 (GMT+2:00) > [mik on PCMIK64] checked in   }
unit EReklama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RTFLabel, StdCtrls, psvBasiclbl, psvWebLabel;

{$I Switches.inc}

procedure ShowAdvert(ARight, ATop: integer);

type
  TfmReklama = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Image1: TImage;
    psvWebLabelFS: TpsvWebLabel;
    psvRTFLabelTextCZ: TpsvRTFLabel;
    psvRTFLabelTextSK: TpsvRTFLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmReklama: TfmReklama;

implementation

uses
  ShellApi;
{$R *.dfm}

procedure ShowAdvert(ARight, ATop: integer);
begin
  Application.CreateForm(TfmReklama, fmReklama);
  with fmReklama do begin
    Left:=ARight-Width;
    Top:=ATop;
    ShowModal;
    Free;
    fmReklama:=nil;
  end;
end; {ShowAdvert}

procedure TfmReklama.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then
    Close;
end;

procedure TfmReklama.Image1Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar('http://www.formstudio.cz'), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TfmReklama.FormCreate(Sender: TObject);
begin
  {$IFDEF FREEVERSIONSK}
  psvRTFLabelTextCZ.Visible := FALSE;
  psvRTFLabelTextSK.Visible := TRUE;
  psvWebLabelFS.Caption := 'www.formstudio.sk';
  {$ELSE FREEVERSIONSK}
  psvRTFLabelTextCZ.Visible := TRUE;
  psvRTFLabelTextSK.Visible := FALSE;
  psvWebLabelFS.Caption := 'www.formstudio.cz';
  {$ENDIF FREEVERSIONSK}
  psvWebLabelFS.Link := psvWebLabelFS.Caption;
end;

end.

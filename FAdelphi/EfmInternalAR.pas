{ 12.10.2012 15:33:29 (GMT+2:00) > [mik] checked in   }
{ 15.8.2008 14:58:08 (GMT+2:00) > [martin on MR64PC] checked in Nastaven tisk v okne vzdy s dialogem  }
{ 14.8.2008 11:57:01 (GMT+2:00) > [martin on MR64PC] checked in Zobrazeni AR v okne  }
{ 7.8.2008 14:19:16 (GMT+2:00) > [martin on MR64PC] checked in   }
unit EfmInternalAR;

{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,PdfLib_TLB, AcroPDFLib_TLB,OleCtrls, ComObj, Main, FCommonUtils;

const
    //Verze7
  LIBID_AcroPDFLib7: TGUID = '{05BFD3F1-6319-4F30-B752-C7A22889BCC4}';
  DIID__IAcroAXDocShimEvents7: TGUID = '{E790E1D1-9DE8-4853-8AC6-933D4FD9C927}';
  IID_IAcroAXDocShim7: TGUID = '{3B813CE7-7C10-4F84-AD06-9DF76D97A9AA}';

  CLASS_PDF: TGUID = '{CA8A9780-280D-11CF-A24D-444553540000}';

  //Verze5
  LIBID_PdfLib5: TGUID = '{CA8A9783-280D-11CF-A24D-444553540000}';
  DIID__DPdf5: TGUID = '{CA8A9781-280D-11CF-A24D-444553540000}';
  DIID__DPdfEvents5: TGUID = '{CA8A9782-280D-11CF-A24D-444553540000}';

type
  TfmInternalAcrobat = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    mPDF5:TPDF;
    mPDF7:TAcroPDF;
    m_Print:Boolean;
    m_Dialog:Boolean;
    procedure LoadFormStateFromIni;
    procedure SaveFormStateToIni;

  public
    { Public declarations }
  end;

  function ShowAcrobatInWindow(fileName:string; caption:string):Tform;
  function PrintAcrobatActivex(fileName:string; caption:string; dialog:Boolean):Boolean;
var
  fmInternalAcrobat: TfmInternalAcrobat;

implementation
uses
  IniFiles, SpolFunkce;

{$R *.dfm}

function ShowAcrobatInWindow(fileName:string; caption:string):TForm;
  var
  lst:TStringList;
  intfA7:IAcroAXDocShim;
  intfA5:_DPdf;
  old:bool;
  intrg:Integer;
  x:TOleControl;
  ClassFactory2: IUnknown;
  vysledek:HRESULT;
  itf:IUnknown;
  frm:TfmInternalAcrobat;
begin
  Result:=nil;

  if fileName='' then begin
     ShowMessage('Není pøedán název souboru pro zobrazení');
     Exit;
  end;

  try
      itf:=CreateComObject(CLASS_PDF);
   except
     ShowMessage('Není zaregistrován objekt Acrobat Readeru');
     Exit;
   end;
   old:=True;
   if Supports(itf,IID_IAcroAXDocShim7,ClassFactory2) then
     old:=False;

   if Supports(itf,DIID__DPdf5,ClassFactory2) then
     old:=True;
    itf:=nil;

    frm:= TfmInternalAcrobat.Create(nil);
    frm.m_Print:=False;
    frm.Caption:=caption;
    frm.Position:=poMainFormCenter;
    try
       if not old then begin
          frm.mPDF7:=TAcroPDF.Create(frm);
          frm.mPDF7.Align:= alClient;
          frm.mPDF7.Visible:=TRUE;
          frm.mPDF7.PARENT:=frm;
          frm.mPDF7.setShowToolbar(TRUE);
          frm.mPdf7.LoadFile(fileName);
          frm.mPDF7.Visible:=True;
       end
       else begin
          frm.mPDF5:=TPDF.Create(frm);
          frm.mPDF5.Align:= alClient;
          frm.mPDF5.Visible:=TRUE;
          frm.mPDF5.PARENT:=frm;
          frm.mPDF5.setShowToolbar(TRUE);
          frm.mPdf5.LoadFile(fileName);
          frm.mPDF5.Visible:=True;
       end;
       frm.ShowModal();
    finally
      FreeAndNil(frm.mPDF5);
      FreeAndNil(frm.mPDF7);
      FreeAndNil(frm);
    end;
end;{ShowAcrobatInWindow}

//Vytiskne pomoci ActiveXAcrobatu
function PrintAcrobatActivex(fileName:string; caption:string; dialog:Boolean):Boolean;
 var
  lst:TStringList;
  intfA7:IAcroAXDocShim;
  intfA5:_DPdf;
  old:bool;
  intrg:Integer;
  x:TOleControl;
  ClassFactory2: IUnknown;
  vysledek:HRESULT;
  itf:IUnknown;
  mPDF5:TPDF;
  mPDF7:TAcroPDF;
  frm:TfmInternalAcrobat;
begin
  Result:=false;

  if fileName='' then begin
     ShowMessage('Není pøedán název souboru pro zobrazení');
     Exit;
  end;

  try
      itf:=CreateComObject(CLASS_PDF);
   except
     ShowMessage('Není zaregistrován objekt Acrobat Readeru');
     Exit;
   end;
   old:=True;
   if Supports(itf,IID_IAcroAXDocShim7,ClassFactory2) then
     old:=False;

   if Supports(itf,DIID__DPdf5,ClassFactory2) then
     old:=True;
    itf:=nil;
    mPDF7:=nil;
    mPDF5:=nil;

    frm:= TfmInternalAcrobat.Create(nil);
    frm.m_Print:=True;
    frm.m_Dialog:=dialog;
    frm.Caption:=caption;
    frm.Position:=poMainFormCenter;
    try
       if not old then begin
          frm.mPDF7:=TAcroPDF.Create(frm);
          frm.mPDF7.Align:= alClient;
          frm.mPDF7.Visible:=TRUE;
          frm.mPDF7.PARENT:=frm;
          frm.mPDF7.setShowToolbar(TRUE);
          frm.mPdf7.LoadFile(fileName);
          frm.mPDF7.Visible:=True;
                    (*
            if dialog then
                        frm.mPDF7.printWithDialog
                      else
                        frm.mPDF7.PrintAll;
          *)
       end
       else begin
          frm.mPDF5:=TPDF.Create(frm);
          frm.mPDF5.Align:= alClient;
          frm.mPDF5.Visible:=TRUE;
          frm.mPDF5.PARENT:=frm;
          frm.mPDF5.setShowToolbar(TRUE);
          frm.mPdf5.LoadFile(fileName);
          frm.mPDF5.Visible:=True;
(*
            if dialog then
              frm.mPDF5.printWithDialog
            else
              frm.mPDF5.PrintAll;
*)
       end;
       frm.ShowModal();
    finally
      FreeAndNil(frm.mPDF5);
      FreeAndNil(frm.mPDF7);
      FreeAndNil(frm);
    end;

end;{PrintAcrobatActiveX}

procedure TfmInternalAcrobat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormStateToIni;
end;

procedure TfmInternalAcrobat.FormCreate(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  SetComponentStyle(Self);
{$ENDIF STANDALONE}
end;

procedure TfmInternalAcrobat.FormShow(Sender: TObject);
begin
   LoadFormStateFromIni;

(*
     if m_Print then begin
        if Assigned(mPDF5) then begin
            mPDF5.SetFocus;
            mPDF5.Perform(WM_KEYDOWN,$11,$1D0001); //KeyDown CTRL
            mPDF5.Perform(WM_KEYDOWN,$50,$190001); //KeyDown P
           // mPDF5.Perform(WM_CHAR,$70,$190001); //KeyDown P
           // mPDF5.Perform(WM_KEYUP,$50,$C0190001); //KeyUP P
           // mPDF5.Perform(WM_KEYUP,$11,$C01D0001); //KeyUP CTRL
        end;
     end;
     if m_Print then begin
        if Assigned(mPDF7) then begin
            mPDF7.SetFocus;
            mPDF7.Perform(WM_KEYDOWN,$11,$1D0001); //KeyDown CTRL
            mPDF7.Perform(WM_KEYDOWN,$50,$190001); //KeyDown P
         //   mPDF7.Perform(WM_CHAR,$70,$190001); //KeyDown P
         //   mPDF7.Perform(WM_KEYUP,$50,$C0190001); //KeyUP P
         //   mPDF7.Perform(WM_KEYUP,$11,$C01D0001); //KeyUP CTRL
        end;
     end;
*)

     if m_Print then begin
        if Assigned(mPDF5) then begin
          //mPDF5.Visible:=False;
          mPdf5.printWithDialog;
          {
          if m_Dialog then
                mPdf5.printWithDialog
              else
                mPDF5.PrintAll;
         }
        end;
        if Assigned(mPDF7) then begin
           //mPDF7.Visible:=False;
           mPdf7.printWithDialog;
           {
           if m_Dialog then
                mPdf7.printWithDialog
              else
                mPDF7.PrintAll;
           }
        end;
     end;
end;{FormShow}

procedure TfmInternalAcrobat.LoadFormStateFromIni;
var iniFile: TMemIniFile;
  l,t: Integer;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    Left:=iniFile.ReadInteger(Name, 'Left', GfaMain.Left);
    Top:=iniFile.ReadInteger(Name, 'Top', GfaMain.Top);
    Width:=iniFile.ReadInteger(Name, 'Width', GfaMain.Width);
    Height:=iniFile.ReadInteger(Name, 'Height', GfaMain.Height);
    l:=Left; t:=Top; CheckFormPosition(l,t,Width); Left:=l; Top:=t;
  finally
    iniFile.Free;
  end;
end;

procedure TfmInternalAcrobat.SaveFormStateToIni;
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


end.

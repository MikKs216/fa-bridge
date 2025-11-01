{ 23. 11. 2023 23:17:48 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Doplneni vlastnosti NowCheckLook do ObjectInspectoru komponenty cxDBCheckBoxEx  }
{ 16. 11. 2023 15:48:40 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Doplneni vlastnosti RadioButtonLook do ObjectInspectoru komponenty cxDBCheckBoxEx  }
{ 29.8.2012 11:30:07 (GMT+2:00) > [mik] checked in   }
//FORM asistent, object inspactor
//
//vytvoreno 22.3.2012
//

unit EObjectInspector;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, oinspect, dbinsp,
  ComCtrls,
  StdCtrls, DCGen, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxEdit, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGrid, Menus, cxDataStorage,
  psvWebLabel, psvBasiclbl, psvLinkedLabel,
  psvBorderLabel;

procedure OpenObjectInspector(AControl: TControl);

type
  TfObjectInspector = class(TForm)
    paDef: TPanel;
    Label1: TLabel;
    ColorDialog: TColorDialog;
    PopupMenu1: TPopupMenu;
    miGenOdkazy: TMenuItem;
    SaveDialog: TSaveDialog;
    miSeznamUdaju: TMenuItem;
    ObjectInspector: TObjectInspector;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dsinspFieldsChangePropValue(Sender: TObject;
      const PropEdit: TDCDsgnProperty; var newval: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ObjectInspectorShowProperty(Sender: TObject;
      const PropEdit: TDCDsgnProperty; var show: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    procedure BeforeCloseActions;
  end;

var
  fObjectInspector: TfObjectInspector;

implementation

uses
  Main, IniFiles, FCommonUtils, FUtils,
  cxTextEdit, cxDBEdit, cxCheckBox,
  CxDBTextEditEx, CxDBCheckBoxEx, CxDBMemoEx, cxListBoxEx, cxListBox,
  faEdit, cxLookAndFeelPainters, cxButtons, cxMemo, cxLookAndFeels, SpolFunkce;

{$R *.dfm}

procedure OpenObjectInspector(AControl: TControl);
begin
  try
    if fObjectInspector = nil then
      Application.CreateForm(TfObjectInspector, fObjectInspector);
    if AControl<>nil then begin
      fObjectInspector.ObjectInspector.CurrentControl:=AControl;
      fObjectInspector.Caption:='Vlastnosti objektu: '+AControl.Name;
      fObjectInspector.ShowModal;
      GfaMain.SetChangeFlag(TRUE);
    end
    else
      MessageWarn('Object inspector','Nelze editovat vlastnosti objektu',[MBOK]);
  finally
    fObjectInspector.Free;
    fObjectInspector:=nil;
  end;
end; {OpenObjectInspector}

procedure TfObjectInspector.FormCreate(Sender: TObject);
begin
  LoadFormStateFromIni;
end; {FormCreate}

procedure TfObjectInspector.FormDestroy(Sender: TObject);
begin
  BeforeCloseActions;
end; procedure TfObjectInspector.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then
    Close;
end;

{FormDestroy}

procedure TfObjectInspector.BeforeCloseActions;
begin
  SaveFormStateToIni;
end; {BeforeCloseActions}

procedure TfObjectInspector.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  BeforeCloseActions;
end; {FormClose}

procedure TfObjectInspector.dsinspFieldsChangePropValue(Sender: TObject;
  const PropEdit: TDCDsgnProperty; var newval: string);
begin
  //pri zmene zaznamu mtDef nastavit priznak zmeny
  GfaMain.dxBarButtonSave.Enabled := TRUE;
end; {dsinspFieldsChangePropValue}

procedure TfObjectInspector.SaveFormStateToIni;
var
  iniFile: TMemIniFile;
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
end; {SaveStateFormToIni}

procedure TfObjectInspector.LoadFormStateFromIni;
var
  iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
    Left := iniFile.ReadInteger(Name, 'Left', 200);
    Top := iniFile.ReadInteger(Name, 'Top', 130);
    Width := iniFile.ReadInteger(Name, 'Width', 280);
    Height := iniFile.ReadInteger(Name, 'Height', 600);
  finally
    iniFile.Free;
  end;
end;

procedure TfObjectInspector.ObjectInspectorShowProperty(Sender: TObject;
  const PropEdit: TDCDsgnProperty; var show: Boolean);
begin
  if ObjectInspector.CurrentControl is TfaEdit then begin
    Show :=
      (PropEdit.getName = 'Left') or
      (PropEdit.getName = 'Top') or
      (PropEdit.getName = 'Width') or
      (PropEdit.getName = 'Height') or
      (PropEdit.getName = 'Visible') or
      (PropEdit.getName = 'InvertAlignment') or
      (PropEdit.getName = 'BorderColor') or
      (PropEdit.getName = 'Color') or
      (PropEdit.getName = 'Enabled') or
      (PropEdit.getName = 'FldLookup') or
      (PropEdit.getName = 'FldType') or
      (PropEdit.getName = 'FldTypeDecimalPlaces') or
      (PropEdit.getName = 'RestrictLength') or
      (PropEdit.getName = 'NextDirection') or
      (PropEdit.getName = 'NextField') or
      (PropEdit.getName = 'NextFieldBack') or
      (PropEdit.getName = 'RepAlignment') or
      (PropEdit.getName = 'RepFontSize') or
      (PropEdit.getName = 'RepPosX') or
      (PropEdit.getName = 'RepPosY') or
      (PropEdit.getName = 'HideChar') or
      (PropEdit.getName = 'DisplayFormat') or
      (PropEdit.getName = 'InterlaceSize') or
      (PropEdit.getName = 'InterlaceSizeRep') or
      (PropEdit.getName = 'InterlaceCount') or
      (PropEdit.getName = 'Font') or
      (PropEdit.getName = 'Size') or
      (PropEdit.getName = 'Transparent') or
      (PropEdit.getName = 'RepNoThousandSep') or
      (PropEdit.getName = 'RepHide') or
      (PropEdit.getName = 'SelectedColor');
  end
  else if ObjectInspector.CurrentControl is TcxDBCheckBoxEx then begin
    Show :=
      (PropEdit.getName = 'Left') or
      (PropEdit.getName = 'Top') or
      (PropEdit.getName = 'Width') or
      (PropEdit.getName = 'Height') or
      (PropEdit.getName = 'Visible') or
      (PropEdit.getName = 'Properties') or
      (PropEdit.getName = 'Alignment') or
      (PropEdit.getName = 'Style') or
      (PropEdit.getName = 'BorderColor') or
      (PropEdit.getName = 'Color') or
      (PropEdit.getName = 'Enabled') or
      (PropEdit.getName = 'FldLookup') or
      (PropEdit.getName = 'FldType') or
      (PropEdit.getName = 'FldTypeDecimalPlaces') or
      (PropEdit.getName = 'NextDirection') or
      (PropEdit.getName = 'NextField') or
      (PropEdit.getName = 'NextFieldBack') or
      (PropEdit.getName = 'RepAlignment') or
      (PropEdit.getName = 'RepFontSize') or
      (PropEdit.getName = 'RepLength') or
      (PropEdit.getName = 'RepPosX') or
      (PropEdit.getName = 'RepPosY') or
      (PropEdit.getName = 'RepTrueText') or
      (PropEdit.getName = 'RepFalseText') or
      (PropEdit.getName = 'SelectedColor') or
      //(PropEdit.getName = 'ParentColor') or
      (PropEdit.getName = 'Transparent') or
      (PropEdit.getName = 'AutoSize') or
      (PropEdit.getName = 'MultiLine') or
      (PropEdit.getName = 'Caption') or
      (PropEdit.getName = 'CaptionTrue') or
      (PropEdit.getName = 'CaptionFalse') or
      (PropEdit.getName = 'Font') or
      (PropEdit.getName = 'Name') or
      (PropEdit.getName = 'Size') or
      (PropEdit.getName = 'Style') or
      (PropEdit.getName = 'fsBold') or
      (PropEdit.getName = 'fsItalic') or
      (PropEdit.getName = 'fsUnderline') or
      (PropEdit.getName = 'RepHide') or
      (PropEdit.getName = 'fsStrikeOut') or
      (PropEdit.getName = 'RadioButtonLook') or
      (PropEdit.getName = 'NewCheckLook');
  end
  else if ObjectInspector.CurrentControl is TcxDBMemoEx then begin
    Show :=
      (PropEdit.getName = 'Left') or
      (PropEdit.getName = 'Top') or
      (PropEdit.getName = 'Width') or
      (PropEdit.getName = 'Height') or
      (PropEdit.getName = 'Visible') or
      (PropEdit.getName = 'Properties') or
      (PropEdit.getName = 'Alignment') or
      (PropEdit.getName = 'Style') or
      (PropEdit.getName = 'BorderColor') or
      (PropEdit.getName = 'Color') or
      (PropEdit.getName = 'Enabled') or
      (PropEdit.getName = 'NextDirection') or
      (PropEdit.getName = 'NextField') or
      (PropEdit.getName = 'NextFieldBack') or
      (PropEdit.getName = 'RepAlignment') or
      (PropEdit.getName = 'RepFontSize') or
      (PropEdit.getName = 'RepLength') or
      (PropEdit.getName = 'RepPosX') or
      (PropEdit.getName = 'RepPosY') or
      (PropEdit.getName = 'SelectedColor') or
      (PropEdit.getName = 'WordWrap') or
      (PropEdit.getName = 'LookAndFeel') or
      (PropEdit.getName = 'NativeStyle') or
      (PropEdit.getName = 'Kind') or
      (PropEdit.getName = 'ScrollBars') or
      (PropEdit.getName = 'Font') or
      (PropEdit.getName = 'Name') or
      (PropEdit.getName = 'RepHide') or
      (PropEdit.getName = 'RepRowHeight') or
      (PropEdit.getName = 'RepOffsetFirstRow') or
      (PropEdit.getName = 'Size');
  end
  else
    Show := FALSE;
end;

end.


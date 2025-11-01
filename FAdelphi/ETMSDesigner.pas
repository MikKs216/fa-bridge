{ 23. 11. 2023 23:17:26 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Doplneni vlastnosti NowCheckLook do ObjectInspectoru komponenty cxDBCheckBoxEx  }
{ 16. 11. 2023 15:48:56 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Doplneni vlastnosti RadioButtonLook do ObjectInspectoru komponenty cxDBCheckBoxEx  }
{ 7.7.2021 12:14:28 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Optimalizace.  }
{ 5.10.2020 13:56:48 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Upravena prace s designerem, ten uz neni v samostatnem okne, ale je soucasti hlavniho okna, tak jak byl puvodni DC skripter.  }
{ 12.12.2019 21:57:40 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in zmena faMain na GfaMain  }
{ 9.12.2019 14:45:08 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in uprava vlastnosti ObjectInspectoru, uprava defaultni pozice oken, uprava vkladnani do FControlsNamesList  }
{ 26.11.2019 8:48:06 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in   }
//ToDo:
//+Ukladat/nacist pozice oken
//+resit alignment palette
//+menu s BringToFront a SendToBack
//+ikony toolbaru
//+skryt "neviditelne" komponenty pri designu
//+skryt nepotrebne vlastnosti z ObjectInspektoru
//+edity nemaji pri designu viditelny text
//automaticky nacist komponenty po ulozeni (uzavreni) designeru
//?nektere komponenty (button, checkbox), ktere jsou Visible=False, se zobrazi az pri oznaceni jine komponenty
//  jine (napr label) je v poradku
//-umistovat komponenty vlozene z clipboardu intelignetneji
// + nedelat pri multiselect
// + testovat, ze je v clipboardu spravna komponenta
// + zajistit, aby se inspektor lepe prekresloval
// - pri vlozeni 1 komponenty a prazdnem FLastControlClipb zajistit, aby se dalsim vlozeni komponenta "posunula"
//   (doplneni: stejny problem nastane, pokud 1 komponentu zkopirujeme, vlozime a
//    vlozenou hned smazeme. Po opetovnem vlozeni nedojde k posunu [FLastControlClipb neni prazdny])
// + resit kompatibilitu kopirovani ze stareho designeru
//   (za kazdy objekt staci vlozit: "object Events__: TCompEvents end")
//   neni nutne resit, chybu hlasi jen pri ladeni, jinak se komponenta bez problemu vlozi
// + v memu se po vlozeni z clipboardu neobjevi caption
//+po smazani komponenty nastavit focus na posledni control
//-resit skupiny v object inspektoru
//-po Ctrl+V se skryji controlsy, ktere jsou Visible=False

//+pokud se udaj presune z jedne stany na druhou, tak pri opusteni designu chyba "udaj je pouzit na jine strane"
//+po Ctrl+V ze stareho (dz_20ZadKompBonusPodzim2020) designu do noveho (dz_20DPFO5255_1) se mi u checkoxu zastupce stalo, ze ZastSub se spatne zkopiroval
//(staci udelat duplikaci controlsu a novy je nefunkcni, dokud se do kresleni znovu nevleze)
//-znovu potrapit mazani controlsu
unit ETMSDesigner;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, DBCtrls, IniFiles, TypInfo, ClipBrd, PropertyList,
  psvWebLabel, psvBorderLabel, HTMLText, faEdit,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxTextEdit, cxMemo, cxDBEdit, CxDBMemoEx, cxCheckBox, CxDBCheckBoxEx,
  cxListBoxEx,
  FormDEsigner, IDEMain, fObjectInspector, fToolPalette, ETMSAlignPalette,
  AppEvnts, FCommonUtils, Menus, ImgList, Math;

var
  FControlsList: TStringList; //slouzi k porovnani, ktere komponenty byly smazany

procedure DoOpenTMSDesigner(AData: TMemoryStream; AUseLocalSbForm: boolean);
function CloseTMSDesigner: boolean;
procedure FControlsListCreate;
procedure FControlsListFree;
procedure FControlsListAddControls(ASb: TScrollBox);
procedure UpdateControlsToList(ASb: TScrollBox; ASl:TStringList);

type
 TLastControlClipb = record
   ComponentName: string;
   Top: Integer;
   Left: Integer;
   Height: Integer;
   Width: Integer;
   SizeIsSet: Boolean;
   OneComponentSelected: Boolean;
 end;

type
  TTMSDesigner = class(TForm)
    sbForm: TScrollBox;
    IDEEngine1: TIDEEngine;
    ApplicationEvents: TApplicationEvents;
    PopupMenu1: TPopupMenu;
    miBringToFront: TMenuItem;
    miSendToBack: TMenuItem;
    ImageList1: TImageList;
    ClientBorder: TShape;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure miBringToFrontClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miSendToBackClick(Sender: TObject);
    procedure IDEEngine1GetComponentImage(Sender: TObject;
      RegComp: TIDERegisteredComp; ABitmap: TBitmap; var AHandled: Boolean);
    procedure BringToFrontEx;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FCanClose: boolean;
    //FDesigner: TIDEFormDesigner;
    FObjInspector: TfmObjectInspector;
    FToolPalet: TfmToolPalette;
    FAlignPalette: TfmAlignmentPalette;
    FLastControlClipb: TLastControlClipb;
    //FControlsList: TStringList; //slouzi k porovnani, ktere komponenty byly smazany
    procedure tmsInsp_OnFilter(Sender: TObject; Prop: TProperty; var Result: Boolean);
    procedure tmsInsp_OnDeactivate(Sender: TObject);
    procedure tmsDes_OnCopyComponent(Sender: TObject; TheComponent: TComponent);
    procedure tmsDes_OnPasteComponent(Sender: TObject; TheComponent: TComponent);
    procedure tmsDes_OnSelectControl(Sender: TObject; TheControl: TControl);
    procedure tmsDes_OnSelectionChange(Sender: TObject);
    procedure tmsDes_OnComponentCaption(Sender: TObject; TheComponent: TComponent; var Text: string);
    procedure tmsDes_OnPlaceComponent(Sender: TObject; TheComponent: TComponent);

    procedure IDEEngineRegisterComponent;
    procedure ShowClientBorder;
    procedure HideClientBorder;
    procedure LoadDesignerComponentsFromStream(AStream: TMemoryStream);
    procedure CreateDesigner;
    procedure EmptyPage;
    procedure ShowComponentCaptions(AComponent: TComponent);
    procedure SetLastControlClipb(AComponent: TComponent; OneComponent: Boolean = True);
    procedure SaveFormPositionToIni(AFormName: string);
    procedure LoadFormPositionFromIni(AFormName: string);
    function CanPastComponents: boolean;
    function GetSbForm: TScrollBox;
    function GetIniFileName: string;
  public
    { Public declarations }
    FUseLocalSbForm: boolean;
    FDesigner: TIDEFormDesigner;
    procedure DoDesignForm(AData: TMemoryStream);
    procedure SaveDesignerComponentsToStream(AStream: TMemoryStream; ASl:TStringList);
    procedure SaveDesignerComponentsToFile(AFileName: string);
    procedure tmsDes_OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

var
  tmsDesigner: TTMSDesigner;

implementation

uses
  Main;

{$R *.DFM}

const
  cIniFileNameExt = '_ScrDes.ini';
  cIniDesignerSection = 'Designer';
  cIniInspectorSection = 'Inspector';
  cIniPaletteSection = 'Palette';
  cIniAlignPaletteSection = 'AlignPalette';

procedure DoOpenTMSDesigner(AData: TMemoryStream; AUseLocalSbForm: boolean);
begin
  if tmsDesigner <> nil then begin
    tmsDesigner.BringToFrontEx;
  end
  else begin
    with GfaMain do begin  //zpatky na klavesove zkratky se nastavuje ve FormClose
      dxBarButtonCut.ShortCut := 0;
      dxBarButtonCopy.ShortCut := 0;
      dxBarButtonPaste.ShortCut := 0;
      dxBarButtonUndo.ShortCut := 0;
      dxBarButtonRedo.ShortCut := 0;
    end;
    //
    if AUseLocalSbForm then begin //otevre se designer v samostatnem okne
      tmsDesigner:=TtmsDesigner.Create(nil);
      tmsDesigner.FUseLocalSbForm := AUseLocalSbForm;
      tmsDesigner.LoadFormPositionFromIni('des');
    end
    else begin  //designer bude soucasti FA, tak jako to bylo postaru
      tmsDesigner:=TtmsDesigner.Create(GfaMain);
      tmsDesigner.FUseLocalSbForm := AUseLocalSbForm;
      tmsDesigner.Parent := GfaMain.sbForm;
      //tmsDesigner.Owner
      tmsDesigner.Align := alClient;
      tmsDesigner.BorderIcons := [];
      tmsDesigner.BorderStyle := Forms.bsNone;
    end;
    tmsDesigner.DoDesignForm(AData);
  end;
end; {EditScriptUnModal}

function CloseTMSDesigner: boolean;
begin
  Result := True;
  if tmsDesigner <> nil then
    tmsDesigner.Close;
  if (tmsDesigner <> nil) and (tmsDesigner.FCanClose) then begin
    tmsDesigner.Free;
    tmsDesigner:=nil;
  end;
  if tmsDesigner <> nil then
    Result := False;
end;

procedure FControlsListCreate;
begin
  if FControlsList = nil then
    FControlsList := TStringList.Create;
end;

procedure FControlsListFree;
begin
  if FControlsList <> nil then begin
    FControlsList.Free;
    FControlsList:=nil;
  end;
end;

procedure FControlsListAddControls(ASb: TScrollBox);
var
  i: Integer;
  c: TControl;
begin
 if FControlsList <> nil then begin
    for i := ASb.ControlCount -1 downto 0 do begin
      c := ASb.Controls[i];
      FControlsList.Add(c.Name+','+c.ClassName)
    end;
  end;
end;

procedure UpdateControlsToList(ASb: TScrollBox; ASl:TStringList);
var
  i,y: integer;
  c: TControl;
  sl: TStringList;
begin
  if (ASl <> nil) and (FControlsList <> nil) then begin
    sl := TStringList.Create;
    try
      //ulozime seznam nazvu vsech controlsu do noveho stringlistu "sl"
      for i := 0 to ASb.ControlCount -1 do begin
        c := ASb.Controls[i];
        sl.Add(c.Name+','+c.ClassName);
      end;
      //a pripadne nove pridame do puvodniho stringlistu FControlsList
      for i  := 0 to sl.Count - 1 do
        if sl[i] <> '' then
          if FControlsList.IndexOf(sl[i]) = -1 then
            FControlsList.Add(sl[i]);
      //prochazime puvodni stringlist FControlsNamesList a ty controlsy,
      //ktere nejsou v novem, tak z celkoveho smazeme a ty,
      //ktere jsou nove, tak pridame
      for i  := 0 to FControlsList.Count - 1 do begin
        if sl.IndexOf(FControlsList[i]) = -1 then begin
          if ASl.Find(FControlsList[i], y) then
            ASl.Delete(y);
        end
        else begin
          if not ASl.Find(FControlsList[i], y) then
            ASl.Add(FControlsList[i]);
        end;
      end;
    finally
      sl.Free;
    end;
  end;
end;

function TTMSDesigner.GetIniFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, cIniFileNameExt);
end;

function TTMSDesigner.GetSbForm: TScrollBox;
begin
  Result := sbForm;
end;

procedure TTMSDesigner.BringToFrontEx;
begin
  Show;
  if IsIconic(Handle) then
    ShowWindow(Handle, SW_RESTORE)
  else
    BringToFront;
  if CanFocus then
    SetFocus;
end;

procedure TTMSDesigner.SetLastControlClipb(AComponent: TComponent; OneComponent: Boolean = True);
begin
  if OneComponent then
    FLastControlClipb.ComponentName := AComponent.Name
  else
    FLastControlClipb.ComponentName := '';  
  FLastControlClipb.Top := (AComponent as TControl).Top;
  FLastControlClipb.Left := (AComponent as TControl).Left;
  FLastControlClipb.Height := (AComponent as TControl).Height;
  FLastControlClipb.Width := (AComponent as TControl).Width;
  FLastControlClipb.SizeIsSet := True;
  FLastControlClipb.OneComponentSelected := OneComponent;
end;

procedure TTMSDesigner.tmsDes_OnCopyComponent(Sender: TObject; TheComponent: TComponent);
begin
  SetLastControlClipb(TheComponent, FDesigner.ControlCount = 1);
end;

//testuje, zde je vkladana komponenta kompatibilni s FA
//POKUD JE NEJAKA KOMPONENTA NEKOMPATIBILNI, NEVLOZI SE DO DESIGNERU ZADNA!!!!
//- vytvori se pomocny designer
//- postupne se testuje vsechny komponenty
//- na zaver vse smaze
function TTMSDesigner.CanPastComponents: boolean;
var
  i: Integer;
  c: TControl;
  des: TIDEFormDesigner;
  sl: TstringList;
begin
  Result := False;
  //
  des := TIDEFormDesigner.Create(tmsDesigner);
  des.ShowNonVisual := False;
  des.Active := true;
  try
    try
      des.PasteFromClipboard;
    except
    end;
    for i := 0 to des.ControlCount -1 do begin
      c := des.Controls[i];
      Result := (c is TLabel) or (c is TpsvWebLabel) or (c is TpsvBorderLabel) or
       (c is THTMLStaticText) or (c is TfaEdit) or (c is TcxDBCheckBoxEx) or
       (c is TcxDBMemoEx) or (c is TButton) or (c is TBitBtn) or (c is TShape) or
       (c is TImage) or (c is TcxListBoxEx);
      if not Result then
        Break;
    end;
    //
    if Result then begin
      sl:=TstringList.Create;
      sl.Text:=Clipboard.AsText;
      try
        i := sl.Count-1;
        while i >= 0 do begin
          if (Trim(sl[i]) = 'end') then begin
            if (Trim(sl[i-1]) <> 'object Events__: TCompEvents') then begin
              sl[i] := 'end object Events__: TCompEvents end';
              Dec(i);
            end
            else
              Dec(i, 3);
          end
          else
            Dec(i);
        end;
        Clipboard.AsText:=sl.Text;
      finally
        sl.Free;
      end;
    end;
    //
    for i := des.ControlCount -1 downto 0 do begin
      c := des.Controls[i];
      c.Free;
    end;
  finally
    FreeAndNil(des);
  end;
end;

procedure TTMSDesigner.tmsDes_OnPasteComponent(Sender: TObject; TheComponent: TComponent);
begin // exit;
  //zobrazi v komponentach edit, memo a listbox nazev komponenty
  ShowComponentCaptions(TheComponent);
  //
  //umistime novou komponentu na DesignControl
  TControl(TheComponent).Parent := GetSbForm;
  //shape dame na pozadi
  //skryjeme ClientBorder, jinak se na controlsy, které posilame do pozadi, skryji za ClientBorder 
  HideClientBorder;
  try
    if TheComponent is TShape then
      TShape(TheComponent).SendToBack;
  finally
    ShowClientBorder;
  end;
  //------- UPRAVIME POZICI NOVE KOMPONENTY (POUZE POKUD JE VYBRANA JEDNA KOMPONENTA) --------
  if FLastControlClipb.OneComponentSelected then begin
    //pokud je komponeta v clipboardu a mezi tim se FA vypnul,
    //nebo kopirujeme z jine instance FA, tak FLastControlClipb neni nastaven
    if not FLastControlClipb.SizeIsSet then
      SetLastControlClipb(TheComponent);
    if FLastControlClipb.ComponentName <> TheComponent.Name then begin
      if (FLastControlClipb.Left+FLastControlClipb.Width+10) <= GetSbForm.Width then
        TControl(TheComponent).Left := FLastControlClipb.Left+10
      else
        TControl(TheComponent).Left := FLastControlClipb.Left;
      if (FLastControlClipb.Top+FLastControlClipb.Height+10) <= GetSbForm.Height then
        TControl(TheComponent).Top := FLastControlClipb.Top+10
      else
        TControl(TheComponent).Top := FLastControlClipb.Top;
    end;
    SetLastControlClipb(TheComponent);
  end;
end;

procedure TTMSDesigner.tmsDes_OnSelectControl(Sender: TObject; TheControl: TControl);
begin
  if FObjInspector.Engine = nil then
    FObjInspector.Engine := IDEEngine1;
  //
  if IDEEngine1.Inspector <> nil then
    IDEEngine1.Inspector.Visible := (TheControl <> nil);
end;

procedure TTMSDesigner.tmsDes_OnSelectionChange(Sender: TObject);
begin
  //casto nastava AV pri mazani, proto zde je tato podminka
  //oprava: zde je zakazano a presunuto do ApplicationEventsMessage 
//  if GetKeyState(VK_DELETE) < 0 then
  //  FObjInspector.Engine := nil;
end;

procedure TTMSDesigner.tmsDes_OnComponentCaption(Sender: TObject; TheComponent: TComponent; var Text: string);
begin
//
end;

procedure TTMSDesigner.tmsDes_OnPlaceComponent(Sender: TObject; TheComponent: TComponent);
begin
//
end;

procedure TTMSDesigner.tmsDes_OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//
end;

procedure TTMSDesigner.EmptyPage;
var
  i: integer;
begin
  //smazat komponenty na sbForm
  for i := GetSbForm.ControlCount - 1 downto 0 do begin
    if GetSbForm.Controls[i] is TcxDBMemoEx then //osetreni AV ve Vistach
      TcxDBMemoEx(GetSbForm.Controls[i]).Visible:=FALSE;
    GetSbForm.Controls[i].Free;
  end;
end;

//zajisti, aby v komponentach edit, memo a listbox bylo zobrazeno jmeno komponenty (jinak jsou komponenty prazdne) 
procedure TTMSDesigner.ShowComponentCaptions(AComponent: TComponent);
begin
  if AComponent is TfaEdit then
    TfaEdit(AComponent).Caption := TfaEdit(AComponent).Name;
  if AComponent is TcxDBMemoEx then begin
    TcxDBMemoEx(AComponent).Lines.Clear;
    TcxDBMemoEx(AComponent).Lines.Add(TcxDBMemoEx(AComponent).Name);
  end;
  if AComponent is TcxListBoxEx then begin
    TcxListBoxEx(AComponent).Items.Clear;
    TcxListBoxEx(AComponent).Items.Add(TcxListBoxEx(AComponent).Name);
  end;
end;

procedure TTMSDesigner.ShowClientBorder;
begin
  if (ClientBorder <> nil) and
    (sbForm <> nil) then begin
    ClientBorder.Parent := GetSbForm;
    ClientBorder.Left := 0;
    ClientBorder.Top := 1;
    ClientBorder.Visible := TRUE;
    ClientBorder.SendToBack;
  end;
end;

procedure TTMSDesigner.HideClientBorder;
begin
  if (ClientBorder <> nil) and (sbForm <> nil) then begin
    ClientBorder.Visible := FALSE;
    ClientBorder.Parent := tmsDesigner;
  end;
end;

procedure TTMSDesigner.SaveDesignerComponentsToStream(AStream: TMemoryStream; ASl:TStringList);
{var
  i,y: integer;
  c: TControl;
  sl: TStringList;}
begin
  HideClientBorder;
  if FDesigner <> nil then begin
    FDesigner.SaveComponentToStream(AStream, GetSbForm, dfmBinary);  //dfmBinary
    //AStream.SaveToFile('d:\saveTMSmuj.txt');
    //
    UpdateControlsToList(GetSbForm, ASl);
{    if ASl <> nil then begin
      sl := TStringList.Create;
      try
        //ulozime seznam nazvu vsech controlsu do noveho stringlistu "sl"
        for i := 0 to GetSbForm.ControlCount -1 do begin
          c := GetSbForm.Controls[i];
          sl.Add(c.Name+','+c.ClassName);
        end;
        //a pripadne nove pridame do puvodniho stringlistu FControlsList
        for i  := 0 to sl.Count - 1 do
          if sl[i] <> '' then
            if FControlsList.IndexOf(sl[i]) = -1 then
              FControlsList.Add(sl[i]);
        //prochazime puvodni stringlist FControlsNamesList a ty controlsy,
        //ktere nejsou v novem, tak z celkoveho smazeme a ty,
        //ktere jsou nove, tak pridame
        for i  := 0 to FControlsList.Count - 1 do begin
          if sl.IndexOf(FControlsList[i]) = -1 then begin
            if ASl.Find(FControlsList[i], y) then
              ASl.Delete(y);
          end
          else begin
            if not ASl.Find(FControlsList[i], y) then
              ASl.Add(FControlsList[i]);
          end;
        end;
      finally
        sl.Free;
      end;
    end; }
  end;
end;

procedure TTMSDesigner.SaveDesignerComponentsToFile(AFileName: string);
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  try
    SaveDesignerComponentsToStream(st, nil);
    st.SaveToFile(AFileName);
  finally
    st.Free;
  end;
end;

//Nacte komponenty ze streamu
//- nacita komponenty na pomocny scrollbox a z neho pak "presune" na sbForm (meni jen vlastnost Perent)
//- protoze vlastnost Parent menime od posledniho (musime kvuli chybe List index out of bound),
//  tak SendToBack (od posledniho) zajisti, ze se komponenty nactou ve spravnem poradi
procedure TTMSDesigner.LoadDesignerComponentsFromStream(AStream: TMemoryStream);
var
  i: Integer;
  sb: TScrollBox;
  c: TControl;
begin
  //CreateDesigner; //povolit, pokud se bude potreba ho volat od jinud nez z DoDesignForm
  //
  sb := TScrollBox.Create(tmsDesigner);
  try
    FControlsList.Clear;
    AStream.Seek(0, soFromBeginning);
    sb.Visible := False;
    sb.Color := GetSbForm.Color;
    EmptyPage;
    if AStream.Size > 0 then begin
      //AStream.SaveToFile('D:\stream.txt');
      FDesigner.LoadComponentFromStream(AStream, sb, dfmBinary);
      for i := sb.ControlCount -1 downto 0 do begin
        c := sb.Controls[i];
        c.Parent := GetSbForm;
        c.SendToBack;
        ShowComponentCaptions(c);
        FControlsList.Add(c.Name+','+c.ClassName)
      end;
    end;
    if sb.Color <> GfaMain.sbForm.Color then
      sb.Color := GfaMain.sbForm.Color;
    GetSbForm.Color := sb.Color;
    ShowClientBorder;
  finally
    sb.Free;
  end;
end;

procedure TTMSDesigner.CreateDesigner;
begin
  if FDesigner = nil then
    FDesigner := TIDEFormDesigner.Create(tmsDesigner);
end;

function ComponentToStringProc(Component: TComponent): string;
var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

procedure TTMSDesigner.DoDesignForm(AData: TMemoryStream);
begin
  if FObjInspector = nil then begin
    FObjInspector := TfmObjectInspector.Create(nil);
    LoadFormPositionFromIni('ins');
  end;
  if FObjInspector.TabControl1.Tabs.Count > 1 then
    FObjInspector.TabControl1.Tabs.Delete(1);
  FObjInspector.IDEInspector.CheckBoxes := True;
  FObjInspector.IDEInspector.OnFilter := tmsInsp_OnFilter;
  FObjInspector.OnDeactivate := tmsInsp_OnDeactivate;
  //
  if FToolPalet = nil then begin
    FToolPalet := TfmToolPalette.Create(nil);
    LoadFormPositionFromIni('pal');
  end;
  //
  CreateDesigner;
  //
  if FAlignPalette = nil then begin
    FAlignPalette := TfmAlignmentPalette.Create(FDesigner);
    LoadFormPositionFromIni('ali');
  end;
  //
  FDesigner.DesignControl := GetSbForm;
  FDesigner.PopupMenu := PopupMenu1;
  FDesigner.ShowNonVisual := False;
  FDesigner.ShowComponentCaptions := True;
  //FDesigner.LockedControls.Add('ClientBorder');
  //FDesigner.ProtectedControls.Add('ClientBorder');
  FDesigner.TransparentControls.Add('ClientBorder');
  //
  FDesigner.OnCopyComponent := tmsDes_OnCopyComponent;
  FDesigner.OnSelectControl := tmsDes_OnSelectControl;
  FDesigner.OnSelectionChange := tmsDes_OnSelectionChange;
  FDesigner.OnPasteComponent := tmsDes_OnPasteComponent;
  FDesigner.OnComponentCaption := tmsDes_OnComponentCaption;
  FDesigner.OnPlaceComponent := tmsDes_OnPlaceComponent;
  //FDesigner.OnKeyDown := tmsDes_OnKeyDown;
  //
  LoadDesignerComponentsFromStream(AData);
  //
  IDEEngine1.FormDesigner := FDesigner;
  FObjInspector.Engine := IDEEngine1;
  FToolPalet.Engine := IDEEngine1;
  IDEEngine1.PreventDefaultEventCreation := True;
  //
  FDesigner.Active := true;
  //
  Show;
  FObjInspector.Show;
  FToolPalet.Show;
  FAlignPalette.Show;
end;

//zajisti zobrazeni ikony komponenty v tool palette
//(nejprve je nutne pridat ikonu velikosti 24x24 do ImageListu)
procedure TTMSDesigner.IDEEngine1GetComponentImage(Sender: TObject;
  RegComp: TIDERegisteredComp; ABitmap: TBitmap; var AHandled: Boolean);
begin
  AHandled := False;
  if RegComp.CompClass = TLabel then begin
    ImageList1.GetBitmap(0,ABitmap);
    AHandled := True;
  end;
  if RegComp.CompClass = TpsvWebLabel then begin
    ImageList1.GetBitmap(1,ABitmap);
    AHandled := True;
  end;
  if RegComp.CompClass = TpsvBorderLabel then begin
    ImageList1.GetBitmap(2,ABitmap);
    AHandled := True;
  end;
  if RegComp.CompClass = THTMLStaticText then begin
    ImageList1.GetBitmap(3,ABitmap);
    AHandled := True;
  end;
  if RegComp.CompClass = TfaEdit then begin
    ImageList1.GetBitmap(4,ABitmap);
    AHandled := True;
  end;
  if RegComp.CompClass = TcxDBCheckBoxEx then begin
    ImageList1.GetBitmap(5,ABitmap);
    AHandled := True;
  end;
  if RegComp.CompClass = TcxDBMemoEx then begin
    ImageList1.GetBitmap(6,ABitmap);
    AHandled := True;
  end;
  if RegComp.CompClass = TcxListBoxEx then begin
    ImageList1.GetBitmap(7,ABitmap);
    AHandled := True;
  end;
end;

//RegisterComponent prida vlastni komponentu do tool palette
//UnregisterTab - odstrani systemove komponenty, resp. cele zalozky, z tool palete 
procedure TTMSDesigner.IDEEngineRegisterComponent;
begin
  IDEEngine1.RegisterComponent('Components', TLabel, 'StdCtrls');
  IDEEngine1.RegisterComponent('Components', TpsvWebLabel, 'psvWebLabel');
  IDEEngine1.RegisterComponent('Components', TpsvBorderLabel, 'psvBorderLabel');
  IDEEngine1.RegisterComponent('Components', THTMLStaticText, 'HTMLText');
  IDEEngine1.RegisterComponent('Components', TfaEdit, 'faEdit');
  IDEEngine1.RegisterComponent('Components', TcxDBCheckBoxEx, 'CxDBCheckBoxEx');
  IDEEngine1.RegisterComponent('Components', TcxDBMemoEx, 'CxDBMemoEx');
  IDEEngine1.RegisterComponent('Components', TButton, 'StdCtrls');
  IDEEngine1.RegisterComponent('Components', TBitBtn, 'Buttons');
  IDEEngine1.RegisterComponent('Components', TShape, 'ExtCtrls');
  IDEEngine1.RegisterComponent('Components', TImage, 'ExtCtrls');
  IDEEngine1.RegisterComponent('Components', TcxListBoxEx, 'cxListBoxEx');
  IDEEngine1.UnregisterTab('Standard');
  IDEEngine1.UnregisterTab('Additional');
  IDEEngine1.UnregisterTab('Dialogs');
  IDEEngine1.UnregisterTab('Win32');
end;

procedure TTMSDesigner.miBringToFrontClick(Sender: TObject);
begin
  FDesigner.BringControlsToFront;
end;

procedure TTMSDesigner.miSendToBackClick(Sender: TObject);
begin
  //skryjeme ClientBorder, jinak se na controlsy, které posilame do pozadi, skryji za ClientBorder 
  HideClientBorder;
  try
    FDesigner.SendControlsToBack;
  finally
    ShowClientBorder;
  end;
end;

procedure TTMSDesigner.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GfaMain.DesActiveChanged(False); //zavola se procedura SavePage a v ni SaveDesignerComponentsToStream
  //SaveDesignerComponentsToFile('d:\stream2.dat');
  //
  if FAlignPalette <> nil then begin
    SaveFormPositionToIni('ali');
    FAlignPalette.Free; //musime uvolnit driv nez FDesigner, protoze ten je jeho vlastnikem
    FAlignPalette:=nil;
  end;
  //
  FDesigner.Active := False;
  FDesigner.Free;
  FDesigner := nil;
  //
  SaveFormPositionToIni('des');
  //
  if FObjInspector <> nil then begin
    SaveFormPositionToIni('ins');
    FObjInspector.Free;
    FObjInspector:=nil;
  end;
  if FToolPalet <> nil then begin
    SaveFormPositionToIni('pal');
    FToolPalet.Free;
    FToolPalet:=nil;
  end;
  //
  tmsDesigner.Free;
  tmsDesigner:=nil;
  //
  with GfaMain do begin
    LoadComponentFromSectionForm; //nacte controlsy z mtContentSectionForm na GfaMain.sbForm
    SavePageFieldsDef;            //z controlsu, ktere lezi na GfaMain.sbForm, vytvori fieldy v mtFields (sice uz se to vola vyse v DesActiveChanged, resp. SavePage, ale v tom okamžiku jeste na GfaMain.sbForm nelezi nove vytvorene controlsy)
    if dxBarButtonCut.ShortCut = 0 then
      dxBarButtonCut.ShortCut := ShortCut(Word('X'), [ssCtrl]);
    if dxBarButtonCopy.ShortCut = 0 then
      dxBarButtonCopy.ShortCut := ShortCut(Word('C'), [ssCtrl]);
    if dxBarButtonPaste.ShortCut = 0 then
      dxBarButtonPaste.ShortCut := ShortCut(Word('V'), [ssCtrl]);
    if dxBarButtonUndo.ShortCut = 0 then
      dxBarButtonUndo.ShortCut := ShortCut(Word('Z'), [ssCtrl]);
    if dxBarButtonRedo.ShortCut = 0 then
      dxBarButtonRedo.ShortCut := ShortCut(Word('Y'), [ssCtrl]);
  end;
end;

procedure TTMSDesigner.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  duplicateEditName: string;
  contentKey: integer;
begin
  CanClose := GfaMain.CheckUniqueFieldsDef(GetSbForm, duplicateEditName, contentKey);
  if not CanClose then
    MsgBoxErr(Caption,
      Format('Název %s je už použitý na jiné stranì (key=%d). Zvolte jiné jméno',
      [duplicateEditName, contentKey]), MB_OK);
  //
  FCanClose := CanClose;
end;

procedure TTMSDesigner.FormCreate(Sender: TObject);
begin
  IDEEngineRegisterComponent;
//  FControlsList := TStringList.Create;
  FControlsListCreate;
end;

procedure TTMSDesigner.FormDestroy(Sender: TObject);
begin
  FControlsListFree;
end;

procedure TTMSDesigner.SaveFormPositionToIni(AFormName: string);
var
  iniFile: TIniFile;
  s: string;
begin
  s := '';
  if not FUseLocalSbForm then
    s:='Fa';
  //
  iniFile := TIniFile.Create(GetIniFileName);
  try
    //main form
    if SameText(AFormName, 'des') then begin
      if FUseLocalSbForm then begin
        iniFile.WriteInteger(cIniDesignerSection, 'Left', Left);
        iniFile.WriteInteger(cIniDesignerSection, 'Top', Top);
        iniFile.WriteInteger(cIniDesignerSection, 'Width', Width);
        iniFile.WriteInteger(cIniDesignerSection, 'Height', Height);
      end;
    end;
    //object inspector form
    if SameText(AFormName, 'ins') then begin
      if FObjInspector <> nil then begin
        iniFile.WriteInteger(cIniInspectorSection+s, 'Left', FObjInspector.Left);
        iniFile.WriteInteger(cIniInspectorSection+s, 'Top', FObjInspector.Top);
        iniFile.WriteInteger(cIniInspectorSection+s, 'Width', FObjInspector.Width);
        iniFile.WriteInteger(cIniInspectorSection+s, 'Height', FObjInspector.Height);
      end;
    end;
    //tool palette form
    if SameText(AFormName, 'pal') then begin
      if FToolPalet <> nil then begin
        iniFile.WriteInteger(cIniPaletteSection+s, 'Left', FToolPalet.Left);
        iniFile.WriteInteger(cIniPaletteSection+s, 'Top', FToolPalet.Top);
        iniFile.WriteInteger(cIniPaletteSection+s, 'Width', FToolPalet.Width);
        iniFile.WriteInteger(cIniPaletteSection+s, 'Height', FToolPalet.Height);
      end;
    end;
    //alignment palette form
    if SameText(AFormName, 'ali') then begin
      if FAlignPalette <> nil then begin
        iniFile.WriteInteger(cIniAlignPaletteSection+s, 'Left', FAlignPalette.Left);
        iniFile.WriteInteger(cIniAlignPaletteSection+s, 'Top', FAlignPalette.Top);
        iniFile.WriteInteger(cIniAlignPaletteSection+s, 'Width', FAlignPalette.Width);
        iniFile.WriteInteger(cIniAlignPaletteSection+s, 'Height', FAlignPalette.Height);
      end;
    end;
  finally
    iniFile.Free;
  end;
end;

procedure TTMSDesigner.LoadFormPositionFromIni(AFormName: string);
var
  iniFile: TIniFile;
  s: string;
  l,t,h: Integer;
begin
  iniFile := TIniFile.Create(GetIniFileName);
  try
    //main form
    if SameText(AFormName, 'des') then begin
      if FUseLocalSbForm then begin
        Top := iniFile.ReadInteger(cIniDesignerSection, 'Top', GfaMain.Top+30);
        Width := iniFile.ReadInteger(cIniDesignerSection, 'Width', 588);
        Width := Width - sbForm.Width + GfaMain.sbForm.Width;
        Height := iniFile.ReadInteger(cIniDesignerSection, 'Height', 471);
        Height := Height - sbForm.Height + GfaMain.sbForm.Height;
        Left := iniFile.ReadInteger(cIniDesignerSection, 'Left', GfaMain.Left+(GfaMain.Width-Width));        
      end;
    end;
    //
    if FUseLocalSbForm then begin
      s := '';
      l := Left;
      t := Top;
      h := Height;
    end
    else begin
      s:='Fa';
      l := GfaMain.Left;
      t := GfaMain.Top;
      h := GfaMain.Height;
    end;
    //
    //object inspector form
    if SameText(AFormName, 'ins') then begin
      if FObjInspector <> nil then begin
        FObjInspector.Left := iniFile.ReadInteger(cIniInspectorSection+s, 'Left', Max(0,l-260));
        FObjInspector.Top := iniFile.ReadInteger(cIniInspectorSection+s, 'Top', t);
        FObjInspector.Width := iniFile.ReadInteger(cIniInspectorSection+s, 'Width', 260);
        FObjInspector.Height := iniFile.ReadInteger(cIniInspectorSection+s, 'Height', h);
      end;
    end;
    //tool palette form
    if SameText(AFormName, 'pal') then begin
      if FToolPalet <> nil then begin
        FToolPalet.Left := iniFile.ReadInteger(cIniPaletteSection+s, 'Left', Max(0,l-260-160));
        FToolPalet.Top := iniFile.ReadInteger(cIniPaletteSection+s, 'Top', t);
        FToolPalet.Width := iniFile.ReadInteger(cIniPaletteSection+s, 'Width', 160);
        FToolPalet.Height := iniFile.ReadInteger(cIniPaletteSection+s, 'Height', h);
      end;
    end;
    //alignment palette form
    if SameText(AFormName, 'ali') then begin
      if FAlignPalette <> nil then begin
        FAlignPalette.Left := iniFile.ReadInteger(cIniAlignPaletteSection+s, 'Left', Max(0,l-260-160));
        FAlignPalette.Top := iniFile.ReadInteger(cIniAlignPaletteSection+s, 'Top', FToolPalet.Top+FToolPalet.Height);
        //FAlignPalette.Width := iniFile.ReadInteger(cIniAlignPaletteSection+s, 'Width', 160);
        //FAlignPalette.Height := iniFile.ReadInteger(cIniAlignPaletteSection+s, 'Height', h);
      end;
    end;
  finally
    iniFile.Free;
  end;
end;

procedure TTMSDesigner.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
var
  i: integer;
  cn: string;

  procedure ChangeControlsPosition(ALeft, ATop, AShiftState: Integer);
  var
    y, l, t: integer;
  begin
    if AShiftState < 0 then begin
      l := ALeft * 10;
      t := ATop * 10;
    end
    else begin
      l := ALeft * 1;
      t := ATop * 1;
    end;
    //
    for y := 0 to FDesigner.ControlCount - 1 do begin
      FDesigner.Controls[y].Top := FDesigner.Controls[y].Top + t;
      FDesigner.Controls[y].Left := FDesigner.Controls[y].Left + l;
    end;
    FDesigner.Update; //zajisti prekresleni controlsu
    if FDesigner.ControlCount = 1 then //zajisti aktualizaci v object inspektoru
      if IDEEngine1.Inspector <> nil then
        IDEEngine1.Inspector.Update;
  end;

  procedure ChangeControlsSize(AWidth, AHeight: Integer);
  var
    y: integer;
  begin
    for y := 0 to FDesigner.ControlCount - 1 do begin
      FDesigner.Controls[y].Width := FDesigner.Controls[y].Width + AWidth;
      FDesigner.Controls[y].Height := FDesigner.Controls[y].Height + AHeight;
    end;
    FDesigner.Update; //zajisti prekresleni controlsu
    if FDesigner.ControlCount = 1 then //zajisti aktualizaci v object inspektoru
      if IDEEngine1.Inspector <> nil then
        IDEEngine1.Inspector.Update;
  end;

  function GetNextControlIndex(AIndex, AOfset: integer): Integer;
  var
    y: integer;
  begin
    y := AIndex;
    repeat
      y := y+AOfset;
      if y < 0 then
        y := GetSbForm.ControlCount-1
      else if y > (GetSbForm.ControlCount-1) then
        y := 0;
    until (not SameText(GetSbForm.Controls[y].Name, 'ClientBorder'));
    Result := y;
  end;

  //vraci TRUE, pokud je formular aktivni (tzb. nestojime napr v ObjectInspektoru)
  function DesignFormActive: boolean;
  begin
    Result := (Screen.ActiveForm <> nil) and ((Screen.ActiveForm = GfaMain) or (Screen.ActiveForm = tmsDesigner));
  end;

  //volame pri stisku nekterych klaves, napr. Delete, nebo sipky
  //vraci TRUE, pokud je mozne akci, ktera je navazana na stisk klavesy, vyvolat
  //vraci TRUE, pokud designer neni v samostanem okne (pokud je, tak mazani funguje automaticky) a formular je aktivni (tzb. nestojime napr v ObjectInspektoru)
  function CanPerformAction: boolean;
  begin
    Result := (not FUseLocalSbForm) and DesignFormActive;
  end;

begin
  if //(tmsDesigner.Focused) and
     (FDesigner <> nil) and (FDesigner.Active) then begin
    if Msg.message = WM_KEYDOWN then begin
      if DesignFormActive then begin
        case Msg.wParam of
          67: begin   //C
            if (GetKeyState(VK_CONTROL)<0) then begin
              FDesigner.CopyToClipboard;
              Handled := TRUE;
            end;
          end;
          86: begin   //V
            if (GetKeyState(VK_CONTROL)<0) then begin
              try
                if (FDesigner.CanPaste) and CanPastComponents then
                  FDesigner.PasteFromClipboard;
              except
              end;
              Handled := TRUE;
            end;
          end;
          88: begin   //X
            if (GetKeyState(VK_CONTROL)<0) then begin
              FObjInspector.Engine := nil;
              try
                FDesigner.CutToClipboard;
              finally
                FObjInspector.Engine := IDEEngine1;
              end;
              Handled := TRUE;
            end;
          end;
          VK_DELETE: begin   //delete
            if (CanPerformAction) then begin//pokud je designer v samostatnem okne, tak mazani funguje automaticky
              FObjInspector.Engine := nil;
              try
                //if (GetKeyState(VK_CONTROL)>=0) then begin //mazeme, jen pokud klavesa ctrl neni stisknuta
                  FDesigner.RemoveSelectedControls;
                //end;
                for i := GetSbForm.ControlCount - 1 downto 0 do begin  //po smazani zajisti select prvni komponenty
                  if (GetSbForm.Controls[i] is TControl) and (GetSbForm.Controls[i].Name <> '') then begin
                    FDesigner.AddControl(TControl(GetSbForm.Controls[i]));
                    Break;
                  end;
                end;
              finally
                FObjInspector.Engine := IDEEngine1;
              end;
              Handled := TRUE;
            end;
          end;
          {90: begin   //Z
            if (GetKeyState(VK_CONTROL)<0) then begin
              FDesigner.Engine.UndoDesigner;
              Handled := TRUE;
            end;
          end;}
        end;
      end;
      //
      if (CanPerformAction) and (Msg.wParam >= 37) and (Msg.wParam <= 40) then begin //pokud je designer v samostatnem okne, tak funguje automaticky
        if (GetKeyState(VK_CONTROL)>=0) and ((GetKeyState(VK_SHIFT)>=0)) then begin //pokud neni stisknutej ani Ctrl ani Shift, tak ...
          if (FDesigner.ControlCount = 1) then begin  //sipky: fokus na dalsi/predchozi udaj (up/left, resp. down/right se chovaji stejne)
            cn := FDesigner.Controls[0].Name;
            FDesigner.ClearControls;
            for i := 0 to GetSbForm.ControlCount - 1 do begin
              if (GetSbForm.Controls[i] is TControl) and (GetSbForm.Controls[i].Name <> '') and
                 (not SameText(GetSbForm.Controls[i].Name, 'ClientBorder')) then begin
                if SameText(GetSbForm.Controls[i].Name, cn) then begin
                  if (Msg.wParam = 37) or (Msg.wParam = 38) then
                    FDesigner.AddControl(TControl(GetSbForm.Controls[GetNextControlIndex(i,-1)])) //left/up
                  else
                    FDesigner.AddControl(TControl(GetSbForm.Controls[GetNextControlIndex(i,1)])); //right/down
                  Break;
                end;
              end;
            end;
            Handled := TRUE;
          end;
        end
        else begin                                                              //je stisknutej Ctrl nebo Shift
          if (FDesigner.ControlCount > 0) then begin
            if (GetKeyState(VK_CONTROL)<0) then begin                           //sipky + Ctrl (+ Shift): posun controlsu o 1, resp 10 bodu
              if (Msg.wParam = 37) then //sipka vlevo
                ChangeControlsPosition(-1, 0, GetKeyState(VK_SHIFT));
              if (Msg.wParam = 38) then //sipka nahoru
                ChangeControlsPosition(0, -1, GetKeyState(VK_SHIFT));
              if (Msg.wParam = 39) then //sipka vpravo
                ChangeControlsPosition(1, 0, GetKeyState(VK_SHIFT));
              if (Msg.wParam = 40) then //sipka dolu
                ChangeControlsPosition(0, 1, GetKeyState(VK_SHIFT));
              Handled := TRUE;
            end
            else if (GetKeyState(VK_SHIFT)<0) then begin                           //sipky + Shift): zvetseni controlsu o 1 bod
              if (Msg.wParam = 37) then //sipka vlevo
                ChangeControlsSize(-1, 0);
              if (Msg.wParam = 38) then //sipka nahoru
                ChangeControlsSize(0, -1);
              if (Msg.wParam = 39) then //sipka vpravo
                ChangeControlsSize(1, 0);
              if (Msg.wParam = 40) then //sipka dolu
                ChangeControlsSize(0, 1);
              Handled := TRUE;
            end
          end;
        end;
      end;
    end;
  end;
end;

procedure TTMSDesigner.tmsInsp_OnDeactivate(Sender: TObject);
begin
  if IDEEngine1.Inspector <> nil then
    IDEEngine1.Inspector.ApplyChanges; //pokud zmenime vlastnost, ale bez ulozeni klikneme mysi nekam jinam
end;

procedure TTMSDesigner.tmsInsp_OnFilter(Sender: TObject; Prop: TProperty; var Result: Boolean);
begin
  if Prop.Instance = nil then
    Result := True
  else if (Prop.Instance.ClassType = TLabel) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'Alignment') or
      (Prop.Name = 'AutoSize') or
      (Prop.Name = 'Caption') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'ParentColor') or
      (Prop.Name = 'Transparent') or
      (Prop.Name = 'WordWrap') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Size') or
      (Prop.Name = 'Style') or
      (Prop.Name = 'fsBold') or
      (Prop.Name = 'fsItalic') or
      (Prop.Name = 'fsUnderline') or
      (Prop.Name = 'fsStrikeOut');
  end
  else if (Prop.Instance.ClassType = TpsvBorderLabel) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'Alignment') or
      (Prop.Name = 'AutoSize') or
      (Prop.Name = 'Caption') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Border') or
      (Prop.Name = 'BorderColor') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'ParentColor') or
      (Prop.Name = 'Transparent') or
      (Prop.Name = 'WordWrap') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Size') or
      (Prop.Name = 'Style') or
      (Prop.Name = 'fsBold') or
      (Prop.Name = 'fsItalic') or
      (Prop.Name = 'fsUnderline') or
      (Prop.Name = 'fsStrikeOut');
  end
  else if (Prop.Instance.ClassType = TpsvWebLabel) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'Alignment') or
      (Prop.Name = 'AutoSize') or
      (Prop.Name = 'Caption') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'ParentColor') or
      (Prop.Name = 'Transparent') or
      (Prop.Name = 'WordWrap') or
      (Prop.Name = 'FocusColor') or
      (Prop.Name = 'Link') or
      (Prop.Name = 'LinkControlName') or
      (Prop.Name = 'Hint') or
      (Prop.Name = 'ShowHint') or
      (Prop.Name = 'LinkType') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Size') or
      (Prop.Name = 'Style') or
      (Prop.Name = 'fsBold') or
      (Prop.Name = 'fsItalic') or
      (Prop.Name = 'fsUnderline') or
      (Prop.Name = 'fsStrikeOut');
  end
  else if (Prop.Instance.ClassType = THTMLStaticText) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'AutoSizeType') or
      (Prop.Name = 'AutoSizing') or
      (Prop.Name = 'BorderStyle') or
      (Prop.Name = 'BorderWidth') or
      (Prop.Name = 'HTMLText') or
      (Prop.Name = 'URLColor') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'ParentColor') or
      (Prop.Name = 'Hint') or
      (Prop.Name = 'ShowHint') or
      (Prop.Name = 'VAlignment') or
      (Prop.Name = 'MiniScroll') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Size') or
      (Prop.Name = 'Style') or
      (Prop.Name = 'fsBold') or
      (Prop.Name = 'fsItalic') or
      (Prop.Name = 'fsUnderline') or
      (Prop.Name = 'fsStrikeOut');
  end
  else if (Prop.Instance.ClassType = TfaEdit) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'InvertAlignment') or
      (Prop.Name = 'BorderColor') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'FldLookup') or
      (Prop.Name = 'FldType') or
      (Prop.Name = 'FldTypeDecimalPlaces') or
      (Prop.Name = 'RestrictLength') or
      (Prop.Name = 'NextDirection') or
      (Prop.Name = 'NextField') or
      (Prop.Name = 'NextFieldBack') or
      (Prop.Name = 'RepAlignment') or
      (Prop.Name = 'RepFontSize') or
      //(Prop.Name = 'RepLength') or
      //(Prop.Name = 'RepPage') or
      (Prop.Name = 'RepPosX') or
      (Prop.Name = 'RepPosY') or
      (Prop.Name = 'HideChar') or
      (Prop.Name = 'DisplayFormat') or
      (Prop.Name = 'InterlaceSize') or
      (Prop.Name = 'InterlaceSizeRep') or
      (Prop.Name = 'InterlaceCount') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'Size') or
      (Prop.Name = 'Transparent') or
      (Prop.Name = 'RepNoThousandSep') or
      (Prop.Name = 'SelectedColor') or
      (Prop.Name = 'RepHide');
  end
  else if (Prop.Instance.ClassType = TcxDBCheckBoxEx) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'Properties') or
      (Prop.Name = 'Alignment') or
      (Prop.Name = 'Style') or
      (Prop.Name = 'BorderColor') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'FldLookup') or
      (Prop.Name = 'FldType') or
      (Prop.Name = 'FldTypeDecimalPlaces') or
      (Prop.Name = 'NextDirection') or
      (Prop.Name = 'NextField') or
      (Prop.Name = 'NextFieldBack') or
      (Prop.Name = 'RepAlignment') or
      (Prop.Name = 'RepFontSize') or
      (Prop.Name = 'RepLength') or
      (Prop.Name = 'RepPage') or
      (Prop.Name = 'RepPosX') or
      (Prop.Name = 'RepPosY') or
      (Prop.Name = 'RepTrueText') or
      (Prop.Name = 'RepFalseText') or
      (Prop.Name = 'SelectedColor') or
      //(Prop.Name = 'ParentColor') or
      (Prop.Name = 'Transparent') or
      (Prop.Name = 'AutoSize') or
      (Prop.Name = 'MultiLine') or
      (Prop.Name = 'Caption') or
      (Prop.Name = 'CaptionTrue') or
      (Prop.Name = 'CaptionFalse') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Size') or
      (Prop.Name = 'Style') or
      (Prop.Name = 'fsBold') or
      (Prop.Name = 'fsItalic') or
      (Prop.Name = 'fsUnderline') or
      (Prop.Name = 'fsStrikeOut') or
      (Prop.Name = 'RepHide') or
      (Prop.Name = 'RadioButtonLook') or
      (Prop.Name = 'NewCheckLook');
  end
  else if (Prop.Instance.ClassType = TcxDBMemoEx) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'Properties') or
      (Prop.Name = 'Alignment') or
      (Prop.Name = 'Style') or
      (Prop.Name = 'BorderColor') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'NextDirection') or
      (Prop.Name = 'NextField') or
      (Prop.Name = 'NextFieldBack') or
      (Prop.Name = 'RepAlignment') or
      (Prop.Name = 'RepFontSize') or
      (Prop.Name = 'RepLength') or
      (Prop.Name = 'RepPage') or
      (Prop.Name = 'RepPosX') or
      (Prop.Name = 'RepPosY') or
      (Prop.Name = 'SelectedColor') or
      (Prop.Name = 'WordWrap') or
      (Prop.Name = 'LookAndFeel') or
      (Prop.Name = 'NativeStyle') or
      (Prop.Name = 'Kind') or
      (Prop.Name = 'ScrollBars') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Size') or
      (Prop.Name = 'RepRowHeight') or
      (Prop.Name = 'RepOffsetFirstRow') or
      (Prop.Name = 'RepHide');
  end
  else if (Prop.Instance.ClassType = TButton) or (Prop.Instance.ClassType = TBitBtn) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'Caption') or
      (Prop.Name = 'Glyph') or
      (Prop.Name = 'Hint') or
      (Prop.Name = 'ShowHint') or
      (Prop.Name = 'Enabled');
  end
  else if (Prop.Instance.ClassType = TShape) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'Brush') or
      (Prop.Name = 'ColorStyle') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Pen') or
      (Prop.Name = 'Align') or
      (Prop.Name = 'Style');
  end
  else if (Prop.Instance.ClassType = TImage) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'AutoSize') or
      (Prop.Name = 'Visible') or      
      (Prop.Name = 'Picture');
  end
  else if (Prop.Instance.ClassType = TcxListBoxEx) then begin
    Result :=
      (Prop.Name = 'Left') or
      (Prop.Name = 'Top') or
      (Prop.Name = 'Width') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Visible') or
      (Prop.Name = 'Properties') or
      (Prop.Name = 'Alignment') or
      (Prop.Name = 'Style') or
      (Prop.Name = 'BorderColor') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Enabled') or
      (Prop.Name = 'NextDirection') or
      (Prop.Name = 'NextField') or
      (Prop.Name = 'NextFieldBack') or
      (Prop.Name = 'SelectedColor') or
      (Prop.Name = 'LookAndFeel') or
      (Prop.Name = 'NativeStyle') or
      (Prop.Name = 'Kind') or
      (Prop.Name = 'ScrollBars') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Columns') or
      (Prop.Name = 'Size');
  end
  else if (Prop.Instance.ClassType = TcxMemoProperties) then begin
    Result :=
      (Prop.Name = 'Alignment') or
      (Prop.Name = 'ScrollBars') or
      (Prop.Name = 'WordWrap');
  end
  else if (Prop.Instance.ClassType = TcxEditStyle) or (Prop.Instance.ClassType = TcxContainerStyle) then begin
    Result :=
      (Prop.Name = 'BorderColor') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Font') or
      (Prop.Name = 'LookAndFeel');
  end
  else if (Prop.Instance.ClassType = TcxLookAndFeel) then begin
    Result :=
      (Prop.Name = 'Kind') or
      (Prop.Name = 'NativeStyle');
  end
  else if (Prop.Instance.ClassType = TcxCheckBoxProperties) then begin
    Result :=
      (Prop.Name = 'Alignment') or
      //(Prop.Name = 'Caption') or
      (Prop.Name = 'MultiLine');
  end
  else if (Prop.Instance.ClassType = TcxCheckBoxStyle)then begin
    Result :=
      (Prop.Name = 'BorderColor') or
      (Prop.Name = 'Color') or
      (Prop.Name = 'Font');
  end
  else if (Prop.Instance.ClassType = TFont) then begin
    Result :=
      (Prop.Name = 'Color') or
      (Prop.Name = 'Height') or
      (Prop.Name = 'Name') or
      (Prop.Name = 'Size') or
      (Prop.Name = 'Style');
  end
  else if (Prop.Instance.ClassType = TBrush) or
          (Prop.Instance.ClassType = TPen) then
    Result := True
  else
    Result := FALSE;
end;

end.

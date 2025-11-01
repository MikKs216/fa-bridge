{ 13. 4. 2023 10:55:00 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in   }
{ 22.10.2019 14:20:53 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Zalozka "Nahled" je nyni skryta.  }
{ 18.12.2018 14:53:27 (GMT+1:00) > [marek on WIN-48QDB6JAV23] checked in Pri ukladani se odstranuje z datasetu faMain (rucne z ulozeneho souboru pomoci Replace).  }
{ 26.10.2017 15:45:30 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Opravy po testovani  }
{ 25.10.2017 11:24:17 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Doplneni designeru FR3 do FA  }
{ 10.10.2017 14:19:09 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Pridani designeru FR3 reportu  }
unit ERepDesigner;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  frxDesgn, frxClass, frxPreview, ComCtrls, Menus, ZipForge, JclFileUtils;

procedure DoOpenFR3Designer(AFDRFileName: string);
function CloseFR3Designer: boolean;

type
  TfmRepDesigner = class(TForm)
    PageControl1: TPageControl;
    DesignerSheet: TTabSheet;
    PreviewSheet: TTabSheet;
    frxPreview1: TfrxPreview;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    NewMI: TMenuItem;
    OpenMI: TMenuItem;
    SaveMI: TMenuItem;
    SaveasMI: TMenuItem;
    N1: TMenuItem;
    PreviewMI: TMenuItem;
    PagesettingsMI: TMenuItem;
    N2: TMenuItem;
    ExitMI: TMenuItem;
    Edit1: TMenuItem;
    UndoMI: TMenuItem;
    RedoMI: TMenuItem;
    N3: TMenuItem;
    CutMI: TMenuItem;
    CopyMI: TMenuItem;
    PasteMI: TMenuItem;
    N4: TMenuItem;
    DeleteMI: TMenuItem;
    DeletePageMI: TMenuItem;
    SelectAllMI: TMenuItem;
    GroupMI: TMenuItem;
    UngroupMI: TMenuItem;
    EditMI: TMenuItem;
    N5: TMenuItem;
    BringtoFrontMI: TMenuItem;
    SendtoBackMI: TMenuItem;
    N6: TMenuItem;
    FindMI: TMenuItem;
    ReplaceMI: TMenuItem;
    FindNextMI: TMenuItem;
    Report1: TMenuItem;
    DataMI: TMenuItem;
    VariablesMI: TMenuItem;
    StylesMI: TMenuItem;
    ReportOptionsMI: TMenuItem;
    View1: TMenuItem;
    ToolbarsMI: TMenuItem;
    N7: TMenuItem;
    RulersMI: TMenuItem;
    GuidesMI: TMenuItem;
    DeleteGuidesMI: TMenuItem;
    N8: TMenuItem;
    OptionsMI: TMenuItem;
    StandardMI: TMenuItem;
    TextMI: TMenuItem;
    FrameMI: TMenuItem;
    AlignmentPaletteMI: TMenuItem;
    ObjectInspectorMI: TMenuItem;
    DataTreeMI: TMenuItem;
    ReportTreeMI: TMenuItem;
    Help1: TMenuItem;
    HelpContentsMI: TMenuItem;
    AboutFastReportMI: TMenuItem;
    N9: TMenuItem;
    NewReportMI: TMenuItem;
    NewPageMI: TMenuItem;
    NewDialogMI: TMenuItem;
    frxDesigner1: TfrxDesigner;
    frxReport1: TfrxReport;
    miNahledFA: TMenuItem;
    procedure BringToFrontEx;
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ExitMIClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function frxDesigner1SaveReport(Report: TfrxReport;
      SaveAs: Boolean): Boolean;
    procedure FormCreate(Sender: TObject);
    procedure miNahledFAClick(Sender: TObject);
  private
    { Private declarations }
    FCanClose: boolean;
    FFDRFileName, FGuidTempName: string;
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    function GetFR3Temp: string;
    function GetFR3FromFDR(const AFDRFileName: string): string;
    function CreateSelectForm(const AFDRFileName, AFR3Temp: string; const AListText: TStrings): string;
    procedure SetMainCaption;
  public
    { Public declarations }
  end;

var
  fmRepDesigner: TfmRepDesigner;

implementation

uses
  frxRes, Main, IniFiles, FCommonUtils, FScriptUtils;

{$R *.DFM}

procedure DoOpenFR3Designer(AFDRFileName: string);

  function LoadFR3: boolean;
  var
    fr3FN: string;
  begin
    Result := True;
    fr3FN := fmRepDesigner.GetFR3FromFDR(AFDRFileName);
    if fr3FN = 'NA' then  //pri vyberu FR3 jsme zvolili Storno, designer se neotevre
      Result := False
    else begin
      if fr3FN <> '' then
        fmRepDesigner.frxReport1.LoadFromFile(fr3FN)
      else begin
        fmRepDesigner.frxReport1.Clear;
        fmRepDesigner.frxReport1.FileName := '';
      end;
    end;
    fmRepDesigner.SetMainCaption;
  end;

begin
  if fmRepDesigner <> nil then begin
    if fmRepDesigner.frxReport1.Designer = nil then begin
      if LoadFR3 then
        fmRepDesigner.BringToFrontEx;
    end
    else
      fmRepDesigner.BringToFrontEx;
  end
  else begin
    Application.CreateForm(TfmRepDesigner, fmRepDesigner);
    fmRepDesigner.FFDRFileName := AFDRFileName;
    if LoadFR3 then
      fmRepDesigner.Show;
  end;
end;

function CloseFR3Designer: boolean;
begin
  Result := True;
  if fmRepDesigner <> nil then
    with fmRepDesigner do begin
      Close;
      if FCanClose then begin
        Free;
        fmRepDesigner:=nil;
      end
      else
        Result := False;
    end;
end;

procedure TfmRepDesigner.BringToFrontEx;
begin
  Show;
  if IsIconic(Handle) then
    ShowWindow(Handle, SW_RESTORE)
  else
    BringToFront;
  SetFocus;
end; {BringToFrontEx}

procedure TfmRepDesigner.SetMainCaption;
begin
  fmRepDesigner.Caption := 'FastReport - '+ExtractFileName(frxReport1.FileName);
end;

function TfmRepDesigner.GetFR3Temp: string;
begin
  Result := GetDirWorkPath+FGuidTempName;
end;

function TfmRepDesigner.CreateSelectForm(const AFDRFileName, AFR3Temp: string; const AListText: TStrings): string;
var
  frm: TForm;
  lbx: TListBox;
  btnSelect, btnNew, btnCancel: TButton;
  mr: word;
begin
  Result := '';
  frm := TForm.Create(nil);
  try
    lbx := TListBox.Create(frm);
    btnSelect := TButton.Create(frm);
    btnNew := TButton.Create(frm);
    btnCancel := TButton.Create(frm);

    //frm.BorderStyle := bsDialog;
    frm.Caption := Format('"%s" - vyberte sestavu',[ExtractFileName(AFDRFileName)]);
    frm.Width := 350;
    frm.Height := 200;
    frm.Position := poMainFormCenter;

    lbx.Parent := frm;
    lbx.Top := 0;
    lbx.Left := 0;
    lbx.Width := 350;
    lbx.Height := 160;
    lbx.Style := lbOwnerDrawFixed;
    lbx.Align := alTop;
    lbx.Anchors := [akLeft, akTop, akRight, akBottom];
    lbx.Items := AListText;
    lbx.ItemIndex := 0;

    btnSelect.Parent := frm;
    btnSelect.Caption := 'Vybrat';
    btnSelect.Default := true;
    btnSelect.ModalResult := mrOk;
    btnSelect.Anchors := [akRight, akBottom];
    btnSelect.Width := 93;
    btnSelect.Top := lbx.Top + lbx.Height + 8;
    btnSelect.Left := lbx.Left + lbx.Width - 300;

    btnNew.Parent := frm;
    btnNew.Caption := 'Nová';
    btnNew.Default := false;
    btnNew.ModalResult := mrYes; //meYes nema vyznam, muze byt cokoliv, ale pokud se pouzilo mrNone, tak tlacitko nereaguje
    btnNew.Anchors := [akRight, akBottom];
    btnNew.Width := 93;
    btnNew.Top := lbx.Top + lbx.Height + 8;
    btnNew.Left := btnSelect.Left + btnSelect.Width + 8;

    btnCancel.Parent := frm;
    btnCancel.Caption := 'Storno';
    btnCancel.Default := false;
    btnCancel.ModalResult := mrCancel;
    btnCancel.Anchors := [akRight, akBottom];
    btnCancel.Width := 93;
    btnCancel.Top := lbx.Top + lbx.Height + 8;
    btnCancel.Left := btnNew.Left + btnNew.Width + 8;

    mr := frm.ShowModal;
    if mr = mrOk then
      Result := NormalPath(AFR3Temp)+lbx.Items[lbx.ItemIndex]
    else begin
      if mr = mrCancel then
        Result := 'NA';
    end;
  finally
    frm.Free;
  end;
end;

function TfmRepDesigner.GetFR3FromFDR(const AFDRFileName: string): string;
var
  sl: TStringList;
  i: Integer;

  procedure UnzipFR3FromFDR(const AFDRFile, ADestDir: string);
  var
    zip :TZipForge;
  begin
    zip := TZipForge.Create(nil);
    try
      if not DirectoryExists(ADestDir) then
        CreateDir(ADestDir);

      if FileExists(AFDRFile) then begin
        zip.FileName:=AFDRFile;
        zip.OpenArchive(fmOpenRead);
        zip.BaseDir:=ADestDir;
        zip.Options.CreateDirs:=True;
        zip.Options.OverwriteMode:= omAlways;
        try
          zip.ExtractFiles('*.fr3');   //Obnovime datove soubory
        finally
          zip.CloseArchive;
        end;
      end;
      //
      SaveStringToFile(AFDRFile,   //jen informace o zdrojovem fdr souboru
       NormalPath(ADestDir)+ChangeFileExt(ExtractFileName(AFDRFile), '.txt'));
    finally
      zip.Free;
    end;
  end;

begin
  Result := '';
  sl:= TStringList.Create;
  try
    FGuidTempName := CreateGUIDString;
    UnzipFR3FromFDR(AFDRFileName, GetFR3Temp);
    sl.Text := SearchFiles(GetFR3Temp, '*.fr3', False);
    for i := 0 to sl.Count - 1 do   //zajisti, aby se v listboxu objevili jen nazvy souboru
      sl[i] := ExtractFileName(sl[i]);
    {if sl.Count = 1 then
      Result := sl[0]
    else} if sl.Count > 0 then
      Result := CreateSelectForm(AFDRFileName, GetFR3Temp, sl);
    //
    GfaMain.Invalidate;
    GfaMain.Refresh;
  finally
    sl.Free;
  end;
end;

function TfmRepDesigner.frxDesigner1SaveReport(Report: TfrxReport;
  SaveAs: Boolean): Boolean;
var
  fn: string;
  str: string;

  procedure ZipFR3ToFDR(const AFDRFile, AReportFile: string);
  var
    zip :TZipForge;
  begin
    zip := TZipForge.Create(nil);
    try
      zip.FileName:=AFDRFile;
      if FileExists(AFDRFile) then      
        zip.OpenArchive(fmOpenReadWrite)
      else
        zip.OpenArchive(fmCreate);      
      zip.Options.OverwriteMode:= omAlways;
      zip.BaseDir:=ExtractFilePath(AReportFile);
      try
        zip.AddFiles(ExtractFileName(AReportFile));
      finally
        zip.CloseArchive;
      end;
    finally
      zip.Free;
    end;
  end;

  function GetNewRepFileName: string;
  var
    saveDialog : TSaveDialog;
  begin
    Result := '';
    saveDialog := TSaveDialog.Create(self);
    try
      saveDialog.Title := 'Uložit jako';
      saveDialog.InitialDir := GetFR3Temp;
      saveDialog.Filter := 'Report|*.fr3';
      saveDialog.DefaultExt := 'fr3';
      if saveDialog.Execute then begin
        if not FileExists(savedialog.FileName) or
            (MsgBoxAsk('Potvrdit uložení jako', 'Soubor ' + ExtractFileName(saveDialog.FileName) + ' již existuje.'+cCRLF+
                       'Chcete ho nahradit?',
                       MB_YESNO) = IDYES) then begin
            Result := savedialog.FileName;
        end;
      end
    finally
      saveDialog.Free;
    end;
  end;

begin
  fn := Report.FileName;
  if (fn = '') {or SaveAs} then  //pokud je povoleno, tak se pri normalnim ulozeni report ulozi, ale stale se tvari jako neulozeny
    fn := GetNewRepFileName;
  if fn <> '' then begin
    Report.FileName := fn;
    SetMainCaption;
    Report.SaveToFile(fn);
    str := LoadStringFromFile(fn);
    SaveStringToFile(Replace('DataSet="faMain.', str, 'DataSet="', True), fn);
    ZipFR3ToFDR(FFDRFileName, fn);
  end
  else
    Abort;
end;

procedure TfmRepDesigner.LoadFormStateFromIni;
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '_FR3.ini'));
  try
    Left := iniFile.ReadInteger('RepForm', 'Left', 50);
    Top := iniFile.ReadInteger('RepForm', 'Top', 50);
    Width := iniFile.ReadInteger('RepForm', 'Width', 870);
    Height := iniFile.ReadInteger('RepForm', 'Height', 640);
  finally
    iniFile.Free;
  end;
end;

procedure TfmRepDesigner.miNahledFAClick(Sender: TObject);
begin
//  GfaMain.BringToFront;
  GfaMain.dxBarButtonPreviewClick(nil);
end;

procedure TfmRepDesigner.SaveFormStateToIni;
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '_FR3.ini'));
  try
    iniFile.WriteInteger('RepForm', 'Left', Left);
    iniFile.WriteInteger('RepForm', 'Top', Top);
    iniFile.WriteInteger('RepForm', 'Width', Width);
    iniFile.WriteInteger('RepForm', 'Height', Height);
  finally
    iniFile.Free;
  end;
end;

procedure TfmRepDesigner.FormShow(Sender: TObject);
var
  Designer: TfrxDesignerForm;
begin
  LoadFormStateFromIni;
  // prevent saving/restoring a report when previewing. This will destroy
  // objects that are loaded in the designer and will lead to AV.
  frxReport1.EngineOptions.DestroyForms := False;
  // set the custom preview
  frxReport1.Preview := frxPreview1;
  // display the designer
  frxReport1.DesignReportInPanel(DesignerSheet);

  // set FR images for our menu
  MainMenu1.Images := frxResources.MainButtonImages;
  // get the reference to the Designer
  Designer := TfrxDesignerForm(frxReport1.Designer);

  // assign FR actions to our menu items
  NewMI.Action := Designer.NewItemCmd;
  NewReportMI.Action := Designer.NewReportCmd;
  NewPageMI.Action := Designer.NewPageCmd;
  NewDialogMI.Action := Designer.NewDialogCmd;
  OpenMI.Action := Designer.OpenCmd;
  SaveMI.Action := Designer.SaveCmd;
  //SaveasMI.Action := Designer.SaveAsCmd; //pokud je povoleno, tak se pri normalnim ulozeni report ulozi, ale stale se tvari jako neulozeny
  PreviewMI.Action := Designer.PreviewCmd;
  PageSettingsMI.Action := Designer.PageSettingsCmd;

  UndoMI.Action := Designer.UndoCmd;
  RedoMI.Action := Designer.RedoCmd;
  CutMI.Action := Designer.CutCmd;
  CopyMI.Action := Designer.CopyCmd;
  PasteMI.Action := Designer.PasteCmd;
  DeleteMI.Action := Designer.DeleteCmd;
  DeletePageMI.Action := Designer.DeletePageCmd;
  SelectAllMI.Action := Designer.SelectAllCmd;
  GroupMI.Action := Designer.GroupCmd;
  UngroupMI.Action := Designer.UngroupCmd;
  EditMI.Action := Designer.EditCmd;
  FindMI.Action := Designer.FindCmd;
  ReplaceMI.Action := Designer.ReplaceCmd;
  FindNextMI.Action := Designer.FindNextCmd;
  BringtoFrontMI.Action := Designer.BringToFrontCmd;
  SendtoBackMI.Action := Designer.SendToBackCmd;

  DataMI.Action := Designer.ReportDataCmd;
  VariablesMI.Action := Designer.VariablesCmd;
  StylesMI.Action := Designer.ReportStylesCmd;
  ReportOptionsMI.Action := Designer.ReportOptionsCmd;

  ToolbarsMI.Action := Designer.ToolbarsCmd;
  StandardMI.Action := Designer.StandardTBCmd;
  TextMI.Action := Designer.TextTBCmd;
  FrameMI.Action := Designer.FrameTBCmd;
  AlignmentPaletteMI.Action := Designer.AlignTBCmd;
  ObjectInspectorMI.Action := Designer.InspectorTBCmd;
  DataTreeMI.Action := Designer.DataTreeTBCmd;
  ReportTreeMI.Action := Designer.ReportTreeTBCmd;
  RulersMI.Action := Designer.ShowRulersCmd;
  GuidesMI.Action := Designer.ShowGuidesCmd;
  DeleteGuidesMI.Action := Designer.DeleteVGuidesCmd;
  OptionsMI.Action := Designer.OptionsCmd;

  HelpContentsMI.Action := Designer.HelpContentsCmd;
  AboutFastReportMI.Action := Designer.AboutCmd;
end;

procedure TfmRepDesigner.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = PreviewSheet then
    frxReport1.PrepareReport
end;

procedure TfmRepDesigner.ExitMIClick(Sender: TObject);
begin
  Close;
end;

procedure TfmRepDesigner.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormStateToIni;
  if frxReport1.Designer <> nil then begin
    frxDesigner1.Restrictions := [drDontSaveReport]; //nastaveni restriction je z toho duvodu, ze v OnCloseQuery je dotaz na ulozeni
    try
      frxReport1.Designer.Close;                     //tak i kdyz se da ulozit, tak zde pri OnClose se objevi dotaz znovu
    finally
      frxDesigner1.Restrictions := [];
    end;
  end;
end;

procedure TfmRepDesigner.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if frxReport1.Designer <> nil then
    CanClose := (frxReport1.Designer.CloseQuery);
  FCanClose := CanClose;
end;

procedure TfmRepDesigner.FormCreate(Sender: TObject);
begin
  PageControl1.Pages[1].TabVisible := false;
  FCanClose := True;
end;

end.

{ 18.9.2020 14:10:20 (GMT+2:00) > [mik on WIN-48QDB6JAV23] checked in Oprava okno se oteviralo mimo FA. Sjednoceno s ostatnimi modalnimi okny nad FA  }
{ 4.10.2018 12:03:11 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in do procedure FillTable upraveno, pokud je sirka sloupce v AColumnsWidth -1, tak se sloupec v nezobrazu (jen ve finalbuildu)  }
{ 25.2.2016 14:46:16 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 1181 - doplnen ExportGrid  }
{ 10.10.2008 11:06:11 (GMT+2:00) > [mik] checked in Opravena chyba nezobrazovani nazvu sloupcu v simplelistu  }
{ 21.12.2006 8:58:52 (GMT+1:00) > [mik on PCMIK64] checked in   }
{ 5.9.2006 9:39:29 (GMT+2:00) > [mik on PCMIK64] checked in Doplneny nove vlastnosti simplelistu, trideni, hledani, filtry  }
{ 17.10.2005 11:50:50 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 7.9.2005 16:19:42 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 5.6.2005 9:34:27 (GMT+2:00) > [mik on PCMIKVIRTUAL] checked in   }
{ 27.10.2003 21:05:22 (GMT+1:00) > [mik on PCMIKHOME] checked in   }
{ 4.9.2003 0:46:15 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 3.9.2003 19:28:46 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 23.8.2003 6:54:12 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 15:26:41 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 15:20:27 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 22.8.2003 13:34:26 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
{ 21.8.2003 22:36:36 (GMT+2:00) > [mik on PCMIKHOME] checked in   }

unit ESimpleList;
{$I Switches.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxEdit,
  DB, cxDBData, cxGridLevel, cxGridBandedTableView,
  cxGridDBBandedTableView, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  kbmMemTable, Grids, DBGrids, cxDataStorage, Menus, cxLookAndFeelPainters,
  StdCtrls, cxButtons, ExtCtrls, cxLookAndFeels, cxNavigator;

function OpenSimpleList(const AListValues: string; AValue: string;
  const AColumnsWidth: string = ''; AResultColumnIndex: integer = 0;
  const ACaption: string = ''; const AColumnNames: string = ''): variant;

type
  TfmSimpleList = class(TForm)
    mtList: TkbmMemTable;
    dsList: TDataSource;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    Panel2: TPanel;
    Panel4: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    PopupMenu1: TPopupMenu;
    miExport: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure cxGrid1DBTableView1DblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure miExportClick(Sender: TObject);
  private
    procedure FillTable(const AListValues, AColumnsWidth: string;
      ASerchRecValue: string; const AColumnNames: string = '');
    procedure SaveFormStateToIni;
    procedure LoadFormStateFromIni;
    procedure ExportGrid(AGrid: TcxGrid);
  public
    FResultColumnIndex: integer;
    FResultValue: variant;
  end;

var
  fmSimpleList: TfmSimpleList;

implementation

{$R *.dfm}

uses
  Main, IniFiles, FCommonUtils, Res_FA, cxGridExportLink,
//  {$IFNDEF STANDALONE}
  SpolFunkce,
//  {$ENDIF STANDALONE}
  Math;

procedure TfmSimpleList.FillTable(const AListValues, AColumnsWidth: string;
  ASerchRecValue: string; const AColumnNames: string = '');
var
  i,j: integer;
  numCols, colWidth: integer;
  vals: TStringList;
begin
  StartWait;
  mtList.DisableControls;
  vals := TStringList.Create;
  try
    if Pos('|',AListValues)>0 then
      vals.Text:=Replace('|',AListValues,#13#10)
    else
      vals.Text:=Replace(';',AListValues,#13#10);
    if vals.Count>0 then begin
      numCols:=CountListItems(vals[0]);
      with mtList do begin
        Active := False;
        EmptyTable;
        with FieldDefs do begin
          Clear;
          for i := 1 to numCols do begin
            with AddFieldDef do begin
              mtList.FieldDefs[i - 1].Name := 'fld'+IntToStr(i);
              { v D2007 prestalo fungovat, presunuto do nastaveni mrizky nize
                if AColumnNames<>'' then
                mtList.FieldDefs[i - 1].DisplayName :=
                  GetListItem(AColumnNames,i-1)
              else
                mtList.FieldDefs[i - 1].DisplayName := Chr(i+65);}
              DataType := ftString;
              Required := FALSE;
            end;
          end;
        end;
        //
        CreateTable;
        if Fields.Count > 0 then begin
          for i := 0 to Fields.Count - 1 do begin
            Fields[i].Alignment := taLeftJustify;
            Fields[i].Size := 255;
          end;
        end;
        //naplneni hodnot udaju
        if Fields.Count > 0 then begin
          Open;
          for i:=0 to vals.Count-1 do begin
            Append;
            for j := 0 to Fields.Count - 1 do
              Fields[j].Value := GetListItem(vals[i],j);
            Post;
          end;
          if (ASerchRecValue<>'') and (Fields.Count>0) then begin
            if not Locate(Fields[FResultColumnIndex].FieldName,ASerchRecValue,
              [loCaseInsensitive]) then
              First;
          end
          else
            First;
        end;
      end;
      //napojeni sloupcu a sirky sloupcu
      for i := cxGrid1DBTableView1.ColumnCount - 1 downto 0 do
        cxGrid1DBTableView1.Columns[i].Destroy;
      for i := 0 to mtList.FieldCount - 1 do begin
        colWidth:=StrToIntSafe(GetListItem(AColumnsWidth,i));
        {$IFDEF FINALBUILD}
        //Marek 4.10.2018 - ve finalbuildu nezobrazujeme sloupec, ktery ma sirku -1
        //(pouziji ve skriptu ve funkci DoOpenSimpleList, pokud ji pouzivame pro hledani
        //a v poslednim sloupci si zobrazujeme pomocne udaje)
        if colWidth>-1 then begin
        {$ENDIF FINALBUILD}
          cxGrid1DBTableView1.CreateColumn();
          cxGrid1DBTableView1.Columns[i].DataBinding.FieldName:=
            mtList.Fields[i].FieldName;
          if AColumnNames<>'' then
            cxGrid1DBTableView1.Columns[i].Caption:=
              GetListItem(AColumnNames,i)
          else
            cxGrid1DBTableView1.Columns[i].Caption:=
              Chr(i+65);
          //
          if colWidth=0 then
            case i of
              0: if mtList.FieldCount=1 then
                   colWidth:=250
                 else
                   colWidth:=50;
              1: colWidth:=250;
            else
              colWidth:=100;
            end;
          cxGrid1DBTableView1.Columns[i].Width:=colWidth;
        {$IFDEF FINALBUILD}
        end;
        {$ENDIF FINALBUILD}
      end;
    end;
  finally
    mtList.EnableControls;
    StopWait;
  end;
end;

//AListValues ... value, value CRLF value, value
function OpenSimpleList(const AListValues: string; AValue: string;
  const AColumnsWidth: string = ''; AResultColumnIndex: integer = 0;
  const ACaption: string = ''; const AColumnNames: string = ''): variant;
begin
  fmSimpleList:=TfmSimpleList.Create(nil);
  try
    with fmSimpleList do begin
      FResultValue:=null;
      FResultColumnIndex:=AResultColumnIndex;
      FillTable(AListValues,AColumnsWidth,AValue,AColumnNames);
      if ACaption<>'' then
        fmSimpleList.Caption:=ACaption;
      fmSimpleList.ShowModal;
      Result := FResultValue;
    end;
  finally
    fmSimpleList.Free;
    fmSimpleList:=nil;
  end;
end; {OpenSimpleList}

procedure TfmSimpleList.FormShow(Sender: TObject);
begin
  mtList.Refresh;
end;

procedure TfmSimpleList.cxGrid1DBTableView1DblClick(Sender: TObject);
begin
  FResultValue:=mtList.Fields[FResultColumnIndex].Value;
  Close;
end;

procedure TfmSimpleList.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then begin
    FResultValue:=mtList.Fields[FResultColumnIndex].Value;
    Key:=#0;
    Close;
  end
  else if Key=#27 then begin
    Key:=#0;
    Close;
  end;
end;

procedure TfmSimpleList.LoadFormStateFromIni;
var
  iniFile: TMemIniFile;
begin
  iniFile := TMemIniFile.Create(GfaMain.GetIniFileName);
  try
  (*
{$IFDEF STANDALONE}
    Left:=iniFile.ReadInteger(Name, 'Left',
      GfaMain.Left+GfaMain.paLeft.Width+5);
    Top:=iniFile.ReadInteger(Name, 'Top',
      GfaMain.Top+80);
{$ELSE STANDALONE}
    Left:=iniFile.ReadInteger(Name, 'Left', 0);
    Top:=iniFile.ReadInteger(Name, 'Top', 0);
{$ENDIF STANDALONE}
*)
    Left:=GfaMain.Left+5;
    Top:=GfaMain.Top+30;
    Width:=iniFile.ReadInteger(Name, 'Width', 330);
    Height:=iniFile.ReadInteger(Name, 'Height', 260);
  finally
    iniFile.Free;
  end;
end;

procedure TfmSimpleList.miExportClick(Sender: TObject);
begin
  ExportGrid(cxGrid1);
end;

procedure TfmSimpleList.SaveFormStateToIni;
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
end;

procedure TfmSimpleList.FormCreate(Sender: TObject);
begin
  LoadFormStateFromIni;
end;

procedure TfmSimpleList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormStateToIni;
end;

procedure TfmSimpleList.btnOKClick(Sender: TObject);
begin
  FResultValue:=mtList.Fields[FResultColumnIndex].Value;
end;

procedure TfmSimpleList.ExportGrid(AGrid: TcxGrid);
var
  dlgExportGrid: TSaveDialog;
begin
  dlgExportGrid := TSaveDialog.Create(nil);
  try
    dlgExportGrid.DefaultExt := '.txt';
    dlgExportGrid.Filter :=
      SRMDlgAllFil+' (*.txt)|*.txt|'+
      SRMDlgExcel+' (*.xls)|*.xls|'+
      SRMDlgXMLFil+' (*.xml)|*.xml';
    dlgExportGrid.Title := SRMDlgExpTitl;

    if dlgExportGrid.Execute then begin
      if FileExists(dlgExportGrid.FileName) and
        (MessageAsk(SMExportCap, SRMReplFile, [MBYES, MBNO])=MRNO) then
        EXIT;
      if UpperCase(ExtractFileExt(dlgExportGrid.FileName))='.XLS' then begin
        ExportGridToExcel(dlgExportGrid.FileName, AGrid);
      end
      else if UpperCase(ExtractFileExt(dlgExportGrid.FileName))='.XML' then begin
        ExportGridToXML(dlgExportGrid.FileName, AGrid);
      end
      else begin
        ExportGridToText(dlgExportGrid.FileName, AGrid, True, True,';','"','"');
      end;
    end;
  finally
    dlgExportGrid.Free;
  end;
end;{ExportGrid}

end.

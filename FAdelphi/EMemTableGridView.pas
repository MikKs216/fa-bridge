{ 26.10.2018 14:25:03 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in zarazeni do projektu  }
unit EMemTableGridView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, DB, kbmMemTable, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxInplaceContainer, cxVGrid, cxDBVGrid, cxBlobEdit;

procedure DoOpenGridView;
function CloseGridView: boolean;

type
  TfmMemTableGridView = class(TForm)
    pa1: TPanel;
    rgmtValues_1: TRadioButton;
    rgmtWork_1: TRadioButton;
    rgwt1_1: TRadioButton;
    ds1: TDataSource;
    rgwt2_1: TRadioButton;
    rgwt3_1: TRadioButton;
    rgwt4_1: TRadioButton;
    rgwt5_1: TRadioButton;
    rgwt6_1: TRadioButton;
    Splitter1: TSplitter;
    pa2: TPanel;
    rgmtValues_2: TRadioButton;
    rgmtWork_2: TRadioButton;
    rgwt1_2: TRadioButton;
    rgwt2_2: TRadioButton;
    rgwt3_2: TRadioButton;
    rgwt4_2: TRadioButton;
    rgwt5_2: TRadioButton;
    rgwt6_2: TRadioButton;
    ds2: TDataSource;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid2: TcxGrid;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxGrid2Level1: TcxGridLevel;
    paTop1: TPanel;
    paTop2: TPanel;
    cxDBVGrid1: TcxDBVerticalGrid;
    cxDBVGrid2: TcxDBVerticalGrid;
    lbFilter_2: TLabel;
    lbFilter_1: TLabel;
    ckVerticalGrid_1: TCheckBox;
    ckVerticalGrid_2: TCheckBox;
    procedure BringToFrontEx;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure rgmtValues_1Click(Sender: TObject);
    procedure rgmtValues_2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxGrid2DBTableView1DataControllerDataChanged(Sender: TObject);
    procedure cxGrid1DBTableView1DataControllerDataChanged(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FCanClose: boolean;
    procedure SetGridProperties(const AMt: TkbmMemTable; AGrid: TcxGrid);
    procedure SetGridVProperties(const AMt: TkbmMemTable; AGrid: TcxDBVerticalGrid);
    procedure ClearGridItems(AGrid: TcxGrid);
    procedure ReFillGrid(ANo: string; ADs: TDataSource;
     AGrid: TcxGrid; AGridV: TcxDBVerticalGrid; AVerticalGrid: TCheckBox);
    function GetTableByRadio(ANo: string): TkbmMemTable; 
  public
    { Public declarations }
  end;

var
  fmMemTableGridView: TfmMemTableGridView;

implementation

uses
  FCommonUtils, Main;

{$R *.dfm}

procedure DoOpenGridView;
begin
  if fmMemTableGridView <> nil then
    fmMemTableGridView.BringToFrontEx
  else begin
    Application.CreateForm(TfmMemTableGridView, fmMemTableGridView);
    fmMemTableGridView.Show;
  end;
end;

function CloseGridView: boolean;
begin
  Result := True;
  if fmMemTableGridView <> nil then begin
    fmMemTableGridView.Close;
    if (fmMemTableGridView <> nil) and (fmMemTableGridView.FCanClose) then begin
      fmMemTableGridView.Free;
      fmMemTableGridView:=nil;
    end
    else
      Result := False;
  end;
end;

procedure TfmMemTableGridView.BringToFrontEx;
begin
  Show;
  if IsIconic(Handle) then
    ShowWindow(Handle, SW_RESTORE)
  else
    BringToFront;
  SetFocus;
end; {BringToFrontEx}

procedure TfmMemTableGridView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if fmMemTableGridView <> nil then begin
    if fmMemTableGridView.FCanClose then begin
      fmMemTableGridView.Free;
      fmMemTableGridView:=nil;
    end;
  end;
end;

procedure TfmMemTableGridView.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FCanClose := CanClose;
end;

procedure TfmMemTableGridView.FormShow(Sender: TObject);
begin
  Left := GfaMain.Left+GfaMain.Width;
  Top := GfaMain.Top;
end;

function GetTableByNameX(AName: string): TkbmMemTable;
begin
  with GfaMain do begin
    if SameText(AName, 'mtValues') then
      Result := mtValues
    else if SameText(AName, 'mtWork') then
      Result := mtWork
    else if SameText(AName, 'wt1') then
      Result := wt1
    else if SameText(AName, 'wt2') then
      Result := wt2
    else if SameText(AName, 'wt3') then
      Result := wt3
    else if SameText(AName, 'wt4') then
      Result := wt4
    else if SameText(AName, 'wt5') then
      Result := wt5
    else if SameText(AName, 'wt6') then
      Result := wt6;
  end;

end;

function TfmMemTableGridView.GetTableByRadio(ANo: string): TkbmMemTable;
begin
  with GfaMain do begin
    if (fmMemTableGridView.FindComponent('rgmtValues_'+ANo) as TRadioButton).Checked then
      Result := mtValues
    else if (fmMemTableGridView.FindComponent('rgmtWork_'+ANo) as TRadioButton).Checked then
      Result := mtWork
    else if (fmMemTableGridView.FindComponent('rgwt1_'+ANo) as TRadioButton).Checked then
      Result := wt1
    else if (fmMemTableGridView.FindComponent('rgwt2_'+ANo) as TRadioButton).Checked then
      Result := wt2
    else if (fmMemTableGridView.FindComponent('rgwt3_'+ANo) as TRadioButton).Checked then
      Result := wt3
    else if (fmMemTableGridView.FindComponent('rgwt4_'+ANo) as TRadioButton).Checked then
      Result := wt4
    else if (fmMemTableGridView.FindComponent('rgwt5_'+ANo) as TRadioButton).Checked then
      Result := wt5
    else if (fmMemTableGridView.FindComponent('rgwt6_'+ANo) as TRadioButton).Checked then
      Result := wt6;
  end;

end;

procedure TfmMemTableGridView.ClearGridItems(AGrid: TcxGrid);
begin
  (AGrid.Levels[0].GridView as TcxGridDBTableView).ClearItems;
  (AGrid.Levels[0].GridView as TcxGridDBTableView).DataController.CreateAllItems;
end;

procedure TfmMemTableGridView.cxGrid1DBTableView1DataControllerDataChanged(
  Sender: TObject);
var
  kb: TkbmMemTable;
begin
  kb:=(ds1.DataSet as TkbmMemTable);
  if (kb <> nil) and (kb.Active) and (kb.Filtered) then
    lbFilter_1.Caption := Format('%s Filter: %s',[kb.Name, kb.Filter])
  else
    lbFilter_1.Caption := '';
end;

procedure TfmMemTableGridView.cxGrid2DBTableView1DataControllerDataChanged(
  Sender: TObject);
var
  kb: TkbmMemTable;
begin
  kb:=(ds2.DataSet as TkbmMemTable);
  if (kb <> nil) and (kb.Active) and (kb.Filtered) then
    lbFilter_2.Caption := Format('%s Filter: %s',[kb.Name, kb.Filter])
  else
    lbFilter_2.Caption := '';
end;

procedure TfmMemTableGridView.ReFillGrid(ANo: string; ADs: TDataSource;
           AGrid: TcxGrid; AGridV: TcxDBVerticalGrid; AVerticalGrid: TCheckBox);
var
  kb: TkbmMemTable;
begin
  with GfaMain do begin
    kb := GetTableByRadio(ANo);
    //
    if kb.Active then begin
      ADs.DataSet := kb;
      if AVerticalGrid.Checked then//if (kb = mtValues) then
        SetGridVProperties(kb, AGridV)
      else
        SetGridProperties(kb, AGrid);
    end
    else begin
      ADs.DataSet := nil;
      if AVerticalGrid.Checked then//if (kb = mtValues) then
        AGridV.ClearRows
      else
        ClearGridItems(AGrid);
    end;
    //
    AGrid.Visible := (not AVerticalGrid.Checked);//(kb <> mtValues);
    AGridV.Visible := (AVerticalGrid.Checked);//(kb = mtValues);
  end;
end;

procedure TfmMemTableGridView.rgmtValues_1Click(Sender: TObject);
begin
  ReFillGrid('1', ds1, cxGrid1, cxDBVGrid1, ckVerticalGrid_1);
end;

procedure TfmMemTableGridView.rgmtValues_2Click(Sender: TObject);
begin
  ReFillGrid('2', ds2, cxGrid2, cxDBVGrid2, ckVerticalGrid_2);
end;

procedure TfmMemTableGridView.SetGridProperties(const AMt: TkbmMemTable; AGrid: TcxGrid);
var
  i: integer;
  slWidth: TStringList;
  radek: string;

  function ReplaceListItem(const ACSVList, ANewStringItem: string; AItemIndex: integer): string;
  var
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      sl.CommaText := ACSVList;
      if (AItemIndex >= 0) and (AItemIndex < sl.Count) then
        sl[AItemIndex] := ANewStringItem;
      Result := sl.CommaText;
    finally
      sl.Free;
    end;
  end;

  function GetLongerText(const AStr1, AStr2: string): string;
  begin
    Result := AStr1;
    if Length(AStr2) > Length(AStr1) then
      Result := AStr2;
  end;

  function GetWidthText(const Text:String; Font:TFont): Integer;
  var
    LBmp: TBitmap;
  begin
    LBmp := TBitmap.Create;
    try
      LBmp.Canvas.Font := Font;
      Result := LBmp.Canvas.TextWidth(Text);
    finally
      LBmp.Free;
    end;
  end;

begin
  StartWait;
  AMt.DisableControls;
  slWidth := TStringList.Create;
  try
    if AMt.Active then begin
      radek := '';
      for i := 0 to AMt.Fields.Count - 1 do begin
        radek := AddValueToList(radek, AMt.Fields[i].FieldName, True); //nazvy fildu si zapiseme pro nastaveni idealni sirky kazdeho sloupce v gridu
      end;
      slWidth.Add(radek);
      //
      AMt.First;
      while not AMt.Eof do begin
        for i := 0 to AMt.Fields.Count - 1 do begin
          //novy text porovname s predchozim a pokud je delsi, tak predchozi prepiseme
          slWidth[0] := ReplaceListItem(slWidth[0], GetLongerText(GetListItem(slWidth[0],i), AMt.Fields[i].AsString), i);
        end;
        //
        AMt.Next;
      end;
      //
      //napojeni sloupcu a sirky sloupcu
      ClearGridItems(AGrid);
      (AGrid.Levels[0].GridView as TcxGridDBTableView).BeginUpdate;
      for i := 0 to (AGrid.Levels[0].GridView as TcxGridDBTableView).ColumnCount - 1 do
        (AGrid.Levels[0].GridView as TcxGridDBTableView).Columns[i].Width :=
         GetWidthText(GetListItem(slwidth[0], i), AGrid.Font)+10;;
      (AGrid.Levels[0].GridView as TcxGridDBTableView).EndUpdate;
    end;
  finally
    AMt.EnableControls;
    StopWait;
  end;
end;

procedure TfmMemTableGridView.SetGridVProperties(const AMt: TkbmMemTable; AGrid: TcxDBVerticalGrid);
var
  i: integer;
  ARow: TcxDBEditorRow;  
begin
  StartWait;
  try
    if AMt.Active then begin
      AGrid.ClearRows;
      AGrid.BeginUpdate;
      AGrid.DataController.BeginUpdateFields;
      //AGrid.DataController.CreateAllItems;
      for i := 0 to AMt.Fields.Count - 1 do    begin
        ARow :=  TcxDBEditorRow(AGrid.Add(TcxDBEditorRow));
        TcxDBEditorRow(ARow).Properties.DataBinding.FieldName := AMt.Fields.Fields[I].FieldName;
//        if AMt.Fields.Fields[I].DataType = ftMemo then
  //        TcxDBEditorRow(ARow).Properties.EditPropertiesClass := TcxBlobEditProperties;
      end;
      AGrid.DataController.EndUpdateFields;
      AGrid.EndUpdate;
    end;
  finally
    StopWait;
  end;
end;

end.

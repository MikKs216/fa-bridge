unit ETMSAlignPalette;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Menus, FormDesigner;

type
  TfmAlignmentPalette = class(TForm)
    sbtLeft: TSpeedButton;
    sbtHorCenter: TSpeedButton;
    sbtHorWinCenter: TSpeedButton;
    sbtHorSpace: TSpeedButton;
    sbtRight: TSpeedButton;
    sbtTop: TSpeedButton;
    sbtVerCenter: TSpeedButton;
    sbtVerSpace: TSpeedButton;
    sbtVerWinCenter: TSpeedButton;
    sbtBottom: TSpeedButton;
    pmnMain: TPopupMenu;
    mniStayOnTop: TMenuItem;
    mniShowHints: TMenuItem;
    mniHide: TMenuItem;
    procedure pmnMainPopup(Sender: TObject);
    procedure mniStayOnTopClick(Sender: TObject);
    procedure mniShowHintsClick(Sender: TObject);
    procedure mniHideClick(Sender: TObject);
    procedure sbtHorClick(Sender: TObject);
    procedure sbtVerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure AlignControlsEx(Hor,Ver: TAlignMode);
  public
    { Public declarations }
    procedure SetFlatButtons(AFlat: Boolean);
  end;

var
  fmAlignmentPalette: TfmAlignmentPalette;

implementation

uses ETMSDesigner;

{$R *.DFM}

procedure TfmAlignmentPalette.SetFlatButtons(AFlat: Boolean);
var
  i: Integer;
begin
  for i:=0 to Pred(ControlCount) do
    if Controls[i] is TSpeedButton then
      TSpeedButton(Controls[i]).Flat:=AFlat;
end;

procedure TfmAlignmentPalette.pmnMainPopup(Sender: TObject);
begin
  mniStayOnTop.Checked:=FormStyle=fsStayOnTop;
  mniShowHints.Checked:=ShowHint;
end;

procedure TfmAlignmentPalette.mniStayOnTopClick(Sender: TObject);
begin
  with mniStayOnTop do
  begin
    Checked:=not Checked;
    if Checked then
    begin
      FormStyle:=fsStayOnTop;
      if Assigned(Self.Owner) then
        with Self.Owner as TAdvCustomFormDesigner do
          AlignmentPalette:=AlignmentPalette+[apStayOnTop];
    end
    else
    begin
      FormStyle:=fsNormal;
      if Assigned(Self.Owner) then
        with Self.Owner as TAdvCustomFormDesigner do
          AlignmentPalette:=AlignmentPalette-[apStayOnTop];
    end;
  end;
end;

procedure TfmAlignmentPalette.mniShowHintsClick(Sender: TObject);
begin
  with mniShowHints do
  begin
    Checked:=not Checked;
    ShowHint:=Checked;
    if Checked then
    begin
      if Assigned(Self.Owner) then
        with Self.Owner as TAdvCustomFormDesigner do
          AlignmentPalette:=AlignmentPalette+[apShowHints];
    end
    else
    begin
      if Assigned(Self.Owner) then
        with Self.Owner as TAdvCustomFormDesigner do
          AlignmentPalette:=AlignmentPalette-[apShowHints];
    end;
  end;
end;

procedure TfmAlignmentPalette.FormCreate(Sender: TObject);
begin
  FormStyle := fsStayOnTop;
  ShowHint := True;
end;

procedure TfmAlignmentPalette.mniHideClick(Sender: TObject);
begin
  Hide;
end;

procedure TfmAlignmentPalette.sbtHorClick(Sender: TObject);
begin
  if Assigned(Owner) then
    AlignControlsEx(TAlignMode((Sender as TSpeedButton).Tag),amNoChange);
end;

procedure TfmAlignmentPalette.sbtVerClick(Sender: TObject);
begin
  if Assigned(Owner) then
    AlignControlsEx(amNoChange,TAlignMode((Sender as TSpeedButton).Tag));
end;

procedure TfmAlignmentPalette.AlignControlsEx(Hor,Ver: TAlignMode);
var
  i,Val,Min,Max: Integer;
begin
  if Active and (tmsDesigner <> nil) then with tmsDesigner, FDesigner do
  begin
    if ControlCount>0 then
    begin
      with TList.Create do
      try
        for i:=0 to Pred(ControlCount) do
          if not IsLocked(Controls[i]) then Add(Controls[i]);
        case Hor of
          amLeftTop:
            if ControlCount>1 then
            begin
              //Sort(LeftSort);
              for i:=0 to Pred(ControlCount) do
                if not IsLocked(Controls[i]) then
                  Controls[i].Left:=TControl(Items[0]).Left;
            end;
          amCenters:
            if ControlCount>1 then
            begin
              //Sort(LeftSort);
              Val:=TControl(Items[0]).Left;
              //Sort(RightSort);
              with TControl(Items[0]) do Val:=(Val+Left+Width) div 2;
              for i:=0 to Pred(ControlCount) do
                if not IsLocked(Controls[i]) then
                  with Controls[i] do Left:=Val-Width div 2;
            end;
          amRightBottom:
            if ControlCount>1 then
            begin
              //Sort(RightSort);
              with TControl(Items[0]) do Val:=Left+Width;
              for i:=0 to Pred(ControlCount) do
                if not IsLocked(Controls[i]) then
                  with Controls[i] do Left:=Val-Width;
            end;
          amSpace:
            if Count>1 then
            begin
              //Sort(LeftSort);
              Val:=(TControl(Items[Pred(Count)]).Left-TControl(Items[0]).Left) div Pred(Count);
              for i:=0 to Pred(Count) do
                TControl(Items[i]).Left:=TControl(Items[0]).Left+Val*i;
            end;
          amWindowCenter:
          begin
            Val:=Control.Parent.ClientWidth;
            Min:=MaxInt;
            Max:=-MaxInt;
            for i:=0 to Pred(ControlCount) do
              with Controls[i] do
              begin
                if Left<Min then Min:=Left;
                if Left+Width>Max then Max:=Left+Width;
              end;
            for i:=0 to Pred(ControlCount) do
              if not IsLocked(Controls[i]) then
                with Controls[i] do Left:=Left+(Val-Max+Min) div 2-Min;
          end;
        end;
        case Ver of
          amLeftTop:
            if ControlCount>1 then
            begin
              //Sort(TopSort);
              for i:=0 to Pred(ControlCount) do
                if not IsLocked(Controls[i]) then
                  Controls[i].Top:=TControl(Items[0]).Top;
            end;
          amCenters:
            if ControlCount>1 then
            begin
              //Sort(TopSort);
              Val:=TControl(Items[0]).Top;
              //Sort(BottomSort);
              with TControl(Items[0]) do Val:=(Val+Top+Height) div 2;
              for i:=0 to Pred(ControlCount) do
                if not IsLocked(Controls[i]) then
                  with Controls[i] do Top:=Val-Height div 2;
            end;
          amRightBottom:
            if ControlCount>1 then
            begin
              //Sort(BottomSort);
              with TControl(Items[0]) do Val:=Top+Height;
              for i:=0 to Pred(ControlCount) do
                if not IsLocked(Controls[i]) then
                  with Controls[i] do Top:=Val-Height;
            end;
          amSpace:
            if Count>1 then
            begin
              //Sort(TopSort);
              Val:=(TControl(Items[Pred(Count)]).Top-TControl(Items[0]).Top) div Pred(Count);
              for i:=0 to Pred(Count) do
                TControl(Items[i]).Top:=TControl(Items[0]).Top+Val*i;
            end;
          amWindowCenter:
          begin
            Val:=Control.Parent.ClientHeight;
            Min:=MaxInt;
            Max:=-MaxInt;
            for i:=0 to Pred(ControlCount) do
              with Controls[i] do
              begin
                if Top<Min then Min:=Top;
                if Top+Height>Max then Max:=Top+Height;
              end;
            for i:=0 to Pred(ControlCount) do
              if not IsLocked(Controls[i]) then
                with Controls[i] do Top:=Top+(Val-Max+Min) div 2-Min;
          end;
        end;
      finally
        Free;
      end;
      {if ControlCount>1 then
        for i:=0 to Pred(ControlCount) do DrawMultiSelect(Controls[i])
      else
      begin
        Control.Invalidate;
        FGrabHandles.Update(False);
      end;
      Application.ProcessMessages;
      DoMoveSizeControl;
      NotifyChange('Align');}
    end;
  end;
end;

end.

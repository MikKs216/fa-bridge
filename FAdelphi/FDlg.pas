{ 20.3.2018 12:46:50 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 2700 - Nove AskDateClear  }
{ 8.11.2016 14:44:15 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 1617 - nove MemoKeyDown  }
{ 31.10.2016 10:48:04 (GMT+1:00) > [pinkava on WIN-48QDB6JAV23] checked in 1073 - nove AddMemo  }
{ 25.10.2006 10:27:30 (GMT+2:00) > [mik on PCMIK64] checked in   }
unit FDlg;

interface
uses Forms,Dialogs,Classes,Controls, Res_FA;

function AskInt(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: integer;
                ALeft: integer = -1; ATop: integer = -1): TModalResult;

function AskFloat(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: double;
                ALeft: integer = -1; ATop: integer = -1): TModalResult;

function AskStr(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: string;
                ALeft: integer = -1; ATop: integer = -1;
                ACorectionWidth: integer = -1): TModalResult;

function AskMemo(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: string;
                ALeft: integer = -1; ATop: integer = -1;
                ACorectionWidth: integer = -1): TModalResult;

function AskIntInt(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel1: string; var AValue1: integer;
                const ALabel2: string; var AValue2: integer;
                ALeft: integer = -1; ATop: integer = -1): TModalResult;

function AskDate(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: TDate;
                ALeft: Integer = -1; ATop: Integer = -1): TModalResult;
function AskDateClear(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: TDate;
                ALeft: Integer = -1; ATop: Integer = -1): TModalResult;

function AskDateDate(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel1: string; var AValue1: TDate;
                const ALabel2: string; var AValue2: TDate;
                ALeft: Integer = -1; ATop: Integer = -1): TModalResult;

implementation
uses
  StdCtrls,Windows,Buttons,Consts,SysUtils,Math,FCommonUtils, SpolFunkce;

type
  TfmAbsDialog = class (TForm)
  private
    FIdGen: integer;
    function GetId: string;
    procedure ButtonClick(Sender: TObject);
    procedure AlignInputPairs;
    procedure GetInputPairsArea(out AMaxWidth,AMaxHeight: integer);
    function AddInput(var ATop: integer; ACaption: string): TEdit;
    function AddMemo(var ATop: integer; ACaption: string): TMemo;
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    function AddIntInput(var ATop: integer;
                         ACaption: string; AValue: integer): TEdit;
    function AddFloatInput(var ATop: integer;
                           ACaption: string; AValue: double): TEdit;
    function AddStrInput(var ATop: integer;
                         ACaption: string; AValue: string): TEdit;
    function AddMemoInput(var ATop: integer;
                         ACaption: string; AValue: string): TMemo;
    function AddDateInput(var ATop: integer;
                          ACaption: string; AValue: TDate): TEdit;
    procedure AddButtons(AButtons: TMsgDlgButtons;
                         ADefaultBtn,ACancelBtn: TMsgDlgBtn);
    procedure Init(AActiveControl: TWinControl;
                   ALeft,ATop: integer;
                   ACorectionWidth: integer = 0);
  end;

  TfmAskValue = class (TfmAbsDialog)
  end;

const
  cTopM = 15;
  cBottomM = 8;
  cLeftM = 9;
  cRightM = 9;
  cBetweenButtonsW = 8;
  cBetweenEditsH = 8;
  cBetweenLabel2EditW = 8;
  cBetweenEdit2ButtonH = 15;

procedure TfmAbsDialog.ButtonClick(Sender: TObject);
begin
(*
  pro ladeni
  if Sender is TButton then
    ShowMessage('Left = '+IntToStr(TButton(Sender).Left)+#10+
                'Width = '+IntToStr(TButton(Sender).Width)+#10+
                'Form.Width = '+IntToStr(Self.Width)+#10+
                'Form.Left = '+IntToStr(Self.Left)
    );
  ModalResult:=mrNone;
*)
end;

function TfmAbsDialog.AddInput(var ATop: integer; ACaption: string): TEdit;
var lbl: TLabel;
begin
  Result:=TEdit.Create(Self);
  Result.Parent:=Self;
  Result.Name:='ed'+GetId;
  Result.Top:=ATop;
  
  if ACaption<>'' then begin
    lbl:=TLabel.Create(Self);
    lbl.Parent:=Self;
    lbl.FocusControl:=Result;
    lbl.Caption:=ACaption;
    lbl.Name:='la'+GetId;
    lbl.Top:=Result.Top+(Result.Height-lbl.Height)div 2;
  end;
  ATop:=ATop+Result.Height+cBetweenEditsH;
end;

procedure TfmAbsDialog.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  function FindDefaultButton: TButton;
  var
    i: Integer;
  begin
    Result := nil;

    for i := 0 to ComponentCount-1 do begin
      if (Components[i] is TButton) and ((Components[i] as TButton).Default=True) then begin
        Result := (Components[i] as TButton);
        Exit;
      end;
    end;
  end;
  
var
  dBtn: TButton;
begin
  inherited;
  if (Shift=[]) and (Key=Vk_Escape) then
    Close
  else if (Shift=[ssCtrl]) and (Key=VK_RETURN) then begin
    dBtn := FindDefaultButton;
    if dBtn<>nil then begin
      dBtn.OnClick(nil);
      Close;
      Self.ModalResult := mrOK;
    end;
  end;
end;

function TfmAbsDialog.AddMemo(var ATop: integer; ACaption: string): TMemo;
var
  lbl: TLabel;
begin
  Result:=TMemo.Create(Self);
  Result.Parent:=Self;
  Result.Name:='me'+GetId;
  Result.OnKeyDown := MemoKeyDown;

  if ACaption<>'' then begin
    Result.Top:=ATop+15;

    lbl:=TLabel.Create(Self);
    lbl.Parent:=Self;
    lbl.FocusControl:=Result;
    lbl.Caption:=ACaption;
    lbl.Name:='la'+GetId;
    lbl.Top:=ATop;
  end
  else
    Result.Top:=ATop+3;

  ATop:=ATop+Result.Height+cBetweenEditsH;
end;


function TfmAbsDialog.AddIntInput(var ATop: integer;
                                  ACaption: string; AValue: integer): TEdit;
begin
  Result:=AddInput(ATop,ACaption);
  Result.Text:=IntToStr(AValue);
end;

function TfmAbsDialog.AddFloatInput(var ATop: integer;
                                    ACaption: string; AValue: double): TEdit;
begin
  Result:=AddInput(ATop,ACaption);
  Result.Text:=FloatToStr(AValue);
end;


function TfmAbsDialog.AddStrInput(var ATop: integer;
                                  ACaption: string; AValue: string): TEdit;
begin
  Result:=AddInput(ATop,ACaption);
  Result.Text:=AValue;
end;

function TfmAbsDialog.AddMemoInput(var ATop: integer;
                                  ACaption: string; AValue: string): TMemo;
begin
  Result:=AddMemo(ATop,ACaption);
  Result.Text:=AValue;
end;

function TfmAbsDialog.AddDateInput(var ATop: integer;
                                   ACaption: string; AValue: TDate): TEdit;
begin
  Result:=AddInput(ATop,ACaption);
  Result.Text:=DateToStr(AValue);
end;

procedure TfmAbsDialog.AlignInputPairs;
var i: Integer;
    lbl: TLabel;
    ed: TEdit;
    me: TMemo;
    w, l: integer;
    labelExist: boolean;
begin
  w:=0;
  l := 0;
  labelExist := false;
  for i := 0 to ComponentCount-1 do
    if Components[i] is TLabel then begin
      w:=Max((Components[i] as TLabel).Width,w);
      l := (Components[i] as TLabel).Left;
      labelExist := true;
    end;
  w:=w+cLeftM;
  for i := 0 to ComponentCount-1 do
    if Components[i] is TLabel then begin
      lbl:=Components[i] as TLabel;
      lbl.Alignment:=taRightJustify;
      lbl.Left:=w-lbl.Width;
    end
    else if Components[i] is TEdit then begin
      ed:=Components[i] as TEdit;
      if labelExist then
        ed.Left:=w+cBetweenLabel2EditW
      else
        ed.Left:=w;
    end
    else if Components[i] is TMemo then begin
      me:=Components[i] as TMemo;
      me.Left:=l+cLeftM;//+cBetweenLabel2EditW;
      me.Width := Max(w, me.Width);
    end;
end;

procedure TfmAbsDialog.GetInputPairsArea(out AMaxWidth, AMaxHeight: integer);
var i: Integer;
    ed: TEdit;
    me: TMemo;
begin
  AlignInputPairs;
  AMaxWidth:=0;
  AMaxHeight:=0;
  for i := 0 to ComponentCount-1 do begin
    if Components[i] is TEdit then begin
      ed:=Components[i] as TEdit;
      AMaxWidth:=Max(ed.Left+ed.Width,AMaxWidth);
      AMaxHeight:=Max(ed.Top+ed.Height,AMaxHeight);
    end
    else if Components[i] is TMemo then begin
      me:=Components[i] as TMemo;
      AMaxWidth:=Max(me.Left+me.Width,AMaxWidth);
      AMaxHeight:=Max(me.Top+me.Height,AMaxHeight);
    end;
  end;
end;

procedure TfmAbsDialog.AddButtons(AButtons: TMsgDlgButtons;
                                  ADefaultBtn,ACancelBtn: TMsgDlgBtn);

  function AddButton(var ALeft: integer; ATop: integer;
                     AModalResult: TModalResult; ACaption: string;
                     ADefault,ACancel: boolean): TButton;
  begin
    Result:=TButton.Create(Self);
    Result.Left:=ALeft-Result.Width;
    Result.Top:=ATop;
    Result.Parent:=Self;
    Result.ModalResult:=AModalResult;
    Result.Caption:=ACaption;
    Result.Default:=ADefault;
    Result.Cancel:=ACancel;
    Result.OnClick:=ButtonClick;
    Result.Name:='bt'+GetId;
    Result.TabOrder:=0;
    ALeft:=Result.Left-cBetweenButtonsW;
    if ADefault then
      Self.ActiveControl:=Result;
  end;

var w,h: integer;
begin
  GetInputPairsArea(w,h);
  h:=h+cBetweenEdit2ButtonH;
  if mbHelp in AButtons then
    AddButton(w,h,mrNone,SHelpCz,mbHelp=ADefaultBtn,mbHelp=ACancelBtn);
  if mbYesToAll in AButtons then
    AddButton(w,h,mrYesToAll,SYesToAllCz,mbYesToAll=ADefaultBtn,mbYesToAll=ACancelBtn);
  if mbNoToAll in AButtons then
    AddButton(w,h,mrNoToAll,SNoToAllCz,mbNoToAll=ADefaultBtn,mbNoToAll=ACancelBtn);
  if mbAll in AButtons then
    AddButton(w,h,mrAll,SAllCz,mbAll=ADefaultBtn,mbAll=ACancelBtn);
  if mbAbort in AButtons then
    AddButton(w,h,mrAbort,SAbortCz,mbAbort=ADefaultBtn,mbAbort=ACancelBtn);
  if mbRetry in AButtons then
    AddButton(w,h,mrRetry,SRetryCz,mbRetry=ADefaultBtn,mbRetry=ACancelBtn);
  if mbCancel in AButtons then
    AddButton(w,h,mrCancel,SCancelCz,mbCancel=ADefaultBtn,mbCancel=ACancelBtn);
  if mbIgnore in AButtons then
    AddButton(w,h,mrIgnore,SIgnoreCz,mbIgnore=ADefaultBtn,mbIgnore=ACancelBtn);
  if mbOK in AButtons then
    AddButton(w,h,mrOK,SOKCz,mbOK=ADefaultBtn,mbOK=ACancelBtn);
  if mbNo in AButtons then
    AddButton(w,h,mrNo,SNoCz,mbNo=ADefaultBtn,mbNo=ACancelBtn);
  if mbYes in AButtons then
    AddButton(w,h,mrYes,SYesCz,mbYes=ADefaultBtn,mbYes=ACancelBtn);
end;


procedure TfmAbsDialog.Init(AActiveControl: TWinControl;
                   ALeft,ATop: integer;
                   ACorectionWidth: integer = 0);
var i: Integer;
    wc: TWinControl;
    bt: TButton;
    ed: TEdit;
    me: TMemo;
    minLeft: integer;
    w,h: integer;
begin
  w:=0;
  h:=0;
  for i := 0 to ComponentCount-1 do
    if Components[i] is TWinControl then begin
      wc:=Components[i] as TWinControl;
      w:=Max(wc.Left+wc.Width,w);
      h:=Max(wc.Top+wc.Height,h);
    end;
  ClientWidth:=w+cRightM;
  ClientHeight:=h+cBottomM;
  for i := 0 to ComponentCount-1 do
    if Components[i] is TButton then begin
      bt:=Components[i] as TButton;
      bt.Anchors:=[akBottom,akRight];
    end
    else if Components[i] is TEdit then begin
      ed:=Components[i] as TEdit;
      ed.Anchors:=[akLeft,akRight,akTop];
    end
    else if Components[i] is TMemo then begin
      me:=Components[i] as TMemo;
      me.Anchors:=[akLeft, akRight, akTop, akBottom];
    end;
  minLeft:=0;
  for i := 0 to ComponentCount-1 do
    if Components[i] is TButton then begin
      bt:=Components[i] as TButton;
      minLeft:=Min(bt.Left,minLeft);
    end;
  if minLeft>0 then begin
    if minLeft<cLeftM then
      ClientWidth:=ClientWidth+minLeft + ACorectionWidth
  end
  else
    ClientWidth:=ClientWidth-minLeft+cLeftM + ACorectionWidth;
  if ALeft=-1 then
    Left:=Application.MainForm.Left+(Application.MainForm.Width-Width) div 2
  else
    Left:=ALeft;
  if ATop=-1 then
    Top:=Application.MainForm.Top+(Application.MainForm.Height-Height) div 2
  else
    Top:=ATop;
  ActiveControl:=AActiveControl;
end;

function TfmAbsDialog.GetId: string;
begin
  Result:=IntToStr(FIdGen);
  INC(FIdGen);
end;

function AskInt(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: integer;
                ALeft: integer = -1; ATop: integer = -1): TModalResult;
var
  av: TfmAskValue;
  ed: TEdit;
  h: integer;
begin
  av:=TfmAskValue.CreateNew(nil);
  try
    av.Caption:=ACaption;
    h:=cTopM;
    ed:=av.AddIntInput(h,ALabel,AValue);
    av.AddButtons(AButtons,ADefaultBtn,ACancelBtn);
    av.Init(ed,ALeft,ATop);
    Result:=av.ShowModal;
    if IsInteger(ed.Text) then
      AValue:=StrToInt(ed.Text);
  finally
    av.Free;
  end;
end;

function AskFloat(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: double;
                ALeft: integer = -1; ATop: integer = -1): TModalResult;
var
  av: TfmAskValue;
  ed: TEdit;
  h: integer;
begin
  av:=TfmAskValue.CreateNew(nil);
  try
    av.Caption:=ACaption;
    h:=cTopM;
    ed:=av.AddFloatInput(h,ALabel,AValue);
    av.AddButtons(AButtons,ADefaultBtn,ACancelBtn);
    av.Init(ed,ALeft,ATop);
    Result:=av.ShowModal;
    if IsFloat(ed.Text) then
      AValue:=StrToFloat(ed.Text);
  finally
    av.Free;
  end;
end;

function AskStr(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: string;
                ALeft: integer = -1; ATop: integer = -1;
                ACorectionWidth: integer = -1): TModalResult;
var
  av: TfmAskValue;
  ed: TEdit;
  h: integer;
begin
  av:=TfmAskValue.CreateNew(nil);
  try
    av.Caption:=ACaption;
    h:=cTopM;
    ed:=av.AddStrInput(h,ALabel,AValue);
    av.AddButtons(AButtons,ADefaultBtn,ACancelBtn);
    av.Init(ed,ALeft, ATop, ACorectionWidth);


    Result:=av.ShowModal;
    AValue:=ed.Text;
  finally
    av.Free;
  end;
end;

function AskMemo(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: string;
                ALeft: integer = -1; ATop: integer = -1;
                ACorectionWidth: integer = -1): TModalResult;
var
  av: TfmAskValue;
  me: TMemo;
  h: integer;
begin
  av:=TfmAskValue.CreateNew(nil);
  try
    av.Caption:=ACaption;
    h:=cTopM;
    me := av.AddMemoInput(h,ALabel,AValue);
    av.AddButtons(AButtons,ADefaultBtn,ACancelBtn);
    av.Init(me, ALeft, ATop, ACorectionWidth);

    Result:=av.ShowModal;
    AValue:=me.Text;
  finally
    av.Free;
  end;
end;


function AskIntInt(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel1: string; var AValue1: integer;
                const ALabel2: string; var AValue2: integer;
                ALeft: integer = -1; ATop: integer = -1): TModalResult;
var
  av: TfmAskValue;
  ed1,ed2: TEdit;
  h: integer;
begin
  av:=TfmAskValue.CreateNew(nil);
  try
    av.Caption:=ACaption;
    h:=cTopM;
    ed1:=av.AddIntInput(h,ALabel1,AValue1);
    ed2:=av.AddIntInput(h,ALabel2,AValue2);
    av.AddButtons(AButtons,ADefaultBtn,ACancelBtn);
    av.Init(ed1,ALeft,ATop);
    Result:=av.ShowModal;
    if IsInteger(ed1.Text) then
      AValue1:=StrToInt(ed1.Text);
    if IsInteger(ed2.Text) then
      AValue2:=StrToInt(ed2.Text);
  finally
    av.Free;
  end;
end;

function AskDate(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: TDate;
                ALeft: Integer = -1; ATop: Integer = -1): TModalResult;
var
  av: TfmAskValue;
  ed: TEdit;
  h: Integer;
begin
  av:=TfmAskValue.CreateNew(nil);
  try
    av.Caption:=ACaption;
    h:=cTopM;
    ed:=av.AddDateInput(h,ALabel,AValue);
    av.AddButtons(AButtons,ADefaultBtn,ACancelBtn);
    av.Init(ed,ALeft,ATop);
    Result:=av.ShowModal;
    if IsDate(ed.Text) then
      AValue:=StrToDate(ed.Text);
  finally
    av.Free;
  end;
end;

function AskDateClear(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel: string; var AValue: TDate;
                ALeft: Integer = -1; ATop: Integer = -1): TModalResult;
var
  av: TfmAskValue;
  ed: TEdit;
  h: Integer;
  dateString: string;
begin
  av:=TfmAskValue.CreateNew(nil);
  try
    av.Caption:=ACaption;
    h:=cTopM;
    ed:=av.AddDateInput(h,ALabel,AValue);
    av.AddButtons(AButtons,ADefaultBtn,ACancelBtn);
    av.Init(ed,ALeft,ATop);
    Result:=av.ShowModal;
    dateString := ed.Text;
    if IsDate(ed.Text) then
      AValue:=StrToDate(ed.Text)
    else if CorrectDateString(dateString) and IsDate(dateString) then
      AValue:=StrToDate(dateString)
    else
      AValue:=0;
  finally
    av.Free;
  end;
end;

function AskDateDate(const ACaption: string;
                AButtons: TMsgDlgButtons; ADefaultBtn,ACancelBtn: TMsgDlgBtn;
                const ALabel1: string; var AValue1: TDate;
                const ALabel2: string; var AValue2: TDate;
                ALeft: Integer = -1; ATop: Integer = -1): TModalResult;
var
  av: TfmAskValue;
  ed1,ed2: TEdit;
  h: Integer;
  ok: boolean;
  d1, d2: string;
begin
  ok:=FALSE;
  av:=TfmAskValue.CreateNew(nil);
  try
    av.Caption:=ACaption;
    h:=cTopM;
    ed1:=av.AddDateInput(h,ALabel1,AValue1);
    ed2:=av.AddDateInput(h,ALabel2,AValue2);
    av.AddButtons(AButtons,ADefaultBtn,ACancelBtn);
    av.Init(ed1,ALeft,ATop);
    Result:=av.ShowModal;
    d1:=ed1.Text;
    d2:=ed2.Text;
    CorrectDateString(d1);
    CorrectDateString(d2);
    if IsDate(d1) then begin
      AValue1:=StrToDate(d1);
      ok:=TRUE;
    end;
    if IsDate(d2) then begin
      AValue2:=StrToDate(d2);
      ok:=TRUE;
    end;
    if not ok then
      MessageWarn('',sMsgNoCorrectDateString+' '+
        DateToStr(AValue1)+'..'+DateToStr(AValue2),[MBOK]);
  finally
    av.Free;
  end;
end;

end.


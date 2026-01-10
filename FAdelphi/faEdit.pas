unit faEdit;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, StdCtrls, DBCtrls, UxTheme, Themes, Forms, DwmApi;

const
  cDefaultBorderColor = clHighLight;//clWindowText;
  cDefaultBorderSize = 2;
  cDefaultColor = clWindow;
  cDefaultSelectedColor = clWindow;

type
  TFldType = (fldtString, fldtNumber, fldtCurrency, fldtDate);
  TNextDirection = (ndRight, ndDown);

  TfaEdit = class(TDBText)
  private
    FBorderColor: TColor;
    FSelectedColor: TColor;
    FBorderSize: Integer;
    FGrabDataLink: TFieldDataLink;
    FGrabDataLinkDataChange: TNotifyEvent;
    FFldType: TFldType;
    FFldTypeDecimalPlaces: integer;
    FFldLookup: string;
    FRepPage: integer;
    FRepPosX: integer;
    FRepPosY: integer;
    FRepLength: integer;
    FRepAlignment: TAlignment;
    FRepFontSize: integer;
    FNextDirection: TNextDirection;
    FNextField,
    FNextFieldBack: string;
    FDisplayFormat: string;
    FRestrictLength: boolean;
    FInvertAlignment: boolean;
    FHighlightList: boolean;
    FHighlightDefVal: boolean;
    FHlListRect : TRect;
    FHlDefValRect : TRect;
    FHlListColor: TColor;
    FHlDefValColor: TColor;
    FInterlaceCount: Integer;
    FInterlaceSize: Double;
    FInterlaceSizeRep: Double;
    FHideChar:string;
    FRepNoThousandSep: boolean;
    FRepHide: boolean;
    procedure DataChange(Sender: TObject);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderSize(const Value: Integer);
    procedure SetFldType(AFldType: TFldType);
  protected
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
    procedure DoDrawFrame;
    procedure Paint; override;
    procedure DoDrawTextEx (var Rect: TRect; Flags: Longint); dynamic;
    procedure DoDrawText_New(var Rect: TRect; Flags: Longint; Prokladat:boolean);
    function GetLabelText: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property HighlightListRect: TRect read FHlListRect;
    property HighlightDefvalRect: TRect read FHlDefValRect;
  published
    property BorderColor: TColor read FBorderColor write SetBorderColor default
      cDefaultBorderColor;
    property BorderSize: Integer read FBorderSize write SetBorderSize default
      cDefaultBorderSize;
    property Color default cDefaultColor;
    property ParentColor default False;
    property SelectedColor: TColor read FSelectedColor write FSelectedColor
      default cDefaultSelectedColor;
    property FldType: TFldType read FFldType write SetFldType default
      fldtString;
    property FldTypeDecimalPlaces: integer read FFldTypeDecimalPlaces write
      FFldTypeDecimalPlaces;
    property FldLookup: string read FFldLookup write FFldLookup;
    property RepPage: integer read FRepPage write FRepPage;
    property RepPosX: integer read FRepPosX write FRepPosX;
    property RepPosY: integer read FRepPosY write FRepPosY;
    property RepLength: integer read FRepLength write FRepLength;
    property RepAlignment: TAlignment read FRepAlignment write FRepAlignment;
    property RepFontSize: integer read FRepFontSize write FRepFontSize;
    property NextDirection: TNextDirection read FNextDirection write FNextDirection;
    property NextField: string read FNextField write FNextField;
    property NextFieldBack: string read FNextFieldBack write FNextFieldBack;
    property DisplayFormat: string read FDisplayFormat write FDisplayFormat;
    property RestrictLength: boolean read FRestrictLength write FRestrictLength;
    property InvertAlignment: boolean read FInvertAlignment write FInvertAlignment;
    property HighlightList: boolean read FHighlightList write FHighlightList;
    property HighlightDefVal: boolean read FHighlightDefVal write FHighlightDefVal;
    property HighlightListColor: TColor read FHlListColor write FHlListColor;
    property HighlightDefValColor: TColor read FHlDefValColor write FHlDefValColor;
    property InterlaceCount: Integer read FInterlaceCount write FInterlaceCount;
    property InterlaceSize: Double read FInterlaceSize write FInterlaceSize;
    property InterlaceSizeRep: Double read FInterlaceSizeRep write FInterlaceSizeRep;
    property HideChar: string read FHideChar write FHideChar;
    property RepNoThousandSep: boolean read FRepNoThousandSep write FRepNoThousandSep;
    property RepHide: boolean read FRepHide write FRepHide;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Labels', [TfaEdit]);
end;

{ TfaEdit }

constructor TfaEdit.Create(AOwner: TComponent);
begin
  inherited;
  FGrabDataLink := TFieldDataLink(Perform(CM_GETDATALINK, 0, 0));
  FGrabDataLinkDataChange := FGrabDataLink.OnDataChange;
  FGrabDataLink.OnDataChange := DataChange;
  FBorderColor := cDefaultBorderColor;
  FBorderSize := cDefaultBorderSize;
  FSelectedColor := cDefaultSelectedColor;
  ParentColor := False;
  Color := cDefaultColor;
  Transparent := FALSE;
  Height := 19;
  Width := 119;
  FHighlightList := FALSE;
  FHighlightDefVal := FALSE;
  FInterlaceCount := 0;
  FInterlaceSize := 0;
  FInterlaceSizeRep := 0;
end;

procedure TfaEdit.DataChange(Sender: TObject);
begin
  FGrabDataLinkDataChange(Sender);
  if FGrabDataLink.Field <> nil then
    Alignment := FGrabDataLink.Field.Alignment;
end;

destructor TfaEdit.Destroy;
begin
  FGrabDataLink.OnDataChange := FGrabDataLinkDataChange;
  FGrabDataLink := nil;
  inherited;
end;

procedure TfaEdit.DoDrawFrame;
begin
  Canvas.Brush.Color := FBorderColor;
  Canvas.Brush.Style := bsSolid;
  Canvas.FrameRect(ClientRect);
  //
  if FHighlightList then begin
    Canvas.Brush.Color := HighlightListColor;
    FHlListRect.Left:=ClientRect.Right-2;
    FHlListRect.Right:=ClientRect.Right-0;
    FHlListRect.Top:=ClientRect.Top+0;
    FHlListRect.Bottom:=ClientRect.Top+6;
    Canvas.FillRect(FHlListRect);
    FHlListRect.Left:=ClientRect.Right-6;
    FHlListRect.Right:=ClientRect.Right-0;
    FHlListRect.Top:=ClientRect.Top+0;
    FHlListRect.Bottom:=ClientRect.Top+2;
    Canvas.FillRect(FHlListRect);
    FHlListRect.Left:=ClientRect.Right-10;
    FHlListRect.Right:=ClientRect.Right-0;
    FHlListRect.Top:=ClientRect.Top+0;
    FHlListRect.Bottom:=ClientRect.Top+10;
  end;
  if FHighlightDefVal then begin
    Canvas.Brush.Color := HighlightDefValColor;
    FHlDefValRect.Left:=ClientRect.Right-2;
    FHlDefValRect.Right:=ClientRect.Right-0;
    FHlDefValRect.Top:=ClientRect.Bottom-6;
    FHlDefValRect.Bottom:=ClientRect.Bottom-0;
    Canvas.FillRect(FHlDefValRect);
    FHlDefValRect.Left:=ClientRect.Right-6;
    FHlDefValRect.Right:=ClientRect.Right-0;
    FHlDefValRect.Top:=ClientRect.Bottom-2;
    FHlDefValRect.Bottom:=ClientRect.Bottom-0;
    Canvas.FillRect(FHlDefValRect);
    FHlDefValRect.Left:=ClientRect.Right-10;
    FHlDefValRect.Right:=ClientRect.Right-1;
    FHlDefValRect.Top:=ClientRect.Bottom-10;
    FHlDefValRect.Bottom:=ClientRect.Bottom-1;
  end;
end;

procedure TfaEdit.DoDrawText_New(var Rect: TRect; Flags: Longint; Prokladat:boolean);

  procedure DoDrawThemeTextEx(DC: HDC; const Text: string;
    var TextRect: TRect; TextFlags: Cardinal);
  var
    Options: TDTTOpts;
  begin
    FillChar(Options, SizeOf(Options), 0);
    Options.dwSize := SizeOf(Options);
    Options.dwFlags := DTT_TEXTCOLOR or DTT_COMPOSITED;
    if TextFlags and DT_CALCRECT = DT_CALCRECT then
      Options.dwFlags := Options.dwFlags or DTT_CALCRECT;
    Options.crText := ColorToRGB(Canvas.Font.Color);

    with ThemeServices.GetElementDetails(teEditTextNormal) do
      DrawThemeTextEx(ThemeServices.Theme[teEdit], DC, Part, State,
        PWideChar(WideString(Text)), Length(WideString(Text)), TextFlags, @TextRect, Options);
  end;

  procedure DrawText(DC: HDC; const Text: string; TextLen: Integer;
    var TextRect: TRect; TextFlags: Cardinal);
  var
    LForm: TCustomForm;
    PaintOnGlass: Boolean;
    sirka:Integer;
    mezery: array of Integer;
    pmezery:PInteger;
    i:Integer;
    MyPoint:TPoint;
    mezeraSkutecna:Integer;  //Skutecna mezera
    pulitUp:Boolean;
    pulitDown:Boolean;
    poradi:Integer;
  begin
    PaintOnGlass := ThemeServices.ThemesEnabled and DwmCompositionEnabled and
      not (csDesigning in ComponentState);
    if PaintOnGlass then
    begin
      LForm := GetParentForm(Self);
      PaintOnGlass := (LForm <> nil) and LForm.GlassFrame.FrameExtended and
        LForm.GlassFrame.IntersectsControl(Self);
    end;
    if PaintOnGlass then
      DoDrawThemeTextEx(DC, Text, TextRect, TextFlags)
    else begin
       //Windows.DrawText(DC, PChar(Text), TextLen, TextRect, TextFlags);

       sirka := self.Canvas.TextWidth('W');
       pmezery:=nil;

       //InterlaceSize je to sirka mezery a sirka pismena !!!!!!


       if Prokladat and (TextLen>1) then begin
         pulitUp:=False;
         pulitDown:=False;

         if Frac(InterlaceSize)>0.5 then begin
           pulitUp:=True;
           Poradi:=Trunc(1/(1-Frac(InterlaceSize)));
         end;

         if (Frac(InterlaceSize)>0) and (Frac(InterlaceSize)<=0.5) then begin
           pulitDown:=True;
           if Trunc(TextLen*Frac(InterlaceSize))>0 then
             Poradi:=Trunc( TextLen / Trunc(TextLen*Frac(InterlaceSize)))
           else
             pulitDown:=False;
         end;

         SetLength(mezery, TextLen);
         for i:=0 to TextLen-1 do begin
           mezery[i]:= Trunc(InterlaceSize);

           if pulitDown and (((i+1) mod Poradi)=0) then
             mezery[i]:= Trunc(InterlaceSize)+1;

           if pulitUp then begin
             mezery[i]:= Trunc(InterlaceSize)+1;
             if ((i+1) mod poradi)=0 then
               mezery[i]:= Trunc(InterlaceSize);
           end;


         end;
         pmezery:=@mezery[0];
       end;

       if Self.Alignment=taRightJustify then begin
         Windows.SetTextAlign(DC,TA_RIGHT);
         //Windows.SetTextAlign(DC,TA_LEFT);
         if pmezery=nil then
           sirka:=0;
         Windows.ExtTextOut(DC,TextRect.Right+sirka,TextRect.Top,0,nil,PChar(Text),TextLen,pmezery);
       end
       else begin
         Windows.SetTextAlign(DC,TA_LEFT);
         Windows.ExtTextOut(DC,TextRect.Left,TextRect.Top,0,nil,PChar(Text),TextLen,pmezery);
       end;

    end;
  end;{DrawText}

const
  EllipsisStr = '...';
  Ellipsis: array[TEllipsisPosition] of Longint = (0, DT_PATH_ELLIPSIS,
    DT_END_ELLIPSIS, DT_WORD_ELLIPSIS);
var
  Text, DText: string;
  NewRect: TRect;
  Height, Delim: Integer;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and (Text[1] = '&') and (Text[2] = #0)) then
    Text := Text + ' ';

  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;

  Flags := DrawTextBiDiModeFlags(Flags);
  Canvas.Font := Font;

  if (EllipsisPosition <> epNone) and not AutoSize then begin
    DText := Text;
    Flags := Flags and not DT_EXPANDTABS;
    Flags := Flags or Ellipsis[EllipsisPosition];
    if WordWrap and (EllipsisPosition in [epEndEllipsis, epWordEllipsis]) then
    begin
      repeat
        NewRect := Rect;
        Dec(NewRect.Right, Canvas.TextWidth(EllipsisStr));
        Windows.DrawText(Canvas.Handle, PChar(DText), Length(DText), NewRect, Flags or DT_CALCRECT);
        Height := NewRect.Bottom - NewRect.Top;
        if (Height > ClientHeight) and (Height > Canvas.Font.Height) then
        begin
          Delim := LastDelimiter(' '#9, Text);
          if Delim = 0 then
            Delim := Length(Text);
          Dec(Delim);
          if ByteType(Text, Delim) = mbLeadByte then
            Dec(Delim);
          Text := Copy(Text, 1, Delim);
          DText := Text + EllipsisStr;
          if Text = '' then
            Break;
        end else
          Break;
      until False;
    end;
    if Text <> '' then
      Text := DText;
  end;

  if not Enabled then  begin
    OffsetRect(Rect, 1, 1);
    Canvas.Font.Color := clBtnHighlight;
    DrawText(Canvas.Handle, Text, Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    Canvas.Font.Color := clBtnShadow;
    DrawText(Canvas.Handle, Text, Length(Text), Rect, Flags);
  end else
    DrawText(Canvas.Handle, Text, Length(Text), Rect, Flags);

end;{DoDrawText_New}

//Kreslime si svuj text
procedure TfaEdit.DoDrawTextEx(var Rect: TRect; Flags: Integer);
var
  prokladat:Boolean;
  mezera:Integer;
begin
  prokladat:=False;
  //Pokud je zadfano prokladani a pocet znaku textu je mensi nebo rovno nez pocet kolonek tak aplikuj mezeru
  if (Self.InterlaceSize>0) and (Self.InterlaceCount>=Length(Self.Text)) and (Length(Self.Text)>1) then begin
    prokladat:=True;
    //pozice left se posune jeste o mezery mezi znaky
    if Self.Alignment = taRightJustify then begin

       //mezera:=(Length(GetLabelText)-1)*InterlaceSize;
       //Rect.Left := Rect.Left - mezera;
    end;
  end;

  DoDrawText_New(Rect, Flags, prokladat);
  //inherited DoDrawText(Rect,Flags);

end; {DoDrawTextEx}

procedure TfaEdit.DoDrawText(var Rect: TRect; Flags: Integer);
var
  R: TRect;
  mapMode:Integer;
begin
  //mapMode:=GetMapMode(Canvas.Handle);
  if Flags and DT_CALCRECT <> 0 then begin
    DoDrawTextEx(Rect, Flags);
    Inc(Rect.Right, FBorderSize * 2);
    Inc(Rect.Bottom, FBorderSize * 2);
  end
  else  begin
    R := Rect;
    InflateRect(R, -FBorderSize, -FBorderSize);
    // Simulate TDBEdit right align position calculation
    if Flags and DT_RIGHT <> 0 then begin
      Flags := Flags and (not DT_RIGHT) or DT_LEFT;
      Canvas.Font := Font;
      //R.Left := R.Right - Canvas.TextWidth(GetLabelText) - FBorderSize + 1;
    end;

    DoDrawTextEx(R, Flags);
  end;
end;{DoDrawText}

procedure TfaEdit.Paint;
begin
  inherited;
  DoDrawFrame;
end;

procedure TfaEdit.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TfaEdit.SetBorderSize(const Value: Integer);
begin
  if FBorderSize <> Value then
  begin
    FBorderSize := Value;
    AdjustBounds;
    Invalidate;
  end;
end;

procedure TfaEdit.SetFldType(AFldType: TFldType);
begin
  FFldType := AFldType;
  case AFldType of
    fldtString, fldtDate: begin
      Alignment := taLeftJustify;
      RepAlignment := taLeftJustify;
    end;
    fldtNumber: begin
      Alignment := taRightJustify;
      RepAlignment := taRightJustify;
    end;
  end;
end;

function TfaEdit.GetLabelText: string;
var i: integer;
  s: string;
begin
  Result:= inherited GetLabelText;
  if FHideChar<>'' then begin
    s:=Result;
    Result:='';
    for i:=1 to Length(s) do begin
      if s[i]=FHideChar then
        Result:=Result+' '
      else
        Result:=Result+s[i];
    end;
  end;
end;

end.


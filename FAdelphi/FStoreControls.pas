{ 3.9.2003 19:28:49 (GMT+2:00) > [mik on PCMIKHOME] checked in   }
//Modul pro prevod formularu ze stareho programu
// upravene pro delphi 5 a Stereo
{$IFDEF VER130} //bude definovano pri prekladu z deplhi 5
  {$DEFINE FORSAVE}
{$ENDIF}

unit FStoreControls;

interface

uses
  Classes, SysUtils, Controls, StdCtrls, ExtCtrls, Graphics;

type
  EStoreCompError = class(Exception);

{$IFDEF FORSAVE}
function SaveComponentToString(AC: TComponent;ATransformLabel: boolean): string;
procedure AddComponentToStringList(AC: TComponent; var ASl: TStringList;ATransformLabel: boolean);
function SaveUsedComponentsToString(AC:TWinControl;ATransformLabel: boolean): string;
procedure SaveUsedComponentsToClipboard(AC:TWinControl;ATransformLabel: boolean=FALSE);
{$ELSE}
function CreateComponentFromString(const AStr: string; AOwner: TComponent;
                                   AParent: TWinControl): TComponent;
procedure CreateNewComponentsFromString(const AStr: string; AOwner: TComponent;
                                        AParent: TWinControl);
{$ENDIF}

function AlignmentToStr(AAlignment: TAlignment): string;
function StrToAlignment(const AStr: string): TAlignment;

{$IFDEF FORSAVE}
function EditToStr(AC: TComponent): string;
{$ELSE}
function CreateEditFromStr(const ASlDef: TStringList; AOwner: TComponent;
                           AParent: TWinControl): TComponent;
{$ENDIF}

{$IFDEF FORSAVE}
function CheckBoxToStr(AC: TComponent): string;
{$ELSE}
function CreateCheckBoxFromStr(const ASlDef: TStringList; AOwner: TComponent;
                               AParent: TWinControl): TComponent;
{$ENDIF}

{$IFDEF FORSAVE}
function LabelToStr(AC: TComponent; ATransformLabel: boolean): string;
{$ELSE}
function CreateLabelFromStr(const ASlDef: TStringList; AOwner: TComponent;
                            AParent: TWinControl): TComponent;
{$ENDIF}

{$IFDEF FORSAVE}
function ShapeToStr(AC: TComponent): string;
{$ELSE}
function CreateShapeFromStr(const ASlDef: TStringList; AOwner: TComponent;
                            AParent: TWinControl): TComponent;
{$ENDIF}

implementation

uses
  Forms, Clipbrd, JclGraphUtils
  {$IFDEF FORSAVE}
  , FStdCtrls, Windows, FSysUtils
  {$ELSE}
  ,faEdit, cxDBCheckBoxEx, psvBorderLabel, psvWebLabel, FCommonUtils, FUtils
  {$ENDIF}
  ;

const
  cDefaultBorderColor='clHighlight';

  cFaFormDefID='@FAFORMDEFINITION@';

  cFaNewTypeID='[COMPONENT]';

  cTypeEdit='Edit';
  cTypeCheckBox='CheckBox';
  cTypeLabel='Label';
  cTypeBorderLabel='BorderLabel';
  cTypeWebLabel='WebLabel';
  cTypeShape='Shape';

  cType='Type';
  cName='Name';
  cLeft='Left';
  cTop='Top';
  cWidth='Width';
  cHeight='Height';
  cVisible='Visible';
  cColor='Color';
  cBorderColor='BorderColor';
  cSelectedColor='SelectedColor';
  cBrushColor='BrushColor';
  cPenColor='PenColor';
  cFldType='FldType';
  cFldTypeDecimalPlaces='FldTypeDecimalPlaces';
  cTabOrder='TabOrder';
  cTabStop='TabStop';
  cCaption='Caption';
  cAlignment='Alignment';
  cAutoSize='AutoSize';
  cMultiLine='MultiLine';
  cScrollBars='ScrollBars';
  cWordWrap='WordWrap';
  cFontColor='FontColor';
  cSize='Size';
  cStyle='Style';
  cTransparent='Transparent';
  cParentColor='ParentColor';
  cFontSize='FontSize';
  cFontStyle='FontStyle';
  cFontName='FontName';
  cValueType='ValueType';
  cDisplayFormat='DisplayFormat';
  cBrushStyle='BrushStyle';

  cEvtText='EvtText';
  cEvtFloat='EvtFloat';
  cEvtDate='EvtDate';

  cbsClear='BsClear';
  cbsSolid='BsSolid';

  cfsBold='fsBold';
  cfsItalic='fsItalic';
  cfsUnderline='fsUnderline';
  cfsStrikeOut='fsStrikeOut';

  cDefaultFontName='MS Sans Serif';

  cProperties='Properties';
  cFont='Font';

  cFldtString='cFldtString';
  cFldtNumber='cFldtNumber';
  cFldtDate='cFldtDate';

  cLeftJustify='cLeftJustify';
  cRightJustify='cRightJustify';
  cCenter='cCenter';

  cNone='cNone';
  cHorizontal='cHorizontal';
  cVertical='cVertical';
  cBoth='cBoth';

  cBold='cBold';
  cItalic='cItalic';
  cUnderline='cUnderline';
  cStrikeOut='cStrikeOut';

///////////////////////////////////////////////////////////////////////

const
  cclNone = 'clNone';
  cclScrollBar = 'clScrollBar';
  cclAqua = 'clAqua';
  cclBackground = 'clBackground';
  cclBlack = 'clBlack';
  cclActiveCaption = 'clActiveCaption';
  cclBlue = 'clBlue';
  cclInactiveCaption = 'clInactiveCaption';
  cclCream = 'clCream';
  cclMenu = 'clMenu';
  cclDkGray = 'clDkGray';
  cclWindow = 'clWindow';
  cclFuchsia = 'clFuchsia';
  cclWindowFrame = 'clWindowFrame';
  cclGray = 'clGray';
  cclMenuText = 'clMenuText';
  cclGreen = 'clGreen';
  cclWindowText = 'clWindowText';
  cclLime = 'clLime';
  cclCaptionText = 'clCaptionText';
  cclLtGray = 'clLtGray';
  cclActiveBorder = 'clActiveBorder';
  cclMaroon = 'clMaroon';
  cclInactiveBorder = 'clInactiveBorder';
  cclMedGray = 'clMedGray';
  cclAppWorkSpace = 'clAppWorkSpace';
  cclMoneyGreen = 'clMoneyGreen';
  cclHighlight = 'clHighlight';
  cclNavy = 'clNavy';
  cclHighLightText = 'clHighlightText';
  cclOlive = 'clOlive';
  cclBtnFace = 'clBtnFace';
  cclPurple = 'clPurple';
  cclBtnShadow = 'clBtnShadow';
  cclRed = 'clRed';
  cclGrayText = 'clGrayText';
  cclSilver = 'clSilver';
  cclBtnText = 'clBtnText';
  cclSkyBlue = 'clSkyBlue';
  cclInactiveCaptionText = 'clInactiveCaptionText';
  cclTeal = 'clTeal';
  cclBtnHighlight = 'clBtnHighlight';
  cclWhite = 'clWhite';
  ccl3DDkShadow = 'cl3DDkShadow';
  cclYellow = 'clYellow';
  ccl3DLight = 'cl3DLight';
  cclInfoText = 'clInfoText';
  cclInfoBk = 'clInfoBk';
  cclGradientActiveCaption = 'clGradientActiveCaption';
  cclGradientInactiveCaption = 'clGradientInactiveCaption';
  cclDefault = 'clDefault';

{$IFDEF VER130}
function BoolToStr(B: Boolean): string;
const
  cSimpleBoolStrs: array [boolean] of String = ('0', '-1');
begin
  Result := cSimpleBoolStrs[B];
end;

function StrToBool(const S: string): boolean;
begin
  Result := S='0';
end;
{$ENDIF}

function IsValidStrLogicColor(const AStr: string): boolean;
begin
  Result := (AStr = cclNone) or
    (AStr = cclScrollBar) or
    (AStr = cclAqua) or
    (AStr = cclBackground) or
    (AStr = cclBlack) or
    (AStr = cclActiveCaption) or
    (AStr = cclBlue) or
    (AStr = cclInactiveCaption) or
    (AStr = cclCream) or
    (AStr = cclMenu) or
    (AStr = cclDkGray) or
    (AStr = cclWindow) or
    (AStr = cclFuchsia) or
    (AStr = cclWindowFrame) or
    (AStr = cclGray) or
    (AStr = cclMenuText) or
    (AStr = cclGreen) or
    (AStr = cclWindowText) or
    (AStr = cclLime) or
    (AStr = cclCaptionText) or
    (AStr = cclLtGray) or
    (AStr = cclActiveBorder) or
    (AStr = cclMaroon) or
    (AStr = cclInactiveBorder) or
    (AStr = cclMedGray) or
    (AStr = cclAppWorkSpace) or
    (AStr = cclMoneyGreen) or
    (AStr = cclHighlight) or
    (AStr = cclNavy) or
    (AStr = cclHighlightText) or
    (AStr = cclOlive) or
    (AStr = cclBtnFace) or
    (AStr = cclPurple) or
    (AStr = cclBtnShadow) or
    (AStr = cclRed) or
    (AStr = cclGrayText) or
    (AStr = cclSilver) or
    (AStr = cclBtnText) or
    (AStr = cclSkyBlue) or
    (AStr = cclInactiveCaptionText) or
    (AStr = cclTeal) or
    (AStr = cclBtnHighlight) or
    (AStr = cclWhite) or
    (AStr = ccl3DDkShadow) or
    (AStr = cclYellow) or
    (AStr = ccl3DLight) or
    (AStr = cclInfoText) or
    (AStr = cclInfoBk) or
    (AStr = cclGradientActiveCaption) or
    (AStr = cclGradientInactiveCaption) or
    (AStr = cclDefault);
end; {IsValidStrLogicColor}

function IsLogicColor(AColor: TColor): boolean;
begin
  Result := (AColor = clNone) or
    (AColor = clScrollBar) or
    (AColor = clAqua) or
    (AColor = clBackground) or
    (AColor = clBlack) or
    (AColor = clActiveCaption) or
    (AColor = clBlue) or
    (AColor = clInactiveCaption) or
    {$IFNDEF VER130}(AColor = clCream) or{$ENDIF}
    (AColor = clMenu) or
    (AColor = clDkGray) or
    (AColor = clWindow) or
    (AColor = clFuchsia) or
    (AColor = clWindowFrame) or
    (AColor = clGray) or
    (AColor = clMenuText) or
    (AColor = clGreen) or
    (AColor = clWindowText) or
    (AColor = clLime) or
    (AColor = clCaptionText) or
    (AColor = clLtGray) or
    (AColor = clActiveBorder) or
    (AColor = clMaroon) or
    (AColor = clInactiveBorder) or
    {$IFNDEF VER130}(AColor = clMedGray) or{$ENDIF}
    (AColor = clAppWorkSpace) or
    {$IFNDEF VER130}(AColor = clMoneyGreen) or{$ENDIF}
    (AColor = clHighlight) or
    (AColor = clNavy) or
    (AColor = clHighlightText) or
    (AColor = clOlive) or
    (AColor = clBtnFace) or
    (AColor = clPurple) or
    (AColor = clBtnShadow) or
    (AColor = clRed) or
    (AColor = clGrayText) or
    (AColor = clSilver) or
    (AColor = clBtnText) or
    {$IFNDEF VER130}(AColor = clSkyBlue) or{$ENDIF}
    (AColor = clInactiveCaptionText) or
    (AColor = clTeal) or
    (AColor = clBtnHighlight) or
    (AColor = clWhite) or
    (AColor = cl3DDkShadow) or
    (AColor = clYellow) or
    (AColor = cl3DLight) or
    (AColor = clInfoText) or
    (AColor = clInfoBk) or
    {$IFNDEF VER130}(AColor = clGradientActiveCaption) or{$ENDIF}
    {$IFNDEF VER130}(AColor = clGradientInactiveCaption) or{$ENDIF}
    (AColor = clDefault);
end; {IsLogicColor}

function IntToHexStr(AValue: integer): string;
begin
  Result := Format('%x', [AValue]);
end; {IntToHexStr}

function HexStrToInt(AValue: string): integer;
begin
  Result := StrToInt('$' + AValue)
end; {HexStrToInt}

//prevede barvu na

function ColorToHexStr(AColor: TColor): string;
var
  red, green, blue, flag: Byte;
  function TwoDigits(const AStr: string): string;
  begin
    if Length(AStr) = 1 then
      Result := '0' + AStr
    else
      Result := AStr;
  end;
begin
  GetRGBValue(AColor, red, green, blue);
  flag := GetColorFlag(AColor);
  Result := '$' + TwoDigits(IntToHexStr(flag)) + TwoDigits(IntToHexStr(blue)) +
    TwoDigits(IntToHexStr(green)) + TwoDigits(IntToHexStr(red));
end; {ColorToHexStr}

function HexStrToColor(const AStr: string): TColor;
begin
  Result := SetRGBValue(HexStrToInt(Copy(AStr, 8, 2)), HexStrToInt(Copy(AStr, 6,
    2)),
    HexStrToInt(Copy(AStr, 4, 2)));
  Result := SetColorFlag(Result, HexStrToInt(Copy(AStr, 2, 2)));
end; {HexStrToColor}

function IsValidHexStrColor(const AStr: string): boolean;
var
  i: integer;
  function IsHexDigit(AChar: char): boolean;
  begin
    case AChar of
      '0'..'9', 'A'..'F': Result := TRUE;
    else
      Result := FALSE;
    end;
  end;
begin
  Result := Length(AStr) = 9;
  if Result then
    Result := Copy(AStr, 1, 1) = '$';
  if Result then
    for i := 2 to 9 do
      if not IsHexDigit(AStr[i]) then begin
        Result := FALSE;
        BREAK;
      end;
end; {IsValidHexStrColor}

function LogicColorToStr(AColor: TColor): string;
begin
  if AColor = clNone then
    Result := cclNone
  else if AColor = clScrollBar then
    Result := cclScrollBar
  else if AColor = clAqua then
    Result := cclAqua
  else if AColor = clBackground then
    Result := cclBackground
  else if AColor = clBlack then
    Result := cclBlack
  else if AColor = clActiveCaption then
    Result := cclActiveCaption
  else if AColor = clBlue then
    Result := cclBlue
  else if AColor = clInactiveCaption then
    Result := cclInactiveCaption
  {$IFNDEF VER130}else if AColor = clCream then
    Result := cclCream{$ENDIF}
  else if AColor = clMenu then
    Result := cclMenu
  else if AColor = clDkGray then
    Result := cclDkGray
  else if AColor = clWindow then
    Result := cclWindow
  else if AColor = clFuchsia then
    Result := cclFuchsia
  else if AColor = clWindowFrame then
    Result := cclWindowFrame
  else if AColor = clGray then
    Result := cclGray
  else if AColor = clMenuText then
    Result := cclMenuText
  else if AColor = clGreen then
    Result := cclGreen
  else if AColor = clWindowText then
    Result := cclWindowText
  else if AColor = clLime then
    Result := cclLime
  else if AColor = clCaptionText then
    Result := cclCaptionText
  else if AColor = clLtGray then
    Result := cclLtGray
  else if AColor = clActiveBorder then
    Result := cclActiveBorder
  else if AColor = clMaroon then
    Result := cclMaroon
  else if AColor = clInactiveBorder then
    Result := cclInactiveBorder
  {$IFNDEF VER130}else if AColor = clMedGray then
    Result := cclMedGray{$ENDIF}
  else if AColor = clAppWorkSpace then
    Result := cclAppWorkSpace
  {$IFNDEF VER130}else if AColor = clMoneyGreen then
    Result := cclMoneyGreen{$ENDIF}
  else if AColor = clHighlight then
    Result := cclHighlight
  else if AColor = clNavy then
    Result := cclNavy
  else if AColor = clHighlightText then
    Result := cclHighlightText
  else if AColor = clOlive then
    Result := cclOlive
  else if AColor = clBtnFace then
    Result := cclBtnFace
  else if AColor = clPurple then
    Result := cclPurple
  else if AColor = clBtnShadow then
    Result := cclBtnShadow
  else if AColor = clRed then
    Result := cclRed
  else if AColor = clGrayText then
    Result := cclGrayText
  else if AColor = clSilver then
    Result := cclSilver
  else if AColor = clBtnText then
    Result := cclBtnText
  {$IFNDEF VER130}else if AColor = clSkyBlue then
    Result := cclSkyBlue{$ENDIF}
  else if AColor = clInactiveCaptionText then
    Result := cclInactiveCaptionText
  else if AColor = clTeal then
    Result := cclTeal
  else if AColor = clBtnHighlight then
    Result := cclBtnHighlight
  else if AColor = clWhite then
    Result := cclWhite
  else if AColor = cl3DDkShadow then
    Result := ccl3DDkShadow
  else if AColor = clYellow then
    Result := cclYellow
  else if AColor = cl3DLight then
    Result := ccl3DLight
  else if AColor = clInfoText then
    Result := cclInfoText
  else if AColor = clInfoBk then
    Result := cclInfoBk
  {$IFNDEF VER130}else if AColor = clGradientActiveCaption then
    Result := cclGradientActiveCaption{$ENDIF}
  {$IFNDEF VER130}else if AColor = clGradientInactiveCaption then
    Result := cclGradientInactiveCaption{$ENDIF}
  else if AColor = clDefault then
    Result := cclDefault
  else
    Result := '';
end; {LogicColorToStr}

function StrToLogicColor(const AStr: string): TColor;
begin
  if AStr = cclNone then
    Result := clNone
  else if AStr = cclScrollBar then
    Result := clScrollBar
  else if AStr = cclAqua then
    Result := clAqua
  else if AStr = cclBackground then
    Result := clBackground
  else if AStr = cclBlack then
    Result := clBlack
  else if AStr = cclActiveCaption then
    Result := clActiveCaption
  else if AStr = cclBlue then
    Result := clBlue
  else if AStr = cclInactiveCaption then
    Result := clInactiveCaption
  {$IFNDEF VER130}else if AStr = cclCream then
    Result := clCream{$ENDIF}
  else if AStr = cclMenu then
    Result := clMenu
  else if AStr = cclDkGray then
    Result := clDkGray
  else if AStr = cclWindow then
    Result := clWindow
  else if AStr = cclFuchsia then
    Result := clFuchsia
  else if AStr = cclWindowFrame then
    Result := clWindowFrame
  else if AStr = cclGray then
    Result := clGray
  else if AStr = cclMenuText then
    Result := clMenuText
  else if AStr = cclGreen then
    Result := clGreen
  else if AStr = cclWindowText then
    Result := clWindowText
  else if AStr = cclLime then
    Result := clLime
  else if AStr = cclCaptionText then
    Result := clCaptionText
  else if AStr = cclLtGray then
    Result := clLtGray
  else if AStr = cclActiveBorder then
    Result := clActiveBorder
  else if AStr = cclMaroon then
    Result := clMaroon
  else if AStr = cclInactiveBorder then
    Result := clInactiveBorder
  {$IFNDEF VER130}else if AStr = cclMedGray then
    Result := clMedGray{$ENDIF}
  else if AStr = cclAppWorkSpace then
    Result := clAppWorkSpace
  {$IFNDEF VER130}else if AStr = cclMoneyGreen then
    Result := clMoneyGreen{$ENDIF}
  else if AStr = cclHighlight then
    Result := clHighlight
  else if AStr = cclNavy then
    Result := clNavy
  else if AStr = cclHighlightText then
    Result := clHighlightText
  else if AStr = cclOlive then
    Result := clOlive
  else if AStr = cclBtnFace then
    Result := clBtnFace
  else if AStr = cclPurple then
    Result := clPurple
  else if AStr = cclBtnShadow then
    Result := clBtnShadow
  else if AStr = cclRed then
    Result := clRed
  else if AStr = cclGrayText then
    Result := clGrayText
  else if AStr = cclSilver then
    Result := clSilver
  else if AStr = cclBtnText then
    Result := clBtnText
  {$IFNDEF VER130}else if AStr = cclSkyBlue then
    Result := clSkyBlue{$ENDIF}
  else if AStr = cclInactiveCaptionText then
    Result := clInactiveCaptionText
  else if AStr = cclTeal then
    Result := clTeal
  else if AStr = cclBtnHighlight then
    Result := clBtnHighlight
  else if AStr = cclWhite then
    Result := clWhite
  else if AStr = ccl3DDkShadow then
    Result := cl3DDkShadow
  else if AStr = cclYellow then
    Result := clYellow
  else if AStr = ccl3DLight then
    Result := cl3DLight
  else if AStr = cclInfoText then
    Result := clInfoText
  else if AStr = cclInfoBk then
    Result := clInfoBk
  {$IFNDEF VER130}else if AStr = cclGradientActiveCaption then
    Result := clGradientActiveCaption{$ENDIF}
  {$IFNDEF VER130}else if AStr = cclGradientInactiveCaption then
    Result := clGradientInactiveCaption{$ENDIF}
  else if AStr = cclDefault then
    Result := clDefault
  else
    Result := clNone;
end; {StrToLogicColor}

function ColorToStr(AColor: TColor): string;
begin
  if IsLogicColor(AColor) then
    Result := LogicColorToStr(AColor)
  else
    Result := ColorToHexStr(AColor);
end; {ColorToStr}

function StrToColor(const AStr: string): TColor;
begin
  if IsValidStrLogicColor(AStr) then
    Result := StrToLogicColor(AStr)
  else if IsValidHexStrColor(AStr) then
    Result := HexStrToColor(AStr)
  else
    Result := clNone;
end; {StrToColor}

function BrushStyleToStr(ABrushStyle: TBrushStyle): string;
begin
  if ABrushStyle=bsClear then
    Result:=cbsClear
  else
    Result:=cbsSolid;
end; {BrushStyleToStr}

function StrToBrushStyle(const AStr: string): TBrushStyle;
begin
  if AStr=cbsClear then
    Result:=bsClear
  else
    Result:=bsSolid;
end; {StrToBrushStyle}

function MemoStrToStr(const AStr: string): string;
begin
{$IFDEF FORSAVE}
  Result:=Replace(#10,Replace(#13,AStr,'$cr$'),'$lf$');;
{$ELSE}
  Result:=AStr;
{$ENDIF}
end; {MemoStrToStr}

function StrToMemoStr(const AStr: string): string;
begin
{$IFNDEF FORSAVE}
  Result:=Replace('$lf$',Replace('$cr$',AStr,#13),#10);
{$ELSE}
  Result:=AStr;
{$ENDIF}
end; {StrToMemoStr}

///////////////////////////////////////////////////////////////////////////////
//Component
///////////////////////////////////////////////////////////////////////////////

{$IFDEF FORSAVE}
function SaveComponentToString(AC: TComponent; ATransformLabel: boolean): string;
begin
  if AC is TEdit then
    Result:=EditToStr(AC)
  else if AC is TCheckBox then
    Result:=CheckBoxToStr(AC)
  else if AC is TLabel then
    Result:=LabelToStr(AC,ATransformLabel)
  else if AC is TShape then
    Result:=ShapeToStr(AC);
end; {SaveComponentToString}

procedure AddComponentToStringList(AC: TComponent; var ASl: TStringList;ATransformLabel: boolean);
var
  sl: TStringList;
  s: string;
begin
  sl:= TStringList.Create;
  try
    s:=SaveComponentToString(AC,ATransformLabel);
    if s<>'' then begin
      sl.Add(cFaNewTypeID);
      sl.Add(s);
      ASl.AddStrings(sl);
    end;
  finally
    sl.Free;
  end;
end; {AddComponentToStringList}

function SaveUsedComponentsToString(AC:TWinControl;ATransformLabel: boolean): string;
var
  c: TComponent;
  sl: TStringList;
  i: integer;
begin
  sl:= TStringList.Create;
  try
    sl.Add(cFaFormDefID);
    for i := 0 to AC.ControlCount - 1 do begin
      c := AC.Controls[i];
      AddComponentToStringList(c,sl,ATransformLabel);
    end;
      //sl.SaveToFile('c:\a.txt');
      Result:=sl.Text;
  finally
    sl.Free;
  end;
end; {SaveComponentsToString}

procedure SaveUsedComponentsToClipboard(AC:TWinControl;ATransformLabel: boolean = FALSE);
var
 sl: TstringList;
begin
  sl:= TstringList.Create;
  try
    sl.Text:=SaveUsedComponentsToString(AC,ATransformLabel);
    if sl.Count>2 then begin
      ClipBoard.Open;
      ClipBoard.AsText:=sl.Text;
      ClipBoard.Close;
    end
    else
      MessageWarn('',
        'Není žádná komponenta k uložení. Patrnì je aktivní jiná èást formuláøe. Vyberte údaj formuláøe.',
        [MBOK]);
  finally
    sl.Free;
  end;
end; {SaveUsedComponentsToClipboard}

{$ELSE}
function CreateComponentFromString(const AStr: string; AOwner: TComponent;
                                   AParent: TWinControl): TComponent;
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Text:=AStr;
    if sl.Values[cType]=cTypeEdit then
      Result:=CreateEditFromStr(sl,AOwner,AParent)
    else if sl.Values[cType]=cTypeCheckBox then
      Result:=CreateCheckBoxFromStr(sl,AOwner,AParent)
    else if (sl.Values[cType]=cTypeLabel) or
            (sl.Values[cType]=cTypeBorderLabel)or
            (sl.Values[cType]=cTypeWebLabel) then
      Result:=CreateLabelFromStr(sl,AOwner,AParent)
    else if sl.Values[cType]=cTypeShape then
      Result:=CreateShapeFromStr(sl,AOwner,AParent)
    else
      Result:=nil;
  finally
    sl.Free;
  end;
end; {CreateComponentFromString}

procedure CreateNewComponentsFromString(const AStr: string; AOwner: TComponent;
                                        AParent: TWinControl);
var
  sl, sla: TstringList;
  i: integer;
begin
  sl:= TstringList.Create;
  sla:= TstringList.Create;
  StartWait;
  try
    sl.Text:=AStr;
    if sl[0]=cFaFormDefID then begin
      for i:=2 to sl.Count-1 do begin
        if (sl[i]=cFaNewTypeID)or(i=sl.Count-1) then begin
          CreateComponentFromString(sla.Text, AOwner, AParent);
          sla.Clear;
        end
        else
          sla.Add(sl[i]);
      end;
    end;
  finally
    sl.Free;
    sla.Free;
    StopWait;
  end;
end; {CreateNewComponentsFromString}

{$ENDIF}

///////////////////////////////////////////////////////////////////////////////
//Alignment
///////////////////////////////////////////////////////////////////////////////

function AlignmentToStr(AAlignment: TAlignment): string;
begin
  case AAlignment of
    taLeftJustify: Result:=cLeftJustify;
    taRightJustify: Result:=cRightJustify;
    taCenter: Result:=cCenter;
  end;
end; {AlignmentToStr}

function StrToAlignment(const AStr: string): TAlignment;
begin
  if AStr=cLeftJustify then
    Result:=taLeftJustify
  else if AStr=cRightJustify then
    Result:=taRightJustify
  else if AStr=cCenter then
    Result:=taCenter
  else
    Result:=taLeftJustify;
end; {StrToAlignment}

///////////////////////////////////////////////////////////////////////////////
//FontStyle
///////////////////////////////////////////////////////////////////////////////

function FontStylesToStr(AFontStyles: TFontStyles): string;
begin
  Result:='';
  if fsBold in AFontStyles then
    Result:=Result+cBold+',';
  if fsItalic in AFontStyles then
    Result:=Result+cItalic+',';
  if fsUnderline in AFontStyles then
    Result:=Result+cUnderline+',';
  if fsStrikeOut in AFontStyles then
    Result:=Result+cStrikeOut;
end; {FontStylesToStr}

function StrToFontStyles(const AStr: string): TFontStyles;
begin
  Result:=[];
  if Pos(cBold,AStr)>0 then
    Result:=Result+[fsBold];
  if Pos(cItalic,AStr)>0 then
    Result:=Result+[fsItalic];
  if Pos(cUnderline,AStr)>0 then
    Result:=Result+[fsUnderline];
  if Pos(cStrikeOut,AStr)>0 then
    Result:=Result+[fsStrikeOut];
end; {StrToFontStyles}

///////////////////////////////////////////////////////////////////////////////
//ValueType
///////////////////////////////////////////////////////////////////////////////

{$IFDEF FORSAVE}
function ValueTypeToStr(AValueType: TEditValueType): string;
begin
  case AValueType of
    evtText: Result:=cEvtText;
    evtFloat: Result:=cEvtFloat;
    evtDate: Result:=cEvtDate;
  end;
end; {ValueTypeToStr}
{$ENDIF}

{$IFNDEF FORSAVE}
function StrToFldType(const AStr: string): TFldType;
begin
  if AStr=cEvtText then
    Result:=fldtString
  else if AStr=cEvtFloat then
    Result:=fldtNumber
  else if AStr=cEvtDate then
    Result:=fldtDate
  else
    Result:=fldtString;
end; {StrToFldType}
{$ENDIF}

///////////////////////////////////////////////////////////////////////////////
//Edit
///////////////////////////////////////////////////////////////////////////////

{$IFDEF FORSAVE}
function EditToStr(AC: TComponent): string;
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Values[cType]:=cTypeEdit;
    sl.Values[cName]:=TEdit(AC).Name;
    sl.Values[cLeft]:=IntToStr(TEdit(AC).Left);
    sl.Values[cTop]:=IntToStr(TEdit(AC).Top);
    sl.Values[cWidth]:=IntToStr(TEdit(AC).Width);
    sl.Values[cHeight]:=IntToStr(TEdit(AC).Height);
    sl.Values[cVisible]:=BoolToStr(TEdit(AC).Visible);

    sl.Values[cTabOrder]:=IntToStr(TEdit(AC).TabOrder);
    sl.Values[cTabStop]:=BoolToStr(TEdit(AC).TabStop);

    if AC is TFEdit then begin
      sl.Values[cValueType]:=ValueTypeToStr(TFEdit(AC).EditValueType);
      sl.Values[cDisplayFormat]:=TFEdit(AC).DisplayFormat;
    end;
    //doplnit edit mask

    Result:=sl.Text;
  finally
    sl.Free;
  end;
end; {EditToStr}
{$ELSE}
function CreateEditFromStr(const ASlDef: TStringList; AOwner: TComponent;
                           AParent: TWinControl): TComponent;
var
  cx: TfaEdit;
  format: string;
begin
  if AslDef.Values[cType]=cTypeEdit then begin
    cx:=TfaEdit.Create(AOwner);
    cx.Parent:=AParent;
    cx.Name:=ASlDef.Values[cName];
    cx.Left:=StrToInt(ASlDef.Values[cLeft]);
    cx.Top:=StrToInt(ASlDef.Values[cTop]);
    cx.Width:=StrToInt(ASlDef.Values[cWidth]);
    cx.Height:=StrToInt(ASlDef.Values[cHeight]);
    cx.Visible:=StrToBool(ASlDef.Values[cVisible]);

    //cx.TabOrder:=StrToInt(ASlDef.Values[cTabOrder]);
    //cx.TabStop:=StrToBool(ASlDef.Values[cTabStop]);

    //cx.Style.Color:=StrToColor(ASlDef.Values[cColor]);
    //cx.Style.BorderColor:=StrToColor(ASlDef.Values[cBorderColor]);
    //cx.SelectedColor:=StrToColor(ASlDef.Values[cSelectedColor]);

    cx.FldType:=StrToFldType(ASlDef.Values[cValueType]);
    if ASlDef.IndexOf(cDisplayFormat)>-1 then begin
      format:=ASlDef.Values[cDisplayFormat];
      if Pos('.',format)=0 then
        cx.FldTypeDecimalPlaces:=0
      else
        cx.FldTypeDecimalPlaces:=Length(format)-Pos('.',format);
    end;

    //cx.BorderStyle := ebsSingle;

    Result:=TComponent(cx)
  end
  else
    Result:=nil;
end; {CreateEditFromStr}
{$ENDIF}

///////////////////////////////////////////////////////////////////////////////
//CheckBox
///////////////////////////////////////////////////////////////////////////////

{$IFDEF FORSAVE}
function CheckBoxToStr(AC: TComponent): string;
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Values[cType]:=cTypeCheckBox;
    sl.Values[cName]:=TCheckBox(AC).Name;
    //sl.Values[cAutoSize]:=BoolToStr(TCheckBox(AC).AutoSize);
    sl.Values[cLeft]:=IntToStr(TCheckBox(AC).Left);
    sl.Values[cTop]:=IntToStr(TCheckBox(AC).Top);
    sl.Values[cWidth]:=IntToStr(TCheckBox(AC).Width);
    sl.Values[cHeight]:=IntToStr(TCheckBox(AC).Height);
    sl.Values[cVisible]:=BoolToStr(TCheckBox(AC).Visible);

    sl.Values[cTabOrder]:=IntToStr(TCheckBox(AC).TabOrder);
    sl.Values[cTabStop]:=BoolToStr(TCheckBox(AC).TabStop);

    sl.Values[cColor]:=ColorToStr(TCheckBox(AC).Color);
    //sl.Values[cBorderColor]:=ColorToStr(TCheckBox(AC).Style.BorderColor);

    sl.Values[cCaption]:=MemoStrToStr(TCheckBox(AC).Caption);
    sl.Values[cAlignment]:=AlignmentToStr(TCheckBox(AC).Alignment);
    //sl.Values[cMultiLine]:=BoolToStr(TCheckBox(AC).MultiLine);

    Result:=sl.Text;
  finally
    sl.Free;
  end;
end; {CheckBoxToStr}
{$ELSE}
function CreateCheckBoxFromStr(const ASlDef: TStringList; AOwner: TComponent;
                               AParent: TWinControl): TComponent;
var
  cx: TcxDBCheckBoxEx;
begin
  if AslDef.Values[cType]=cTypeCheckBox then begin
    cx:=TcxDBCheckBoxEx.Create(AOwner);
    cx.Parent:=AParent;
    cx.Name:=ASlDef.Values[cName];
    //cx.AutoSize:=StrToBool(ASlDef.Values[cAutoSize]);
    cx.Left:=StrToInt(ASlDef.Values[cLeft])-4;
    cx.Top:=StrToInt(ASlDef.Values[cTop]);
    cx.Width:=StrToInt(ASlDef.Values[cWidth])+1;
    cx.Height:=StrToInt(ASlDef.Values[cHeight]);
    cx.Visible:=StrToBool(ASlDef.Values[cVisible]);

    cx.TabOrder:=StrToInt(ASlDef.Values[cTabOrder]);
    cx.TabStop:=StrToBool(ASlDef.Values[cTabStop]);

    cx.ParentColor:=FALSE;
    cx.Style.Color:=StrToColor(ASlDef.Values[cColor]);
    cx.Style.BorderColor:=StrToColor(cDefaultBorderColor);
      //StrToColor(ASlDef.Values[cBorderColor]);

    cx.Properties.Caption:=StrToMemoStr(ASlDef.Values[cCaption]);
    if ASlDef.Values[cAlignment]=cRightJustify then
      cx.Properties.Alignment:=StrToAlignment(cLeftJustify)
    else if ASlDef.Values[cAlignment]=cLeftJustify then
      cx.Properties.Alignment:=StrToAlignment(cRightJustify)
    else
      cx.Properties.Alignment:=StrToAlignment(ASlDef.Values[cAlignment]);
    //cx.Properties.MultiLine:=StrToBool(ASlDef.Values[cMultiLine]);

    //cx.Style.BorderStyle := ebsSingle;

    Result:=TComponent(cx)
  end
  else
    Result:=nil;
end; {CreateCheckBoxFromStr}
{$ENDIF}

///////////////////////////////////////////////////////////////////////////////
//Label
///////////////////////////////////////////////////////////////////////////////

{$IFDEF FORSAVE}
function LabelToStr(AC: TComponent; ATransformLabel: boolean): string;
var
  sl: TStringList;
  framed: boolean;

  function IsFramedLabel(al: TLabel): boolean;
  var
    i: integer;
    s: TShape;
  begin
    Result:=FALSE;
    if AL.Parent is TWinControl then
      for i:=0 to al.Parent.ControlCount-1 do
        if al.Parent.Controls[i] is TShape then begin
          s:=TShape(al.Parent.Controls[i]);
          Result:=(s.Left<=al.Left)and(s.Top<=al.Top)and
            (s.Width>=al.Width)and(s.Height>=al.Height);
          if Result then
            BREAK;
        end;
  end;

  function IsUnderline(AFontStyles: TFontStyles): boolean;
  begin
    Result:=fsUnderline in AFontStyles;
  end;

begin
  sl:= TStringList.Create;
  try
    framed:= ATransformLabel and IsFramedLabel(TLabel(AC));
    if framed then
      sl.Values[cType]:=cTypeBorderLabel
    else
      if IsUnderline(TLabel(AC).Font.Style) then
        sl.Values[cType]:=cTypeWebLabel
      else
        sl.Values[cType]:=cTypeLabel;
    sl.Values[cName]:=TLabel(AC).Name;
    sl.Values[cAutoSize]:=BoolToStr(TLabel(AC).AutoSize);
    sl.Values[cLeft]:=IntToStr(TLabel(AC).Left);
    sl.Values[cTop]:=IntToStr(TLabel(AC).Top);
    sl.Values[cWidth]:=IntToStr(TLabel(AC).Width);
    sl.Values[cHeight]:=IntToStr(TLabel(AC).Height);
    sl.Values[cVisible]:=BoolToStr(TLabel(AC).Visible);
    sl.Values[cCaption]:=MemoStrToStr(TLabel(AC).Caption);

    sl.Values[cColor]:=ColorToStr(TLabel(AC).Color);
    if TLabel(AC).Font.Name<>cDefaultFontName then
      sl.Values[cFontName]:=TLabel(AC).Font.Name;
    sl.Values[cFontColor]:=ColorToStr(TLabel(AC).Font.Color);
    sl.Values[cFontSize]:=IntToStr(TLabel(AC).Font.Size);
    sl.Values[cFontStyle]:=FontStylesToStr(TLabel(AC).Font.Style);

    sl.Values[cAlignment]:=
      AlignmentToStr(TLabel(AC).Alignment);
    sl.Values[cTransparent]:=BoolToStr(TLabel(AC).Transparent);
    sl.Values[cParentColor]:=BoolToStr(TLabel(AC).ParentColor);
    sl.Values[cWordWrap]:=BoolToStr(TLabel(AC).WordWrap);

    Result:=sl.Text;
  finally
    sl.Free;
  end;
end; {LabelToStr}
{$ELSE}
function CreateLabelFromStr(const ASlDef: TStringList; AOwner: TComponent;
                            AParent: TWinControl): TComponent;
var
  cxb: TpsvBorderLabel;
  cxl: TpsvWebLabel;
  cx: TLabel;
begin
  if AslDef.Values[cType]=cTypeBorderLabel then begin
    cxb:=TpsvBorderLabel.Create(AOwner);
    cxb.Parent:=AParent;
    cxb.Name:=ASlDef.Values[cName];
    cxb.AutoSize:=FALSE;//StrToBool(ASlDef.Values[cAutoSize]);
    cxb.Left:=StrToInt(ASlDef.Values[cLeft]);
    cxb.Top:=StrToInt(ASlDef.Values[cTop]);
    cxb.Width:=StrToInt(ASlDef.Values[cWidth]);
    cxb.Height:=StrToInt(ASlDef.Values[cHeight]);
    cxb.Visible:=StrToBool(ASlDef.Values[cVisible]);
    cxb.Caption:=StrToMemoStr(ASlDef.Values[cCaption]);

    cxb.Color:=StrToColor(ASlDef.Values[cColor]);
    if ASlDef.IndexOfName(cFontName)>-1 then
      cxb.Font.Name:=ASlDef.Values[cFontName];
    cxb.Font.Color:=StrToColor(ASlDef.Values[cFontColor]);
    cxb.Font.Size:=StrToInt(ASlDef.Values[cFontSize]);
    cxb.Font.Style:=StrToFontStyles(ASlDef.Values[cFontStyle]);

    cxb.Alignment:=StrToAlignment(ASlDef.Values[cAlignment]);
    cxb.Transparent:=StrToBool(ASlDef.Values[cTransparent]);
    cxb.ParentColor:=StrToBool(ASlDef.Values[cParentColor]);
    cxb.WordWrap:=StrToBool(ASlDef.Values[cWordWrap]);

    cxb.Border:=bsFramed;

    Result:=TComponent(cxb)
  end
  else if AslDef.Values[cType]=cTypeWebLabel then begin
    cxl:=TpsvWebLabel.Create(AOwner);
    cxl.Parent:=AParent;
    cxl.Name:=ASlDef.Values[cName];
    cxl.AutoSize:=StrToBool(ASlDef.Values[cAutoSize]);
    cxl.Left:=StrToInt(ASlDef.Values[cLeft]);
    cxl.Top:=StrToInt(ASlDef.Values[cTop]);
    cxl.Width:=StrToInt(ASlDef.Values[cWidth]);
    cxl.Height:=StrToInt(ASlDef.Values[cHeight]);
    cxl.Visible:=StrToBool(ASlDef.Values[cVisible]);
    cxl.Caption:=StrToMemoStr(ASlDef.Values[cCaption]);

    if ASlDef.IndexOfName(cFontName)>-1 then
      cxl.Font.Name:=ASlDef.Values[cFontName];
    cxl.Font.Color:=StrToColor(ASlDef.Values[cFontColor]);
    cxl.Font.Size:=StrToInt(ASlDef.Values[cFontSize]);
    cxl.Font.Style:=StrToFontStyles(ASlDef.Values[cFontStyle]);

    cxl.Alignment:=StrToAlignment(ASlDef.Values[cAlignment]);
    cxl.Transparent:=StrToBool(ASlDef.Values[cTransparent]);
    cxl.WordWrap:=StrToBool(ASlDef.Values[cWordWrap]);

    //cx.ParentColor:=StrToBool(ASlDef.Values[cParentColor]);
    cxl.Color:=StrToColor(ASlDef.Values[cColor]);

    Result:=TComponent(cxl)
  end
  else if AslDef.Values[cType]=cTypeLabel then begin
    cx:=TLabel.Create(AOwner);
    cx.Parent:=AParent;
    cx.Name:=ASlDef.Values[cName];
    cx.AutoSize:=StrToBool(ASlDef.Values[cAutoSize]);
    cx.Left:=StrToInt(ASlDef.Values[cLeft]);
    cx.Top:=StrToInt(ASlDef.Values[cTop]);
    cx.Width:=StrToInt(ASlDef.Values[cWidth]);
    cx.Height:=StrToInt(ASlDef.Values[cHeight]);
    cx.Visible:=StrToBool(ASlDef.Values[cVisible]);
    cx.Caption:=StrToMemoStr(ASlDef.Values[cCaption]);

    if ASlDef.IndexOfName(cFontName)>-1 then
      cx.Font.Name:=ASlDef.Values[cFontName];
    cx.Font.Color:=StrToColor(ASlDef.Values[cFontColor]);
    cx.Font.Size:=StrToInt(ASlDef.Values[cFontSize]);
    cx.Font.Style:=StrToFontStyles(ASlDef.Values[cFontStyle]);

    cx.Alignment:=StrToAlignment(ASlDef.Values[cAlignment]);
    cx.Transparent:=StrToBool(ASlDef.Values[cTransparent]);
    cx.WordWrap:=StrToBool(ASlDef.Values[cWordWrap]);

    cx.ParentColor:=StrToBool(ASlDef.Values[cParentColor]);
    cx.Color:=StrToColor(ASlDef.Values[cColor]);

    Result:=TComponent(cx)
  end
  else
    Result:=nil;
end; {CreateLabelFromStr}
{$ENDIF}

{$IFDEF FORSAVE}
function ShapeToStr(AC: TComponent): string;
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Values[cType]:=cTypeShape;
    sl.Values[cName]:=TShape(AC).Name;
    sl.Values[cLeft]:=IntToStr(TShape(AC).Left);
    sl.Values[cTop]:=IntToStr(TShape(AC).Top);
    sl.Values[cWidth]:=IntToStr(TShape(AC).Width);
    sl.Values[cHeight]:=IntToStr(TShape(AC).Height);
    sl.Values[cVisible]:=BoolToStr(TShape(AC).Visible);

    sl.Values[cBrushColor]:=ColorToStr(TShape(AC).Brush.Color);
    sl.Values[cBrushStyle]:=BrushStyleToStr(TShape(AC).Brush.Style);
    //sl.Values[cPenColor]:=ColorToStr(TShape(AC).Pen.Color);
    sl.Values[cPenColor]:=ColorToStr(clHighlight);

    Result:=sl.Text;
  finally
    sl.Free;
  end;
end; {ShapeToStr}
{$ELSE}
function CreateShapeFromStr(const ASlDef: TStringList; AOwner: TComponent;
                               AParent: TWinControl): TComponent;
var
  cx: TShape;
begin
  if AslDef.Values[cType]=cTypeShape then begin
    cx:=TShape.Create(AOwner);
    cx.Parent:=AParent;
    cx.Name:=ASlDef.Values[cName];
    cx.Left:=StrToInt(ASlDef.Values[cLeft]);
    cx.Top:=StrToInt(ASlDef.Values[cTop]);
    cx.Width:=StrToInt(ASlDef.Values[cWidth]);
    cx.Height:=StrToInt(ASlDef.Values[cHeight]);
    cx.Visible:=StrToBool(ASlDef.Values[cVisible]);

    cx.Brush.Color:=StrToColor(ASlDef.Values[cBrushColor]);
    cx.Brush.Style:=StrToBrushStyle(ASlDef.Values[cBrushStyle]);
    cx.Pen.Color:=StrToColor(ASlDef.Values[cPenColor]);

    Result:=TComponent(cx)
  end
  else
    Result:=nil;
end; {CreateShapeFromStr}
{$ENDIF}

end.




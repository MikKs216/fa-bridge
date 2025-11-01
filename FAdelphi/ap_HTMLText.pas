{***************************************************************************}
{ This source code was generated automatically by                           }
{ Pas file import tool for Scripter Studio (Pro)                            }
{                                                                           }
{ Scripter Studio and Pas file import tool for Scripter Studio              }
{ written by TMS Software                                                   }
{            copyright © 1997 - 2010                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{***************************************************************************}
unit ap_HTMLText;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  Extctrls,
  ComObj,
  ActiveX,
  PictureContainer,
  ImgList,
  Types,
  HTMLText,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatHTMLTextLibrary = class(TatScripterLibrary)
    procedure __THTMLStaticTextCreate(AMachine: TatVirtualMachine);
    procedure __THTMLStaticTextDestroy(AMachine: TatVirtualMachine);
    procedure __THTMLStaticTextBeginUpdate(AMachine: TatVirtualMachine);
    procedure __THTMLStaticTextEndUpdate(AMachine: TatVirtualMachine);
    procedure __THTMLStaticTextDoit(AMachine: TatVirtualMachine);
    procedure __THTMLStaticTextHilightText(AMachine: TatVirtualMachine);
    procedure __THTMLStaticTextUnHilightText(AMachine: TatVirtualMachine);
    procedure __THTMLStaticTextMarkText(AMachine: TatVirtualMachine);
    procedure __THTMLStaticTextUnMarkText(AMachine: TatVirtualMachine);
    procedure __GetTHTMLStaticTextText(AMachine: TatVirtualMachine);
    procedure __GetTHTMLStaticTextVOffset(AMachine: TatVirtualMachine);
    procedure __SetTHTMLStaticTextVOffset(AMachine: TatVirtualMachine);
    procedure __GetTHTMLStaticTextHTMLWidth(AMachine: TatVirtualMachine);
    procedure __GetTHTMLStaticTextHTMLHeight(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  THTMLStaticTextClass = class of THTMLStaticText;

  TatHTMLTextDispatcher = class(TatEventDispatcher)
  private
    procedure __TOnNewSize( Sender: TObject;  NewWidth: Integer;  NewHeight: Integer);
    procedure __TAnchorClick( Sender: TObject;  Anchor: string);
    procedure __TAnchorHintEvent( Sender: TObject; var Anchor: string);
  end;


implementation



procedure TatHTMLTextLibrary.__THTMLStaticTextCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(THTMLStaticTextClass(CurrentClass.ClassRef).Create(TComponent(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatHTMLTextLibrary.__THTMLStaticTextDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).Destroy;
  end;
end;

procedure TatHTMLTextLibrary.__THTMLStaticTextBeginUpdate(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).BeginUpdate;
  end;
end;

procedure TatHTMLTextLibrary.__THTMLStaticTextEndUpdate(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).EndUpdate;
  end;
end;

procedure TatHTMLTextLibrary.__THTMLStaticTextDoit(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).Doit;
  end;
end;

procedure TatHTMLTextLibrary.__THTMLStaticTextHilightText(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).HilightText(VarToStr(GetInputArg(0)),GetInputArg(1));
  end;
end;

procedure TatHTMLTextLibrary.__THTMLStaticTextUnHilightText(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).UnHilightText;
  end;
end;

procedure TatHTMLTextLibrary.__THTMLStaticTextMarkText(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).MarkText(VarToStr(GetInputArg(0)),GetInputArg(1));
  end;
end;

procedure TatHTMLTextLibrary.__THTMLStaticTextUnMarkText(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).UnMarkText;
  end;
end;

procedure TatHTMLTextLibrary.__GetTHTMLStaticTextText(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(string(THTMLStaticText(CurrentObject).Text));
  end;
end;

procedure TatHTMLTextLibrary.__GetTHTMLStaticTextVOffset(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(THTMLStaticText(CurrentObject).VOffset));
  end;
end;

procedure TatHTMLTextLibrary.__SetTHTMLStaticTextVOffset(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    THTMLStaticText(CurrentObject).VOffset:=VarToInteger(GetInputArg(0));
  end;
end;

procedure TatHTMLTextLibrary.__GetTHTMLStaticTextHTMLWidth(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(THTMLStaticText(CurrentObject).HTMLWidth));
  end;
end;

procedure TatHTMLTextLibrary.__GetTHTMLStaticTextHTMLHeight(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(Integer(THTMLStaticText(CurrentObject).HTMLHeight));
  end;
end;

procedure TatHTMLTextDispatcher.__TOnNewSize( Sender: TObject;  NewWidth: Integer;  NewHeight: Integer);
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TOnNewSize(BeforeCall)(Sender,NewWidth,NewHeight);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [Sender,NewWidth,NewHeight]);
    if AssignedMethod(AfterCall) then
      TOnNewSize(AfterCall)(Sender,NewWidth,NewHeight);
  end;
end;

procedure TatHTMLTextDispatcher.__TAnchorClick( Sender: TObject;  Anchor: string);
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TAnchorClick(BeforeCall)(Sender,Anchor);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [Sender,Anchor]);
    if AssignedMethod(AfterCall) then
      TAnchorClick(AfterCall)(Sender,Anchor);
  end;
end;

procedure TatHTMLTextDispatcher.__TAnchorHintEvent( Sender: TObject; var Anchor: string);
var
  AnchorTemp: variant;
begin
  if DoOnExecuteEvent then
  begin
    if AssignedMethod(BeforeCall) then
      TAnchorHintEvent(BeforeCall)(Sender,Anchor);
    AnchorTemp := string(Anchor);
    if Assigned(Scripter) and (RoutineName > '') then
      Scripter.ExecuteSubroutine(RoutineName, [Sender,AnchorTemp]);
    Anchor := VarToStr(AnchorTemp);
    if AssignedMethod(AfterCall) then
      TAnchorHintEvent(AfterCall)(Sender,Anchor);
  end;
end;

procedure TatHTMLTextLibrary.Init;
begin
  With Scripter.DefineClass(THTMLStaticText) do
  begin
    DefineMethod('Create',1,tkClass,THTMLStaticText,__THTMLStaticTextCreate,true,0,'AOwner: TComponent');
    DefineMethod('Destroy',0,tkNone,nil,__THTMLStaticTextDestroy,false,0,'');
    DefineMethod('BeginUpdate',0,tkNone,nil,__THTMLStaticTextBeginUpdate,false,0,'');
    DefineMethod('EndUpdate',0,tkNone,nil,__THTMLStaticTextEndUpdate,false,0,'');
    DefineMethod('Doit',0,tkNone,nil,__THTMLStaticTextDoit,false,0,'');
    DefineMethod('HilightText',2,tkNone,nil,__THTMLStaticTextHilightText,false,0,'HiText: string; DoCase: Boolean');
    DefineMethod('UnHilightText',0,tkNone,nil,__THTMLStaticTextUnHilightText,false,0,'');
    DefineMethod('MarkText',2,tkNone,nil,__THTMLStaticTextMarkText,false,0,'HiText: string; DoCase: Boolean');
    DefineMethod('UnMarkText',0,tkNone,nil,__THTMLStaticTextUnMarkText,false,0,'');
    DefineProp('Text',tkVariant,__GetTHTMLStaticTextText,nil,nil,false,0);
    DefineProp('VOffset',tkInteger,__GetTHTMLStaticTextVOffset,__SetTHTMLStaticTextVOffset,nil,false,0);
    DefineProp('HTMLWidth',tkInteger,__GetTHTMLStaticTextHTMLWidth,nil,nil,false,0);
    DefineProp('HTMLHeight',tkInteger,__GetTHTMLStaticTextHTMLHeight,nil,nil,false,0);
  end;
  DefineEventAdapter(TypeInfo(TOnNewSize), TatHTMLTextDispatcher, @TatHTMLTextDispatcher.__TOnNewSize);
  DefineEventAdapter(TypeInfo(TAnchorClick), TatHTMLTextDispatcher, @TatHTMLTextDispatcher.__TAnchorClick);
  DefineEventAdapter(TypeInfo(TAnchorHintEvent), TatHTMLTextDispatcher, @TatHTMLTextDispatcher.__TAnchorHintEvent);
  With Scripter.DefineClass(ClassType) do
  begin
    AddConstant('tvaTop',tvaTop);
    AddConstant('tvaCenter',tvaCenter);
    AddConstant('tvaBottom',tvaBottom);
    AddConstant('asVertical',asVertical);
    AddConstant('asHorizontal',asHorizontal);
    AddConstant('asBoth',asBoth);
    AddConstant('MAJ_VER',MAJ_VER);
    AddConstant('MIN_VER',MIN_VER);
    AddConstant('REL_VER',REL_VER);
    AddConstant('BLD_VER',BLD_VER);
  end;
end;

class function TatHTMLTextLibrary.LibraryName: string;
begin
  result := 'HTMLText';
end;

initialization
  RegisterScripterLibrary(TatHTMLTextLibrary, True);

{$WARNINGS ON}

end.


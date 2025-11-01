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
unit ap_CxListBoxEx;

interface

uses
  SysUtils,
  Classes,
  Controls,
  cxControls,
  cxContainer,
  cxEdit,
  cxTextEdit,
  cxMemo,
  cxDBEdit,
  Graphics,
  Windows,
  faEdit,
  cxListBox,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  CxListBoxEx,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatCxListBoxExLibrary = class(TatScripterLibrary)
    procedure __TcxListBoxExCreate(AMachine: TatVirtualMachine);
    procedure __Register(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  TcxListBoxExClass = class of TcxListBoxEx;



implementation



procedure TatCxListBoxExLibrary.__TcxListBoxExCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TcxListBoxExClass(CurrentClass.ClassRef).Create(TComponent(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatCxListBoxExLibrary.__Register(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    CxListBoxEx.Register;
  end;
end;

procedure TatCxListBoxExLibrary.Init;
begin
  With Scripter.DefineClass(TcxListBoxEx) do
  begin
    DefineMethod('Create',1,tkClass,TcxListBoxEx,__TcxListBoxExCreate,true,0,'AOwner: TComponent');
  end;
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('Register',0,tkNone,nil,__Register,false,0,'');
    AddConstant('cDefaultBorderColor',cDefaultBorderColor);
    AddConstant('cDefaultSelectedColor',cDefaultSelectedColor);
  end;
end;

class function TatCxListBoxExLibrary.LibraryName: string;
begin
  result := 'CxListBoxEx';
end;

initialization
  RegisterScripterLibrary(TatCxListBoxExLibrary, True);

{$WARNINGS ON}

end.


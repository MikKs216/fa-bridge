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
unit ap_CxDBCheckBoxEx;

interface

uses
  SysUtils,
  Classes,
  Controls,
  cxControls,
  cxContainer,
  cxEdit,
  cxCheckBox,
  cxDBEdit,
  Graphics,
  Windows,
  Messages,
  faEdit,
  StdCtrls,
  cxLookAndFeels,
  CxDBCheckBoxEx,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatCxDBCheckBoxExLibrary = class(TatScripterLibrary)
    procedure __TcxDBCheckBoxExCreate(AMachine: TatVirtualMachine);
    procedure __Register(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  TcxDBCheckBoxExClass = class of TcxDBCheckBoxEx;



implementation



procedure TatCxDBCheckBoxExLibrary.__TcxDBCheckBoxExCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TcxDBCheckBoxExClass(CurrentClass.ClassRef).Create(TComponent(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatCxDBCheckBoxExLibrary.__Register(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    CxDBCheckBoxEx.Register;
  end;
end;

procedure TatCxDBCheckBoxExLibrary.Init;
begin
  With Scripter.DefineClass(TcxDBCheckBoxEx) do
  begin
    DefineMethod('Create',1,tkClass,TcxDBCheckBoxEx,__TcxDBCheckBoxExCreate,true,0,'AOwner: TComponent');
  end;
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('Register',0,tkNone,nil,__Register,false,0,'');
    AddConstant('cDefaultBorderColor',cDefaultBorderColor);
    AddConstant('cDefaultSelectedColor',cDefaultSelectedColor);
  end;
end;

class function TatCxDBCheckBoxExLibrary.LibraryName: string;
begin
  result := 'CxDBCheckBoxEx';
end;

initialization
  RegisterScripterLibrary(TatCxDBCheckBoxExLibrary, True);

{$WARNINGS ON}

end.


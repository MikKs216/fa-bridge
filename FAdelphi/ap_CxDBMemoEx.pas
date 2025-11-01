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
unit ap_CxDBMemoEx;

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
  cxLookAndFeels,
  CxDBMemoEx,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatCxDBMemoExLibrary = class(TatScripterLibrary)
    procedure __TcxDBMemoExCreate(AMachine: TatVirtualMachine);
    procedure __Register(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  TcxDBMemoExClass = class of TcxDBMemoEx;



implementation



procedure TatCxDBMemoExLibrary.__TcxDBMemoExCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TcxDBMemoExClass(CurrentClass.ClassRef).Create(TComponent(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatCxDBMemoExLibrary.__Register(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    CxDBMemoEx.Register;
  end;
end;

procedure TatCxDBMemoExLibrary.Init;
begin
  With Scripter.DefineClass(TcxDBMemoEx) do
  begin
    DefineMethod('Create',1,tkClass,TcxDBMemoEx,__TcxDBMemoExCreate,true,0,'AOwner: TComponent');
  end;
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('Register',0,tkNone,nil,__Register,false,0,'');
    AddConstant('cDefaultBorderColor',cDefaultBorderColor);
    AddConstant('cDefaultSelectedColor',cDefaultSelectedColor);
  end;
end;

class function TatCxDBMemoExLibrary.LibraryName: string;
begin
  result := 'CxDBMemoEx';
end;

initialization
  RegisterScripterLibrary(TatCxDBMemoExLibrary, True);

{$WARNINGS ON}

end.


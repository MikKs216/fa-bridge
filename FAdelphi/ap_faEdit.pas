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
unit ap_faEdit;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  DBCtrls,
  UxTheme,
  Themes,
  Forms,
  DwmApi,
  faEdit,
  Variants,
  ap_Windows,
  ap_Types,  
  atScript;

{$WARNINGS OFF}

type
  TatfaEditLibrary = class(TatScripterLibrary)
    procedure __TfaEditCreate(AMachine: TatVirtualMachine);
    procedure __TfaEditDestroy(AMachine: TatVirtualMachine);
    procedure __GetTfaEditHighlightListRect(AMachine: TatVirtualMachine);
    procedure __GetTfaEditHighlightDefvalRect(AMachine: TatVirtualMachine);
    procedure __Register(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  TfaEditClass = class of TfaEdit;



implementation



procedure TatfaEditLibrary.__TfaEditCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TfaEditClass(CurrentClass.ClassRef).Create(TComponent(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatfaEditLibrary.__TfaEditDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TfaEdit(CurrentObject).Destroy;
  end;
end;

procedure TatfaEditLibrary.__GetTfaEditHighlightListRect(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TRectWrapper.Create(TfaEdit(CurrentObject).HighlightListRect)));
  end;
end;

procedure TatfaEditLibrary.__GetTfaEditHighlightDefvalRect(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(ObjectToVar(TRectWrapper.Create(TfaEdit(CurrentObject).HighlightDefvalRect)));
  end;
end;

procedure TatfaEditLibrary.__Register(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    faEdit.Register;
  end;
end;

procedure TatfaEditLibrary.Init;
begin
  With Scripter.DefineClass(TfaEdit) do
  begin
    DefineMethod('Create',1,tkClass,TfaEdit,__TfaEditCreate,true,0,'AOwner: TComponent');
    DefineMethod('Destroy',0,tkNone,nil,__TfaEditDestroy,false,0,'');
    DefineProp('HighlightListRect',tkVariant,__GetTfaEditHighlightListRect,nil,nil,false,0);
    DefineProp('HighlightDefvalRect',tkVariant,__GetTfaEditHighlightDefvalRect,nil,nil,false,0);
  end;
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('Register',0,tkNone,nil,__Register,false,0,'');
    AddConstant('fldtString',fldtString);
    AddConstant('fldtNumber',fldtNumber);
    AddConstant('fldtCurrency',fldtCurrency);
    AddConstant('fldtDate',fldtDate);
    AddConstant('ndRight',ndRight);
    AddConstant('ndDown',ndDown);
    AddConstant('cDefaultBorderColor',cDefaultBorderColor);
    AddConstant('cDefaultBorderSize',cDefaultBorderSize);
    AddConstant('cDefaultColor',cDefaultColor);
    AddConstant('cDefaultSelectedColor',cDefaultSelectedColor);
  end;
end;

class function TatfaEditLibrary.LibraryName: string;
begin
  result := 'faEdit';
end;

initialization
  RegisterScripterLibrary(TatfaEditLibrary, True);

{$WARNINGS ON}

end.


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
unit ap_psvWebLabel;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  stdCtrls,
  Graphics,
  Messages,
  psvBasicLbl,
  ShellAPI,
  Forms,
  psvWebLabel,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatpsvWebLabelLibrary = class(TatScripterLibrary)
    procedure __TpsvWebLabelCreate(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  TpsvWebLabelClass = class of TpsvWebLabel;



implementation



procedure TatpsvWebLabelLibrary.__TpsvWebLabelCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := ObjectToVar(TpsvWebLabelClass(CurrentClass.ClassRef).Create(TComponent(VarToObject(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatpsvWebLabelLibrary.Init;
begin
  With Scripter.DefineClass(TpsvWebLabel) do
  begin
    DefineMethod('Create',1,tkClass,TpsvWebLabel,__TpsvWebLabelCreate,true,0,'aOwner: TComponent');
  end;
  With Scripter.DefineClass(ClassType) do
  begin
    AddConstant('lnFile',lnFile);
    AddConstant('lnFtp',lnFtp);
    AddConstant('lnGopher',lnGopher);
    AddConstant('lnHttp',lnHttp);
    AddConstant('lnHttps',lnHttps);
    AddConstant('lnMailto',lnMailto);
    AddConstant('lnNews',lnNews);
    AddConstant('lnTelnet',lnTelnet);
    AddConstant('lnWais',lnWais);
    AddConstant('lnControl',lnControl);
  end;
end;

class function TatpsvWebLabelLibrary.LibraryName: string;
begin
  result := 'psvWebLabel';
end;

initialization
  RegisterScripterLibrary(TatpsvWebLabelLibrary, True);

{$WARNINGS ON}

end.


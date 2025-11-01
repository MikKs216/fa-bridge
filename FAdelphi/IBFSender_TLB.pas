{ 3.9.2020 12:56:42 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in Dodatecne zarazeni zmen dle verze 1.1.3 (z 15.1.2020).  }
{ 3.10.2018 12:20:43 (GMT+2:00) > [marek on WIN-48QDB6JAV23] checked in zarazeni do projektu  }
unit IBFSender_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 3.9.2020 12:50:16 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Vyvoj\FormStudioFull\FA\IBFSender.tlb (1)
// LIBID: {173A5226-C61A-4475-89E3-FFD0B4AADC9A}
// LCID: 0
// Helpfile: 
// HelpString: Odesilani bankovnich prikazu pres rozhrani FIO
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v2.4 mscorlib, (C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorlib.tlb)
// Errors:
//   Error creating palette bitmap of (TIBFMainLib) : Server mscoree.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  IBFSenderMajorVersion = 1;
  IBFSenderMinorVersion = 1;

  LIBID_IBFSender: TGUID = '{173A5226-C61A-4475-89E3-FFD0B4AADC9A}';

  IID__IBFMainLib: TGUID = '{460F26A5-420C-357E-9E0D-EF3939736D15}';
  CLASS_IBFMainLib: TGUID = '{D1213118-5EB3-4619-B53D-A793C3C9C440}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IBFMainLib = interface;
  _IBFMainLibDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  IBFMainLib = _IBFMainLib;


// *********************************************************************//
// Interface: _IBFMainLib
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {460F26A5-420C-357E-9E0D-EF3939736D15}
// *********************************************************************//
  _IBFMainLib = interface(IDispatch)
    ['{460F26A5-420C-357E-9E0D-EF3939736D15}']
    function Get_ToString: WideString; safecall;
    function Equals(obj: OleVariant): WordBool; safecall;
    function GetHashCode: Integer; safecall;
    function GetType: _Type; safecall;
    function SendPost(const pathToFile: WideString; const fileFormat: WideString; 
                      const token: WideString; out response: WideString; out statusCode: WideString): WordBool; safecall;
    function SendGetAddress(const address: WideString; out response: WideString; 
                            out statusCode: WideString): WordBool; safecall;
    function SendGet(const fileFormat: WideString; const token: WideString; datumOd: TDateTime; 
                     datumDo: TDateTime; out response: WideString; out statusCode: WideString): WordBool; safecall;
    function SendGetLast(const fileFormat: WideString; const token: WideString; 
                         out response: WideString; out statusCode: WideString): WordBool; safecall;
    function SendGetSetLastDate(lastDate: TDateTime; const token: WideString; 
                                out response: WideString; out statusCode: WideString): WordBool; safecall;
    function Name: WideString; safecall;
    property ToString: WideString read Get_ToString;
  end;

// *********************************************************************//
// DispIntf:  _IBFMainLibDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {460F26A5-420C-357E-9E0D-EF3939736D15}
// *********************************************************************//
  _IBFMainLibDisp = dispinterface
    ['{460F26A5-420C-357E-9E0D-EF3939736D15}']
    property ToString: WideString readonly dispid 0;
    function Equals(obj: OleVariant): WordBool; dispid 1610743809;
    function GetHashCode: Integer; dispid 1610743810;
    function GetType: _Type; dispid 1610743811;
    function SendPost(const pathToFile: WideString; const fileFormat: WideString; 
                      const token: WideString; out response: WideString; out statusCode: WideString): WordBool; dispid 1610743812;
    function SendGetAddress(const address: WideString; out response: WideString; 
                            out statusCode: WideString): WordBool; dispid 1610743813;
    function SendGet(const fileFormat: WideString; const token: WideString; datumOd: TDateTime; 
                     datumDo: TDateTime; out response: WideString; out statusCode: WideString): WordBool; dispid 1610743814;
    function SendGetLast(const fileFormat: WideString; const token: WideString; 
                         out response: WideString; out statusCode: WideString): WordBool; dispid 1610743815;
    function SendGetSetLastDate(lastDate: TDateTime; const token: WideString; 
                                out response: WideString; out statusCode: WideString): WordBool; dispid 1610743816;
    function Name: WideString; dispid 1610743817;
  end;

// *********************************************************************//
// The Class CoIBFMainLib provides a Create and CreateRemote method to          
// create instances of the default interface _IBFMainLib exposed by              
// the CoClass IBFMainLib. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoIBFMainLib = class
    class function Create: _IBFMainLib;
    class function CreateRemote(const MachineName: string): _IBFMainLib;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TIBFMainLib
// Help String      : 
// Default Interface: _IBFMainLib
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TIBFMainLibProperties= class;
{$ENDIF}
  TIBFMainLib = class(TOleServer)
  private
    FIntf: _IBFMainLib;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TIBFMainLibProperties;
    function GetServerProperties: TIBFMainLibProperties;
{$ENDIF}
    function GetDefaultInterface: _IBFMainLib;
  protected
    procedure InitServerData; override;
    function Get_ToString: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _IBFMainLib);
    procedure Disconnect; override;
    function Equals(obj: OleVariant): WordBool;
    function GetHashCode: Integer;
    function GetType: _Type;
    function SendPost(const pathToFile: WideString; const fileFormat: WideString; 
                      const token: WideString; out response: WideString; out statusCode: WideString): WordBool;
    function SendGetAddress(const address: WideString; out response: WideString; 
                            out statusCode: WideString): WordBool;
    function SendGet(const fileFormat: WideString; const token: WideString; datumOd: TDateTime; 
                     datumDo: TDateTime; out response: WideString; out statusCode: WideString): WordBool;
    function SendGetLast(const fileFormat: WideString; const token: WideString; 
                         out response: WideString; out statusCode: WideString): WordBool;
    function SendGetSetLastDate(lastDate: TDateTime; const token: WideString; 
                                out response: WideString; out statusCode: WideString): WordBool;
    function Name: WideString;
    property DefaultInterface: _IBFMainLib read GetDefaultInterface;
    property ToString: WideString read Get_ToString;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TIBFMainLibProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TIBFMainLib
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TIBFMainLibProperties = class(TPersistent)
  private
    FServer:    TIBFMainLib;
    function    GetDefaultInterface: _IBFMainLib;
    constructor Create(AServer: TIBFMainLib);
  protected
    function Get_ToString: WideString;
  public
    property DefaultInterface: _IBFMainLib read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = '(none)';

  dtlOcxPage = '(none)';

implementation

uses ComObj;

class function CoIBFMainLib.Create: _IBFMainLib;
begin
  Result := CreateComObject(CLASS_IBFMainLib) as _IBFMainLib;
end;

class function CoIBFMainLib.CreateRemote(const MachineName: string): _IBFMainLib;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_IBFMainLib) as _IBFMainLib;
end;

procedure TIBFMainLib.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D1213118-5EB3-4619-B53D-A793C3C9C440}';
    IntfIID:   '{460F26A5-420C-357E-9E0D-EF3939736D15}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TIBFMainLib.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _IBFMainLib;
  end;
end;

procedure TIBFMainLib.ConnectTo(svrIntf: _IBFMainLib);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TIBFMainLib.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TIBFMainLib.GetDefaultInterface: _IBFMainLib;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TIBFMainLib.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TIBFMainLibProperties.Create(Self);
{$ENDIF}
end;

destructor TIBFMainLib.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TIBFMainLib.GetServerProperties: TIBFMainLibProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TIBFMainLib.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

function TIBFMainLib.Equals(obj: OleVariant): WordBool;
begin
  Result := DefaultInterface.Equals(obj);
end;

function TIBFMainLib.GetHashCode: Integer;
begin
  Result := DefaultInterface.GetHashCode;
end;

function TIBFMainLib.GetType: _Type;
begin
  Result := DefaultInterface.GetType;
end;

function TIBFMainLib.SendPost(const pathToFile: WideString; const fileFormat: WideString; 
                              const token: WideString; out response: WideString; 
                              out statusCode: WideString): WordBool;
begin
  Result := DefaultInterface.SendPost(pathToFile, fileFormat, token, response, statusCode);
end;

function TIBFMainLib.SendGetAddress(const address: WideString; out response: WideString; 
                                    out statusCode: WideString): WordBool;
begin
  Result := DefaultInterface.SendGetAddress(address, response, statusCode);
end;

function TIBFMainLib.SendGet(const fileFormat: WideString; const token: WideString; 
                             datumOd: TDateTime; datumDo: TDateTime; out response: WideString; 
                             out statusCode: WideString): WordBool;
begin
  Result := DefaultInterface.SendGet(fileFormat, token, datumOd, datumDo, response, statusCode);
end;

function TIBFMainLib.SendGetLast(const fileFormat: WideString; const token: WideString; 
                                 out response: WideString; out statusCode: WideString): WordBool;
begin
  Result := DefaultInterface.SendGetLast(fileFormat, token, response, statusCode);
end;

function TIBFMainLib.SendGetSetLastDate(lastDate: TDateTime; const token: WideString; 
                                        out response: WideString; out statusCode: WideString): WordBool;
begin
  Result := DefaultInterface.SendGetSetLastDate(lastDate, token, response, statusCode);
end;

function TIBFMainLib.Name: WideString;
begin
  Result := DefaultInterface.Name;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TIBFMainLibProperties.Create(AServer: TIBFMainLib);
begin
  inherited Create;
  FServer := AServer;
end;

function TIBFMainLibProperties.GetDefaultInterface: _IBFMainLib;
begin
  Result := FServer.DefaultInterface;
end;

function TIBFMainLibProperties.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TIBFMainLib]);
end;

end.

unit ASSECOPZP_Library_TLB;

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

// PASTLWTR : 1.2
// File generated on 13.11.2012 12:08:08 from Type Library described below.

// ************************************************************************  //
// Type Lib: c:\Programy\PVTPZP\ASSECOPZP.dll (1)
// LIBID: {B2036E86-9742-45D8-BEF7-DFF0264B3608}
// LCID: 0
// Helpfile: 
// HelpString: ASSECOPZP Library version 2.3
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
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

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ASSECOPZP_LibraryMajorVersion = 2;
  ASSECOPZP_LibraryMinorVersion = 3;

  LIBID_ASSECOPZP_Library: TGUID = '{B2036E86-9742-45D8-BEF7-DFF0264B3608}';

  IID_IPZPDLL: TGUID = '{FECB6B1F-302E-4E9D-A472-11091DB69A9E}';
  CLASS_PZPDLL: TGUID = '{1C5A5C35-1409-40C5-8EDF-40AC6913E794}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPZPDLL = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PZPDLL = IPZPDLL;


// *********************************************************************//
// Interface: IPZPDLL
// Flags:     (256) OleAutomation
// GUID:      {FECB6B1F-302E-4E9D-A472-11091DB69A9E}
// *********************************************************************//
  IPZPDLL = interface(IUnknown)
    ['{FECB6B1F-302E-4E9D-A472-11091DB69A9E}']
    function Run(const ZP: WideString; var ZP_Cert_SN: WideString; var ZP_Cert_IDN: WideString; 
                 const Sluzba: WideString; const DataIn: WideString; TimeOut: Smallint; 
                 var ID_Podani: SYSINT; var Chyba: WideString; var Varovani: WideString; 
                 var DataOut: WideString; var Debug_internal_warning: WideString; 
                 var Debug_XML_vyzva: WideString; var Debug_XML_odpoved: WideString): HResult; stdcall;
    function Init: HResult; stdcall;
    function SMSAuth(const ZP: WideString; var ZP_Cert_SN: WideString; var ZP_Cert_IDN: WideString; 
                     const Jmeno: WideString; const Heslo: WideString; TimeOut: Smallint; 
                     var ID_Podani: SYSINT; var Chyba: WideString; var Varovani: WideString; 
                     var DataOut: WideString; var Debug_internal_warning: WideString; 
                     var Debug_XML_vyzva: WideString; var Debug_XML_odpoved: WideString): HResult; stdcall;
    function SMSRun(const ZP: WideString; var ZP_Cert_SN: WideString; var ZP_Cert_IDN: WideString; 
                    const Sluzba: WideString; const DataIn: WideString; const Jmeno: WideString; 
                    const SMSKod: WideString; TimeOut: Smallint; var ID_Podani: SYSINT; 
                    var Chyba: WideString; var Varovani: WideString; var DataOut: WideString; 
                    var Debug_internal_warning: WideString; var Debug_XML_vyzva: WideString; 
                    var Debug_XML_odpoved: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoPZPDLL provides a Create and CreateRemote method to          
// create instances of the default interface IPZPDLL exposed by              
// the CoClass PZPDLL. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPZPDLL = class
    class function Create: IPZPDLL;
    class function CreateRemote(const MachineName: string): IPZPDLL;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TPZPDLL
// Help String      : PZPDLL version 2.3
// Default Interface: IPZPDLL
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TPZPDLLProperties= class;
{$ENDIF}
  TPZPDLL = class(TOleServer)
  private
    FIntf:        IPZPDLL;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TPZPDLLProperties;
    function      GetServerProperties: TPZPDLLProperties;
{$ENDIF}
    function      GetDefaultInterface: IPZPDLL;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPZPDLL);
    procedure Disconnect; override;
    function Run(const ZP: WideString; var ZP_Cert_SN: WideString; var ZP_Cert_IDN: WideString; 
                 const Sluzba: WideString; const DataIn: WideString; TimeOut: Smallint; 
                 var ID_Podani: SYSINT; var Chyba: WideString; var Varovani: WideString; 
                 var DataOut: WideString; var Debug_internal_warning: WideString; 
                 var Debug_XML_vyzva: WideString; var Debug_XML_odpoved: WideString): HResult;
    function Init: HResult;
    function SMSAuth(const ZP: WideString; var ZP_Cert_SN: WideString; var ZP_Cert_IDN: WideString; 
                     const Jmeno: WideString; const Heslo: WideString; TimeOut: Smallint; 
                     var ID_Podani: SYSINT; var Chyba: WideString; var Varovani: WideString; 
                     var DataOut: WideString; var Debug_internal_warning: WideString; 
                     var Debug_XML_vyzva: WideString; var Debug_XML_odpoved: WideString): HResult;
    function SMSRun(const ZP: WideString; var ZP_Cert_SN: WideString; var ZP_Cert_IDN: WideString; 
                    const Sluzba: WideString; const DataIn: WideString; const Jmeno: WideString; 
                    const SMSKod: WideString; TimeOut: Smallint; var ID_Podani: SYSINT; 
                    var Chyba: WideString; var Varovani: WideString; var DataOut: WideString; 
                    var Debug_internal_warning: WideString; var Debug_XML_vyzva: WideString; 
                    var Debug_XML_odpoved: WideString): HResult;
    property DefaultInterface: IPZPDLL read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TPZPDLLProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TPZPDLL
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TPZPDLLProperties = class(TPersistent)
  private
    FServer:    TPZPDLL;
    function    GetDefaultInterface: IPZPDLL;
    constructor Create(AServer: TPZPDLL);
  protected
  public
    property DefaultInterface: IPZPDLL read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoPZPDLL.Create: IPZPDLL;
begin
  Result := CreateComObject(CLASS_PZPDLL) as IPZPDLL;
end;

class function CoPZPDLL.CreateRemote(const MachineName: string): IPZPDLL;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PZPDLL) as IPZPDLL;
end;

procedure TPZPDLL.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{1C5A5C35-1409-40C5-8EDF-40AC6913E794}';
    IntfIID:   '{FECB6B1F-302E-4E9D-A472-11091DB69A9E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPZPDLL.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPZPDLL;
  end;
end;

procedure TPZPDLL.ConnectTo(svrIntf: IPZPDLL);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPZPDLL.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPZPDLL.GetDefaultInterface: IPZPDLL;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TPZPDLL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TPZPDLLProperties.Create(Self);
{$ENDIF}
end;

destructor TPZPDLL.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TPZPDLL.GetServerProperties: TPZPDLLProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TPZPDLL.Run(const ZP: WideString; var ZP_Cert_SN: WideString; var ZP_Cert_IDN: WideString; 
                     const Sluzba: WideString; const DataIn: WideString; TimeOut: Smallint; 
                     var ID_Podani: SYSINT; var Chyba: WideString; var Varovani: WideString; 
                     var DataOut: WideString; var Debug_internal_warning: WideString; 
                     var Debug_XML_vyzva: WideString; var Debug_XML_odpoved: WideString): HResult;
begin
  Result := DefaultInterface.Run(ZP, ZP_Cert_SN, ZP_Cert_IDN, Sluzba, DataIn, TimeOut, ID_Podani, 
                                 Chyba, Varovani, DataOut, Debug_internal_warning, Debug_XML_vyzva, 
                                 Debug_XML_odpoved);
end;

function TPZPDLL.Init: HResult;
begin
  Result := DefaultInterface.Init;
end;

function TPZPDLL.SMSAuth(const ZP: WideString; var ZP_Cert_SN: WideString; 
                         var ZP_Cert_IDN: WideString; const Jmeno: WideString; 
                         const Heslo: WideString; TimeOut: Smallint; var ID_Podani: SYSINT; 
                         var Chyba: WideString; var Varovani: WideString; var DataOut: WideString; 
                         var Debug_internal_warning: WideString; var Debug_XML_vyzva: WideString; 
                         var Debug_XML_odpoved: WideString): HResult;
begin
  Result := DefaultInterface.SMSAuth(ZP, ZP_Cert_SN, ZP_Cert_IDN, Jmeno, Heslo, TimeOut, ID_Podani, 
                                     Chyba, Varovani, DataOut, Debug_internal_warning, 
                                     Debug_XML_vyzva, Debug_XML_odpoved);
end;

function TPZPDLL.SMSRun(const ZP: WideString; var ZP_Cert_SN: WideString; 
                        var ZP_Cert_IDN: WideString; const Sluzba: WideString; 
                        const DataIn: WideString; const Jmeno: WideString; 
                        const SMSKod: WideString; TimeOut: Smallint; var ID_Podani: SYSINT; 
                        var Chyba: WideString; var Varovani: WideString; var DataOut: WideString; 
                        var Debug_internal_warning: WideString; var Debug_XML_vyzva: WideString; 
                        var Debug_XML_odpoved: WideString): HResult;
begin
  Result := DefaultInterface.SMSRun(ZP, ZP_Cert_SN, ZP_Cert_IDN, Sluzba, DataIn, Jmeno, SMSKod, 
                                    TimeOut, ID_Podani, Chyba, Varovani, DataOut, 
                                    Debug_internal_warning, Debug_XML_vyzva, Debug_XML_odpoved);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TPZPDLLProperties.Create(AServer: TPZPDLL);
begin
  inherited Create;
  FServer := AServer;
end;

function TPZPDLLProperties.GetDefaultInterface: IPZPDLL;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TPZPDLL]);
end;

end.

unit ManagerISDS_TLB;

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
// File generated on 14.9.2017 16:06:48 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\temp\isds\ManagerISDS.tlb (1)
// LIBID: {9C6377B0-E681-4156-94DC-E5471153923C}
// LCID: 0
// Helpfile: 
// HelpString: Spravce komunikace s DS
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
// Errors:
//   Error creating palette bitmap of (TISDSManager) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TLicenceService) : Server mscoree.dll contains no icons
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
  ManagerISDSMajorVersion = 2;
  ManagerISDSMinorVersion = 2;

  LIBID_ManagerISDS: TGUID = '{9C6377B0-E681-4156-94DC-E5471153923C}';

  IID__ISDSManager: TGUID = '{BBFC3BA1-03A4-345F-986F-43CC9933C13B}';
  IID__LicenceService: TGUID = '{FA90CA19-76E8-312B-857E-32EF54573273}';
  CLASS_ISDSManager: TGUID = '{A9FAD126-E2DD-3830-9F37-82F4998E3EF0}';
  CLASS_LicenceService: TGUID = '{0C3B7DD6-5E55-38CB-ADE8-808311FE31D3}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _ISDSManager = interface;
  _ISDSManagerDisp = dispinterface;
  _LicenceService = interface;
  _LicenceServiceDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ISDSManager = _ISDSManager;
  LicenceService = _LicenceService;


// *********************************************************************//
// Interface: _ISDSManager
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {BBFC3BA1-03A4-345F-986F-43CC9933C13B}
// *********************************************************************//
  _ISDSManager = interface(IDispatch)
    ['{BBFC3BA1-03A4-345F-986F-43CC9933C13B}']
    function Get_ToString: WideString; safecall;
    function Equals(obj: OleVariant): WordBool; safecall;
    function GetHashCode: Integer; safecall;
    function GetType: _Type; safecall;
    function NajdiSchrankuFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const fSchrankaID: WideString; const fLastName: WideString; 
                             const fLastNameBirth: WideString; fBirthDate: TDateTime; 
                             out vysledek: WideString; out errCode: WideString; 
                             out errMsg: WideString): WordBool; safecall;
    function NajdiSchrankuPFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                              const certifikat: WideString; prihlasit: WordBool; 
                              const fSchrankaID: WideString; const fIC: WideString; 
                              const fLastName: WideString; const fLastNameBirth: WideString; 
                              fBirthDate: TDateTime; const fTyp: WideString; 
                              out vysledek: WideString; out errCode: WideString; 
                              out errMsg: WideString): WordBool; safecall;
    function NajdiSchrankuPO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const fSchrankaID: WideString; const fIC: WideString; 
                             const fLastName: WideString; const fFirmaName: WideString; 
                             const fTyp: WideString; out vysledek: WideString; 
                             out errCode: WideString; out errMsg: WideString): WordBool; safecall;
    function NajdiSchrankuOVM(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                              const certifikat: WideString; prihlasit: WordBool; 
                              const fSchrankaID: WideString; const fIC: WideString; 
                              const fFirmaName: WideString; const fTyp: WideString; 
                              out vysledek: WideString; out errCode: WideString; 
                              out errMsg: WideString): WordBool; safecall;
    function DostupnostSchranky(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                const certifikat: WideString; prihlasit: WordBool; 
                                const fSchrankaID: WideString; out retCode: WideString; 
                                out retMsg: WideString): WordBool; safecall;
    function ZjistiPrijateZpravy(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 fZpravyDatumOd: TDateTime; fZpravyDatumDo: TDateTime; 
                                 fOrgJednotka: Integer; fFilter: Integer; fZaznamOd: Integer; 
                                 fZaznamLimit: Integer; out vysledek: WideString; 
                                 out retCode: WideString; out retMsg: WideString): WordBool; safecall;
    function ZjistiOdeslaneZpravy(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                  const certifikat: WideString; prihlasit: WordBool; 
                                  fZpravyDatumOd: TDateTime; fZpravyDatumDo: TDateTime; 
                                  fOrgJednotka: Integer; fFilter: Integer; fZaznamOd: Integer; 
                                  fZaznamLimit: Integer; out vysledek: WideString; 
                                  out retCode: WideString; out retMsg: WideString): WordBool; safecall;
    function ZjistiPrijateOdeslaneZpravy(test: WordBool; const jmeno: WideString; 
                                         const heslo: WideString; const certifikat: WideString; 
                                         prihlasit: WordBool; fZpravyDatumOd: TDateTime; 
                                         fZpravyDatumDo: TDateTime; fOrgJednotka: Integer; 
                                         fFilter: Integer; fZaznamOd: Integer; 
                                         fZaznamLimit: Integer; out vysledek: WideString; 
                                         out retCode: WideString; out retMsg: WideString): WordBool; safecall;
    function StahniZpravu(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; prihlasit: WordBool; 
                          const msgID: WideString; const filePath: WideString; 
                          out vysledek: WideString; out mappingNames: WideString; 
                          out retCode: WideString; out retMsg: WideString): WordBool; safecall;
    function StahniZpravuZFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const msgID: WideString; const filePath: WideString; 
                             out retCode: WideString; out retMsg: WideString): WordBool; safecall;
    function StahniOdeslanouZpravu(test: WordBool; const jmeno: WideString; 
                                   const heslo: WideString; const certifikat: WideString; 
                                   prihlasit: WordBool; const msgID: WideString; 
                                   const fileName: WideString; out retCode: WideString; 
                                   out retMsg: WideString): WordBool; safecall;
    function OznacZpravuPrectena(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 const msgID: WideString; out retCode: WideString; 
                                 out retMsg: WideString): WordBool; safecall;
    function OznacZpravuDorucena(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 const msgID: WideString; out retCode: WideString; 
                                 out retMsg: WideString): WordBool; safecall;
    function OdesliZpravu(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; prihlasit: WordBool; 
                          const schrankaPrijemce: WideString; const anotace: WideString; 
                          substDelivery: WordBool; legalTitleLaw: Integer; 
                          const legalTitlePar: WideString; const legalTitlePoint: WideString; 
                          const legalTitleSect: WideString; legalTitleYear: Integer; 
                          const recipientIdent: WideString; const recipientOrgUnit: WideString; 
                          recipientOrgUnitNum: Integer; const recipientRefNumber: WideString; 
                          const senderIdent: WideString; const senderOrgUnit: WideString; 
                          senderOrgUnitNum: Integer; const senderRefNumber: WideString; 
                          const toHands: WideString; personalDelivery: WordBool; ovm: WordBool; 
                          const fileList: WideString; out sendMessageID: WideString; 
                          out retCode: WideString; out retMsg: WideString): WordBool; safecall;
    function StahniDorucenku(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const msgID: WideString; out vysledek: WideString; 
                             out retCode: WideString; out retMsg: WideString): WordBool; safecall;
    function LoginMailbox(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; out retCode: WideString; 
                          out retMsg: WideString): WordBool; safecall;
    function LogoutMailbox: WordBool; safecall;
    function ExpiraceHesla(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                           const certifikat: WideString; prihlasit: WordBool; 
                           out ExpiraceHesla: WideString; out retCode: WideString; 
                           out retMsg: WideString): WordBool; safecall;
    function PrivilegiaUzivatele(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 out pristupUsr: WideString; out typeUsr: WideString; 
                                 out retCode: WideString; out retMsg: WideString): WordBool; safecall;
    property ToString: WideString read Get_ToString;
  end;

// *********************************************************************//
// DispIntf:  _ISDSManagerDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {BBFC3BA1-03A4-345F-986F-43CC9933C13B}
// *********************************************************************//
  _ISDSManagerDisp = dispinterface
    ['{BBFC3BA1-03A4-345F-986F-43CC9933C13B}']
    property ToString: WideString readonly dispid 0;
    function Equals(obj: OleVariant): WordBool; dispid 1610743809;
    function GetHashCode: Integer; dispid 1610743810;
    function GetType: _Type; dispid 1610743811;
    function NajdiSchrankuFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const fSchrankaID: WideString; const fLastName: WideString; 
                             const fLastNameBirth: WideString; fBirthDate: TDateTime; 
                             out vysledek: WideString; out errCode: WideString; 
                             out errMsg: WideString): WordBool; dispid 1610743812;
    function NajdiSchrankuPFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                              const certifikat: WideString; prihlasit: WordBool; 
                              const fSchrankaID: WideString; const fIC: WideString; 
                              const fLastName: WideString; const fLastNameBirth: WideString; 
                              fBirthDate: TDateTime; const fTyp: WideString; 
                              out vysledek: WideString; out errCode: WideString; 
                              out errMsg: WideString): WordBool; dispid 1610743813;
    function NajdiSchrankuPO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const fSchrankaID: WideString; const fIC: WideString; 
                             const fLastName: WideString; const fFirmaName: WideString; 
                             const fTyp: WideString; out vysledek: WideString; 
                             out errCode: WideString; out errMsg: WideString): WordBool; dispid 1610743814;
    function NajdiSchrankuOVM(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                              const certifikat: WideString; prihlasit: WordBool; 
                              const fSchrankaID: WideString; const fIC: WideString; 
                              const fFirmaName: WideString; const fTyp: WideString; 
                              out vysledek: WideString; out errCode: WideString; 
                              out errMsg: WideString): WordBool; dispid 1610743815;
    function DostupnostSchranky(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                const certifikat: WideString; prihlasit: WordBool; 
                                const fSchrankaID: WideString; out retCode: WideString; 
                                out retMsg: WideString): WordBool; dispid 1610743816;
    function ZjistiPrijateZpravy(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 fZpravyDatumOd: TDateTime; fZpravyDatumDo: TDateTime; 
                                 fOrgJednotka: Integer; fFilter: Integer; fZaznamOd: Integer; 
                                 fZaznamLimit: Integer; out vysledek: WideString; 
                                 out retCode: WideString; out retMsg: WideString): WordBool; dispid 1610743817;
    function ZjistiOdeslaneZpravy(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                  const certifikat: WideString; prihlasit: WordBool; 
                                  fZpravyDatumOd: TDateTime; fZpravyDatumDo: TDateTime; 
                                  fOrgJednotka: Integer; fFilter: Integer; fZaznamOd: Integer; 
                                  fZaznamLimit: Integer; out vysledek: WideString; 
                                  out retCode: WideString; out retMsg: WideString): WordBool; dispid 1610743818;
    function ZjistiPrijateOdeslaneZpravy(test: WordBool; const jmeno: WideString; 
                                         const heslo: WideString; const certifikat: WideString; 
                                         prihlasit: WordBool; fZpravyDatumOd: TDateTime; 
                                         fZpravyDatumDo: TDateTime; fOrgJednotka: Integer; 
                                         fFilter: Integer; fZaznamOd: Integer; 
                                         fZaznamLimit: Integer; out vysledek: WideString; 
                                         out retCode: WideString; out retMsg: WideString): WordBool; dispid 1610743819;
    function StahniZpravu(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; prihlasit: WordBool; 
                          const msgID: WideString; const filePath: WideString; 
                          out vysledek: WideString; out mappingNames: WideString; 
                          out retCode: WideString; out retMsg: WideString): WordBool; dispid 1610743820;
    function StahniZpravuZFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const msgID: WideString; const filePath: WideString; 
                             out retCode: WideString; out retMsg: WideString): WordBool; dispid 1610743821;
    function StahniOdeslanouZpravu(test: WordBool; const jmeno: WideString; 
                                   const heslo: WideString; const certifikat: WideString; 
                                   prihlasit: WordBool; const msgID: WideString; 
                                   const fileName: WideString; out retCode: WideString; 
                                   out retMsg: WideString): WordBool; dispid 1610743822;
    function OznacZpravuPrectena(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 const msgID: WideString; out retCode: WideString; 
                                 out retMsg: WideString): WordBool; dispid 1610743823;
    function OznacZpravuDorucena(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 const msgID: WideString; out retCode: WideString; 
                                 out retMsg: WideString): WordBool; dispid 1610743824;
    function OdesliZpravu(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; prihlasit: WordBool; 
                          const schrankaPrijemce: WideString; const anotace: WideString; 
                          substDelivery: WordBool; legalTitleLaw: Integer; 
                          const legalTitlePar: WideString; const legalTitlePoint: WideString; 
                          const legalTitleSect: WideString; legalTitleYear: Integer; 
                          const recipientIdent: WideString; const recipientOrgUnit: WideString; 
                          recipientOrgUnitNum: Integer; const recipientRefNumber: WideString; 
                          const senderIdent: WideString; const senderOrgUnit: WideString; 
                          senderOrgUnitNum: Integer; const senderRefNumber: WideString; 
                          const toHands: WideString; personalDelivery: WordBool; ovm: WordBool; 
                          const fileList: WideString; out sendMessageID: WideString; 
                          out retCode: WideString; out retMsg: WideString): WordBool; dispid 1610743825;
    function StahniDorucenku(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const msgID: WideString; out vysledek: WideString; 
                             out retCode: WideString; out retMsg: WideString): WordBool; dispid 1610743826;
    function LoginMailbox(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; out retCode: WideString; 
                          out retMsg: WideString): WordBool; dispid 1610743827;
    function LogoutMailbox: WordBool; dispid 1610743828;
    function ExpiraceHesla(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                           const certifikat: WideString; prihlasit: WordBool; 
                           out ExpiraceHesla: WideString; out retCode: WideString; 
                           out retMsg: WideString): WordBool; dispid 1610743829;
    function PrivilegiaUzivatele(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 out pristupUsr: WideString; out typeUsr: WideString; 
                                 out retCode: WideString; out retMsg: WideString): WordBool; dispid 1610743830;
  end;

// *********************************************************************//
// Interface: _LicenceService
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {FA90CA19-76E8-312B-857E-32EF54573273}
// *********************************************************************//
  _LicenceService = interface(IDispatch)
    ['{FA90CA19-76E8-312B-857E-32EF54573273}']
    function Get_ToString: WideString; safecall;
    function Equals(obj: OleVariant): WordBool; safecall;
    function GetHashCode: Integer; safecall;
    function GetType: _Type; safecall;
    function CheckService(const licNo: WideString; const programCode: WideString; 
                          const rok: WideString; out moduly: WideString): WordBool; safecall;
    property ToString: WideString read Get_ToString;
  end;

// *********************************************************************//
// DispIntf:  _LicenceServiceDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {FA90CA19-76E8-312B-857E-32EF54573273}
// *********************************************************************//
  _LicenceServiceDisp = dispinterface
    ['{FA90CA19-76E8-312B-857E-32EF54573273}']
    property ToString: WideString readonly dispid 0;
    function Equals(obj: OleVariant): WordBool; dispid 1610743809;
    function GetHashCode: Integer; dispid 1610743810;
    function GetType: _Type; dispid 1610743811;
    function CheckService(const licNo: WideString; const programCode: WideString; 
                          const rok: WideString; out moduly: WideString): WordBool; dispid 1610743812;
  end;

// *********************************************************************//
// The Class CoISDSManager provides a Create and CreateRemote method to          
// create instances of the default interface _ISDSManager exposed by              
// the CoClass ISDSManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoISDSManager = class
    class function Create: _ISDSManager;
    class function CreateRemote(const MachineName: string): _ISDSManager;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TISDSManager
// Help String      : 
// Default Interface: _ISDSManager
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TISDSManagerProperties= class;
{$ENDIF}
  TISDSManager = class(TOleServer)
  private
    FIntf: _ISDSManager;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TISDSManagerProperties;
    function GetServerProperties: TISDSManagerProperties;
{$ENDIF}
    function GetDefaultInterface: _ISDSManager;
  protected
    procedure InitServerData; override;
    function Get_ToString: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ISDSManager);
    procedure Disconnect; override;
    function Equals(obj: OleVariant): WordBool;
    function GetHashCode: Integer;
    function GetType: _Type;
    function NajdiSchrankuFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const fSchrankaID: WideString; const fLastName: WideString; 
                             const fLastNameBirth: WideString; fBirthDate: TDateTime; 
                             out vysledek: WideString; out errCode: WideString; 
                             out errMsg: WideString): WordBool;
    function NajdiSchrankuPFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                              const certifikat: WideString; prihlasit: WordBool; 
                              const fSchrankaID: WideString; const fIC: WideString; 
                              const fLastName: WideString; const fLastNameBirth: WideString; 
                              fBirthDate: TDateTime; const fTyp: WideString; 
                              out vysledek: WideString; out errCode: WideString; 
                              out errMsg: WideString): WordBool;
    function NajdiSchrankuPO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const fSchrankaID: WideString; const fIC: WideString; 
                             const fLastName: WideString; const fFirmaName: WideString; 
                             const fTyp: WideString; out vysledek: WideString; 
                             out errCode: WideString; out errMsg: WideString): WordBool;
    function NajdiSchrankuOVM(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                              const certifikat: WideString; prihlasit: WordBool; 
                              const fSchrankaID: WideString; const fIC: WideString; 
                              const fFirmaName: WideString; const fTyp: WideString; 
                              out vysledek: WideString; out errCode: WideString; 
                              out errMsg: WideString): WordBool;
    function DostupnostSchranky(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                const certifikat: WideString; prihlasit: WordBool; 
                                const fSchrankaID: WideString; out retCode: WideString; 
                                out retMsg: WideString): WordBool;
    function ZjistiPrijateZpravy(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 fZpravyDatumOd: TDateTime; fZpravyDatumDo: TDateTime; 
                                 fOrgJednotka: Integer; fFilter: Integer; fZaznamOd: Integer; 
                                 fZaznamLimit: Integer; out vysledek: WideString; 
                                 out retCode: WideString; out retMsg: WideString): WordBool;
    function ZjistiOdeslaneZpravy(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                  const certifikat: WideString; prihlasit: WordBool; 
                                  fZpravyDatumOd: TDateTime; fZpravyDatumDo: TDateTime; 
                                  fOrgJednotka: Integer; fFilter: Integer; fZaznamOd: Integer; 
                                  fZaznamLimit: Integer; out vysledek: WideString; 
                                  out retCode: WideString; out retMsg: WideString): WordBool;
    function ZjistiPrijateOdeslaneZpravy(test: WordBool; const jmeno: WideString; 
                                         const heslo: WideString; const certifikat: WideString; 
                                         prihlasit: WordBool; fZpravyDatumOd: TDateTime; 
                                         fZpravyDatumDo: TDateTime; fOrgJednotka: Integer; 
                                         fFilter: Integer; fZaznamOd: Integer; 
                                         fZaznamLimit: Integer; out vysledek: WideString; 
                                         out retCode: WideString; out retMsg: WideString): WordBool;
    function StahniZpravu(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; prihlasit: WordBool; 
                          const msgID: WideString; const filePath: WideString; 
                          out vysledek: WideString; out mappingNames: WideString; 
                          out retCode: WideString; out retMsg: WideString): WordBool;
    function StahniZpravuZFO(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const msgID: WideString; const filePath: WideString; 
                             out retCode: WideString; out retMsg: WideString): WordBool;
    function StahniOdeslanouZpravu(test: WordBool; const jmeno: WideString; 
                                   const heslo: WideString; const certifikat: WideString; 
                                   prihlasit: WordBool; const msgID: WideString; 
                                   const fileName: WideString; out retCode: WideString; 
                                   out retMsg: WideString): WordBool;
    function OznacZpravuPrectena(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 const msgID: WideString; out retCode: WideString; 
                                 out retMsg: WideString): WordBool;
    function OznacZpravuDorucena(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 const msgID: WideString; out retCode: WideString; 
                                 out retMsg: WideString): WordBool;
    function OdesliZpravu(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; prihlasit: WordBool; 
                          const schrankaPrijemce: WideString; const anotace: WideString; 
                          substDelivery: WordBool; legalTitleLaw: Integer; 
                          const legalTitlePar: WideString; const legalTitlePoint: WideString; 
                          const legalTitleSect: WideString; legalTitleYear: Integer; 
                          const recipientIdent: WideString; const recipientOrgUnit: WideString; 
                          recipientOrgUnitNum: Integer; const recipientRefNumber: WideString; 
                          const senderIdent: WideString; const senderOrgUnit: WideString; 
                          senderOrgUnitNum: Integer; const senderRefNumber: WideString; 
                          const toHands: WideString; personalDelivery: WordBool; ovm: WordBool; 
                          const fileList: WideString; out sendMessageID: WideString; 
                          out retCode: WideString; out retMsg: WideString): WordBool;
    function StahniDorucenku(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                             const certifikat: WideString; prihlasit: WordBool; 
                             const msgID: WideString; out vysledek: WideString; 
                             out retCode: WideString; out retMsg: WideString): WordBool;
    function LoginMailbox(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                          const certifikat: WideString; out retCode: WideString; 
                          out retMsg: WideString): WordBool;
    function LogoutMailbox: WordBool;
    function ExpiraceHesla(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                           const certifikat: WideString; prihlasit: WordBool; 
                           out ExpiraceHesla: WideString; out retCode: WideString; 
                           out retMsg: WideString): WordBool;
    function PrivilegiaUzivatele(test: WordBool; const jmeno: WideString; const heslo: WideString; 
                                 const certifikat: WideString; prihlasit: WordBool; 
                                 out pristupUsr: WideString; out typeUsr: WideString; 
                                 out retCode: WideString; out retMsg: WideString): WordBool;
    property DefaultInterface: _ISDSManager read GetDefaultInterface;
    property ToString: WideString read Get_ToString;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TISDSManagerProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TISDSManager
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TISDSManagerProperties = class(TPersistent)
  private
    FServer:    TISDSManager;
    function    GetDefaultInterface: _ISDSManager;
    constructor Create(AServer: TISDSManager);
  protected
    function Get_ToString: WideString;
  public
    property DefaultInterface: _ISDSManager read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoLicenceService provides a Create and CreateRemote method to          
// create instances of the default interface _LicenceService exposed by              
// the CoClass LicenceService. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoLicenceService = class
    class function Create: _LicenceService;
    class function CreateRemote(const MachineName: string): _LicenceService;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TLicenceService
// Help String      : 
// Default Interface: _LicenceService
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TLicenceServiceProperties= class;
{$ENDIF}
  TLicenceService = class(TOleServer)
  private
    FIntf: _LicenceService;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TLicenceServiceProperties;
    function GetServerProperties: TLicenceServiceProperties;
{$ENDIF}
    function GetDefaultInterface: _LicenceService;
  protected
    procedure InitServerData; override;
    function Get_ToString: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _LicenceService);
    procedure Disconnect; override;
    function Equals(obj: OleVariant): WordBool;
    function GetHashCode: Integer;
    function GetType: _Type;
    function CheckService(const licNo: WideString; const programCode: WideString; 
                          const rok: WideString; out moduly: WideString): WordBool;
    property DefaultInterface: _LicenceService read GetDefaultInterface;
    property ToString: WideString read Get_ToString;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TLicenceServiceProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TLicenceService
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TLicenceServiceProperties = class(TPersistent)
  private
    FServer:    TLicenceService;
    function    GetDefaultInterface: _LicenceService;
    constructor Create(AServer: TLicenceService);
  protected
    function Get_ToString: WideString;
  public
    property DefaultInterface: _LicenceService read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoISDSManager.Create: _ISDSManager;
begin
  Result := CreateComObject(CLASS_ISDSManager) as _ISDSManager;
end;

class function CoISDSManager.CreateRemote(const MachineName: string): _ISDSManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ISDSManager) as _ISDSManager;
end;

procedure TISDSManager.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A9FAD126-E2DD-3830-9F37-82F4998E3EF0}';
    IntfIID:   '{BBFC3BA1-03A4-345F-986F-43CC9933C13B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TISDSManager.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ISDSManager;
  end;
end;

procedure TISDSManager.ConnectTo(svrIntf: _ISDSManager);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TISDSManager.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TISDSManager.GetDefaultInterface: _ISDSManager;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TISDSManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TISDSManagerProperties.Create(Self);
{$ENDIF}
end;

destructor TISDSManager.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TISDSManager.GetServerProperties: TISDSManagerProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TISDSManager.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

function TISDSManager.Equals(obj: OleVariant): WordBool;
begin
  Result := DefaultInterface.Equals(obj);
end;

function TISDSManager.GetHashCode: Integer;
begin
  Result := DefaultInterface.GetHashCode;
end;

function TISDSManager.GetType: _Type;
begin
  Result := DefaultInterface.GetType;
end;

function TISDSManager.NajdiSchrankuFO(test: WordBool; const jmeno: WideString; 
                                      const heslo: WideString; const certifikat: WideString; 
                                      prihlasit: WordBool; const fSchrankaID: WideString; 
                                      const fLastName: WideString; 
                                      const fLastNameBirth: WideString; fBirthDate: TDateTime; 
                                      out vysledek: WideString; out errCode: WideString; 
                                      out errMsg: WideString): WordBool;
begin
  Result := DefaultInterface.NajdiSchrankuFO(test, jmeno, heslo, certifikat, prihlasit, 
                                             fSchrankaID, fLastName, fLastNameBirth, fBirthDate, 
                                             vysledek, errCode, errMsg);
end;

function TISDSManager.NajdiSchrankuPFO(test: WordBool; const jmeno: WideString; 
                                       const heslo: WideString; const certifikat: WideString; 
                                       prihlasit: WordBool; const fSchrankaID: WideString; 
                                       const fIC: WideString; const fLastName: WideString; 
                                       const fLastNameBirth: WideString; fBirthDate: TDateTime; 
                                       const fTyp: WideString; out vysledek: WideString; 
                                       out errCode: WideString; out errMsg: WideString): WordBool;
begin
  Result := DefaultInterface.NajdiSchrankuPFO(test, jmeno, heslo, certifikat, prihlasit, 
                                              fSchrankaID, fIC, fLastName, fLastNameBirth, 
                                              fBirthDate, fTyp, vysledek, errCode, errMsg);
end;

function TISDSManager.NajdiSchrankuPO(test: WordBool; const jmeno: WideString; 
                                      const heslo: WideString; const certifikat: WideString; 
                                      prihlasit: WordBool; const fSchrankaID: WideString; 
                                      const fIC: WideString; const fLastName: WideString; 
                                      const fFirmaName: WideString; const fTyp: WideString; 
                                      out vysledek: WideString; out errCode: WideString; 
                                      out errMsg: WideString): WordBool;
begin
  Result := DefaultInterface.NajdiSchrankuPO(test, jmeno, heslo, certifikat, prihlasit, 
                                             fSchrankaID, fIC, fLastName, fFirmaName, fTyp, 
                                             vysledek, errCode, errMsg);
end;

function TISDSManager.NajdiSchrankuOVM(test: WordBool; const jmeno: WideString; 
                                       const heslo: WideString; const certifikat: WideString; 
                                       prihlasit: WordBool; const fSchrankaID: WideString; 
                                       const fIC: WideString; const fFirmaName: WideString; 
                                       const fTyp: WideString; out vysledek: WideString; 
                                       out errCode: WideString; out errMsg: WideString): WordBool;
begin
  Result := DefaultInterface.NajdiSchrankuOVM(test, jmeno, heslo, certifikat, prihlasit, 
                                              fSchrankaID, fIC, fFirmaName, fTyp, vysledek, 
                                              errCode, errMsg);
end;

function TISDSManager.DostupnostSchranky(test: WordBool; const jmeno: WideString; 
                                         const heslo: WideString; const certifikat: WideString; 
                                         prihlasit: WordBool; const fSchrankaID: WideString; 
                                         out retCode: WideString; out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.DostupnostSchranky(test, jmeno, heslo, certifikat, prihlasit, 
                                                fSchrankaID, retCode, retMsg);
end;

function TISDSManager.ZjistiPrijateZpravy(test: WordBool; const jmeno: WideString; 
                                          const heslo: WideString; const certifikat: WideString; 
                                          prihlasit: WordBool; fZpravyDatumOd: TDateTime; 
                                          fZpravyDatumDo: TDateTime; fOrgJednotka: Integer; 
                                          fFilter: Integer; fZaznamOd: Integer; 
                                          fZaznamLimit: Integer; out vysledek: WideString; 
                                          out retCode: WideString; out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.ZjistiPrijateZpravy(test, jmeno, heslo, certifikat, prihlasit, 
                                                 fZpravyDatumOd, fZpravyDatumDo, fOrgJednotka, 
                                                 fFilter, fZaznamOd, fZaznamLimit, vysledek, 
                                                 retCode, retMsg);
end;

function TISDSManager.ZjistiOdeslaneZpravy(test: WordBool; const jmeno: WideString; 
                                           const heslo: WideString; const certifikat: WideString; 
                                           prihlasit: WordBool; fZpravyDatumOd: TDateTime; 
                                           fZpravyDatumDo: TDateTime; fOrgJednotka: Integer; 
                                           fFilter: Integer; fZaznamOd: Integer; 
                                           fZaznamLimit: Integer; out vysledek: WideString; 
                                           out retCode: WideString; out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.ZjistiOdeslaneZpravy(test, jmeno, heslo, certifikat, prihlasit, 
                                                  fZpravyDatumOd, fZpravyDatumDo, fOrgJednotka, 
                                                  fFilter, fZaznamOd, fZaznamLimit, vysledek, 
                                                  retCode, retMsg);
end;

function TISDSManager.ZjistiPrijateOdeslaneZpravy(test: WordBool; const jmeno: WideString; 
                                                  const heslo: WideString; 
                                                  const certifikat: WideString; 
                                                  prihlasit: WordBool; fZpravyDatumOd: TDateTime; 
                                                  fZpravyDatumDo: TDateTime; fOrgJednotka: Integer; 
                                                  fFilter: Integer; fZaznamOd: Integer; 
                                                  fZaznamLimit: Integer; out vysledek: WideString; 
                                                  out retCode: WideString; out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.ZjistiPrijateOdeslaneZpravy(test, jmeno, heslo, certifikat, prihlasit, 
                                                         fZpravyDatumOd, fZpravyDatumDo, 
                                                         fOrgJednotka, fFilter, fZaznamOd, 
                                                         fZaznamLimit, vysledek, retCode, retMsg);
end;

function TISDSManager.StahniZpravu(test: WordBool; const jmeno: WideString; 
                                   const heslo: WideString; const certifikat: WideString; 
                                   prihlasit: WordBool; const msgID: WideString; 
                                   const filePath: WideString; out vysledek: WideString; 
                                   out mappingNames: WideString; out retCode: WideString; 
                                   out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.StahniZpravu(test, jmeno, heslo, certifikat, prihlasit, msgID, 
                                          filePath, vysledek, mappingNames, retCode, retMsg);
end;

function TISDSManager.StahniZpravuZFO(test: WordBool; const jmeno: WideString; 
                                      const heslo: WideString; const certifikat: WideString; 
                                      prihlasit: WordBool; const msgID: WideString; 
                                      const filePath: WideString; out retCode: WideString; 
                                      out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.StahniZpravuZFO(test, jmeno, heslo, certifikat, prihlasit, msgID, 
                                             filePath, retCode, retMsg);
end;

function TISDSManager.StahniOdeslanouZpravu(test: WordBool; const jmeno: WideString; 
                                            const heslo: WideString; const certifikat: WideString; 
                                            prihlasit: WordBool; const msgID: WideString; 
                                            const fileName: WideString; out retCode: WideString; 
                                            out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.StahniOdeslanouZpravu(test, jmeno, heslo, certifikat, prihlasit, 
                                                   msgID, fileName, retCode, retMsg);
end;

function TISDSManager.OznacZpravuPrectena(test: WordBool; const jmeno: WideString; 
                                          const heslo: WideString; const certifikat: WideString; 
                                          prihlasit: WordBool; const msgID: WideString; 
                                          out retCode: WideString; out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.OznacZpravuPrectena(test, jmeno, heslo, certifikat, prihlasit, msgID, 
                                                 retCode, retMsg);
end;

function TISDSManager.OznacZpravuDorucena(test: WordBool; const jmeno: WideString; 
                                          const heslo: WideString; const certifikat: WideString; 
                                          prihlasit: WordBool; const msgID: WideString; 
                                          out retCode: WideString; out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.OznacZpravuDorucena(test, jmeno, heslo, certifikat, prihlasit, msgID, 
                                                 retCode, retMsg);
end;

function TISDSManager.OdesliZpravu(test: WordBool; const jmeno: WideString; 
                                   const heslo: WideString; const certifikat: WideString; 
                                   prihlasit: WordBool; const schrankaPrijemce: WideString; 
                                   const anotace: WideString; substDelivery: WordBool; 
                                   legalTitleLaw: Integer; const legalTitlePar: WideString; 
                                   const legalTitlePoint: WideString; 
                                   const legalTitleSect: WideString; legalTitleYear: Integer; 
                                   const recipientIdent: WideString; 
                                   const recipientOrgUnit: WideString; 
                                   recipientOrgUnitNum: Integer; 
                                   const recipientRefNumber: WideString; 
                                   const senderIdent: WideString; const senderOrgUnit: WideString; 
                                   senderOrgUnitNum: Integer; const senderRefNumber: WideString; 
                                   const toHands: WideString; personalDelivery: WordBool; 
                                   ovm: WordBool; const fileList: WideString; 
                                   out sendMessageID: WideString; out retCode: WideString; 
                                   out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.OdesliZpravu(test, jmeno, heslo, certifikat, prihlasit, 
                                          schrankaPrijemce, anotace, substDelivery, legalTitleLaw, 
                                          legalTitlePar, legalTitlePoint, legalTitleSect, 
                                          legalTitleYear, recipientIdent, recipientOrgUnit, 
                                          recipientOrgUnitNum, recipientRefNumber, senderIdent, 
                                          senderOrgUnit, senderOrgUnitNum, senderRefNumber, 
                                          toHands, personalDelivery, ovm, fileList, sendMessageID, 
                                          retCode, retMsg);
end;

function TISDSManager.StahniDorucenku(test: WordBool; const jmeno: WideString; 
                                      const heslo: WideString; const certifikat: WideString; 
                                      prihlasit: WordBool; const msgID: WideString; 
                                      out vysledek: WideString; out retCode: WideString; 
                                      out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.StahniDorucenku(test, jmeno, heslo, certifikat, prihlasit, msgID, 
                                             vysledek, retCode, retMsg);
end;

function TISDSManager.LoginMailbox(test: WordBool; const jmeno: WideString; 
                                   const heslo: WideString; const certifikat: WideString; 
                                   out retCode: WideString; out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.LoginMailbox(test, jmeno, heslo, certifikat, retCode, retMsg);
end;

function TISDSManager.LogoutMailbox: WordBool;
begin
  Result := DefaultInterface.LogoutMailbox;
end;

function TISDSManager.ExpiraceHesla(test: WordBool; const jmeno: WideString; 
                                    const heslo: WideString; const certifikat: WideString; 
                                    prihlasit: WordBool; out ExpiraceHesla: WideString; 
                                    out retCode: WideString; out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.ExpiraceHesla(test, jmeno, heslo, certifikat, prihlasit, 
                                           ExpiraceHesla, retCode, retMsg);
end;

function TISDSManager.PrivilegiaUzivatele(test: WordBool; const jmeno: WideString; 
                                          const heslo: WideString; const certifikat: WideString; 
                                          prihlasit: WordBool; out pristupUsr: WideString; 
                                          out typeUsr: WideString; out retCode: WideString; 
                                          out retMsg: WideString): WordBool;
begin
  Result := DefaultInterface.PrivilegiaUzivatele(test, jmeno, heslo, certifikat, prihlasit, 
                                                 pristupUsr, typeUsr, retCode, retMsg);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TISDSManagerProperties.Create(AServer: TISDSManager);
begin
  inherited Create;
  FServer := AServer;
end;

function TISDSManagerProperties.GetDefaultInterface: _ISDSManager;
begin
  Result := FServer.DefaultInterface;
end;

function TISDSManagerProperties.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

{$ENDIF}

class function CoLicenceService.Create: _LicenceService;
begin
  Result := CreateComObject(CLASS_LicenceService) as _LicenceService;
end;

class function CoLicenceService.CreateRemote(const MachineName: string): _LicenceService;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_LicenceService) as _LicenceService;
end;

procedure TLicenceService.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0C3B7DD6-5E55-38CB-ADE8-808311FE31D3}';
    IntfIID:   '{FA90CA19-76E8-312B-857E-32EF54573273}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TLicenceService.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _LicenceService;
  end;
end;

procedure TLicenceService.ConnectTo(svrIntf: _LicenceService);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TLicenceService.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TLicenceService.GetDefaultInterface: _LicenceService;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TLicenceService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TLicenceServiceProperties.Create(Self);
{$ENDIF}
end;

destructor TLicenceService.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TLicenceService.GetServerProperties: TLicenceServiceProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TLicenceService.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

function TLicenceService.Equals(obj: OleVariant): WordBool;
begin
  Result := DefaultInterface.Equals(obj);
end;

function TLicenceService.GetHashCode: Integer;
begin
  Result := DefaultInterface.GetHashCode;
end;

function TLicenceService.GetType: _Type;
begin
  Result := DefaultInterface.GetType;
end;

function TLicenceService.CheckService(const licNo: WideString; const programCode: WideString; 
                                      const rok: WideString; out moduly: WideString): WordBool;
begin
  Result := DefaultInterface.CheckService(licNo, programCode, rok, moduly);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TLicenceServiceProperties.Create(AServer: TLicenceService);
begin
  inherited Create;
  FServer := AServer;
end;

function TLicenceServiceProperties.GetDefaultInterface: _LicenceService;
begin
  Result := FServer.DefaultInterface;
end;

function TLicenceServiceProperties.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TISDSManager, TLicenceService]);
end;

end.

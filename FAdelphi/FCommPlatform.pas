unit FCommPlatform;

{
  Detekce platformy a výběr správné verze fcomm.exe
}

interface

uses
  Windows, SysUtils;

/// <summary>
/// Zjistí, zda běžíme na Windows 7 nebo starším
/// </summary>
function IsWindows7OrOlder: Boolean;

/// <summary>
/// Vrátí cestu k správné verzi fcomm.exe podle OS
/// </summary>
function GetFCommExePath: string;

/// <summary>
/// Vrátí název OS pro logging
/// </summary>
function GetWindowsVersionName: string;

implementation

function IsWindows7OrOlder: Boolean;
var
  VersionInfo: TOSVersionInfo;
begin
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  
  // Windows 10 = 10.0
  // Windows 8.1 = 6.3
  // Windows 8   = 6.2
  // Windows 7   = 6.1
  // Windows Vista = 6.0
  // Windows XP  = 5.x
  
  Result := (VersionInfo.dwMajorVersion < 6) or 
            ((VersionInfo.dwMajorVersion = 6) and (VersionInfo.dwMinorVersion <= 1));
end;

function GetFCommExePath: string;
var
  BasePath: string;
  Win7Path: string;
  Win10Path: string;
begin
  BasePath := ExtractFilePath(ParamStr(0));
  Win7Path := BasePath + 'fcomm-win7.exe';
  Win10Path := BasePath + 'fcomm.exe';
  
  if IsWindows7OrOlder then
  begin
    // Windows 7 nebo starší - použij .NET 6 verzi (32-bit)
    if FileExists(Win7Path) then
      Result := Win7Path
    else
    begin
      // Fallback: zkus standardní verzi (pravděpodobně nebude fungovat)
      if FileExists(Win10Path) then
        Result := Win10Path
      else
        raise Exception.Create('fcomm.exe nebyl nalezen. Očekávaná cesta: ' + Win7Path);
    end;
  end
  else
  begin
    // Windows 10/11 - použij .NET 9 verzi (64-bit)
    if FileExists(Win10Path) then
      Result := Win10Path
    else if FileExists(Win7Path) then
    begin
      // Fallback: použij Win7 verzi (bude fungovat, ale není optimální)
      Result := Win7Path;
    end
    else
      raise Exception.Create('fcomm.exe nebyl nalezen. Očekávaná cesta: ' + Win10Path);
  end;
end;

function GetWindowsVersionName: string;
var
  VersionInfo: TOSVersionInfo;
begin
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  
  case VersionInfo.dwMajorVersion of
    5: 
      case VersionInfo.dwMinorVersion of
        0: Result := 'Windows 2000';
        1: Result := 'Windows XP';
        2: Result := 'Windows Server 2003';
      else
        Result := 'Windows 5.x';
      end;
    6:
      case VersionInfo.dwMinorVersion of
        0: Result := 'Windows Vista';
        1: Result := 'Windows 7';
        2: Result := 'Windows 8';
        3: Result := 'Windows 8.1';
      else
        Result := 'Windows 6.x';
      end;
    10:
      Result := 'Windows 10/11';
  else
    Result := Format('Windows %d.%d', [VersionInfo.dwMajorVersion, VersionInfo.dwMinorVersion]);
  end;
end;

end.


unit FCommHttpClient;

interface

uses
  Classes, SysUtils, IdHTTP;

type
  /// <summary>
  /// HTTP klient pro komunikaci s fcomm API serverem
  /// </summary>
  TFCommHttpClient = class
  private
    FHTTP: TIdHTTP;
    FBaseUrl: string;
    FTimeout: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Zkontroluje, zda fcomm API server běží
    /// </summary>
    function HealthCheck: Boolean;
    
    /// <summary>
    /// Provede HTTP GET request
    /// </summary>
    function Get(const Endpoint: string): string;
    
    /// <summary>
    /// Provede HTTP POST request s JSON tělem
    /// </summary>
    function Post(const Endpoint, JsonBody: string): string;
    
    property BaseUrl: string read FBaseUrl write FBaseUrl;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

implementation

{ TFCommHttpClient }

constructor TFCommHttpClient.Create;
begin
  inherited Create;
  FBaseUrl := 'http://127.0.0.1:54321';
  FTimeout := 5000; // 5 sekund default
  
  // SSL handler není potřeba pro HTTP komunikaci na localhost
  FHTTP := TIdHTTP.Create(nil);
  FHTTP.Request.ContentType := 'application/json; charset=utf-8';
  FHTTP.Request.Accept := 'application/json';
  // Poznámka: CharSet property neexistuje v Indy 9 (Delphi 2007)
  // Charset je specifikován v ContentType výše
end;

destructor TFCommHttpClient.Destroy;
begin
  FHTTP.Free;
  inherited;
end;

function TFCommHttpClient.HealthCheck: Boolean;
var
  Response: string;
begin
  Result := False;
  try
    FHTTP.ReadTimeout := 300; // Krátký timeout pro health check
    FHTTP.ConnectTimeout := 300;
    Response := Get('/health');
    Result := Pos('"ok"', Response) > 0;
  except
    Result := False;
  end;
end;

function TFCommHttpClient.Get(const Endpoint: string): string;
var
  Response: TStringStream;
begin
  FHTTP.ReadTimeout := FTimeout;
  FHTTP.ConnectTimeout := FTimeout;
  
  Response := TStringStream.Create('');
  try
    FHTTP.Get(FBaseUrl + Endpoint, Response);
    Result := UTF8Decode(Response.DataString);
  finally
    Response.Free;
  end;
end;

function TFCommHttpClient.Post(const Endpoint, JsonBody: string): string;
var
  Request: TStringStream;
  Response: TStringStream;
begin
  FHTTP.ReadTimeout := FTimeout;
  FHTTP.ConnectTimeout := FTimeout;
  
  // Poznámka: V Delphi 2007 TStringStream nemá encoding parametr
  // UTF-8 konverze se musí provést ručně
  Request := TStringStream.Create(UTF8Encode(JsonBody));
  Response := TStringStream.Create('');
  try
    FHTTP.Post(FBaseUrl + Endpoint, Request, Response);
    Result := UTF8Decode(Response.DataString);
  finally
    Request.Free;
    Response.Free;
  end;
end;

end.



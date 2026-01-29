unit mfcr_utils;

interface

function FileToWideString(const FileName: String): WideString;
function Base64Decode(const InStr: String): String;
procedure Base64ToFile(const B64, FileName: WideString);
function XMLDecode(const XmlStr: String): String;

function BinaryFileToStringBase64(const AFileName: string): string;
procedure StringBase64ToBinaryFile(const AStrBase64, AFileName: string);

implementation

uses
  SysUtils, Classes, Windows, mfcr_consts, mfcr_resources, SynaCode;

function FileToWideString(const FileName: String): WideString;
var
  FS: TFileStream;
  Ptr: Pointer;
begin
  FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone); //#MR povolit sdileni bez omezeni
  //FS := TFileStream.Create(FileName, fmOpenRead);
  try
    SetLength(Result, (FS.Size + 1) div 2);
    FS.Read(Result[1], FS.Size);
    Ptr := Pointer(Integer(Pointer(Result)) - 4);
    PInteger(Ptr)^ := FS.Size;
  finally
    FS.Free;
  end;
end;

function Base64Decode(const InStr: String): String;
var
  I: Integer;
  InBuf: Array[0..3] of Byte;
  OutBuf: Array[0..2] of Byte;
  S: String;
  P: Integer;
begin
  Result := '';
  SetLength(S, Length(InStr));
  P := 1;
  for I := 1 to Length(InStr) do
    if InStr[I] > #32 then
      begin
        S[P] := InStr[I];
        Inc(P);
      end;
  SetLength(S, P - 1);
  if (Length(S) mod 4)<> 0 then
    raise Exception.Create(errExceptBase64Length);
  SetLength(Result,((Length(S) div 4) - 1) * 3);
  for I := 1 to ((Length(S) div 4) - 1) do
    begin
      Move(S[(I-1) * 4 + 1], InBuf, 4);
      if (InBuf[0] > 64) and (InBuf[0] < 91) then
        Dec(InBuf[0], 65)
      else
        if (InBuf[0] > 96) and (InBuf[0] < 123) then
          Dec(InBuf[0], 71)
        else
          if (InBuf[0] > 47) and (InBuf[0] < 58) then
            Inc(InBuf[0], 4)
          else
            if InBuf[0] = 43 then
              InBuf[0] := 62
            else
              InBuf[0] := 63;
      if (InBuf[1] > 64) and (InBuf[1] < 91) then
        Dec(InBuf[1],65)
      else
        if (InBuf[1] > 96) and (InBuf[1] < 123) then
          Dec(InBuf[1], 71)
        else
          if (InBuf[1] > 47) and (InBuf[1] < 58) then
            Inc(InBuf[1], 4)
          else
            if InBuf[1] = 43 then
              InBuf[1] := 62
            else
              InBuf[1] := 63;
      if (InBuf[2] > 64) and (InBuf[2] < 91) then
        Dec(InBuf[2],65)
      else
        if (InBuf[2] > 96) and (InBuf[2] < 123) then
          Dec(InBuf[2], 71)
        else
          if (InBuf[2] > 47) and (InBuf[2] < 58) then
            Inc(InBuf[2], 4)
          else
            if InBuf[2] = 43 then
              InBuf[2] := 62
            else
              InBuf[2] := 63;
      if (InBuf[3] > 64) and (InBuf[3] < 91) then
        Dec(InBuf[3],65)
      else
        if (InBuf[3] > 96) and (InBuf[3] < 123) then
          Dec(InBuf[3], 71)
        else
          if (InBuf[3] > 47) and (InBuf[3] < 58) then
            Inc(InBuf[3], 4)
          else
            if InBuf[3] = 43 then
              InBuf[3] := 62
            else
              InBuf[3] := 63;
      OutBuf[0] := (InBuf[0] shl 2) or ((InBuf[1] shr 4) and $03);
      OutBuf[1] := (InBuf[1] shl 4) or ((InBuf[2] shr 2) and $0F);
      OutBuf[2] := (InBuf[2] shl 6) or (InBuf[3] and $3F);
      Move(OutBuf,Result[(I-1) * 3 + 1], 3);
    end;
  if Length(S) <> 0 then
    begin
      Move(S[Length(S)-3],InBuf,4);
      if InBuf[2]= 61 then
        begin
          if (InBuf[0]> 64) and (InBuf[0]< 91) then
            Dec(InBuf[0],65)
          else if (InBuf[0]> 96) and (InBuf[0]< 123) then
            Dec(InBuf[0],71)
          else if (InBuf[0]> 47) and (InBuf[0]< 58) then
            Inc(InBuf[0],4)
          else if InBuf[0]= 43 then
            InBuf[0]:= 62
          else
            InBuf[0]:= 63;
          if (InBuf[1]> 64) and (InBuf[1]< 91) then
            Dec(InBuf[1],65)
          else if (InBuf[1]> 96) and (InBuf[1]< 123) then
            Dec(InBuf[1],71)
          else if (InBuf[1]> 47) and (InBuf[1]< 58) then
            Inc(InBuf[1],4)
          else if InBuf[1]= 43 then
            InBuf[1]:= 62
          else
            InBuf[1]:= 63;
          OutBuf[0]:= (InBuf[0] shl 2) or ((InBuf[1] shr 4) and $03);
          Result:= Result + char(OutBuf[0]);
        end
      else
        if InBuf[3]= 61 then
          begin
            if (InBuf[0] > 64) and (InBuf[0] < 91) then
              Dec(InBuf[0], 65)
            else
              if (InBuf[0] > 96) and (InBuf[0] < 123) then
                Dec(InBuf[0], 71)
              else
                if (InBuf[0] > 47) and (InBuf[0] < 58) then
                  Inc(InBuf[0], 4)
                else
                  if InBuf[0] = 43 then
                    InBuf[0] := 62
                  else
                    InBuf[0] := 63;
            if (InBuf[1] > 64) and (InBuf[1] < 91) then
              Dec(InBuf[1], 65)
            else
              if (InBuf[1] > 96) and (InBuf[1] < 123) then
                Dec(InBuf[1], 71)
              else
                if (InBuf[1] > 47) and (InBuf[1] < 58) then
                  Inc(InBuf[1], 4)
                else
                  if InBuf[1] = 43 then
                    InBuf[1] := 62
                  else
                    InBuf[1] := 63;
            if (InBuf[2] > 64) and (InBuf[2] < 91) then
              Dec(InBuf[2], 65)
            else
              if (InBuf[2] > 96) and (InBuf[2] < 123) then
                Dec(InBuf[2], 71)
              else
                if (InBuf[2] > 47) and (InBuf[2] < 58) then
                  Inc(InBuf[2], 4)
                else
                  if InBuf[2] = 43 then
                    InBuf[2] := 62
                  else
                    InBuf[2] := 63;
            OutBuf[0] := (InBuf[0] shl 2) or ((InBuf[1] shr 4) and $03);
            OutBuf[1] := (InBuf[1] shl 4) or ((InBuf[2] shr 2) and $0F);
            Result := Result + char(OutBuf[0]) + char(OutBuf[1]);
          end
        else
          begin
            if (InBuf[0] > 64) and (InBuf[0] < 91) then
              Dec(InBuf[0], 65)
            else
              if (InBuf[0] > 96) and (InBuf[0] < 123) then
                Dec(InBuf[0], 71)
              else
                if (InBuf[0] > 47) and (InBuf[0] < 58) then
                  Inc(InBuf[0], 4)
                else
                  if InBuf[0] = 43 then
                    InBuf[0] := 62
                  else
                    InBuf[0] := 63;
            if (InBuf[1] > 64) and (InBuf[1] < 91) then
              Dec(InBuf[1], 65)
            else
              if (InBuf[1] > 96) and (InBuf[1] < 123) then
                Dec(InBuf[1], 71)
              else
                if (InBuf[1] > 47) and (InBuf[1] < 58) then
                  Inc(InBuf[1], 4)
                else
                  if InBuf[1] = 43 then
                    InBuf[1] := 62
                  else
                    InBuf[1] := 63;
            if (InBuf[2] > 64) and (InBuf[2] < 91) then
              Dec(InBuf[2], 65)
            else
              if (InBuf[2] > 96) and (InBuf[2] < 123) then
                Dec(InBuf[2], 71)
              else
                if (InBuf[2] > 47) and (InBuf[2] < 58) then
                  Inc(InBuf[2], 4)
                else
                  if InBuf[2] = 43 then
                    InBuf[2] := 62
                  else
                    InBuf[2] := 63;
            if (InBuf[3] > 64) and (InBuf[3] < 91) then
              Dec(InBuf[3], 65)
            else
              if (InBuf[3] > 96) and (InBuf[3] < 123) then
                Dec(InBuf[3], 71)
              else
                if (InBuf[3] > 47) and (InBuf[3] < 58) then
                  Inc(InBuf[3], 4)
                else
                  if InBuf[3] = 43 then
                    InBuf[3] := 62
                  else
                    InBuf[3] := 63;
            OutBuf[0] := (InBuf[0] shl 2) or ((InBuf[1] shr 4) and $03);
            OutBuf[1] := (InBuf[1] shl 4) or ((InBuf[2] shr 2) and $0F);
            OutBuf[2] := (InBuf[2] shl 6) or (InBuf[3] and $3F);
            Result := Result + Char(OutBuf[0]) + Char(OutBuf[1]) + Char(OutBuf[2]);
          end;
    end;
end;

procedure Base64ToFile(const B64, FileName: WideString);
var
  FS: TFileStream;
  S: String;
begin
  FS := TFileStream.Create(FileName, fmCreate);
  try
    S := Base64Decode(B64);
    FS.Write(S[1], Length(S));
  finally
    FS.Free;
  end;
end;

function ReplaceString(const InputStr, OldString, NewString: String): String;
var
  S: String;
  Index: Integer;
begin
  Result := '';
  S := InputStr;
  repeat
    Index := Pos(LowerCase(OldString), LowerCase(S));
    if Index > 0 then
      begin
        Result := Result + Copy(S, 1, Index - 1) + NewString;
        S := Copy(S, Index + Length(OldString), Length(S) - Index - Length(OldString) + 1);
      end;
  until Index < 1;
  Result := Result + S;
end;

function XMLDecode(const XmlStr: String): String;
var
  I: Integer;
begin
  Result := XmlStr;
  for I := Low(XMLReplaceStrings) to High(XMLReplaceStrings) do
    Result := ReplaceString(Result, XMLReplaceStrings[I].O, XMLReplaceStrings[I].N);
end;

function BinaryFileToString(const AFileName: string): string;
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(AFileName, fmOpenRead);
  try
    SetLength(Result, fs.Size);
    fs.Read(Result[1], fs.Size);
  finally
    fs.Free;
  end;
end;

procedure StringToBinaryFile(const AFileName: string;
  const ADataString: string);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(AFileName, fmCreate);
  try
    fs.Write(ADataString[1], Length(ADataString));
  finally
    fs.Free;
  end;
end;

function BinaryFileToStringBase64(const AFileName: string): string;
begin
  Result:=EncodeBase64(BinaryFileToString(AFileName));
end;

procedure StringBase64ToBinaryFile(const AStrBase64, AFileName: string);
begin
  StringToBinaryFile(AFileName, DecodeBase64(AStrBAse64));
end;

end.


unit MyUtils;

interface

uses Windows, SysUtils, Forms;

function GetAppVersionStr: string; overload;
function GetAppVersionStr(major, minor, release, build: boolean): string; overload;
procedure GetAppVersion(var major, minor, release, build: LongWord);

implementation

function GetAppVersionStr: string;
var mj, mn, r, b: longword;
begin
  GetAppVersion(mj,mn,r,b);
  Result:=
    IntToStr(mj)+'.'+
    IntToStr(mn)+'.'+
    IntToStr(r)+'.'+
    IntToStr(b);
end;

function GetAppVersionStr(major,minor,release,build: boolean): string;
var mj, mn, r, b: longword;
begin
  GetAppVersion(mj,mn,r,b);
  result:= '';
  if major then
    Result:= IntToStr(mj);
  if minor then
    Result:= Result+'.'+IntToStr(mn);
  if release then
    Result:= Result+'.'+IntToStr(r);
  if build then
    Result:= Result+'.'+IntToStr(b);
end;

procedure GetAppVersion(var major,minor,release,build: LongWord);
var
  VIHandle : Cardinal;
  VSize : LongInt;
  VData : Pointer;
  Len : LongWord;
  FileName : PChar;
  Info: ^VS_FIXEDFILEINFO;
begin
  FileName := PChar(Application.EXEName);
  VSize := GetFileVersionInfoSize(FileName, VIHandle);
  if (VSize>0) then
  begin
    GetMem(VData, VSize);
    try
      if GetFileVersionInfo(FileName, VIHandle, VSize, VData) Then
        if VerQueryValue(VData,'\',pointer(Info),Len) then
        begin
          major:= Info^.dwFileVersionMS and $FFFF0000 shr 16;
          minor:= Info^.dwFileVersionMS and $FFFF;
          release:= Info^.dwFileVersionLS and $FFFF0000 shr 16;
          build:= Info^.dwFileVersionLS and $FFFF;
        end;
    finally
      FreeMem(VData, VSize);
    end;
  end; 
end;

end.

unit pars;

interface

uses
  Sysutils;

type
  TSyntaxError = class of Exception;

function ProcessString(s: string): string;

implementation

type
  TEventProc = procedure(var s, code: string; ch: char);

const
  cQuote  = #39;
  sfError = 'Ошибка при синтаксическом анализе (строка %%d, столбец %d)';
  MaxCode = 255;

const
  ParsTable : array [0..8,0..3] of smallint = (
            { '  A  #  1}
{за текст 0}( 1, 0, 4, 0),
{нач стр  1}( 3, 2, 2, 2),
{стр      2}( 3, 2, 2, 2),
{кон стр  3}( 1, 0, 6, 0),
{нач 0код 4}( 6, 6, 6, 5),
{0код     5}( 1, 0, 5, 5),
{нач 3код 6}( 6, 6, 6, 7),
{3код     7}( 1, 0, 7, 7),
{ошибка   8}( -1, -1, -1, -1)
  );

{ Events handlers }
procedure WriteChar(var s, code: string; ch: char); forward;
procedure BuffChar(var s, code: string; ch: char); forward;
procedure e31(var s, code: string; ch: char); forward;
procedure e36(var s, code: string; ch: char); forward;
procedure AddCode(var s, code: string; ch: char); forward;
procedure e51(var s, code: string; ch: char); forward;
procedure e50(var s, code: string; ch: char); forward;
procedure e55(var s, code: string; ch: char); forward;
procedure BuffCode(var s, code: string; ch: char); forward;
procedure e91(var s, code: string; ch: char); forward;
procedure e90(var s, code: string; ch: char); forward;
procedure e99(var s, code: string; ch: char); forward;
procedure NOP(var s, code: string; ch: char); forward;
procedure ERR(var s, code: string; ch: char); forward;

{ Event conditions }
const
  EventTable: array [0..8,0..3] of TEventProc = (
          {'   A  #  1}
{за текст}( WriteChar,  WriteChar,      NOP,            WriteChar),
{нач стр }( WriteChar,  WriteChar,      WriteChar,      WriteChar),
{стр     }( BuffChar,   WriteChar,      WriteChar,      WriteChar),
{кон стр }( e31,        e31,            e36,            e31),
{нач 0код}( ERR,        ERR,            ERR,            AddCode),
{0код    }( e51,        e50,            e55,            AddCode),
{нач 3код}( ERR,        ERR,            ERR,            AddCode),
{3код    }( e91,        e90,            e99,            AddCode),
{ошибка  }( NOP,        NOP,            NOP,            NOP)
  );

var
  buffer: string;


{ Used about EventTable }
function CharToCol(ch: char): integer;
begin
  case ch of
    cQuote: result:= 0;
    '#': result:= 2;
    '0'..'9': result:= 3;
    else result:= 1;
  end;
end;

{}
function CodeToChar(const code: string): char; overload;
begin
  result:= string(WideChar(StrToInt(Code)))[1];
end;

function CodeToChar(const code: integer): char; overload;
begin
  result:= string(WideChar(code))[1];
end;

function IsUnicode(const code: string): boolean; overload;
begin
  result:= StrToInt(code)>MaxCode;
end;

function IsUnicode(const code: integer): boolean; overload;
begin
  result:= code>MaxCode;
end;


{ Stack routines }
procedure push(ch: char);
begin
  buffer:= buffer+ch;
end;

function peek: char;
begin
  result:= buffer[1];
end;

function pop: char;
begin
  if Length(buffer)<>0 then begin
    result:= peek;
    Delete(buffer,1,1);
  end else result:= #0;
end;

function popall: string;
begin
  result:= buffer;
  buffer:= '';
end;

{ Event routines }

procedure WriteString(var dest: string; const source: string);
begin
  dest:= dest+source;
end;

procedure WriteChar(var s, code: string; ch: char);
begin
  s:= s+ch;
end;

procedure BuffChar(var s, code: string; ch: char);
begin
  push(ch);
end;

procedure e31(var s, code: string; ch: char);
begin
  if Length(buffer)<>0 then
    WriteChar(s,code,pop);
  WriteChar(s,code,ch);
end;

procedure e36(var s, code: string; ch: char);
begin
  pop;
end;

procedure AddCode(var s, code: string; ch: char);
begin
  code:= code+ch;
end;

procedure e51(var s, code: string; ch: char);
begin
  if IsUnicode(code) then begin
    BuffCode(s,code,ch);
    WriteChar(s,code,cQuote);
    WriteString(s,popall);
  end else begin
    if Length(buffer)<>0 then begin
      WriteChar(s,code,cQuote);
      WriteString(s,popall);
      WriteChar(s,code,cQuote);
    end;
    WriteString(s,'#'+code);
    code:= '';
    WriteChar(s,code,cQuote);
  end;
end;

procedure e50(var s, code: string; ch: char);
begin
  if IsUnicode(code) then begin
    BuffCode(s,code,ch);
    WriteChar(s,code,cQuote);
    WriteString(s,popall);
    WriteChar(s,code,cQuote);
  end else begin
    if Length(buffer)<>0 then begin
      WriteChar(s,code,cQuote);
      WriteString(s,popall);
      WriteChar(s,code,cQuote);
    end;
    WriteString(s,'#'+code);
    code:= '';
  end;
  WriteChar(s,code,ch);
end;

procedure e55(var s, code: string; ch: char);
begin
  if IsUnicode(code) then begin
    BuffCode(s,code,ch);
  end else begin
    if Length(buffer)<>0 then begin
      WriteChar(s,code,cQuote);
      WriteString(s,popall);
      WriteChar(s,code,cQuote);
    end;
    WriteString(s,'#'+code);
    code:= '';
  end;
end;

procedure BuffCode(var s, code: string; ch: char);
begin
  push(CodeToChar(code));
  code:= '';
end;

procedure e91(var s, code: string; ch: char);
begin
  if IsUnicode(code) then begin
    BuffCode(s,code,ch);
    WriteString(s,popall);
  end else begin
    if (Length(buffer)<>0)and not(buffer=cQuote) then
      WriteString(s,popall);
    if buffer=cQuote then
      pop
    else
      WriteChar(s,code,cQuote);
    WriteString(s,'#'+code);
    code:= '';
    WriteChar(s,code,cQuote);
  end;
end;

procedure e90(var s, code: string; ch: char);
begin
  if IsUnicode(code) then begin
    BuffCode(s,code,ch);
    WriteString(s,popall);
    WriteChar(s,code,cQuote);
  end else begin
    if (Length(buffer)<>0)and not(buffer=cQuote) then
      WriteString(s,popall);
    if buffer=cQuote then
      pop
    else
      WriteChar(s,code,cQuote);
    WriteString(s,'#'+code);
    code:= '';
  end;
  WriteChar(s,code,ch);
end;

procedure e99(var s, code: string; ch: char);
begin
  if IsUnicode(code) then begin
    BuffCode(s,code,ch);
  end else begin
    if (Length(buffer)<>0)and not(buffer=cQuote) then
      WriteString(s,popall);
    if buffer=cQuote then
      pop
    else
      WriteChar(s,code,cQuote);
    WriteString(s,'#'+code);
    code:= '';
    BuffChar(s,code,cQuote);
  end;
end;

procedure NOP(var s, code: string; ch: char);
begin
end;

procedure ERR(var s, code: string; ch: char);
begin
  raise Exception.Create('');
end;


{ Main function }
function ProcessString(s: string): string;
var
  i: integer;
  code, buffer: string;
  cond: smallint;
  Len: integer;
  col: integer;
begin
  try
    { инициализация переменных }
    result:= ''; code:= ''; buffer:= '';
    Len:= Length(s);
    cond:= 0;
    i:= 1;
    { гл. цикл }
    while i<=Len do begin
      col:= CharToCol(s[i]);
      EventTable[cond,col](result,code,s[i]);
      cond:= ParsTable[cond,col];
      if i=Len then begin
        col:= 1;
        EventTable[cond,col](result,code,#0);
      end;
      inc(i);
    end;
    SetLength(result,Length(result)-1);
  except
    raise Exception.Create(Format(sfError,[i]));
  end
end;

end.

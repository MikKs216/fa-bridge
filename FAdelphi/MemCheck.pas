{
SilverStream How To: Checking if application leaks memory
---------------------------------------------------------
http://www.dystopia.fi/~janij/techinfo/memleak.htm

Copyright (C) 1997 Jani J„rvinen.

You may freely use the code for this application. You may also
redistribute this packet as a whole, provided that nothing is modified,
and that no money is charged. Partitial distribution is not permitted. if
you use the code or parts of it in your own productions, credits would
be nice.

Warranty: This code is provided "as-is". There is no warranty of any
kind. Use at your own risk.
}
unit MemCheck;

{$I Switches.inc}

interface

procedure SaveAllocationState;
function RestoreAllocationState: Integer;

implementation

uses Windows;

const
  AllocationStackSize = 10;

type
  TAllocationStack = array[1..AllocationStackSize] of integer;

var
  HeapStatus: THeapStatus;
  AllocationStack: TAllocationStack;
  StackCounter: Integer;

function IntToStr(I: Integer): string;
begin
  Str(I, Result);
end;

procedure SaveAllocationState;
begin
  if (StackCounter < AllocationStackSize) then begin
    Inc(StackCounter);
    HeapStatus := GetHeapStatus;
    AllocationStack[StackCounter] := HeapStatus.TotalAllocated;
  end
  else begin
    MessageBox(0, PChar('Cannot save more than ' +
      IntToStr(AllocationStackSize) + ' states.'),
      'MemCheck', mb_OK or mb_IconExclamation);
  end;
end;

function RestoreAllocationState: Integer;
begin
  if (StackCounter > 0) then begin
    HeapStatus := GetHeapStatus;
    Result := integer(HeapStatus.TotalAllocated) -
      AllocationStack[StackCounter];
    Dec(StackCounter);
  end
  else begin
    MessageBox(0, 'Cannot restore state when no items are saved.',
      'MemCheck', mb_OK or mb_IconExclamation);
    Result := -1;
  end;
end;

var
  Leak: Integer;
  HS: THEapStatus;

initialization
  HS := GetHeapStatus;

  if HS.TotalAllocated<>0 then begin
    MessageBox(0, 'Unit MemCheck musí být uveden jako první',
    'Chybné poøadí v USES sekci', 0);
    halt(0);
  end;
  

finalization
{$IFDEF MEMCHECK}
  HeapStatus := GetHeapStatus;
  Leak := HeapStatus.TotalAllocated;
  if (Leak > 1768) then //Mik 1768 vnasi pouzite komponenty
    MessageBox(0, PChar('Your application leaks ' + IntToStr(Leak-1768) + ' bytes.'),
      'Memory Leak', mb_OK or mb_IconExclamation);
{$ENDIF MEMCHECK}
end.

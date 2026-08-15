{% init bundle %}
{% term bundle %}

{% init switchs %}
{$mode delphi}
{$modeswitch TypeHelpers}
{$modeswitch AdvancedRecords}
{$macro on}
{% term switchs %}

{% init defines %}
{% term defines %}

{% init guards %}
{$ifndef OPX_LIBRARY}
    {$ifndef OPX_PROGRAM}
        {$define OPX_UNIT}
    {$endif}
{$endif}

{$ifndef OPX_UNIT}
    {$define OPX_PROGRAM_OR_LIBRARY}
{$endif}

{$ifndef OPX_MODULE_NAME}
    {$define OPX_MODULE_NAME := opx}
{$endif}

{$ifndef OPX_HAS_MAIN}
    {$define OPX_NOT_HAS_MAIN}
{$endif}
{% term guards %}

{$ifdef OPX_LIBRARY} library {$endif}
{$ifdef OPX_PROGRAM} program {$endif}
{$ifdef OPX_UNIT} unit {$endif} OPX_MODULE_NAME;

{% init macros %}
{$define i8 := Int8}
{$define i16 := Int16}
{$define i32 := Int32}
{$define i64 := Int64}
{$define u8 := UInt8}
{$define u16 := UInt16}
{$define u32 := UInt32}
{$define u64 := UInt64}
{$define f32 := Single}
{$define f64 := Double}
{$define isize := SizeInt}
{$define usize := SizeUInt}
{$define rune := Ucs4Char}
{% term macros %}


{$ifdef OPX_UNIT}
interface
{$endif}

uses
    {% init uses_global_system %}
    {% term uses_global_system %}
    SysUtils,
    {$ifdef OPX_TESTS}
    FpcUnit, TestRegistry,
        {$ifdef OPX_TESTS_RUNNER}
        ConsoleTestRunner, TestReport,
    {$endif}
    {$endif}
    {% init uses_global_custom %}
    {% term uses_global_custom %}
    Classes;

{% init interface %}
{% term interface %}

procedure Test; {$ifdef OPX_PROGRAM_OR_LIBRARY} forward; {$endif}

{$ifdef OPX_UNIT}
implementation
{$endif}

{% init uses_local %}
{% term uses_local %}

{% init implementation %}
{% term implementation %}

procedure Init;
begin
{% init initialization %}
{% term initialization %}
end;

procedure Term;
begin
{% init finalization %}
{% term finalization %}
end;

procedure Test;
{$ifdef OPX_TESTS_RUNNER}
var
    TestRunner : TTestRunner;
{$endif}
begin
{$ifdef OPX_TESTS_RUNNER}
    DefaultFormat := fPlain;
    DefaultRunAllTests := True;

    Writeln;
    Writeln('=============================');
    Writeln('TEST RUNNER - Unit Test Suite');
    Writeln('=============================');
    Writeln;

    TestRunner := TTestRunner.Create(nil);
    try
        TestRunner.Initialize;
        TestRunner.Title := 'TEST RUNNER - Test Suite';
        TestRunner.Run;
    finally
        TestRunner.Free;
    end;
{$endif}
end;

{$ifdef OPX_NOT_HAS_MAIN}
procedure Main;
begin
    Writeln('Hello OPX!');
end;
{$endif}

{$ifdef OPX_PROGRAM_OR_LIBRARY}
begin
    {$ifdef OPX_LIBRARY} AddExitProc(@Term); {$endif}
    Init;
    {$ifdef OPX_PROGRAM}
        {$ifdef OPX_TESTS} Test {$else} Main {$endif};
        Term;
    {$endif}
{$endif}
end.
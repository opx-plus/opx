(*********************************************************
  builder -- the OPX build tool.

  Standalone, plain Pascal. Knows nothing of OPX's architecture
  (WIRTH, QWERT, BOROS, ...). Its only job: read /code and project
  every published artifact out of it.

    /code  --(builder)-->  dist/opx.pas
                           README.md
                           CONTRIBUTING.md
                           /docs
                           /tests
                           /examples
**********************************************************)

{% init bundle %}
{% term bundle %}

{% init switchs %}
{$mode delphi}
{$modeswitch TypeHelpers}
{$modeswitch AdvancedRecords}
{$macro on}
{% term switchs %}

{% init defines %}
{$define OPX_MODULE_NAME := build}
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
    TypInfo,
    {% term uses_global_custom %}
    Classes;

{% init interface %}
const
    DIR_CODE = 'code';
    DIR_DIST = 'dist';
    FILE_TEMPLATE = 'code' + PathDelim + 'main.pas';
    FILE_OPX = 'dist' + PathDelim + 'opx.pas';

{$include code/PasModifiers.Intf.pas}
{$include code/PasModifiers.Impl.pas}
{$ifdef OPX_TESTS}
    {$include code/PasModifiers.Test.pas}
{$endif}

var
    ExitText : string = '';
    StrInterface, StrImplementation, StrInitialization, StrFinalization : TStringList;

{% term interface %}

procedure Test; {$ifdef OPX_PROGRAM_OR_LIBRARY} forward; {$endif}

{$ifdef OPX_UNIT}
implementation
{$endif}

type
  TMinhaClasse = class
    procedure Teste; virtual; final;
  end;

procedure TMinhaClasse.Teste;
begin
end;

{% init uses_local %}
{% term uses_local %}

{% init implementation %}
procedure OpxLoadMainTemplate(var List : TStringList);
begin
    if not FileExists(FILE_TEMPLATE) then begin
        ExitCode := 1;
        ExitText := FILE_TEMPLATE + ' not found';
        Exit;
    end;
    List.LoadFromFile(FILE_TEMPLATE);
end;    

{ Stitch every /code subproject section into the template and write
  the single compilable dist/opx.pas. This is the core; the rest are
  extractions layered on top once this is solid. }
procedure DoOpx;
var
    Template : TStringList;
begin
    if ExitCode <> 0 then Exit;

    Template := TStringList.Create;
    try
        OpxLoadMainTemplate(Template);
        if ExitCode <> 0 then Exit;

        ForceDirectories(DIR_DIST);
        Template.SaveToFile(FILE_OPX);
        WriteLn('  [opx]          -> ', FILE_OPX, '  (', Template.Count, ' lines)');
    finally
        Template.Free;
    end;
end;

{ Extract the factual parts of the README from /code (module list,
  commands, version). The human prose stays hand-written. }
procedure DoReadme;
begin
    if ExitCode <> 0 then Exit;
    WriteLn('  [readme]       -> README.md  (not implemented)');
end;

{ Generate CONTRIBUTING.md: how to build, test, and submit changes. }
procedure DoContributing;
begin
    if ExitCode <> 0 then Exit;
    WriteLn('  [contributing] -> CONTRIBUTING.md  (not implemented)');
end;

{ Generate API/reference docs from the interface sections in /code. }
procedure DoDocs;
begin
    if ExitCode <> 0 then Exit;
    WriteLn('  [docs]         -> docs' + PathDelim + '  (not implemented)');
end;

{ Materialize the test sources living in /code into standalone /tests. }
procedure DoTests;
begin
    if ExitCode <> 0 then Exit;
    WriteLn('  [tests]        -> tests' + PathDelim + '  (not implemented)');
end;

{ Materialize runnable examples out of /code into /examples. }
procedure DoExamples;
begin
    if ExitCode <> 0 then Exit;
    WriteLn('  [examples]     -> examples' + PathDelim + '  (not implemented)');
end;
{% term implementation %}

procedure Init;
begin
{% init initialization %}
    WriteLn('builder: projecting /code into published artifacts');
    WriteLn;

    StrInterface := TStringList.Create;
    StrImplementation := TStringList.Create;
    StrInitialization := TStringList.Create;
    StrFinalization := TStringList.Create;
    {$ifdef OPX_TESTS}
        {$include code/PasModifiers.Init.pas}
    {$endif}
{% term initialization %}
end;

procedure Term;
begin
{% init finalization %}
    StrFinalization.Free;
    StrInitialization.Free;
    StrImplementation.Free;
    StrInterface.Free;

    WriteLn;
    if ExitText <> '' then begin
        WriteLn(ErrOutput, 'builder: ', ExitText);
    end else begin
        WriteLn('builder: done');
    end;
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
    DoOpx;
    DoReadme;
    DoContributing;
    DoDocs;
    DoTests;
    DoExamples;
end;
{$endif}

{$ifdef OPX_PROGRAM_OR_LIBRARY}
begin
    {$ifdef OPX_LIBRARY} AddExitProc(@Term); {$endif}
    try
        Init;
        {$ifdef OPX_PROGRAM}
            {$ifdef OPX_TESTS} Test {$else} Main {$endif};
    finally
            Term;            
        {$endif}
    end;
{$endif}

end.
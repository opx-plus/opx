program builder;

{$mode delphi}{$H+}{$J-}

uses
    SysUtils;

{ ---------------------------------------------------------------
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
  --------------------------------------------------------------- }

const
    DIR_CODE = 'code';
    DIR_DIST = 'dist';
    FILE_TEMPLATE = 'code' + PathDelim + 'main.pas';
    FILE_OPX = 'dist' + PathDelim + 'opx.pas';

{ Stitch every /code subproject section into the template and write
  the single compilable dist/opx.pas. This is the core; the rest are
  extractions layered on top once this is solid. }
procedure DoOpx;
begin
    WriteLn('  [opx]          -> ', FILE_OPX, '  (not implemented)');
end;

{ Extract the factual parts of the README from /code (module list,
  commands, version). The human prose stays hand-written. }
procedure DoReadme;
begin
    WriteLn('  [readme]       -> README.md  (not implemented)');
end;

{ Generate CONTRIBUTING.md: how to build, test, and submit changes. }
procedure DoContributing;
begin
    WriteLn('  [contributing] -> CONTRIBUTING.md  (not implemented)');
end;

{ Generate API/reference docs from the interface sections in /code. }
procedure DoDocs;
begin
    WriteLn('  [docs]         -> docs' + PathDelim + '  (not implemented)');
end;

{ Materialize the test sources living in /code into standalone /tests. }
procedure DoTests;
begin
    WriteLn('  [tests]        -> tests' + PathDelim + '  (not implemented)');
end;

{ Materialize runnable examples out of /code into /examples. }
procedure DoExamples;
begin
    WriteLn('  [examples]     -> examples' + PathDelim + '  (not implemented)');
end;

begin
    WriteLn('builder: projecting /code into published artifacts');
    WriteLn;

    DoOpx;
    DoReadme;
    DoContributing;
    DoDocs;
    DoTests;
    DoExamples;

    WriteLn;
    WriteLn('builder: done');
end.
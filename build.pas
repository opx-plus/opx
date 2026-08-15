program builder;

{$mode delphi}{$H+}{$J-}
{$modeswitch TypeHelpers}

uses
    SysUtils, Classes, TypInfo;

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

{$include code/Intf.pas}
{$include code/Impl.pas}

var
    ExitText : string = '';
    StrInterface, StrImplementation, StrInitialization, StrFinalization : TStringList;

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

procedure Init;
begin
    StrInterface := TStringList.Create;
    StrImplementation := TStringList.Create;
    StrInitialization := TStringList.Create;
    StrFinalization := TStringList.Create;
end;

procedure Main;
begin
    DoOpx;
    DoReadme;
    DoContributing;
    DoDocs;
    DoTests;
    DoExamples;
end;

procedure Term;
begin
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
end;

begin
    WriteLn('builder: projecting /code into published artifacts');
    WriteLn;

    try
        Init;
        Main;
    finally
        Term;
    end;

    Halt(ExitCode);
end.
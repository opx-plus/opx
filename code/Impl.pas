{ TPasModifierHelper }

function TPasModifierHelper.ToString : string;
var
    EnumName : string;
begin
    EnumName := GetEnumName(TypeInfo(TPasModifier), Ord(Self));
    Result := Copy(EnumName, 3, Length(EnumName) - 2);
end;

function TPasModifierHelper.ToPascalCode : string;
begin
    if Self = pmUnknown then begin
        Exit('');
    end;
    if Self = pmStrictPrivate then begin
        Exit('strict private');
    end;
    if Self = pmStrictProtected then begin
        Exit('strict protected');
    end;
    Result := LowerCase(ToString);
end;

function TPasModifierHelper.IsValidModifier : boolean;
begin
    Result := Self <> pmUnknown;
end;

function TPasModifierHelper.IsInvalidModifier : boolean;
begin
    Result := Self = pmUnknown;
end;

function TPasModifierHelper.IsCallingConvention : boolean;
begin
    Result := Self in [
        pmPascal,
        pmCdecl,
        pmCppdecl,
        pmStdcall,
        pmSafecall,
        pmRegister,
        pmOldfpccall,
        pmWinapi
    ];
end;

function TPasModifierHelper.IsVisibilityModifier : boolean;
begin
    Result := Self in [
        pmStrictPrivate,
        pmStrictProtected,
        pmPublic,
        pmProtected,
        pmPrivate,
        pmPublished
    ];
end;

function TPasModifierHelper.IsHintDirective : boolean;
begin
    Result := Self in [
        pmDeprecated,
        pmExperimental,
        pmPlatform,
        pmUnimplemented
    ];
end;

function TPasModifierHelper.IsLinkageDirective : boolean;
begin
    Result := Self in [
        pmExternal,
        pmExport,
        pmName,
        pmAssembler,
        pmLocal,
        pmAlias
    ];
end;

function TPasModifierHelper.IsMethodDirective : boolean;
begin
    Result := Self in [
        pmVirtual,
        pmDynamic,
        pmAbstract,
        pmOverride,
        pmOverload,
        pmReintroduce,
        pmMessage,
        pmStatic,
        pmForward
    ];
end;

function TPasModifierHelper.IsPropertyDirective : boolean;
begin
    Result := Self in [
        pmRead,
        pmWrite,
        pmDefault,
        pmNodefault,
        pmStored,
        pmIndex,
        pmImplements,
        pmEnumerator
    ];
end;

function TPasModifierHelper.IsGenericsDirective : boolean;
begin
    Result := Self in [
        pmGeneric,
        pmSpecialize
    ];
end;

function TPasModifierHelper.IsMemoryLayoutDirective : boolean;
begin
    Result := Self in [
        pmPacked,
        pmBitpacked,
        pmUnaligned,
        pmAbsolute,
        pmCvar
    ];
end;

function TPasModifierHelper.IsPlatformOrHardwareDirective : boolean;
begin
    Result := Self in [
        pmInterrupt,
        pmIocheck,
        pmNostackframe,
        pmSaveregisters,
        pmSoftfloat,
        pmFar,
        pmNear,
        pmFar16
    ];
end;

function TPasModifierHelper.IsMiscRoutineDirective : boolean;
begin
    Result := Self in [
        pmVarargs,
        pmNoreturn,
        pmResult
    ];
end;

function TPasModifierHelper.IsDeclarationPrefix : boolean;
begin
    Result := Self in [pmClass];
end;

function TPasModifierHelper.IsControlFlowKeyword : boolean;
begin
    Result := Self in [
        pmBreak,
        pmOtherwise
    ];
end;

function TPasModifierHelper.IsTypeExtension : boolean;
begin
    Result := Self in [
        pmHelper
    ];
end;

function TPasModifierHelper.IsMethodDirectiveExclusive : boolean;
begin
    Result := Self in [pmVirtual, pmDynamic, pmAbstract, pmOverride, pmStatic, pmMessage];
end;

function TPasModifierHelper.IsVisibilityModifierExclusive : boolean;
begin
    Result := Self in [pmStrictPrivate, pmStrictProtected, pmPrivate,
                       pmProtected, pmPublic, pmPublished];
end;

function TPasModifierHelper.IsCallingConventionExclusive : boolean;
begin
    Result := Self in [pmPascal, pmCdecl, pmCppdecl, pmStdcall, pmSafecall,
                       pmRegister, pmOldfpccall, pmWinapi];
end;

function TPasModifierHelper.IsPropertyDirectiveExclusive : boolean;
begin
    Result := Self in [pmDefault, pmNodefault];
end;

function TPasModifierHelper.IsMemoryLayoutPackedExclusive : boolean;
begin
    Result := Self in [pmPacked, pmBitpacked];
end;

function TPasModifierHelper.IsMemoryLayoutVariablesExclusive : boolean;
begin
    Result := Self in [pmAbsolute, pmCvar];
end;

function TPasModifierHelper.IsPlatformOrHardwareExclusive : boolean;
begin
    Result := Self in [pmFar, pmNear, pmFar16];
end;

{ TPasModifierSetHelper }

procedure TPasModifierSetHelper.AddVisibility(const AModifier : TPasModifier);
begin
    Self := Self - [
        pmStrictPrivate,
        pmStrictProtected,
        pmPrivate,
        pmProtected,
        pmPublic,
        pmPublished
    ];
    Include(Self, AModifier);
end;

procedure TPasModifierSetHelper.AddCallingConvention(const AModifier : TPasModifier);
begin
    Self := Self - [
        pmPascal,
        pmCdecl,
        pmCppdecl,
        pmStdcall,
        pmSafecall,
        pmRegister,
        pmOldfpccall,
        pmWinapi
    ];
    Include(Self, AModifier);
end;

procedure TPasModifierSetHelper.AddMethodDirective(const AModifier : TPasModifier);
begin
    if AModifier.IsMethodDirectiveExclusive then begin
        Self := Self - [
            pmVirtual,
            pmDynamic,
            pmAbstract,
            pmOverride,
            pmStatic,
            pmMessage
        ];
    end;
    Include(Self, AModifier);
end;

procedure TPasModifierSetHelper.AddPropertyDirective(const AModifier : TPasModifier);
begin
    if AModifier.IsPropertyDirectiveExclusive then begin
        Self := Self - [pmDefault, pmNodefault];
    end;
    Include(Self, AModifier);
end;

procedure TPasModifierSetHelper.AddMemoryLayoutDirective(const AModifier : TPasModifier);
begin
    if AModifier.IsMemoryLayoutPackedExclusive then begin
        Self := Self - [pmPacked, pmBitpacked];
    end;
    if AModifier.IsMemoryLayoutVariablesExclusive then begin
        Self := Self - [pmAbsolute, pmCvar];
    end;
    Include(Self, AModifier);
end;

procedure TPasModifierSetHelper.AddPlatformOrHardwareDirective(const AModifier : TPasModifier);
begin
    if AModifier.IsPlatformOrHardwareExclusive then begin
        Self := Self - [pmFar, pmNear, pmFar16];
    end;
    Include(Self, AModifier);
end;

procedure TPasModifierSetHelper.Add(const AModifier : TPasModifier);
begin
    if AModifier = pmUnknown then begin
        Exit;
    end;

    if AModifier.IsVisibilityModifier then begin
        AddVisibility(AModifier);
    end else if AModifier.IsMethodDirective then begin
        AddMethodDirective(AModifier);
    end else if AModifier.IsCallingConvention then begin
        AddCallingConvention(AModifier);
    end else if AModifier.IsPropertyDirective then begin
        AddPropertyDirective(AModifier);
    end else if AModifier.IsMemoryLayoutDirective then begin
        AddMemoryLayoutDirective(AModifier);
    end else if AModifier.IsPlatformOrHardwareDirective then begin
        AddPlatformOrHardwareDirective(AModifier);
    end else begin
        Include(Self, AModifier);
    end;
end;

function TPasModifierSetHelper.HasVisibility : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsVisibilityModifier then begin
            Result := True;
            break;
        end;
    end;
end;

function TPasModifierSetHelper.HasCallingConvention : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsCallingConvention then begin
            Result := True;
            break;
        end;
    end;
end;

function TPasModifierSetHelper.HasMethodDirective : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsMethodDirective then begin
            Result := True;
            break;
        end;
    end;
end;

function TPasModifierSetHelper.HasPropertyDirective : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsPropertyDirective then begin
            Result := True;
            break;
        end;
    end;
end;

function TPasModifierSetHelper.HasMemoryLayoutDirective : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsMemoryLayoutDirective then begin
            Result := True;
            break;
        end;
    end;
end;

function TPasModifierSetHelper.HasPlatformOrHardwareDirective : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsPlatformOrHardwareDirective then begin
            Result := True;
            break;
        end;
    end;
end;

function TPasModifierSetHelper.HasMiscRoutineDirective : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsMiscRoutineDirective then begin
            Result := True;
            break;
        end;
    end;
end;

function TPasModifierSetHelper.HasControlFlowKeyword : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsControlFlowKeyword then begin
            Result := True;
            break;
        end;
    end;
end;

function TPasModifierSetHelper.HasTypeExtension : boolean;
var
    Modifier : TPasModifier;
begin
    Result := False;
    for Modifier in Self do begin
        if Modifier.IsTypeExtension then begin
            Result := True;
            break;
        end;
    end;
end;
type
    TPasModifierTests = class(TTestCase)
    published
        {conversion}
        procedure ToString_StripsPrefix;
        procedure ToPascalCode_LowercasesAndHandlesStrict;
        procedure ToPascalCode_UnknownIsEmpty;
        {state}
        procedure ValidAndInvalid;
        {taxonomy}
        procedure TaxonomyClassifies;
        procedure TaxonomyIsDisjoint;
        {set: exclusivity}
        procedure AddVisibility_ReplacesPrevious;
        procedure AddCallingConvention_ReplacesPrevious;
        procedure AddMethodDirective_ReplacesExclusiveOnly;
        procedure AddMethodDirective_KeepsNonExclusive;
        procedure AddPropertyDirective_DefaultNodefaultExclusive;
        procedure AddMemoryLayout_PackedAndVariablesExclusive;
        procedure AddPlatformOrHardware_AddressingExclusive;
        {set: dispatcher}
        procedure Dispatcher_RoutesByTaxonomy;
        procedure Dispatcher_IgnoresUnknown;
        procedure Dispatcher_AdditiveForNonExclusive;
        {set: queries}
        procedure HasQueries;
    end;

{ conversion }

procedure TPasModifierTests.ToString_StripsPrefix;
begin
    AssertEquals('Virtual', pmVirtual.ToString);
    AssertEquals('Pascal', pmPascal.ToString);
    AssertEquals('StrictPrivate', pmStrictPrivate.ToString);
    AssertEquals('Far16', pmFar16.ToString);
end;

procedure TPasModifierTests.ToPascalCode_LowercasesAndHandlesStrict;
begin
    AssertEquals('virtual', pmVirtual.ToPascalCode);
    AssertEquals('override', pmOverride.ToPascalCode);
    AssertEquals('strict private', pmStrictPrivate.ToPascalCode);
    AssertEquals('strict protected', pmStrictProtected.ToPascalCode);
end;

procedure TPasModifierTests.ToPascalCode_UnknownIsEmpty;
begin
    AssertEquals('', pmUnknown.ToPascalCode);
end;

{ state }

procedure TPasModifierTests.ValidAndInvalid;
begin
    AssertTrue('valid is valid', pmVirtual.IsValidModifier);
    AssertFalse('valid is not invalid', pmVirtual.IsInvalidModifier);
    AssertTrue('unknown is invalid', pmUnknown.IsInvalidModifier);
    AssertFalse('unknown is not valid', pmUnknown.IsValidModifier);
end;

{ taxonomy }

procedure TPasModifierTests.TaxonomyClassifies;
begin
    AssertTrue('cdecl is calling convention', pmCdecl.IsCallingConvention);
    AssertTrue('deprecated is hint', pmDeprecated.IsHintDirective);
    AssertTrue('external is linkage', pmExternal.IsLinkageDirective);
    AssertTrue('virtual is method', pmVirtual.IsMethodDirective);
    AssertTrue('read is property', pmRead.IsPropertyDirective);
    AssertTrue('public is visibility', pmPublic.IsVisibilityModifier);
    AssertTrue('generic is generics', pmGeneric.IsGenericsDirective);
    AssertTrue('packed is memory layout', pmPacked.IsMemoryLayoutDirective);
    AssertTrue('far is platform', pmFar.IsPlatformOrHardwareDirective);
    AssertTrue('varargs is misc routine', pmVarargs.IsMiscRoutineDirective);
    AssertTrue('class is declaration prefix', pmClass.IsDeclarationPrefix);
    AssertTrue('break is control flow', pmBreak.IsControlFlowKeyword);
    AssertTrue('helper is type extension', pmHelper.IsTypeExtension);
end;

procedure TPasModifierTests.TaxonomyIsDisjoint;
begin
    // a member of one category must not leak into another
    AssertFalse('virtual is not visibility', pmVirtual.IsVisibilityModifier);
    AssertFalse('public is not method', pmPublic.IsMethodDirective);
    AssertFalse('cdecl is not property', pmCdecl.IsPropertyDirective);
    AssertFalse('packed is not calling convention', pmPacked.IsCallingConvention);
    AssertFalse('unknown belongs to nothing', pmUnknown.IsMethodDirective);
end;

{ set: exclusivity }

procedure TPasModifierTests.AddVisibility_ReplacesPrevious;
var
    Set1 : TPasModifierSet;
begin
    Set1 := [];
    Set1.AddVisibility(pmPrivate);
    AssertTrue('private set', pmPrivate in Set1);

    Set1.AddVisibility(pmPublic);
    AssertFalse('private replaced', pmPrivate in Set1);
    AssertTrue('public now set', pmPublic in Set1);
end;

procedure TPasModifierTests.AddCallingConvention_ReplacesPrevious;
var
    Set1 : TPasModifierSet;
begin
    Set1 := [];
    Set1.AddCallingConvention(pmCdecl);
    Set1.AddCallingConvention(pmStdcall);
    AssertFalse('cdecl replaced', pmCdecl in Set1);
    AssertTrue('stdcall now set', pmStdcall in Set1);
end;

procedure TPasModifierTests.AddMethodDirective_ReplacesExclusiveOnly;
var
    Set1 : TPasModifierSet;
begin
    // virtual and override are both exclusive binding mechanisms
    Set1 := [];
    Set1.AddMethodDirective(pmVirtual);
    Set1.AddMethodDirective(pmOverride);
    AssertFalse('virtual replaced by override', pmVirtual in Set1);
    AssertTrue('override set', pmOverride in Set1);
end;

procedure TPasModifierTests.AddMethodDirective_KeepsNonExclusive;
var
    Set1 : TPasModifierSet;
begin
    // overload is a method directive but NOT exclusive: it coexists
    Set1 := [];
    Set1.AddMethodDirective(pmVirtual);
    Set1.AddMethodDirective(pmOverload);
    AssertTrue('virtual kept', pmVirtual in Set1);
    AssertTrue('overload added alongside', pmOverload in Set1);
end;

procedure TPasModifierTests.AddPropertyDirective_DefaultNodefaultExclusive;
var
    Set1 : TPasModifierSet;
begin
    Set1 := [];
    Set1.AddPropertyDirective(pmDefault);
    Set1.AddPropertyDirective(pmNodefault);
    AssertFalse('default replaced', pmDefault in Set1);
    AssertTrue('nodefault set', pmNodefault in Set1);

    // read is a property directive but not exclusive: coexists
    Set1.AddPropertyDirective(pmRead);
    AssertTrue('read added', pmRead in Set1);
    AssertTrue('nodefault kept', pmNodefault in Set1);
end;

procedure TPasModifierTests.AddMemoryLayout_PackedAndVariablesExclusive;
var
    Set1 : TPasModifierSet;
begin
    Set1 := [];
    // packed group
    Set1.AddMemoryLayoutDirective(pmPacked);
    Set1.AddMemoryLayoutDirective(pmBitpacked);
    AssertFalse('packed replaced', pmPacked in Set1);
    AssertTrue('bitpacked set', pmBitpacked in Set1);

    // variables group is independent of the packed group
    Set1.AddMemoryLayoutDirective(pmAbsolute);
    AssertTrue('bitpacked kept across groups', pmBitpacked in Set1);
    AssertTrue('absolute set', pmAbsolute in Set1);
    Set1.AddMemoryLayoutDirective(pmCvar);
    AssertFalse('absolute replaced', pmAbsolute in Set1);
    AssertTrue('cvar set', pmCvar in Set1);
end;

procedure TPasModifierTests.AddPlatformOrHardware_AddressingExclusive;
var
    Set1 : TPasModifierSet;
begin
    Set1 := [];
    Set1.AddPlatformOrHardwareDirective(pmFar);
    Set1.AddPlatformOrHardwareDirective(pmNear);
    AssertFalse('far replaced', pmFar in Set1);
    AssertTrue('near set', pmNear in Set1);

    // interrupt is additive, not part of the addressing group
    Set1.AddPlatformOrHardwareDirective(pmInterrupt);
    AssertTrue('near kept', pmNear in Set1);
    AssertTrue('interrupt added', pmInterrupt in Set1);
end;

{ set: dispatcher }

procedure TPasModifierTests.Dispatcher_RoutesByTaxonomy;
var
    Set1 : TPasModifierSet;
begin
    // the generic Add must route each modifier to its exclusivity group
    Set1 := [];
    Set1.Add(pmPrivate);
    Set1.Add(pmPublic);          // visibility -> replaces private
    Set1.Add(pmCdecl);
    Set1.Add(pmStdcall);         // calling conv -> replaces cdecl
    AssertFalse('private routed and replaced', pmPrivate in Set1);
    AssertTrue('public survives', pmPublic in Set1);
    AssertFalse('cdecl routed and replaced', pmCdecl in Set1);
    AssertTrue('stdcall survives', pmStdcall in Set1);
end;

procedure TPasModifierTests.Dispatcher_IgnoresUnknown;
var
    Set1 : TPasModifierSet;
begin
    Set1 := [];
    Set1.Add(pmUnknown);
    AssertFalse('unknown never enters the set', pmUnknown in Set1);
    AssertTrue('set stays empty', Set1 = []);
end;

procedure TPasModifierTests.Dispatcher_AdditiveForNonExclusive;
var
    Set1 : TPasModifierSet;
begin
    // inline is a misc routine directive: no group, purely additive
    Set1 := [];
    Set1.Add(pmInline);
    Set1.Add(pmVirtual);
    AssertTrue('inline kept', pmInline in Set1);
    AssertTrue('virtual kept', pmVirtual in Set1);
end;

{ set: queries }

procedure TPasModifierTests.HasQueries;
var
    Set1 : TPasModifierSet;
begin
    Set1 := [pmPublic, pmVirtual, pmInline];
    AssertTrue('has visibility', Set1.HasVisibility);
    AssertTrue('has method directive', Set1.HasMethodDirective);
    AssertTrue('has misc routine', Set1.HasMiscRoutineDirective);
    AssertFalse('no calling convention', Set1.HasCallingConvention);
    AssertFalse('no property directive', Set1.HasPropertyDirective);
    AssertFalse('no type extension', Set1.HasTypeExtension);
end;
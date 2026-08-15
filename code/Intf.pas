type

    /// @abstract(Classic Free Pascal modifier vocabulary, modeled as an enum.)
    /// The official modifiers as defined in the Free Pascal documentation,
    /// extended with intentional additions for AST modeling (e.g. pmPacked).
    ///
    /// Design note: the "strict" keyword is fused into pmStrictPrivate and
    /// pmStrictProtected to prevent state-machine ambiguity during validation.
    TPasModifier = (
        {guard}
        pmUnknown,

        {calling convention}
        pmPascal,
        pmCdecl,
        pmCppdecl,
        pmStdcall,
        pmSafecall,
        pmRegister,
        pmOldfpccall,
        pmWinapi,

        {hint directive}
        pmDeprecated,
        pmExperimental,
        pmPlatform,
        pmUnimplemented,

        {linkage directive}
        pmExternal,
        pmExport,
        pmName,
        pmAssembler,
        pmLocal,
        pmAlias,

        {method directive}
        pmVirtual,
        pmDynamic,
        pmAbstract,
        pmOverride,
        pmOverload,
        pmReintroduce,
        pmMessage,
        pmStatic,
        pmForward,

        {property directive}
        pmRead,
        pmWrite,
        pmDefault,
        pmNodefault,
        pmStored,
        pmIndex,
        pmImplements,
        pmEnumerator,

        {visibility modifier}
        pmStrictPrivate,
        pmStrictProtected,
        pmPrivate,
        pmProtected,
        pmPublic,
        pmPublished,

        {generics directive}
        pmGeneric,
        pmSpecialize,

        {memory layout directive}
        pmPacked,
        pmBitpacked,
        pmUnaligned,
        pmAbsolute,
        pmCvar,

        {platform or hardware}
        pmInterrupt,
        pmIocheck,
        pmNostackframe,
        pmSaveregisters,
        pmSoftfloat,
        pmFar,
        pmNear,
        pmFar16,

        {misc routine directive}
        pmVarargs,
        pmNoreturn,
        pmResult,
        pmInline,

        {declaration prefix}
        pmClass,

        {control flow keyword}
        pmBreak,
        pmOtherwise,

        {type extension}
        pmHelper
    );

    TPasModifierHelper = type helper for TPasModifier
        {conversion}
        function ToString : string;
        function ToPascalCode : string;

        {state}
        function IsValidModifier : boolean;
        function IsInvalidModifier : boolean;

        {complete taxonomy}
        function IsCallingConvention : boolean;
        function IsHintDirective : boolean;
        function IsLinkageDirective : boolean;
        function IsMethodDirective : boolean;
        function IsPropertyDirective : boolean;
        function IsVisibilityModifier : boolean;
        function IsGenericsDirective : boolean;
        function IsMemoryLayoutDirective : boolean;
        function IsPlatformOrHardwareDirective : boolean;
        function IsMiscRoutineDirective : boolean;
        function IsDeclarationPrefix : boolean;
        function IsControlFlowKeyword : boolean;
        function IsTypeExtension : boolean;

        {mutually exclusive groups}
        function IsMethodDirectiveExclusive : boolean;
        function IsVisibilityModifierExclusive : boolean;
        function IsCallingConventionExclusive : boolean;
        function IsPropertyDirectiveExclusive : boolean;
        function IsMemoryLayoutPackedExclusive : boolean;
        function IsMemoryLayoutVariablesExclusive : boolean;
        function IsPlatformOrHardwareExclusive : boolean;
    end;

    TPasModifierSet = set of TPasModifier;

    TPasModifierSetHelper = type helper for TPasModifierSet
        {specific mutators}
        procedure AddVisibility(const AModifier : TPasModifier);
        procedure AddCallingConvention(const AModifier : TPasModifier);
        procedure AddMethodDirective(const AModifier : TPasModifier);
        procedure AddPropertyDirective(const AModifier : TPasModifier);
        procedure AddMemoryLayoutDirective(const AModifier : TPasModifier);
        procedure AddPlatformOrHardwareDirective(const AModifier : TPasModifier);

        {dispatcher}
        procedure Add(const AModifier : TPasModifier);

        {queries}
        function HasVisibility : boolean;
        function HasCallingConvention : boolean;
        function HasMethodDirective : boolean;
        function HasPropertyDirective : boolean;
        function HasMemoryLayoutDirective : boolean;
        function HasPlatformOrHardwareDirective : boolean;
        function HasMiscRoutineDirective : boolean;
        function HasControlFlowKeyword : boolean;
        function HasTypeExtension : boolean;
    end;

    TOpxAliasSpec = record
        Alias     : string;
        Canonical : string;
    end;

const
    OPX_ALIASES : array[0..8] of TOpxAliasSpec =
    (
        (Alias: 'c';    Canonical: 'Cdecl'),
        (Alias: 'cpp';  Canonical: 'Cppdecl'),
        (Alias: 'std';  Canonical: 'Stdcall'),
        (Alias: 'pv';   Canonical: 'Private'),
        (Alias: 'prot'; Canonical: 'Protected'),
        (Alias: 'pub';  Canonical: 'Public'),        
        (Alias: 'over'; Canonical: 'Override'),
        (Alias: 'fwd';  Canonical: 'Forward'),
        (Alias: 'abs';  Canonical: 'Abstract')
    );
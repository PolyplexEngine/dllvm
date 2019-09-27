module dllvm.enums;
import llvm;

/**
    LLVM OPCodes
*/
enum OPCodes : LLVMOpcode {
    Ret =               LLVMRet,
    Br =                LLVMBr,
    Switch =            LLVMSwitch,
    IndirectBr =        LLVMIndirectBr,
    Invoke =            LLVMInvoke,
    Unreachable =       LLVMUnreachable,
    FNeg =              LLVMFNeg,
    Add =               LLVMAdd,
    FAdd =              LLVMFAdd,
    Sub =               LLVMSub,
    FSub =              LLVMFSub,
    Mul =               LLVMMul,
    FMul =              LLVMFMul,
    UDiv =              LLVMUDiv,
    SDiv =              LLVMSDiv,
    FDiv =              LLVMFDiv,
    URem =              LLVMURem,
    SRem =              LLVMSRem,
    FRem =              LLVMFRem,
    Shl =               LLVMShl,
    LShr =              LLVMLShr,
    AShr =              LLVMAShr,
    And =               LLVMAnd,
    Or =                LLVMOr,
    Xor =               LLVMXor,
    Alloca =            LLVMAlloca,
    Load =              LLVMLoad,
    Store =             LLVMStore,
    GetElementPtr =     LLVMGetElementPtr,
    Trunc =             LLVMTrunc,
    ZExt =              LLVMZExt,
    SExt =              LLVMSExt,
    FPToUI =            LLVMFPToUI,
    FPToSI =            LLVMFPToSI,
    UIToFP =            LLVMUIToFP,
    SIToFP =            LLVMSIToFP,
    FPTrunc =           LLVMFPTrunc,
    FPExt =             LLVMFPExt,
    PtrToInt =          LLVMPtrToInt,
    IntToPtr =          LLVMIntToPtr,
    BitCast =           LLVMBitCast,
    AddrSpaceCast =     LLVMAddrSpaceCast,
    ICmp =              LLVMICmp,
    FCmp =              LLVMFCmp,
    PHI =               LLVMPHI,
    Call =              LLVMCall,
    Select =            LLVMSelect,
    UserOp1 =           LLVMUserOp1,
    UserOp2 =           LLVMUserOp2,
    VAArg =             LLVMVAArg,
    ExtractElement =    LLVMExtractElement,
    InsertElement =     LLVMInsertElement,
    ShuffleVector =     LLVMShuffleVector,
    ExtractValue =      LLVMExtractValue,
    InsertValue =       LLVMInsertValue,
    Fence =             LLVMFence,
    AtomicCmpXchg =     LLVMAtomicCmpXchg,
    AtomicRMW =         LLVMAtomicRMW,
    Resume =            LLVMResume,
    LandingPad =        LLVMLandingPad,
    CleanupRet =        LLVMCleanupRet,
    CatchRet =          LLVMCatchRet,
    CatchPad =          LLVMCatchPad,
    CleanupPad =        LLVMCleanupPad,
    CatchSwitch =       LLVMCatchSwitch
}

/**
    The visibility of an LLVM value
*/
enum VisibilityType : LLVMVisibility {
    Default =       LLVMDefaultVisibility,
    Hidden =        LLVMHiddenVisibility,
    Protected =     LLVMProtectedVisibility
}

/**
    An LLVM linkage type
*/
enum LinkageType : LLVMLinkage {
    External =                  LLVMExternalLinkage,
    AvailableExternally =       LLVMAvailableExternallyLinkage,
    LinkOnceAny =               LLVMLinkOnceAnyLinkage,
    LonkOnceODR =               LLVMLinkOnceODRLinkage,
    WeakAny =                   LLVMWeakAnyLinkage,
    WeakODR =                   LLVMWeakODRLinkage,
    Appending =                 LLVMAppendingLinkage,
    Internal =                  LLVMInternalLinkage,
    Private =                   LLVMPrivateLinkage,
    ExternalWeak =              LLVMExternalWeakLinkage,
    Common =                    LLVMCommonLinkage
}

/**
    An LLVM storage class
*/
enum StorageClassType : LLVMDLLStorageClass {
    Default =       LLVMDefaultStorageClass,
    DLLImport =     LLVMDLLImportStorageClass,
    DLLExport =     LLVMDLLExportStorageClass
}

/**
    The kind of Type a type is.
*/
enum TypeKind : int {
    Void = LLVMVoidTypeKind,
    Float16 = LLVMHalfTypeKind,
    Float32 = LLVMFloatTypeKind,
    Float64 = LLVMDoubleTypeKind,
    Float80 = LLVMX86_FP80TypeKind,
    FloatFP128 = LLVMFP128TypeKind,
    FloatPPC_FP128 = LLVMPPC_FP128TypeKind,
    Label = LLVMLabelTypeKind,
    Int = LLVMIntegerTypeKind,
    Function = LLVMFunctionTypeKind,
    Struct = LLVMStructTypeKind,
    Array = LLVMArrayTypeKind,
    Pointer = LLVMPointerTypeKind,
    Vector = LLVMVectorTypeKind,
    Metadata = LLVMMetadataTypeKind,
    MMX = LLVMX86_MMXTypeKind,
    Token = LLVMTokenTypeKind
}

/**
    The kind of the value
*/
enum ValueKind {
    Argument =          LLVMArgumentValueKind,
    BasicBlock =        LLVMBasicBlockValueKind,
    MemUse =            LLVMMemoryUseValueKind,
    MemDef =            LLVMMemoryDefValueKind,
    MemPhi =            LLVMMemoryPhiValueKind,
    Function =          LLVMFunctionValueKind,
    GlobalAlias =       LLVMGlobalAliasValueKind,
    GlobalIFunc =       LLVMGlobalIFuncValueKind,
    GlobalVariable =    LLVMGlobalVariableValueKind,
    BlockAddress =      LLVMBlockAddressValueKind,
    ConstExpr =         LLVMConstantExprValueKind,
    ConstArr =          LLVMConstantArrayValueKind,
    ConstStruct =       LLVMConstantStructValueKind,
    ConstVector =       LLVMConstantVectorValueKind,
    UndefValue =        LLVMUndefValueValueKind,
    ConstAggrZV =       LLVMConstantAggregateZeroValueKind,
    ConstDataArray =    LLVMConstantDataArrayValueKind,
    ConstDataVector =   LLVMConstantDataVectorValueKind,
    ConstInt =          LLVMConstantIntValueKind,
    ConstFP =           LLVMConstantFPValueKind,
    ConstNULL =         LLVMConstantPointerNullValueKind,
    ConstTokenNone =    LLVMConstantTokenNoneValueKind,
    MetadataAsValue =   LLVMMetadataAsValueValueKind,
    InlineASM =         LLVMInlineAsmValueKind,
    Instruction =       LLVMInstructionValueKind
}

/**
    The significance of the address
*/
enum AddressSignificance {
    /// Address of the Global Value is *significant*
    Significant             = LLVMNoUnnamedAddr,

    /// Address of the Global Value is *locally insignificant*
    LocallyInsignificant    = LLVMLocalUnnamedAddr,

    /// Address of the Global Value is *globally insignificant*
    GloballyInsignificant   = LLVMGlobalUnnamedAddr
}

/**
    An LLVM Thread Local Mode
*/
enum ThreadLocalModeType : LLVMThreadLocalMode {
    NotThreadLocal =            LLVMNotThreadLocal,
    GeneralDynamicTLSModel =    LLVMGeneralDynamicTLSModel,
    LocalDynamicTLSModel =      LLVMLocalDynamicTLSModel,
    InitialExecTLSModel =       LLVMInitialExecTLSModel,
    LocalExecTLSModel =         LLVMLocalExecTLSModel
}

/**
    The calling conventions officially supported by LLVM

    Taken from http://llvm.org/doxygen/CallingConv_8h_source.html#l00024
*/
enum CallingConventionType : uint {
    C =                         0,
    Fast =                      8,
    Cold =                      9,
    GHC =                       10,
    HiPE =                      11,
    WebKit_JS =                 12,
    AnyReg =                    13,
    PreserveMost =              14,
    PreserveAll =               15,
    Swift =                     16,
    CXX_FAST_TLS =              17,
    FirstTargetCC =             64,
    X86_StdCall =               64,
    X86_FastCall =              65,
    ARM_APCS =                  66,
    ARM_AAPCS =                 67,
    ARM_AAPCS_VFP =             68,
    MSP430_INTR =               69,
    X86_ThisCall =              70,
    PTX_Kernel =                71,
    PTX_Device =                72,
    SPIR_FUNC =                 75,
    SPIR_KERNEL =               76,
    Intel_OCL_BI =              77,
    X86_64_SysV =               78,
    Win64 =                     79,
    X86_VectorCall =            80,
    HHVM =                      81,
    HHVM_C =                    82,
    X86_INTR =                  83,
    AVR_INTR =                  84,
    AVR_SIGNAL =                85,
    AVR_BUILTIN =               86,
    AMDGPU_VS =                 87,
    AMDGPU_GS =                 88,
    AMDGPU_PS =                 89,
    AMDGPU_CS =                 90,
    ANDGPU_KERNEL =             91,
    X86_RegCall =               92,
    AMDGPU_HS =                 93,
    MSP430_BUILTIN =            94,
    AMDGPU_LS =                 95,
    AMDGPU_ES =                 96,
    AArch64_VectorCall =        97,
    AArch64_SVE_VectorCall =    98,
    WASM_EmscriptenInvoke =     99,
    MaxID =                     1023
}
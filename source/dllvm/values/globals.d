module dllvm.values.globals;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;

/**
    A global value
*/
class GlobalValue : Value {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:

    /**
        Gets the parent module
    */
    @property
    Module GlobalParent() {
        return new Module(LLVMGetGlobalParent(ptr));
    }

    /**
        Gets wether this global value is a declaration
    */
    @property
    bool IsDeclaration() {
        return cast(bool)LLVMIsDeclaration(ptr);
    }

    /**
        Gets the linkage type of the global value
    */
    @property
    LinkageType Linkage() {
        return cast(LinkageType)LLVMGetLinkage(ptr);
    }

    /**
        Sets the linkage type of the global value
    */
    @property
    void Linkage(LinkageType type) {
        LLVMSetLinkage(ptr, type);
    }

    /**
        Gets the section of the global value
    */
    @property
    string Section() {
        return cast(string)LLVMGetSection(ptr).fromStringz;
    }

    /**
        Sets the section of the global value
    */
    @property
    void Section(string value) {
        LLVMSetSection(ptr, value.toStringz);
    }

    /**
        Gets the visibility of the global value
    */
    @property
    VisibilityType Visibility() {
        return cast(VisibilityType)LLVMGetVisibility(ptr);
    }

    /**
        Sets the visibility of the global value
    */
    @property
    void Visibility(VisibilityType type) {
        LLVMSetVisibility(ptr, type);
    }

    /**
        Gets the visibility of the global value
    */
    @property
    StorageClassType StorageClass() {
        return cast(StorageClassType)LLVMGetDLLStorageClass(ptr);
    }

    /**
        Sets the visibility of the global value
    */
    @property
    void StorageClass(StorageClassType type) {
        LLVMSetDLLStorageClass(ptr, type);
    }

    /**
        Gets the significance of the unnamed address
    */
    @property
    AddressSignificance Significance() {
        return cast(AddressSignificance)LLVMGetUnnamedAddress(ptr);
    }

    /**
        Sets the significance of the unnamed address
    */
    @property
    void Significance(AddressSignificance value) {
        return LLVMSetUnnamedAddress(ptr, value);
    }

    /**
        Gets the value type of the global value
    */
    @property
    Type ValueType() {
        LLVMTypeRef type = LLVMGlobalGetValueType(ptr);
        return new Type(type, cast(TypeKind)LLVMGetTypeKind(type));
    }

    /**
        Gets the preferred alignment of the value
    */
    @property
    uint Alignment() {
        return LLVMGetAlignment(ptr);
    }

    /**
        Sets the preferred alignment of the value
    */
    @property
    void Alignment(uint bytes) {
        LLVMSetAlignment(ptr, bytes);
    }
}

/**
    A global alias between 2 values
*/
class GlobalAlias : GlobalValue {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:
    /**
        Creates a new global alias
    */
    this(Module mod, Type type, Value aliasee, string name) {
        super(LLVMAddAlias(mod.ptr, type.ptr, aliasee.ptr, name.toStringz));
    }

    /**
        Gets the next global alias in the parent module

        Returns null if the end has been reached
    */
    @property
    GlobalAlias Next() {
        LLVMValueRef value = LLVMGetNextGlobalAlias(ptr);
        return value !is null ? new GlobalAlias(value) : null;
    }

    /**
        Gets the previous global alias in the parent module
        
        Returns null if the start has been reached
    */
    @property
    GlobalAlias Previous() {
        LLVMValueRef value = LLVMGetPreviousGlobalAlias(ptr);
        return value !is null ? new GlobalAlias(value) : null;
    }

    /**
        Gets the aliasee
    */
    @property
    Value Aliasee() {
        return new Value(LLVMAliasGetAliasee(ptr));
    }

    /**
        Sets the aliasee
    */
    @property
    void Aliasee(Value value) {
        LLVMAliasSetAliasee(ptr, value.ptr);
    }
}

/**
    A global variable
*/
class GlobalVariable : GlobalValue {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:
    /**
        Creates a new global variable of specified type, with specified name, in the specified module
    */
    this(Module mod, Type type, string name) {
        super(LLVMAddGlobal(mod.ptr, type.ptr, name.toStringz));
    }

    /**
        Creates a new global variable of specified type, with specified name, in the specified address space, in the specified module
    */
    this(Module mod, Type type, string name, uint addressSpace) {
        super(LLVMAddGlobalInAddressSpace(mod.ptr, type.ptr, name.toStringz, addressSpace));
    }

    /**
        Deletes this global variable from the module
    */
    void Delete() {
        LLVMDeleteGlobal(ptr);
    }

    /**
        Gets the next global variable in the parent module

        Returns null if the end has been reached
    */
    @property
    GlobalValue Next() {
        LLVMValueRef value = LLVMGetNextGlobal(ptr);
        return value !is null ? new GlobalValue(value) : null;
    }

    /**
        Gets the previous global variable in the parent module
        
        Returns null if the start has been reached
    */
    @property
    GlobalValue Previous() {
        LLVMValueRef value = LLVMGetPreviousGlobal(ptr);
        return value !is null ? new GlobalValue(value) : null;
    }

    /**
        Gets this global variable's initializer
    */
    @property
    Constant Initializer() {
        return cast(Constant)(new Value(LLVMGetInitializer(ptr)));
    }

    /**
        Sets this global variable's initializer
    */
    @property
    void Initiliazer(Constant value) {
        LLVMSetInitializer(ptr, value.ptr);
    }

    /**
        Gets wether this global variable is a global constant
    */
    @property
    bool IsGlobalConst() {
        return cast(bool)LLVMIsGlobalConstant(ptr);
    }

    /**
        Sets wether this global variable is a global constant
    */
    @property
    void IsGlobalConst(bool value) {
        LLVMSetGlobalConstant(ptr, cast(LLVMBool)value);
    }

    /**
        Gets wether this global variable is externally initalized
    */
    @property
    bool IsExternallyInitialized() {
        return cast(bool)LLVMIsExternallyInitialized(ptr);
    }

    /**
        Sets wether this global variable is externally initalized
    */
    @property
    void IsExternallyInitialized(bool value) {
        LLVMSetExternallyInitialized(ptr, cast(LLVMBool)value);
    }

    /**
        Gets wether this global variable is thread local
    */
    @property
    bool IsThreadLocal() {
        return cast(bool)LLVMIsThreadLocal(ptr);
    }

    /**
        Sets wether this global variable is thread local
    */
    @property
    void IsThreadLocal(bool value) {
        LLVMSetThreadLocal(ptr, cast(LLVMBool)value);
    }

    /**
        Gets the thread local mode
    */
    @property
    ThreadLocalModeType ThreadLocalMode() {
        return cast(ThreadLocalModeType)LLVMGetThreadLocalMode(ptr);
    }

    /**
        Sets the thread local mode
    */
    @property
    void ThreadLocalMode(ThreadLocalModeType type) {
        LLVMSetThreadLocalMode(ptr, cast(LLVMThreadLocalMode)type);
    }
}
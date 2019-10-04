module dllvm.mod;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;

/**
    An LLVM module
*/
class Module {
private:

    /// Hidden constructor for backend uses.
    this(LLVMModuleRef ptr) {
        this.ptr = ptr;
    }

public:
    /**
        The LLVM level pointer to this object
    */
    LLVMModuleRef ptr;

    /**
        Creates a module with the specified name
    */
    this(string name) {
        ptr = LLVMModuleCreateWithName(name.toStringz);
    }

    /**
        Creates a module with the specified name, attached to the specified context.
    */
    this(string name, Context context) {
        ptr = LLVMModuleCreateWithNameInContext(name.toStringz, context.ptr);
    }

    /**
        Disposes module on destruction
    */
    ~this() {
        // TODO: Find out why this crashes
        //LLVMDisposeModule(ptr);
    }

    /**
        Clones this module
    */
    Module Clone() {
        return new Module(LLVMCloneModule(ptr));
    }

    /**
        Gets the module's original source file name
    */
    @property
    string SourceFile() {
        size_t len;
        const(char)* cstr = LLVMGetSourceFileName(ptr, &len);
        return cstrToStr(cstr, len);
    }

    /**
        Gets the module's original source file name
    */
    @property
    void SourceFile(string value) {
        CStrInfo info = strToCstr(value);
        LLVMSetSourceFileName(ptr, info.cstr, info.len);
    }

    /**
        Gets the module identifier
    */
    @property
    string Identifier() {
        size_t len;
        const(char)* cstr = LLVMGetModuleIdentifier(ptr, &len);
        return cstrToStr(cstr, len);
    }

    /**
        Sets the module identifier
    */
    @property
    void Identifier(string value) {
        CStrInfo info = strToCstr(value);
        LLVMSetModuleIdentifier(ptr, info.cstr, info.len);
    }

    /**
        Gets the module inline ASM
    */
    @property
    string InlineASM() {
        size_t len;
        const(char)* cstr = LLVMGetModuleInlineAsm(ptr, &len);
        return cstrToStr(cstr, len);
    }

    /**
        Sets the module inline ASM
    */
    @property
    void InlineASM(string value) {
        CStrInfo info = strToCstr(value);
        LLVMSetModuleInlineAsm2(ptr, info.cstr, info.len);
    }

    /**
        Gets the first global variable in the module
    */
    @property
    GlobalValue FirstGlobal() {
        return new GlobalValue(LLVMGetFirstGlobal(ptr));
    }

    /**
        Gets the last global variable in the module
    */
    @property
    GlobalValue LastGlobal() {
        return new GlobalValue(LLVMGetLastGlobal(ptr));
    }

    /**
        Gets the first function in the module
    */
    @property
    Function FirstFunction() {
        return new Function(LLVMGetFirstFunction(ptr));
    }

    /**
        Gets the last function in the module
    */
    @property
    Function LastFunction() {
        return new Function(LLVMGetLastFunction(ptr));
    }

    /**
        Gets the first alias in the module
    */
    @property
    GlobalAlias FirstAlias() {
        return new GlobalAlias(LLVMGetFirstGlobalAlias(ptr));
    }

    /**
        Gets the last alias in the module
    */
    @property
    GlobalValue LastAlias() {
        return new GlobalAlias(LLVMGetLastGlobalAlias(ptr));
    }

    /**
        Returns a global variable from the module by name
    */
    GlobalValue GetGlobal(string name) {
        auto valptr = LLVMGetNamedGlobal(ptr, name.toStringz);
        return valptr !is null ? cast(GlobalValue)(new Value(valptr)) : null;
    }

    /**
        Returns a function from the module by name
    */
    Function GetFunction(string name) {
        auto valptr = LLVMGetNamedFunction(ptr, name.toStringz);
        return valptr !is null ? new Function(valptr) : null;
    }

    /**
        Returns a global variable from the module by name
    */
    GlobalAlias GetAlias(string name) {
        CStrInfo cstr = strToCstr(name);
        auto valptr = LLVMGetNamedGlobalAlias(ptr, cstr.cstr, cstr.len);
        return valptr !is null ? cast(GlobalAlias)(new Value(valptr)) : null;
    }

    /**
        Iterates to the next function, if there's no functions value will be null
    */
    Value GetNextFunction(Value value) {
        auto valptr = LLVMGetNextFunction(value.ptr);
        return valptr !is null ? new Function(valptr) : null;
    }

    /**
        Iterates to the previous function, if there's no functions value will be null
    */
    Value GetPreviousFunction(Value value) {
        auto valptr = LLVMGetPreviousFunction(value.ptr);
        return valptr !is null ? new Function(valptr) : null;
    }

    /**
        Obtains a type from the module by its registered name
    */
    Type GetType(string name) {
        auto valptr = LLVMGetTypeByName(ptr, name.toStringz);
        return valptr !is null ? new Type(valptr, cast(TypeKind)LLVMGetTypeKind(valptr)) : null;
    }

    /**
        Returns the IR of the module
    */
    override string toString() {
        return cast(string)LLVMPrintModuleToString(ptr).fromStringz;
    }

}
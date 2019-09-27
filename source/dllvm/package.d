module dllvm;
public import dllvm.values;
public import dllvm.enums;
import llvm;
import std.string : toStringz, fromStringz;

/**
    Loads LLVM in to memory
*/
void loadLLVM() {
    LLVM.load();

    // Set the global context
    globalCtx = new Context(LLVMGetGlobalContext());
}

/**
    Unloads LLVM from memory
*/
void unloadLLVM() {
    // Destroy the global context
    globalCtx = null;

    LLVM.unload();
}

/**
    Converts an LLVM C string (with length provided) to a D UTF-8 string
*/
string cstrToStr(const(char)* cstr, size_t len) {
    return cast(string)cstr[0..len];
}

/**
    Converts a D UTF-8 string to a C string (with length provided)
*/
CStrInfo strToCstr(string str) {
    return CStrInfo(str.toStringz, str.length);
}

/**
    C string information
*/
struct CStrInfo {
    /**
        The C string
    */
    const(char)* cstr;

    /**
        The length of the string
    */
    size_t len;
}

private static Context globalCtx;

/**
    An LLVM context
*/
class Context {
private:
    /**
        Constructs a new LLVM context
    */
    this(LLVMContextRef ptr) {
        this.ptr = ptr;    
    }

public:
    /**
        The LLVM level pointer to this object
    */
    LLVMContextRef ptr;

    /**
        Gets the global context
    */
    @property
    static Context Global() {
        return globalCtx;
    }

    /**
        Constructs a new LLVM context
    */
    this() {
        ptr = LLVMContextCreate();    
    }

    /**
        Disposes context on object distruction
    */
    ~this() {
        LLVMContextDispose(ptr);
    }

    /**
        Gets wether the context should discard value names
    */
    @property
    bool DiscardValueNames() {
        return cast(bool)LLVMContextShouldDiscardValueNames(ptr);
    }

    /**
        Sets wether the context should discard value names
    */
    @property
    void DiscardValueNames(bool opt) {
        LLVMContextSetDiscardValueNames(ptr, opt);
    }

    /**
        Creates a bit type bound to this context
    */
    Type CreateBit() {
        return new Type(LLVMInt1TypeInContext(ptr), TypeKind.Int);
    }

    /**
        Creates a byte type bound to this context
    */
    Type CreateByte() {
        return new Type(LLVMInt8TypeInContext(ptr), TypeKind.Int);
    }

    /**
        Creates a int16 (short) type bound to this context
    */
    Type CreateInt16() {
        return new Type(LLVMInt16TypeInContext(ptr), TypeKind.Int);
    }

    /**
        Creates a int32 (int) type bound to this context
    */
    Type CreateInt32() {
        return new Type(LLVMInt32TypeInContext(ptr), TypeKind.Int);
    }

    /**
        Creates a int64 (long) type bound to this context
    */
    Type CreateInt64() {
        return new Type(LLVMInt64TypeInContext(ptr), TypeKind.Int);
    }

    /**
        Creates a int128 type bound to this context
    */
    Type CreateInt128() {
        return new Type(LLVMInt128TypeInContext(ptr), TypeKind.Int);
    }

    /**
        Creates a float16 type bound to this context
    */
    Type CreateFloat16() {
        return new Type(LLVMHalfTypeInContext(ptr), TypeKind.Float16);
    }

    /**
        Creates a float32 type bound to this context
    */
    Type CreateFloat32() {
        return new Type(LLVMFloatTypeInContext(ptr), TypeKind.Float32);
    }

    /**
        Creates a float64 type bound to this context
    */
    Type CreateFloat64() {
        return new Type(LLVMDoubleTypeInContext(ptr), TypeKind.Float64);
    }

    /**
        Creates a float128 type bound to this context
    */
    Type CreateFloat128() {
        return new Type(LLVMFP128TypeInContext(ptr), TypeKind.FloatFP128);
    }

    /**
        Creates a new function type bound to this context
    */
    FuncType CreateFunction(Type returnType, Type[] parameters, bool isVariadic) {

        // Iterate through the types, transforming them to their native counterpart
        LLVMTypeRef[] nativeTypes = new LLVMTypeRef[parameters.length];
        foreach(i, type; parameters) {
            nativeTypes[i] = type.ptr;
        }

        // Return the new FuncType
        return new FuncType(LLVMFunctionType(returnType.ptr, nativeTypes.ptr, cast(uint)nativeTypes.length, isVariadic), TypeKind.Function);
    }

    /**
        Creates a new empty struct with specified name
    */
    StructType CreateStruct(string name) {
        return new StructType(LLVMStructCreateNamed(ptr, name.toStringz), TypeKind.Struct);
    }

    /**
        Creates a new struct with the specified name and types
    */
    StructType CreateStruct(string name, Type[] elementTypes, bool packed) {
        StructType type = CreateStruct(name);
        type.SetBody(elementTypes, packed);
        return type;
    }

    /**
        Creates a new struct with the specified element types and packing flag
    */
    StructType CreateStruct(Type[] elementTypes, bool packed) {

        // Iterate through the types, transforming them to their native counterpart
        LLVMTypeRef[] nativeTypes = new LLVMTypeRef[elementTypes.length];
        foreach(i, type; elementTypes) {
            nativeTypes[i] = type.ptr;
        }

        return new StructType(LLVMStructTypeInContext(ptr, nativeTypes.ptr, cast(uint)nativeTypes.length, packed), TypeKind.Struct);
    }

    /**
        Creates a new array of the specified type with the specified length
    */
    ArrayType CreateArray(Type type, uint length) {
        return new ArrayType(LLVMArrayType(type.ptr, length), TypeKind.Array);
    }

    /**
        Creates a new pointer at the specified address space
    */
    PointerType CreatePointer(Type type, uint addressSpace) {
        return new PointerType(LLVMArrayType(type.ptr, addressSpace), TypeKind.Pointer);
    }

    /**
        Creates a new vector of the specified type with the specified length
    */
    VectorType CreateVector(Type type, uint length) {
        return new VectorType(LLVMVectorType(type.ptr, length), TypeKind.Vector);
    }

    /**
        Creates a void type
    */
    Type CreateVoid() {
        return new Type(LLVMVoidTypeInContext(ptr), TypeKind.Void);
    }

    /**
        Creates a label type
    */
    Type CreateLabel() {
        return new Type(LLVMLabelTypeInContext(ptr), TypeKind.Label);
    }

    /**
        Creates a token type
    */
    Type CreateToken() {
        return new Type(LLVMTokenTypeInContext(ptr), TypeKind.Token);
    }
}

/**
    An LLVM module
*/
class Module {
private:
    /// Allows cloning
    this(LLVMModuleRef ptr) {
        this.ptr = ptr;
    }

public:
    /// The pointer to the underlying LLVM module
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
        Disposes module
    */
    void Dispose() {
        LLVMDisposeModule(ptr);
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
        Returns a function from the module by name
    */
    Value GetFunction(string name) {
        auto valptr = LLVMGetNamedFunction(ptr, name.toStringz);
        return valptr !is null ? new Function(valptr) : null;
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

/**
    An LLVM type
*/
class Type {
private:
    TypeKind kind;

public:

    /**
        This allows cloning and creation from other sources, as well storing type kind info
        It should not be called directly.
    */
    this(LLVMTypeRef ptr, TypeKind kind) {
        this.ptr = ptr;
        this.kind = kind;
    }

    /**
        The LLVM level pointer to this object
    */
    LLVMTypeRef ptr;


    /**
        The kind of Type this type is.
    */
    @property
    TypeKind Kind() {
        return kind;
    }

    /**
        Gets wether this type has a known size
    */
    @property
    bool HasSize() {
        return cast(bool)LLVMTypeIsSized(ptr);
    }

    /**
        Gets the name of this type
    */
    @property
    string TypeName() {
        return cast(string)LLVMPrintTypeToString(ptr).fromStringz;
    }

    /**
        Obtains the context which this type is associated with
    */
    @property
    Context RootContext() {
        return new Context(LLVMGetTypeContext(ptr));
    }
}

/**
    The type of a function
*/
class FuncType : Type {
private:
    /// This allows cloning and creation from other sources, as well storing type kind info
    this(LLVMTypeRef ptr, TypeKind kind) {
        super(ptr, kind);
    }

public:
    /**
        Gets wether the function is variadic
    */
    @property
    bool IsVariadic() {
        return cast(bool)LLVMIsFunctionVarArg(ptr);
    }

    /**
        Gets the return type of this function
    */
    @property
    Type ReturnType() {
        LLVMTypeRef type = LLVMGetReturnType(ptr);
        return new Type(type, cast(TypeKind)LLVMGetTypeKind(type));
    }

    /**
        Gets the count of parameters which this function accepts
    */
    @property
    uint ParamCount() {
        return LLVMCountParamTypes(ptr);
    }

    /**
        Gets the types of the parameters
    */
    @property
    Type[] ParamTypes() {

        // Create new arrays of proper size
        immutable(uint) paramCount = ParamCount();
        Type[] outVar = new Type[paramCount];
        LLVMTypeRef[] types = new LLVMTypeRef[paramCount];

        // Fetch the types
        LLVMGetParamTypes(ptr, types.ptr);

        // Iterate and upgrade to D types
        foreach(i, type; types) {
            outVar[i] = new Type(type, cast(TypeKind)LLVMGetTypeKind(type));
        }
        return outVar;
    }
}

/**
    The type of a structure
*/
class StructType : Type {
private:
    /// This allows cloning and creation from other sources, as well storing type kind info
    this(LLVMTypeRef ptr, TypeKind kind) {
        super(ptr, kind);
    }
    
public:

    /**
        Gets the name of the struct
    */
    @property
    string Name() {
        return cast(string)LLVMGetStructName(ptr).fromStringz;
    }

    /**
        Returns the count of elements in the struct
    */
    @property
    uint ElementCount() {
        return LLVMCountStructElementTypes(ptr);
    }

    /**
        Gets wether this struct is packed
    */
    @property
    bool IsPacked() {
        return cast(bool)LLVMIsPackedStruct(ptr);
    }

    /**
        Gets wether this struct is opaque
    */
    @property
    bool IsOpqaue() {
        return cast(bool)LLVMIsOpaqueStruct(ptr);
    }

    /**
        Gets wether this struct is literal
    */
    @property
    bool IsLiteral() {
        return cast(bool)LLVMIsLiteralStruct(ptr);
    }

    /**
        Gets the types of the elements
    */
    @property
    Type[] Elements() {

        // Create new arrays of proper size
        immutable(uint) elementCount = ElementCount();
        Type[] outVar = new Type[elementCount];
        LLVMTypeRef[] types = new LLVMTypeRef[elementCount];

        // Fetch the types
        LLVMGetStructElementTypes(ptr, types.ptr);

        // Iterate and upgrade to D types
        foreach(i, type; types) {
            outVar[i] = new Type(type, cast(TypeKind)LLVMGetTypeKind(type));
        }
        return outVar;
    }

    /**
        Sets the body of the struct type
    */
    void SetBody(Type[] elementTypes, bool packed) {

        // Iterate through the types, transforming them to their native counterpart
        LLVMTypeRef[] nativeTypes = new LLVMTypeRef[elementTypes.length];
        foreach(i, type; elementTypes) {
            nativeTypes[i] = type.ptr;
        }

        LLVMStructSetBody(ptr, nativeTypes.ptr, cast(uint)nativeTypes.length, packed);
    }
}

/**
    A sequence type, base for arrays, vectors and pointers
*/
class SeqType : Type {
private:
    /// This allows cloning and creation from other sources, as well storing type kind info
    this(LLVMTypeRef ptr, TypeKind kind) {
        super(ptr, kind);
    }
    
public:
    /**
        Gets the element type of the sequence
    */
    @property
    Type ElementType() {
        LLVMTypeRef type = LLVMGetElementType(ptr);
        return new Type(type, cast(TypeKind)LLVMGetTypeKind(type));
    }

    /**
        Gets the amount of contained types
    */
    @property
    uint Count() {
        return LLVMGetNumContainedTypes(ptr);
    }

    /**
        Gets the type's subtypes
    */
    @property
    Type[] SubTypes() {
        // Create new arrays of proper size
        immutable(uint) count = Count();
        Type[] outVar = new Type[count];
        LLVMTypeRef[] types = new LLVMTypeRef[count];

        // Fetch the types
        LLVMGetSubtypes(ptr, types.ptr);

        // Iterate and upgrade to D types
        foreach(i, type; types) {
            outVar[i] = new Type(type, cast(TypeKind)LLVMGetTypeKind(type));
        }
        return outVar;
    }
}

/**
    The array sequence type
*/
class ArrayType : SeqType {
private:

    /// This allows cloning and creation from other sources, as well storing type kind info
    this(LLVMTypeRef ptr, TypeKind kind) {
        super(ptr, kind);
    }
    
public:
    /**
        Gets the length of the array
    */
    @property
    uint Length() {
        return LLVMGetArrayLength(ptr);
    }
}

/**
    The pointer sequence type
*/
class PointerType : SeqType {
private:

    /// This allows cloning and creation from other sources, as well storing type kind info
    this(LLVMTypeRef ptr, TypeKind kind) {
        super(ptr, kind);
    }
    
public:
    /**
        Gets the address space of the pointer
    */
    @property
    uint AddressSpace() {
        return LLVMGetPointerAddressSpace(ptr);
    }
}

/**
    The vector sequence type
*/
class VectorType : SeqType {
private:

    /// This allows cloning and creation from other sources, as well storing type kind info
    this(LLVMTypeRef ptr, TypeKind kind) {
        super(ptr, kind);
    }
    
public:
    /**
        Gets the vector size
    */
    @property
    uint VectorSize() {
        return LLVMGetVectorSize(ptr);
    }
}

/**
    An LLVM value
*/
class Value {
protected:
    /// This allows cloning and creation from other sources.
    this(LLVMValueRef ptr) {
        this.ptr = ptr;
    }

public:
    /**
        The LLVM level pointer to this object
    */
    LLVMValueRef ptr;

    /**
        Gets the type of this value
    */
    @property
    Type TypeOf() {
        LLVMTypeRef type = LLVMTypeOf(ptr);
        return new Type(type, cast(TypeKind)LLVMGetTypeKind(type));
    }

    /**
        Gets the kind of this value
    */
    @property
    ValueKind Kind() {
        return cast(ValueKind)LLVMGetValueKind(ptr);
    }

    /**
        Gets the name of this value
    */
    @property
    string Name() {
        size_t len;
        const(char)* cstr = LLVMGetValueName2(ptr, &len);
        return cstrToStr(cstr, len);
    }

    /**
        Sets the name of the value
    */
    @property
    void Name(string value) {
        CStrInfo info = strToCstr(value);
        LLVMSetValueName2(ptr, info.cstr, info.len);
    }

    /**
        Gets wether this value is a constant
    */
    @property
    bool IsConst() {
        return cast(bool)LLVMIsConstant(ptr);
    }

    /**
        Gets wether this value is undefined
    */
    @property
    bool IsUndef() {
        return cast(bool)LLVMIsUndef(ptr);
    }

    /**
        Prints out the string representation of this value
    */
    override string toString() {
        return cast(string)LLVMPrintValueToString(ptr).fromStringz;
    }
}
module dllvm.context;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;

package(dllvm) static Context globalCtx;

/**
    An LLVM context
*/
class Context {
private:

    /// Hidden constructor for backend uses.
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
    PointerType CreatePointer(Type type, uint addressSpace = 0) {
        return new PointerType(LLVMPointerType(type.ptr, addressSpace), TypeKind.Pointer);
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
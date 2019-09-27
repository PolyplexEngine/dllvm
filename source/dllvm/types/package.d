module dllvm.types;
public import dllvm.types.sequence;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;

/**
    An LLVM type
*/
class Type {
private:
    TypeKind kind;

package(dllvm):
    /**
        This allows cloning and creation from other sources, as well storing type kind info
    */
    this(LLVMTypeRef ptr, TypeKind kind) {
        this.ptr = ptr;
        this.kind = kind;
    }

public:

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
package(dllvm):
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
package(dllvm):
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

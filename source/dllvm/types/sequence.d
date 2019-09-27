module dllvm.types.sequence;
import dllvm;
import llvm;
import dllvm.enums;

/**
    A sequence type, base for arrays, vectors and pointers
*/
class SeqType : Type {
package(dllvm):
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
package(dllvm):

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
package(dllvm):

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
package(dllvm):

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
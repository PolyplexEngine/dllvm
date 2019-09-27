module dllvm.values.constants;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;

/**
    A constant value
*/
class Constant : User {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:

}

/**
    A constant integer value
*/
class ConstInt : Constant {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:
    /**
        Creates a new constant integer
    */
    this(Type type, ulong value, bool signExtend) {
        this(LLVMConstInt(type.ptr, value, signExtend));
    }

    /**
        Creates a new constant integer from a string

        radix allows setting the radix.
    */
    this(Type type, string value, ubyte radix) {
        CStrInfo cstr = strToCstr(value);
        this(LLVMConstIntOfStringAndSize(type.ptr, cstr.cstr, cast(uint)cstr.len, radix));
    }

    /**
        Gets the Zero Extended value of this constant int
    */
    @property
    ulong ValueZExt() {
        return LLVMConstIntGetZExtValue(ptr);
    }

    /**
        Gets the Sign Extended value of this constant int
    */
    @property
    ulong Value() {
        return LLVMConstIntGetSExtValue(ptr);
    }
}

/**
    A constant real
*/
class ConstReal : Constant {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:
    /**
        Creates a new constant integer
    */
    this(Type type, double value) {
        super(LLVMConstReal(type.ptr, value));
    }

    /**
        Creates a new constant integer from a string

        radix allows setting the radix.
    */
    this(Type type, string value) {
        CStrInfo cstr = strToCstr(value);
        super(LLVMConstRealOfStringAndSize(type.ptr, cstr.cstr, cast(uint)cstr.len));
    }

    /**
        Gets the value of this real.
        lostPrecision is set to true if precision was lost in the conversion
    */
    double GetValue(ref bool lostPrecision) {
        return LLVMConstRealGetDouble(ptr, cast(int*)&lostPrecision);
    }
}

/**
    The base class for constant sequential data
    eg. Vectors, Structs and Arrays
*/
class ConstDataSeq : Constant {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:
    /**
        Gets the element at the specified index
    */
    Value GetElement(uint index) {
        return new Value(LLVMGetElementAsConstant(ptr, index));
    }

    /**
        This shorthand allows indexing the data sequence like an array
    */
    Value opIndex(uint index) {
        return GetElement(index);
    }
}

/**
    A string value
*/
class ConstString : ConstDataSeq {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:
    /**
        Creates a new const string in the specified context
    */
    this(Context ctx, string value, bool nullTerminated) {
        super(LLVMConstStringInContext(ctx.ptr, value.toStringz, cast(uint)value.length, !nullTerminated));
    }

    /**
        Creates a new const string in the global context
    */
    this(string value, bool nullTerminated) {
        this(Context.Global, value, nullTerminated);
    }

    /**
        Gets the value of the string
    */
    @property
    string Value() {
        size_t len;
        return cstrToStr(LLVMGetAsString(ptr, &len), len);
    }
}

/**
    A constant struct
*/
class ConstStruct : ConstDataSeq {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:
    /**
        Creates a new constant struct with the specified elements and the specified packing in the specified context
    */
    this(Context ctx, Value[] elements, bool packed) {

        // Iterate through the values, transforming them to their native counterpart
        LLVMValueRef[] nativeValues = new LLVMValueRef[elements.length];
        foreach(i, type; elements) {
            nativeValues[i] = type.ptr;
        }

        super(LLVMConstStructInContext(ctx.ptr, nativeValues.ptr, cast(uint)nativeValues.length, packed));
    }

    /**
        Creates a new constant struct with the specified elements and the specified packing in the global context
    */
    this(Value[] elements, bool packed) {
        this(Context.Global, elements, packed);
    }

    /**
        Creates a new named struct based on the specified type with the specified elements in the context of the type
    */
    this(StructType base, Value[] constants) {

        // Iterate through the values, transforming them to their native counterpart
        LLVMValueRef[] nativeValues = new LLVMValueRef[constants.length];
        foreach(i, type; constants) {
            nativeValues[i] = type.ptr;
        }

        super(LLVMConstNamedStruct(base.ptr, nativeValues.ptr, cast(uint)nativeValues.length));
    }
}

/**
    A constant array
*/
class ConstArray : ConstDataSeq {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:
    /**
        Creates a new array based on the specified array type's element type with the specified elements in the context of the type
    */
    this(ArrayType base, Value[] constants) {
        this(base.ElementType, constants);
    }

    /**
        Creates a new array based on the specified type with the specified elements in the context of the type
    */
    this(Type base, Value[] constants) {

        // Iterate through the values, transforming them to their native counterpart
        LLVMValueRef[] nativeValues = new LLVMValueRef[constants.length];
        foreach(i, type; constants) {
            nativeValues[i] = type.ptr;
        }

        super(LLVMConstArray(base.ptr, nativeValues.ptr, cast(uint)nativeValues.length));
    }
}

/**
    A constant vector
*/
class ConstVector : ConstDataSeq {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:
    /**
        Creates a new constant vector with the specified elements
    */
    this(Value[] elements) {

        // Iterate through the values, transforming them to their native counterpart
        LLVMValueRef[] nativeValues = new LLVMValueRef[elements.length];
        foreach(i, type; elements) {
            nativeValues[i] = type.ptr;
        }

        super(LLVMConstVector(nativeValues.ptr, cast(uint)nativeValues.length));
    }
}

/**
    The base type of a constant expression
*/
class ConstantExpr : Constant {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:

    /**
        Gets the OPCode associated with this constant expression
    */
    @property
    OPCodes OPCode() {
        return cast(OPCodes)LLVMGetConstOpcode(ptr);
    }
}

/**
    sizeof constant expression
*/
class SizeOf : ConstantExpr {
    /**
        Constructs a new undefined value of specified type
    */
    this(Type ofType) {
        super(LLVMSizeOf(ofType.ptr));
    }
}

/**
    alignof constant expression
*/
class AlignOf : ConstantExpr {
    /**
        Constructs a new undefined value of specified type
    */
    this(Type ofType) {
        super(LLVMAlignOf(ofType.ptr));
    }
}

// TODO: implement more constant expressions
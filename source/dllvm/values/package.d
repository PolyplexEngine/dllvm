module dllvm.values;
public import dllvm.values.nil;
public import dllvm.values.constants;
public import dllvm.values.globals;
public import dllvm.values.functions;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;


/**
    An LLVM value
*/
class Value {
package(dllvm):

    /// Hidden constructor for backend uses.
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

/**
    A user value
*/
class User : Value {
protected:

    /// Hidden constructor for backend uses.

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:
    /**
        Obtains an operand at the specifed index.
    */
    Value GetOperand(uint index) {
        LLVMValueRef value = LLVMGetOperand(ptr, index);
        return new Value(value);
    }

    /**
        Sets the operand at the specified index
    */
    void SetOperand(Value value, uint index) {
        LLVMSetOperand(value.ptr, index, value.ptr);
    }
}
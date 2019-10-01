module dllvm.values.instructions.callbase;
import dllvm;
import llvm;

/**
    The basis for call instructions, (callbr, call, invoke)
*/
class CallBase : Instruction {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:
    /**
        Gets wether a function attribute is present
    */
    bool HasFunctionAttribute(AttributeKind kind) {
        return LLVMGetEnumAttributeAtIndex(ptr, AttributeIndex.Function, kind) is null ? false : true;
    }

    /**
        Gets wether a function attribute is present
    */
    bool HasFunctionAttribute(string kind) {
        CStrInfo cstr = strToCstr(kind);
        return LLVMGetStringAttributeAtIndex(ptr, AttributeIndex.Function, cstr.cstr, cast(uint)cstr.len) is null ? false : true;
    }
}

class Invoke : CallBase {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:

    /**
        Get wether invoke does not throw
    */
    bool DoesNotThrow() {
        return HasFunctionAttribute(AttributeKind.NoUnwind);
    }
}
module dllvm.values.instructions.atomic;
import dllvm;
import llvm;

/**
    An atomic compare/exchange instruction

    TODO: Finish this
*/
deprecated("This class does not have everything implemented yet and will probably fail.")
class AtomicCmpXchg : Instruction {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:
    /**
        Gets wether this instruction is volatile
    */
    bool Volatile() {
        return cast(bool)LLVMGetVolatile(ptr);
    }

    /**
        Sets wether this instruction is volatile
    */
    void Volatile(bool value) {
        LLVMSetVolatile(ptr, cast(LLVMBool)value);
    }

    // AtomicOrdering SuccessOrdering() {
    //     return LLVMGetCmpXchgSuccessOrdering(ptr);
    // }

    /**
        Gets the pointer operand
    */
    @property
    Value PointerOperand() {
        return new Value(LLVMGetOperand(ptr, 0));
    }

    /**
        Gets the compare operand
    */
    @property
    Value CompareOperand() {
        return new Value(LLVMGetOperand(ptr, 1));
    }

    /**
        Gets the new value operand
    */
    @property
    Value NewValOperand() {
        return new Value(LLVMGetOperand(ptr, 2));
    }

    /**
        Gets the pointer address space
    */
    @property
    uint PointerAddressSpace() {
        return LLVMGetPointerAddressSpace(this.TypeOf.ptr);
    }
}

/**
    TODO: Everything
*/
class AtomicRMW : Instruction {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:
}
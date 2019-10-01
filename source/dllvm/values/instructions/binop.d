module dllvm.values.instructions.binop;
import dllvm;
import llvm;

/**
    A binary operator
*/
class BinaryOperator : Instruction {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:

    /**
        Gets the opcode
    */
    @property
    OPCodes OPCode() {
        return cast(OPCodes)LLVMGetInstructionOpcode(ptr);
    }

    /**
        Swaps the operands for the operator
    */
    bool SwapOperands() {
        LLVMValueRef lhs = LLVMGetOperand(ptr, 0);
        LLVMValueRef rhs = LLVMGetOperand(ptr, 1);
        LLVMSetOperand(ptr, 0, rhs);
        LLVMSetOperand(ptr, 1, lhs);
        return (LLVMGetOperand(ptr, 0) == rhs && LLVMGetOperand(ptr, 1) == lhs);
    }
}

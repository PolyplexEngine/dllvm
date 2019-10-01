module dllvm.values.instructions;
public import dllvm.values.instructions.atomic;
public import dllvm.values.instructions.binop;
public import dllvm.values.instructions.callbase;
public import dllvm.values.instructions.except;
import dllvm;
import llvm;

/**
    An instruction
*/
class Instruction : User {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:

    /**
        Clones this instruction
    */
    Instruction Clone() {
        return new Instruction(LLVMInstructionClone(ptr));
    }

    /**
        Gets the specified successor. This instruction must be a terminator.
    */
    BasicBlock GetSuccessor(uint index) {
        return new BasicBlock(LLVMGetSuccessor(ptr, index));
    }

    /**
        Sets the successor to provided block.
    */
    void SetSuccessor(uint index, BasicBlock successor) {
        LLVMSetSuccessor(ptr, index, successor.ptr);
    }

    /**
        Gets wether this a terminator
    */
    bool IsTerminator() {
        return cast(bool)LLVMIsATerminatorInst(ptr);
    }

    /**
        Gets wether this is an unary operation
    */
    bool IsUnaryOp() {
        return cast(bool)LLVMIsAUnaryInstruction(ptr);
    }

    /**
        Gets wether this is a binary operation
    */
    bool IsBinaryOp() {
        return cast(bool)LLVMIsABinaryOperator(ptr);
    }

    /**
        Gets wether this is a funclet pad
    */
    bool IsFuncletPad() {
        return cast(bool)LLVMIsAFuncletPadInst(ptr);
    }
}

/**
    A branch instruction
*/
class Branch : Instruction {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:
    /**
        Gets wether this branch instruction is unconditional
    */
    @property
    bool IsUnconditional() {
        return LLVMGetNumOperands(ptr) == 1;
    }

    /**
        Gets wether this branch instruction is conditional
    */
    @property
    bool IsConditional() {
        return LLVMGetNumOperands(ptr) == 3;
    }

    /**
        Gets the branch condition
    */
    @property
    Value Condition() {
        return new Value(LLVMGetCondition(ptr));
    }

    /**
        Sets the branch condition
    */
    @property
    void Condition(Value value) {
        LLVMSetCondition(ptr, value.ptr);
    }

    /**
        Swaps the successors
    */
    void SwapSuccessors() {
        LLVMBasicBlockRef succ1 = LLVMGetSuccessor(ptr, 0);
        LLVMBasicBlockRef succ2 = LLVMGetSuccessor(ptr, 1);
        LLVMSetSuccessor(ptr, 0, succ2);
        LLVMSetSuccessor(ptr, 1, succ1);
    }
}

/**
    A switch-case instruction
*/
class SwitchCase : Instruction {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }


}
module dllvm.values.instructions.except;
import dllvm;
import llvm;

/**
    A funclet pad instruction
*/
class FuncletPad : Instruction {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:

}

/**
    A landing pad (exception handling) instruction
*/
class LandingPad : Instruction {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:

    /**
        Gets the number of clauses in a landing pad.
    */
    @property
    uint NumClauses() {
        return LLVMGetNumClauses(ptr);
    }

    /**
        Gets the clause at the specified index from the landing pad.
    */
    Value GetClause(uint index) {
        return new Value(LLVMGetClause(ptr, index));
    }

    /**
        Adds a clause to the landing pad
    */
    void AddClause(Value clause) {
        LLVMAddClause(ptr, clause.ptr);
    }

}

class CleanupPad : Instruction {
    
}
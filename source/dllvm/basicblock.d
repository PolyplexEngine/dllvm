module dllvm.basicblock;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;

/**
    A basic block represents a single-entry single-exit section of code.
*/
class BasicBlock {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMBasicBlockRef ptr) {
        this.ptr = ptr;
    }

public:
    /**
        The LLVM level pointer to this object
    */
    LLVMBasicBlockRef ptr;
}
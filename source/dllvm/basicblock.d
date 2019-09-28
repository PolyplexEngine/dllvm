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

    /**
        Creates a new basic block without any parent
    */
    this(Context ctx, string name) {
        this(LLVMCreateBasicBlockInContext(ctx.ptr, name.toStringz));
    }

    /**
        Gets this Basic Block as a value
    */
    @property
    Value AsValue() {
        return new Value(LLVMBasicBlockAsValue(ptr));
    }

    /**
        Gets the name of this Basic Block
    */
    @property
    string Name() {
        return cast(string)LLVMGetBasicBlockName(ptr).fromStringz;
    }

    /**
        Gets the parent function of this basic block
    */
    @property
    Function Parent() {
        return new Function(LLVMGetBasicBlockParent(ptr));
    }

    /**
        Gets the previous basic block
    */
    @property
    BasicBlock Previous() {
        LLVMBasicBlockRef value = LLVMGetPreviousBasicBlock(ptr);
        return value !is null ? new BasicBlock(value) : null;
    }

    /**
        Gets the previous basic block
    */
    @property
    BasicBlock Next() {
        LLVMBasicBlockRef value = LLVMGetNextBasicBlock(ptr);
        return value !is null ? new BasicBlock(value) : null;
    }

    /**
        Gets the first instruction in this block
    */
    @property
    Value FirstInstruction() {
        return new Value(LLVMGetFirstInstruction(ptr));
    }

    /**
        Gets the last instruction in this block
    */
    @property
    Value LastInstruction() {
        return new Value(LLVMGetLastInstruction(ptr));
    }

    /**
        Move this basic block before the other block
    */
    void MoveBefore(BasicBlock other) {
        LLVMMoveBasicBlockBefore(ptr, other.ptr);
    }

    /**
        Move this basic block after the other block
    */
    void MoveAfter(BasicBlock other) {
        LLVMMoveBasicBlockAfter(ptr, other.ptr);
    }

    /**
        Pops the basic block out of its parent.
        This object (and the basic block) will still be valid after.
   
        **NOTE**: It's not currently possible to push a popped block back in to a function
    */
    void Pop() {
        LLVMRemoveBasicBlockFromParent(ptr);
    }

    /**
        Deletes the basic block, this will invalidate this object.
    */
    void Delete() {
        LLVMDeleteBasicBlock(ptr);
        destroy(this);
    }
}
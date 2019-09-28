module dllvm.builder;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;

/**
    A class that builds IR instructions in Basic Blocks
*/
class Builder {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMBuilderRef ptr) {
        this.ptr = ptr;
    }

public:
    /**
        The LLVM level pointer to this object
    */
    LLVMBuilderRef ptr;

    /**
        Creates a new builder in the specified context
    */
    this(Context ctx) {
        this(LLVMCreateBuilderInContext(ctx.ptr));
    }

    /**
        Creates a new builder in the global context
    */
    this() {
        this(Context.Global);
    }

    /**
        Dispose builder on destruction
    */
    ~this() {
        LLVMDisposeBuilder(ptr);
    }

    /**
        Gets the insert block
    */
    @property
    BasicBlock InsertBlock() {
        return new BasicBlock(LLVMGetInsertBlock(ptr));
    }

    /**
        Positions the builder at the end of the basic block
    */
    void PositionAtEnd(BasicBlock block) {
        LLVMPositionBuilderAtEnd(ptr, block.ptr);
    }

    /**
        Positions the builder at the start of the basic block
    */
    void PositionAtStart(BasicBlock block) {
        PositionBuilder(block, block.FirstInstruction);
    }

    /**
        Positions the builder at the specified instruction
    */
    void PositionBuilder(BasicBlock block, Value instruction) {
        LLVMPositionBuilder(ptr, block.ptr, instruction.ptr);
    }

    /**
        Positions the builder before the specified instruction
    */
    void PositionBuilderBefore(Value instruction) {
        LLVMPositionBuilderBefore(ptr, instruction.ptr);
    }

    /**
        Clears the insertion position
    */
    void ClearInsertPosition() {
        LLVMClearInsertionPosition(ptr);
    }

    /**
        Builds a Return Void instruction
    */
    Value BuildRetVoid() {
        return new Value(LLVMBuildRetVoid(ptr));
    }

    /**
        Builds a return instruction
    */
    Value BuildRet(Value value) {
        return new Value(LLVMBuildRet(ptr, value.ptr));
    }

    /**
        Builds a return instruction that returns multiple values
    */
    Value BuildAggregateRet(Value[] values) {
        // Convert D Value to LLVM native types
        LLVMValueRef[] refs = new LLVMValueRef[values.length];
        foreach(i, item; values) refs[i] = item.ptr; 

        // Build the return
        return new Value(LLVMBuildAggregateRet(ptr, refs.ptr, cast(uint)refs.length));
    }

    /**
        Builds a Branch instruction

        Unconditional branch instruction
    */
    Value BuildBr(BasicBlock dest) {
        return new Value(LLVMBuildBr(ptr, dest.ptr));
    }

    /**
        Builds a Branch instruction

        Conditional branch instruction
    */
    Value BuildCondBr(Value if_, BasicBlock then, BasicBlock else_) {
        return new Value(LLVMBuildCondBr(ptr, if_.ptr, then.ptr, else_.ptr));
    }

    /**
        Builds a switch instruction

        Basis for switch-case statements
    */
    Value BuildSwitch(Value value, BasicBlock else_, uint count) {
        return new Value(LLVMBuildSwitch(ptr, value.ptr, else_.ptr, count));
    }

    /**
        Builds an indirect branch instruction.

        Branch instruction called indirectly, numDests defines how many destinations there are.
    */
    Value BuildIndirectBr(Value addr, uint numDests) {
        return new Value(LLVMBuildIndirectBr(ptr, addr.ptr, numDests));
    }

    /**
        Builds an invoke instruction

        Invoke calls an other specified function, then is executed if returned normally, catch_ is executed if an exception occured
    */
    Value BuildInvoke(Function func, Value[] args, BasicBlock then, BasicBlock catch_, string name = "") {
        // Convert D Value to LLVM native types
        LLVMValueRef[] refs = new LLVMValueRef[args.length];
        foreach(i, item; args) refs[i] = item.ptr; 

        return new Value(LLVMBuildInvoke(ptr, func.ptr, refs.ptr, cast(uint)refs.length, then.ptr, catch_.ptr, name.toStringz));
    }

    /**
        Builds an invoke instruction

        Invoke calls an other specified function, then is executed if returned normally, catch_ is executed if an exception occured
    */
    Value BuildInvoke(Type type, Function func, Value[] args, BasicBlock then, BasicBlock catch_, string name = "") {

        // Convert D Value to LLVM native types
        LLVMValueRef[] refs = new LLVMValueRef[args.length];
        foreach(i, item; args) refs[i] = item.ptr; 

        return new Value(LLVMBuildInvoke2(ptr, type.ptr, func.ptr, refs.ptr, cast(uint)refs.length, then.ptr, catch_.ptr, name.toStringz));
    }

    /**
        Builds an unreachable instruction

        This instruction informs the optimizer that the following code is unreachable.
    */
    Value BuildUnreachable() {
        return new Value(LLVMBuildUnreachable(ptr));
    }

    /**
        Builds a resume instruction

        Resume rethrows/resumes a current exception's unwinding which was interrupted by a landingpad.
    */
    Value BuildResume(Value ex) {
        return new Value(LLVMBuildResume(ptr, ex.ptr));
    }

    /**
        Builds a landing pad instruction

        Specifies that this basic block is a block where an exception can land, persFunc specifies the personality function used on re-entry.
    */
    Value BuildLandingPad(Type type, Function persFunc, uint clauseCount, string name = "") {
        return new Value(LLVMBuildLandingPad(ptr, type.ptr, persFunc.ptr, clauseCount, name.toStringz));
    }

    /**
        Builds a new cleanupret instruction

        This instruction terminates a cleanuppad with an optional successor
    */
    Value BuildCleanupRet(Value catchPad, BasicBlock successor = null) {
        return new Value(LLVMBuildCleanupRet(ptr, catchPad.ptr, successor !is null ? successor.ptr : null));
    }

    /**
        Builds a new catchret instruction

        This instruction terminates a catchpad with an successor
    */
    Value BuildCatchRet(Value catchPad, BasicBlock successor) {
        return new Value(LLVMBuildCatchRet(ptr, catchPad.ptr, successor.ptr));
    }

    /**
        Builds a signed division instruction
    */
    Value BuildSDiv(Value rhs, Value lhs, string name = "") {
        return new Value(LLVMBuildSDiv(ptr, rhs.ptr, lhs.ptr, name.toStringz));
    }

    /**
        Builds a select instruction.
        Select selects a value based on the 1i (bool) value of the if_ value.
    */
    Value BuildSelect(Value if_, Value then, Value else_, string name = "") {
        return new Value(LLVMBuildSelect(ptr, if_.ptr, then.ptr, else_.ptr, name.toStringz));
    }

    /**
        Builds a Sign Extend instruction.

        SExt copies the sign bit from value repeatedly until it reaches the bit size of destType
    */
    Value BuildSExt(Value value, Type destType, string name = "") {
        return new Value(LLVMBuildSExt(ptr, value.ptr, destType.ptr, name.toStringz));
    }

    /**
        Builds a Sign Extend or BitCast instruction.

        Choses either SExt or BitCast to convert the type of value to destType
    */
    Value BuildSExtOrBitCast(Value value, Type destType, string name = "") {
        return new Value(LLVMBuildSExtOrBitCast(ptr, value.ptr, destType.ptr, name.toStringz));
    }

    /**
        Builds a shift-left instruction

        Shifts the values of lhs to the left by the amount of bits specified in rhs
    */
    Value BuildShl(Value lhs, Value rhs, string name = "") {
        return new Value(LLVMBuildShl(ptr, lhs.ptr, rhs.ptr, name.toStringz));
    }

    /**
        Builds a shuffle-vector instruction
    */
    Value BuildShuffleVector(Value vec1, Value vec2, Value mask, string name = "") {
        return new Value(LLVMBuildShuffleVector(ptr, vec1.ptr, vec2.ptr, mask.ptr, name.toStringz));
    }

    /**
        Builds a Signed Int to Floating Point instruction

        Converts a signed integer type to a floating point type
    */
    Value BuildSIToFP(Value value, Type destType, string name = "") {
        return new Value(LLVMBuildSIToFP(ptr, value.ptr, destType.ptr, name.toStringz));
    }

    /**
        Build a Signed Remainder instruction

        Gets the signed remainder after a division between rhs and lhs
        (Either zero or same sign as divisor, this is not modulo)
    */
    Value BuildSRem(Value rhs, Value lhs, string name = "") {
        return new Value(LLVMBuildSRem(ptr, rhs.ptr, lhs.ptr, name.toStringz));
    }

    /**
        Builds a store instruction

        Stores value at address
    */
    Value BuildStore(Value val, Value addr) {
        return new Value(LLVMBuildStore(ptr, val.ptr, addr.ptr));
    }

    /**
        Builds a Struct GEP instruction

        I don't know what this does yet.
    */
    Value BuildStructGEP(Value addr, uint idx, string name = "") {
        return new Value(LLVMBuildStructGEP(ptr, addr.ptr, idx, name.toStringz));
    }

    /**
        Builds a Struct GEP instruction

        I don't know what this does yet.
    */
    Value BuildStructGEP(Type type, Value addr, uint idx, string name = "") {
        return new Value(LLVMBuildStructGEP2(ptr, type.ptr, addr.ptr, idx, name.toStringz));
    }

    /**
        Builds a subtract instruction

        Subtracts lhs by rhs
    */
    Value BuildSub(Value lhs, Value rhs, string name = "") {
        return new Value(LLVMBuildSub(ptr, lhs.ptr, rhs.ptr, name.toStringz));
    }

    /**
        Builds an allocate argument instruction
    */
    Value BuildAlloca(Type type, string name = "") {
        return new Value(LLVMBuildAlloca(ptr, type.ptr, name.toStringz));
    }
    
}
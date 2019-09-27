module dllvm.values.functions;
import std.string : fromStringz, toStringz;
import dllvm;
import llvm;

/**
    A function constant
*/
class Function : GlobalValue {
protected:

    /// Hidden constructor for backend uses.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:
    /**
        Creates a new function in the module with the specified return type and name
    */
    this(Module mod, FuncType functionType, string name) {
        super(LLVMAddFunction(mod.ptr, name.toStringz, functionType.ptr));
    }

    /**
        Deletes this function from the module

        This will invalidate this object, and thus it will be destroyed.
    */
    void Delete() {
        LLVMDeleteFunction(ptr);
        destroy(this);
    }

    /**
        Gets wether this function has a personality function
    */
    @property
    bool HasPersonalityFunction() {
        return cast(bool)LLVMHasPersonalityFn(ptr);
    }

    /**
        Get this function's personality function if any is present

        returns null otherwise
    */
    @property
    Function PersonalityFunction() {
        return HasPersonalityFunction ? new Function(LLVMGetPersonalityFn(ptr)) : null;
    }


    /**
        Sets this function's personality function
    */
    @property
    void PersonalityFunction(Function func) {
        LLVMSetPersonalityFn(ptr, func.ptr);
    }

    /**
        Gets wether this function is an intrinsic
    */
    @property
    bool IsIntrinsic() {
        return IntrinsicId == 0;
    }

    /**
        Gets the Intrinsic ID of this function
    */
    @property
    uint IntrinsicId() {
        return LLVMGetIntrinsicID(ptr);
    }

    // TODO: Implement intrinsic functions
    
    /**
        Gets the function's calling conventions
    */
    @property
    CallingConventionType CallingConvention() {
        return cast(CallingConventionType)LLVMGetFunctionCallConv(ptr);
    }

    /**
        Sets the function's calling conventions
    */
    @property
    void CallingConvention(CallingConventionType type) {
        LLVMSetFunctionCallConv(ptr, type);
    }

    /**
        Gets the return type of this function
    */
    @property
    Type ReturnType() {
        return (cast(FuncType)(this.TypeOf)).ReturnType;
    }

    /**
        Gets the count of parameters for this type
    */
    @property
    uint ParamCount() {
        return LLVMCountParams(ptr);
    }

    /**
        Gets the parameter at the specified index
    */
    Value GetParam(uint index) {
        return new Value(LLVMGetParam(ptr, index));
    }
    
    // TODO: Implement Attributes

    /**
        Creates a basic block with the specified name in the function
    */
    BasicBlock AppendBasicBlock(string name) {
        return new BasicBlock(LLVMAppendBasicBlock(ptr, name.toStringz));
    }
}
module dllvm.values;
public import dllvm.values.nil;
public import dllvm.values.constants;
public import dllvm.values.globals;
import llvm;
import dllvm;

/**
    A user value
*/
class User : Value {
protected:
    /// This allows cloning and creation from other sources.
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

/**
    A function constant
*/
class Function : Constant {
package(dllvm):
    /// This allows cloning and creation from other sources.
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:

}

// /**
//     An argument value
// */
// class Argument : Value {

// }
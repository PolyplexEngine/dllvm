module dllvm.values.nil;
import llvm;
import dllvm;

/**
    A null value
*/
class Null : Value {
    /**
        Constructs a new null
    */
    this(Type ofType) {
        super(LLVMConstNull(ofType.ptr));
    }
}

/**
    A value consisting of all ones
*/
class AllOnes : Value {
    /**
        Constructs a new AllOnes
    */
    this(Type ofType) {
        super(LLVMConstAllOnes(ofType.ptr));
    }
}

/**
    A constant null pointer value
*/
class NullPtr : Value {
    /**
        Constructs a new constant null
    */
    this(Type ofType) {
        super(LLVMConstPointerNull(ofType.ptr));
    }
}

/**
    A undefined value
*/
class Undefined : Value {
    /**
        Constructs a new undefined value of specified type
    */
    this(Type ofType) {
        super(LLVMGetUndef(ofType.ptr));
    }
}
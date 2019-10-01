module dllvm.exengine;
import dllvm;
import llvm;
import std.traits;

/**
    The LLVM Execution Engine
*/
class ExecutionEngine {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMExecutionEngineRef ptr) {
        this.ptr = ptr;
    }

public:
    /**
        The LLVM level pointer to this object
    */
    LLVMExecutionEngineRef ptr;

    /**
        Initialized execution engine for module
    */
    this(Module mod) {
        char** errPtr = new char*;
        LLVMCreateExecutionEngineForModule(&ptr, mod.ptr, errPtr);
    }

    ~this() {
        LLVMDisposeExecutionEngine(ptr);
    }

    /**
        Run function
    */
    GenericValue RunFunction(Function func, GenericValue[] args) {
        
        // Convert D Value to LLVM native types
        LLVMGenericValueRef[] refs = new LLVMGenericValueRef[args.length];
        foreach(i, item; args) refs[i] = item.ptr; 

        return new GenericValue(LLVMRunFunction(ptr, func.ptr, cast(uint)refs.length, refs.ptr));
    }

    /**
        Adds a module to the execution engine
    */
    void AddModule(Module mod) {
        LLVMAddModule(ptr, mod.ptr);
    }
}

/**
    A generic LLVM Value
*/
class GenericValue {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMGenericValueRef ptr) {
        this.ptr = ptr;
    }

public:
    /**
        The LLVM level pointer to this object
    */
    LLVMGenericValueRef ptr;

    static GenericValue NewValue(T)(Type type, T value) if (isIntegral!T || is(T : bool)) {
        return new GenericValue(LLVMCreateGenericValueOfInt(type.ptr, cast(ulong)value, isSigned!T));
    }

    static GenericValue NewValue(T)(Type type, T value) if (isFloatingPoint!T) {
        return new GenericValue(LLVMCreateGenericValueOfFloat(type.ptr, cast(double)value));
    }

    static GenericValue NewValue(T)(T value) if (is(T == struct) && !isPointer!T) {
        return new GenericValue(LLVMCreateGenericValueOfPointer(&value));
    }

    static GenericValue NewValue(T)(T value) if (is(T == struct) && isPointer!T) {
        return new GenericValue(LLVMCreateGenericValueOfPointer(value));
    }

    static GenericValue NewValue(T)(T value) if (isArray!T) {
        return new GenericValue(LLVMCreateGenericValueOfPointer(value.ptr));
    }

    ~this() {
        LLVMDisposeGenericValue(ptr);
    }

    /**
        Gets value
    */
    T GetValue(T)() if (isIntegral!T || is(T : bool)) {
        return cast(T)LLVMGenericValueToInt(ptr, isSigned!T);
    }

    /**
        Gets value
    */
    T GetValue(T)() if (isFloatingPoint!T) {
        return cast(T)LLVMGenericValueToFloat(ptr);
    }

    /**
        Gets value
    */
    T GetValue(T)() if (is(T == struct) && !isPointer!T)  {
        return *cast(T*)LLVMGenericValueToPointer(ptr);
    }

    /**
        Gets value
    */
    T GetValue(T)() if (is(T == struct) && isPointer!T)  {
        return cast(T*)LLVMGenericValueToPointer(ptr);
    }

    /**
        Gets value
    */
    T GetValue(T)() if (isPointer!T) {
        return cast(T*)LLVMGenericValueToPointer(ptr);
    }
}
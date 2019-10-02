module dllvm.exengine;
import std.traits, std.string, std.algorithm.mutation, std.algorithm.searching;
import dllvm;
import llvm;

version (Windows) {
    enum USE_MC_JIT_DEFAULT = false;
} else {
    enum USE_MC_JIT_DEFAULT = true;
}

/**
    Initialize things needed for the execution engine
*/
void initExecutionEngine() {
    LLVMInitializeNativeTarget();
    LLVMInitializeNativeAsmPrinter();
}

/**
    The LLVM Execution Engine
*/
class ExecutionEngine {
private:
    Module[] managedModules;

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
    this(Module mod, bool useMCJIT = true) {
        char* error;
        if (useMCJIT) {
            LLVMMCJITCompilerOptions options;
            LLVMInitializeMCJITCompilerOptions(&options, options.sizeof);

            LLVMCreateMCJITCompilerForModule(&ptr, mod.ptr, &options, options.sizeof, &error);
        } else {
            LLVMCreateExecutionEngineForModule(&ptr, mod.ptr, &error);
        }

        if (error) {
            scope (exit) LLVMDisposeMessage(error);
            throw new Exception(error.fromStringz().idup);
        }

        // Add to the managed modules list.
        managedModules ~= mod;
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
        managedModules ~= mod;
    }

    /**
        Removes the module from the execution engine
    */
    void RemoveModule(Module mod) {
        char* error;
        LLVMRemoveModule(ptr, mod.ptr, &mod.ptr, &error);
        if (error) throw new Exception(error.fromStringz.idup());

        managedModules.remove(managedModules.countUntil(mod));
    }

    /**
        Recompiles all modules
    */
    void RecompileAll() {
        // Copy the managed modules list
        Module[] modules = managedModules;

        foreach(module_; modules) {
            Recompile(module_);
        }
    }

    /**
        Recompiles a module
    */
    void Recompile(Module mod) {
        RemoveModule(mod);
        AddModule(mod);
    }

    /**
        Returns the function address of the specified function
    */
    T GetFunctionAddr(T)(string name) {
        return cast(T)LLVMGetFunctionAddress(ptr, name.toStringz);
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
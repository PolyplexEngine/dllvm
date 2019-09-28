module dllvm;
public import dllvm.values;
public import dllvm.enums;
public import dllvm.types;
public import dllvm.context;
public import dllvm.mod;
public import dllvm.basicblock;
public import dllvm.builder;
import llvm;
import std.string : toStringz, fromStringz;

/**
    Loads LLVM in to memory
*/
void loadLLVM() {
    LLVM.load();

    // Set the global context
    globalCtx = new Context(LLVMGetGlobalContext());
}

/**
    Unloads LLVM from memory
*/
void unloadLLVM() {
    // Destroy the global context
    globalCtx = null;

    LLVM.unload();
}

/**
    Converts an LLVM C string (with length provided) to a D UTF-8 string
*/
string cstrToStr(const(char)* cstr, size_t len) {
    return cast(string)cstr[0..len];
}

/**
    Converts a D UTF-8 string to a C string (with length provided)
*/
CStrInfo strToCstr(string str) {
    return CStrInfo(str.toStringz, str.length);
}

/**
    C string information
*/
struct CStrInfo {
    /**
        The C string
    */
    const(char)* cstr;

    /**
        The length of the string
    */
    size_t len;
}
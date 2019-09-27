module dllvm.values.globals;
import llvm;
import dllvm;
import dllvm.values;
import dllvm.enums;
import std.traits;
import std.string : fromStringz, toStringz;

/**
    A global value
*/
class GlobalValue : Value {
protected:
    this(LLVMValueRef ptr) {
        super(ptr);
    }

public:

    /**
        Gets the parent module
    */
    @property
    Module GlobalParent() {
        return new Module(LLVMGetGlobalParent(ptr));
    }

    /**
        Gets wether this global value is a declaration
    */
    @property
    bool IsDeclaration() {
        return cast(bool)LLVMIsDeclaration(ptr);
    }

    /**
        Gets the linkage type of the global value
    */
    @property
    LinkageType Linkage() {
        return cast(LinkageType)LLVMGetLinkage(ptr);
    }

    /**
        Sets the linkage type of the global value
    */
    @property
    void Linkage(LinkageType type) {
        LLVMSetLinkage(ptr, type);
    }

    /**
        Gets the section of the global value
    */
    @property
    string Section() {
        return cast(string)LLVMGetSection(ptr).fromStringz;
    }

    /**
        Sets the section of the global value
    */
    @property
    void Section(string value) {
        LLVMSetSection(ptr, value.toStringz);
    }

    /**
        Gets the visibility of the global value
    */
    @property
    VisibilityType Visibility() {
        return cast(VisibilityType)LLVMGetVisibility(ptr);
    }

    /**
        Sets the visibility of the global value
    */
    @property
    void Visibility(VisibilityType type) {
        LLVMSetVisibility(ptr, type);
    }

    /**
        Gets the visibility of the global value
    */
    @property
    StorageClassType StorageClass() {
        return cast(StorageClassType)LLVMGetDLLStorageClass(ptr);
    }

    /**
        Sets the visibility of the global value
    */
    @property
    void StorageClass(StorageClassType type) {
        LLVMSetDLLStorageClass(ptr, type);
    }

    /**
        Gets the significance of the unnamed address
    */
    @property
    AddressSignificance Significance() {
        return cast(AddressSignificance)LLVMGetUnnamedAddress(ptr);
    }

    /**
        Sets the significance of the unnamed address
    */
    @property
    void Significance(AddressSignificance value) {
        return LLVMSetUnnamedAddress(ptr, value);
    }

    /**
        Gets the value type of the global value
    */
    @property
    Type ValueType() {
        LLVMTypeRef type = LLVMGlobalGetValueType(ptr);
        return new Type(type, cast(TypeKind)LLVMGetTypeKind(type));
    }

    /**
        Gets the preferred alignment of the value
    */
    @property
    uint Alignment() {
        return LLVMGetAlignment(ptr);
    }

    /**
        Sets the preferred alignment of the value
    */
    @property
    void Alignment(uint bytes) {
        LLVMSetAlignment(ptr, bytes);
    }
}

/**
    A global variable
*/
class GlobalVariable : GlobalValue {
protected:
    this(LLVMValueRef ptr) {
        super(ptr);
    }
    
public:

}
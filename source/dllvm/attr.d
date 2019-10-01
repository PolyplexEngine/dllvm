module dllvm.attr;
import dllvm;
import llvm;

/**
    An LLVM attribute
*/
class Attribute {
package(dllvm):

    /// Hidden constructor for backend uses.
    this(LLVMAttributeRef ptr) {
        this.ptr = ptr;
    }

public:
    /**
        The LLVM level pointer to this object
    */
    LLVMAttributeRef ptr;
    
    /**
        Gets wether the attribute is an enum attribute.
    */
    @property
    bool IsEnumAttribute() {
        return cast(bool)LLVMIsEnumAttribute(ptr);
    }

    /**
        Gets wether the attribute is a string attribute
    */
    @property
    bool IsStringAttribute() {
        return cast(bool)LLVMIsStringAttribute(ptr);
    }

    /**
        Gets the attribute's kind as an enum
    */
    @property
    AttributeKind KindEnum() {
        return cast(AttributeKind)LLVMGetEnumAttributeKind(ptr);
    }

    /**
        Gets the attribute's value
    */
    @property
    size_t ValueEnum() {
        return LLVMGetEnumAttributeValue(ptr);
    }

    /**
        Gets the attribute's kind as a string
    */
    @property
    string KindString() {
        uint len;
        auto text = LLVMGetStringAttributeKind(ptr, &len);
        return cstrToStr(text, len);
    }

    /**
        Gets the attribute's value as a string
    */
    @property
    string ValueString() {
        uint len;
        auto text = LLVMGetStringAttributeValue(ptr, &len);
        return cstrToStr(text, len);
    }
}
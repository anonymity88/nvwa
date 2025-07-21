module {
  func.func @main() -> () {
    // Type operations
    %type1 = pdl.type
    %type2 = pdl.type : i32
    
    // Types operations
    %types = pdl.types
    %constantTypes = pdl.types : [i32, i64, i32]
    
    // Attribute operations
    %attr1 = pdl.attribute
    %type = pdl.type : i32
    %attr2 = pdl.attribute : %type
    %attr3 = pdl.attribute = "hello"
    
    return
  }
}
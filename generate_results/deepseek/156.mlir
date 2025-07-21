module {
  func.func @main() -> () {
    // Operators from the first fragment
    %attr1 = pdl.attribute
    %type = pdl.type : i32
    %attr2 = pdl.attribute : %type
    %attr3 = pdl.attribute = "hello"
    
    // Operators from the second fragment
    %types = pdl.types
    %constantTypes = pdl.types : [i32, i64, i32]
    
    // Operators from the third fragment
    %type1 = pdl.type
    %type2 = pdl.type : i32
    
    return
  }
}
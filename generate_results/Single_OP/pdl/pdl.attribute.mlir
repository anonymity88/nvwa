module {
  func.func @main() -> () {
    // Define an attribute:
    %attr1 = pdl.attribute

    // Define an attribute with an expected type:
    %type = pdl.type : i32
    %attr2 = pdl.attribute : %type

    // Define an attribute with a constant value:
    %attr3 = pdl.attribute = "hello"

    return
  }
}
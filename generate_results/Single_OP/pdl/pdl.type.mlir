module {
  func.func @main() -> () {
    // Define a type:
    %type1 = pdl.type

    // Define a type with a constant value:
    %type2 = pdl.type : i32

    return
  }
}
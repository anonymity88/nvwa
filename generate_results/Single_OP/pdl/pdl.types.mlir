module {
  func.func @main() -> () {
    // Define a range of types:
    %types = pdl.types

    // Define a range of types with a range of constant values:
    %constantTypes = pdl.types : [i32, i64, i32]

    return
  }
}
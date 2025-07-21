module {
  func.func @main() -> i32 {
    %0 = emitc.literal "Hello, World!" : i32
    return %0 : i32
  }
}
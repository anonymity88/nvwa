module {
  func.func @main() -> i32 {
    // Example unsigned integer value to cast
    %value = arith.constant 42 : i32

    // Casting the unsigned integer to index type using arith.indexcastui
    %index_cast = arith.index_castui %value : i32 to index

    // Return a value to avoid undefined behavior
    %result = arith.index_castui %index_cast : index to i32
    return %result : i32
  }
}
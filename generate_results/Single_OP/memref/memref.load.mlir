module {
  func.func @main(%arg0: memref<8x8xi32>, %i: index, %j: index) -> i32 {
    // Perform a load from the memref using provided indices
    %value = memref.load %arg0[%i, %j] : memref<8x8xi32>

    return %value : i32
  }
}
module {
  func.func @main(%arg: index) -> memref<8x?xf32, 1> {
    // Allocate a memref with dynamic size for the second dimension
    %0 = memref.alloc(%arg) : memref<8x?xf32, 1>

    // Load a default value from the allocated memref
    %index0 = arith.constant 0 : index      // index for the first dimension
    %index1 = arith.constant 0 : index      // index for the second dimension
    %default_value = memref.load %0[%index0, %index1] : memref<8x?xf32, 1>

    return %0 : memref<8x?xf32, 1>
  }
}
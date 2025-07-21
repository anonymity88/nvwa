module {
  func.func @main(%d: index, %s: index) -> memref<8x?xf32> {
    // Allocate a memref on the stack with dynamic dimensions
    %0 = memref.alloca(%d) : memref<8x?xf32>

    return %0 : memref<8x?xf32>
  }
}
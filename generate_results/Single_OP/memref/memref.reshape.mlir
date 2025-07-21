module {
  func.func @main(%src: memref<4x1xf32>, %shape: memref<1xi32>) -> memref<4xf32> {
    // Perform the reshape operation
    %dst = memref.reshape %src(%shape) : (memref<4x1xf32>, memref<1xi32>) -> memref<4xf32>
    
    return %dst : memref<4xf32>
  }
}
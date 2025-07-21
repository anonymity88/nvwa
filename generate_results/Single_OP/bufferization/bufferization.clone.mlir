module {
  func.func @main(%arg0: memref<?xf32>) -> memref<?xf32> {
    // Clone the input memref using bufferization.clone
    %result = bufferization.clone %arg0 : memref<?xf32> to memref<?xf32>

    return %result : memref<?xf32>
  }
}
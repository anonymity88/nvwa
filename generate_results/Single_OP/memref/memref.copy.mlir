module {
  func.func @main(%arg0: memref<10xf32>, %arg1: memref<10xf32>) -> () {
    // Copy data from source memref to target memref.
    memref.copy %arg0, %arg1 : memref<10xf32> to memref<10xf32>
    return
  }
}
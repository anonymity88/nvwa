module {
  func.func @main(%arg0: memref<*xf32>, %arg1: memref<?x?xf32>) -> (index, index) {
    %0 = memref.rank %arg0 : memref<*xf32>
    %1 = memref.rank %arg1 : memref<?x?xf32>
    return %0, %1 : index, index
  }
}
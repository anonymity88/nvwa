module {
  func.func @main(%A: memref<4x?xf32>) -> () {
    // Get the size of the first dimension
    %c0 = arith.constant 0 : index
    %x = memref.dim %A, %c0 : memref<4x?xf32>

    // Get the size of the second dimension
    %c1 = arith.constant 1 : index
    %y = memref.dim %A, %c1 : memref<4x?xf32>
    
    return
  }
}
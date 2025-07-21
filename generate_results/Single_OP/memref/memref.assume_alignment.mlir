module {
  func.func @main(%arg: memref<4xf32>) -> () {
    // Assume that the memory for 'arg' is aligned to a boundary of 64 bytes
    memref.assume_alignment %arg, 64 : memref<4xf32>
    
    // Here you could load a value from the memref, for example:
    %index = arith.constant 0 : index
    %value = memref.load %arg[%index] : memref<4xf32>

    return
  }
}
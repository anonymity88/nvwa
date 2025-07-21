module {
  memref.global @foo : memref<2xf32>

  func.func @main(%src: memref<64xf32>, %new_size: index, %arg: memref<4xf32>) -> memref<124xf32> {
    // Ensure alignment of input memref
    memref.assume_alignment %arg, 64 : memref<4xf32>
    
    // Load value from aligned memref
    %index = arith.constant 0 : index
    %value = memref.load %arg[%index] : memref<4xf32>

    // Reallocate memory from 64 to 124 elements
    %new = memref.realloc %src : memref<64xf32> to memref<124xf32>
    
    // Load value from reallocated memref
    %value_new = memref.load %new[%index] : memref<124xf32>
    
    // Access global memref
    %global_memref = memref.get_global @foo : memref<2xf32>
    
    return %new : memref<124xf32>
  }
}
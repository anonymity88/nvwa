module {
  func.func @main(%arg: memref<4x2x3xf32>, %dim: index, %src: memref<10xf32>, %dst: memref<10xf32>) -> (memref<8x3xf32>, memref<8x?xf32, 1>) {
    // Collapse shape operation
    %collapsed = memref.collapse_shape %arg [[0, 1], [2]] : 
      memref<4x2x3xf32> into memref<8x3xf32>
    
    // Allocate dynamic memref
    %alloc_memref = memref.alloc(%dim) : memref<8x?xf32, 1>
    
    // Load from allocated memref
    %index0 = arith.constant 0 : index
    %index1 = arith.constant 0 : index
    %default_value = memref.load %alloc_memref[%index0, %index1] : memref<8x?xf32, 1>
    
    // Copy between memrefs
    memref.copy %src, %dst : memref<10xf32> to memref<10xf32>
    
    return %collapsed, %alloc_memref : memref<8x3xf32>, memref<8x?xf32, 1>
  }
}
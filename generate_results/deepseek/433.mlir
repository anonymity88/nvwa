#map0 = affine_map<(d0, d1, d2) -> (d0 * 64 + d1 * 4 + d2)>
#map1 = affine_map<(d0, d1, d2) -> (d0 * 64 + d1 * 4 + d2 + 8)>

module {
  func.func @main(%arg0: memref<10xf32>, %arg1: memref<10xf32>, 
                  %arg2: memref<*xf32>, %arg3: memref<?x?xf32>,
                  %arg4: memref<8x16x4xf32, #map0>, %sz: index) 
                  -> (index, index, memref<4x4x4xf32, #map1>, index, index) {
    // Copy operation
    memref.copy %arg0, %arg1 : memref<10xf32> to memref<10xf32>
    
    // Rank operations
    %rank0 = memref.rank %arg2 : memref<*xf32>
    %rank1 = memref.rank %arg3 : memref<?x?xf32>
    
    // Subview operation
    %subview = memref.subview %arg4[0, 2, 0][4, 4, 4][1, 1, 1]
      : memref<8x16x4xf32, #map0> to memref<4x4x4xf32, #map1>
    
    // Call to memref_alloc function
    %alloc_dim0, %alloc_dim1 = call @memref_alloc(%sz) : (index) -> (index, index)
    
    return %rank0, %rank1, %subview, %alloc_dim0, %alloc_dim1 : 
      index, index, memref<4x4x4xf32, #map1>, index, index
  }

  func.func @memref_alloc(%sz: index) -> (index, index) {
    %0 = memref.alloc(%sz) : memref<6x?xf32>
    %1 = "test.reify_bound"(%0) {dim = 0} : (memref<6x?xf32>) -> (index)
    %2 = "test.reify_bound"(%0) {dim = 1} : (memref<6x?xf32>) -> (index)
    return %1, %2 : index, index
  }
}
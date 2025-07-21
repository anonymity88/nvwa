#map0 = affine_map<(d0, d1, d2) -> (d0 * 64 + d1 * 4 + d2)>
#map1 = affine_map<(d0, d1, d2) -> (d0 * 64 + d1 * 4 + d2 + 8)>

module {
  func.func @main(%arg0: memref<10xf32>, %arg1: memref<10xf32>, 
                  %arg2: memref<*xf32>, %arg3: memref<?x?xf32>,
                  %arg4: memref<8x16x4xf32, #map0>) -> (index, index, memref<4x4x4xf32, #map1>) {
    // Copy operation between two 1D memrefs
    memref.copy %arg0, %arg1 : memref<10xf32> to memref<10xf32>
    
    // Get ranks of unranked and dynamic memrefs
    %rank0 = memref.rank %arg2 : memref<*xf32>
    %rank1 = memref.rank %arg3 : memref<?x?xf32>
    
    // Create subview of the 3D memref
    %subview = memref.subview %arg4[0, 2, 0][4, 4, 4][1, 1, 1]
      : memref<8x16x4xf32, #map0> to memref<4x4x4xf32, #map1>
    
    return %rank0, %rank1, %subview : index, index, memref<4x4x4xf32, #map1>
  }
}
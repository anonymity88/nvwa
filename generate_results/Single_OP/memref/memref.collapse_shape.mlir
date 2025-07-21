module {
  func.func @main(%arg: memref<4x2x3xf32>) -> memref<8x3xf32> {
    // Collapse the shape from (4, 2, 3) to (8, 3)
    %collapsed = memref.collapse_shape %arg [[0, 1], [2]] : 
      memref<4x2x3xf32> into memref<8x3xf32>
    
    return %collapsed : memref<8x3xf32>
  }
}
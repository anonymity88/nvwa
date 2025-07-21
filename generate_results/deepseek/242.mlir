#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @main(
      %src: memref<64xf32>, 
      %new_size: index,
      %A: memref<4x?xf32>,
      %arg0: memref<?x?xf32>,
      %arg1: memref<4xf32>,
      %arg2: memref<12x4xf32, strided<[4, 1], offset: 5>>,
      %expand_arg: memref<1x?xf32, strided<[?, ?], offset: ?>>,
      %sz0: index
  ) -> (memref<124xf32>, memref<1x2x?xf32, strided<[?, ?, ?], offset: ?>>) {
    %new = memref.realloc %src : memref<64xf32> to memref<124xf32>
    
    %index = arith.constant 0 : index
    %value = memref.load %new[%index] : memref<124xf32>
    
    %c0 = arith.constant 0 : index
    %x = memref.dim %A, %c0 : memref<4x?xf32>
    %c1 = arith.constant 1 : index
    %y = memref.dim %A, %c1 : memref<4x?xf32>
    
    %cast1 = memref.cast %arg0 : memref<?x?xf32> to memref<4x4xf32>
    %cast2 = memref.cast %arg1 : memref<4xf32> to memref<?xf32>
    %cast3 = memref.cast %arg2 : memref<12x4xf32, strided<[4, 1], offset: 5>> to 
                                memref<12x4xf32, strided<[?, ?], offset: ?>>
    
    %expanded = call @expand_shape_dynamic_with_non_identity_layout(%expand_arg, %sz0) : 
        (memref<1x?xf32, strided<[?, ?], offset: ?>>, index) -> 
        memref<1x2x?xf32, strided<[?, ?, ?], offset: ?>>
    
    return %new, %expanded : memref<124xf32>, memref<1x2x?xf32, strided<[?, ?, ?], offset: ?>>
  }

  func.func @expand_shape_dynamic_with_non_identity_layout(
      %arg0 : memref<1x?xf32, strided<[?, ?], offset: ?>>, %sz0: index) ->
      memref<1x2x?xf32, strided<[?, ?, ?], offset: ?>> {
    %0 = memref.expand_shape %arg0 [[0], [1, 2]] output_shape [1, 2, %sz0] :
      memref<1x?xf32, strided<[?, ?], offset: ?>> into
      memref<1x2x?xf32, strided<[?, ?, ?], offset: ?>>
    return %0 : memref<1x2x?xf32, strided<[?, ?, ?], offset: ?>>
  }
}
module {
  memref.global @foo : memref<2xf32>

  func.func @main(%src: memref<64xf32>, %new_size: index, %arg: memref<4xf32>, %arg0: memref<20x42xf32>) -> (memref<124xf32>, memref<20x42xf32, strided<[42, 1], offset: 1>>) {
    // Operations from first IR
    memref.assume_alignment %arg, 64 : memref<4xf32>
    
    %index = arith.constant 0 : index
    %value = memref.load %arg[%index] : memref<4xf32>

    %new = memref.realloc %src : memref<64xf32> to memref<124xf32>
    
    %value_new = memref.load %new[%index] : memref<124xf32>
    
    %global_memref = memref.get_global @foo : memref<2xf32>
    
    // Call function from second IR
    %subview_result = call @no_fold_subview_with_non_zero_offset(%arg0) : (memref<20x42xf32>) -> memref<20x42xf32, strided<[42, 1], offset: 1>>
    
    return %new, %subview_result : memref<124xf32>, memref<20x42xf32, strided<[42, 1], offset: 1>>
  }

  func.func @no_fold_subview_with_non_zero_offset(%arg0 : memref<20x42xf32>) -> memref<20x42xf32, strided<[42, 1], offset: 1>> {
    %0 = memref.subview %arg0[0, 1] [20, 42] [1, 1] : memref<20x42xf32> to memref<20x42xf32, strided<[42, 1], offset: 1>>
    return %0 : memref<20x42xf32, strided<[42, 1], offset: 1>>
  }
}
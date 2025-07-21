module {
  func.func @main(%tag: memref<1xi32>, %num_elements: index, %arg0: memref<*xf32>, %arg1: memref<?x?xf32>, %arg: memref<4xf32>) -> (index, index) {
    %index = arith.constant 0 : index
    memref.dma_wait %tag[%index], %num_elements : memref<1xi32>

    memref.assume_alignment %arg, 64 : memref<4xf32>
    %value = memref.load %arg[%index] : memref<4xf32>

    %rank0 = memref.rank %arg0 : memref<*xf32>
    %rank1 = memref.rank %arg1 : memref<?x?xf32>

    %ptr_index = call @extract_aligned_pointer_as_index_of_unranked_source(%arg0) : (memref<*xf32>) -> index

    return %rank0, %rank1 : index, index
  }

  func.func @extract_aligned_pointer_as_index_of_unranked_source(%arg0: memref<*xf32>) -> index {
    %r = memref.reinterpret_cast %arg0 to offset: [0], sizes: [], strides: [] : memref<*xf32> to memref<f32>
    %i = memref.extract_aligned_pointer_as_index %r : memref<f32> -> index
    return %i : index
  }
}
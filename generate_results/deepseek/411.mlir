module {
  func.func @main(%arg0: !shape.shape, %arg1: !shape.shape, %tensor_arg: tensor<2x3xf32>, %idx: index) -> (index, index) {
    %const_size = "shape.const_size"() {value = 10 : index} : () -> !shape.size
    %size_to_index_result = "shape.size_to_index"(%const_size) : (!shape.size) -> index
    %min_shape_result = shape.min %arg0, %arg1 : !shape.shape, !shape.shape -> !shape.shape
    
    // Call the get_extent_shape_of function
    %extent_result = call @get_extent_shape_of(%tensor_arg, %idx) : (tensor<2x3xf32>, index) -> index
    
    return %size_to_index_result, %extent_result : index, index
  }

  func.func @get_extent_shape_of(%arg : tensor<2x3xf32>, %idx : index) -> index {
    %shape = shape.shape_of %arg : tensor<2x3xf32> -> tensor<?xindex>
    %result = shape.get_extent %shape, %idx : tensor<?xindex>, index -> index
    return %result : index
  }
}
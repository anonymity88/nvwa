module {
  func.func @main(%arg0: !shape.size, %arg1: !shape.shape, %arg2: !shape.shape) -> tensor<1xindex> {
    // Convert size to index
    %size_to_index_result = "shape.size_to_index"(%arg0) : (!shape.size) -> index
    
    // Compute max of two shapes
    %max_shape_result = shape.max %arg1, %arg2 : !shape.shape, !shape.shape -> !shape.shape
    
    // Convert the resulting shape to extent tensor
    %extent_tensor_result = shape.to_extent_tensor %max_shape_result : !shape.shape -> tensor<1xindex>
    
    // Return the extent tensor
    return %extent_tensor_result : tensor<1xindex>
  }
}
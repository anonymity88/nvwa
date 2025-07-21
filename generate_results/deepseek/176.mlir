module {
  func.func @main(%arg0: !shape.shape, %arg1: !shape.shape, %arg2: !shape.value_shape<tensor<2x3xf32>>, %arg3: tensor<5xindex>) -> tensor<2x3xf32> {
    // Compute maximum of two shapes
    %max_shape = shape.max %arg0, %arg1 : !shape.shape, !shape.shape -> !shape.shape
    
    // Convert extent tensor to shape
    %from_extent_shape = "shape.from_extent_tensor"(%arg3) : (tensor<5xindex>) -> !shape.shape
    
    // Extract value from value_shape
    %value = "shape.value_of"(%arg2) : (!shape.value_shape<tensor<2x3xf32>>) -> tensor<2x3xf32>
    
    // Return the extracted value
    return %value : tensor<2x3xf32>
  }
}
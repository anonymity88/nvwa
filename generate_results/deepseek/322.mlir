module {
  func.func @main(%arg0: !shape.shape, %arg1: !shape.shape, %arg2: !shape.value_shape<tensor<2x3xf32>>, %arg3: tensor<5xindex>) -> tensor<2x3xf32> {
    %max_shape = shape.max %arg0, %arg1 : !shape.shape, !shape.shape -> !shape.shape
    
    %from_extent_shape = "shape.from_extent_tensor"(%arg3) : (tensor<5xindex>) -> !shape.shape
    
    // Get the size of the max_shape for size_upper_bounded_by_constant function
    %size = shape.num_elements %max_shape : !shape.shape -> !shape.size
    %bounded_size = call @size_upper_bounded_by_constant(%size) : (!shape.size) -> !shape.size
    
    %value = "shape.value_of"(%arg2) : (!shape.value_shape<tensor<2x3xf32>>) -> tensor<2x3xf32>
    
    return %value : tensor<2x3xf32>
  }

  func.func @size_upper_bounded_by_constant(%a: !shape.size) -> !shape.size {
    %0 = shape.const_size 5
    %1 = shape.max %a, %0 : !shape.size, !shape.size -> !shape.size
    %2 = shape.meet %0, %1, error="exceeded element-wise upper bound" : 
      !shape.size, !shape.size -> !shape.size
    return %2 : !shape.size
  }
}
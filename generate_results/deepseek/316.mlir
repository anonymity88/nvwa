module {
  func.func @main(%arg0: !shape.shape, %shape1: !shape.shape, %shape2: !shape.shape, %dummy_value: tensor<1xf32>) -> tensor<1xindex> {
    %num_elements = shape.num_elements %arg0 : !shape.shape -> !shape.size
    
    %shape_equality = shape.shape_eq %shape1, %shape2 : !shape.shape, !shape.shape
    
    %extent_tensor = shape.to_extent_tensor %arg0 : !shape.shape -> tensor<1xindex>
    
    // Create value_shape from dummy value
    %value_shape = "shape.value_shape"(%dummy_value) : (tensor<1xf32>) -> !shape.value_shape
    
    // Call the value_shape_with_shape function
    %result_tensor = call @value_shape_with_shape(%value_shape, %value_shape) : (!shape.value_shape, !shape.value_shape) -> tensor<?xf32>
    
    return %extent_tensor : tensor<1xindex>
  }

  func.func @value_shape_with_shape(%arg0: !shape.value_shape, %arg1: !shape.value_shape) -> tensor<?xf32> {
    %1 = shape.shape_of %arg0 : !shape.value_shape -> !shape.shape
    %2 = shape.with_shape %arg1, %1 : !shape.value_shape, !shape.shape
    %3 = shape.value_of %2 : tensor<?xf32>
    return %3 : tensor<?xf32>
  }
}
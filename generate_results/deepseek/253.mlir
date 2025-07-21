module {
  func.func @main(%arg0: !shape.value_shape, %arg1: tensor<2xi32>, %pred: i1) -> !shape.witness {
    %value_as_shape_result = shape.value_as_shape %arg1 : tensor<2xi32> -> !shape.shape
    %with_shape_result = shape.with_shape %arg0, %value_as_shape_result : !shape.value_shape, !shape.shape
    %witness_result = shape.cstr_require %pred, "Assertion message"
    
    // Convert shape to extent tensor and pass to the other function
    %extent_tensor = shape.to_extent_tensor %value_as_shape_result : !shape.shape -> tensor<?xindex>
    %result = call @to_extent_tensor(%extent_tensor) : (tensor<?xindex>) -> tensor<3xindex>
    
    return %witness_result : !shape.witness
  }

  func.func @to_extent_tensor(%arg: tensor<?xindex>) -> tensor<3xindex> {
    %casted = shape.to_extent_tensor %arg : tensor<?xindex> -> tensor<3xindex>
    return %casted : tensor<3xindex>
  }
}
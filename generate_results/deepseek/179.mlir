module {
  func.func @main(%arg0: !shape.value_shape, %arg1: tensor<2xi32>, %pred: i1) -> !shape.witness {
    // Convert tensor to shape
    %value_as_shape_result = shape.value_as_shape %arg1 : tensor<2xi32> -> !shape.shape
    
    // Combine value_shape with shape
    %with_shape_result = shape.with_shape %arg0, %value_as_shape_result : !shape.value_shape, !shape.shape
    
    // Conditional requirement based on predicate
    %witness_result = shape.cstr_require %pred, "Assertion message"
    
    // Return the witness result
    return %witness_result : !shape.witness
  }
}
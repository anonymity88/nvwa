module {
  func.func @main(%arg0: !shape.size, %arg1: !shape.shape, %arg2: !shape.shape) -> tensor<1xindex> {
    %size_to_index_result = "shape.size_to_index"(%arg0) : (!shape.size) -> index
    
    %max_shape_result = shape.max %arg1, %arg2 : !shape.shape, !shape.shape -> !shape.shape
    
    // Call the f function which has side effects
    call @f() : () -> ()
    
    %extent_tensor_result = shape.to_extent_tensor %max_shape_result : !shape.shape -> tensor<1xindex>
    
    return %extent_tensor_result : tensor<1xindex>
  }

  func.func @f() {
    %0 = shape.const_witness true
    %1 = shape.assuming %0 -> index {
      %2 = "test.source"() : () -> (index)
      shape.assuming_yield %2 : index
    }
    "test.sink"(%1) : (index) -> ()
    return
  }
}
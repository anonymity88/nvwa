module {
  func.func @main(%shape1: !shape.shape, %shape2: !shape.shape, %extent_tensor: tensor<5xindex>, %arg0: index, %arg1: index) -> i1 {
    // Convert extent tensor to shape
    %from_extent_result = "shape.from_extent_tensor"(%extent_tensor) : (tensor<5xindex>) -> !shape.shape
    
    // Multiply two indices
    %mul_result = "shape.mul"(%arg0, %arg1) : (index, index) -> index
    
    // Compare two shapes for equality
    %shape_eq_result = "shape.shape_eq"(%shape1, %shape2) : (!shape.shape, !shape.shape) -> i1
    
    // Return the shape comparison result
    return %shape_eq_result : i1
  }
}
module {
  func.func @main(%arg0: !shape.shape, %shape1: !shape.shape, %shape2: !shape.shape) -> tensor<1xindex> {
    // Calculate number of elements in shape
    %num_elements = shape.num_elements %arg0 : !shape.shape -> !shape.size
    
    // Compare two shapes for equality
    %shape_equality = shape.shape_eq %shape1, %shape2 : !shape.shape, !shape.shape
    
    // Convert shape to extent tensor
    %extent_tensor = shape.to_extent_tensor %arg0 : !shape.shape -> tensor<1xindex>
    
    // Return the extent tensor result
    return %extent_tensor : tensor<1xindex>
  }
}
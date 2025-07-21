module {
  func.func @main(%arg0: index, %arg1: index, %shape1: !shape.shape, %shape2: !shape.shape) -> !shape.shape {
    // Create shapes from extents
    %extent_shape1 = shape.from_extents %arg0 : index
    %extent_shape2 = shape.from_extents %arg1 : index
    
    // Broadcast the two shapes created from extents
    %broadcast_result = shape.broadcast %extent_shape1, %extent_shape2 : !shape.shape, !shape.shape -> !shape.shape
    
    // Compute the minimum between the broadcast result and first input shape
    %min_result1 = shape.min %broadcast_result, %shape1 : !shape.shape, !shape.shape -> !shape.shape
    
    // Compute the minimum between the previous result and second input shape
    %min_result2 = shape.min %min_result1, %shape2 : !shape.shape, !shape.shape -> !shape.shape
    
    // Return the final shape
    return %min_result2 : !shape.shape
  }
}
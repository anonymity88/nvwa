module {
  func.func @main(%arg0: index, %arg1: index, %shape1: !shape.shape, %shape2: !shape.shape, %unranked_input: tensor<*xf32>) -> (!shape.shape, tensor<*xf32>) {
    // Shape operations
    %extent_shape1 = shape.from_extents %arg0 : index
    %extent_shape2 = shape.from_extents %arg1 : index
    %broadcast_result = shape.broadcast %extent_shape1, %extent_shape2 : !shape.shape, !shape.shape -> !shape.shape
    %min_result1 = shape.min %broadcast_result, %shape1 : !shape.shape, !shape.shape -> !shape.shape
    %min_result2 = shape.min %min_result1, %shape2 : !shape.shape, !shape.shape -> !shape.shape
    
    // Call unranked tensor lowering function
    %processed_tensor = call @unranked_tensor_lowering(%unranked_input) : (tensor<*xf32>) -> tensor<*xf32>
    
    return %min_result2, %processed_tensor : !shape.shape, tensor<*xf32>
  }

  func.func @unranked_tensor_lowering(%input: tensor<*xf32>) -> tensor<*xf32> {
    %input_shape = shape.shape_of %input : tensor<*xf32> -> tensor<?xindex>
    %input_size = shape.num_elements %input_shape : tensor<?xindex> -> index
    %input_collapsed_shape = tensor.from_elements %input_size : tensor<1xindex>
    %input_collapsed = tensor.reshape %input(%input_collapsed_shape) : (tensor<*xf32>, tensor<1xindex>) -> tensor<?xf32>
    %one = arith.constant 1.0 : f32
    %one_splat = tensor.splat %one[%input_size] : tensor<?xf32>
    %sum_collapsed = arith.addf %input_collapsed, %one_splat : tensor<?xf32>
    %sum = tensor.reshape %sum_collapsed(%input_shape) : (tensor<?xf32>, tensor<?xindex>) -> tensor<*xf32>
    %sum_shape = shape.shape_of %sum : tensor<*xf32> -> tensor<?xindex>
    %sum_size = shape.num_elements %sum_shape : tensor<?xindex> -> index
    %sum_collapsed_shape = tensor.from_elements %sum_size : tensor<1xindex>
    %sum_collapsed_0 = tensor.reshape %sum(%sum_collapsed_shape) : (tensor<*xf32>, tensor<1xindex>) -> tensor<?xf32>
    %two = arith.constant 2.0 : f32
    %two_splat = tensor.splat %two[%sum_size] : tensor<?xf32>
    %product_collapsed = arith.mulf %sum_collapsed_0, %two_splat : tensor<?xf32>
    %product = tensor.reshape %product_collapsed(%sum_shape) : (tensor<?xf32>, tensor<?xindex>) -> tensor<*xf32>
    return %product : tensor<*xf32>
  }
}
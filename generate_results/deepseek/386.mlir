module {
  func.func @main(%shape1: !shape.shape, %shape2: !shape.shape, %extent_tensor: tensor<5xindex>, %arg0: index, %arg1: index, %dynamic_tensor1: tensor<?x4x?xf32>, %dynamic_tensor2: tensor<2x4x?xf32>) -> (i1, tensor<?x4x?xf32>) {
    %from_extent_result = "shape.from_extent_tensor"(%extent_tensor) : (tensor<5xindex>) -> !shape.shape
    
    %mul_result = "shape.mul"(%arg0, %arg1) : (index, index) -> index
    
    %shape_eq_result = "shape.shape_eq"(%shape1, %shape2) : (!shape.shape, !shape.shape) -> i1
    
    // Call the function that processes dynamic tensors
    %processed_tensor = call @two_dynamic_share_same_shape(%dynamic_tensor1, %dynamic_tensor2) : (tensor<?x4x?xf32>, tensor<2x4x?xf32>) -> tensor<?x4x?xf32>
    
    return %shape_eq_result, %processed_tensor : i1, tensor<?x4x?xf32>
  }

  func.func @two_dynamic_share_same_shape(%arg0: tensor<?x4x?xf32>, %arg1: tensor<2x4x?xf32>) -> tensor<?x4x?xf32> {
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c4 = arith.constant 4 : index
    %0 = shape.shape_of %arg0 : tensor<?x4x?xf32> -> tensor<3xindex>
    %1 = shape.get_extent %0, %c2 : tensor<3xindex>, index -> index
    %2 = "test.concat"(%arg0, %arg1) {axis = 0 : i64} : (tensor<?x4x?xf32>, tensor<2x4x?xf32>) -> tensor<?x4x?xf32>
    %3 = shape.get_extent %0, %c0 : tensor<3xindex>, index -> index
    %4 = arith.addi %3, %c2 : index
    %5 = shape.from_extents %4, %c4, %1 : index, index, index
    %6 = shape.with_shape %2, %5 : tensor<?x4x?xf32>, !shape.shape
    %7 = shape.value_of %6 : tensor<?x4x?xf32>
    %8 = "test.abs"(%7) : (tensor<?x4x?xf32>) -> tensor<?x4x?xf32>
    %9 = shape.with_shape %8, %5 : tensor<?x4x?xf32>, !shape.shape
    %10 = shape.value_of %9 : tensor<?x4x?xf32>
    return %10 : tensor<?x4x?xf32>
  }
}
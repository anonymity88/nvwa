module {
  func.func @main(%lhs: tensor<4x8xi8>, 
                  %rhs: tensor<8x6xi8>, 
                  %lhs_zero_point: i32, 
                  %rhs_zero_point: i32, 
                  %output: tensor<4x6xi32>) -> tensor<4x6xi32> {
    %0 = linalg.quantized_matmul
         ins(%lhs, %rhs, %lhs_zero_point, %rhs_zero_point : tensor<4x8xi8>, tensor<8x6xi8>, i32, i32)
         outs(%output : tensor<4x6xi32>) -> tensor<4x6xi32>

    return %0 : tensor<4x6xi32>
  }
}
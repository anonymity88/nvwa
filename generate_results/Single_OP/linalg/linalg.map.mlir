module {
  func.func @main(%lhs: tensor<64xf32>, %rhs: tensor<64xf32>, %init: tensor<64xf32>) -> tensor<64xf32> {
    %add = linalg.map 
         ins(%lhs, %rhs : tensor<64xf32>, tensor<64xf32>)
         outs(%init : tensor<64xf32>)
         (%lhs_elem: f32, %rhs_elem: f32) {
          %0 = arith.addf %lhs_elem, %rhs_elem: f32
          linalg.yield %0: f32
        }

    return %add : tensor<64xf32>
  }
}
func.func @generalize_elemwise_log(%lhs : tensor<4x8xf32>, %output : tensor<4x8xf32>) -> tensor<4x8xf32> {
  %0 = linalg.elemwise_unary {fun = #linalg.unary_fn<log>}
                              ins(%lhs: tensor<4x8xf32>) outs(%output: tensor<4x8xf32>) -> tensor<4x8xf32>
  return %0: tensor<4x8xf32>
}
module {
  func.func @transpose_conv2d_example(%input: tensor<1x32x32x8xf32>, %filter: tensor<16x8x3x3xf32>, %bias: tensor<16xf32>) -> tensor<1x34x34x16xf32> {
    %0 = "tosa.transpose_conv2d"(%input, %filter, %bias) {out_pad = array<i64: 1, 1, 1, 1>, stride = array<i64: 1, 1>, out_shape = array<i64: 1, 34, 34, 16>} : (tensor<1x32x32x8xf32>, tensor<16x8x3x3xf32>, tensor<16xf32>) -> tensor<1x34x34x16xf32>
    return %0 : tensor<1x34x34x16xf32>
  }
}
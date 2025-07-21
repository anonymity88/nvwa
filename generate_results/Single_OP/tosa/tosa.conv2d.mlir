module {
  func.func @conv2d_example(%input: tensor<1x32x32x8xf32>, %weights: tensor<16x8x3x3xf32>, %bias: tensor<16xf32>) -> tensor<1x30x30x16xf32> {
    %0 = "tosa.conv2d"(%input, %weights, %bias) {pad = array<i64: 0, 0, 0, 0>, stride = array<i64: 1, 1>, dilation = array<i64: 1, 1>} : (tensor<1x32x32x8xf32>, tensor<16x8x3x3xf32>, tensor<16xf32>) -> tensor<1x30x30x16xf32>
    return %0 : tensor<1x30x30x16xf32>
  }
}
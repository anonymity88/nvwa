module {
  func.func @test_conv3d(%input: tensor<1x49x48x47x27xf32>, %weights: tensor<28x3x4x5x27xf32>, %bias: tensor<28xf32>) -> tensor<1x47x45x43x28xf32> {
    %0 = tosa.conv3d %input, %weights, %bias {pad = array<i64: 0, 0, 0, 0, 0, 0>, stride = array<i64: 1, 1, 1>, dilation = array<i64: 1, 1, 1>} : (tensor<1x49x48x47x27xf32>, tensor<28x3x4x5x27xf32>, tensor<28xf32>) -> tensor<1x47x45x43x28xf32>
    return %0 : tensor<1x47x45x43x28xf32>
  }
}
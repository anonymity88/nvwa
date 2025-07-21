module {
  func.func @test_resize(%arg0: tensor<1x28x28x3xf32>) -> tensor<1x56x56x3xf32> {
    %resize = "tosa.resize"(%arg0) {scale = array<i64: 2, 2, 1, 1>, offset = array<i64: 0, 0>, border = array<i64: 0, 0>, mode = "BILINEAR"} : (tensor<1x28x28x3xf32>) -> tensor<1x56x56x3xf32>
    return %resize : tensor<1x56x56x3xf32>
  }
}
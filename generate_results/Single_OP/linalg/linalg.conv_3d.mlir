module {
  func.func @main(%input: tensor<10x20x5xf32>, %filter: tensor<3x3x3xf32>, %output: tensor<8x18x3xf32>) -> tensor<8x18x3xf32> {
    %result = linalg.conv_3d
         ins(%input, %filter : tensor<10x20x5xf32>, tensor<3x3x3xf32>)
         outs(%output : tensor<8x18x3xf32>) -> tensor<8x18x3xf32>

    return %result : tensor<8x18x3xf32>
  }
}
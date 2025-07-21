module {
  func.func @main(%input: tensor<5x3x100xf32>, %filter: tensor<4x3x10xf32>, %output: tensor<5x4x91xf32>) -> tensor<5x4x91xf32> {
    %result = linalg.conv_1d_ncw_fcw {strides = dense<1> : tensor<1xi64>, dilations = dense<1> : tensor<1xi64>}
               ins(%input, %filter : tensor<5x3x100xf32>, tensor<4x3x10xf32>)
               outs(%output : tensor<5x4x91xf32>) -> tensor<5x4x91xf32>

    return %result : tensor<5x4x91xf32>
  }
}
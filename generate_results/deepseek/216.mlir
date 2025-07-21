module {
  func.func @combined_ops(%input1: tensor<4xi32>, 
                          %input2: tensor<4xi32>,
                          %in_real: tensor<2x8x9xf32>,
                          %in_imag: tensor<2x8x9xf32>,
                          %arg3: tensor<2x8x9xf32>,
                          %arg4: tensor<2x8x9xf32>) -> (tensor<4xi1>,
                                                       tensor<2x8xi32>,
                                                       tensor<4xi32>,
                                                       tensor<4xi32>,
                                                       tensor<4xi1>,
                                                       tensor<2x8x9xf32>,
                                                       tensor<2x8x9xf32>) {
    // Equal operation
    %equal_result = "tosa.equal"(%input1, %input2) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>

    // Tile example (using constants)
    %tile_input = "tosa.const"() <{value = dense<[[1, 2, 3, 4], [5, 6, 7, 8]]> : tensor<2x4xi32>}> : () -> tensor<2x4xi32>
    %tiled = tosa.tile %tile_input {multiples = array<i64: 1, 2>} : (tensor<2x4xi32>) -> tensor<2x8xi32>
    %tile_const = "tosa.const"() <{value = dense<[[10, 10, 10, 10, 10, 10, 10, 10], 
                                                 [10, 10, 10, 10, 10, 10, 10, 10]]> : tensor<2x8xi32>}> : () -> tensor<2x8xi32>
    %tile_result = tosa.add %tiled, %tile_const : (tensor<2x8xi32>, tensor<2x8xi32>) -> tensor<2x8xi32>

    // Bitwise AND operation
    %bitwise_and = "tosa.bitwise_and"(%input1, %input2) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi32>

    // Count leading zeros operation
    %clz_result = "tosa.clz"(%input1) : (tensor<4xi32>) -> tensor<4xi32>

    // Greater equal operation
    %ge_result = "tosa.greater_equal"(%input1, %input2) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>

    // FFT2D operation with additions
    %fft_real, %fft_imag = "tosa.fft2d"(%in_real, %in_imag) {inverse = false} : (tensor<2x8x9xf32>, tensor<2x8x9xf32>) -> (tensor<2x8x9xf32>, tensor<2x8x9xf32>)
    %result_real = "tosa.add"(%fft_real, %arg3) : (tensor<2x8x9xf32>, tensor<2x8x9xf32>) -> tensor<2x8x9xf32>
    %result_imag = "tosa.add"(%fft_imag, %arg4) : (tensor<2x8x9xf32>, tensor<2x8x9xf32>) -> tensor<2x8x9xf32>

    return %equal_result, %tile_result, %bitwise_and, %clz_result, %ge_result, %result_real, %result_imag : 
           tensor<4xi1>, tensor<2x8xi32>, tensor<4xi32>, tensor<4xi32>, tensor<4xi1>, tensor<2x8x9xf32>, tensor<2x8x9xf32>
  }
}
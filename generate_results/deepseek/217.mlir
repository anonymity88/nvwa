module {
  func.func @main(%input_clz: tensor<4xi32>,
                  %input_exp: tensor<4xf32>,
                  %input_tanh: tensor<4xi32>,
                  %in_real: tensor<2x8x9xf32>,
                  %in_imag: tensor<2x8x9xf32>,
                  %arg3: tensor<2x8x9xf32>,
                  %arg4: tensor<2x8x9xf32>) -> (tensor<4xi32>,
                                               tensor<4xf32>,
                                               tensor<4xi32>,
                                               tensor<2x8x9xf32>,
                                               tensor<2x8x9xf32>,
                                               tensor<2x8xi32>) {
    // CLZ operation
    %clz_result = "tosa.clz"(%input_clz) : (tensor<4xi32>) -> tensor<4xi32>
    
    // EXP operation
    %exp_result = "tosa.exp"(%input_exp) : (tensor<4xf32>) -> tensor<4xf32>
    
    // Tanh operation
    %tanh_result = "tosa.tanh"(%input_tanh) : (tensor<4xi32>) -> tensor<4xi32>
    
    // FFT2D operation
    %fft_real, %fft_imag = "tosa.fft2d"(%in_real, %in_imag) {inverse = false} : (tensor<2x8x9xf32>, tensor<2x8x9xf32>) -> (tensor<2x8x9xf32>, tensor<2x8x9xf32>)
    
    // Add operations after FFT
    %result_real = "tosa.add"(%fft_real, %arg3) : (tensor<2x8x9xf32>, tensor<2x8x9xf32>) -> tensor<2x8x9xf32>
    %result_imag = "tosa.add"(%fft_imag, %arg4) : (tensor<2x8x9xf32>, tensor<2x8x9xf32>) -> tensor<2x8x9xf32>
    
    // Tile example (using some of the previous results)
    %tile_input = "tosa.const"() <{value = dense<[[1, 2, 3, 4], [5, 6, 7, 8]]> : tensor<2x4xi32>}> : () -> tensor<2x4xi32>
    %tile_result = tosa.tile %tile_input {multiples = array<i64: 1, 2>} : (tensor<2x4xi32>) -> tensor<2x8xi32>
    %const_tile = "tosa.const"() <{value = dense<[[10, 10, 10, 10, 10, 10, 10, 10], 
                                                 [10, 10, 10, 10, 10, 10, 10, 10]]> : tensor<2x8xi32>}> : () -> tensor<2x8xi32>
    %add_tile_result = tosa.add %tile_result, %const_tile : (tensor<2x8xi32>, tensor<2x8xi32>) -> tensor<2x8xi32>
    
    // Variable read operation (using a different type)
    tosa.variable @stored_var = dense<-1> : tensor<2x4x8xi32>
    %var_read = tosa.variable.read @stored_var : tensor<2x4x8xi16>
    
    return %clz_result, %exp_result, %tanh_result, %result_real, %result_imag, %add_tile_result : 
           tensor<4xi32>, tensor<4xf32>, tensor<4xi32>, tensor<2x8x9xf32>, tensor<2x8x9xf32>, tensor<2x8xi32>
  }
}
#trait_attribute = {
  doc = "Example of a linalg.generic operation",
  indexing_maps = [
    affine_map<(m, k, n) -> (m, k)>,
    affine_map<(m, k, n) -> (k, n)>,
    affine_map<(m, k, n) -> (m, n)>
  ],
  iterator_types = ["parallel", "reduction", "parallel"]
}

module {
  func.func @generic_matmul(%A: tensor<128x256xf32>, %B: tensor<256x128xf32>, %C_init: tensor<128x128xf32>) -> tensor<128x128xf32> {
    %result = linalg.generic #trait_attribute
        ins(%A, %B : tensor<128x256xf32>, tensor<256x128xf32>)
        outs(%C_init : tensor<128x128xf32>) {
      ^bb0(%a: f32, %b: f32, %c: f32):
        %mul = arith.mulf %a, %b : f32
        %add = arith.addf %c, %mul : f32
        linalg.yield %add : f32
    } -> tensor<128x128xf32>
    return %result : tensor<128x128xf32>
  }

  func.func @matmul_transpose_a(%A: tensor<4x3xf32>, %B: tensor<4x2xf32>, %C_init: tensor<3x2xf32>) -> tensor<3x2xf32> {
    %C = linalg.matmul_transpose_a 
         ins(%A, %B : tensor<4x3xf32>, tensor<4x2xf32>)
         outs(%C_init : tensor<3x2xf32>) -> tensor<3x2xf32>
    return %C : tensor<3x2xf32>
  }

  func.func @depthwise_conv_3d_ncdhw_cdhw(%input: tensor<2x6x6x13x12xf32>, %filter: tensor<6x2x1x3xf32>) -> tensor<2x6x3x13x4xf32> {
    %zero = arith.constant 0.000000e+00 : f32
    %init = tensor.empty() : tensor<2x6x3x13x4xf32>
    %fill = linalg.fill ins(%zero : f32) outs(%init : tensor<2x6x3x13x4xf32>) -> tensor<2x6x3x13x4xf32>
    %0 = linalg.depthwise_conv_3d_ncdhw_cdhw {dilations = dense<1> : tensor<3xi64>, strides = dense<[2, 1, 3]> : tensor<3xi64>}
      ins(%input, %filter : tensor<2x6x6x13x12xf32>, tensor<6x2x1x3xf32>)
      outs(%fill : tensor<2x6x3x13x4xf32>) -> tensor<2x6x3x13x4xf32>
    return %0 : tensor<2x6x3x13x4xf32>
  }

  func.func @main(
    %A_generic: tensor<128x256xf32>,
    %B_generic: tensor<256x128xf32>,
    %C_init_generic: tensor<128x128xf32>,
    %A_transpose: tensor<4x3xf32>,
    %B_transpose: tensor<4x2xf32>,
    %C_init_transpose: tensor<3x2xf32>,
    %input_conv: tensor<2x6x6x13x12xf32>,
    %filter_conv: tensor<6x2x1x3xf32>
  ) -> tensor<128x128xf32> {
    // Call generic matmul operation
    %generic_result = call @generic_matmul(%A_generic, %B_generic, %C_init_generic) : 
        (tensor<128x256xf32>, tensor<256x128xf32>, tensor<128x128xf32>) -> tensor<128x128xf32>
    
    // Call matmul transpose operation
    %transpose_result = call @matmul_transpose_a(%A_transpose, %B_transpose, %C_init_transpose) : 
        (tensor<4x3xf32>, tensor<4x2xf32>, tensor<3x2xf32>) -> tensor<3x2xf32>
    
    // Call depthwise convolution 3D operation
    %conv_result = call @depthwise_conv_3d_ncdhw_cdhw(%input_conv, %filter_conv) : 
        (tensor<2x6x6x13x12xf32>, tensor<6x2x1x3xf32>) -> tensor<2x6x3x13x4xf32>
    
    // Return the result from the generic matmul as the main output
    return %generic_result : tensor<128x128xf32>
  }
}
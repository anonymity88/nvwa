#map1 = affine_map<(d0, d1) -> (d0, d1)>
#map2 = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @generic_add_tensor(%input: tensor<2x3xf32>, %output: tensor<2x3xf32>) -> tensor<2x3xf32> {
    %0 = linalg.generic {
           indexing_maps = [#map1, #map2],
           iterator_types = ["parallel", "parallel"]
         }
         ins(%input : tensor<2x3xf32>)
         outs(%output : tensor<2x3xf32>) {
           ^bb0(%in: f32, %out: f32):
             %1 = arith.addf %in, %out : f32
             linalg.yield %1 : f32
         } -> tensor<2x3xf32>
    return %0 : tensor<2x3xf32>
  }

  func.func @conv_2d_ngchw_fgchw_tensor(
    %input: tensor<1x2x3x8x8xf32>,
    %filter: tensor<2x2x3x3x3xf32>,
    %output: tensor<1x2x2x6x6xf32>
  ) -> tensor<1x2x2x6x6xf32> {
    %0 = linalg.conv_2d_ngchw_fgchw 
         {strides = dense<[1, 1]> : tensor<2xi64>, 
          dilations = dense<[1, 1]> : tensor<2xi64>}
         ins(%input, %filter : tensor<1x2x3x8x8xf32>, tensor<2x2x3x3x3xf32>)
         outs(%output : tensor<1x2x2x6x6xf32>) -> tensor<1x2x2x6x6xf32>
    return %0 : tensor<1x2x2x6x6xf32>
  }

  func.func @depthwise_conv_1d_nwc_wcm_tensor(
    %input: tensor<1x12x8xf32>,
    %filter: tensor<3x8x8xf32>
  ) -> tensor<1x10x8x8xf32> {
    %zero = arith.constant 0.000000e+00 : f32
    %init = tensor.empty() : tensor<1x10x8x8xf32>
    %fill = linalg.fill ins(%zero : f32) outs(%init : tensor<1x10x8x8xf32>) -> tensor<1x10x8x8xf32>
    %0 = linalg.depthwise_conv_1d_nwc_wcm 
         {dilations = dense<1> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>}
         ins(%input, %filter : tensor<1x12x8xf32>, tensor<3x8x8xf32>)
         outs(%fill : tensor<1x10x8x8xf32>) -> tensor<1x10x8x8xf32>
    return %0 : tensor<1x10x8x8xf32>
  }

  func.func @main(
    %generic_input: tensor<2x3xf32>,
    %generic_output: tensor<2x3xf32>,
    %conv_input: tensor<1x2x3x8x8xf32>,
    %conv_filter: tensor<2x2x3x3x3xf32>,
    %conv_output: tensor<1x2x2x6x6xf32>,
    %depthwise_input: tensor<1x12x8xf32>,
    %depthwise_filter: tensor<3x8x8xf32>
  ) -> tensor<1x2x2x6x6xf32> {
    // Call generic add operation
    %generic_result = call @generic_add_tensor(%generic_input, %generic_output) 
                      : (tensor<2x3xf32>, tensor<2x3xf32>) -> tensor<2x3xf32>
    
    // Call 2D convolution operation
    %conv_result = call @conv_2d_ngchw_fgchw_tensor(%conv_input, %conv_filter, %conv_output)
                   : (tensor<1x2x3x8x8xf32>, tensor<2x2x3x3x3xf32>, tensor<1x2x2x6x6xf32>) -> tensor<1x2x2x6x6xf32>
    
    // Call depthwise convolution 1D operation
    %depthwise_result = call @depthwise_conv_1d_nwc_wcm_tensor(%depthwise_input, %depthwise_filter)
                        : (tensor<1x12x8xf32>, tensor<3x8x8xf32>) -> tensor<1x10x8x8xf32>
    
    // Use the convolution result as the final output
    return %conv_result : tensor<1x2x2x6x6xf32>
  }
}
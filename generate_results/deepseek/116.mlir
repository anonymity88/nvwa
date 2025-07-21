#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, d3)>
#map2 = affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2, d3, d4)>

module {
  // Map operation with element-wise addition
  func.func @map_add(%lhs: tensor<64xf32>, %rhs: tensor<64xf32>, %init: tensor<64xf32>) -> tensor<64xf32> {
    %add = linalg.map 
         ins(%lhs, %rhs : tensor<64xf32>, tensor<64xf32>)
         outs(%init : tensor<64xf32>)
         (%lhs_elem: f32, %rhs_elem: f32) {
          %0 = arith.addf %lhs_elem, %rhs_elem: f32
          linalg.yield %0: f32
        }
    return %add : tensor<64xf32>
  }

  // Depthwise convolution 1D
  func.func @depthwise_conv_1d(%input: tensor<1x12x8xf32>, %filter: tensor<3x8x8xf32>) -> tensor<1x10x8x8xf32> {
    %zero = arith.constant 0.000000e+00 : f32
    %init = tensor.empty() : tensor<1x10x8x8xf32>
    %fill = linalg.fill ins(%zero : f32) outs(%init : tensor<1x10x8x8xf32>) -> tensor<1x10x8x8xf32>
    %0 = linalg.depthwise_conv_1d_nwc_wcm {dilations = dense<1> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>}
      ins(%input, %filter : tensor<1x12x8xf32>, tensor<3x8x8xf32>)
      outs(%fill : tensor<1x10x8x8xf32>) -> tensor<1x10x8x8xf32>
    return %0 : tensor<1x10x8x8xf32>
  }

  // Quantized depthwise convolution 2D
  func.func @depthwise_conv_q(%arg0: tensor<?x?x?x?xi8>, %arg1: tensor<?x?x?x1xi8>, %arg2: tensor<?x?x?x?x1xi32>, %arg3 : i32, %arg4 : i32) -> tensor<?x?x?x?x1xi32> {
    %0 = linalg.depthwise_conv_2d_nhwc_hwcm_q {dilations = dense<1> : tensor<2xi64>, strides = dense<2> : tensor<2xi64>} 
         ins(%arg0, %arg1, %arg3, %arg4 : tensor<?x?x?x?xi8>, tensor<?x?x?x1xi8>, i32, i32) 
         outs(%arg2 : tensor<?x?x?x?x1xi32>) -> tensor<?x?x?x?x1xi32>
    return %0 : tensor<?x?x?x?x1xi32>
  }

  // Main function that calls all operations
  func.func @main(
    %lhs_map: tensor<64xf32>, 
    %rhs_map: tensor<64xf32>, 
    %init_map: tensor<64xf32>,
    %input_conv1d: tensor<1x12x8xf32>, 
    %filter_conv1d: tensor<3x8x8xf32>,
    %input_conv2d: tensor<?x?x?x?xi8>, 
    %filter_conv2d: tensor<?x?x?x1xi8>, 
    %output_conv2d: tensor<?x?x?x?x1xi32>,
    %arg3: i32, 
    %arg4: i32
  ) -> (tensor<64xf32>, tensor<1x10x8x8xf32>, tensor<?x?x?x?x1xi32>) {
    // Call map operation
    %map_result = call @map_add(%lhs_map, %rhs_map, %init_map) 
                  : (tensor<64xf32>, tensor<64xf32>, tensor<64xf32>) -> tensor<64xf32>
    
    // Call depthwise conv 1D
    %conv1d_result = call @depthwise_conv_1d(%input_conv1d, %filter_conv1d) 
                     : (tensor<1x12x8xf32>, tensor<3x8x8xf32>) -> tensor<1x10x8x8xf32>
    
    // Call quantized depthwise conv 2D
    %conv2d_result = call @depthwise_conv_q(%input_conv2d, %filter_conv2d, %output_conv2d, %arg3, %arg4) 
                     : (tensor<?x?x?x?xi8>, tensor<?x?x?x1xi8>, tensor<?x?x?x?x1xi32>, i32, i32) -> tensor<?x?x?x?x1xi32>
    
    // Return all results
    return %map_result, %conv1d_result, %conv2d_result : tensor<64xf32>, tensor<1x10x8x8xf32>, tensor<?x?x?x?x1xi32>
  }
}
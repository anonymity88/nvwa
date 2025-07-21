#map = affine_map<(i, j) -> (i, j)>

module {
  func.func @depthwise_conv_q(%arg0: tensor<?x?x?x?xi8>, %arg1: tensor<?x?x?x1xi8>, %arg2: tensor<?x?x?x?x1xi32>, %arg3 : i32, %arg4 : i32) -> tensor<?x?x?x?x1xi32> {
    %0 = linalg.depthwise_conv_2d_nhwc_hwcm_q {_someattr, dilations = dense<1> : tensor<2xi64>, strides = dense<2> : tensor<2xi64>} 
         ins(%arg0, %arg1, %arg3, %arg4 : tensor<?x?x?x?xi8>, tensor<?x?x?x1xi8>, i32, i32) 
         outs(%arg2 : tensor<?x?x?x?x1xi32>) -> tensor<?x?x?x?x1xi32>
    return %0 : tensor<?x?x?x?x1xi32>
  }

  func.func @quantized_matmul(%lhs: tensor<4x8xi8>, 
                             %rhs: tensor<8x6xi8>, 
                             %lhs_zero_point: i32, 
                             %rhs_zero_point: i32, 
                             %output: tensor<4x6xi32>) -> tensor<4x6xi32> {
    %0 = linalg.quantized_matmul
         ins(%lhs, %rhs, %lhs_zero_point, %rhs_zero_point : tensor<4x8xi8>, tensor<8x6xi8>, i32, i32)
         outs(%output : tensor<4x6xi32>) -> tensor<4x6xi32>
    return %0 : tensor<4x6xi32>
  }

  func.func @conv_2d(%input: tensor<28x28xf32>, %filter: tensor<3x3xf32>, %output: tensor<26x26xf32>) -> tensor<26x26xf32> {
    %result = linalg.conv_2d
         ins(%input, %filter : tensor<28x28xf32>, tensor<3x3xf32>)
         outs(%output : tensor<26x26xf32>) -> tensor<26x26xf32>
    return %result : tensor<26x26xf32>
  }

  func.func @main(
    %input_depthwise: tensor<?x?x?x?xi8>, 
    %filter_depthwise: tensor<?x?x?x1xi8>, 
    %output_depthwise: tensor<?x?x?x?x1xi32>,
    %lhs_matmul: tensor<4x8xi8>,
    %rhs_matmul: tensor<8x6xi8>,
    %lhs_zp: i32,
    %rhs_zp: i32,
    %output_matmul: tensor<4x6xi32>,
    %input_conv: tensor<28x28xf32>,
    %filter_conv: tensor<3x3xf32>,
    %output_conv: tensor<26x26xf32>,
    %I: memref<?x?xindex>,
    %J: memref<?x?xindex>
  ) -> tensor<26x26xf32> {
    // Call depthwise convolution
    %depthwise_result = call @depthwise_conv_q(%input_depthwise, %filter_depthwise, %output_depthwise, %lhs_zp, %rhs_zp) 
                        : (tensor<?x?x?x?xi8>, tensor<?x?x?x1xi8>, tensor<?x?x?x?x1xi32>, i32, i32) -> tensor<?x?x?x?x1xi32>
    
    // Call quantized matrix multiplication
    %matmul_result = call @quantized_matmul(%lhs_matmul, %rhs_matmul, %lhs_zp, %rhs_zp, %output_matmul)
                     : (tensor<4x8xi8>, tensor<8x6xi8>, i32, i32, tensor<4x6xi32>) -> tensor<4x6xi32>
    
    // Call regular 2D convolution
    %conv_result = call @conv_2d(%input_conv, %filter_conv, %output_conv)
                   : (tensor<28x28xf32>, tensor<3x3xf32>, tensor<26x26xf32>) -> tensor<26x26xf32>
    
    // Generic operation
    linalg.generic {indexing_maps = [#map, #map],
                    iterator_types = ["parallel", "parallel"]}
      outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
      ^bb0(%arg0 : index, %arg1 : index):
        %i = linalg.index 0 : index
        %j = linalg.index 1 : index
        linalg.yield %i, %j : index, index
    }
    
    return %conv_result : tensor<26x26xf32>
  }
}
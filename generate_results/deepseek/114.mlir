#map = affine_map<(i, j) -> (i, j)>

module {
  func.func @conv_2d_nhwc_hwcf_q(
    %input: tensor<1x28x28x3xi8>, 
    %kernel: tensor<3x3x3x8xi8>, 
    %input_zero_point: i32, 
    %kernel_zero_point: i32, 
    %output: tensor<1x26x26x8xi32>
  ) -> tensor<1x26x26x8xi32> {
    %result = linalg.conv_2d_nhwc_hwcf_q
        {strides = dense<[1, 1]> : tensor<2xi64>, dilations = dense<[1, 1]> : tensor<2xi64>}
        ins(%input, %kernel, %input_zero_point, %kernel_zero_point : tensor<1x28x28x3xi8>, tensor<3x3x3x8xi8>, i32, i32)
        outs(%output : tensor<1x26x26x8xi32>) -> tensor<1x26x26x8xi32>
    return %result : tensor<1x26x26x8xi32>
  }

  func.func @conv_2d_nchw_fchw(
    %input: tensor<1x3x32x32xf32>, 
    %filter: tensor<2x3x5x5xf32>, 
    %bias: tensor<2xf32>, 
    %output: tensor<1x2x28x28xf32>
  ) -> tensor<1x2x28x28xf32> {
    %0 = linalg.conv_2d_nchw_fchw 
         {strides = dense<[1, 1]> : tensor<2xi64>, 
          dilations = dense<[1, 1]> : tensor<2xi64>} 
         ins(%input, %filter : tensor<1x3x32x32xf32>, tensor<2x3x5x5xf32>) 
         outs(%output : tensor<1x2x28x28xf32>) -> tensor<1x2x28x28xf32>
    return %0 : tensor<1x2x28x28xf32>
  }

  func.func @pooling_ncw_max_tensor(
    %input: tensor<1x1x4xf32>
  ) -> tensor<1x1x2xf32> {
    %fake = tensor.empty() : tensor<3xf32>
    %init = tensor.empty() : tensor<1x1x2xf32>
    %cst = arith.constant 0.000000e+00 : f32
    %fill = linalg.fill ins(%cst : f32) outs(%init : tensor<1x1x2xf32>) -> tensor<1x1x2xf32>
    %res = linalg.pooling_ncw_max 
           {dilations = dense<1> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>}
           ins(%input, %fake: tensor<1x1x4xf32>, tensor<3xf32>)
           outs(%fill: tensor<1x1x2xf32>) -> tensor<1x1x2xf32>
    return %res : tensor<1x1x2xf32>
  }

  func.func @main(
    %input_quant: tensor<1x28x28x3xi8>, 
    %kernel_quant: tensor<3x3x3x8xi8>, 
    %input_zp: i32, 
    %kernel_zp: i32, 
    %output_quant: tensor<1x26x26x8xi32>,
    %input_conv: tensor<1x3x32x32xf32>, 
    %filter_conv: tensor<2x3x5x5xf32>, 
    %bias: tensor<2xf32>, 
    %output_conv: tensor<1x2x28x28xf32>,
    %input_pool: tensor<1x1x4xf32>,
    %I: memref<?x?xindex>, 
    %J: memref<?x?xindex>
  ) -> tensor<1x26x26x8xi32> {
    // Call quantized convolution
    %quant_result = call @conv_2d_nhwc_hwcf_q(
        %input_quant, %kernel_quant, %input_zp, %kernel_zp, %output_quant
    ) : (tensor<1x28x28x3xi8>, tensor<3x3x3x8xi8>, i32, i32, tensor<1x26x26x8xi32>) -> tensor<1x26x26x8xi32>
    
    // Call NCHW convolution
    %conv_result = call @conv_2d_nchw_fchw(
        %input_conv, %filter_conv, %bias, %output_conv
    ) : (tensor<1x3x32x32xf32>, tensor<2x3x5x5xf32>, tensor<2xf32>, tensor<1x2x28x28xf32>) -> tensor<1x2x28x28xf32>
    
    // Call pooling operation
    %pool_result = call @pooling_ncw_max_tensor(%input_pool) : (tensor<1x1x4xf32>) -> tensor<1x1x2xf32>
    
    // Generic operation
    linalg.generic {
        indexing_maps = [#map, #map],
        iterator_types = ["parallel", "parallel"]
    } outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
    ^bb0(%arg0: index, %arg1: index):
        %i = linalg.index 0 : index
        %j = linalg.index 1 : index
        linalg.yield %i, %j : index, index
    }
    
    return %quant_result : tensor<1x26x26x8xi32>
  }
}
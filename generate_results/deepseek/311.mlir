module {
  func.func @vecmat_multiply(%vec: tensor<4xf32>, %mat: tensor<4x3xf32>, %result: tensor<3xf32>) -> tensor<3xf32> {
    %0 = linalg.vecmat 
         ins(%vec, %mat : tensor<4xf32>, tensor<4x3xf32>) 
         outs(%result : tensor<3xf32>) -> tensor<3xf32>
    return %0 : tensor<3xf32>
  }

  func.func @conv_2d_nhwc_fhwc(
    %input: tensor<1x32x32x3xf32>, 
    %filter: tensor<3x3x3x3xf32>, 
    %output: tensor<1x30x30x3xf32>
  ) -> tensor<1x30x30x3xf32> {
    %0 = linalg.conv_2d_nhwc_fhwc 
         {strides = dense<[1, 1]> : tensor<2xi64>, 
          dilations = dense<[1, 1]> : tensor<2xi64>}
         ins(%input, %filter : tensor<1x32x32x3xf32>, tensor<3x3x3x3xf32>)
         outs(%output : tensor<1x30x30x3xf32>) -> tensor<1x30x30x3xf32>
    return %0 : tensor<1x30x30x3xf32>
  }

  func.func @elementwise_map(%lhs: tensor<64xf32>, %rhs: tensor<64xf32>, %init: tensor<64xf32>) -> tensor<64xf32> {
    %add = linalg.map 
         ins(%lhs, %rhs : tensor<64xf32>, tensor<64xf32>)
         outs(%init : tensor<64xf32>)
         (%lhs_elem: f32, %rhs_elem: f32) {
          %0 = arith.addf %lhs_elem, %rhs_elem: f32
          linalg.yield %0: f32
        }
    return %add : tensor<64xf32>
  }

  func.func @simple_KCRS_to_KCRSsr(%arg0: tensor<1x1x32x8xf32>, %arg1: tensor<1x1x1x1x8x32xf32>) -> tensor<1x1x1x1x8x32xf32> {
    %0 = tensor.pack %arg0 inner_dims_pos = [3, 2] inner_tiles = [8, 32] into %arg1 : tensor<1x1x32x8xf32> -> tensor<1x1x1x1x8x32xf32>
    return %0 : tensor<1x1x1x1x8x32xf32>
  }

  func.func @main(
    %lhs_map: tensor<64xf32>,
    %rhs_map: tensor<64xf32>,
    %init_map: tensor<64xf32>,
    %input_conv: tensor<1x32x32x3xf32>,
    %filter_conv: tensor<3x3x3x3xf32>,
    %output_conv: tensor<1x30x30x3xf32>,
    %vec_vecmat: tensor<4xf32>,
    %mat_vecmat: tensor<4x3xf32>,
    %result_vecmat: tensor<3xf32>,
    %pack_input: tensor<1x1x32x8xf32>,
    %pack_result: tensor<1x1x1x1x8x32xf32>
  ) -> (tensor<1x30x30x3xf32>, tensor<1x1x1x1x8x32xf32>) {
    %map_result = call @elementwise_map(%lhs_map, %rhs_map, %init_map) 
                  : (tensor<64xf32>, tensor<64xf32>, tensor<64xf32>) -> tensor<64xf32>
    
    %vecmat_result = call @vecmat_multiply(%vec_vecmat, %mat_vecmat, %result_vecmat)
                    : (tensor<4xf32>, tensor<4x3xf32>, tensor<3xf32>) -> tensor<3xf32>
    
    %conv_result = call @conv_2d_nhwc_fhwc(%input_conv, %filter_conv, %output_conv)
                  : (tensor<1x32x32x3xf32>, tensor<3x3x3x3xf32>, tensor<1x30x30x3xf32>) -> tensor<1x30x30x3xf32>
    
    %packed_result = call @simple_KCRS_to_KCRSsr(%pack_input, %pack_result)
                    : (tensor<1x1x32x8xf32>, tensor<1x1x1x1x8x32xf32>) -> tensor<1x1x1x1x8x32xf32>
    
    return %conv_result, %packed_result : tensor<1x30x30x3xf32>, tensor<1x1x1x1x8x32xf32>
  }
}
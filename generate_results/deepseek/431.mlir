#map = affine_map<(i, j) -> (i, j)>

module {
  func.func @matmul_transpose_a(
    %A: tensor<4x3xf32>, 
    %B: tensor<4x2xf32>, 
    %C_init: tensor<3x2xf32>
  ) -> tensor<3x2xf32> {
    %C = linalg.matmul_transpose_a 
         ins(%A, %B : tensor<4x3xf32>, tensor<4x2xf32>)
         outs(%C_init : tensor<3x2xf32>) -> tensor<3x2xf32>
    return %C : tensor<3x2xf32>
  }

  func.func @depthwise_conv_3d_ncdhw_cdhw(
    %input: tensor<2x6x6x13x12xf32>, 
    %filter: tensor<6x2x1x3xf32>
  ) -> tensor<2x6x3x13x4xf32> {
    %zero = arith.constant 0.000000e+00 : f32
    %init = tensor.empty() : tensor<2x6x3x13x4xf32>
    %fill = linalg.fill ins(%zero : f32) outs(%init : tensor<2x6x3x13x4xf32>) -> tensor<2x6x3x13x4xf32>
    %0 = linalg.depthwise_conv_3d_ncdhw_cdhw 
         {dilations = dense<1> : tensor<3xi64>, strides = dense<[2, 1, 3]> : tensor<3xi64>}
         ins(%input, %filter : tensor<2x6x6x13x12xf32>, tensor<6x2x1x3xf32>)
         outs(%fill : tensor<2x6x3x13x4xf32>) -> tensor<2x6x3x13x4xf32>
    return %0 : tensor<2x6x3x13x4xf32>
  }

  func.func @conv_3d_ndhwc_dhwcf_q(
    %input: tensor<1x5x5x5x3xf32>, 
    %filter: tensor<3x3x3x3x5xf32>, 
    %output: tensor<1x3x3x3x5xf32>, 
    %input_zero_point: tensor<f32>,
    %filter_zero_point: tensor<f32>
  ) -> tensor<1x3x3x3x5xf32> {
    %result = linalg.conv_3d_ndhwc_dhwcf_q 
         {strides = dense<[1, 1, 1]> : tensor<3xi64>,
          dilations = dense<[1, 1, 1]> : tensor<3xi64>} 
         ins(%input, %filter, %input_zero_point, %filter_zero_point : tensor<1x5x5x5x3xf32>, tensor<3x3x3x3x5xf32>, tensor<f32>, tensor<f32>)
         outs(%output : tensor<1x3x3x3x5xf32>) -> tensor<1x3x3x3x5xf32>
    return %result : tensor<1x3x3x3x5xf32>
  }

  func.func @pack_with_pad(%src: tensor<4225x12xf32>, %dest: tensor<265x16x16x1xf32>)
      -> tensor<265x16x16x1xf32> {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = tensor.pack %src
      padding_value(%cst : f32)
      inner_dims_pos = [0, 1]
      inner_tiles = [16, 1] into %dest
      : tensor<4225x12xf32> -> tensor<265x16x16x1xf32>
    return %0 : tensor<265x16x16x1xf32>
  }

  func.func @main(
    %A_matmul: tensor<4x3xf32>,
    %B_matmul: tensor<4x2xf32>,
    %C_init_matmul: tensor<3x2xf32>,
    %input_depthwise: tensor<2x6x6x13x12xf32>,
    %filter_depthwise: tensor<6x2x1x3xf32>,
    %input_conv3d: tensor<1x5x5x5x3xf32>,
    %filter_conv3d: tensor<3x3x3x3x5xf32>,
    %output_conv3d: tensor<1x3x3x3x5xf32>,
    %input_zero_point: tensor<f32>,
    %filter_zero_point: tensor<f32>,
    %I: memref<?x?xindex>,
    %J: memref<?x?xindex>,
    %src_pack: tensor<4225x12xf32>,
    %dest_pack: tensor<265x16x16x1xf32>
  ) -> (tensor<3x2xf32>, tensor<265x16x16x1xf32>) {
    %matmul_result = call @matmul_transpose_a(%A_matmul, %B_matmul, %C_init_matmul) 
                     : (tensor<4x3xf32>, tensor<4x2xf32>, tensor<3x2xf32>) -> tensor<3x2xf32>
    
    %depthwise_result = call @depthwise_conv_3d_ncdhw_cdhw(%input_depthwise, %filter_depthwise)
                       : (tensor<2x6x6x13x12xf32>, tensor<6x2x1x3xf32>) -> tensor<2x6x3x13x4xf32>
    
    %conv3d_result = call @conv_3d_ndhwc_dhwcf_q(
                      %input_conv3d, %filter_conv3d, %output_conv3d, 
                      %input_zero_point, %filter_zero_point)
                    : (tensor<1x5x5x5x3xf32>, tensor<3x3x3x3x5xf32>, tensor<1x3x3x3x5xf32>, 
                       tensor<f32>, tensor<f32>) -> tensor<1x3x3x3x5xf32>
    
    %pack_result = call @pack_with_pad(%src_pack, %dest_pack)
                  : (tensor<4225x12xf32>, tensor<265x16x16x1xf32>) -> tensor<265x16x16x1xf32>
    
    linalg.generic {indexing_maps = [#map, #map],
                    iterator_types = ["parallel", "parallel"]}
      outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
      ^bb0(%arg0 : index, %arg1 : index):
        %i = linalg.index 0 : index
        %j = linalg.index 1 : index
        linalg.yield %i, %j : index, index
    }
    
    return %matmul_result, %pack_result : tensor<3x2xf32>, tensor<265x16x16x1xf32>
  }
}
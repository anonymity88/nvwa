#map = affine_map<(i, j) -> (i, j)>

module {
  func.func @mmt4d_tensor(
    %lhs: tensor<4x5x2x3xf32>, 
    %rhs: tensor<4x5x2x3xf32>, 
    %output: tensor<4x4x2x2xf32>
  ) -> tensor<4x4x2x2xf32> {
    %0 = linalg.mmt4d
         ins(%lhs, %rhs : tensor<4x5x2x3xf32>, tensor<4x5x2x3xf32>)
         outs(%output : tensor<4x4x2x2xf32>) -> tensor<4x4x2x2xf32>
    return %0 : tensor<4x4x2x2xf32>
  }

  func.func @conv_1d_ncw_fcw_tensor(
    %input: tensor<5x3x100xf32>, 
    %filter: tensor<4x3x10xf32>, 
    %output: tensor<5x4x91xf32>
  ) -> tensor<5x4x91xf32> {
    %result = linalg.conv_1d_ncw_fcw 
              {strides = dense<1> : tensor<1xi64>, dilations = dense<1> : tensor<1xi64>}
              ins(%input, %filter : tensor<5x3x100xf32>, tensor<4x3x10xf32>)
              outs(%output : tensor<5x4x91xf32>) -> tensor<5x4x91xf32>
    return %result : tensor<5x4x91xf32>
  }

  func.func @max_tensor(
    %A: tensor<3x4xf32>, 
    %B: tensor<3x4xf32>, 
    %C_init: tensor<3x4xf32>
  ) -> tensor<3x4xf32> {
    %C = linalg.max
         ins(%A, %B : tensor<3x4xf32>, tensor<3x4xf32>)
         outs(%C_init : tensor<3x4xf32>) -> tensor<3x4xf32>
    return %C : tensor<3x4xf32>
  }

  func.func @main(
    %lhs_mmt4d: tensor<4x5x2x3xf32>, 
    %rhs_mmt4d: tensor<4x5x2x3xf32>, 
    %output_mmt4d: tensor<4x4x2x2xf32>,
    %input_conv: tensor<5x3x100xf32>, 
    %filter_conv: tensor<4x3x10xf32>, 
    %output_conv: tensor<5x4x91xf32>,
    %A_max: tensor<3x4xf32>, 
    %B_max: tensor<3x4xf32>, 
    %C_init_max: tensor<3x4xf32>,
    %I: memref<?x?xindex>, 
    %J: memref<?x?xindex>
  ) -> tensor<4x4x2x2xf32> {
    // Call mmt4d operation
    %mmt4d_result = call @mmt4d_tensor(%lhs_mmt4d, %rhs_mmt4d, %output_mmt4d) 
                    : (tensor<4x5x2x3xf32>, tensor<4x5x2x3xf32>, tensor<4x4x2x2xf32>) -> tensor<4x4x2x2xf32>
    
    // Call 1D convolution
    %conv_result = call @conv_1d_ncw_fcw_tensor(%input_conv, %filter_conv, %output_conv)
                  : (tensor<5x3x100xf32>, tensor<4x3x10xf32>, tensor<5x4x91xf32>) -> tensor<5x4x91xf32>
    
    // Call max operation
    %max_result = call @max_tensor(%A_max, %B_max, %C_init_max)
                 : (tensor<3x4xf32>, tensor<3x4xf32>, tensor<3x4xf32>) -> tensor<3x4xf32>
    
    // Generic operation
    linalg.generic {indexing_maps = [#map, #map],
                    iterator_types = ["parallel", "parallel"]}
      outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
      ^bb0(%arg0 : index, %arg1 : index):
        %i = linalg.index 0 : index
        %j = linalg.index 1 : index
        linalg.yield %i, %j : index, index
    }
    
    return %mmt4d_result : tensor<4x4x2x2xf32>
  }
}
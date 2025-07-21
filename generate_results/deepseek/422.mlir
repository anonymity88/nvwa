#map = affine_map<(i, j) -> (i, j)>

module attributes {transform.with_named_sequence} {
  func.func @quantized_matmul_main(
    %lhs: tensor<4x8xi8>, 
    %rhs: tensor<8x6xi8>, 
    %lhs_zero_point: i32, 
    %rhs_zero_point: i32, 
    %output: tensor<4x6xi32>
  ) -> tensor<4x6xi32> {
    %0 = linalg.quantized_matmul
         ins(%lhs, %rhs, %lhs_zero_point, %rhs_zero_point : tensor<4x8xi8>, tensor<8x6xi8>, i32, i32)
         outs(%output : tensor<4x6xi32>) -> tensor<4x6xi32>
    return %0 : tensor<4x6xi32>
  }

  func.func @reduce_main(
    %input: tensor<16x32x64xf32>, 
    %init: tensor<16x64xf32>
  ) -> tensor<16x64xf32> {
    %reduce = linalg.reduce
        ins(%input : tensor<16x32x64xf32>)
        outs(%init : tensor<16x64xf32>)
        dimensions = [1]
        (%in: f32, %out: f32) {
          %0 = arith.addf %out, %in : f32
          linalg.yield %0 : f32
        }
    return %reduce : tensor<16x64xf32>
  }

  func.func @conv_2d_ngchw_fgchw_main(
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

  func.func @main(
    %lhs_matmul: tensor<4x8xi8>,
    %rhs_matmul: tensor<8x6xi8>,
    %lhs_zero_point: i32,
    %rhs_zero_point: i32,
    %output_matmul: tensor<4x6xi32>,
    %input_reduce: tensor<16x32x64xf32>,
    %init_reduce: tensor<16x64xf32>,
    %input_conv: tensor<1x2x3x8x8xf32>,
    %filter_conv: tensor<2x2x3x3x3xf32>,
    %output_conv: tensor<1x2x2x6x6xf32>,
    %I: memref<?x?xindex>,
    %J: memref<?x?xindex>
  ) -> (tensor<4x6xi32>, tensor<16x64xf32>, tensor<1x2x2x6x6xf32>) {
    %matmul_result = call @quantized_matmul_main(
      %lhs_matmul, %rhs_matmul, %lhs_zero_point, %rhs_zero_point, %output_matmul
    ) : (tensor<4x8xi8>, tensor<8x6xi8>, i32, i32, tensor<4x6xi32>) -> tensor<4x6xi32>

    %reduce_result = call @reduce_main(
      %input_reduce, %init_reduce
    ) : (tensor<16x32x64xf32>, tensor<16x64xf32>) -> tensor<16x64xf32>

    %conv_result = call @conv_2d_ngchw_fgchw_main(
      %input_conv, %filter_conv, %output_conv
    ) : (tensor<1x2x3x8x8xf32>, tensor<2x2x3x3x3xf32>, tensor<1x2x2x6x6xf32>) -> tensor<1x2x2x6x6xf32>

    linalg.generic {
      indexing_maps = [#map, #map],
      iterator_types = ["parallel", "parallel"]
    } outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
    ^bb0(%arg0: index, %arg1: index):
      %i = linalg.index 0 : index
      %j = linalg.index 1 : index
      linalg.yield %i, %j : index, index
    }

    return %matmul_result, %reduce_result, %conv_result : tensor<4x6xi32>, tensor<16x64xf32>, tensor<1x2x2x6x6xf32>
  }

  transform.named_sequence @__transform_main(%arg1: !transform.any_op {transform.readonly}) {
    %0 = transform.structured.match ops{["linalg.matmul"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    transform.structured.multitile_sizes %0 { target_size = 3, dimension = 0 } : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}
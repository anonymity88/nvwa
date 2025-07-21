module {
  func.func @combined_main(
      %input_transpose: tensor<1x32x32x8xf32>,
      %filter: tensor<16x8x3x3xf32>,
      %bias: tensor<16xf32>,
      %input_erf: tensor<4xf32>,
      %input_clz: tensor<4xi32>,
      %input_reduce: tensor<4x3xi32>,
      %input_sin: tensor<?x?xf32>
  ) -> (tensor<1x34x34x16xf32>, tensor<4xf32>, tensor<4xi32>, tensor<4x1xi32>, tensor<?x?xf32>) {
    // Transpose convolution operation
    %transpose_result = "tosa.transpose_conv2d"(%input_transpose, %filter, %bias) {
      out_pad = array<i64: 1, 1, 1, 1>,
      stride = array<i64: 1, 1>,
      out_shape = array<i64: 1, 34, 34, 16>
    } : (tensor<1x32x32x8xf32>, tensor<16x8x3x3xf32>, tensor<16xf32>) -> tensor<1x34x34x16xf32>

    // Custom operation
    "tosa.custom"() {domain_name = "custom_op", operator_name = "my_custom_op", implementation_attrs = ""} : () -> ()

    // Error function operation
    %erf_result = "tosa.erf"(%input_erf) : (tensor<4xf32>) -> tensor<4xf32>

    // Count leading zeros operation
    %clz_result = "tosa.clz"(%input_clz) : (tensor<4xi32>) -> tensor<4xi32>

    // Reduce min operation
    %reduce_result = "tosa.reduce_min"(%input_reduce) {axis = 1 : i32} : (tensor<4x3xi32>) -> tensor<4x1xi32>

    // Sine operation
    %sin_result = "tosa.sin"(%input_sin) : (tensor<?x?xf32>) -> tensor<?x?xf32>

    return %transpose_result, %erf_result, %clz_result, %reduce_result, %sin_result : 
           tensor<1x34x34x16xf32>, tensor<4xf32>, tensor<4xi32>, tensor<4x1xi32>, tensor<?x?xf32>
  }
}
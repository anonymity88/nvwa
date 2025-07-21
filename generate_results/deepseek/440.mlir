module {
  func.func @main(
      %input_transpose: tensor<1x32x32x8xf32>,
      %filter: tensor<16x8x3x3xf32>,
      %bias: tensor<16xf32>,
      %input_erf: tensor<4xf32>,
      %input_clz: tensor<4xi32>,
      %input_reduce: tensor<4x3xi32>,
      %input_sin: tensor<?x?xf32>,
      %arg0_conv3d: tensor<1x1x32x32x8xf32>,
      %arg1_conv3d: tensor<16x2x2x2x8xf32>,
      %arg2_conv3d: tensor<16xf32>
  ) -> (tensor<1x34x34x16xf32>, tensor<4xf32>, tensor<4xi32>, tensor<4x1xi32>, tensor<?x?xf32>, tensor<1x1x32x32x16xf32>) {
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

    // Call 3D convolution function
    %conv3d_result = call @test_conv3d_pad_right(%arg0_conv3d, %arg1_conv3d, %arg2_conv3d) : 
        (tensor<1x1x32x32x8xf32>, tensor<16x2x2x2x8xf32>, tensor<16xf32>) -> tensor<1x1x32x32x16xf32>

    return %transpose_result, %erf_result, %clz_result, %reduce_result, %sin_result, %conv3d_result : 
           tensor<1x34x34x16xf32>, tensor<4xf32>, tensor<4xi32>, tensor<4x1xi32>, tensor<?x?xf32>, tensor<1x1x32x32x16xf32>
  }

  func.func @test_conv3d_pad_right(%arg0: tensor<1x1x32x32x8xf32>, %arg1: tensor<16x2x2x2x8xf32>, %arg2: tensor<16xf32>) -> tensor<1x1x32x32x16xf32> {
    %0 = "tosa.conv3d"(%arg0, %arg1, %arg2) {dilation = array<i64: 1, 1, 1>, pad = array<i64: 0, 1, 0, 1, 0, 8193>, stride = array<i64: 1, 1, 1>} :
              (tensor<1x1x32x32x8xf32>, tensor<16x2x2x2x8xf32>, tensor<16xf32>) -> tensor<1x1x32x32x16xf32>
    return %0 : tensor<1x1x32x32x16xf32>
  }
}
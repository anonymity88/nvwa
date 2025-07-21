module {
  func.func @combined_main(
      %input_transpose: tensor<1x32x32x8xf32>,
      %filter: tensor<16x8x3x3xf32>,
      %bias: tensor<16xf32>,
      %input_pad: tensor<2x3xf32>,
      %padding: tensor<2x2xi32>,
      %pad_const: tensor<f32>,
      %input_abs: tensor<?x?xf32>,
      %arg0_mul: tensor<4xi16>,
      %arg1_mul: tensor<4xi16>,
      %input1_greater: tensor<4xi32>,
      %input2_greater: tensor<4xi32>,
      %input1_sub: tensor<?x?xf32>,
      %input2_sub: tensor<?x?xf32>
  ) -> (tensor<1x34x34x16xf32>, tensor<6x7xf32>, tensor<?x?xf32>, tensor<4xi32>, tensor<4xi1>, tensor<?x?xf32>) {
    // Transpose convolution operation
    %transpose_result = "tosa.transpose_conv2d"(%input_transpose, %filter, %bias) {
      out_pad = array<i64: 1, 1, 1, 1>,
      stride = array<i64: 1, 1>,
      out_shape = array<i64: 1, 34, 34, 16>
    } : (tensor<1x32x32x8xf32>, tensor<16x8x3x3xf32>, tensor<16xf32>) -> tensor<1x34x34x16xf32>

    // Pad operation
    %pad_result = "tosa.pad"(%input_pad, %padding, %pad_const) : (tensor<2x3xf32>, tensor<2x2xi32>, tensor<f32>) -> tensor<6x7xf32>

    // Absolute value operation
    %abs_result = "tosa.abs"(%input_abs) : (tensor<?x?xf32>) -> tensor<?x?xf32>

    // Multiplication operation
    %mul_result = "tosa.mul"(%arg0_mul, %arg1_mul) {shift = 0 : i8} : (tensor<4xi16>, tensor<4xi16>) -> tensor<4xi32>

    // Greater than comparison
    %greater_result = "tosa.greater"(%input1_greater, %input2_greater) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>

    // Subtraction operation
    %sub_result = "tosa.sub"(%input1_sub, %input2_sub) : (tensor<?x?xf32>, tensor<?x?xf32>) -> tensor<?x?xf32>

    return %transpose_result, %pad_result, %abs_result, %mul_result, %greater_result, %sub_result : 
           tensor<1x34x34x16xf32>, tensor<6x7xf32>, tensor<?x?xf32>, tensor<4xi32>, tensor<4xi1>, tensor<?x?xf32>
  }
}
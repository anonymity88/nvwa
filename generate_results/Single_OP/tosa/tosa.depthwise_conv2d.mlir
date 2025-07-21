module {
  func.func @depthwise_conv_example(%input : tensor<1x12x12x4xi8>, 
                                     %weight : tensor<3x3x4x128xi8>, 
                                     %bias : tensor<512xi32>) -> (tensor<1x12x12x512xi32>) {
    %0 = tosa.depthwise_conv2d %input, %weight, %bias {pad = array<i64: 1, 1, 1, 1>, 
                                                        stride = array<i64: 1, 1>, 
                                                        dilation = array<i64: 1, 1>, 
                                                        quantization_info = #tosa.conv_quant<input_zp = -128, weight_zp = 42>, 
                                                        local_bound = false} : 
                                                        (tensor<1x12x12x4xi8>, 
                                                         tensor<3x3x4x128xi8>, 
                                                         tensor<512xi32>) -> 
                                                         tensor<1x12x12x512xi32>
    return %0 : tensor<1x12x12x512xi32>
  }
}
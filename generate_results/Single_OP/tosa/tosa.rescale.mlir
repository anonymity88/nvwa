module {
  func.func @rescale_example(%input: tensor<2xi8>) -> tensor<2xi16> {
    %0 = tosa.rescale %input {input_zp = 17 : i32, output_zp = 22 : i32, multiplier = array<i32: 19689>, shift = array<i8: 15>, scale32 = false, double_round = false, per_channel = false} : (tensor<2xi8>) -> tensor<2xi16>
    return %0 : tensor<2xi16>
  }
}
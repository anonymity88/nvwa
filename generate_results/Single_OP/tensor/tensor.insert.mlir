module {
  func.func @main(%dest: tensor<4x4xi32>, %scalar: i32, %i: index, %j: index) -> tensor<4x4xi32> {
    %result = tensor.insert %scalar into %dest[%i, %j] : tensor<4x4xi32>
    return %result : tensor<4x4xi32>
  }
}
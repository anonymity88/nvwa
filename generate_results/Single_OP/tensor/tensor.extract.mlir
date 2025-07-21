module {
  func.func @main(%t: tensor<4x4xi32>, %i: index, %j: index) -> i32 {
    %element = tensor.extract %t[%i, %j] : tensor<4x4xi32>
    return %element : i32
  }
}
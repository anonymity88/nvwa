module {
  func.func @main() -> tensor<8x16xf32> {
    %s = arith.constant 1.0 : f32
    %t = tensor.splat %s : tensor<8x16xf32>
    return %t : tensor<8x16xf32>
  }
}

module {
  func.func @main_dynamic(%m: index, %n: index) -> tensor<?x20x?xf32> {
    %s = arith.constant 1.0 : f32
    %t = tensor.splat %s[%m, %n] : tensor<?x20x?xf32>
    return %t : tensor<?x20x?xf32>
  }
}
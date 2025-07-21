module {
  // Affine map can be included as needed; here it is a placeholder
  // #map = affine_map<(d0) -> (d0)>

  func.func @fptosi_example(%arg0: tensor<4xf32>) -> tensor<4xi32> {
    %0 = arith.fptosi %arg0 : tensor<4xf32> to tensor<4xi32>
    return %0 : tensor<4xi32>
  }
}
#trait_attribute = {
  doc = "Example of a linalg.generic operation",
  indexing_maps = [
    affine_map<(m, k, n) -> (m, k)>,
    affine_map<(m, k, n) -> (k, n)>,
    affine_map<(m, k, n) -> (m, n)>
  ],
  iterator_types = ["parallel", "reduction", "parallel"]
}

module {
  func.func @main(%A: tensor<128x256xf32>, %B: tensor<256x128xf32>, %C_init: tensor<128x128xf32>) -> tensor<128x128xf32> {
    %result = linalg.generic #trait_attribute
        ins(%A, %B : tensor<128x256xf32>, tensor<256x128xf32>)
        outs(%C_init : tensor<128x128xf32>) {
      ^bb0(%a: f32, %b: f32, %c: f32):
        %mul = arith.mulf %a, %b : f32
        %add = arith.addf %c, %mul : f32
        linalg.yield %add : f32
    } -> tensor<128x128xf32>

    return %result : tensor<128x128xf32>
  }
}
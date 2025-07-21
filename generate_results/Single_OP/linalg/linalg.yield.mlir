#map1 = affine_map<(d0, d1) -> (d0, d1)>
#map2 = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main(%input: tensor<2x3xf32>, %output: tensor<2x3xf32>) -> tensor<2x3xf32> {
    %0 = linalg.generic {
           indexing_maps = [#map1, #map2],
           iterator_types = ["parallel", "parallel"]
         }
         ins(%input : tensor<2x3xf32>)
         outs(%output : tensor<2x3xf32>) {
           ^bb0(%in: f32, %out: f32):  // Block with input types and output type
             %1 = arith.addf %in, %out : f32
             linalg.yield %1 : f32    // Yield operation returning the result
         } -> tensor<2x3xf32>

    return %0 : tensor<2x3xf32>
  }
}
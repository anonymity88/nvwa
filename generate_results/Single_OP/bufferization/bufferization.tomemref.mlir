#layout = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main(%arg: tensor<4x?xf32>) -> memref<4x?xf32, #layout, 0> {
    // Cast the input tensor to a memref using bufferization.tomemref
    %m = bufferization.to_memref %arg : memref<4x?xf32, #layout, 0>

    return %m : memref<4x?xf32, #layout, 0>
  }
}
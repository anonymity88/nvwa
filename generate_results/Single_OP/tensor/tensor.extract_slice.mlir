module {
  func.func @main(%arg: tensor<8x16x4xf32>, %offset0: index, %offset2: index, %size1: index, %stride1: index) -> (tensor<16x4xf32>, tensor<1x?xf32>) {
    %slice1 = tensor.extract_slice %arg[0, 0, 0][1, 16, 4][1, 1, 1] : tensor<8x16x4xf32> to tensor<16x4xf32>
  
    %slice2 = tensor.extract_slice %arg[%offset0, 4, %offset2][1, %size1, 1][1, %stride1, 1] : tensor<8x16x4xf32> to tensor<1x?xf32>

    return %slice1, %slice2 : tensor<16x4xf32>, tensor<1x?xf32>
  }
}
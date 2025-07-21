module {
  func.func @main(%input: tensor<16x64xf32>, %init: tensor<64x16xf32>) -> tensor<64x16xf32> {
    %transpose = linalg.transpose
                  ins(%input : tensor<16x64xf32>)
                  outs(%init : tensor<64x16xf32>)
                  permutation = [1, 0]
    
    return %transpose : tensor<64x16xf32>
  }
}
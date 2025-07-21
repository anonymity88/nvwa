module {
  func.func @main(%input: tensor<16xf32>, %init: tensor<16x64xf32>) -> tensor<16x64xf32> {
    %0 = linalg.broadcast 
         ins(%input : tensor<16xf32>) 
         outs(%init : tensor<16x64xf32>) 
         dimensions = [1]

    return %0 : tensor<16x64xf32>
  }
}
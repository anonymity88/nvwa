module {
  func.func @main(%input: tensor<16x32x64xf32>, %init: tensor<16x64xf32>) -> tensor<16x64xf32> {
    %reduce = linalg.reduce
        ins(%input : tensor<16x32x64xf32>)
        outs(%init : tensor<16x64xf32>)
        dimensions = [1]
        (%in: f32, %out: f32) {
          %0 = arith.addf %out, %in : f32
          linalg.yield %0 : f32
        }

    return %reduce : tensor<16x64xf32>
  }
}
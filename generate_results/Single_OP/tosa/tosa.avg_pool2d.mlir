module {
  func.func @avg_pool_example(%arg0: tensor<1x3x32x32xf32>) -> tensor<1x3x30x30xf32> {
    %0 = tosa.avg_pool2d %arg0 {pad = array<i64: 1, 1, 1, 1>, kernel = array<i64: 3, 3>, stride = array<i64: 1, 1>, acc_type = f32} : (tensor<1x3x32x32xf32>) -> tensor<1x3x30x30xf32>
    
    // Using a dummy constant tensor to illustrate dependencies
    %const = "tosa.const"() <{value = dense<[[1.0]]> : tensor<1x1xf32>}> : () -> tensor<1x1xf32>
    
    // Example of using another operation
    %1 = tosa.add %0, %const : (tensor<1x3x30x30xf32>, tensor<1x1xf32>) -> tensor<1x3x30x30xf32>

    return %1 : tensor<1x3x30x30xf32>
  }
}
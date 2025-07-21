module {
  func.func @main(%arg0: tensor<4xf32>, %arg1: tensor<4xf32>, %cond: i1) -> tensor<4xf32> {
    // Using tosa.maximum operator
    %0 = "tosa.maximum"(%arg0, %arg1) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>

    // A constant tensor for use in tosa.select
    %c0 = arith.constant dense<0> : tensor<4xi1>
    %1 = "tosa.select"(%c0, %arg0, %0) : (tensor<4xi1>, tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>

    // A simple if-else with tosa.yield
    %true_branch = scf.if %cond -> tensor<4xf32> {
      %2 = arith.constant dense<[1.0, 2.0, 3.0, 4.0]> : tensor<4xf32>
      scf.yield %2 : tensor<4xf32>
    } else {
      %3 = arith.constant dense<[5.0, 6.0, 7.0, 8.0]> : tensor<4xf32>
      scf.yield %3 : tensor<4xf32>
    }

    return %true_branch : tensor<4xf32>
  }
}
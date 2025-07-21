module {
  func.func @main(%arg0: tensor<4x3xi1>, %arg1: tensor<4x3xi32>) -> (tensor<4x1xi1>, tensor<4x1xi1>) {
    // The first use of tosa.reduce_any
    %0 = "tosa.reduce_any"(%arg0) {axis = 1 : i32} : (tensor<4x3xi1>) -> tensor<4x1xi1>

    // Converting the second input tensor to boolean type tensor
    %1 = "tosa.cast"(%arg1) : (tensor<4x3xi32>) -> tensor<4x3xi1>

    // The second use of tosa.reduce_any applied to the cast result
    %2 = "tosa.reduce_any"(%1) {axis = 1 : i32} : (tensor<4x3xi1>) -> tensor<4x1xi1>

    // Return the results of the reduce_any operations
    return %0, %2 : tensor<4x1xi1>, tensor<4x1xi1>
  }
}
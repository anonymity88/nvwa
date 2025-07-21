module {
  // A function with two arguments and a single result
  func.func @add_tensors(%arg0: tensor<16xf32>, %arg1: tensor<16xf32>) -> tensor<16xf32> {
    %result = arith.addf %arg0, %arg1 : tensor<16xf32>
    return %result : tensor<16xf32>
  }

  // Main function
  func.func @main() {
    // Define a function constant for indirect calls inside the same region
    %func = func.constant @add_tensors : (tensor<16xf32>, tensor<16xf32>) -> tensor<16xf32>

    %tensor_a = arith.constant dense<1.0> : tensor<16xf32>
    %tensor_b = arith.constant dense<2.0> : tensor<16xf32>
    
    // Indirect call to a function using the function constant
    %result = func.call_indirect %func(%tensor_a, %tensor_b) : (tensor<16xf32>, tensor<16xf32>) -> tensor<16xf32>
    
    // Return from main
    func.return
  }
}
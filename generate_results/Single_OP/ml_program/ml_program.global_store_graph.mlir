module {
  // Define a mutable global variable that we will store into.
  ml_program.global public mutable @foobar : tensor<4xi32>

  func.func @main() -> !ml_program.token {
    // Define some initial constant value with a static shape that we want to store into the global
    %0 = arith.constant dense<[1, 2, 3, 4]> : tensor<4xi32>

    // Assume we have an initial token to manage execution order
    %in_token = "ml_program.token"() : () -> !ml_program.token

    // Store the value into the global variable @foobar
    %token = ml_program.global_store_graph @foobar = %0 
      ordering (%in_token -> !ml_program.token) : tensor<4xi32>

    return %token : !ml_program.token
  }
}
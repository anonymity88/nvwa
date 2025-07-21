module {
  // Global mutable tensor definition
  ml_program.global public mutable @foobar : tensor<4xi32>

  // Private subgraph with simple pass-through
  ml_program.subgraph private @simple_subgraph(%arg0: i32) -> i32 {
    ml_program.output %arg0 : i32
  }

  // Public subgraph that performs addition
  ml_program.subgraph @add_subgraph(%a: i32, %b: i32) -> i32 {
    %sum = arith.addi %a, %b : i32
    ml_program.output %sum : i32
  }

  // Main function with token operations and global storage
  func.func @main() -> !ml_program.token {
    // Initialize constant tensor
    %0 = arith.constant dense<[1, 2, 3, 4]> : tensor<4xi32>
    
    // Create initial token
    %in_token = "ml_program.token"() : () -> !ml_program.token
    
    // Store to global variable
    %token = ml_program.global_store_graph @foobar = %0 
      ordering (%in_token -> !ml_program.token) : tensor<4xi32>
    
    // Example usage of subgraphs (would need proper calling mechanism)
    // %val1 = arith.constant 42 : i32
    // %val2 = arith.constant 10 : i32
    // %simple_result = call @simple_subgraph(%val1) : (i32) -> i32
    // %sum_result = call @add_subgraph(%val1, %val2) : (i32, i32) -> i32
    
    return %token : !ml_program.token
  }
}
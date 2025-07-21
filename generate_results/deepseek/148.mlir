module {
  // Global mutable tensor definition
  ml_program.global public mutable @foobar : tensor<4xi32>

  // Simple pass-through subgraph
  ml_program.subgraph private @simple_subgraph(%arg0: i32) -> i32 {
    ml_program.output %arg0 : i32
  }

  // Subgraph that adds two integers
  ml_program.subgraph @add_subgraph(%a: i32, %b: i32) -> i32 {
    %sum = arith.addi %a, %b : i32
    ml_program.output %sum : i32
  }

  // Subgraph with mixed input types
  ml_program.subgraph @subgraph_function(%arg0: i32, %arg1: f32) -> (i32, f32) {
    ml_program.output %arg0, %arg1 : i32, f32
  }

  // Main function demonstrating usage of globals and subgraphs
  func.func @main() -> !ml_program.token {
    // Initialize and store to global tensor
    %0 = arith.constant dense<[1, 2, 3, 4]> : tensor<4xi32>
    %in_token = "ml_program.token"() : () -> !ml_program.token
    %token = ml_program.global_store_graph @foobar = %0 
      ordering (%in_token -> !ml_program.token) : tensor<4xi32>

    // Example usage of subgraphs (commented out as they don't return tokens)
    // %val1 = arith.constant 5 : i32
    // %val2 = arith.constant 3.14 : f32
    // %simple_result = call @simple_subgraph(%val1) : (i32) -> i32
    // %add_result = call @add_subgraph(%val1, %simple_result) : (i32, i32) -> i32
    // %mixed_result = call @subgraph_function(%add_result, %val2) : (i32, f32) -> (i32, f32)

    return %token : !ml_program.token
  }
}
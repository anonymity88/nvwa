module {
  // Define a subgraph with a private visibility and a simple input-output signature
  ml_program.subgraph private @simple_subgraph(%arg0: i32) -> i32 {
    // Simply return the incoming argument as the output
    ml_program.output %arg0 : i32
  }

  // Define a public subgraph with a function signature taking and returning two 32-bit integers
  ml_program.subgraph @add_subgraph(%a: i32, %b: i32) -> i32 {
    // Add the two arguments and return the result
    %sum = arith.addi %a, %b : i32
    ml_program.output %sum : i32
  }

  func.func @main() {
    // Invoke the declared subgraphs from the main function
    // Typically one would call these subgraphs here (actual calls are not shown as they depend on the wider use in the complete program)
    return
  }
}
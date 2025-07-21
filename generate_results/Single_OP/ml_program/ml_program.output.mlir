module {
  // Define a subgraph function via ml_program.subgraph
  ml_program.subgraph @subgraph_function(%arg0: i32, %arg1: f32) -> (i32, f32) {
    // Some operations on %arg0 and %arg1 can be done here

    // The ml_program.output operation correctly terminates the subgraph
    ml_program.output %arg0, %arg1 : i32, f32
    // The ml_program.output operation takes operands and yields them to the caller.
  }
}
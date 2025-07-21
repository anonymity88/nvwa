module {
  // Define a PDL Interpreter function named 'erase_example' that takes a single
  // argument of type '!pdl.operation'.
  pdl_interp.func @erase_example(%targetOp: !pdl.operation) {
    // Erase the operation provided as argument '%targetOp'
    pdl_interp.erase %targetOp
    // Finalize the interpreter function execution
    pdl_interp.finalize
  }
}
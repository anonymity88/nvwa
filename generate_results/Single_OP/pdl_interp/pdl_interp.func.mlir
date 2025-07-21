module {
  // Define a PDL Interpreter function named 'rewriter_example' with one argument of type !pdl.operation.
  pdl_interp.func @rewriter_example(%root: !pdl.operation) {
    // Create a new operation named "foo.new_operation".
    %op = pdl_interp.create_operation "foo.new_operation"
    // Erase the root operation provided as an argument.
    pdl_interp.erase %root
    // Finalize the interpreter function execution.
    pdl_interp.finalize
  }
}
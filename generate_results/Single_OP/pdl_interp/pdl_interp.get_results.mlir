module {
  // Define a PDL Interpreter function named 'get_results_example' with one input operand of type !pdl.operation.
  pdl_interp.func @get_results_example(%op: !pdl.operation) {
    // Get the first group of results from the operation, expecting a single element.
    %result = pdl_interp.get_results 0 of %op : !pdl.value

    // Get the first group of results from the operation as a range.
    %results = pdl_interp.get_results 0 of %op : !pdl.range<value>

    // Get all of the results from the operation as a range.
    %all_results = pdl_interp.get_results of %op : !pdl.range<value>

    // Finalize the interpreter function execution
    pdl_interp.finalize
  }
}
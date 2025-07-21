module {
  // Define a PDL Interpreter function named 'check_result_count_example'
  // that takes a single argument of type '!pdl.operation'.
  pdl_interp.func @check_result_count_example(%op: !pdl.operation) {
    // Check if the number of results of '%op' is exactly 2.
    pdl_interp.check_result_count of %op is 2 -> ^matchDest, ^failureDest

  // Define the match destination block.
  ^matchDest:
    // Handle the case where the condition is met.
    pdl_interp.finalize
    
  // Define the failure destination block.
  ^failureDest:
    // Handle the case where the condition is not met.
    pdl_interp.finalize
  }
}
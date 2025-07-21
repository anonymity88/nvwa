module {
  // Define a PDL Interpreter function named 'check_operand_count_example' that takes a single argument of type '!pdl.operation'.
  pdl_interp.func @check_operand_count_example(%op: !pdl.operation) {
    // Check if the number of operands of the operation %op is exactly 2.
    pdl_interp.check_operand_count of %op is 2 -> ^matchDest, ^failureDest

  ^matchDest:
    // Handle the case where the operand count matches the expectation.
    // Finalize the interpreter function execution at this block.
    pdl_interp.finalize

  ^failureDest:
    // Handle the case where the operand count does not match the expectation.
    // Finalize the interpreter function execution at this block.
    pdl_interp.finalize
  }
}
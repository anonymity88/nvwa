module {
  // Define a PDL Interpreter function named 'record_match_example' that takes 
  // two arguments of type '!pdl.operation'.
  pdl_interp.func @record_match_example(%root: !pdl.operation, %op1: !pdl.operation) {
    // Record a successful pattern match using the specified rewriter, benefit, 
    // location, and root kind attributes.
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^nextDest

    // Define the destination block.
  ^nextDest:
    // Finalize the interpreter function execution at this block.
    pdl_interp.finalize
  }
}
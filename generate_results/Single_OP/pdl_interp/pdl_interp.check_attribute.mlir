module {
  // Define a PDL Interpreter function named 'check_attribute_example' with no arguments.
  pdl_interp.func @check_attribute_example() {
    // Create a constant attribute with value 10 of integer type i64.
    %attr = pdl_interp.create_attribute 10 : i64
    // Check if the attribute %attr is equal to the constant value 10
    pdl_interp.check_attribute %attr is 10 -> ^matchDest, ^failureDest
    
    // Define the success destination block
    ^matchDest:
      // (Actions to take on success)
      pdl_interp.finalize

    // Define the failure destination block
    ^failureDest:
      // (Actions to take on failure)
      pdl_interp.finalize
  }
}
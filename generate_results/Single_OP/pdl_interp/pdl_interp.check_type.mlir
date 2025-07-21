module {
  // Define a PDL Interpreter function named 'check_type_example' that takes
  // a single argument of type '!pdl.type', which will represent the value.
  pdl_interp.func @check_type_example(%value: !pdl.type) {
    // Check if the type of the operation is i32
    pdl_interp.check_type %value is i32 -> ^matchDest, ^failureDest
    
    // Block that is executed if the type matches
  ^matchDest:
    // Here you can insert operations that should happen upon a successful type check.
    pdl_interp.finalize

    // Block that is executed if the type does not match
  ^failureDest:
    // Here you can insert operations that should happen upon a failed type check.
    pdl_interp.finalize
  }
}
module {
  // Define a PDL Interpreter function named 'get_attribute_example' that takes a single
  // argument of type '!pdl.operation'.
  pdl_interp.func @get_attribute_example(%op: !pdl.operation) {
    // Get the attribute named "attr" from the provided operation '%op'
    %attr = pdl_interp.get_attribute "attr" of %op
    // Finalize the interpreter function execution
    pdl_interp.finalize
  }
}
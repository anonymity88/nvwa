module {
  // Define a PDL Interpreter function named 'get_attribute_type_example' with no arguments.
  pdl_interp.func @get_attribute_type_example() {
    // Assume we first create an attribute to get its type
    %attr = pdl_interp.create_attribute 10 : i64
    // Get the result type of the specified attribute
    %type = pdl_interp.get_attribute_type of %attr 
    // Finalize the interpreter function execution
    pdl_interp.finalize
  }
}
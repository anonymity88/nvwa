module {
  // Define a PDL Interpreter function named 'create_op_example' that creates a new
  // operation with specific operands, attributes, and result types.
  pdl_interp.func @create_op_example(%value: !pdl.value, %attr: !pdl.attribute, %type: !pdl.type) {
    // Create an instance of a `foo.op` operation with an operand, attribute, and result type.
    %op = pdl_interp.create_operation "foo.op"(%value : !pdl.value) {"attrA" = %attr} -> (%type : !pdl.type)
    
    // Finalize the interpreter function execution
    pdl_interp.finalize
  }
}
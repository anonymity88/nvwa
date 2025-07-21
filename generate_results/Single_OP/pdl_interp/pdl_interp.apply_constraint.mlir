module {
  // Define a PDL Interpreter function named 'apply_constraint_example' that 
  // takes three arguments of types !pdl.value, !pdl.attribute, and !pdl.operation.
  pdl_interp.func @apply_constraint_example(%input: !pdl.value, %attr: !pdl.attribute, %op: !pdl.operation) {
    // Apply the constraint 'myConstraint' to the provided inputs
    // and specify the types of the arguments. No result is defined here.
    pdl_interp.apply_constraint "myConstraint"(%input, %attr, %op : !pdl.value, !pdl.attribute, !pdl.operation) -> ^matchDest, ^failureDest

    // Define the true destination block where the constraint is satisfied.
  ^matchDest:
    // Finalize the interpreter function execution at this block.
    pdl_interp.finalize

    // Define the false destination block where the constraint fails.
  ^failureDest:
    // Finalize the interpreter function execution at this block.
    pdl_interp.finalize
  }
}
module {
  pdl_interp.func @main(%input: !pdl.value, %attr_param: !pdl.attribute, %op_param: !pdl.operation, %ops: !pdl.range<operation>) {
    // Check attribute example
    %attr = pdl_interp.create_attribute 10 : i64
    pdl_interp.check_attribute %attr is 10 -> ^attr_match, ^attr_fail

  ^attr_match:
    // Apply constraint example
    pdl_interp.apply_constraint "myConstraint"(%input, %attr_param, %op_param : !pdl.value, !pdl.attribute, !pdl.operation) -> ^constraint_match, ^constraint_fail

  ^constraint_match:
    // Foreach example iterating over operations
    pdl_interp.foreach %op : !pdl.operation in %ops {
      pdl_interp.continue
    } -> ^next

  ^next:
    // Finalize upon successful path
    pdl_interp.finalize

  ^attr_fail:
    // Finalize upon attribute check failure
    pdl_interp.finalize

  ^constraint_fail:
    // Finalize upon constraint failure
    pdl_interp.finalize
  }
}
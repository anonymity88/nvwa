module {
  pdl_interp.func @main(%input: !pdl.value, %attr_param: !pdl.attribute, %op_param: !pdl.operation, %ops: !pdl.range<operation>, %op: !pdl.operation, %root: !pdl.operation, %typeRange: !pdl.range<type>) {
    // First IR operations
    %attr = pdl_interp.create_attribute 10 : i64
    pdl_interp.check_attribute %attr is 10 -> ^attr_match, ^attr_fail

  ^attr_match:
    pdl_interp.apply_constraint "myConstraint"(%input, %attr_param, %op_param : !pdl.value, !pdl.attribute, !pdl.operation) -> ^constraint_match, ^constraint_fail

  ^constraint_match:
    // Second IR operations
    pdl_interp.check_operand_count of %op is 2 -> ^operandCountMatch, ^operandCountFailure

  ^operandCountMatch:
    %newOp = pdl_interp.create_operation "foo.new_operation"
    pdl_interp.erase %root
    pdl_interp.switch_types %typeRange to [[i32], [i64, i64]](^i32Dest, ^i64Dest) -> ^defaultDest

  ^i32Dest:
    pdl_interp.finalize

  ^i64Dest:
    pdl_interp.finalize

  ^defaultDest:
    // First IR foreach loop
    pdl_interp.foreach %current_op : !pdl.operation in %ops {
      pdl_interp.continue
    } -> ^next

  ^next:
    pdl_interp.finalize

  ^attr_fail:
    pdl_interp.finalize

  ^constraint_fail:
    pdl_interp.finalize

  ^operandCountFailure:
    pdl_interp.finalize
  }
}
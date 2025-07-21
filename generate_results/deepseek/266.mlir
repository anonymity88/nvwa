module {
  pdl_interp.func @main(%root: !pdl.operation, %op1: !pdl.operation, %type_range: !pdl.range<type>, %op: !pdl.operation) {
    // Common operations from both IRs
    %attr = pdl_interp.create_attribute 10 : i64
    %attr_type = pdl_interp.get_attribute_type of %attr
    
    // Check operand count from second IR
    pdl_interp.check_operand_count of %op is 2 -> ^operandCountMatch, ^operandCountFailure

  ^operandCountMatch:
    // Create new operation from second IR
    %newOp = pdl_interp.create_operation "foo.new_operation"
    
    // Switch types from both IRs (merged)
    pdl_interp.switch_types %type_range to [[i32], [i64, i64]](^i32Dest, ^i64Dest) -> ^defaultDest

  ^i32Dest:
    // Record match from first IR
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^nextDest

  ^i64Dest:
    // Record match from first IR
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^nextDest

  ^operandCountFailure:
    pdl_interp.finalize

  ^defaultDest:
    pdl_interp.finalize

  ^nextDest:
    // Erase operation from second IR
    pdl_interp.erase %root
    pdl_interp.finalize
  }
}
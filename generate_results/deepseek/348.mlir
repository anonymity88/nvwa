module {
  pdl_interp.func @main(%type: !pdl.range<type>, %targetOp: !pdl.operation, %root: !pdl.operation, %op1: !pdl.operation, %op: !pdl.operation) {
    // Check operand count from second IR
    pdl_interp.check_operand_count of %op is 2 -> ^operandCountMatch, ^operandCountFailure

  ^operandCountMatch:
    // Create new operation from second IR
    %newOp = pdl_interp.create_operation "foo.new_operation"
    
    // Switch types from both IRs (merged)
    pdl_interp.switch_types %type to [[i32], [i64, i64]](^i32Dest, ^i64Dest) -> ^defaultDest

  ^i32Dest:
    // Record match from first IR
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^eraseDest

  ^i64Dest:
    // Record match from first IR
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^eraseDest

  ^defaultDest:
    // Record match from first IR
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^eraseDest

  ^eraseDest:
    // Erase operations from both IRs
    pdl_interp.erase %targetOp
    pdl_interp.erase %root
    pdl_interp.finalize

  ^operandCountFailure:
    pdl_interp.finalize
  }
}
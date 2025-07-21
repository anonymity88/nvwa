module {
  pdl_interp.func @main(%type: !pdl.range<type>, %targetOp: !pdl.operation, %root: !pdl.operation, %op1: !pdl.operation) {
    // Switch types example
    pdl_interp.switch_types %type to [[i32], [i64, i64]](^i32Dest, ^i64Dest) -> ^defaultDest

  ^i32Dest:
    // Record match example for i32 case
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^eraseDest

  ^i64Dest:
    // Record match example for i64 case
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^eraseDest

  ^defaultDest:
    // Record match example for default case
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^eraseDest

  ^eraseDest:
    // Erase example
    pdl_interp.erase %targetOp
    pdl_interp.finalize
  }
}
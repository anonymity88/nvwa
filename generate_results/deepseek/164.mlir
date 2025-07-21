module {
  pdl_interp.func @main(%root: !pdl.operation, %op1: !pdl.operation, %type_range: !pdl.range<type>) {
    // Get attribute type example
    %attr = pdl_interp.create_attribute 10 : i64
    %attr_type = pdl_interp.get_attribute_type of %attr
    
    // Switch types example
    pdl_interp.switch_types %type_range to [[i32], [i64, i64]](^i32Dest, ^i64Dest) -> ^defaultDest

  ^i32Dest:
    // Record match example for i32 case
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^nextDest

  ^i64Dest:
    // Record match example for i64 case
    pdl_interp.record_match @rewriters.myRewriter(%root : !pdl.operation) : 
                            benefit(1), 
                            loc([%root, %op1]), 
                            root("foo.op") -> ^nextDest

  ^defaultDest:
    // Finalize for default case
    pdl_interp.finalize

  ^nextDest:
    // Finalize after successful record_match
    pdl_interp.finalize
  }
}
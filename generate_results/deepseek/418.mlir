module {
  pdl_interp.func @main(%op: !pdl.operation, %type: !pdl.range<type>, %root: !pdl.operation) {
    // Operations from first IR
    %attr = pdl_interp.create_attribute 10 : i64
    pdl_interp.check_attribute %attr is 10 -> ^attrMatch, ^attrFail
    
  ^attrMatch:
    // Check operand count from both IRs (merged)
    pdl_interp.check_operand_count of %op is 2 -> ^operandMatch, ^operandFail
    
  ^operandMatch:
    // Create operation from second IR
    %newOp = pdl_interp.create_operation "foo.new_operation"
    // Erase operation from second IR
    pdl_interp.erase %root
    // Switch types from both IRs (merged)
    pdl_interp.switch_types %type to [[i32], [i64, i64]](^i32Dest, ^i64Dest) -> ^defaultDest
    
  ^i32Dest:
    pdl_interp.finalize
    
  ^i64Dest:
    pdl_interp.finalize
    
  ^defaultDest:
    pdl_interp.finalize
    
  ^operandFail:
    pdl_interp.finalize
    
  ^attrFail:
    pdl_interp.finalize
  }
}
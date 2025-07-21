module {
  pdl_interp.func @main(%op: !pdl.operation, %targetOp: !pdl.operation) {
    // Operations from first IR
    %attr = pdl_interp.create_attribute 10 : i64
    pdl_interp.check_attribute %attr is 10 -> ^attr_match, ^attr_fail
    
  ^attr_match:
    // Get results operations from first IR
    %result = pdl_interp.get_results 0 of %op : !pdl.value
    %results = pdl_interp.get_results 0 of %op : !pdl.range<value>
    %all_results = pdl_interp.get_results of %op : !pdl.range<value>
    
    // Check operand count from second IR
    pdl_interp.check_operand_count of %op is 2 -> ^operand_match, ^operand_fail
    
  ^operand_match:
    // Erase operations from both IRs (merged)
    pdl_interp.erase %targetOp
    pdl_interp.branch ^final
    
  ^attr_fail:
    pdl_interp.finalize
    
  ^operand_fail:
    pdl_interp.finalize
    
  ^final:
    pdl_interp.finalize
  }
}
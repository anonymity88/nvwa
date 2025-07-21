module {
  pdl_interp.func @main(%value: !pdl.value, %attr: !pdl.attribute, %type: !pdl.type, %ops: !pdl.range<operation>, %targetOp: !pdl.operation, %op: !pdl.operation) {
    // Operations from first IR
    %created_attr = pdl_interp.create_attribute 10 : i64
    pdl_interp.check_attribute %created_attr is 10 -> ^attr_match, ^attr_fail
    
  ^attr_match:
    // Create operation from first IR
    %new_op = pdl_interp.create_operation "foo.op"(%value : !pdl.value) {"attrA" = %attr} -> (%type : !pdl.type)
    
    // Check operand count from second IR
    pdl_interp.check_operand_count of %op is 2 -> ^operand_match, ^operand_fail
    
  ^operand_match:
    // Erase operation from second IR
    pdl_interp.erase %targetOp
    
    // Foreach loop from first IR
    pdl_interp.foreach %foreach_op : !pdl.operation in %ops {
      pdl_interp.continue
    } -> ^next
    
  ^next:
    pdl_interp.finalize
    
  ^attr_fail:
    pdl_interp.finalize
    
  ^operand_fail:
    pdl_interp.finalize
  }
}
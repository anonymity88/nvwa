module {
  pdl_interp.func @main(%value: !pdl.value, %attr: !pdl.attribute, %type: !pdl.type, %ops: !pdl.range<operation>) {
    // Check attribute example
    %created_attr = pdl_interp.create_attribute 10 : i64
    pdl_interp.check_attribute %created_attr is 10 -> ^attr_match, ^attr_fail
    
  ^attr_match:
    // Create operation example using the input parameters
    %op = pdl_interp.create_operation "foo.op"(%value : !pdl.value) {"attrA" = %attr} -> (%type : !pdl.type)
    
    // Foreach example iterating over operations
    pdl_interp.foreach %foreach_op : !pdl.operation in %ops {
      pdl_interp.continue
    } -> ^next
    
  ^next:
    pdl_interp.finalize
    
  ^attr_fail:
    pdl_interp.finalize
  }
}
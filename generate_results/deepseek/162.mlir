module {
  pdl_interp.func @main(%ops: !pdl.range<operation>, %op: !pdl.operation) {
    // Create types example
    %types_handle = pdl_interp.create_types [i64, i64]
    
    // Foreach example iterating over operations
    pdl_interp.foreach %current_op : !pdl.operation in %ops {
      // Get results example for each operation in the loop
      %result = pdl_interp.get_results 0 of %current_op : !pdl.value
      %results = pdl_interp.get_results 0 of %current_op : !pdl.range<value>
      %all_results = pdl_interp.get_results of %current_op : !pdl.range<value>
      
      pdl_interp.continue
    } -> ^next
    
  ^next:
    // Get results example for the input operation
    %main_result = pdl_interp.get_results 0 of %op : !pdl.value
    %main_results = pdl_interp.get_results 0 of %op : !pdl.range<value>
    %main_all_results = pdl_interp.get_results of %op : !pdl.range<value>
    
    pdl_interp.finalize
  }
}
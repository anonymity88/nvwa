module {
  pdl_interp.func @main(%op: !pdl.operation, %targetOp: !pdl.operation) {
    // Check attribute example
    %attr = pdl_interp.create_attribute 10 : i64
    pdl_interp.check_attribute %attr is 10 -> ^matchDest, ^failureDest
    
  ^matchDest:
    // Get results example - single result
    %result = pdl_interp.get_results 0 of %op : !pdl.value
    
    // Get results example - range of results at index 0
    %results = pdl_interp.get_results 0 of %op : !pdl.range<value>
    
    // Get results example - all results
    %all_results = pdl_interp.get_results of %op : !pdl.range<value>
    
    // Erase example
    pdl_interp.erase %targetOp
    
    pdl_interp.finalize

  ^failureDest:
    // Finalize if attribute check fails
    pdl_interp.finalize
  }
}
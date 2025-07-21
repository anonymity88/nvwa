module {
  pdl_interp.func @main(%ops: !pdl.range<operation>, %op: !pdl.operation, %targetOp: !pdl.operation) {
    %types_handle = pdl_interp.create_types [i64, i64]
    
    pdl_interp.foreach %current_op : !pdl.operation in %ops {
      %result = pdl_interp.get_results 0 of %current_op : !pdl.value
      %results = pdl_interp.get_results 0 of %current_op : !pdl.range<value>
      %all_results = pdl_interp.get_results of %current_op : !pdl.range<value>
      
      pdl_interp.continue
    } -> ^next
    
  ^next:
    %main_result = pdl_interp.get_results 0 of %op : !pdl.value
    %main_results = pdl_interp.get_results 0 of %op : !pdl.range<value>
    %main_all_results = pdl_interp.get_results of %op : !pdl.range<value>
    
    pdl_interp.check_operand_count of %op is 2 -> ^matchDest, ^failureDest

  ^matchDest:
    pdl_interp.erase %targetOp
    pdl_interp.branch ^dest

  ^failureDest:
    pdl_interp.finalize
  ^dest:
    pdl_interp.finalize
  }
}
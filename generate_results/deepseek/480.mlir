module attributes {transform.with_named_sequence} {
  func.func @main(%arg0: index, %arg1: index) {
    // Call the get_parent_for_op_no_loop function
    call @get_parent_for_op_no_loop(%arg0, %arg1) : (index, index) -> ()
    
    // Initialize transform sequence
    %dummy_op = transform.test_produce_self_handle_or_forward_operand : () -> !transform.any_op
    transform.sequence %dummy_op : !transform.any_op failures(propagate) {
    ^bb0(%seq_arg: !transform.any_op):
      // Include the emit_warning_only sequence
      transform.include @emit_warning_only failures(propagate) (%seq_arg) : (!transform.any_op) -> ()
      transform.yield
    }
    return
  }

  func.func @get_parent_for_op_no_loop(%arg0: index, %arg1: index) {
    %0 = arith.muli %arg0, %arg1 : index
    %1 = arith.addi %0, %arg1 : index
    return
  }

  transform.named_sequence @emit_warning_only(%op: !transform.any_op {transform.consumed}) {
    transform.debug.emit_remark_at %op, "message" : !transform.any_op
    transform.yield
  }

  transform.sequence failures(propagate) {
  ^bb0(%arg0: !transform.any_op):
    transform.include @emit_warning_only failures(propagate) (%arg0) : (!transform.any_op) -> ()
    transform.yield
  }
}
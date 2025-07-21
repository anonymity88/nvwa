module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%arg0: !transform.any_op) {
    %funcs = transform.structured.match ops{["func.func"]} in %arg0 : (!transform.any_op) -> !transform.any_op
    transform.test_produce_invalid_ir %funcs : !transform.any_op
    transform.verify %funcs : !transform.any_op
    
    %linalg_ops = transform.structured.match interface{LinalgOp} in %arg0 : (!transform.any_op) -> !transform.any_op
    %flattened = transform.structured.flatten_elementwise %linalg_ops : (!transform.any_op) -> !transform.any_op
    
    transform.yield
  }
}
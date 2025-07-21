module {
  func.func @reduction3(%arg0 : index, %arg1 : index, %arg2 : index,
                        %arg3 : index, %arg4 : index) -> f32 {
    %step = arith.constant 1 : index
    %zero = arith.constant 0.0 : f32
    %final_reduce = scf.parallel (%i0, %i1) = (%arg0, %arg1) to (%arg2, %arg3)
                              step (%arg4, %step) init (%zero) -> (f32) {
      %one = arith.constant 1.0 : f32
      scf.reduce(%one : f32) {
      ^bb0(%lhs : f32, %rhs: f32):
        %cmp = arith.cmpf oge, %lhs, %rhs : f32
        %res = arith.select %cmp, %lhs, %rhs : f32
        scf.reduce.return %res : f32
      }
    }
    return %final_reduce : f32
  }

  func.func @while_unused_arg2(%val0: i32) -> i32 {
    %0 = scf.while (%val1 = %val0) : (i32) -> i32 {
      %val = "test.val"() : () -> i32
      %condition = "test.condition"() : () -> i1
      scf.condition(%condition) %val: i32
    } do {
    ^bb0(%val2: i32):
      "test.use"(%val2) : (i32) -> ()
      %val1 = "test.val1"() : () -> i32
      scf.yield %val1 : i32
    }
    return %0 : i32
  }

  func.func @simple_while_loop(%init: f32) -> f32 {
    %res = scf.while (%arg1 = %init) : (f32) -> f32 {
      %condition = func.call @evaluate_condition(%arg1) : (f32) -> i1
      scf.condition(%condition) %arg1 : f32
    } do {
    ^bb0(%arg2: f32):
      %next = func.call @payload(%arg2) : (f32) -> f32
      scf.yield %next : f32
    }
    return %res : f32
  }

  func.func @evaluate_condition(%arg: f32) -> i1 {
    %zero = arith.constant 0.0 : f32
    %cond = arith.cmpf "ogt", %arg, %zero : f32
    return %cond : i1
  }

  func.func @payload(%arg: f32) -> f32 {
    %one = arith.constant 1.0 : f32
    %incremented = arith.addf %arg, %one : f32
    return %incremented : f32
  }

  func.func @for_iter_args(%arg0 : index, %arg1: index, %arg2: index) -> f32 {
    %s0 = arith.constant 0.0 : f32
    %result:2 = scf.for %i0 = %arg0 to %arg1 step %arg2 iter_args(%iarg0 = %s0, %iarg1 = %s0) -> (f32, f32) {
      %sn = arith.addf %iarg0, %iarg1 : f32
      scf.yield %sn, %sn : f32, f32
    }
    return %result#1 : f32
  }

  func.func @main(%init_val: f32, %val0: i32, 
                  %arg0: index, %arg1: index, %arg2: index, 
                  %arg3: index, %arg4: index,
                  %for_arg0: index, %for_arg1: index, %for_arg2: index) 
                  -> (f32, i32, f32, f32) {
    %while_result = call @simple_while_loop(%init_val) : (f32) -> f32
    %unused_arg_result = call @while_unused_arg2(%val0) : (i32) -> i32
    %reduce_result = call @reduction3(%arg0, %arg1, %arg2, %arg3, %arg4) :
                     (index, index, index, index, index) -> f32
    %for_result = call @for_iter_args(%for_arg0, %for_arg1, %for_arg2) :
                  (index, index, index) -> f32
    return %while_result, %unused_arg_result, %reduce_result, %for_result : 
           f32, i32, f32, f32
  }
}
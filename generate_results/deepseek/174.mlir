module {
  func.func @max_between_buffers(%bufferA: memref<1024xf32>, %bufferB: memref<1024xf32>, 
                                 %lb: index, %ub: index, %step: index) -> f32 {
    %init_max = arith.constant -3.4028235E38 : f32  // smallest float value
    %final_max = scf.for %iv = %lb to %ub step %step
        iter_args(%max_iter = %init_max) -> (f32) {
      %valA = memref.load %bufferA[%iv] : memref<1024xf32>
      %valB = memref.load %bufferB[%iv] : memref<1024xf32>
      %cmp = arith.cmpf "ogt", %valA, %valB : f32
      %local_max = arith.select %cmp, %valA, %valB : f32
      %global_cmp = arith.cmpf "ogt", %local_max, %max_iter : f32
      %new_max = arith.select %global_cmp, %local_max, %max_iter : f32
      scf.yield %new_max : f32
    }
    return %final_max : f32
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

  func.func @main(%bufferA: memref<1024xf32>, %bufferB: memref<1024xf32>,
                  %lb: index, %ub: index, %step: index,
                  %init_val: f32,
                  %arg0: index, %arg1: index, %arg2: index,
                  %arg3: index, %arg4: index) -> (f32, f32, f32) {
    %max_val = call @max_between_buffers(%bufferA, %bufferB, %lb, %ub, %step) :
                (memref<1024xf32>, memref<1024xf32>, index, index, index) -> f32
    %while_result = call @simple_while_loop(%init_val) : (f32) -> f32
    %reduce_result = call @reduction3(%arg0, %arg1, %arg2, %arg3, %arg4) :
                     (index, index, index, index, index) -> f32
    return %max_val, %while_result, %reduce_result : f32, f32, f32
  }
}
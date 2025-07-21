module {
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

  func.func @select_value(%condition: i1, %trueValue: f32, %falseValue: f32) -> f32 {
    %result = scf.if %condition -> (f32) {
      scf.yield %trueValue : f32
    } else {
      scf.yield %falseValue : f32
    }
    return %result : f32
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

  func.func @forward_dead_store_dynamic_non_overlap_trailing_dim(
      %buffer : memref<?x?xf32>, %v0 : vector<4xf32>, %v1 : vector<4xf32>, %i0 : index) {
    %c1 = arith.constant 1 : index
    %c4 = arith.constant 4 : index
    %c0 = arith.constant 0 : index
    %cf0 = arith.constant 0.0 : f32
    %i1 = affine.apply affine_map<(d0) -> (d0 + 4)>(%i0)
    vector.transfer_write %v0, %buffer[%i0, %i0] {in_bounds = [true]} : vector<4xf32>, memref<?x?xf32>
    vector.transfer_write %v0, %buffer[%i0, %i1] {in_bounds = [true]} : vector<4xf32>, memref<?x?xf32>
    %0 = vector.transfer_read %buffer[%i0, %i0], %cf0 {in_bounds = [true]} : memref<?x?xf32>, vector<4xf32>
    %x = scf.for %iv = %c0 to %c4 step %c1 iter_args(%acc = %0) -> (vector<4xf32>) {
      %1 = arith.addf %acc, %acc : vector<4xf32>
      scf.yield %1 : vector<4xf32>
    }
    vector.transfer_write %x, %buffer[%i0, %i0] {in_bounds = [true]} : vector<4xf32>, memref<?x?xf32>
    return
  }

  func.func @main(%val0: i32, %cond: i1, %trueValue: f32, %falseValue: f32, %init: f32,
                  %buffer: memref<?x?xf32>, %v0: vector<4xf32>, %v1: vector<4xf32>, %i0: index) 
      -> (i32, f32, f32) {
    %while_result = call @while_unused_arg2(%val0) : (i32) -> i32
    %select_result = call @select_value(%cond, %trueValue, %falseValue) : (i1, f32, f32) -> f32
    %loop_result = call @simple_while_loop(%init) : (f32) -> f32
    call @forward_dead_store_dynamic_non_overlap_trailing_dim(%buffer, %v0, %v1, %i0) : 
        (memref<?x?xf32>, vector<4xf32>, vector<4xf32>, index) -> ()
    return %while_result, %select_result, %loop_result : i32, f32, f32
  }
}
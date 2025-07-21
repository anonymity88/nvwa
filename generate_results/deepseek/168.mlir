module {
  func.func @compute_parallel_sum_and_product(%buffer1: memref<100xf32>, %buffer2: memref<100xf32>,
                                              %lb: index, %ub: index, %step: index) -> (f32, f32) {
    %init = arith.constant 0.0 : f32
    %result_sum, %result_product = scf.parallel (%iv) = (%lb) to (%ub) step (%step) 
                                     init (%init, %init) -> (f32, f32) {
      %val1 = memref.load %buffer1[%iv] : memref<100xf32>
      %val2 = memref.load %buffer2[%iv] : memref<100xf32>
      scf.reduce(%val1, %val2 : f32, f32) {
        ^bb0(%lhs: f32, %rhs: f32):
          %sum_res = arith.addf %lhs, %rhs : f32
          scf.reduce.return %sum_res : f32
      }, {
        ^bb0(%lhs: f32, %rhs: f32):
          %product_res = arith.mulf %lhs, %rhs : f32
          scf.reduce.return %product_res : f32
      }
    }
    return %result_sum, %result_product : f32, f32
  }

  func.func @process_data(%A: memref<128xi32>, %B: memref<128xi32>) -> memref<128xi32> {
    %result = memref.alloc() : memref<128xi32>
    %c0 = arith.constant 0 : index
    %c128 = arith.constant 128 : index
    %c1 = arith.constant 1 : index
    scf.for %i = %c0 to %c128 step %c1 {
      %load_value = scf.execute_region -> i32 {
        %elem = memref.load %A[%i] : memref<128xi32>
        %incremented = arith.addi %elem, %elem : i32
        scf.yield %incremented : i32
      }
      memref.store %load_value, %result[%i] : memref<128xi32>
    }
    return %result : memref<128xi32>
  }

  func.func @conditional_example(%cond: i1) -> i64 {
    %conditional_value = scf.execute_region -> i64 {
      cf.cond_br %cond, ^bb_if, ^bb_else
    ^bb_if:
      %const_one = arith.constant 1 : i64
      cf.br ^bb_merge(%const_one : i64)
    ^bb_else:
      %const_two = arith.constant 2 : i64
      cf.br ^bb_merge(%const_two : i64)
    ^bb_merge(%result : i64):
      scf.yield %result : i64
    }
    return %conditional_value : i64
  }

  func.func @main(%buffer1: memref<100xf32>, %buffer2: memref<100xf32>,
                  %lb: index, %ub: index, %step: index,
                  %A: memref<128xi32>, %B: memref<128xi32>,
                  %cond: i1) -> (f32, f32, memref<128xi32>, i64) {
    %sum, %product = call @compute_parallel_sum_and_product(%buffer1, %buffer2, %lb, %ub, %step) :
                     (memref<100xf32>, memref<100xf32>, index, index, index) -> (f32, f32)
    %processed = call @process_data(%A, %B) : (memref<128xi32>, memref<128xi32>) -> memref<128xi32>
    %cond_result = call @conditional_example(%cond) : (i1) -> i64
    return %sum, %product, %processed, %cond_result : f32, f32, memref<128xi32>, i64
  }

  func.func private @private2(%0 : i32) -> i32 {
    %cond = arith.index_cast %0 {tag = "in_private2"} : i32 to index
    %1 = scf.index_switch %cond -> i32
    case 1 {
      %ten = arith.constant 10 : i32
      scf.yield %ten : i32
    }
    case 2 {
      %twenty = arith.constant 20 : i32
      scf.yield %twenty : i32
    }
    default {
      %thirty = arith.constant 30 : i32
      scf.yield %thirty : i32
    }
    func.return %1 : i32
  }
}
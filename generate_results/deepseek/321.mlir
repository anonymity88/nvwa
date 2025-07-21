#map_dim_i = affine_map<(d0)[s0] -> (-d0 + 1024, s0)>

module {
  func.func @fuse_reductions_three(%A: memref<2x2xf32>, %B: memref<2x2xf32>, %C: memref<2x2xf32>) -> (f32) {
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %init1 = arith.constant 1.0 : f32
    %init2 = arith.constant 2.0 : f32
    %init3 = arith.constant 3.0 : f32
    %res1 = scf.parallel (%i, %j) = (%c0, %c0) to (%c2, %c2) step (%c1, %c1) init(%init1) -> f32 {
      %A_elem = memref.load %A[%i, %j] : memref<2x2xf32>
      scf.reduce(%A_elem : f32) {
      ^bb0(%lhs: f32, %rhs: f32):
        %1 = arith.addf %lhs, %rhs : f32
        scf.reduce.return %1 : f32
      }
    }
    return %res1 : f32
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

  func.func @non_scalable_code() {
    %c1024 = arith.constant 1024 : index
    %c4 = arith.constant 4 : index
    %c0 = arith.constant 0 : index
    scf.for %i = %c0 to %c1024 step %c4 {
      %min_i = affine.min #map_dim_i(%i)[%c4]
      %bound_i = "test.reify_bound"(%min_i) {type = "UB", vscale_min = 1, vscale_max = 16, scalable} : (index) -> index
      "test.some_use"(%bound_i) : (index) -> ()
    }
    return
  }

  func.func @main(%A: memref<2x2xf32>, %B: memref<2x2xf32>, %C: memref<2x2xf32>,
                  %arrayA: memref<128xi32>, %arrayB: memref<128xi32>,
                  %cond: i1, %private_arg: i32) 
                  -> (f32, memref<128xi32>, i64, i32) {
    %reduction_result = call @fuse_reductions_three(%A, %B, %C) : 
                      (memref<2x2xf32>, memref<2x2xf32>, memref<2x2xf32>) -> f32
    %processed_data = call @process_data(%arrayA, %arrayB) : 
                     (memref<128xi32>, memref<128xi32>) -> memref<128xi32>
    %conditional_val = call @conditional_example(%cond) : (i1) -> i64
    %private_result = call @private2(%private_arg) : (i32) -> i32
    call @non_scalable_code() : () -> ()
    return %reduction_result, %processed_data, %conditional_val, %private_result : 
           f32, memref<128xi32>, i64, i32
  }
}
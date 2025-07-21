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

  func.func @main(%A: memref<2x2xf32>, %B: memref<2x2xf32>, %C: memref<2x2xf32>, %val0: i32) -> (f32, i32) {
    %reduction_result = call @fuse_reductions_three(%A, %B, %C) : (memref<2x2xf32>, memref<2x2xf32>, memref<2x2xf32>) -> f32
    %while_result = call @while_unused_arg2(%val0) : (i32) -> i32
    return %reduction_result, %while_result : f32, i32
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
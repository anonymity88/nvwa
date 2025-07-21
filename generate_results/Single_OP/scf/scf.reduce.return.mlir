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
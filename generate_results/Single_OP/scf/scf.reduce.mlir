func.func @reduction3(%arg0 : index, %arg1 : index, %arg2 : index,
                 %arg3 : index, %arg4 : index) {
  %step = arith.constant 1 : index
  %zero = arith.constant 0.0 : f32
  scf.parallel (%i0, %i1) = (%arg0, %arg1) to (%arg2, %arg3)
                            step (%arg4, %step) init (%zero) -> (f32) {
    %one = arith.constant 1.0 : f32
    scf.reduce(%one : f32) {
    ^bb0(%lhs : f32, %rhs: f32):
      %cmp = arith.cmpf oge, %lhs, %rhs : f32
      %res = arith.select %cmp, %lhs, %rhs : f32
      scf.reduce.return %res : f32
    }
  }
  return
}
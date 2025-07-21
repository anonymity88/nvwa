module {
  func.func @reduce_sum(%buffer: memref<1024xf32>, %lb: index,
                        %ub: index, %step: index) -> f32 {
    // Initial sum set to 0.
    %initial_sum = arith.constant 0.0 : f32
    // iter_args binds initial values to the loop's region arguments.
    %final_sum = scf.for %iv = %lb to %ub step %step
        iter_args(%sum_iter = %initial_sum) -> (f32) {
      %element = memref.load %buffer[%iv] : memref<1024xf32>
      %updated_sum = arith.addf %sum_iter, %element : f32
      // Yield current iteration sum to next iteration %sum_iter or to %final_sum
      // if final iteration.
      scf.yield %updated_sum : f32
    }
    return %final_sum : f32
  }
}
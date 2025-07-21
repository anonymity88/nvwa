module {
  func.func @compute_parallel_sum_and_product(%buffer1: memref<100xf32>, %buffer2: memref<100xf32>,
                                              %lb: index, %ub: index, %step: index) -> (f32, f32) {
    %init = arith.constant 0.0 : f32

    // Define a parallel for operation with reduction on sum and product
    %result_sum, %result_product = scf.parallel (%iv) = (%lb) to (%ub) step (%step) 
                                     init (%init, %init) -> (f32, f32) {
      // Load elements to be possibly reduced
      %val1 = memref.load %buffer1[%iv] : memref<100xf32>
      %val2 = memref.load %buffer2[%iv] : memref<100xf32>

      // Perform reduction on the loaded elements
      scf.reduce(%val1, %val2 : f32, f32) {
        // First reduction reduces by addition
        ^bb0(%lhs: f32, %rhs: f32):
          %sum_res = arith.addf %lhs, %rhs : f32
          scf.reduce.return %sum_res : f32
      }, {
        // Second reduction reduces by multiplication
        ^bb0(%lhs: f32, %rhs: f32):
          %product_res = arith.mulf %lhs, %rhs : f32
          scf.reduce.return %product_res : f32
      }
    }

    return %result_sum, %result_product : f32, f32
  }
}
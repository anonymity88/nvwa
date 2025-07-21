module {
  func.func @max_between_buffers(%bufferA: memref<1024xf32>, %bufferB: memref<1024xf32>, 
                                 %lb: index, %ub: index, %step: index) -> f32 {
    // Initialize maximum value to a very low value
    %init_max = arith.constant -3.4028235E38 : f32  // smallest float value

    // Loop using scf.for to find maximum element
    %final_max = scf.for %iv = %lb to %ub step %step
        iter_args(%max_iter = %init_max) -> (f32) {
      // Load current values from both buffers
      %valA = memref.load %bufferA[%iv] : memref<1024xf32>
      %valB = memref.load %bufferB[%iv] : memref<1024xf32>

      // Compare values and select the maximum one
      %cmp = arith.cmpf "ogt", %valA, %valB : f32
      %local_max = arith.select %cmp, %valA, %valB : f32

      // Update global maximum
      %global_cmp = arith.cmpf "ogt", %local_max, %max_iter : f32
      %new_max = arith.select %global_cmp, %local_max, %max_iter : f32

      // Yield to the next iteration
      scf.yield %new_max : f32
    }

    return %final_max : f32
  }
}
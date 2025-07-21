module {
  func.func @main() -> (memref<2x32xf32>, f32, memref<20xf32>) {
    // Allocate memory and prepare arguments for combined_func
    %arg0 = arith.constant dense<0.0> : vector<4xf8E5M2FNUZ>
    %arg1 = arith.constant 1.0 : f32
    %arg2 = memref.alloc() : memref<20xf32>
    %arg3 = arith.constant 0 : index
    %arg4 = arith.constant 0 : i32
    
    // Call combined function
    %extracted_f32, %updated_buffer = call @combined_func(%arg0, %arg1, %arg2, %arg3, %arg4) : 
      (vector<4xf8E5M2FNUZ>, f32, memref<20xf32>, index, i32) -> (f32, memref<20xf32>)
    
    // Prepare for saxpy2d_no_barrier
    %x = memref.alloc() : memref<2x32xf32>
    %y = memref.alloc() : memref<2x32xf32>
    %t = memref.alloc() : memref<32xf32>
    %alpha = arith.constant 1.0 : f32
    %stream = gpu.wait async
    
    // Call saxpy function
    %result_y = call @saxpy2d_no_barrier(%x, %y, %t, %alpha, %stream) : 
      (memref<2x32xf32>, memref<2x32xf32>, memref<32xf32>, f32, !gpu.async.token) -> memref<2x32xf32>
    
    return %result_y, %extracted_f32, %updated_buffer : memref<2x32xf32>, f32, memref<20xf32>
  }

  func.func @combined_func(
    %arg0: vector<4xf8E5M2FNUZ>, 
    %arg1: f32, 
    %arg2: memref<20xf32>, 
    %arg3: index, 
    %arg4: i32
  ) -> (f32, memref<20xf32>) {
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    %extracted_f32 = amdgpu.ext_packed_fp8 %arg0[2] : vector<4xf8E5M2FNUZ> to f32
    
    %index1 = arith.index_cast %arg3 : index to i32
    
    amdgpu.raw_buffer_store %extracted_f32 -> %arg2[%index1] sgprOffset %arg4 : f32 -> memref<20xf32>, i32
    
    amdgpu.raw_buffer_store %arg1 -> %arg2[%index1] sgprOffset %arg4 : f32 -> memref<20xf32>, i32
    
    return %extracted_f32, %arg2 : f32, memref<20xf32>
  }

  func.func @saxpy2d_no_barrier(
    %x: memref<2x32xf32>, 
    %y: memref<2x32xf32>, 
    %t: memref<32xf32>, 
    %alpha: f32, 
    %stream: !gpu.async.token
  ) -> memref<2x32xf32> {
    %one = arith.constant 1 : index
    %c12 = arith.constant 12 : index
    %c9 = arith.constant 9 : index
    %c7 = arith.constant 7 : index
    %name = gpu.launch async[%stream] blocks(%arg3, %arg4, %arg5) in (%arg9 = %one, %arg10 = %one, %arg11 = %one)
              threads(%arg6, %arg7, %arg8) in (%arg12 = %one, %arg13 = %one, %arg14 = %one) {
      scf.forall (%i, %j) in (%c7, %c9) {
        %4 = memref.load %x[%i, %j] : memref<2x32xf32>
        %5 = memref.load %y[%i, %j] : memref<2x32xf32>
        %6 = math.fma %alpha, %4, %5 : f32
        memref.store %6, %y[%i, %j] : memref<2x32xf32>
      } { mapping = [#gpu.thread<y>, #gpu.thread<x>] }
      gpu.terminator
    }
    return %y : memref<2x32xf32>
  }
}
module {
  func.func @main() -> i32 {
    // Prepare arguments for combined_func
    %arg0 = arith.constant 42 : i32
    %arg1 = memref.alloc() : memref<10xi32>
    %arg2 = arith.constant 0 : index
    %arg3 = memref.alloc() : memref<16xi32>
    %arg4 = arith.constant 0 : i32
    %arg5 = arith.constant 0 : i32
    
    // Call combined function
    %result = call @combined_func(%arg0, %arg1, %arg2, %arg3, %arg4, %arg5) : 
      (i32, memref<10xi32>, index, memref<16xi32>, i32, i32) -> i32
    
    // Prepare arguments for test_math
    %math_arg = arith.constant 1.0 : f32
    call @test_math(%math_arg) : (f32) -> ()
    
    return %result : i32
  }

  func.func @combined_func(
    %arg0: i32, 
    %arg1: memref<10xi32>, 
    %arg2: index,
    %arg3: memref<16xi32>, 
    %arg4: i32, 
    %arg5: i32
  ) -> i32 {
    %index1 = arith.index_cast %arg2 : index to i32
    amdgpu.raw_buffer_atomic_smax %arg0 -> %arg1[%index1] : i32 -> memref<10xi32>, i32
    
    amdgpu.lds_barrier
    
    %loaded_value = amdgpu.raw_buffer_load %arg3[%arg4] sgprOffset %arg5 : memref<16xi32>, i32 -> i32
    
    return %loaded_value : i32
  }

  func.func @test_math(%arg0 : f32) {
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    gpu.launch 
        blocks(%0, %1, %2) in (%3 = %c1, %4 = %c1, %5 = %c1) 
        threads(%6, %7, %8) in (%9 = %c2, %10 = %c1, %11 = %c1) { 
        %s1 = math.exp %arg0 : f32
        gpu.printf "%f" %s1 : f32
        gpu.terminator
    }
    return
  }
}
module {
  func.func @combined(
    %x: f32,
    %v: vector<4xf32>,
    %h: vector<3xf16>,
    %pointer_i32: !spirv.ptr<i32, StorageBuffer>,
    %value_i32: i32,
    %pointer_i64: !spirv.ptr<i64, StorageBuffer>,
    %value_i64: i64,
    %bitwise_arg0: i32,
    %bitwise_arg1: vector<3xi32>
  ) -> (f32, vector<4xf32>, vector<3xf16>, f32, i32, i64, i32, vector<3xi32>) {
    // SPIR-V operations
    %ceil_scalar = spirv.CL.ceil %x : f32
    %ceil_vec = spirv.CL.ceil %v : vector<4xf32>
    %ceil_half_vec = spirv.CL.ceil %h : vector<3xf16>
    %undef = spirv.Undef : f32
    %atomic_xor_i32 = spirv.AtomicXor <Device> <None> %pointer_i32, %value_i32 : !spirv.ptr<i32, StorageBuffer>
    %atomic_xor_i64 = spirv.AtomicXor <Device> <None> %pointer_i64, %value_i64 : !spirv.ptr<i64, StorageBuffer>
    
    // Call bitwise_and function
    %bitwise_result0, %bitwise_result1 = call @bitwise_and_x_0(%bitwise_arg0, %bitwise_arg1) : (i32, vector<3xi32>) -> (i32, vector<3xi32>)
    
    // Call volatile load function
    call @volatile_aligned_load() : () -> ()
    
    return %ceil_scalar, %ceil_vec, %ceil_half_vec, %undef, %atomic_xor_i32, %atomic_xor_i64, %bitwise_result0, %bitwise_result1 : 
           f32, vector<4xf32>, vector<3xf16>, f32, i32, i64, i32, vector<3xi32>
  }

  func.func @bitwise_and_x_0(%arg0 : i32, %arg1 : vector<3xi32>) -> (i32, vector<3xi32>) {
    %c0 = spirv.Constant 0 : i32
    %cv0 = spirv.Constant dense<0> : vector<3xi32>
    %0 = spirv.BitwiseAnd %arg0, %c0 : i32
    %1 = spirv.BitwiseAnd %arg1, %cv0 : vector<3xi32>
    return %0, %1 : i32, vector<3xi32>
  }

  func.func @volatile_aligned_load() -> () {
    %0 = spirv.Variable : !spirv.ptr<f32, Function>
    %1 = "spirv.Load"(%0) {memory_access = #spirv.memory_access<Volatile|Aligned>, alignment = 4 : i32} : (!spirv.ptr<f32, Function>) -> (f32)
    return
  }
}
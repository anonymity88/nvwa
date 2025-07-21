module {
  func.func @combined(
    %x: f32,
    %v: vector<4xf32>,
    %h: vector<3xf16>,
    %pointer_i32: !spirv.ptr<i32, StorageBuffer>,
    %value_i32: i32,
    %pointer_i64: !spirv.ptr<i64, StorageBuffer>,
    %value_i64: i64
  ) -> (f32, vector<4xf32>, vector<3xf16>, f32, i32, i64) {
    // Compute ceiling for scalar float
    %ceil_scalar = spirv.CL.ceil %x : f32
    
    // Compute ceiling for vector of floats
    %ceil_vec = spirv.CL.ceil %v : vector<4xf32>
    
    // Compute ceiling for vector of half floats
    %ceil_half_vec = spirv.CL.ceil %h : vector<3xf16>
    
    // Create an undefined float value
    %undef = spirv.Undef : f32
    
    // Perform atomic XOR operation on 32-bit integer
    %atomic_xor_i32 = spirv.AtomicXor <Device> <None> %pointer_i32, %value_i32 : !spirv.ptr<i32, StorageBuffer>
    
    // Perform atomic XOR operation on 64-bit integer
    %atomic_xor_i64 = spirv.AtomicXor <Device> <None> %pointer_i64, %value_i64 : !spirv.ptr<i64, StorageBuffer>
    
    // Return all results
    return %ceil_scalar, %ceil_vec, %ceil_half_vec, %undef, %atomic_xor_i32, %atomic_xor_i64 : 
           f32, vector<4xf32>, vector<3xf16>, f32, i32, i64
  }
}
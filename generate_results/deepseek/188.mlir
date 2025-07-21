module {
  func.func @combined(
    %x: f32,
    %v: vector<4xf32>,
    %y: vector<3xf16>,
    %pointer_i32: !spirv.ptr<i32, StorageBuffer>,
    %value_i32: i32,
    %pointer_i64: !spirv.ptr<i64, StorageBuffer>,
    %value_i64: i64,
    %base: i32,
    %offset: i8,
    %count: i8,
    %v_base: vector<4xi32>
  ) -> (f32, vector<4xf32>, vector<3xf16>, i32, i64, i32, vector<4xi32>) {
    // Compute FSign operations
    %fsign_scalar = spirv.GL.FSign %x : f32
    %fsign_vec4 = spirv.GL.FSign %v : vector<4xf32>
    %fsign_vec3 = spirv.GL.FSign %y : vector<3xf16>

    // Perform atomic XOR operations
    %atomic_xor_i32 = spirv.AtomicXor <Device> <None> %pointer_i32, %value_i32 : !spirv.ptr<i32, StorageBuffer>
    %atomic_xor_i64 = spirv.AtomicXor <Device> <None> %pointer_i64, %value_i64 : !spirv.ptr<i64, StorageBuffer>

    // Perform bit field operations
    %bitfield_scalar = spirv.BitFieldSExtract %base, %offset, %count : i32, i8, i8
    %bitfield_vector = spirv.BitFieldSExtract %v_base, %offset, %count : vector<4xi32>, i8, i8

    // Return all results
    return %fsign_scalar, %fsign_vec4, %fsign_vec3, %atomic_xor_i32, %atomic_xor_i64, %bitfield_scalar, %bitfield_vector : 
           f32, vector<4xf32>, vector<3xf16>, i32, i64, i32, vector<4xi32>
  }
}
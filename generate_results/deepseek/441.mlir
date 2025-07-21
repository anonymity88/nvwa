module {
  func.func @main(
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
  ) -> (f32, vector<4xf32>, vector<3xf16>, i32, i64, i32, vector<4xi32>, i32, i32) {
    // Call combined function for SPIR-V operations
    %fsign_scalar, %fsign_vec4, %fsign_vec3, %atomic_xor_i32, %atomic_xor_i64, %bitfield_scalar, %bitfield_vector = 
      call @combined(%x, %v, %y, %pointer_i32, %value_i32, %pointer_i64, %value_i64, %base, %offset, %count, %v_base) : 
      (f32, vector<4xf32>, vector<3xf16>, !spirv.ptr<i32, StorageBuffer>, i32, !spirv.ptr<i64, StorageBuffer>, i64, i32, i8, i8, vector<4xi32>) -> 
      (f32, vector<4xf32>, vector<3xf16>, i32, i64, i32, vector<4xi32>)
    
    // Call extract_array_final function
    %extracted_val1, %extracted_val2 = call @extract_array_final() : () -> (i32, i32)
    
    return %fsign_scalar, %fsign_vec4, %fsign_vec3, %atomic_xor_i32, %atomic_xor_i64, %bitfield_scalar, %bitfield_vector, %extracted_val1, %extracted_val2 : 
           f32, vector<4xf32>, vector<3xf16>, i32, i64, i32, vector<4xi32>, i32, i32
  }

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
    %fsign_scalar = spirv.GL.FSign %x : f32
    %fsign_vec4 = spirv.GL.FSign %v : vector<4xf32>
    %fsign_vec3 = spirv.GL.FSign %y : vector<3xf16>

    %atomic_xor_i32 = spirv.AtomicXor <Device> <None> %pointer_i32, %value_i32 : !spirv.ptr<i32, StorageBuffer>
    %atomic_xor_i64 = spirv.AtomicXor <Device> <None> %pointer_i64, %value_i64 : !spirv.ptr<i64, StorageBuffer>

    %bitfield_scalar = spirv.BitFieldSExtract %base, %offset, %count : i32, i8, i8
    %bitfield_vector = spirv.BitFieldSExtract %v_base, %offset, %count : vector<4xi32>, i8, i8

    return %fsign_scalar, %fsign_vec4, %fsign_vec3, %atomic_xor_i32, %atomic_xor_i64, %bitfield_scalar, %bitfield_vector : 
           f32, vector<4xf32>, vector<3xf16>, i32, i64, i32, vector<4xi32>
  }

  func.func @extract_array_final() -> (i32, i32) {
    %0 = spirv.Constant [dense<[4, -5]> : vector<2xi32>] : !spirv.array<1 x vector<2xi32>>
    %1 = spirv.CompositeExtract %0[0 : i32, 0 : i32] : !spirv.array<1 x vector<2 x i32>>
    %2 = spirv.CompositeExtract %0[0 : i32, 1 : i32] : !spirv.array<1 x vector<2 x i32>>
    return %1, %2 : i32, i32
  }
}
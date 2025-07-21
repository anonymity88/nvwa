module {
  func.func @main(%arg0: f32, %arg1: memref<10xf32>, %arg2: index, %arg3: i32) {
    %index1 = arith.index_cast %arg2 : index to i32
    amdgpu.raw_buffer_atomic_fmax %arg0 -> %arg1[%index1] sgprOffset %arg3 : f32 -> memref<10xf32>, i32
    return
  }
}
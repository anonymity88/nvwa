module {
  func.func @main(%arg0: memref<16xi32>, %arg1: i32, %arg2: i32) -> i32 {
    %loaded_value = amdgpu.raw_buffer_load %arg0[%arg1] sgprOffset %arg2 : memref<16xi32>, i32 -> i32
    return %loaded_value : i32
  }
}
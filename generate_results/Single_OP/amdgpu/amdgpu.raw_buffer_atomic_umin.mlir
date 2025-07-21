module {
  func.func @main(%arg0: i32, %arg1: memref<8xi32>, %arg2: index, %arg3: i32) {
    %index1 = arith.index_cast %arg2 : index to i32
    amdgpu.raw_buffer_atomic_umin %arg0 -> %arg1[%index1] sgprOffset %arg3 : i32 -> memref<8xi32>, i32
    return
  }
}
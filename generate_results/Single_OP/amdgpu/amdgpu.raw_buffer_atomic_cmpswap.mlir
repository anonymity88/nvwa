module {
  func.func @main(%arg0: i32, %arg1: i32, %arg2: memref<10xi32>, %arg3: index, %arg4: i32) {
    %index1 = arith.index_cast %arg3 : index to i32
    amdgpu.raw_buffer_atomic_cmpswap %arg0, %arg1 -> %arg2[%index1] sgprOffset %arg4 : i32 -> memref<10xi32>, i32
    return
  }
}
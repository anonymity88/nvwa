module {
  func.func @main(%arg0: i32, %arg1: memref<10xi32>, %arg2: index) {
    %index1 = arith.index_cast %arg2 : index to i32
    amdgpu.raw_buffer_atomic_smax %arg0 -> %arg1[%index1] : i32 -> memref<10xi32>, i32
    return
  }
}
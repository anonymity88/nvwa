module {
  func.func @main() -> () {
    %src = memref.alloc() : memref<16xf32>
    %dst = memref.alloc() : memref<16xf32, 3>
    %c0 = arith.constant 0 : index
    // Perform asynchronous copy 1
    %cp1 = nvgpu.device_async_copy %src[%c0], %dst[%c0], 4 : memref<16xf32> to memref<16xf32, 3>

    %C = memref.alloc() : memref<16xf32>
    %D = memref.alloc() : memref<16xf32, 3>
    // Perform asynchronous copy 2
    %cp2 = nvgpu.device_async_copy %C[%c0], %D[%c0], 4 : memref<16xf32> to memref<16xf32, 3>

    // Create group for copy 1 and copy 2
    %token1 = nvgpu.device_async_create_group %cp1, %cp2

    %E = memref.alloc() : memref<16xf32>
    %F = memref.alloc() : memref<16xf32, 3>
    // Perform asynchronous copy 3
    %cp3 = nvgpu.device_async_copy %E[%c0], %F[%c0], 4 : memref<16xf32> to memref<16xf32, 3>

    // Create group for copy 3
    %token2 = nvgpu.device_async_create_group %cp3

    // Wait for group 1 to complete
    nvgpu.device_async_wait %token1

    // Wait for group 2 to complete
    nvgpu.device_async_wait %token2

    return
  }
}
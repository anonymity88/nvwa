module {
  func.func @main() -> !gpu.async.token {
    // Memory allocations and initializations
    %src = memref.alloc() : memref<128xf32>
    %dst = memref.alloc() : memref<128xf32>
    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %token = gpu.memcpy async [%dep] %dst, %src : memref<128xf32>, memref<128xf32>

    // Get subgroup size
    %sgSz = gpu.subgroup_size : index

    // Prepare constants for later use
    %f0 = arith.constant 3.14 : f32
    %f1 = arith.constant 2.71 : f32

    // Prepare tensors for matmul operation
    %x = tensor.empty() : tensor<32x32xf32>
    %y = tensor.empty() : tensor<32x32xf32>
    %z = tensor.empty() : tensor<32x32xf32>

    // Launch matmul kernel
    %new_token = call @map_nested_forall_to_threads_not_buffer(%x, %y, %z, %token) : 
      (tensor<32x32xf32>, tensor<32x32xf32>, tensor<32x32xf32>, !gpu.async.token) -> !gpu.async.token

    return %new_token : !gpu.async.token
  }

  func.func @map_nested_forall_to_threads_not_buffer(
    %x: tensor<32x32xf32>, 
    %y: tensor<32x32xf32>, 
    %z: tensor<32x32xf32>, 
    %stream: !gpu.async.token
  ) -> !gpu.async.token {
    %one = arith.constant 1 : index
    %name = gpu.launch async[%stream] blocks(%arg3, %arg4, %arg5) in (%arg9 = %one, %arg10 = %one, %arg11 = %one)
              threads(%arg6, %arg7, %arg8) in (%arg12 = %one, %arg13 = %one, %arg14 = %one) {
      %t = linalg.matmul ins(%x, %y: tensor<32x32xf32>, tensor<32x32xf32>) outs(%z : tensor<32x32xf32>) -> tensor<32x32xf32>
      gpu.terminator
    }
    return %name : !gpu.async.token
  }
}
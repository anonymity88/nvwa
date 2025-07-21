#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main() -> (vector<2x2xf32>, !nvgpu.device.async.token) {
    // Allocate memory and prepare arguments for main function
    %src1 = memref.alloc() : memref<16xf32>
    %dst1 = memref.alloc() : memref<16xf32, 3>
    %c0 = arith.constant 0 : index
    %cp1 = nvgpu.device_async_copy %src1[%c0], %dst1[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    
    %src2 = memref.alloc() : memref<16xf32>
    %dst2 = memref.alloc() : memref<16xf32, 3>
    %cp2 = nvgpu.device_async_copy %src2[%c0], %dst2[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    
    %token1 = nvgpu.device_async_create_group %cp1, %cp2
    
    %src3 = memref.alloc() : memref<16xf32>
    %dst3 = memref.alloc() : memref<16xf32, 3>
    %cp3 = nvgpu.device_async_copy %src3[%c0], %dst3[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    
    %token2 = nvgpu.device_async_create_group %cp3
    
    %srcMemref = memref.alloc() : memref<8x8xf16, 3>
    %matrixA = nvgpu.ldmatrix %srcMemref[%c0, %c0] {numTiles = 4 : i32, transpose = false} : 
      memref<8x8xf16, 3> -> vector<4x2xf16>
    
    %matrixB = arith.constant dense<[[1.0, 2.0], [3.0, 4.0]]> : vector<2x2xf16>
    %matrixC = arith.constant dense<[[5.0, 6.0], [7.0, 8.0]]> : vector<2x2xf32>
    
    %res = nvgpu.mma.sync (%matrixA, %matrixB, %matrixC) {mmaShape = [16, 8, 16]} : 
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf32>) -> vector<2x2xf32>
    
    nvgpu.device_async_wait %token1
    nvgpu.device_async_wait %token2
    
    // Prepare arguments for async_cp_i4
    %src_i4 = memref.alloc() : memref<128x64xi4>
    %dst_i4 = memref.alloc() : memref<128x128xi4, 3>
    %async_token = call @async_cp_i4(%src_i4, %dst_i4, %c0) : 
      (memref<128x64xi4>, memref<128x128xi4, 3>, index) -> !nvgpu.device.async.token
    
    return %res, %async_token : vector<2x2xf32>, !nvgpu.device.async.token
  }

  func.func @async_cp_i4(
    %src: memref<128x64xi4>, %dst: memref<128x128xi4, 3>, %i : index
  ) -> !nvgpu.device.async.token {
    %0 = nvgpu.device_async_copy %src[%i, %i], %dst[%i, %i], 32 : memref<128x64xi4> to memref<128x128xi4, 3>
    return %0 : !nvgpu.device.async.token
  }
}
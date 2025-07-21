#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main() -> vector<2x2xf32> {
    %c0 = arith.constant 0 : index
    %c4 = arith.constant 4 : index
    
    // Async memory operations
    %src1 = memref.alloc() : memref<16xf32>
    %dst1 = memref.alloc() : memref<16xf32, 3>
    %cp1 = nvgpu.device_async_copy %src1[%c0], %dst1[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    
    %src2 = memref.alloc() : memref<16xf32>
    %dst2 = memref.alloc() : memref<16xf32, 3>
    %cp2 = nvgpu.device_async_copy %src2[%c0], %dst2[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    
    %token1 = nvgpu.device_async_create_group %cp1, %cp2
    
    %src3 = memref.alloc() : memref<16xf32>
    %dst3 = memref.alloc() : memref<16xf32, 3>
    %cp3 = nvgpu.device_async_copy %src3[%c0], %dst3[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    
    %token2 = nvgpu.device_async_create_group %cp3
    
    // Matrix operations
    %srcMemref = memref.alloc() : memref<8x8xf16, 3>
    %matrixA = nvgpu.ldmatrix %srcMemref[%c0, %c0] {numTiles = 4 : i32, transpose = false} : 
      memref<8x8xf16, 3> -> vector<4x2xf16>
    
    %matrixB = arith.constant dense<[[1.0, 2.0], [3.0, 4.0]]> : vector<2x2xf16>
    %matrixC = arith.constant dense<[[5.0, 6.0], [7.0, 8.0]]> : vector<2x2xf32>
    
    %res = nvgpu.mma.sync (%matrixA, %matrixB, %matrixC) {mmaShape = [16, 8, 16]} : 
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf32>) -> vector<2x2xf32>
    
    // Wait for async operations
    nvgpu.device_async_wait %token1
    nvgpu.device_async_wait %token2
    
    // Call matmul function
    %A = memref.alloc() : memref<16x4xf32>
    %B = memref.alloc() : memref<4x8xf32>
    %C = memref.alloc() : memref<16x8xf32>
    call @matmul_16x8x4xf32_global(%A, %B, %C) : (memref<16x4xf32>, memref<4x8xf32>, memref<16x8xf32>) -> ()
    
    // Call mma_sync function
    %mma_result = call @mma_sync(%matrixA, %matrixB, %matrixB) : 
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf16>) -> vector<2x2xf16>
    
    return %res : vector<2x2xf32>
  }

  func.func @matmul_16x8x4xf32_global(
      %A: memref<16x4xf32>, %B: memref<4x8xf32>, %C: memref<16x8xf32>) {
    linalg.matmul ins(%A, %B: memref<16x4xf32>, memref<4x8xf32>)
              outs(%C: memref<16x8xf32>)
    return
  }

  func.func @mma_sync(%arg0: vector<4x2xf16>,
                 %arg1: vector<2x2xf16>,
                 %arg2: vector<2x2xf16>) -> vector<2x2xf16> {
    %d = nvgpu.mma.sync(%arg0, %arg1, %arg2) {mmaShape = [16, 8, 16]} :
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf16>) -> vector<2x2xf16>
    return %d : vector<2x2xf16>
  }
}
#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main() -> vector<2x2xf32> {
    // Device async copies
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

    // Matrix operations
    %srcMemref = memref.alloc() : memref<8x8xf16, 3>
    %ldMatrixResult = nvgpu.ldmatrix %srcMemref[%c0, %c0] {numTiles = 4 : i32, transpose = false} :
      memref<8x8xf16, 3> -> vector<4x2xf16>

    %matrixB = arith.constant dense<[[1.0, 2.0], [3.0, 4.0]]> : vector<2x2xf16>
    %matrixC = arith.constant dense<[[5.0, 6.0], [7.0, 8.0]]> : vector<2x2xf32>

    %res = nvgpu.mma.sync (%ldMatrixResult, %matrixB, %matrixC) {mmaShape = [16, 8, 16]} :
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf32>) -> vector<2x2xf32>

    // Wait for async operations
    nvgpu.device_async_wait %token1
    nvgpu.device_async_wait %token2

    // Call non_constant_launches function
    %launch_size = arith.constant 4 : index
    call @non_constant_launches(%launch_size) : (index) -> ()

    return %res : vector<2x2xf32>
  }

  func.func @non_constant_launches(%arg0 : index) {
    gpu.launch blocks(%bx, %by, %bz) in (%grid_x = %arg0, %grid_y = %arg0,
                                         %grid_z = %arg0)
               threads(%tx, %ty, %tz) in (%block_x = %arg0, %block_y = %arg0,
                                          %block_z = %arg0) {
      gpu.terminator
    }
    return
  }
}
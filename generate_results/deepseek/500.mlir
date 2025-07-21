#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @load_matrix_fragment(%arg0: memref<128x128xf16>, %ldRow: index, %ldCol: index,
                                %stRow: index, %stCol: index, %fragRow: index, %fragCol: index)
                                -> vector<1x2xf16> {
    %shm = memref.alloc() : memref<128x32xf16, 3>
    %shmView = memref.subview %shm[0, 0][64, 32][1, 1] : memref<128x32xf16, 3> to memref<64x32xf16, 3>
    %0 = nvgpu.device_async_copy %arg0[%ldRow, %ldCol], %shm[%stRow, %stCol], 8
        : memref<128x128xf16> to memref<128x32xf16, 3>
    %1 = nvgpu.device_async_create_group %0
    nvgpu.device_async_wait %1 { numGroups = 1 : i32}
    %mat = nvgpu.ldmatrix %shmView[%fragRow, %fragCol] {numTiles = 1 : i32, transpose = false}
        : memref<64x32xf16, 3> -> vector<1x2xf16>
    return %mat: vector<1x2xf16>
  }

  func.func @mma_sp_sync_f16_16832(%arg0: vector<4x2xf16>,
                                  %arg1: vector<4x2xf16>,
                                  %arg2: vector<2x2xf16>,
                                  %arg3: vector<2xi16>) -> vector<2x2xf16> {
    %d = nvgpu.mma.sp.sync(%arg0, %arg1, %arg2) metadata(%arg3) {mmaShape = [16, 8, 32]} :
      (vector<4x2xf16>, vector<4x2xf16>, vector<2x2xf16>) -> vector<2x2xf16>
    return %d : vector<2x2xf16>
  }

  func.func @main() -> vector<2x2xf32> {
    %c0 = arith.constant 0 : index
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

    %srcMemref = memref.alloc() : memref<8x8xf16, 3>
    %ldMatrixResult = nvgpu.ldmatrix %srcMemref[%c0, %c0] {numTiles = 4 : i32, transpose = false} :
      memref<8x8xf16, 3> -> vector<4x2xf16>

    %matrixB = arith.constant dense<[[1.0, 2.0], [3.0, 4.0]]> : vector<2x2xf16>
    %matrixC = arith.constant dense<[[5.0, 6.0], [7.0, 8.0]]> : vector<2x2xf32>

    %res = nvgpu.mma.sync (%ldMatrixResult, %matrixB, %matrixC) {mmaShape = [16, 8, 16]} :
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf32>) -> vector<2x2xf32>

    // Call the load_matrix_fragment function
    %input_matrix = memref.alloc() : memref<128x128xf16>
    %fragment = func.call @load_matrix_fragment(%input_matrix, %c0, %c0, %c0, %c0, %c0, %c0) : 
      (memref<128x128xf16>, index, index, index, index, index, index) -> vector<1x2xf16>

    // Prepare metadata for mma.sp.sync
    %metadata = arith.constant dense<0> : vector<2xi16>
    
    // Call the mma_sp_sync_f16_16832 function
    %sparse_result = func.call @mma_sp_sync_f16_16832(%ldMatrixResult, %ldMatrixResult, %matrixB, %metadata) :
      (vector<4x2xf16>, vector<4x2xf16>, vector<2x2xf16>, vector<2xi16>) -> vector<2x2xf16>

    nvgpu.device_async_wait %token1
    nvgpu.device_async_wait %token2

    return %res : vector<2x2xf32>
  }
}
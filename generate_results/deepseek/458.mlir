#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  memref.global "private" @bufferLhsGlobal : memref<64x32xf32, #gpu.address_space<workgroup>>
  memref.global "private" @bufferRhsGlobal : memref<8x32xf32, #gpu.address_space<workgroup>>

  func.func @main() -> vector<2x2xf32> {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c4 = arith.constant 4 : index

    // Async copy operations
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
    
    nvgpu.device_async_wait %token1
    nvgpu.device_async_wait %token2

    // GPU launch operations
    %0 = gpu.wait async
    %memref, %asyncToken = gpu.alloc async [%0] () : memref<64x32xf32>
    %memref_1, %asyncToken_2 = gpu.alloc async [%0] () : memref<8x32xf32>
    
    gpu.launch blocks(%bx, %by, %bz) in (%grid_x = %c1, %grid_y = %c1, %grid_z = %c1)
              threads(%tx, %ty, %tz) in (%block_x = %c128, %block_y = %c1, %block_z = %c1) {
      %out = memref.get_global @bufferLhsGlobal : memref<64x32xf32, #gpu.address_space<workgroup>>
      %out_1 = memref.get_global @bufferRhsGlobal : memref<8x32xf32, #gpu.address_space<workgroup>>
      linalg.copy ins(%memref: memref<64x32xf32>) outs(%out: memref<64x32xf32, #gpu.address_space<workgroup>>)
      linalg.copy ins(%memref_1: memref<8x32xf32>) outs(%out_1: memref<8x32xf32, #gpu.address_space<workgroup>>)
      gpu.terminator
    }

    return %res : vector<2x2xf32>
  }

  func.func @abort_if_subview(%arg0: memref<128x128xf16>,
                             %ldRow: index, %ldCol: index,
                             %stRow: index, %stCol: index,
                             %fragRow: index, %fragCol: index) -> vector<1x2xf16> {
    %shm = memref.alloc() : memref<128x32xf16, 3>
    %shmView = memref.subview %shm[0, 0][64, 32][1, 1] : memref<128x32xf16, 3> to memref<64x32xf16, 3>
    %0 = nvgpu.device_async_copy %arg0[%ldRow, %ldCol], %shm[%stRow, %stCol], 8
        : memref<128x128xf16> to memref<128x32xf16, 3>
    %1 = nvgpu.device_async_create_group %0
    nvgpu.device_async_wait %1 {numGroups = 1 : i32}
    %mat = nvgpu.ldmatrix %shmView[%fragRow, %fragCol] {numTiles = 1 : i32, transpose = false}
        : memref<64x32xf16, 3> -> vector<1x2xf16>
    return %mat : vector<1x2xf16>
  }
}
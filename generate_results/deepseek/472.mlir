#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func private @body(%arg0: index, %arg1: memref<?xf32, #gpu.address_space<workgroup>>)

  func.func @load_matrices(%arg0: memref<128x128xf16>, %ldRow: index, %ldCol: index,
                          %stRow: index, %stCol: index,
                          %fragRow: index, %fragCol: index) -> (vector<4x2xf16>, vector<4x2xf16>) {
    %shm = memref.alloc() : memref<128x32xf16, 3>
    %shmB = memref.alloc() : memref<32x128xf16, 3>
    %0 = nvgpu.device_async_copy %arg0[%ldRow, %ldCol], %shm[%stRow, %stCol], 8
        : memref<128x128xf16> to memref<128x32xf16, 3>
    %1 = nvgpu.device_async_create_group %0
    nvgpu.device_async_wait %1 {numGroups = 1 : i32}
    %mat = nvgpu.ldmatrix %shm[%fragRow, %fragCol] {numTiles = 4 : i32, transpose = false}
        : memref<128x32xf16, 3> -> vector<4x2xf16>
    %2 = nvgpu.device_async_copy %arg0[%ldRow, %ldCol], %shmB[%stRow, %stCol], 8
        : memref<128x128xf16> to memref<32x128xf16, 3>
    %3 = nvgpu.device_async_create_group %2
    nvgpu.device_async_wait %3 {numGroups = 1 : i32}
    %matB = nvgpu.ldmatrix %shmB[%fragRow, %fragCol] {numTiles = 4 : i32, transpose = false}
        : memref<32x128xf16, 3> -> vector<4x2xf16>
    return %mat, %matB : vector<4x2xf16>, vector<4x2xf16>
  }

  func.func @simple_depth_2_peeled(%global: memref<?xf32>) {
    %c0 = arith.constant 0 : index
    %c100 = arith.constant 100 : index
    %c200 = arith.constant 200 : index
    %c4 = arith.constant 4 : index
    %shared = memref.alloc(%c200) : memref<?xf32, #gpu.address_space<workgroup>>
    %c0f = arith.constant 0.0 : f32
    scf.for %i = %c0 to %c100 step %c4 {
      %mem = vector.transfer_read %global[%i], %c0f : memref<?xf32>, vector<4xf32>
      vector.transfer_write %mem, %shared[%i] : vector<4xf32>, memref<?xf32, #gpu.address_space<workgroup>>
      func.call @body(%i, %shared) : (index, memref<?xf32, #gpu.address_space<workgroup>>) -> ()
    }
    return
  }

  func.func @main() -> vector<2x2xf32> {
    %c0 = arith.constant 0 : index
    %c4 = arith.constant 4 : index
    
    // Async copy operations
    %src1 = memref.alloc() : memref<16xf32>
    %dst1 = memref.alloc() : memref<16xf32, 3>
    %cp1 = nvgpu.device_async_copy %src1[%c0], %dst1[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    
    %src2 = memref.alloc() : memref<16xf32>
    %dst2 = memref.alloc() : memref<16xf32, 3>
    %cp2 = nvgpu.device_async_copy %src2[%c0], %dst2[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    
    %token1 = nvgpu.device_async_create_group %cp1, %cp2

    // Matrix operations
    %srcMemref = memref.alloc() : memref<8x8xf16, 3>
    %ldMatrixResult = nvgpu.ldmatrix %srcMemref[%c0, %c0] {numTiles = 4 : i32, transpose = false} :
      memref<8x8xf16, 3> -> vector<4x2xf16>

    %matrixB = arith.constant dense<[[1.0, 2.0], [3.0, 4.0]]> : vector<2x2xf16>
    %matrixC = arith.constant dense<[[5.0, 6.0], [7.0, 8.0]]> : vector<2x2xf32>

    %res = nvgpu.mma.sync (%ldMatrixResult, %matrixB, %matrixC) {mmaShape = [16, 8, 16]} :
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf32>) -> vector<2x2xf32>

    nvgpu.device_async_wait %token1

    // Additional async copy
    %src3 = memref.alloc() : memref<16xf32>
    %dst3 = memref.alloc() : memref<16xf32, 3>
    %cp3 = nvgpu.device_async_copy %src3[%c0], %dst3[%c0], 4 : memref<16xf32> to memref<16xf32, 3>
    %token2 = nvgpu.device_async_create_group %cp3
    nvgpu.device_async_wait %token2

    // Call the memory transfer function
    %global_mem = memref.alloc(%c4) : memref<?xf32>
    func.call @simple_depth_2_peeled(%global_mem) : (memref<?xf32>) -> ()

    return %res : vector<2x2xf32>
  }
}
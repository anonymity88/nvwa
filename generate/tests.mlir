#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main() -> vector<2x2xf32> {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c4 = arith.constant 4 : index
    %c128 = arith.constant 128 : index
    %c100 = arith.constant 100 : index
    %c0f = arith.constant 0.0 : f32

    // Allocate memory for async copy operations
    %src1 = memref.alloc() : memref<16xf32>
    %dst1 = memref.alloc() : memref<16xf32, 3>
    %cp1 = nvgpu.device_async_copy %src1[%c0], %dst1[%c0], 4 : memref<16xf32> to memref<16xf32, 3>

    %src2 = memref.alloc() : memref<16xf32>
    %dst2 = memref.alloc() : memref<16xf32, 3>
    %cp2 = nvgpu.device_async_copy %src2[%c0], %dst2[%c0], 4 : memref<16xf32> to memref<16xf32, 3>

    %token1 = nvgpu.device_async_create_group %cp1, %cp2

    // Load matrix and perform MMA operation
    %srcMatrix = memref.alloc() : memref<8x8xf16, 3>
    %ldMatrixResult = nvgpu.ldmatrix %srcMatrix[%c0, %c0] {numTiles = 4 : i32, transpose = false} :
      memref<8x8xf16, 3> -> vector<4x2xf16>

    %matrixB = arith.constant dense<[[1.0, 2.0], [3.0, 4.0]]> : vector<2x2xf16>
    %matrixC = arith.constant dense<[[5.0, 6.0], [7.0, 8.0]]> : vector<2x2xf32>

    %res = nvgpu.mma.sync (%ldMatrixResult, %matrixB, %matrixC) {mmaShape = [16, 8, 16]} :
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf32>) -> vector<2x2xf32>

    nvgpu.device_async_wait %token1

    // Additional async copy operations
    %E = memref.alloc() : memref<16xf32>
    %F = memref.alloc() : memref<16xf32, 3>
    %cp3 = nvgpu.device_async_copy %E[%c0], %F[%c0], 4 : memref<16xf32> to memref<16xf32, 3>

    %token2 = nvgpu.device_async_create_group %cp3

    nvgpu.device_async_wait %token2

    // Loop with vector transfer
    %shared = memref.alloc(%c100) : memref<?xf32, #gpu.address_space<workgroup>>
    scf.for %i = %c0 to %c100 step %c4 iter_args(%accum = %c0f) -> f32 {
      %mem = vector.transfer_read %src1[%i], %c0f : memref<16xf32>, vector<4xf32>
      vector.transfer_write %mem, %shared[%i] : vector<4xf32>, memref<?xf32, #gpu.address_space<workgroup>>
      %0 = arith.addf %accum, %accum : f32
      scf.yield %0 : f32
    }

    // Matrix multiplication using linalg.matmul
    %A = memref.alloc() : memref<16x16xf16>
    %B = memref.alloc() : memref<16x8xf16>
    %C = memref.alloc() : memref<16x8xf16>
    linalg.matmul ins(%A, %B: memref<16x16xf16>, memref<16x8xf16>)
              outs(%C: memref<16x8xf16>)

    // GPU memory operations
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

  memref.global "private" @bufferLhsGlobal : memref<64x32xf32, #gpu.address_space<workgroup>>
  memref.global "private" @bufferRhsGlobal : memref<8x32xf32, #gpu.address_space<workgroup>>
}
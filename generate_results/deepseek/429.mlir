#gpu_address_space = #gpu.address_space<workgroup>

module {
  func.func @main() -> (vector<4x2xf16>, vector<4x2xf16>) {
    // Main function setup
    %devIndex = arith.constant 0 : i32
    gpu.set_default_device %devIndex

    %dyn_shared_mem = gpu.dynamic_shared_memory : memref<?xi8, #gpu_address_space>

    %c8192 = arith.constant 8192 : index
    %view1 = memref.view %dyn_shared_mem[%c8192][] : memref<?xi8, #gpu_address_space> to memref<32x64xf32, #gpu_address_space>

    %c16384 = arith.constant 16384 : index
    %view2 = memref.view %dyn_shared_mem[%c16384][] : memref<?xi8, #gpu_address_space> to memref<32x64xf32, #gpu_address_space>

    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %width = arith.constant 64 : index
    %memref, %token = gpu.alloc async [%dep] host_shared (%width) : memref<64x?xf32, 1>

    // Prepare arguments for optimize_128x32xf16_32x128xf16
    %arg0 = memref.alloc() : memref<128x128xf16>
    %ldRow = arith.constant 0 : index
    %ldCol = arith.constant 0 : index
    %stRow = arith.constant 0 : index
    %stCol = arith.constant 0 : index
    %fragRow = arith.constant 0 : index
    %fragCol = arith.constant 0 : index

    // Call optimization function
    %mat, %matB = call @optimize_128x32xf16_32x128xf16(
      %arg0, %ldRow, %ldCol, %stRow, %stCol, %fragRow, %fragCol
    ) : (memref<128x128xf16>, index, index, index, index, index, index) 
      -> (vector<4x2xf16>, vector<4x2xf16>)

    return %mat, %matB : vector<4x2xf16>, vector<4x2xf16>
  }

  func.func @optimize_128x32xf16_32x128xf16(
    %arg0: memref<128x128xf16>,
    %ldRow: index, %ldCol: index,
    %stRow: index, %stCol: index,
    %fragRow: index, %fragCol: index
  ) -> (vector<4x2xf16>, vector<4x2xf16>) {
    %shm = memref.alloc() : memref<128x32xf16, 3>
    %shmB = memref.alloc() : memref<32x128xf16, 3>
    %0 = nvgpu.device_async_copy %arg0[%ldRow, %ldCol], %shm[%stRow, %stCol], 8
        : memref<128x128xf16> to memref<128x32xf16, 3>
    %1 = nvgpu.device_async_create_group %0
    nvgpu.device_async_wait %1 { numGroups = 1 : i32}
    %mat = nvgpu.ldmatrix %shm[%fragRow, %fragCol] {numTiles = 4 : i32, transpose = false}
        : memref<128x32xf16, 3> -> vector<4x2xf16>
    %2 = nvgpu.device_async_copy %arg0[%ldRow, %ldCol], %shmB[%stRow, %stCol], 8
        : memref<128x128xf16> to memref<32x128xf16, 3>
    %3 = nvgpu.device_async_create_group %0
    nvgpu.device_async_wait %1 { numGroups = 1 : i32}
    %matB = nvgpu.ldmatrix %shmB[%fragRow, %fragCol] {numTiles = 4 : i32, transpose = false}
        : memref<32x128xf16, 3> -> vector<4x2xf16>
    return %mat, %matB: vector<4x2xf16>, vector<4x2xf16>
  }
}
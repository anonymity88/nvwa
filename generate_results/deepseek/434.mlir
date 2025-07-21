module {
  func.func @main() -> vector<2x2xi32> {
    // Main function operations
    %dim1 = arith.constant 5 : index
    %dim2 = arith.constant 5 : index
    %mem = memref.alloc() : memref<5x5xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %tensor, %token1 = gpu.create_dn_tensor async [%dep1] %mem, %dim1, %dim2 : 
      index, index into memref<5x5xf64>

    %memref = memref.alloc() : memref<8x64xf32, 1>
    %dep2 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %token2 = gpu.dealloc async [%dep2] %memref : memref<8x64xf32, 1>

    %sgSz = gpu.subgroup_size : index

    // Prepare arguments for mma_sp_sync_i8_16864
    %arg0 = arith.constant dense<0> : vector<4x4xi8>
    %arg1 = arith.constant dense<0> : vector<4x4xi8>
    %arg2 = arith.constant dense<0> : vector<2x2xi32>
    %arg3 = arith.constant dense<0> : vector<2xi16>
    
    // Call MMA function
    %result = call @mma_sp_sync_i8_16864(%arg0, %arg1, %arg2, %arg3) : 
      (vector<4x4xi8>, vector<4x4xi8>, vector<2x2xi32>, vector<2xi16>) -> vector<2x2xi32>

    return %result : vector<2x2xi32>
  }

  func.func @mma_sp_sync_i8_16864(
    %arg0: vector<4x4xi8>,
    %arg1: vector<4x4xi8>,
    %arg2: vector<2x2xi32>,
    %arg3: vector<2xi16>
  ) -> vector<2x2xi32> {
    %d = nvgpu.mma.sp.sync(%arg0, %arg1, %arg2) metadata(%arg3) {mmaShape = [16, 8, 64]} :
      (vector<4x4xi8>, vector<4x4xi8>, vector<2x2xi32>) -> vector<2x2xi32>
    return %d : vector<2x2xi32>
  }
}
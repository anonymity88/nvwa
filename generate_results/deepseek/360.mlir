module {
  func.func @create_zero_tile(%arg0: i32, %arg1: i32) -> !llvm.array<256 x i8> {
    %tile = "amx.tilezero"(%arg0, %arg1) : (i32, i32) -> !llvm.array<256 x i8>
    return %tile : !llvm.array<256 x i8>
  }

  func.func @matrix_multiply(%a: vector<16x64xi8>, %b: vector<16x64xi8>, %c: vector<16x16xi32>) -> vector<16x16xi32> {
    %result = amx.tile_muli %a zext, %b zext, %c : vector<16x64xi8>, vector<16x64xi8>, vector<16x16xi32>
    return %result : vector<16x16xi32>
  }

  func.func @tiled_dot_product(%c0: i16, %c1: i16, %c2: i32, %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>) -> vector<4xi32> {
    %result = "amx.tdpbssd"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @kernel1(%arg0: memref<2x4xbf16>,
                    %arg1: memref<2x4xbf16>,
                    %arg2: memref<2x2xf32>) {
    %0 = arith.constant 0 : index
    %1 = amx.tile_load %arg0[%0, %0] : memref<2x4xbf16> into vector<2x4xbf16>
    %2 = amx.tile_load %arg1[%0, %0] : memref<2x4xbf16> into vector<2x4xbf16>
    %3 = amx.tile_zero : vector<2x2xf32>
    %4 = amx.tile_mulf %1, %2, %3 : vector<2x4xbf16>, vector<2x4xbf16>, vector<2x2xf32>
    amx.tile_store %arg2[%0, %0], %4 : memref<2x2xf32>, vector<2x2xf32>
    return
  }

  func.func @main(
      %tile_arg0: i32, %tile_arg1: i32,
      %a: vector<16x64xi8>, %b: vector<16x64xi8>, %c: vector<16x16xi32>,
      %tdp_c0: i16, %tdp_c1: i16, %tdp_c2: i32,
      %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>,
      %mem_in: memref<?x64xi8>, %mem_out: memref<?x?xi8>,
      %idx0: index, %idx1: index,
      %kernel_arg0: memref<2x4xbf16>,
      %kernel_arg1: memref<2x4xbf16>,
      %kernel_arg2: memref<2x2xf32>
  ) -> (vector<16x16xi32>, vector<4xi32>) {
    %zero_tile = call @create_zero_tile(%tile_arg0, %tile_arg1) : (i32, i32) -> !llvm.array<256 x i8>
    
    %loaded_tile = amx.tile_load %mem_in[%idx0, %idx1] : memref<?x64xi8> into vector<16x64xi8>
    
    amx.tile_store %mem_out[%idx0, %idx1], %loaded_tile : memref<?x?xi8>, vector<16x64xi8>
    
    %matmul_result = call @matrix_multiply(%loaded_tile, %b, %c) : 
        (vector<16x64xi8>, vector<16x64xi8>, vector<16x16xi32>) -> vector<16x16xi32>
    
    %tdp_result = call @tiled_dot_product(%tdp_c0, %tdp_c1, %tdp_c2, %vecA, %vecB, %vecC) : 
        (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    
    // Call kernel1 function
    call @kernel1(%kernel_arg0, %kernel_arg1, %kernel_arg2) : (memref<2x4xbf16>, memref<2x4xbf16>, memref<2x2xf32>) -> ()
    
    return %matmul_result, %tdp_result : vector<16x16xi32>, vector<4xi32>
  }
}
module {
  func.func @create_tile(%arg0: i32, %arg1: i32) -> !llvm.array<256 x i8> {
    %tileResult = "amx.tilezero"(%arg0, %arg1) : (i32, i32) -> !llvm.array<256 x i8>
    return %tileResult : !llvm.array<256 x i8>
  }

  func.func @tiled_bus_compute(%c0: i16, %c1: i16, %c2: i32, %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>) -> vector<4xi32> {
    %computeResult = "amx.tdpbusd"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %computeResult : vector<4xi32>
  }

  func.func @store_tile(%memref: memref<?x?xi8>, %row: index, %col: index, %tile: vector<16x64xi8>) {
    amx.tile_store %memref[%row, %col], %tile : memref<?x?xi8>, vector<16x64xi8>
    return
  }

  func.func @kernel(%arg0: memref<16x32xbf16>,
                   %arg1: memref<16x32xbf16>,
                   %arg2: memref<16x16xf32>) {
    %0 = arith.constant 0 : index
    %1 = amx.tile_load %arg0[%0, %0] : memref<16x32xbf16> into vector<16x32xbf16>
    %2 = amx.tile_load %arg1[%0, %0] : memref<16x32xbf16> into vector<16x32xbf16>
    %3 = amx.tile_zero : vector<16x16xf32>
    %4 = amx.tile_mulf %1, %2, %3 : vector<16x32xbf16>, vector<16x32xbf16>, vector<16x16xf32>
    amx.tile_store %arg2[%0, %0], %4 : memref<16x16xf32>, vector<16x16xf32>
    return
  }

  func.func @main(%memref: memref<?x?xi8>, 
                  %row: index, %col: index, 
                  %tileArg0: i32, %tileArg1: i32,
                  %c0TDP: i16, %c1TDP: i16, %c2TDP: i32,
                  %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>,
                  %tileVal: vector<16x64xi8>,
                  %bf16_mem1: memref<16x32xbf16>,
                  %bf16_mem2: memref<16x32xbf16>,
                  %f32_mem: memref<16x16xf32>) -> vector<4xi32> {
    %zeroTile = call @create_tile(%tileArg0, %tileArg1) : (i32, i32) -> !llvm.array<256 x i8>
    
    call @store_tile(%memref, %row, %col, %tileVal) : (memref<?x?xi8>, index, index, vector<16x64xi8>) -> ()
    
    %result = call @tiled_bus_compute(%c0TDP, %c1TDP, %c2TDP, %vecA, %vecB, %vecC) 
              : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    
    call @kernel(%bf16_mem1, %bf16_mem2, %f32_mem) : (memref<16x32xbf16>, memref<16x32xbf16>, memref<16x16xf32>) -> ()
    
    return %result : vector<4xi32>
  }
}
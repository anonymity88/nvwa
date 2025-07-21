module {
  func.func @create_bf16_tile() -> vector<16x16xbf16> {
    %zeroTile = amx.tile_zero : vector<16x16xbf16>
    return %zeroTile : vector<16x16xbf16>
  }

  func.func @load_tile(%arg0: memref<?x64xi8>, %c0: index, %c1: index) -> vector<16x64xi8> {
    %loadedTile = amx.tile_load %arg0[%c0, %c1] : memref<?x64xi8> into vector<16x64xi8>
    return %loadedTile : vector<16x64xi8>
  }

  func.func @tiled_bus_compute(%c0: i16, %c1: i16, %c2: i32, %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>) -> vector<4xi32> {
    %computeResult = "amx.tdpbusd"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %computeResult : vector<4xi32>
  }

  func.func @kernel1(%arg0: memref<16x16xi8>,
                    %arg1: memref<4x16xi8>,
                    %arg2: memref<16x4xi32>) {
    %0 = arith.constant 0 : index
    %1 = amx.tile_load %arg0[%0, %0] : memref<16x16xi8> into vector<16x16xi8>
    %2 = amx.tile_load %arg1[%0, %0] : memref<4x16xi8> into vector<4x16xi8>
    %3 = amx.tile_zero : vector<16x4xi32>
    %4 = amx.tile_muli %1, %2, %3 : vector<16x16xi8>, vector<4x16xi8>, vector<16x4xi32>
    amx.tile_store %arg2[%0, %0], %4 : memref<16x4xi32>, vector<16x4xi32>
    return
  }

  func.func @main(%inputMemref: memref<?x64xi8>, 
                  %c0: index, %c1: index,
                  %busC0: i16, %busC1: i16, %busC2: i32,
                  %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>,
                  %kernelArg0: memref<16x16xi8>,
                  %kernelArg1: memref<4x16xi8>,
                  %kernelArg2: memref<16x4xi32>) 
                  -> (vector<16x64xi8>, vector<16x16xbf16>, vector<4xi32>) {
    %bf16Tile = call @create_bf16_tile() : () -> vector<16x16xbf16>
    
    %loadedTile = call @load_tile(%inputMemref, %c0, %c1) : (memref<?x64xi8>, index, index) -> vector<16x64xi8>
    
    %busResult = call @tiled_bus_compute(%busC0, %busC1, %busC2, %vecA, %vecB, %vecC) 
                 : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    
    // Call kernel1 with additional arguments
    call @kernel1(%kernelArg0, %kernelArg1, %kernelArg2) : (memref<16x16xi8>, memref<4x16xi8>, memref<16x4xi32>) -> ()
    
    return %loadedTile, %bf16Tile, %busResult : vector<16x64xi8>, vector<16x16xbf16>, vector<4xi32>
  }
}
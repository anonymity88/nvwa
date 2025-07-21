module {
  // Function to create a zero-initialized BF16 tile
  func.func @create_bf16_tile() -> vector<16x16xbf16> {
    %zeroTile = amx.tile_zero : vector<16x16xbf16>
    return %zeroTile : vector<16x16xbf16>
  }

  // Function to load a tile from memory
  func.func @load_tile(%arg0: memref<?x64xi8>, %c0: index, %c1: index) -> vector<16x64xi8> {
    %loadedTile = amx.tile_load %arg0[%c0, %c1] : memref<?x64xi8> into vector<16x64xi8>
    return %loadedTile : vector<16x64xi8>
  }

  // Function to perform tiled bus computation
  func.func @tiled_bus_compute(%c0: i16, %c1: i16, %c2: i32, %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>) -> vector<4xi32> {
    %computeResult = "amx.tdpbusd"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %computeResult : vector<4xi32>
  }

  // Main function that combines all operations
  func.func @main(%inputMemref: memref<?x64xi8>, 
                  %c0: index, %c1: index,
                  %busC0: i16, %busC1: i16, %busC2: i32,
                  %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>) 
                  -> (vector<16x64xi8>, vector<16x16xbf16>, vector<4xi32>) {
    // Create a zero BF16 tile
    %bf16Tile = call @create_bf16_tile() : () -> vector<16x16xbf16>
    
    // Load a tile from memory
    %loadedTile = call @load_tile(%inputMemref, %c0, %c1) : (memref<?x64xi8>, index, index) -> vector<16x64xi8>
    
    // Perform tiled bus computation
    %busResult = call @tiled_bus_compute(%busC0, %busC1, %busC2, %vecA, %vecB, %vecC) 
                 : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    
    // Return all results
    return %loadedTile, %bf16Tile, %busResult : vector<16x64xi8>, vector<16x16xbf16>, vector<4xi32>
  }
}
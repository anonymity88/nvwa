module {
  // Function to create a zero-initialized tile
  func.func @create_tile(%arg0: i32, %arg1: i32) -> !llvm.array<256 x i8> {
    %tileResult = "amx.tilezero"(%arg0, %arg1) : (i32, i32) -> !llvm.array<256 x i8>
    return %tileResult : !llvm.array<256 x i8>
  }

  // Function to perform tiled bus computation
  func.func @tiled_bus_compute(%c0: i16, %c1: i16, %c2: i32, %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>) -> vector<4xi32> {
    %computeResult = "amx.tdpbusd"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %computeResult : vector<4xi32>
  }

  // Function to store a tile to memory
  func.func @store_tile(%memref: memref<?x?xi8>, %row: index, %col: index, %tile: vector<16x64xi8>) {
    amx.tile_store %memref[%row, %col], %tile : memref<?x?xi8>, vector<16x64xi8>
    return
  }

  // Main function that orchestrates the operations
  func.func @main(%memref: memref<?x?xi8>, 
                  %row: index, %col: index, 
                  %tileArg0: i32, %tileArg1: i32,
                  %c0TDP: i16, %c1TDP: i16, %c2TDP: i32,
                  %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>,
                  %tileVal: vector<16x64xi8>) -> vector<4xi32> {
    // Create a zero-initialized tile
    %zeroTile = call @create_tile(%tileArg0, %tileArg1) : (i32, i32) -> !llvm.array<256 x i8>
    
    // Store the input tile value to memory
    call @store_tile(%memref, %row, %col, %tileVal) : (memref<?x?xi8>, index, index, vector<16x64xi8>) -> ()
    
    // Perform the tiled bus computation
    %result = call @tiled_bus_compute(%c0TDP, %c1TDP, %c2TDP, %vecA, %vecB, %vecC) 
              : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    
    return %result : vector<4xi32>
  }
}
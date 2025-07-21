module {
  // Function to create a zero-initialized tile
  func.func @create_tile(%arg0: i32, %arg1: i32) -> !llvm.array<256 x i8> {
    %tileResult = "amx.tilezero"(%arg0, %arg1) : (i32, i32) -> !llvm.array<256 x i8>
    return %tileResult : !llvm.array<256 x i8>
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

  // Main function that orchestrates the operations
  func.func @main(
      %memInput: memref<?x64xi8>, 
      %tileRow: index, 
      %tileCol: index,
      %tileConfig0: i32,
      %tileConfig1: i32,
      %busConfig0: i16,
      %busConfig1: i16,
      %busConfig2: i32,
      %vecOperandA: vector<4xi32>,
      %vecOperandB: vector<4xi32>,
      %vecOperandC: vector<4xi32>
  ) -> vector<4xi32> {
    // Create a zero-initialized tile
    %zeroTile = call @create_tile(%tileConfig0, %tileConfig1) : (i32, i32) -> !llvm.array<256 x i8>
    
    // Load a tile from memory
    %loadedTile = call @load_tile(%memInput, %tileRow, %tileCol) : (memref<?x64xi8>, index, index) -> vector<16x64xi8>
    
    // Perform the tiled bus computation
    %busResult = call @tiled_bus_compute(
        %busConfig0, %busConfig1, %busConfig2, 
        %vecOperandA, %vecOperandB, %vecOperandC
    ) : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    
    return %busResult : vector<4xi32>
  }
}
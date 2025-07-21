module {
  // Function to create a zero-initialized tile
  func.func @create_zero_tile(%arg0: i32, %arg1: i32) -> !llvm.array<256 x i8> {
    %tile = "amx.tilezero"(%arg0, %arg1) : (i32, i32) -> !llvm.array<256 x i8>
    return %tile : !llvm.array<256 x i8>
  }

  // Function to perform signed-signed dot product with accumulation
  func.func @tiled_dot_product_ssd(%c0: i16, %c1: i16, %c2: i32, 
                                 %vecA: vector<4xi32>, %vecB: vector<4xi32>, 
                                 %vecC: vector<4xi32>) -> vector<4xi32> {
    %result = "amx.tdpbssd"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : 
              (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %result : vector<4xi32>
  }

  // Function to perform signed-unsigned dot product with accumulation
  func.func @tiled_dot_product_sud(%c0: i16, %c1: i16, %c2: i32, 
                                 %vecA: vector<4xi32>, %vecB: vector<4xi32>, 
                                 %vecC: vector<4xi32>) -> vector<4xi32> {
    %result = "amx.tdpbsud"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : 
              (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %result : vector<4xi32>
  }

  // Main function that orchestrates the tile operations
  func.func @main(%tile_row: i32, %tile_col: i32,
                 %ssd_c0: i16, %ssd_c1: i16, %ssd_c2: i32,
                 %sud_c0: i16, %sud_c1: i16, %sud_c2: i32,
                 %vecA: vector<4xi32>, %vecB: vector<4xi32>, 
                 %vecC: vector<4xi32>) -> (vector<4xi32>, vector<4xi32>) {
    // Create a zero-initialized tile
    %zero_tile = call @create_zero_tile(%tile_row, %tile_col) : 
                (i32, i32) -> !llvm.array<256 x i8>

    // Perform signed-signed dot product
    %ssd_result = call @tiled_dot_product_ssd(%ssd_c0, %ssd_c1, %ssd_c2, 
                                             %vecA, %vecB, %vecC) : 
                 (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>

    // Perform signed-unsigned dot product using the same vectors
    %sud_result = call @tiled_dot_product_sud(%sud_c0, %sud_c1, %sud_c2, 
                                             %vecA, %vecB, %vecC) : 
                 (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>

    // Return both results
    return %ssd_result, %sud_result : vector<4xi32>, vector<4xi32>
  }
}
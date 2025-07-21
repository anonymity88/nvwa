module {
  func.func @create_zero_tile(%arg0: i32, %arg1: i32) -> !llvm.array<256 x i8> {
    %tile = "amx.tilezero"(%arg0, %arg1) : (i32, i32) -> !llvm.array<256 x i8>
    return %tile : !llvm.array<256 x i8>
  }

  func.func @tiled_dot_product_ssd(%c0: i16, %c1: i16, %c2: i32, 
                                 %vecA: vector<4xi32>, %vecB: vector<4xi32>, 
                                 %vecC: vector<4xi32>) -> vector<4xi32> {
    %result = "amx.tdpbssd"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : 
              (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @tiled_dot_product_sud(%c0: i16, %c1: i16, %c2: i32, 
                                 %vecA: vector<4xi32>, %vecB: vector<4xi32>, 
                                 %vecC: vector<4xi32>) -> vector<4xi32> {
    %result = "amx.tdpbsud"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : 
              (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @mulf(%arg0: memref<?x?xbf16>, %arg1: memref<?x?xf32>) {
    %0 = arith.constant 0 : index
    %1 = amx.tile_zero : vector<16x32xbf16>
    %2 = amx.tile_load %arg0[%0, %0] : memref<?x?xbf16> into vector<16x32xbf16>
    %3 = amx.tile_load %arg1[%0, %0] : memref<?x?xf32> into vector<16x16xf32>
    %4 = amx.tile_mulf %1, %2, %3 : vector<16x32xbf16>, vector<16x32xbf16>, vector<16x16xf32>
    amx.tile_store %arg1[%0, %0], %4 : memref<?x?xf32>, vector<16x16xf32>
    return
  }

  func.func @main(%tile_row: i32, %tile_col: i32,
                 %ssd_c0: i16, %ssd_c1: i16, %ssd_c2: i32,
                 %sud_c0: i16, %sud_c1: i16, %sud_c2: i32,
                 %vecA: vector<4xi32>, %vecB: vector<4xi32>, 
                 %vecC: vector<4xi32>,
                 %mulf_arg0: memref<?x?xbf16>, %mulf_arg1: memref<?x?xf32>) -> (vector<4xi32>, vector<4xi32>) {
    %zero_tile = call @create_zero_tile(%tile_row, %tile_col) : 
                (i32, i32) -> !llvm.array<256 x i8>

    %ssd_result = call @tiled_dot_product_ssd(%ssd_c0, %ssd_c1, %ssd_c2, 
                                             %vecA, %vecB, %vecC) : 
                 (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>

    %sud_result = call @tiled_dot_product_sud(%sud_c0, %sud_c1, %sud_c2, 
                                             %vecA, %vecB, %vecC) : 
                 (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>

    call @mulf(%mulf_arg0, %mulf_arg1) : (memref<?x?xbf16>, memref<?x?xf32>) -> ()

    return %ssd_result, %sud_result : vector<4xi32>, vector<4xi32>
  }
}
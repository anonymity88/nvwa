module {
  func.func @vector_extract_element_bf16(%row: index, %col: index) -> bf16 {
    %tile = arm_sme.get_tile : vector<[8]x[8]xbf16>
    %el = vector.extract %tile[%row, %col] : bf16 from vector<[8]x[8]xbf16>
    return %el : bf16
  }

  func.func @arm_sme_store_tile_slice_hor_f16(%tile_slice_index : index, %mask : vector<[8]xi1>, %dest : memref<?x?xf16>) -> () {
    %c0 = arith.constant 0 : index
    %tile = arm_sme.get_tile : vector<[8]x[8]xf16>
    arm_sme.store_tile_slice %tile, %tile_slice_index, %mask, %dest[%c0] : memref<?x?xf16>, vector<[8]xi1>, vector<[8]x[8]xf16>
    return
  }

  func.func @main(%row: index, %col: index, %tile_slice_index: index, %mask: vector<[8]xi1>, %dest: memref<?x?xf16>) -> bf16 {
    %extracted_bf16 = call @vector_extract_element_bf16(%row, %col) : (index, index) -> bf16
    call @arm_sme_store_tile_slice_hor_f16(%tile_slice_index, %mask, %dest) : (index, vector<[8]xi1>, memref<?x?xf16>) -> ()
    return %extracted_bf16 : bf16
  }
}
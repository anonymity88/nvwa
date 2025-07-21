module {
  func.func @arm_sme_copy_tile(%vec: vector<[4]x[4]xf32>) -> vector<[4]x[4]xf32> {
    %result = arm_sme.copy_tile %vec : vector<[4]x[4]xf32>
    return %result : vector<[4]x[4]xf32>
  }
  func.func @arm_sme_extract_tile_slice_i64(%tile_slice_index : index) -> vector<[2]xi64> {
    %tile = arm_sme.get_tile : vector<[2]x[2]xi64>
    %slice = arm_sme.extract_tile_slice %tile[%tile_slice_index] : vector<[2]xi64> from vector<[2]x[2]xi64>
    return %slice : vector<[2]xi64>
  }
  func.func @main(%vec: vector<[4]x[4]xf32>, %tile_slice_index : index) {
    %copied_tile = call @arm_sme_copy_tile(%vec) : (vector<[4]x[4]xf32>) -> vector<[4]x[4]xf32>
    %slice = call @arm_sme_extract_tile_slice_i64(%tile_slice_index) : (index) -> vector<[2]xi64>
    return
  }
}
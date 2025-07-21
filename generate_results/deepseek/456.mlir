module {
  func.func @outerproduct_widening_2way__cant_erase(
      %a0 : vector<[4]xf16>, %b0 : vector<[4]xf16>,
      %a1 : vector<[4]xf16>, %b1 : vector<[4]xf16>) -> vector<[4]x[4]xf32> {
    %a0_ext = arith.extf %a0 : vector<[4]xf16> to vector<[4]xf32>
    %b0_ext = arith.extf %b0 : vector<[4]xf16> to vector<[4]xf32>
    %a1_ext = arith.extf %a1 : vector<[4]xf16> to vector<[4]xf32>
    %b1_ext = arith.extf %b1 : vector<[4]xf16> to vector<[4]xf32>
    %acc = arith.constant dense<1.0> : vector<[4]x[4]xf32>
    %0 = arm_sme.outerproduct %a0_ext, %b0_ext acc(%acc) : vector<[4]xf32>, vector<[4]xf32>
    "test.some_use"(%0) : (vector<[4]x[4]xf32>) -> ()
    %1 = arm_sme.outerproduct %a1_ext, %b1_ext acc(%0) : vector<[4]xf32>, vector<[4]xf32>
    return %1 : vector<[4]x[4]xf32>
  }

  func.func @arm_sme_load_tile_slice_ver_f32(%src : memref<?x?xf32>, %mask : vector<[4]xi1>, %tile_slice_index : index) {
    %c0 = arith.constant 0 : index
    %tile = arm_sme.get_tile : vector<[4]x[4]xf32>
    %tile_update = arm_sme.load_tile_slice %src[%c0], %mask, %tile, %tile_slice_index layout<vertical> : memref<?x?xf32>, vector<[4]xi1>, vector<[4]x[4]xf32>
    "test.some_use" (%tile_update) : (vector<[4]x[4]xf32>) -> ()
    return
  }

  func.func @main(
      %a0 : vector<[4]xf16>, %b0 : vector<[4]xf16>,
      %a1 : vector<[4]xf16>, %b1 : vector<[4]xf16>,
      %src : memref<?x?xf32>, %mask : vector<[4]xi1>, %tile_slice_index : index) {
    %result = call @outerproduct_widening_2way__cant_erase(%a0, %b0, %a1, %b1)
      : (vector<[4]xf16>, vector<[4]xf16>, vector<[4]xf16>, vector<[4]xf16>) -> vector<[4]x[4]xf32>
    call @arm_sme_load_tile_slice_ver_f32(%src, %mask, %tile_slice_index)
      : (memref<?x?xf32>, vector<[4]xi1>, index) -> ()
    return
  }
}
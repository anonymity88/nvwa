module {
  func.func @vector_extract_element_f16(%row: index, %col: index) -> f16 {
    %tile = arm_sme.get_tile : vector<[8]x[8]xf16>
    %el = vector.extract %tile[%row, %col] : f16 from vector<[8]x[8]xf16>
    return %el : f16
  }

  func.func @outerproduct_widening_4way__missing_acc(
      %a0 : vector<[4]xi8>, %b0 : vector<[4]xi8>,
      %a1 : vector<[4]xi8>, %b1 : vector<[4]xi8>,
      %a2 : vector<[4]xi8>, %b2 : vector<[4]xi8>,
      %a3 : vector<[4]xi8>, %b3 : vector<[4]xi8>) -> vector<[4]x[4]xi32> {
    %a0_ext = arith.extsi %a0 : vector<[4]xi8> to vector<[4]xi32>
    %b0_ext = arith.extsi %b0 : vector<[4]xi8> to vector<[4]xi32>
    %a1_ext = arith.extsi %a1 : vector<[4]xi8> to vector<[4]xi32>
    %b1_ext = arith.extsi %b1 : vector<[4]xi8> to vector<[4]xi32>
    %a2_ext = arith.extsi %a2 : vector<[4]xi8> to vector<[4]xi32>
    %b2_ext = arith.extsi %b2 : vector<[4]xi8> to vector<[4]xi32>
    %a3_ext = arith.extsi %a3 : vector<[4]xi8> to vector<[4]xi32>
    %b3_ext = arith.extsi %b3 : vector<[4]xi8> to vector<[4]xi32>
    %0 = arm_sme.outerproduct %a0_ext, %b0_ext : vector<[4]xi32>, vector<[4]xi32>
    %1 = arm_sme.outerproduct %a1_ext, %b1_ext acc(%0) : vector<[4]xi32>, vector<[4]xi32>
    %2 = arm_sme.outerproduct %a2_ext, %b2_ext acc(%1) : vector<[4]xi32>, vector<[4]xi32>
    %3 = arm_sme.outerproduct %a3_ext, %b3_ext : vector<[4]xi32>, vector<[4]xi32>
    "test.some_use"(%2) : (vector<[4]x[4]xi32>) -> ()
    return %3 : vector<[4]x[4]xi32>
  }

  func.func @main(
      %row: index, %col: index,
      %a0 : vector<[4]xi8>, %b0 : vector<[4]xi8>,
      %a1 : vector<[4]xi8>, %b1 : vector<[4]xi8>,
      %a2 : vector<[4]xi8>, %b2 : vector<[4]xi8>,
      %a3 : vector<[4]xi8>, %b3 : vector<[4]xi8>) {
    // Call vector extraction function
    %f16_val = call @vector_extract_element_f16(%row, %col) : (index, index) -> f16
    
    // Call outer product function
    %result = call @outerproduct_widening_4way__missing_acc(
        %a0, %b0, %a1, %b1, %a2, %b2, %a3, %b3) : 
        (vector<[4]xi8>, vector<[4]xi8>, 
         vector<[4]xi8>, vector<[4]xi8>, 
         vector<[4]xi8>, vector<[4]xi8>, 
         vector<[4]xi8>, vector<[4]xi8>) -> vector<[4]x[4]xi32>
    
    return
  }
}
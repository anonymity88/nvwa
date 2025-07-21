module {
  func.func @main(
    %mask: vector<[4]xi1>,
    %src1: vector<[4]xf32>,
    %src2: vector<[4]xf32>,
    %memref: memref<2x?xi1>,
    %p1: vector<[4]xi1>,
    %p2: vector<[8]xi1>,
    %index: index,
    %a: vector<[16]xi8>,
    %b: vector<[16]xi8>,
    %c: vector<[4]xi32>
  ) -> (vector<[4]xf32>, vector<[4]xi1>, vector<2x[16]xi1>, vector<[4]xi32>) {
    // First set of operations
    %masked_sub = arm_sve.masked.subf %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xf32>
    
    %c0 = arith.constant 0 : index
    %loaded_vector = vector.load %memref[%c0, %c0] : memref<2x?xi1>, vector<2x[16]xi1>
    %converted_from_svbool = arm_sve.convert_from_svbool %loaded_vector : vector<2x[16]xi1>
    
    %selected_pred = arm_sve.psel %p1, %p2[%index] : vector<[4]xi1>, vector<[8]xi1>
    
    // Call the udot function
    %dot_result = call @arm_sve_udot(%a, %b, %c) : 
      (vector<[16]xi8>, vector<[16]xi8>, vector<[4]xi32>) -> vector<[4]xi32>
    
    return %masked_sub, %selected_pred, %converted_from_svbool, %dot_result : 
      vector<[4]xf32>, vector<[4]xi1>, vector<2x[16]xi1>, vector<[4]xi32>
  }

  func.func @arm_sve_udot(
    %a: vector<[16]xi8>,
    %b: vector<[16]xi8>,
    %c: vector<[4]xi32>
  ) -> vector<[4]xi32> {
    %0 = arm_sve.udot %c, %a, %b : vector<[16]xi8> to vector<[4]xi32>
    return %0 : vector<[4]xi32>
  }
}
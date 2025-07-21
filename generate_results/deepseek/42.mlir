module {
  func.func @combined_operations(
    %mask: vector<[4]xi1>,
    %src1: vector<[4]xf32>,
    %src2: vector<[4]xf32>,
    %memref: memref<2x?xi1>,
    %p1: vector<[4]xi1>,
    %p2: vector<[8]xi1>,
    %index: index
  ) -> (vector<[4]xf32>, vector<[4]xi1>, vector<2x[16]xi1>) {
    // Perform masked subtraction
    %masked_sub = arm_sve.masked.subf %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xf32>
    
    // Load from memory reference and convert from svbool
    %c0 = arith.constant 0 : index
    %loaded_vector = vector.load %memref[%c0, %c0] : memref<2x?xi1>, vector<2x[16]xi1>
    %converted_from_svbool = arm_sve.convert_from_svbool %loaded_vector : vector<2x[16]xi1>
    
    // Perform predicate selection
    %selected_pred = arm_sve.psel %p1, %p2[%index] : vector<[4]xi1>, vector<[8]xi1>
    
    return %masked_sub, %selected_pred, %converted_from_svbool : 
      vector<[4]xf32>, vector<[4]xi1>, vector<2x[16]xi1>
  }
}
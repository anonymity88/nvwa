module {
  func.func @combined_operations(
    %source: vector<[4]xi1>,
    %memref: memref<2x?xi1>,
    %p1: vector<[4]xi1>,
    %p2: vector<[8]xi1>,
    %index: index
  ) -> (vector<[16]xi1>, vector<[4]xi1>, vector<2x[16]xi1>) {
    // Convert 4-bit vector to 16-bit vector
    %converted_svbool = arm_sve.convert_to_svbool %source : vector<[4]xi1>
    
    // Load from memory reference and convert from svbool
    %c0 = arith.constant 0 : index
    %loaded_vector = vector.load %memref[%c0, %c0] : memref<2x?xi1>, vector<2x[16]xi1>
    %converted_from_svbool = arm_sve.convert_from_svbool %loaded_vector : vector<2x[16]xi1>
    
    // Perform predicate selection
    %selected_pred = arm_sve.psel %p1, %p2[%index] : vector<[4]xi1>, vector<[8]xi1>
    
    return %converted_svbool, %selected_pred, %converted_from_svbool : 
      vector<[16]xi1>, vector<[4]xi1>, vector<2x[16]xi1>
  }
}
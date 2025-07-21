module {
  func.func @combined_operations(
      %mask: vector<[4]xi1>, 
      %src1: vector<[4]xf32>, 
      %src2: vector<[4]xf32>,
      %source: vector<[4]xi1>
  ) -> (vector<[4]xf32>, vector<[4]xf32>, vector<[16]xi1>) {
    // Perform masked subtraction
    %result_sub = arm_sve.masked.subf %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xf32>
    
    // Perform masked addition
    %result_add = arm_sve.masked.addf %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xf32>
    
    // Convert 4-bit vector to 16-bit vector
    %result_convert = arm_sve.convert_to_svbool %source : vector<[4]xi1>
    
    return %result_sub, %result_add, %result_convert : vector<[4]xf32>, vector<[4]xf32>, vector<[16]xi1>
  }
}
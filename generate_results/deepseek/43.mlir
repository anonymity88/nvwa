module {
  func.func @combined_masked_operations(
    %mask_i32: vector<[4]xi1>,
    %src1_i32: vector<[4]xi32>,
    %src2_i32: vector<[4]xi32>,
    %mask_f32: vector<[4]xi1>,
    %src1_f32: vector<[4]xf32>,
    %src2_f32: vector<[4]xf32>
  ) -> (vector<[4]xi32>, vector<[4]xi32>, vector<[4]xf32>) {
    // Masked integer addition
    %add_result = arm_sve.masked.addi %mask_i32, %src1_i32, %src2_i32 : vector<[4]xi1>, vector<[4]xi32>
    
    // Masked integer division (signed)
    %div_result = arm_sve.masked.divi_signed %mask_i32, %src1_i32, %src2_i32 : vector<[4]xi1>, vector<[4]xi32>
    
    // Masked floating-point multiplication
    %mul_result = arm_sve.masked.mulf %mask_f32, %src1_f32, %src2_f32 : vector<[4]xi1>, vector<[4]xf32>
    
    return %add_result, %div_result, %mul_result : 
      vector<[4]xi32>, vector<[4]xi32>, vector<[4]xf32>
  }
}
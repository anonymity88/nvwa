module {
  func.func @combined_operations(
      %mask_i32: vector<[4]xi1>, %src1_i32: vector<[4]xi32>, %src2_i32: vector<[4]xi32>,
      %mask_f32: vector<[4]xi1>, %src1_f32: vector<[4]xf32>, %src2_f32: vector<[4]xf32>
  ) -> (vector<[4]xi32>, vector<[4]xf32>, vector<[4]xi32>) {
    // Signed division of integers with mask
    %result_divi = arm_sve.masked.divi_signed %mask_i32, %src1_i32, %src2_i32 : vector<[4]xi1>, vector<[4]xi32>
    
    // Subtraction of floats with mask
    %result_subf = arm_sve.masked.subf %mask_f32, %src1_f32, %src2_f32 : vector<[4]xi1>, vector<[4]xf32>
    
    // Addition of integers with mask
    %result_addi = arm_sve.masked.addi %mask_i32, %src1_i32, %src2_i32 : vector<[4]xi1>, vector<[4]xi32>
    
    return %result_divi, %result_subf, %result_addi : vector<[4]xi32>, vector<[4]xf32>, vector<[4]xi32>
  }
}
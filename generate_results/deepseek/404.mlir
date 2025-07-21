module {
  func.func @main(
    %mask_div: vector<[4]xi1>,
    %src1_div: vector<[4]xi32>,
    %src2_div: vector<[4]xi32>,
    %mask_mul: vector<[4]xi1>,
    %src1_mul: vector<[4]xi32>,
    %src2_mul: vector<[4]xi32>,
    %source: vector<[4]xi1>,
    %a: vector<[8]xi16>,
    %b: vector<[8]xi16>
  ) -> (vector<[4]xi32>, vector<[4]xi32>, vector<[16]xi1>, vector<[8]xi16>, vector<[8]xi16>) {
    // Original operations from combined_operations
    %div_result = "arm_sve.masked.divi_unsigned"(%mask_div, %src1_div, %src2_div) : 
      (vector<[4]xi1>, vector<[4]xi32>, vector<[4]xi32>) -> vector<[4]xi32>
    
    %mul_result = arm_sve.masked.muli %mask_mul, %src1_mul, %src2_mul : 
      vector<[4]xi1>, vector<[4]xi32>
    
    %converted_svbool = arm_sve.convert_to_svbool %source : vector<[4]xi1>
    
    // Call the zip.x2 function
    %zip_result0, %zip_result1 = call @arm_sve_zip_x2(%a, %b) : 
      (vector<[8]xi16>, vector<[8]xi16>) -> (vector<[8]xi16>, vector<[8]xi16>)
    
    return %div_result, %mul_result, %converted_svbool, %zip_result0, %zip_result1 : 
      vector<[4]xi32>, vector<[4]xi32>, vector<[16]xi1>, vector<[8]xi16>, vector<[8]xi16>
  }
  
  func.func @arm_sve_zip_x2(
    %a: vector<[8]xi16>,
    %b: vector<[8]xi16>
  ) -> (vector<[8]xi16>, vector<[8]xi16>) {
    %0, %1 = arm_sve.zip.x2 %a, %b : vector<[8]xi16>
    return %0, %1 : vector<[8]xi16>, vector<[8]xi16>
  }
}
module {
  func.func @main(
    %mask: vector<[4]xi1>,
    %src1: vector<[4]xi32>,
    %src2: vector<[4]xi32>,
    %sourceV1: vector<[16]xi8>,
    %sourceV2: vector<[16]xi8>,
    %c: vector<[4]xi32>
  ) -> (vector<[4]xi32>, vector<[4]xi32>, vector<[16]xi8>, vector<[16]xi8>, vector<[4]xi32>) {
    // Original operations from combined_operations
    %result_div = arm_sve.masked.divi_signed %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xi32>
    %result_add = arm_sve.masked.addi %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xi32>
    %resultV1, %resultV2 = arm_sve.zip.x2 %sourceV1, %sourceV2 : vector<[16]xi8>
    
    // Call the ummla function
    %ummla_result = call @arm_sve_ummla(%sourceV1, %sourceV2, %c) : 
      (vector<[16]xi8>, vector<[16]xi8>, vector<[4]xi32>) -> vector<[4]xi32>
    
    return %result_div, %result_add, %resultV1, %resultV2, %ummla_result : 
      vector<[4]xi32>, vector<[4]xi32>, vector<[16]xi8>, vector<[16]xi8>, vector<[4]xi32>
  }
  
  func.func @arm_sve_ummla(
    %a: vector<[16]xi8>,
    %b: vector<[16]xi8>,
    %c: vector<[4]xi32>
  ) -> vector<[4]xi32> {
    %0 = arm_sve.ummla %c, %a, %b : vector<[16]xi8> to vector<[4]xi32>
    return %0 : vector<[4]xi32>
  }
}
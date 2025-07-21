module {
  func.func @combined_operations(
      %mask: vector<[4]xi1>,
      %src1: vector<[4]xi32>,
      %src2: vector<[4]xi32>,
      %sourceV1: vector<[16]xi8>,
      %sourceV2: vector<[16]xi8>
  ) -> (vector<[4]xi32>, vector<[4]xi32>, vector<[16]xi8>, vector<[16]xi8>) {
    // Perform masked signed division
    %result_div = arm_sve.masked.divi_signed %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xi32>
    
    // Perform masked addition
    %result_add = arm_sve.masked.addi %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xi32>
    
    // Perform zip operation on two 16-bit vectors
    %resultV1, %resultV2 = arm_sve.zip.x2 %sourceV1, %sourceV2 : vector<[16]xi8>
    
    return %result_div, %result_add, %resultV1, %resultV2 : 
      vector<[4]xi32>, vector<[4]xi32>, vector<[16]xi8>, vector<[16]xi8>
  }
}
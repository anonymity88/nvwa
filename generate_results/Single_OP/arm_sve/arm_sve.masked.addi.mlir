module {
  func.func @main(%mask: vector<[4]xi1>, %src1: vector<[4]xi32>, %src2: vector<[4]xi32>) -> vector<[4]xi32> {
    %result = arm_sve.masked.addi %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xi32>
    return %result : vector<[4]xi32>
  }
}
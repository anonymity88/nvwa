module {
  func.func @main(%mask: vector<[4]xi1>, %src1: vector<[4]xf32>, %src2: vector<[4]xf32>) -> vector<[4]xf32> {
    %result = arm_sve.masked.addf %mask, %src1, %src2 : vector<[4]xi1>, vector<[4]xf32>
    return %result : vector<[4]xf32>
  }
}
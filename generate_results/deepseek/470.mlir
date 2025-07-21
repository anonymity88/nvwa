module {
  func.func @arm_sme_sumopa_4way_i16i16_to_i64(%vecA: vector<[8]xi16>, %vecB: vector<[8]xi16>) -> vector<[2]x[2]xi64> {
    %result = arm_sme.sumopa_4way %vecA, %vecB : vector<[8]xi16>, vector<[8]xi16> into vector<[2]x[2]xi64>
    return %result : vector<[2]x[2]xi64>
  }
  func.func @arm_sme_fmopa_2way_with_everything(%vecA: vector<[8]xf16>, %vecB: vector<[8]xf16>, %acc : vector<[4]x[4]xf32>, %maskA: vector<[8]xi1>, %maskB: vector<[8]xi1>) -> vector<[4]x[4]xf32> {
    %result = arm_sme.fmopa_2way %vecA, %vecB acc(%acc) masks(%maskA, %maskB) : vector<[8]xf16>, vector<[8]xf16> into vector<[4]x[4]xf32>
    return %result : vector<[4]x[4]xf32>
  }
  func.func @main(%vecA_i16: vector<[8]xi16>, %vecB_i16: vector<[8]xi16>, %vecA_f16: vector<[8]xf16>, %vecB_f16: vector<[8]xf16>, %acc: vector<[4]x[4]xf32>, %maskA: vector<[8]xi1>, %maskB: vector<[8]xi1>) {
    %sumopa_result = call @arm_sme_sumopa_4way_i16i16_to_i64(%vecA_i16, %vecB_i16) : (vector<[8]xi16>, vector<[8]xi16>) -> vector<[2]x[2]xi64>
    %fmopa_result = call @arm_sme_fmopa_2way_with_everything(%vecA_f16, %vecB_f16, %acc, %maskA, %maskB) : (vector<[8]xf16>, vector<[8]xf16>, vector<[4]x[4]xf32>, vector<[8]xi1>, vector<[8]xi1>) -> vector<[4]x[4]xf32>
    return
  }
}
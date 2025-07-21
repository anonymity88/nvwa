module {
  func.func @main(%source: vector<[4]xi1>) -> vector<[16]xi1> {
    // Convert SVE predicate type to svbool type
    %result = arm_sve.convert_to_svbool %source : vector<[4]xi1>
    return %result : vector<[16]xi1>
  }
}
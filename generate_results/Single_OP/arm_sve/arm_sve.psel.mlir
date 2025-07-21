module {
  func.func @main(%p1: vector<[4]xi1>, %p2: vector<[8]xi1>, %index: index) -> vector<[4]xi1> {
    %result = arm_sve.psel %p1, %p2[%index] : vector<[4]xi1>, vector<[8]xi1>
    return %result : vector<[4]xi1>
  }
}
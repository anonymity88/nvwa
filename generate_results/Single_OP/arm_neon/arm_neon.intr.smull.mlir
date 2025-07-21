module {
  func.func @main(%arg0: vector<4xi16>, %arg1: vector<4xi16>) -> vector<4xi32> {
    %result = arm_neon.intr.smull %arg0, %arg1 : vector<4xi16> to vector<4xi32>
    return %result : vector<4xi32>
  }
}
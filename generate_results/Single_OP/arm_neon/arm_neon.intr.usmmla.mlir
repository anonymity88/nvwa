module {
  func.func @main(%arg0: vector<4xi32>, %arg1: vector<16xi8>, %arg2: vector<16xi8>) -> vector<4xi32> {
    %result = arm_neon.intr.usmmla %arg0, %arg1, %arg2 : vector<16xi8> to vector<4xi32>
    return %result : vector<4xi32>
  }
}
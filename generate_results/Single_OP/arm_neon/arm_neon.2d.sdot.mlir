module {
  func.func @main(%arg0: vector<2xi32>, %arg1: vector<2x4xi8>, %arg2: vector<2x4xi8>) -> vector<2xi32> {
    %result = arm_neon.2d.sdot %arg0, %arg1, %arg2 : vector<2x4xi8>, vector<2x4xi8> to vector<2xi32>
    return %result : vector<2xi32>
  }
}
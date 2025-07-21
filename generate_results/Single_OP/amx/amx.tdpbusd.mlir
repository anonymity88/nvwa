module {
  func.func @main(%c0: i16, %c1: i16, %c2: i32, %vecA: vector<4xi32>, %vecB: vector<4xi32>, %vecC: vector<4xi32>) -> vector<4xi32> {
    %0 = "amx.tdpbusd"(%c0, %c1, %c2, %vecA, %vecB, %vecC) : (i16, i16, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
    return %0 : vector<4xi32>
  }
}
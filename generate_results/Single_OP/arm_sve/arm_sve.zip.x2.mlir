module {
  func.func @main(%sourceV1: vector<[16]xi8>, %sourceV2: vector<[16]xi8>) -> (vector<[16]xi8>, vector<[16]xi8>) {
    %resultV1, %resultV2 = arm_sve.zip.x2 %sourceV1, %sourceV2 : vector<[16]xi8>
    return %resultV1, %resultV2 : vector<[16]xi8>, vector<[16]xi8>
  }
}
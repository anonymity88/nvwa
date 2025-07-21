module {
  func.func @main(%sourceV1: vector<[16]xi8>, %sourceV2: vector<[16]xi8>, %sourceV3: vector<[16]xi8>, %sourceV4: vector<[16]xi8>) -> (vector<[16]xi8>, vector<[16]xi8>, vector<[16]xi8>, vector<[16]xi8>) {
    %resultV1, %resultV2, %resultV3, %resultV4 = arm_sve.zip.x4 %sourceV1, %sourceV2, %sourceV3, %sourceV4 : vector<[16]xi8>
    return %resultV1, %resultV2, %resultV3, %resultV4 : vector<[16]xi8>, vector<[16]xi8>, vector<[16]xi8>, vector<[16]xi8>
  }
}
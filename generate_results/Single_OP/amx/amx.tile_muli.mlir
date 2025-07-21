module {
  func.func @main(%a: vector<16x64xi8>, %b: vector<16x64xi8>, %c: vector<16x16xi32>) -> vector<16x16xi32> {
    %0 = amx.tile_muli %a zext, %b zext, %c : vector<16x64xi8>, vector<16x64xi8>, vector<16x16xi32>
    return %0 : vector<16x16xi32>
  }
}
module {
  func.func @main(%arg0: memref<?x64xi8>, %c0: index, %c1: index) -> vector<16x64xi8> {
    %0 = amx.tile_load %arg0[%c0, %c1] : memref<?x64xi8> into vector<16x64xi8>
    return %0 : vector<16x64xi8>
  }
}
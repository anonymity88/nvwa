module {
  func.func @main(%arg1: memref<?x?xi8>, %c0: index, %c1: index, %tileVal: vector<16x64xi8>) {
    amx.tile_store %arg1[%c0, %c1], %tileVal : memref<?x?xi8>, vector<16x64xi8>
    return
  }
}
module {
  func.func @main() -> vector<16x16xbf16> {
    %0 = amx.tile_zero : vector<16x16xbf16>
    return %0 : vector<16x16xbf16>
  }
}
#map = affine_map<(d0, d1) -> (1000, d0 + 512)>

module {
  func.func @main(%arg0: index, %arg1: index) -> (index) {
    // Compute the minimum using affine.min on the given SSA values
    %0 = affine.min #map(%arg0, %arg1)

    return %0 : index
  }
}
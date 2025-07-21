#map = affine_map<(d0) -> (1000, d0 + 512)>

module {
  func.func @main() -> () {
    // Define a loop index as an integer constant and cast it to index type
    %c0 = arith.constant 0 : i32
    %i = arith.index_cast %c0 : i32 to index

    // Correctly compute the maximum value using the affine.max operation with the affine map
    %maxVal = affine.max #map(%i)

    return
  }
}
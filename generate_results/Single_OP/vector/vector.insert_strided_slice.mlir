module {
  // Define any affine maps if needed
  // #map = affine_map<(d0, d1) -> (d0, d1)>

  func.func @main() {
    // Allocate a destination vector of shape [16, 4, 8]
    %dest = arith.constant dense<0.0> : vector<16x4x8xf32>

    // Define a source vector with shape [2, 4]
    %source = arith.constant dense<[[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0]]> : vector<2x4xf32>

    // Insert the source vector into the destination vector with specified offsets and strides
    %result = vector.insert_strided_slice %source, %dest
      {offsets = [0, 0, 2], strides = [1, 1]}: vector<2x4xf32> into vector<16x4x8xf32>

    return
  }
}
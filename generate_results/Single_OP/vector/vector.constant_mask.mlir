module {
  // Create a constant vector mask of size 4x3xi1 with specified mask dimensions
  func.func @main() {
    // Create the constant mask with dimensions [3, 2]
    %mask = vector.constant_mask [3, 2] : vector<4x3xi1>

    return
  }
}
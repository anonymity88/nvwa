module {
  func.func @main() {
    // Define constants for the dimensions of the mask
    %c4 = arith.constant 4 : index
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index

    // Create a vector mask of size 4x3xi1 where elements in the specified range are set to 1
    %mask = vector.create_mask %c3, %c2 : vector<4x3xi1>

    return
  }
}
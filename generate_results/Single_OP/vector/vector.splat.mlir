module {
  func.func @main() {
    // Define a scalar value of type f32
    %s = arith.constant 10.1 : f32

    // Broadcast the scalar value to a vector with dimensions 8x16 and of type f32
    %t = vector.splat %s : vector<8x16xf32>

    return
  }
}
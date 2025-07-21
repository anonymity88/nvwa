module {
  func.func @main() {
    // Define a scalar value to be broadcasted
    %scalar = arith.constant 1.0 : f32

    // Broadcast the scalar to a vector of shape <16>
    %broadcasted_vector_1 = vector.broadcast %scalar : f32 to vector<16xf32>

    // Further broadcast the first broadcasted vector to a higher dimensional vector of shape <4x16>
    %broadcasted_vector_2 = vector.broadcast %broadcasted_vector_1 : vector<16xf32> to vector<4x16xf32>

    return
  }
}
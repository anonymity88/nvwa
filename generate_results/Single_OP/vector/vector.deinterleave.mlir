module {
  func.func @main() {
    // Define a vector with interleaved elements
    %input_vector = arith.constant dense<[1, 2, 3, 4, 5, 6, 7, 8]> : vector<8xi32>

    // Deinterleave the input vector into two vectors
    %even_elements, %odd_elements = vector.deinterleave %input_vector : vector<8xi32> -> vector<4xi32>

    return
  }
}
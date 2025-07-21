module {
  func.func @main() {
    // Define the first input vector
    %a = arith.constant dense<[0, 1]> : vector<2xi32>

    // Define the second input vector
    %b = arith.constant dense<[2, 3]> : vector<2xi32>

    // Interleave the two vectors
    %0 = vector.interleave %a, %b : vector<2xi32> -> vector<4xi32>

    return
  }
}
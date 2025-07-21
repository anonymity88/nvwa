module {
  func.func @main() {
    // Create a constant dense vector
    %v = arith.constant dense<[0.0, 0.0, 0.0, 0.0]> : vector<4xf32>

    // Print the vector to stdout
    vector.print %v : vector<4xf32>

    // Optionally, print a string
    vector.print str "Hello, World!" : vector<1xi1>

    return
  }
}
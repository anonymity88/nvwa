module {
  func.func @main() {
    // Allocate a memref for holding scalar data
    %base = memref.alloc() : memref<32xf32>

    // Define the index to load the vector from the memref
    %i = arith.constant 0 : index

    // Define the mask vector, indicating which elements should be loaded from memory
    %mask = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>

    // Define the pass-through vector for elements not loaded from memory
    %pass_thru = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>

    // Perform the vector masked load operation
    %result = vector.maskedload %base[%i], %mask, %pass_thru 
      : memref<32xf32>, vector<8xi1>, vector<8xf32> into vector<8xf32>

    return
  }
}
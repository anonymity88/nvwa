module {
  func.func @main() {
    // Allocate a memref for holding data
    %base = memref.alloc() : memref<16x16xf32>

    // Define the indices to gather from the base memref
    %i = arith.constant 0 : index
    %j = arith.constant 0 : index

    // Define the index vector for gathering
    %index_vec = arith.constant dense<[0, 1, 2, 3]> : vector<4xi32>

    // Define the mask vector, indicating which elements should be gathered
    %mask = arith.constant dense<[1, 0, 1, 1]> : vector<4xi1>

    // Define the pass-through vector for elements not gathered from memory
    %pass_thru = arith.constant dense<[10.0, 20.0, 30.0, 40.0]> : vector<4xf32>

    // Perform the gather operation
    %result = vector.gather %base[%i, %j][%index_vec], %mask, %pass_thru 
      : memref<16x16xf32>, vector<4xi32>, vector<4xi1>, vector<4xf32> into vector<4xf32>

    return
  }
}
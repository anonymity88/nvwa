module {
  func.func @main() {
    // Allocate a memref for holding 2-D scalar data
    %base = memref.alloc() : memref<200x100xf32>

    // Define the index to store the vector into the memref
    %i = arith.constant 0 : index
    %j = arith.constant 0 : index

    // Define the vector value to be stored into memory with shape [4, 2]
    %valueToStore = arith.constant dense<[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]> : vector<4x2xf32>

    // Perform the vector store operation
    vector.store %valueToStore, %base[%i, %j] : memref<200x100xf32>, vector<4x2xf32>

    return
  }
}
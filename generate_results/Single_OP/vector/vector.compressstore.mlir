module {
  func.func @main() {
    // Allocate a memref for storing vector elements
    %base = memref.alloc() : memref<16xf32>

    // Define the index to store the vector into the memref
    %i = arith.constant 0 : index

    // Define the mask vector, indicating which elements should actually be stored
    %mask = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>

    // Define the vector data to be stored into memory
    %valueToStore = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>

    // Perform the compress store operation
    vector.compressstore %base[%i], %mask, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    return
  }
}
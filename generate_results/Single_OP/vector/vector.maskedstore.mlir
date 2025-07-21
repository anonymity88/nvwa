module {
  func.func @main() {
    // Allocate a memref for storing vector elements
    %base = memref.alloc() : memref<16xf32>

    // Define the index for the base memory reference
    %i = arith.constant 0 : index

    // Define the mask vector, indicating which elements should actually be stored
    %mask = arith.constant dense<[1, 0, 1, 0, 1, 0, 1, 0]> : vector<8xi1>

    // Define the vector data to be stored into memory
    %valueToStore = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]> : vector<8xf32>

    // Perform the masked store operation
    vector.maskedstore %base[%i], %mask, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    return
  }
}
module {
  func.func @main() {
    // Allocate a memref for holding values
    %base = memref.alloc() : memref<32xf32>
    
    // Define constant index values for scattering
    %i0 = arith.constant 0 : index
    %i1 = arith.constant 2 : index
    %i2 = arith.constant 4 : index
    %i3 = arith.constant 6 : index
    %i4 = arith.constant 8 : index

    // Define a vector of indices to scatter
    %index_vec = arith.constant dense<[1, 3, 5, 7, 9]> : vector<5xi32>

    // Define the mask vector, indicating which elements should actually be stored
    %mask = arith.constant dense<[1, 0, 1, 1, 0]> : vector<5xi1>

    // Define the vector data to be stored into memory
    %valueToStore = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0]> : vector<5xf32>

    // Perform the scatter operation using the individual index values
    vector.scatter %base[%i0][%index_vec], %mask, %valueToStore 
      : memref<32xf32>, vector<5xi32>, vector<5xi1>, vector<5xf32>

    return
  }
}
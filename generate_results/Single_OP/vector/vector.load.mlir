module {
  func.func @main() {
    // Allocate a memref for holding scalar 2-D data
    %base = memref.alloc() : memref<200x100xf32>

    // Define the indices to load the vector from the memref
    %i = arith.constant 5 : index
    %j = arith.constant 10 : index

    // Load a 2-D vector from the base memref
    %result = vector.load %base[%i, %j] : memref<200x100xf32>, vector<4x8xf32>

    return
  }
}
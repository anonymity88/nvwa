module {
  func.func @main() {
    // Allocate a memref with scalar elements
    %A = memref.alloc() : memref<5x4x3xf32>

    // Perform the vector type cast operation
    // Convert the scalar memref to a memref representing a single vector element
    %VA = vector.type_cast %A : memref<5x4x3xf32> to memref<vector<5x4x3xf32>>

    return
  }
}
#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main() -> () {
    %0 = memref.alloca() : memref<100x100xf32>
    
    // Define a scalar value to be stored and cast it to a vector
    %scalar_value = arith.constant 0.0 : f32
    %v0 = vector.broadcast %scalar_value : f32 to vector<8xf32> // Broadcast a scalar f32 to a vector<8xf32>

    // Initialize loop indices as constant integers
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32

    // Cast the constants to the index type
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index

    // Perform the affine vector store
    affine.vector_store %v0, %0[%i0 + 3, %i1 + 7] : memref<100x100xf32>, vector<8xf32>

    return
  }
}
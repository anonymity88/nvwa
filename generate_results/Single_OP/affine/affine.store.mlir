#map = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>

module {
  func.func @main() -> () {
    // Allocate a memref to store data
    %memref = memref.alloca() : memref<100x100xf32>
    
    // Create a constant value to store
    %v0 = arith.constant 1.0 : f32
    
    // Initialize loop indices as constant integers
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32

    // Cast the constants to the index type
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index

    // Perform the affine store
    affine.store %v0, %memref[%i0 + 3, %i1 + 7] : memref<100x100xf32>

    return
  }
}
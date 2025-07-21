#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main() -> () {
    %0 = memref.alloca() : memref<400x400xi32>

    // Initialize loop indices as constant integers
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32

    // Cast the constants to the index type
    %i = arith.index_cast %c0 : i32 to index
    %j = arith.index_cast %c1 : i32 to index

    // Perform the affine prefetch without storing the result
    affine.prefetch %0[%i, %j + 5], read, locality<3>, data : memref<400x400xi32>

    return
  }
}
#map = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>

module {
  func.func @main() -> () {
    %0 = memref.alloca() : memref<100x100xf32>
    
    // Initialize loop indices as constant integers
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32

    // Cast the constants to the index type
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index

    // Perform the affine load
    %1 = affine.load %0[%i0 + 3, %i1 + 7] : memref<100x100xf32>

    return
  }
}
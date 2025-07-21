#map0 = affine_map<()[s0] -> (s0 floordiv 50176)>
#map1 = affine_map<()[s0] -> ((s0 mod 50176) floordiv 224)>
#map2 = affine_map<()[s0] -> (s0 mod 224)>
#map_store = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main() -> () {
    // Delinearize index operation
    %linear_index = arith.constant 100000 : index
    %c16 = arith.constant 16 : index
    %c224 = arith.constant 224 : index
    %indices:3 = affine.delinearize_index %linear_index into (%c16, %c224, %c224) : index, index, index

    // Allocate memory and initialize with affine.for
    %buffer = memref.alloca() : memref<10xi32>
    %value = arith.constant 42 : i32
    affine.for %i = 0 to 10 {
      affine.store %value, %buffer[%i] : memref<10xi32>
      affine.yield
    }

    // Vector store operation
    %0 = memref.alloca() : memref<100x100xf32>
    %scalar_value = arith.constant 0.0 : f32
    %v0 = vector.broadcast %scalar_value : f32 to vector<8xf32>
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index
    affine.vector_store %v0, %0[%i0 + 3, %i1 + 7] : memref<100x100xf32>, vector<8xf32>

    return
  }
}
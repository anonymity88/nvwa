#map0 = affine_map<()[s0] -> (s0 floordiv 50176)>
#map1 = affine_map<()[s0] -> ((s0 mod 50176) floordiv 224)>
#map2 = affine_map<()[s0] -> (s0 mod 224)>
#map_store = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main() -> () {
    %linear_index = arith.constant 100000 : index
    %c16 = arith.constant 16 : index
    %c224 = arith.constant 224 : index
    %indices:3 = affine.delinearize_index %linear_index into (%c16, %c224, %c224) : index, index, index

    %buffer = memref.alloca() : memref<10xi32>
    %value = arith.constant 42 : i32
    affine.for %i = 0 to 10 {
      affine.store %value, %buffer[%i] : memref<10xi32>
      affine.yield
    }

    %0 = memref.alloca() : memref<100x100xf32>
    %scalar_value = arith.constant 0.0 : f32
    %v0 = vector.broadcast %scalar_value : f32 to vector<8xf32>
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index
    affine.vector_store %v0, %0[%i0 + 3, %i1 + 7] : memref<100x100xf32>, vector<8xf32>

    // Create properly sized memref for vec2d_imperfectly_nested call
    %d0 = arith.constant 10 : index
    %d1 = arith.constant 10 : index
    %d2 = arith.constant 10 : index
    %dummy_memref = memref.alloc(%d0, %d1, %d2) : memref<?x?x?xf32>
    call @vec2d_imperfectly_nested(%dummy_memref) : (memref<?x?x?xf32>) -> ()
    memref.dealloc %dummy_memref : memref<?x?x?xf32>

    return
  }

  func.func @vec2d_imperfectly_nested(%A : memref<?x?x?xf32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %0 = memref.dim %A, %c0 : memref<?x?x?xf32>
    %1 = memref.dim %A, %c1 : memref<?x?x?xf32>
    %2 = memref.dim %A, %c2 : memref<?x?x?xf32>
    affine.for %i0 = 0 to %0 {
      affine.for %i1 = 0 to %1 {
        affine.for %i2 = 0 to %2 {
          %a2 = affine.load %A[%i2, %i1, %i0] : memref<?x?x?xf32>
        }
      }
      affine.for %i3 = 0 to %1 {
        affine.for %i4 = 0 to %2 {
          %a4 = affine.load %A[%i3, %i4, %i0] : memref<?x?x?xf32>
        }
        affine.for %i5 = 0 to %2 {
          %a5 = affine.load %A[%i3, %i5, %i0] : memref<?x?x?xf32>
        }
      }
    }
    return
  }
}
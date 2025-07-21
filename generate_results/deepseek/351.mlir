#map_store = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>
#map_vector = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>

module {
  func.func @main() -> () {
    %memref = memref.alloca() : memref<100x100xf32>
    %vector_memref = memref.alloca() : memref<100x100xf32>
    %buffer = memref.alloca() : memref<10xi32>
    
    %v0 = arith.constant 1.0 : f32
    %scalar_value = arith.constant 0.0 : f32
    %value = arith.constant 42 : i32
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index
    
    affine.store %v0, %memref[%i0 + 3, %i1 + 7] : memref<100x100xf32>
    
    %broadcast_vec = vector.broadcast %scalar_value : f32 to vector<8xf32>
    affine.vector_store %broadcast_vec, %vector_memref[%i0 + 3, %i1 + 7] : memref<100x100xf32>, vector<8xf32>
    
    affine.for %i = 0 to 10 {
      %loop_buffer = memref.alloca() : memref<10xi32>
      affine.store %value, %loop_buffer[%i] : memref<10xi32>
      affine.yield
    }
    
    %loaded_val = affine.load %buffer[%i0] : memref<10xi32>
    %sum = arith.addi %loaded_val, %value : i32
    affine.store %sum, %buffer[%i1] : memref<10xi32>
    
    // Call the invariant_affine_for_inside_affine_if function
    call @invariant_affine_for_inside_affine_if() : () -> ()
    
    return
  }

  func.func @invariant_affine_for_inside_affine_if() {
    %m = memref.alloc() : memref<10xf32>
    %cf8 = arith.constant 8.0 : f32
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
        affine.if affine_set<(d0, d1) : (d1 - d0 >= 0)> (%arg0, %arg0) {
            %cf9 = arith.addf %cf8, %cf8 : f32
            affine.store %cf9, %m[%arg0] : memref<10xf32>
            affine.for %arg2 = 0 to 10 {
              affine.store %cf9, %m[%arg2] : memref<10xf32>
            }
        }
      }
    }
    return
  }
}
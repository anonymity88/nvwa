#map_store = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>
#map_max = affine_map<(d0) -> (1000, d0 + 512)>
#map_lower = affine_map<(d0) -> (d0)>
#map_upper = affine_map<(d0) -> (d0)>

module {
  func.func @main() -> (f32) {
    %memref = memref.alloca() : memref<100x100xf32>
    %buffer = memref.alloca() : memref<1024xf32>
    
    %v0 = arith.constant 1.0 : f32
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %c10 = arith.constant 10 : index
    %sum_0 = arith.constant 0.0 : f32
    
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index
    %max_i = arith.index_cast %c0 : i32 to index
    
    %maxVal = affine.max #map_max(%max_i)
    affine.store %v0, %memref[%i0 + 3, %i1 + 7] : memref<100x100xf32>
    
    %final_sum = affine.for %i = 0 to %c10 iter_args(%sum_iter = %sum_0) -> (f32) {
      %t = affine.load %buffer[%i] : memref<1024xf32>
      %sum_next = arith.addf %sum_iter, %t : f32
      affine.yield %sum_next : f32
    }
    
    // Call the merge_mixed_uses_of_affine_max_ops function with some indices
    %idx0 = arith.constant 5 : index
    %idx1 = arith.constant 10 : index
    %result_idx = call @merge_mixed_uses_of_affine_max_ops(%idx0, %idx1) : (index, index) -> index
    
    return %final_sum : f32
  }

  func.func @merge_mixed_uses_of_affine_max_ops(%i0: index, %i1: index) -> index {
    %0 = affine.max affine_map<()[s0] -> (s0 + 16, s0 * 8)> ()[%i0]
    %2 = affine.max affine_map<()[s0, s1, s2] -> (s0, s1 + 1, s2 * 2)> ()[%0, %0, %i1]
    return %2: index
  }
}
module {
  func.func @main() -> (vector<16xi1>, vector<16xi1>, vector<8xi1>, vector<16xf32>) {
    // Initialize constants for vector operations
    %c5_i32 = arith.constant 5 : i32
    %c3_i32 = arith.constant 3 : i32
    %c5_i64 = arith.constant 5 : i64
    %c3_i64 = arith.constant 3 : i64
    %c2_5_f32 = arith.constant 2.5 : f32
    %c1_5_f32 = arith.constant 1.5 : f32
    %rounding = arith.constant 0 : i32
    %imm = arith.constant 0 : i16
    
    // Create vectors for AVX512 operations
    %a_i32 = vector.broadcast %c5_i32 : i32 to vector<16xi32>
    %b_i32 = vector.broadcast %c3_i32 : i32 to vector<16xi32>
    %a_i64 = vector.broadcast %c5_i64 : i64 to vector<8xi64>
    %b_i64 = vector.broadcast %c3_i64 : i64 to vector<8xi64>
    %src_f32 = vector.broadcast %c2_5_f32 : f32 to vector<16xf32>
    %a_f32 = vector.broadcast %c1_5_f32 : f32 to vector<16xf32>
    %k = arith.constant 0 : i32
    
    // Call AVX512 operations
    %k1, %k2 = x86vector.avx512.vp2intersect %a_i32, %b_i32 : vector<16xi32>
    %res_i64 = "x86vector.avx512.intr.vp2intersect.q.512"(%a_i64, %b_i64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
    %rndscale_result = x86vector.avx512.mask.rndscale %src_f32, %k, %a_f32, %imm, %rounding : vector<16xf32>
    
    // Prepare memrefs for linalg.mul operation
    %c7 = arith.constant 7 : index
    %c14 = arith.constant 14 : index
    %c21 = arith.constant 21 : index
    
    %lhs = memref.alloc() : memref<7x14x21xf32>
    %rhs = memref.alloc() : memref<7x14x21xf32>
    %out = memref.alloc() : memref<7x14x21xf32>
    
    // Call linalg.mul operation
    call @generalize_mul(%lhs, %rhs, %out) : (memref<7x14x21xf32>, memref<7x14x21xf32>, memref<7x14x21xf32>) -> ()
    
    return %k1, %k2, %res_i64, %rndscale_result : vector<16xi1>, vector<16xi1>, vector<8xi1>, vector<16xf32>
  }

  func.func @generalize_mul(%lhs: memref<7x14x21xf32>, %rhs: memref<7x14x21xf32>,
                          %out: memref<7x14x21xf32>) {
    linalg.mul ins(%lhs, %rhs : memref<7x14x21xf32>, memref<7x14x21xf32>)
               outs(%out : memref<7x14x21xf32>)
    return
  }
}
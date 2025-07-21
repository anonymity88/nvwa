module {
  func.func @main() {
    // Memory allocation and initialization
    %base = memref.alloc() : memref<16xf32>
    %i = arith.constant 0 : index
    %mask = arith.constant dense<[1, 0, 1, 0, 1, 0, 1, 0]> : vector<8xi1>
    %valueToStore = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]> : vector<8xf32>
    vector.maskedstore %base[%i], %mask, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    // Vector operations
    %input_vector = arith.constant dense<[1, 2, 3, 4, 5, 6, 7, 8]> : vector<8xi32>
    %even_elements, %odd_elements = vector.deinterleave %input_vector : vector<8xi32> -> vector<4xi32>

    %lhs = arith.constant dense<[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]> : vector<4x2xf32>
    %rhs = arith.constant dense<[[2.0, 3.0], [4.0, 5.0], [6.0, 7.0], [8.0, 9.0]]> : vector<4x2xf32>
    %acc = arith.constant dense<[[1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0]]> : vector<4x2xf32>
    %result = vector.fma %lhs, %rhs, %acc : vector<4x2xf32>

    // Call fold_extract_broadcast function
    %scalar = arith.constant 1.0 : f32
    %broadcast_result = call @fold_extract_broadcast(%scalar) : (f32) -> vector<4xf32>

    return
  }

  func.func @fold_extract_broadcast(%a : f32) -> vector<4xf32> {
    %b = vector.broadcast %a : f32 to vector<1x2x4xf32>
    %r = vector.extract %b[0, 1] : vector<4xf32> from vector<1x2x4xf32>
    return %r : vector<4xf32>
  }
}
module {
  func.func @main() {
    // Constants for vector.from_elements
    %f1 = arith.constant 1.0 : f32
    %f2 = arith.constant 2.0 : f32
    %f3 = arith.constant 3.0 : f32
    %f4 = arith.constant 4.0 : f32
    %f5 = arith.constant 5.0 : f32
    %f6 = arith.constant 6.0 : f32

    // Vector creation operations
    %vec2 = vector.from_elements %f1, %f2 : vector<2xf32>
    %vec2x3 = vector.from_elements %f1, %f2, %f3, %f4, %f5, %f6 : vector<2x3xf32>
    %vec3x1x2 = vector.from_elements %f1, %f2, %f3, %f4, %f5, %f6 : vector<3x1x2xf32>

    // Vector constant mask
    %mask1 = vector.constant_mask [3, 2] : vector<4x3xi1>

    // Memory operations
    %base = memref.alloc() : memref<16xf32>
    %i = arith.constant 0 : index
    %mask2 = arith.constant dense<[1, 0, 1, 0, 1, 0, 1, 0]> : vector<8xi1>
    %valueToStore = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]> : vector<8xf32>
    vector.maskedstore %base[%i], %mask2, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    return
  }
}
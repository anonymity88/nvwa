module {
  func.func @main() -> f16 {
    // First part: vector mask operations and compress store
    %c4 = arith.constant 4 : index
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index
    %dynamic_mask = vector.create_mask %c3, %c2 : vector<4x3xi1>
    %constant_mask = vector.constant_mask [3, 2] : vector<4x3xi1>

    %base = memref.alloc() : memref<16xf32>
    %i = arith.constant 0 : index
    %store_mask = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>
    %valueToStore = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>
    vector.compressstore %base[%i], %store_mask, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    // Create a vector for reduction and call reduce_f16
    %reduce_input = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0]> : vector<16xf16>
    %reduced_value = call @reduce_f16(%reduce_input) : (vector<16xf16>) -> f16

    return %reduced_value : f16
  }

  func.func @reduce_f16(%arg0: vector<16xf16>) -> f16 {
    %0 = vector.reduction <add>, %arg0 : vector<16xf16> into f16
    return %0 : f16
  }
}
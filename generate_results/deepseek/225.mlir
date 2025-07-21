module {
  func.func @main() {
    // First part - Create mask with dynamic dimensions
    %c4 = arith.constant 4 : index
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index
    %dynamic_mask = vector.create_mask %c3, %c2 : vector<4x3xi1>

    // Second part - Constant mask with fixed dimensions
    %constant_mask = vector.constant_mask [3, 2] : vector<4x3xi1>

    // Third part - Memory allocation and compress store operation
    %base = memref.alloc() : memref<16xf32>
    %i = arith.constant 0 : index
    %store_mask = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>
    %valueToStore = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>
    vector.compressstore %base[%i], %store_mask, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    return
  }
}
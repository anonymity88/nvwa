module {
  func.func @main() {
    // Vector step operation
    %step_vector = vector.step : vector<4xindex>

    // First memory operation - 1D masked load
    %base1 = memref.alloc() : memref<32xf32>
    %i1 = arith.constant 0 : index
    %mask = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>
    %pass_thru = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>
    %result = vector.maskedload %base1[%i1], %mask, %pass_thru 
      : memref<32xf32>, vector<8xi1>, vector<8xf32> into vector<8xf32>

    // Second memory operation - 2D vector store
    %base2 = memref.alloc() : memref<200x100xf32>
    %i2 = arith.constant 0 : index
    %j = arith.constant 0 : index
    %valueToStore = arith.constant dense<[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]> : vector<4x2xf32>
    vector.store %valueToStore, %base2[%i2, %j] : memref<200x100xf32>, vector<4x2xf32>

    return
  }
}
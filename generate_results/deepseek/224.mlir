module {
  func.func @main() {
    // Vector transpose operation
    %matrix = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 
                                    5.0, 6.0, 7.0, 8.0, 
                                    9.0, 10.0, 11.0, 12.0, 
                                    13.0, 14.0, 15.0, 16.0]> : vector<16xf32>
    %transposed = vector.flat_transpose %matrix {rows = 4 : i32, columns = 4 : i32} : vector<16xf32> -> vector<16xf32>

    // First memory operation - masked store
    %base1 = memref.alloc() : memref<16xf32>
    %i1 = arith.constant 0 : index
    %mask1 = arith.constant dense<[1, 0, 1, 0, 1, 0, 1, 0]> : vector<8xi1>
    %valueToStore = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]> : vector<8xf32>
    vector.maskedstore %base1[%i1], %mask1, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    // Second memory operation - expand load
    %base2 = memref.alloc() : memref<32xf32>
    %i2 = arith.constant 0 : index
    %mask2 = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>
    %pass_thru = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>
    %result = vector.expandload %base2[%i2], %mask2, %pass_thru 
      : memref<32xf32>, vector<8xi1>, vector<8xf32> into vector<8xf32>

    return
  }
}
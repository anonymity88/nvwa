module {
  func.func @main() {
    // Vector operations from first IR
    %step_vector = vector.step : vector<4xindex>

    %base1 = memref.alloc() : memref<32xf32>
    %i1 = arith.constant 0 : index
    %mask = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>
    %pass_thru = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>
    %result = vector.maskedload %base1[%i1], %mask, %pass_thru 
      : memref<32xf32>, vector<8xi1>, vector<8xf32> into vector<8xf32>

    %base2 = memref.alloc() : memref<200x100xf32>
    %i2 = arith.constant 0 : index
    %j = arith.constant 0 : index
    %valueToStore = arith.constant dense<[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]> : vector<4x2xf32>
    vector.store %valueToStore, %base2[%i2, %j] : memref<200x100xf32>, vector<4x2xf32>

    // Call the entry function from second IR
    call @entry() : () -> ()

    return
  }

  func.func @entry() {
    // Vector mask operations from second IR
    %0 = vector.constant_mask [4] : vector<8xi1>
    vector.print %0 : vector<8xi1>
    %1 = vector.constant_mask [1, 3] : vector<4x4xi1>
    vector.print %1 : vector<4x4xi1>
    %2 = vector.constant_mask [2, 2] : vector<4x4xi1>
    vector.print %2 : vector<4x4xi1>
    %3 = vector.constant_mask [2, 4] : vector<4x4xi1>
    vector.print %3 : vector<4x4xi1>
    %4 = vector.constant_mask [3, 1] : vector<4x4xi1>
    vector.print %4 : vector<4x4xi1>
    %5 = vector.constant_mask [3, 2] : vector<4x4xi1>
    vector.print %5 : vector<4x4xi1>
    %6 = vector.constant_mask [4, 3] : vector<4x4xi1>
    vector.print %6 : vector<4x4xi1>
    %7 = vector.constant_mask [4, 4] : vector<4x4xi1>
    vector.print %7 : vector<4x4xi1>
    %8 = vector.constant_mask [1, 2, 3] : vector<2x3x4xi1>
    vector.print %8 : vector<2x3x4xi1>
    %9 = vector.constant_mask [2, 2, 3] : vector<2x3x4xi1>
    vector.print %9 : vector<2x3x4xi1>

    return
  }
}
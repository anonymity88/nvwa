module {
  func.func @main() {
    // Allocations and constants from first IR
    %base = memref.alloc() : memref<32xf32>
    %i = arith.constant 0 : index
    %mask = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>
    %pass_thru = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>
    %result = vector.maskedload %base[%i], %mask, %pass_thru 
      : memref<32xf32>, vector<8xi1>, vector<8xf32> into vector<8xf32>

    %v = arith.constant dense<[0.0, 0.0, 0.0, 0.0]> : vector<4xf32>
    vector.print %v : vector<4xf32>
    vector.print str "Hello, World!" : vector<1xi1>

    %A_mem = memref.alloc() : memref<64xf64>
    %B_mem = memref.alloc() : memref<48xf64>
    
    %zero = arith.constant 0.0 : f64
    %A = vector.transfer_read %A_mem[%i], %zero : memref<64xf64>, vector<64xf64>
    %B = vector.transfer_read %B_mem[%i], %zero : memref<48xf64>, vector<48xf64>
    
    %C = vector.matrix_multiply %A, %B
        { lhs_rows = 4 : i32, lhs_columns = 16 : i32, rhs_columns = 3 : i32 } :
        (vector<64xf64>, vector<48xf64>) -> vector<12xf64>

    // Create arguments for cast_away_transfer_write_leading_one_dims
    %arg0_mem = memref.alloc() : memref<1x4x8x16xf16>
    %arg1_vec = arith.constant dense<1.0> : vector<1x4xf16>
    
    // Call the second function
    call @cast_away_transfer_write_leading_one_dims(%arg0_mem, %arg1_vec) : (memref<1x4x8x16xf16>, vector<1x4xf16>) -> ()

    return
  }

  func.func @cast_away_transfer_write_leading_one_dims(%arg0: memref<1x4x8x16xf16>, %arg1: vector<1x4xf16>) {
    %c0 = arith.constant 0 : index
    vector.transfer_write %arg1, %arg0[%c0, %c0, %c0, %c0] {in_bounds = [true, true]} : vector<1x4xf16>, memref<1x4x8x16xf16>
    return
  }
}
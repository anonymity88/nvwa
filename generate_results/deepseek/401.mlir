#broadcast_2d = affine_map<(d0, d1) -> (0, 0)>

module {
  func.func @main() {
    %step_vector = vector.step : vector<4xindex>

    %base = memref.alloc() : memref<32xf32>
    %i0 = arith.constant 0 : index
    %i1 = arith.constant 2 : index
    %i2 = arith.constant 4 : index
    %i3 = arith.constant 6 : index
    %i4 = arith.constant 8 : index
    %index_vec = arith.constant dense<[1, 3, 5, 7, 9]> : vector<5xi32>
    %mask = arith.constant dense<[1, 0, 1, 1, 0]> : vector<5xi1>
    %valueToStore = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0]> : vector<5xf32>
    vector.scatter %base[%i0][%index_vec], %mask, %valueToStore 
      : memref<32xf32>, vector<5xi32>, vector<5xi1>, vector<5xf32>

    %lhs = arith.constant dense<[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]> : vector<4x2xf32>
    %rhs = arith.constant dense<[[2.0, 3.0], [4.0, 5.0], [6.0, 7.0], [8.0, 9.0]]> : vector<4x2xf32>
    %acc = arith.constant dense<[[1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0]]> : vector<4x2xf32>
    %result = vector.fma %lhs, %rhs, %acc : vector<4x2xf32>

    // Create a memref for the transfer_broadcasting_2D function
    %mem = memref.alloc() : memref<8x8xf32>
    %idx = arith.constant 0 : index
    
    // Call transfer_broadcasting_2D function
    %broadcast_result = call @transfer_broadcasting_2D(%mem, %idx) : (memref<8x8xf32>, index) -> vector<4x4xf32>

    return
  }

  func.func @transfer_broadcasting_2D(%mem : memref<8x8xf32>, %idx : index) -> vector<4x4xf32> {
    %cf0 = arith.constant 0.0 : f32
    %res = vector.transfer_read %mem[%idx, %idx], %cf0
      {in_bounds = [true, true], permutation_map = #broadcast_2d}
        : memref<8x8xf32>, vector<4x4xf32>
    return %res : vector<4x4xf32>
  }
}
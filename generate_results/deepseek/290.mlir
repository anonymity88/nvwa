module {
  func.func @main(%arg0: f32, %arg1: vector<4xf32>) -> (i32, i8, vector<4xf32>) {
    // Integer truncation operations
    %1 = arith.constant 21 : i5                  // %1 is 0b10101
    %2 = arith.trunci %1 : i5 to i4             // %2 is 0b0101
    %3 = arith.trunci %1 : i5 to i3             // %3 is 0b101

    // Vector truncation operation
    %0 = arith.constant dense<[12, 12]> : vector<2 x i32>
    %4 = arith.trunci %0 : vector<2 x i32> to vector<2 x i16>

    // Call to shift left function
    %shli_result = call @example_shli() : () -> i8

    // Max operation
    %max_val1 = arith.constant 5 : i32
    %max_val2 = arith.constant 10 : i32
    %max_result = arith.maxsi %max_val1, %max_val2 : i32

    // Call to vector insert element function
    %vector_result = call @insertelement_into_vec_1d_f32_scalable_idx_as_index(%arg0, %arg1) : (f32, vector<4xf32>) -> vector<4xf32>

    return %max_result, %shli_result, %vector_result : i32, i8, vector<4xf32>
  }

  func.func @example_shli() -> i8 {
    %1 = arith.constant 5 : i8
    %2 = arith.constant 3 : i8
    %3 = arith.shli %1, %2 : i8
    %4 = arith.shli %1, %2 overflow<nsw, nuw> : i8

    return %3 : i8
  }

  func.func @insertelement_into_vec_1d_f32_scalable_idx_as_index(%arg0: f32, %arg1: vector<4xf32>) -> vector<4xf32> {
    %0 = arith.constant 3 : index
    %1 = vector.insertelement %arg0, %arg1[%0 : index] : vector<4xf32>
    return %1 : vector<4xf32>
  }
}
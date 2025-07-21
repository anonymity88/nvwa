module {
  func.func @main() -> (i64, vector<2xi64>, i128, i128, i64) {
    // Integer division operations
    %b_ceil = arith.constant 7 : i64
    %c_ceil = arith.constant -2 : i64
    %ceil_result = arith.ceildivsi %b_ceil, %c_ceil : i64

    %b_div = arith.constant 6 : i64
    %c_div = arith.constant 2 : i64
    %a_div = arith.divui %b_div, %c_div : i64

    // Vector extension operations
    %0 = arith.constant dense<[5, 2]> : vector<2xi3>
    %5 = arith.extsi %0 : vector<2xi3> to vector<2xi64>

    // Vector division operations
    %g_div = arith.constant dense<[12, 24, 0, 36]> : vector<4xi32>
    %h_div = arith.constant dense<[3, 4, 1, 6]> : vector<4xi32>
    %f_div = arith.divui %g_div, %h_div : vector<4xi32>

    // Tensor division operations
    %y_div = arith.constant dense<[8, 16, 1, 32]> : tensor<4xi8>
    %z_div = arith.constant dense<[2, 4, 1, 8]> : tensor<4xi8>
    %x_div = arith.divui %y_div, %z_div : tensor<4xi8>

    // Conversion operations
    %conv1 = arith.extui %a_div : i64 to i128
    %conv2 = arith.extui %ceil_result : i64 to i128

    // Call to zexti2 function with a constant value
    %test_val = arith.constant 42 : i32
    %zext_result = call @zexti2(%test_val) : (i32) -> i64

    return %ceil_result, %5, %conv1, %conv2, %zext_result : i64, vector<2xi64>, i128, i128, i64
  }

  func.func @zexti2(%arg0 : i32) -> i64 {
    %0 = arith.extui %arg0 : i32 to i64
    return %0 : i64
  }
}
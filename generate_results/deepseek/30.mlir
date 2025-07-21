module {
  func.func @main() -> (i64, vector<2xi64>) {
    // Ceiling division operation
    %b_ceil = arith.constant 7 : i64
    %c_ceil = arith.constant -2 : i64
    %ceil_result = arith.ceildivsi %b_ceil, %c_ceil : i64

    // Sign extension operations
    %1 = arith.constant 5 : i3
    %2 = arith.extsi %1 : i3 to i6
    %3 = arith.constant 2 : i3
    %4 = arith.extsi %3 : i3 to i6
    %0 = arith.constant dense<[5, 2]> : vector<2xi3>
    %5 = arith.extsi %0 : vector<2xi3> to vector<2xi64>

    // Unsigned division operations
    %b_div = arith.constant 6 : i64
    %c_div = arith.constant 2 : i64
    %a_div = arith.divui %b_div, %c_div : i64

    // Vector division operations
    %g_div = arith.constant dense<[12, 24, 0, 36]> : vector<4xi32>
    %h_div = arith.constant dense<[3, 4, 1, 6]> : vector<4xi32>
    %f_div = arith.divui %g_div, %h_div : vector<4xi32>

    // Tensor division operations
    %y_div = arith.constant dense<[8, 16, 1, 32]> : tensor<4xi8>
    %z_div = arith.constant dense<[2, 4, 1, 8]> : tensor<4xi8>
    %x_div = arith.divui %y_div, %z_div : tensor<4xi8>

    // Convert some results to ensure data flow
    %conv1 = arith.extui %a_div : i64 to i128
    %conv2 = arith.extui %ceil_result : i64 to i128

    return %ceil_result, %5 : i64, vector<2xi64>
  }
}
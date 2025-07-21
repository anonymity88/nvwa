module {
  func.func @main() {
    // Scalar integer bitwise or.
    %b = arith.constant 42 : i64
    %c = arith.constant 17 : i64
    %a = arith.ori %b, %c : i64

    // SIMD vector element-wise bitwise integer or.
    %g = arith.constant dense<0> : vector<4xi32>
    %h = arith.constant dense<1> : vector<4xi32>
    %f = arith.ori %g, %h : vector<4xi32>

    // Tensor element-wise bitwise integer or.
    %y = arith.constant dense<[1, 2, 3, 4]> : tensor<4xi8>
    %z = arith.constant dense<[4, 3, 2, 1]> : tensor<4xi8>
    %x = arith.ori %y, %z : tensor<4xi8>

    return
  }
}
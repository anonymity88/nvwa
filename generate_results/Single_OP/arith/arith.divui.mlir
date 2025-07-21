module {
  func.func @main() {
    // Scalar unsigned integer division.
    %b = arith.constant 6 : i64
    %c = arith.constant 2 : i64
    %a = arith.divui %b, %c : i64

    // SIMD vector element-wise division.
    %g = arith.constant dense<[12, 24, 0, 36]> : vector<4xi32>
    %h = arith.constant dense<[3, 4, 1, 6]> : vector<4xi32> // Avoid division by zero
    %f = arith.divui %g, %h : vector<4xi32>

    // Tensor element-wise unsigned integer division.
    %y = arith.constant dense<[8, 16, 1, 32]> : tensor<4xi8> // Avoid division by zero
    %z = arith.constant dense<[2, 4, 1, 8]> : tensor<4xi8> // Avoid division by zero
    %x = arith.divui %y, %z : tensor<4xi8>

    return
  }
}
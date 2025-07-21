module {
  func.func @main() -> i32 {
    // Scalar subtraction.
    %b = arith.constant 10 : i32
    %c = arith.constant 4 : i32
    %a = arith.subi %b, %c : i32

    // Scalar subtraction with overflow flags.
    %d = arith.subi %b, %c overflow<nsw, nuw> : i32

    // SIMD vector element-wise subtraction.
    %g = arith.constant dense<[10, 20, 30, 40]> : vector<4xi32>
    %h = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %f = arith.subi %g, %h : vector<4xi32>

    // Tensor element-wise subtraction.
    %y = arith.constant dense<[5, 7, 9, 11]> : tensor<4xi32>
    %z = arith.constant dense<[2, 3, 4, 5]> : tensor<4xi32>
    %x = arith.subi %y, %z : tensor<4xi32>

    return %a : i32
  }
}
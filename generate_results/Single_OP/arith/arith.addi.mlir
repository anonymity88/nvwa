module {
  func.func @main() -> i32 {
    // Scalar addition.
    %b = arith.constant 10 : i32
    %c = arith.constant 20 : i32
    %a = arith.addi %b, %c : i32

    // Scalar addition with overflow flags.
    %d = arith.constant 30 : i32
    %e = arith.constant 40 : i32
    %f = arith.addi %d, %e overflow<nsw, nuw> : i32

    // SIMD vector element-wise addition.
    %g = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %h = arith.constant dense<[5, 6, 7, 8]> : vector<4xi32>
    %i = arith.addi %g, %h : vector<4xi32>

    // Tensor element-wise addition.
    %j = arith.constant dense<[1, 2, 3, 4]> : tensor<4xi8>
    %k = arith.constant dense<[5, 6, 7, 8]> : tensor<4xi8>
    %l = arith.addi %j, %k : tensor<4xi8>

    // Return the result of the first addition as an example.
    return %a : i32
  }
}
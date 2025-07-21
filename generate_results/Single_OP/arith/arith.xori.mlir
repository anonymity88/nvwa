module {
  func.func @main() {
    // Declare inputs for scalar integer bitwise xor
    %b = arith.constant 5 : i64       // Example scalar value
    %c = arith.constant 3 : i64       // Example scalar value
    %a = arith.xori %b, %c : i64

    // Declare inputs for SIMD vector element-wise bitwise integer xor
    %g = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>     // Example vector values
    %h = arith.constant dense<[5, 6, 7, 8]> : vector<4xi32>     // Example vector values
    %f = arith.xori %g, %h : vector<4xi32>

    // Declare inputs for tensor element-wise bitwise integer xor
    %y = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>  // Example tensor values
    %z = arith.constant dense<[[5, 6], [7, 8]]> : tensor<2x2xi8>  // Example tensor values
    %x = arith.xori %y, %z : tensor<2x2xi8>

    return
  }
}
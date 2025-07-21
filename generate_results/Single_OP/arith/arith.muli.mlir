module {
  func.func @main() -> () {
    // Scalar multiplication without overflow flags
    %b = arith.constant 3 : i64
    %c = arith.constant 4 : i64
    %a = arith.muli %b, %c : i64

    // Scalar multiplication with overflow flags
    %d = arith.muli %b, %c overflow<nsw> : i64

    // SIMD vector element-wise multiplication
    %vectorA = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %vectorB = arith.constant dense<[5, 6, 7, 8]> : vector<4xi32>
    %f = arith.muli %vectorA, %vectorB : vector<4xi32>

    // Tensor element-wise multiplication
    %tensorY = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %tensorZ = arith.constant dense<[[5, 6], [7, 8]]> : tensor<2x2xi8>
    %x = arith.muli %tensorY, %tensorZ : tensor<2x2xi8>
    
    return
  }
}
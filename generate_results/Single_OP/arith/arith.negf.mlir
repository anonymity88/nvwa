module {
  func.func @main() -> () {
    // Scalar negation value.
    %b = arith.constant 3.14 : f64
    %a = arith.negf %b : f64

    // Vector element-wise negation value.
    %g = arith.constant dense<[1.0, -2.0, 3.0, 4.0]> : vector<4xf32>
    %f = arith.negf %g : vector<4xf32>

    // Tensor element-wise negation value.
    %y = arith.constant dense<[1.0, 2.0, 3.0, 4.0]> : tensor<4xf32>
    %x = arith.negf %y : tensor<4xf32>
  
    return
  }
}
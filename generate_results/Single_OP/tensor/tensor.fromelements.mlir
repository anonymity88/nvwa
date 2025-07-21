module {
  func.func @main() -> tensor<2x3xi32> {
    // Creating inline values for elements
    %a = arith.constant 1 : i32
    %b = arith.constant 2 : i32
    %c = arith.constant 3 : i32
    %d = arith.constant 4 : i32
    %e = arith.constant 5 : i32
    %f = arith.constant 6 : i32

    // Using tensor.fromelements to instantiate a tensor from the provided elements
    %tensor_result = tensor.from_elements %a, %b, %c, %d, %e, %f : tensor<2x3xi32>

    return %tensor_result : tensor<2x3xi32>
  }
}
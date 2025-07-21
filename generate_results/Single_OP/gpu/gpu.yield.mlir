module {
  func.func @main() {
    // Define some floating-point values to yield
    %f0 = arith.constant 3.14 : f32
    %f1 = arith.constant 2.71 : f32

    // This would typically be inside a GPU region or kernel function
    gpu.yield %f0, %f1 : f32, f32
  }
}
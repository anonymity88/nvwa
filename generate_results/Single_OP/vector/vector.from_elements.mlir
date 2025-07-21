module {
  func.func @main() {
    // Define scalar elements to be included in the vector
    %f1 = arith.constant 1.0 : f32
    %f2 = arith.constant 2.0 : f32
    %f3 = arith.constant 3.0 : f32
    %f4 = arith.constant 4.0 : f32
    %f5 = arith.constant 5.0 : f32
    %f6 = arith.constant 6.0 : f32

    // Create a vector from two scalar elements
    %vec2 = vector.from_elements %f1, %f2 : vector<2xf32>

    // Create a 2x3 vector from six scalar elements
    %vec2x3 = vector.from_elements %f1, %f2, %f3, %f4, %f5, %f6 : vector<2x3xf32>

    // Create a 3x1x2 vector from six scalar elements
    %vec3x1x2 = vector.from_elements %f1, %f2, %f3, %f4, %f5, %f6 : vector<3x1x2xf32>

    return
  }
}
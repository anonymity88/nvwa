module {
  func.func @main() -> (vector<2xi32>) {
    // Constants and vector operations from first IR
    %f1 = arith.constant 1.0 : f32
    %f2 = arith.constant 2.0 : f32
    %f3 = arith.constant 3.0 : f32
    %f4 = arith.constant 4.0 : f32
    %f5 = arith.constant 5.0 : f32
    %f6 = arith.constant 6.0 : f32

    %vec2 = vector.from_elements %f1, %f2 : vector<2xf32>
    %vec2x3 = vector.from_elements %f1, %f2, %f3, %f4, %f5, %f6 : vector<2x3xf32>
    %vec3x1x2 = vector.from_elements %f1, %f2, %f3, %f4, %f5, %f6 : vector<3x1x2xf32>

    %mask1 = vector.constant_mask [3, 2] : vector<4x3xi1>

    %base = memref.alloc() : memref<16xf32>
    %i = arith.constant 0 : index
    %mask2 = arith.constant dense<[1, 0, 1, 0, 1, 0, 1, 0]> : vector<8xi1>
    %valueToStore = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]> : vector<8xf32>
    vector.maskedstore %base[%i], %mask2, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    // Create input for vector_multi_reduction_or
    %reduction_input = arith.constant dense<[[1, 2, 3, 4], [5, 6, 7, 8]]> : vector<2x4xi32>
    %reduction_acc = arith.constant dense<[0, 0]> : vector<2xi32>
    
    // Call vector_multi_reduction_or function
    %result = call @vector_multi_reduction_or(%reduction_input, %reduction_acc) : (vector<2x4xi32>, vector<2xi32>) -> vector<2xi32>

    return %result : vector<2xi32>
  }

  func.func @vector_multi_reduction_or(%arg0: vector<2x4xi32>, %acc: vector<2xi32>) -> vector<2xi32> {
    %0 = vector.multi_reduction <or>, %arg0, %acc [1] : vector<2x4xi32> to vector<2xi32>
    return %0 : vector<2xi32>
  }
}
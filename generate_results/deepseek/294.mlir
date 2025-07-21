module {
  func.func @main(
    %value: vector<4xf32>,
    %a: f32,
    %b: f32,
    %vec1: vector<4xf32>,
    %vec2: vector<4xf32>,
    %pointer: !spirv.ptr<i32, StorageBuffer>,
    %atomic_value: i32,
    %arg0: i32,
    %arg1: vector<3xi32>
  ) -> (vector<4xf32>, i1, vector<4xi1>, i32, i32, vector<3xi32>, i32, vector<3xi32>) {
    // Call combined function operations
    %combined_result1, %combined_result2, %combined_result3, %combined_result4, %combined_result5 = call @combined(
      %value, %a, %b, %vec1, %vec2, %pointer, %atomic_value
    ) : (vector<4xf32>, f32, f32, vector<4xf32>, vector<4xf32>, !spirv.ptr<i32, StorageBuffer>, i32) -> (vector<4xf32>, i1, vector<4xi1>, i32, i32)
    
    // Call const_fold_vector_lsl function
    %lsl_result = call @const_fold_vector_lsl() : () -> vector<3xi32>
    
    // Call bitwise_and_x_0 function
    %bitwise_result1, %bitwise_result2 = call @bitwise_and_x_0(%arg0, %arg1) : (i32, vector<3xi32>) -> (i32, vector<3xi32>)
    
    return %combined_result1, %combined_result2, %combined_result3, %combined_result4, %combined_result5, 
           %lsl_result, %bitwise_result1, %bitwise_result2 : 
           vector<4xf32>, i1, vector<4xi1>, i32, i32, vector<3xi32>, i32, vector<3xi32>
  }

  func.func @combined(
    %value: vector<4xf32>,
    %a: f32,
    %b: f32,
    %vec1: vector<4xf32>,
    %vec2: vector<4xf32>,
    %pointer: !spirv.ptr<i32, StorageBuffer>,
    %atomic_value: i32
  ) -> (vector<4xf32>, i1, vector<4xi1>, i32, i32) {
    %asin_result = spirv.CL.asin %value : vector<4xf32>
    %scalar_compare = spirv.FOrdLessThanEqual %a, %b : f32
    %vector_compare = spirv.FOrdLessThanEqual %vec1, %vec2 : vector<4xf32>
    %atomic_scalar_result = spirv.AtomicIAdd <Device> <None> %pointer, %atomic_value : !spirv.ptr<i32, StorageBuffer>
    %atomic_vector_result = spirv.AtomicIAdd <Device> <None> %pointer, %atomic_value : !spirv.ptr<i32, StorageBuffer>
    
    return %asin_result, %scalar_compare, %vector_compare, %atomic_scalar_result, %atomic_vector_result : 
           vector<4xf32>, i1, vector<4xi1>, i32, i32
  }

  func.func @const_fold_vector_lsl() -> vector<3xi32> {
    %c1 = spirv.Constant dense<[1, -1, 127]> : vector<3xi32>
    %c2 = spirv.Constant dense<[31, 16, 13]> : vector<3xi32>
    %0 = spirv.ShiftLeftLogical %c1, %c2 : vector<3xi32>, vector<3xi32>
    return %0 : vector<3xi32>
  }

  func.func @bitwise_and_x_0(%arg0 : i32, %arg1 : vector<3xi32>) -> (i32, vector<3xi32>) {
    %c0 = spirv.Constant 0 : i32
    %cv0 = spirv.Constant dense<0> : vector<3xi32>
    %0 = spirv.BitwiseAnd %arg0, %c0 : i32
    %1 = spirv.BitwiseAnd %arg1, %cv0 : vector<3xi32>
    return %0, %1 : i32, vector<3xi32>
  }
}
module {
  func.func @main(
    %a: i32, %b: i32,
    %v1: vector<4xi32>, %v2: vector<4xi32>,
    %operand1: vector<4xi32>, %operand2: vector<4xi32>,
    %x: f32, %v: vector<4xf32>, %y: vector<2xf64>,
    %sudot_a: vector<4xi8>, %sudot_b: vector<4xi8>
  ) -> (i1, vector<4xi1>, vector<4xi32>, f32, vector<4xf32>, vector<2xf64>, i32) {
    // Call the combined function for SPIR-V operations
    %combined_result1, %combined_result2, %combined_result3, %combined_result4, %combined_result5, %combined_result6 = 
      call @combined(%a, %b, %v1, %v2, %operand1, %operand2, %x, %v, %y) : 
        (i32, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>, vector<4xi32>, f32, vector<4xf32>, vector<2xf64>) -> 
        (i1, vector<4xi1>, vector<4xi32>, f32, vector<4xf32>, vector<2xf64>)
    
    // Call the SUDot function
    %sudot_result = call @sudot_vector_4xi8(%sudot_a, %sudot_b) : (vector<4xi8>, vector<4xi8>) -> i32
    
    return %combined_result1, %combined_result2, %combined_result3, %combined_result4, %combined_result5, %combined_result6, %sudot_result : 
           i1, vector<4xi1>, vector<4xi32>, f32, vector<4xf32>, vector<2xf64>, i32
  }

  func.func @combined(
    %a: i32, %b: i32,
    %v1: vector<4xi32>, %v2: vector<4xi32>,
    %operand1: vector<4xi32>, %operand2: vector<4xi32>,
    %x: f32, %v: vector<4xf32>, %y: vector<2xf64>
  ) -> (i1, vector<4xi1>, vector<4xi32>, f32, vector<4xf32>, vector<2xf64>) {
    %ineq_scalar = spirv.INotEqual %a, %b : i32
    
    %ineq_vector = spirv.INotEqual %v1, %v2 : vector<4xi32>
    
    %srem_result = spirv.SRem %operand1, %operand2 : vector<4xi32>
    
    %asinh_scalar = spirv.CL.asinh %x : f32
    
    %asinh_vector = spirv.CL.asinh %v : vector<4xf32>
    
    %asinh_double_vec = spirv.CL.asinh %y : vector<2xf64>
    
    return %ineq_scalar, %ineq_vector, %srem_result, %asinh_scalar, %asinh_vector, %asinh_double_vec : 
           i1, vector<4xi1>, vector<4xi32>, f32, vector<4xf32>, vector<2xf64>
  }

  func.func @sudot_vector_4xi8(%a: vector<4xi8>, %b: vector<4xi8>) -> i32 {
    %r = spirv.SUDot %a, %b : vector<4xi8> -> i32
    return %r : i32
  }
}
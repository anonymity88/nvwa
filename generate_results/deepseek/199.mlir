module {
  func.func @combined(
    %a: i32, %b: i32,
    %v1: vector<4xi32>, %v2: vector<4xi32>,
    %operand1: vector<4xi32>, %operand2: vector<4xi32>,
    %x: f32, %v: vector<4xf32>, %y: vector<2xf64>
  ) -> (i1, vector<4xi1>, vector<4xi32>, f32, vector<4xf32>, vector<2xf64>) {
    // Integer not-equal comparison for scalars
    %ineq_scalar = spirv.INotEqual %a, %b : i32
    
    // Integer not-equal comparison for vectors
    %ineq_vector = spirv.INotEqual %v1, %v2 : vector<4xi32>
    
    // Signed remainder operation for vectors
    %srem_result = spirv.SRem %operand1, %operand2 : vector<4xi32>
    
    // Inverse hyperbolic sine for scalar float
    %asinh_scalar = spirv.CL.asinh %x : f32
    
    // Inverse hyperbolic sine for float vector
    %asinh_vector = spirv.CL.asinh %v : vector<4xf32>
    
    // Inverse hyperbolic sine for double precision vector
    %asinh_double_vec = spirv.CL.asinh %y : vector<2xf64>
    
    // Return all results
    return %ineq_scalar, %ineq_vector, %srem_result, %asinh_scalar, %asinh_vector, %asinh_double_vec : 
           i1, vector<4xi1>, vector<4xi32>, f32, vector<4xf32>, vector<2xf64>
  }
}
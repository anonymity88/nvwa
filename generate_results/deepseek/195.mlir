module {
  func.func @combined(
    %a_float: f32, %b_float: f32,
    %v1_float: vector<4xf32>, %v2_float: vector<4xf32>,
    %a_int: i32, %b_int: i32,
    %v1_int: vector<4xi32>, %v2_int: vector<4xi32>,
    %x: f32, %y: f32
  ) -> (i1, vector<4xi1>, i1, vector<4xi1>, i1, vector<4xi1>) {
    // Float not-equal comparison (scalar)
    %float_ne_scalar = spirv.FOrdNotEqual %a_float, %b_float : f32
    
    // Float not-equal comparison (vector)
    %float_ne_vector = spirv.FOrdNotEqual %v1_float, %v2_float : vector<4xf32>
    
    // Integer not-equal comparison (scalar)
    %int_ne_scalar = spirv.INotEqual %a_int, %b_int : i32
    
    // Integer not-equal comparison (vector)
    %int_ne_vector = spirv.INotEqual %v1_int, %v2_int : vector<4xi32>
    
    // Float greater-than-or-equal comparison (scalar)
    %float_ge_scalar = spirv.FOrdGreaterThanEqual %x, %y : f32
    
    // Float greater-than-or-equal comparison (vector)
    %float_ge_vector = spirv.FOrdGreaterThanEqual %v1_float, %v2_float : vector<4xf32>
    
    // Return all results
    return %float_ne_scalar, %float_ne_vector,
           %int_ne_scalar, %int_ne_vector,
           %float_ge_scalar, %float_ge_vector : 
           i1, vector<4xi1>, i1, vector<4xi1>, i1, vector<4xi1>
  }
}
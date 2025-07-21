module {
  func.func @main(
    %a: f32, %b: f32, %c: f32,
    %x: f32,
    %v: vector<4xf32>,
    %v_double: vector<4xf64>,
    %a_vec: vector<4xf32>, %b_vec: vector<4xf32>, %c_vec: vector<4xf32>,
    %srem_arg0: i32,
    %srem_arg1: vector<3xi32>
  ) -> (i32, vector<4xi32>, f32, vector<4xf32>, f32, vector<4xf32>, vector<4xf64>, i32, vector<3xi32>) {
    // Call the combined function for conversion, FMA and cosine operations
    %convert_scalar, %convert_vector, %fma_scalar, %fma_vector, %cos_scalar, %cos_vector, %cos_vector_double = 
      call @combined(%a, %b, %c, %x, %v, %v_double, %a_vec, %b_vec, %c_vec) : 
      (f32, f32, f32, f32, vector<4xf32>, vector<4xf64>, vector<4xf32>, vector<4xf32>, vector<4xf32>) -> 
      (i32, vector<4xi32>, f32, vector<4xf32>, f32, vector<4xf32>, vector<4xf64>)
    
    // Call the srem function
    %srem_result0, %srem_result1 = call @srem_x_1(%srem_arg0, %srem_arg1) : (i32, vector<3xi32>) -> (i32, vector<3xi32>)
    
    return %convert_scalar, %convert_vector, %fma_scalar, %fma_vector, %cos_scalar, %cos_vector, %cos_vector_double, %srem_result0, %srem_result1 : 
           i32, vector<4xi32>, f32, vector<4xf32>, f32, vector<4xf32>, vector<4xf64>, i32, vector<3xi32>
  }

  func.func @combined(
    %a: f32, %b: f32, %c: f32,
    %x: f32,
    %v: vector<4xf32>,
    %v_double: vector<4xf64>,
    %a_vec: vector<4xf32>, %b_vec: vector<4xf32>, %c_vec: vector<4xf32>
  ) -> (i32, vector<4xi32>, f32, vector<4xf32>, f32, vector<4xf32>, vector<4xf64>) {
    %convert_scalar = spirv.ConvertFToS %a : f32 to i32
    %convert_vector = spirv.ConvertFToS %v : vector<4xf32> to vector<4xi32>
    
    %fma_scalar = spirv.GL.Fma %a, %b, %c : f32
    %fma_vector = spirv.GL.Fma %a_vec, %b_vec, %c_vec : vector<4xf32>
    
    %cos_scalar = spirv.CL.cos %x : f32
    %cos_vector = spirv.CL.cos %v : vector<4xf32>
    %cos_vector_double = spirv.CL.cos %v_double : vector<4xf64>
    
    return %convert_scalar, %convert_vector, %fma_scalar, %fma_vector, 
           %cos_scalar, %cos_vector, %cos_vector_double : 
           i32, vector<4xi32>, f32, vector<4xf32>, f32, vector<4xf32>, vector<4xf64>
  }

  func.func @srem_x_1(%arg0: i32, %arg1: vector<3xi32>) -> (i32, vector<3xi32>) {
    %c1 = spirv.Constant 1 : i32
    %cv1 = spirv.Constant dense<1> : vector<3xi32>
    %0 = spirv.SRem %arg0, %c1 : i32
    %1 = spirv.SRem %arg1, %cv1 : vector<3xi32>
    return %0, %1 : i32, vector<3xi32>
  }
}
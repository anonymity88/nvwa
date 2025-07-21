module {
  func.func @combined(
    %a: f32, %b: f32, %c: f32,
    %x: f32,
    %v: vector<4xf32>,
    %v_double: vector<4xf64>,
    %a_vec: vector<4xf32>, %b_vec: vector<4xf32>, %c_vec: vector<4xf32>
  ) -> (i32, vector<4xi32>, f32, vector<4xf32>, f32, vector<4xf32>, vector<4xf64>) {
    // ConvertFToS operations
    %convert_scalar = spirv.ConvertFToS %a : f32 to i32
    %convert_vector = spirv.ConvertFToS %v : vector<4xf32> to vector<4xi32>
    
    // FMA operations
    %fma_scalar = spirv.GL.Fma %a, %b, %c : f32
    %fma_vector = spirv.GL.Fma %a_vec, %b_vec, %c_vec : vector<4xf32>
    
    // Cosine operations
    %cos_scalar = spirv.CL.cos %x : f32
    %cos_vector = spirv.CL.cos %v : vector<4xf32>
    %cos_vector_double = spirv.CL.cos %v_double : vector<4xf64>
    
    // Return all results
    return %convert_scalar, %convert_vector, %fma_scalar, %fma_vector, 
           %cos_scalar, %cos_vector, %cos_vector_double : 
           i32, vector<4xi32>, f32, vector<4xf32>, f32, vector<4xf32>, vector<4xf64>
  }
}
module {
  func.func @main(
    %condition: i1,
    %true_value: f32,
    %false_value: f32,
    %condition_vec: vector<4xi1>,
    %true_value_vec: vector<4xf32>,
    %false_value_vec: vector<4xf32>,
    %vector: vector<4xf32>,
    %scalar: f32,
    %v: vector<3xf32>,
    %s: f32,
    %value: vector<4xf32>,
    %arg0: ui32,
    %min: ui32,
    %max: ui32
  ) -> (f32, vector<4xf32>, vector<4xf32>, vector<3xf32>, vector<4xi1>) {
    // Call the combined function for SPIR-V operations
    %select_result, %select_vec_result, %vector_times_scalar_result, %vector_times_scalar_3d_result, %is_nan_result = call @combined(
      %condition, %true_value, %false_value, 
      %condition_vec, %true_value_vec, %false_value_vec,
      %vector, %scalar, %v, %s, %value
    ) : (
      i1, f32, f32, 
      vector<4xi1>, vector<4xf32>, vector<4xf32>,
      vector<4xf32>, f32, vector<3xf32>, f32, vector<4xf32>
    ) -> (f32, vector<4xf32>, vector<4xf32>, vector<3xf32>, vector<4xi1>)
    
    // Call the UClamp function
    call @uclamp(%arg0, %min, %max) : (ui32, ui32, ui32) -> ()
    
    return %select_result, %select_vec_result, %vector_times_scalar_result, %vector_times_scalar_3d_result, %is_nan_result : 
           f32, vector<4xf32>, vector<4xf32>, vector<3xf32>, vector<4xi1>
  }

  func.func @combined(
    %condition: i1,
    %true_value: f32,
    %false_value: f32,
    %condition_vec: vector<4xi1>,
    %true_value_vec: vector<4xf32>,
    %false_value_vec: vector<4xf32>,
    %vector: vector<4xf32>,
    %scalar: f32,
    %v: vector<3xf32>,
    %s: f32,
    %value: vector<4xf32>
  ) -> (f32, vector<4xf32>, vector<4xf32>, vector<3xf32>, vector<4xi1>) {
    %select_result = spirv.Select %condition, %true_value, %false_value : i1, f32
    %select_vec_result = spirv.Select %condition_vec, %true_value_vec, %false_value_vec : vector<4xi1>, vector<4xf32>
    
    %vector_times_scalar_result = spirv.VectorTimesScalar %vector, %scalar : (vector<4xf32>, f32) -> vector<4xf32>
    %vector_times_scalar_3d_result = spirv.VectorTimesScalar %v, %s : (vector<3xf32>, f32) -> vector<3xf32>
    
    %is_nan_result = spirv.IsNan %value : vector<4xf32>
    
    return %select_result, %select_vec_result, %vector_times_scalar_result, %vector_times_scalar_3d_result, %is_nan_result : 
           f32, vector<4xf32>, vector<4xf32>, vector<3xf32>, vector<4xi1>
  }

  func.func @uclamp(%arg0 : ui32, %min : ui32, %max : ui32) -> () {
    %2 = spirv.GL.UClamp %arg0, %min, %max : ui32
    return
  }
}
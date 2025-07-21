module {
  func.func @main(
    %a_scalar: f32,
    %v_vector: vector<4xf32>,
    %value_scalar: i32,
    %values_vector: vector<4xi32>,
    %a_add: i32,
    %b_add: i32,
    %v1_add: vector<4xi32>,
    %v2_add: vector<4xi32>,
    %round_vec: vector<3xf16>
  ) -> (i32, vector<4xi32>, i32, vector<4xi32>, i32, vector<4xi32>) {
    // Call the combined function for conversion and arithmetic operations
    %convert_scalar, %convert_vector, %group_add_scalar, %group_add_vector, %iadd_scalar, %iadd_vector = 
      call @combined(%a_scalar, %v_vector, %value_scalar, %values_vector, %a_add, %b_add, %v1_add, %v2_add) : 
      (f32, vector<4xf32>, i32, vector<4xi32>, i32, i32, vector<4xi32>, vector<4xi32>) -> 
      (i32, vector<4xi32>, i32, vector<4xi32>, i32, vector<4xi32>)
    
    // Call the rounding function
    call @round_even_vec(%round_vec) : (vector<3xf16>) -> ()
    
    return %convert_scalar, %convert_vector, %group_add_scalar, %group_add_vector, %iadd_scalar, %iadd_vector : 
           i32, vector<4xi32>, i32, vector<4xi32>, i32, vector<4xi32>
  }

  func.func @combined(
    %a_scalar: f32,
    %v_vector: vector<4xf32>,
    %value_scalar: i32,
    %values_vector: vector<4xi32>,
    %a_add: i32,
    %b_add: i32,
    %v1_add: vector<4xi32>,
    %v2_add: vector<4xi32>
  ) -> (i32, vector<4xi32>, i32, vector<4xi32>, i32, vector<4xi32>) {
    %convert_scalar = spirv.ConvertFToU %a_scalar : f32 to i32
    %convert_vector = spirv.ConvertFToU %v_vector : vector<4xf32> to vector<4xi32>
    %group_add_scalar = spirv.GroupIAdd <Workgroup> <Reduce> %value_scalar : i32
    %group_add_vector = spirv.GroupIAdd <Subgroup> <Reduce> %values_vector : vector<4xi32>
    %iadd_scalar = spirv.IAdd %a_add, %b_add : i32
    %iadd_vector = spirv.IAdd %v1_add, %v2_add : vector<4xi32>
    
    return %convert_scalar, %convert_vector, %group_add_scalar, %group_add_vector, %iadd_scalar, %iadd_vector : 
           i32, vector<4xi32>, i32, vector<4xi32>, i32, vector<4xi32>
  }

  func.func @round_even_vec(%arg0 : vector<3xf16>) -> () {
    %2 = spirv.GL.RoundEven %arg0 : vector<3xf16>
    return
  }
}
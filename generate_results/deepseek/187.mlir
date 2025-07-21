module {
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
    // Convert floating-point to unsigned integer (scalar)
    %convert_scalar = spirv.ConvertFToU %a_scalar : f32 to i32

    // Convert floating-point to unsigned integer (vector)
    %convert_vector = spirv.ConvertFToU %v_vector : vector<4xf32> to vector<4xi32>

    // Group reduction add (scalar, workgroup scope)
    %group_add_scalar = spirv.GroupIAdd <Workgroup> <Reduce> %value_scalar : i32

    // Group reduction add (vector, subgroup scope)
    %group_add_vector = spirv.GroupIAdd <Subgroup> <Reduce> %values_vector : vector<4xi32>

    // Scalar integer addition
    %iadd_scalar = spirv.IAdd %a_add, %b_add : i32

    // Vector integer addition
    %iadd_vector = spirv.IAdd %v1_add, %v2_add : vector<4xi32>

    // Return all results
    return %convert_scalar, %convert_vector, %group_add_scalar, %group_add_vector, %iadd_scalar, %iadd_vector : 
           i32, vector<4xi32>, i32, vector<4xi32>, i32, vector<4xi32>
  }
}
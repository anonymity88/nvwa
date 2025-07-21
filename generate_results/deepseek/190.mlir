module {
  func.func @combined(
    %ptr_float: !spirv.ptr<f32, Generic>,
    %ptr_int: !spirv.ptr<i32, Generic>,
    %x: i1,
    %y: i1,
    %v1: vector<4xi1>,
    %v2: vector<4xi1>
  ) -> (!spirv.ptr<f32, CrossWorkgroup>, i32, i1, vector<4xi1>) {
    // Cast generic float pointer to cross-workgroup pointer
    %cast_result = spirv.GenericCastToPtr %ptr_float : !spirv.ptr<f32, Generic> to !spirv.ptr<f32, CrossWorkgroup>
    
    // Convert integer pointer to unsigned integer
    %convert_result = spirv.ConvertPtrToU %ptr_int : !spirv.ptr<i32, Generic> to i32
    
    // Logical OR for scalar booleans
    %logical_or_scalar = spirv.LogicalOr %x, %y : i1
    
    // Logical OR for vector of booleans
    %logical_or_vector = spirv.LogicalOr %v1, %v2 : vector<4xi1>
    
    // Return all results
    return %cast_result, %convert_result, %logical_or_scalar, %logical_or_vector : 
           !spirv.ptr<f32, CrossWorkgroup>, i32, i1, vector<4xi1>
  }
}
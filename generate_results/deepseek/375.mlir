module {
  func.func @main(
    %ptr_float: !spirv.ptr<f32, Generic>,
    %ptr_int: !spirv.ptr<i32, Generic>,
    %x: i1,
    %y: i1,
    %v1: vector<4xi1>,
    %v2: vector<4xi1>,
    %bitwise_arg: i32
  ) -> (!spirv.ptr<f32, CrossWorkgroup>, i32, i1, vector<4xi1>, i32) {
    // Call the combined function for pointer operations and logical operations
    %cast_result, %convert_result, %logical_or_scalar, %logical_or_vector = 
      call @combined(%ptr_float, %ptr_int, %x, %y, %v1, %v2) : 
      (!spirv.ptr<f32, Generic>, !spirv.ptr<i32, Generic>, i1, i1, vector<4xi1>, vector<4xi1>) -> 
      (!spirv.ptr<f32, CrossWorkgroup>, i32, i1, vector<4xi1>)
    
    // Call the bitwise_and_scalar function
    %bitwise_result = call @bitwise_and_scalar(%bitwise_arg) : (i32) -> i32
    
    return %cast_result, %convert_result, %logical_or_scalar, %logical_or_vector, %bitwise_result : 
           !spirv.ptr<f32, CrossWorkgroup>, i32, i1, vector<4xi1>, i32
  }

  func.func @combined(
    %ptr_float: !spirv.ptr<f32, Generic>,
    %ptr_int: !spirv.ptr<i32, Generic>,
    %x: i1,
    %y: i1,
    %v1: vector<4xi1>,
    %v2: vector<4xi1>
  ) -> (!spirv.ptr<f32, CrossWorkgroup>, i32, i1, vector<4xi1>) {
    %cast_result = spirv.GenericCastToPtr %ptr_float : !spirv.ptr<f32, Generic> to !spirv.ptr<f32, CrossWorkgroup>
    
    %convert_result = spirv.ConvertPtrToU %ptr_int : !spirv.ptr<i32, Generic> to i32
    
    %logical_or_scalar = spirv.LogicalOr %x, %y : i1
    
    %logical_or_vector = spirv.LogicalOr %v1, %v2 : vector<4xi1>
    
    return %cast_result, %convert_result, %logical_or_scalar, %logical_or_vector : 
           !spirv.ptr<f32, CrossWorkgroup>, i32, i1, vector<4xi1>
  }

  func.func @bitwise_and_scalar(%arg: i32) -> i32 {
    %0 = spirv.BitwiseAnd %arg, %arg : i32
    return %0 : i32
  }
}
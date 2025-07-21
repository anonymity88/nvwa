module {
  func.func @main(
    %x: f32,
    %v: vector<4xf32>,
    %pointer: !spirv.ptr<i32, StorageBuffer>,
    %value: i32,
    %a: i32,
    %b: i32,
    %vecA: vector<4xi32>,
    %vecB: vector<4xi32>
  ) -> (f32, vector<4xf32>, i32, i32, vector<4xi32>, vector<3xi1>) {
    // Call combined function for basic operations
    %atan_result, %atan_vec_result, %atomic_result, %udiv_result, %udiv_vec_result = 
      call @combined(%x, %v, %pointer, %value, %a, %b, %vecA, %vecB) : 
      (f32, vector<4xf32>, !spirv.ptr<i32, StorageBuffer>, i32, i32, i32, vector<4xi32>, vector<4xi32>) -> 
      (f32, vector<4xf32>, i32, i32, vector<4xi32>)
    
    // Call vector comparison function
    %vector_comp_result = call @const_fold_vector_ult() : () -> vector<3xi1>
    
    return %atan_result, %atan_vec_result, %atomic_result, %udiv_result, %udiv_vec_result, %vector_comp_result : 
           f32, vector<4xf32>, i32, i32, vector<4xi32>, vector<3xi1>
  }

  func.func @combined(
    %x: f32,
    %v: vector<4xf32>,
    %pointer: !spirv.ptr<i32, StorageBuffer>,
    %value: i32,
    %a: i32,
    %b: i32,
    %vecA: vector<4xi32>,
    %vecB: vector<4xi32>
  ) -> (f32, vector<4xf32>, i32, i32, vector<4xi32>) {
    %atan_result = spirv.CL.atan %x : f32
    %atan_vec_result = spirv.CL.atan %v : vector<4xf32>
    %atomic_result = spirv.AtomicUMax <Device> <None> %pointer, %value : !spirv.ptr<i32, StorageBuffer>
    %udiv_result = spirv.UDiv %a, %b : i32
    %udiv_vec_result = spirv.UDiv %vecA, %vecB : vector<4xi32>
    
    return %atan_result, %atan_vec_result, %atomic_result, %udiv_result, %udiv_vec_result : 
           f32, vector<4xf32>, i32, i32, vector<4xi32>
  }

  func.func @const_fold_vector_ult() -> vector<3xi1> {
    %cv0 = spirv.Constant dense<[-1, -4, 3]> : vector<3xi32>
    %cv1 = spirv.Constant dense<[-1, -3, 2]> : vector<3xi32>
    %0 = spirv.ULessThan %cv0, %cv1 : vector<3xi32>
    return %0 : vector<3xi1>
  }
}
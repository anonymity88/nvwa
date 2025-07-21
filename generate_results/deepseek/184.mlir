module {
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
    // Compute atan for scalar float
    %atan_result = spirv.CL.atan %x : f32
    
    // Compute atan for vector of floats
    %atan_vec_result = spirv.CL.atan %v : vector<4xf32>
    
    // Perform atomic unsigned maximum operation
    %atomic_result = spirv.AtomicUMax <Device> <None> %pointer, %value : !spirv.ptr<i32, StorageBuffer>
    
    // Compute unsigned division for scalar integers
    %udiv_result = spirv.UDiv %a, %b : i32
    
    // Compute unsigned division for vector of integers
    %udiv_vec_result = spirv.UDiv %vecA, %vecB : vector<4xi32>
    
    // Return all results
    return %atan_result, %atan_vec_result, %atomic_result, %udiv_result, %udiv_vec_result : 
           f32, vector<4xf32>, i32, i32, vector<4xi32>
  }
}
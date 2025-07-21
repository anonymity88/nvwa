module {
  func.func @combined(
    %value: vector<4xf32>,
    %a: f32,
    %b: f32,
    %vec1: vector<4xf32>,
    %vec2: vector<4xf32>,
    %pointer: !spirv.ptr<i32, StorageBuffer>,
    %atomic_value: i32
  ) -> (vector<4xf32>, i1, vector<4xi1>, i32, i32) {
    // Compute arc sine of vector elements
    %asin_result = spirv.CL.asin %value : vector<4xf32>
    
    // Compare two floating-point scalars
    %scalar_compare = spirv.FOrdLessThanEqual %a, %b : f32
    
    // Compare two floating-point vectors
    %vector_compare = spirv.FOrdLessThanEqual %vec1, %vec2 : vector<4xf32>
    
    // Perform atomic integer addition on scalar pointer
    %atomic_scalar_result = spirv.AtomicIAdd <Device> <None> %pointer, %atomic_value : !spirv.ptr<i32, StorageBuffer>
    
    // Perform atomic integer addition on vector pointer (same operation as scalar)
    %atomic_vector_result = spirv.AtomicIAdd <Device> <None> %pointer, %atomic_value : !spirv.ptr<i32, StorageBuffer>
    
    // Return all results
    return %asin_result, %scalar_compare, %vector_compare, %atomic_scalar_result, %atomic_vector_result : 
           vector<4xf32>, i1, vector<4xi1>, i32, i32
  }
}
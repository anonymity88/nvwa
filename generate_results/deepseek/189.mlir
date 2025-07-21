module {
  func.func @combined(
    %a: i32,
    %b: i32,
    %v1: vector<4xi32>,
    %v2: vector<4xi32>,
    %value: vector<4xi32>,
    %pointer: !spirv.ptr<i32, StorageBuffer>
  ) -> (i32, vector<4xi32>, vector<4xi32>, i32) {
    // Compute unsigned modulus for scalar integers
    %umod_result = spirv.UMod %a, %b : i32
    
    // Compute unsigned modulus for vector of integers
    %vector_umod_result = spirv.UMod %v1, %v2 : vector<4xi32>
    
    // Compute negation for vector of integers
    %negate_result = spirv.SNegate %value : vector<4xi32>
    
    // Perform atomic increment on the integer pointer
    %increment_result = spirv.AtomicIIncrement <Device> <None> %pointer : !spirv.ptr<i32, StorageBuffer>
    
    // Return all results
    return %umod_result, %vector_umod_result, %negate_result, %increment_result : 
           i32, vector<4xi32>, vector<4xi32>, i32
  }
}
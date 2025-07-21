module {
  func.func @main(
    %a: i32,
    %b: i32,
    %v1: vector<4xi32>,
    %v2: vector<4xi32>,
    %value: vector<4xi32>,
    %pointer: !spirv.ptr<i32, StorageBuffer>,
    %vector_i16: vector<4xi16>
  ) -> (i32, vector<4xi32>, vector<4xi32>, i32, i64) {
    // Call combined function for SPIR-V operations
    %umod_result, %vector_umod_result, %negate_result, %increment_result = 
      call @combined(%a, %b, %v1, %v2, %value, %pointer) : 
        (i32, i32, vector<4xi32>, vector<4xi32>, vector<4xi32>, !spirv.ptr<i32, StorageBuffer>) -> 
        (i32, vector<4xi32>, vector<4xi32>, i32)
    
    // Call SDot vector function
    %sdot_result = call @sdot_vector_4xi16_i64(%vector_i16) : (vector<4xi16>) -> i64
    
    return %umod_result, %vector_umod_result, %negate_result, %increment_result, %sdot_result : 
           i32, vector<4xi32>, vector<4xi32>, i32, i64
  }

  func.func @combined(
    %a: i32,
    %b: i32,
    %v1: vector<4xi32>,
    %v2: vector<4xi32>,
    %value: vector<4xi32>,
    %pointer: !spirv.ptr<i32, StorageBuffer>
  ) -> (i32, vector<4xi32>, vector<4xi32>, i32) {
    %umod_result = spirv.UMod %a, %b : i32
    %vector_umod_result = spirv.UMod %v1, %v2 : vector<4xi32>
    %negate_result = spirv.SNegate %value : vector<4xi32>
    %increment_result = spirv.AtomicIIncrement <Device> <None> %pointer : !spirv.ptr<i32, StorageBuffer>
    
    return %umod_result, %vector_umod_result, %negate_result, %increment_result : 
           i32, vector<4xi32>, vector<4xi32>, i32
  }

  func.func @sdot_vector_4xi16_i64(%a: vector<4xi16>) -> i64 {
    %r = spirv.SDot %a, %a: vector<4xi16> -> i64
    return %r: i64
  }
}
module {
  func.func @main(
    %x: i32,
    %y: i32,
    %v1: vector<4xi32>,
    %v2: vector<4xi32>,
    %value: vector<4xf32>,
    %a: i32,
    %b: i32,
    %a_vec: vector<4xi8>
  ) -> (i32, vector<4xi32>, vector<4xf32>, i1, vector<4xi1>, i64) {
    // Call the combined function for various SPIR-V operations
    %scalar_umax, %vector_umax, %asin_result, %scalar_sle, %vector_sle = 
      call @combined(%x, %y, %v1, %v2, %value, %a, %b) : 
      (i32, i32, vector<4xi32>, vector<4xi32>, vector<4xf32>, i32, i32) -> 
      (i32, vector<4xi32>, vector<4xf32>, i1, vector<4xi1>)
    
    // Call the UDot operation function
    %udot_result = call @udot_vector_4xi8_i64(%a_vec) : (vector<4xi8>) -> i64
    
    return %scalar_umax, %vector_umax, %asin_result, %scalar_sle, %vector_sle, %udot_result : 
           i32, vector<4xi32>, vector<4xf32>, i1, vector<4xi1>, i64
  }

  func.func @combined(
    %x: i32,
    %y: i32,
    %v1: vector<4xi32>,
    %v2: vector<4xi32>,
    %value: vector<4xf32>,
    %a: i32,
    %b: i32
  ) -> (i32, vector<4xi32>, vector<4xf32>, i1, vector<4xi1>) {
    %scalar_umax = spirv.GL.UMax %x, %y : i32
    %vector_umax = spirv.GL.UMax %v1, %v2 : vector<4xi32>
    %asin_result = spirv.CL.asin %value : vector<4xf32>
    %scalar_sle = spirv.SLessThanEqual %a, %b : i32
    %vector_sle = spirv.SLessThanEqual %v1, %v2 : vector<4xi32>
    
    return %scalar_umax, %vector_umax, %asin_result, %scalar_sle, %vector_sle : 
           i32, vector<4xi32>, vector<4xf32>, i1, vector<4xi1>
  }

  func.func @udot_vector_4xi8_i64(%a: vector<4xi8>) -> i64 {
    %r = spirv.UDot %a, %a: vector<4xi8> -> i64
    return %r: i64
  }
}
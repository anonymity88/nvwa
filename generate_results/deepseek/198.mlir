module {
  func.func @combined(
    %x: i32,
    %y: i32,
    %v1: vector<4xi32>,
    %v2: vector<4xi32>,
    %value: vector<4xf32>,
    %a: i32,
    %b: i32
  ) -> (i32, vector<4xi32>, vector<4xf32>, i1, vector<4xi1>) {
    // Compute unsigned maximum for scalars
    %scalar_umax = spirv.GL.UMax %x, %y : i32
    
    // Compute unsigned maximum for vectors
    %vector_umax = spirv.GL.UMax %v1, %v2 : vector<4xi32>
    
    // Compute arcsine for vector elements
    %asin_result = spirv.CL.asin %value : vector<4xf32>
    
    // Compute signed less-than-or-equal for scalars
    %scalar_sle = spirv.SLessThanEqual %a, %b : i32
    
    // Compute signed less-than-or-equal for vectors
    %vector_sle = spirv.SLessThanEqual %v1, %v2 : vector<4xi32>
    
    // Return all results
    return %scalar_umax, %vector_umax, %asin_result, %scalar_sle, %vector_sle : 
           i32, vector<4xi32>, vector<4xf32>, i1, vector<4xi1>
  }
}
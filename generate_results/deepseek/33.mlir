module {
  func.func @main(%cond: i1, %true_val: i32, %false_val: i32) -> (i32, i64, vector<4xi32>, tensor<4xi8>) {
    // Integer max operation
    %max_val1 = arith.constant 5 : i32
    %max_val2 = arith.constant 10 : i32
    %max_result = arith.maxsi %max_val1, %max_val2 : i32
    
    // Scalar select operation
    %select_result = call @scalar_select(%cond, %true_val, %false_val) : (i1, i32, i32) -> i32
    
    // Unsigned division operations
    %div_scalar1 = arith.constant 6 : i64
    %div_scalar2 = arith.constant 2 : i64
    %div_scalar_result = arith.divui %div_scalar1, %div_scalar2 : i64
    
    // Vector division operations
    %div_vec1 = arith.constant dense<[12, 24, 0, 36]> : vector<4xi32>
    %div_vec2 = arith.constant dense<[3, 4, 1, 6]> : vector<4xi32>
    %div_vec_result = arith.divui %div_vec1, %div_vec2 : vector<4xi32>
    
    // Tensor division operations
    %div_tensor1 = arith.constant dense<[8, 16, 1, 32]> : tensor<4xi8>
    %div_tensor2 = arith.constant dense<[2, 4, 1, 8]> : tensor<4xi8>
    %div_tensor_result = arith.divui %div_tensor1, %div_tensor2 : tensor<4xi8>
    
    // Prepare inputs for vector select
    %vcond = vector.broadcast %cond : i1 to vector<4xi1>
    %vtrue = arith.sitofp %div_vec_result : vector<4xi32> to vector<4xf32>
    %vfalse = arith.constant dense<0.0> : vector<4xf32>
    
    // Vector select operation
    %vector_select_result = call @vector_select(%vcond, %vtrue, %vfalse) : (vector<4xi1>, vector<4xf32>, vector<4xf32>) -> vector<4xf32>
    
    return %select_result, %div_scalar_result, %div_vec_result, %div_tensor_result : i32, i64, vector<4xi32>, tensor<4xi8>
  }
  
  func.func @scalar_select(%cond: i1, %true_val: i32, %false_val: i32) -> i32 {
    %result = "arith.select"(%cond, %true_val, %false_val) : (i1, i32, i32) -> i32
    return %result : i32
  }
  
  func.func @vector_select(%vcond: vector<4xi1>, %vtrue: vector<4xf32>, %vfalse: vector<4xf32>) -> vector<4xf32> {
    %vresult = "arith.select"(%vcond, %vtrue, %vfalse) : (vector<4xi1>, vector<4xf32>, vector<4xf32>) -> vector<4xf32>
    return %vresult : vector<4xf32>
  }
}
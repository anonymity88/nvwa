module {
  func.func @main(%cond: i1, %true_val: i32, %false_val: i32) -> (f64, i32) {
    // XOR operations
    %b_xor = arith.constant 5 : i64
    %c_xor = arith.constant 3 : i64
    %a_xor = arith.xori %b_xor, %c_xor : i64
    
    // Vector XOR operations
    %g_xor = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %h_xor = arith.constant dense<[5, 6, 7, 8]> : vector<4xi32>
    %f_xor = arith.xori %g_xor, %h_xor : vector<4xi32>
    
    // Tensor XOR operations
    %y_xor = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %z_xor = arith.constant dense<[[5, 6], [7, 8]]> : tensor<2x2xi8>
    %x_xor = arith.xori %y_xor, %z_xor : tensor<2x2xi8>
    
    // Floating-point addition
    %b_add = arith.constant 3.5 : f64
    %c_add = arith.constant 2.5 : f64
    %a_add = arith.addf %b_add, %c_add : f64
    
    // Scalar select operation
    %scalar_select = call @select(%cond, %true_val, %false_val) : (i1, i32, i32) -> i32
    
    // Prepare inputs for vector select
    %vcond = vector.broadcast %cond : i1 to vector<4xi1>
    %vtrue = arith.sitofp %f_xor : vector<4xi32> to vector<4xf32>
    %vfalse = arith.constant dense<1.0> : vector<4xf32>
    
    // Vector select operation
    %vector_select = call @vector_select(%vcond, %vtrue, %vfalse) : (vector<4xi1>, vector<4xf32>, vector<4xf32>) -> vector<4xf32>
    
    return %a_add, %scalar_select : f64, i32
  }
  
  func.func @select(%cond: i1, %true_val: i32, %false_val: i32) -> i32 {
    %result = "arith.select"(%cond, %true_val, %false_val) : (i1, i32, i32) -> i32
    return %result : i32
  }

  func.func @vector_select(%vcond: vector<4xi1>, %vtrue: vector<4xf32>, %vfalse: vector<4xf32>) -> vector<4xf32> {
    %vresult = "arith.select"(%vcond, %vtrue, %vfalse) : (vector<4xi1>, vector<4xf32>, vector<4xf32>) -> vector<4xf32>
    return %vresult : vector<4xf32>
  }
}
module {
  func.func @minui_example(%a: i32, %b: i32) -> i32 {
    %result = arith.minui %a, %b : i32
    return %result : i32
  }

  func.func @vector_select(%vcond: vector<4xi1>, %vtrue: vector<4xf32>, %vfalse: vector<4xf32>) -> vector<4xf32> {
    %vresult = "arith.select"(%vcond, %vtrue, %vfalse) : (vector<4xi1>, vector<4xf32>, vector<4xf32>) -> vector<4xf32>
    return %vresult : vector<4xf32>
  }

  func.func @test_xori(%arg0 : i64, %arg1 : i64) -> i64 {
    %0 = arith.xori %arg0, %arg1 : i64
    return %0 : i64
  }

  func.func @main(%cond: i1, %true_val: i32, %false_val: i32, %xori_a: i64, %xori_b: i64) -> (f32, i64) {
    // Regular select operation
    %select_result = "arith.select"(%cond, %true_val, %false_val) : (i1, i32, i32) -> i32
    
    // Call minui example
    %min_val = arith.constant 100 : i32
    %min_result = call @minui_example(%select_result, %min_val) : (i32, i32) -> i32
    
    // Convert to float
    %float_result = arith.uitofp %min_result : i32 to f32
    
    // Vector operations
    %vcond = arith.constant dense<[true, false, true, false]> : vector<4xi1>
    %vtrue = arith.constant dense<[1.0, 2.0, 3.0, 4.0]> : vector<4xf32>
    %vfalse = arith.constant dense<[5.0, 6.0, 7.0, 8.0]> : vector<4xf32>
    %vec_result = call @vector_select(%vcond, %vtrue, %vfalse) : (vector<4xi1>, vector<4xf32>, vector<4xf32>) -> vector<4xf32>
    
    // Call xori function
    %xor_result = call @test_xori(%xori_a, %xori_b) : (i64, i64) -> i64
    
    return %float_result, %xor_result : f32, i64
  }
}
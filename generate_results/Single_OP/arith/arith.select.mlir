module {
  func.func @main(%cond: i1, %true_val: i32, %false_val: i32) -> i32 {
    %result = "arith.select"(%cond, %true_val, %false_val) : (i1, i32, i32) -> i32
    return %result : i32
  }

  func.func @vector_select(%vcond: vector<4xi1>, %vtrue: vector<4xf32>, %vfalse: vector<4xf32>) -> vector<4xf32> {
    %vresult = "arith.select"(%vcond, %vtrue, %vfalse) : (vector<4xi1>, vector<4xf32>, vector<4xf32>) -> vector<4xf32>
    return %vresult : vector<4xf32>
  }
}
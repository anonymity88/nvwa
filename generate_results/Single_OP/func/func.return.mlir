module {
  func.func @process_data(%arg0: i32, %arg1: f32) -> (i32, f32) {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.mulf %arg1, %arg1 : f32
    func.return %0, %1 : i32, f32
  }

  func.func @main() {
    %const_i32 = arith.constant 5 : i32
    %const_f32 = arith.constant 2.5 : f32
    %result0, %result1 = func.call @process_data(%const_i32, %const_f32) : (i32, f32) -> (i32, f32)
    func.return
  }
}
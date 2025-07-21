module {
  func.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }

  func.func @process_data(%arg0: i32, %arg1: f32) -> (i32, f32) {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.mulf %arg1, %arg1 : f32
    func.return %0, %1 : i32, f32
  }

  func.func private @external_compute(i32, f32) -> f32
  func.func private @log_message()

  func.func @double(%x: i32) -> i32 {
    %0 = arith.addi %x, %x : i32
    return %0 : i32
  }

  func.func @compute_and_log(%value: i32 {dialectName.argAttribute = "input"}, %scale: f32) -> (f32 {dialectName.resAttribute = "output"}) {
    %1 = arith.mulf %scale, %scale : f32
    %2 = arith.sitofp %value : i32 to f32
    %3 = arith.mulf %2, %1 : f32
    %4 = func.call @external_compute(%value, %3) : (i32, f32) -> f32
    func.call @log_message() : () -> ()
    return %4 : f32
  }

  func.func @main() {
    // Call my_add
    %arg0 = arith.constant 1.0 : f32
    %arg1 = arith.constant 2.0 : f32
    %result_add = func.call @my_add(%arg0, %arg1) : (f32, f32) -> f32

    // Call process_data
    %const_i32 = arith.constant 5 : i32
    %const_f32 = arith.constant 2.5 : f32
    %result0, %result1 = func.call @process_data(%const_i32, %const_f32) : (i32, f32) -> (i32, f32)

    // Call compute_and_log
    %arg_i32 = arith.constant 10 : i32
    %arg_f32 = arith.constant 3.5 : f32
    %result_compute = func.call @compute_and_log(%arg_i32, %arg_f32) : (i32, f32) -> f32

    // Call double
    %doubled = func.call @double(%arg_i32) : (i32) -> i32

    func.return
  }
}
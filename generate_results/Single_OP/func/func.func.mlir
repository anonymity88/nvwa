module {
  // External function declarations
  func.func private @external_compute(i32, f32) -> f32
  func.func private @log_message()

  // A simple function that doubles its integer input
  func.func @double(%x: i32) -> i32 {
    %0 = arith.addi %x, %x : i32
    return %0 : i32
  }

  // A function with argument and result attributes
  func.func @compute_and_log(%value: i32 {dialectName.argAttribute = "input"}, %scale: f32) -> (f32 {dialectName.resAttribute = "output"}) {
    %1 = arith.mulf %scale, %scale : f32
    %2 = arith.sitofp %value : i32 to f32
    %3 = arith.mulf %2, %1 : f32
    // Call an external function to compute additional results
    %4 = func.call @external_compute(%value, %3) : (i32, f32) -> f32
    func.call @log_message() : () -> ()
    return %4 : f32
  }

  // Main function
  func.func @main() {
    %arg_i32 = arith.constant 10 : i32
    %arg_f32 = arith.constant 3.5 : f32
    %result = func.call @compute_and_log(%arg_i32, %arg_f32) : (i32, f32) -> f32
    func.return
  }
}
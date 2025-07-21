module {
  func.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }

  func.func @main() {
    %arg0 = arith.constant 1.0 : f32
    %arg1 = arith.constant 2.0 : f32
    %result = func.call @my_add(%arg0, %arg1) : (f32, f32) -> f32
    func.return 
  }
}
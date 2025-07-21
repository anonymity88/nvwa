module {
  func.func @main(%y: vector<4xf32>, %x: vector<4xf32>) -> vector<4xf32> {
    %result = spirv.CL.atan2 %y, %x : vector<4xf32>
    return %result : vector<4xf32>
  }

  func.func @another_func(%y: f64, %x: f64) -> f64 {
    %result = spirv.CL.atan2 %y, %x : f64
    return %result : f64
  }
}
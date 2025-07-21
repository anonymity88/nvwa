module {
  func.func @main(%x: f32) -> f32 {
    spirv.ReturnValue %x : f32
  }

  func.func @another_func(%y: vector<4xf32>) -> vector<4xf32> {
    spirv.ReturnValue %y : vector<4xf32>
  }
}
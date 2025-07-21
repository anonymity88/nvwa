module {
  emitc.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %result = emitc.add %arg0, %arg1 : (f32, f32) -> f32
    emitc.return %result : f32
  }

  func.func @main(%arg0: f32, %arg1: f32) -> f32 {
    %result = emitc.call @my_add(%arg0, %arg1) : (f32, f32) -> f32
    return %result : f32
  }
}
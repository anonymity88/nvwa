module {
  func.func @main(%arg0: i32, %arg1: i32, %arg2: f32, %arg3: f32) -> (i32, f32) {
    %0 = emitc.div %arg0, %arg1 : (i32, i32) -> i32
    %1 = emitc.div %arg2, %arg3 : (f32, f32) -> f32
    return %0, %1 : i32, f32
  }
}
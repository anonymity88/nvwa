module {
  emitc.func @main(%arg0 : i32) -> f32 {
    %0 = emitc.cast %arg0 : i32 to f32
    emitc.return %0 : f32
  }
}
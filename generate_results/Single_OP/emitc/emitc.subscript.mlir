module {
  func.func @main(%arg0: !emitc.array<4x8xf32>, %arg1: !emitc.ptr<i32>, %i: index, %j: index) -> () {
    %0 = emitc.subscript %arg0[%i, %j] : (!emitc.array<4x8xf32>, index, index) -> !emitc.lvalue<f32>
    %1 = emitc.subscript %arg1[%i] : (!emitc.ptr<i32>, index) -> !emitc.lvalue<i32>
    return
  }
}
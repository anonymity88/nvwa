module {
  emitc.declare_func @bar
  emitc.func @foo(%arg0: i32) -> i32 {
    %0 = emitc.call @bar(%arg0) : (i32) -> (i32)
    emitc.return %0 : i32
  }

  emitc.func @bar(%arg0: i32) -> i32 {
    emitc.return %arg0 : i32
  }
}
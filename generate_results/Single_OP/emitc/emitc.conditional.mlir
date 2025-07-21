module {
  emitc.func @main(%arg0: i32, %arg1: i32) -> i32 {
    %0 = emitc.cmp "gt", %arg0, %arg1 : (i32, i32) -> i1

    %c0 = arith.constant 10 : i32
    %c1 = arith.constant 11 : i32

    %1 = emitc.conditional %0, %c0, %c1 : i32

    emitc.return %1 : i32
  }
}
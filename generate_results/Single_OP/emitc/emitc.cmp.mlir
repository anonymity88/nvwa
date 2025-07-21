module {
  func.func @compare_integers(%arg0: i32, %arg1: i32) -> i1 {
    %0 = emitc.cmp eq, %arg0, %arg1 : (i32, i32) -> i1
    return %0 : i1
  }
  
  func.func @compare_valarrays(%arg2: !emitc.opaque<"std::valarray<float>">, %arg3: !emitc.opaque<"std::valarray<float>">) -> !emitc.opaque<"std::valarray<bool>"> {
    %1 = emitc.cmp lt, %arg2, %arg3 : (!emitc.opaque<"std::valarray<float>">, !emitc.opaque<"std::valarray<float>">) -> !emitc.opaque<"std::valarray<bool>">
    return %1 : !emitc.opaque<"std::valarray<bool>">
  }
}
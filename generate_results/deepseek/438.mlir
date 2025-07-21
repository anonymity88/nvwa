module {
  emitc.include "myheader.h" : () -> ()

  func.func @cast_func(%arg0: i32) -> f32 {
    %0 = emitc.cast %arg0 : i32 to f32
    return %0 : f32
  }

  func.func @bitwise_or_func(%arg0: i32, %arg1: i32) -> i32 {
    %0 = emitc.bitwise_or %arg0, %arg1 : (i32, i32) -> i32
    return %0 : i32
  }

  func.func @expression_with_subscript_user(%arg0: !emitc.ptr<!emitc.opaque<"void">>) -> i32 {
    %c0 = "emitc.constant"() {value = 0 : i64} : () -> i64
    %0 = emitc.expression : !emitc.ptr<i32> {
      %0 = emitc.cast %arg0 : !emitc.ptr<!emitc.opaque<"void">> to !emitc.ptr<i32>
      emitc.yield %0 : !emitc.ptr<i32>
    }
    %res = emitc.subscript %0[%c0] : (!emitc.ptr<i32>, i64) -> !emitc.lvalue<i32>
    %res_load = emitc.load %res : !emitc.lvalue<i32>
    return %res_load : i32
  }

  func.func @main() -> f32 {
    %a = arith.constant 1 : i32
    %b = arith.constant 2 : i32
    %c = arith.constant 3 : i32
    %d = arith.constant 4 : i32
    
    %r = emitc.expression : i32 {
      %0 = emitc.add %a, %b : (i32, i32) -> i32
      %1 = emitc.call_opaque "foo"(%0) : (i32) -> i32
      %2 = emitc.add %c, %d : (i32, i32) -> i32
      %3 = emitc.mul %1, %2 : (i32, i32) -> i32
      emitc.yield %3 : i32
    }
    
    %or_result = func.call @bitwise_or_func(%a, %b) : (i32, i32) -> i32
    
    %combined = emitc.add %r, %or_result : (i32, i32) -> i32
    
    %final_result = func.call @cast_func(%combined) : (i32) -> f32
    
    // Create a dummy pointer for testing the subscript function
    %dummy_ptr = "emitc.call_opaque"() {callee = "malloc", args = [1 : i64]} : () -> !emitc.ptr<!emitc.opaque<"void">>
    %subscript_result = func.call @expression_with_subscript_user(%dummy_ptr) : (!emitc.ptr<!emitc.opaque<"void">>) -> i32
    
    // Clean up
    emitc.call_opaque "free"(%dummy_ptr) : (!emitc.ptr<!emitc.opaque<"void">>) -> ()
    
    return %final_result : f32
  }
}
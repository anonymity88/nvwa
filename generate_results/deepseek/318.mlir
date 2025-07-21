module {
  emitc.include "myheader.h" : () -> ()

  func.func @main(%arg0: i32, %arg1: i32, %arg2: f32) -> (i32, f32) {
    // Bitwise operations
    %shifted = emitc.bitwise_left_shift %arg0, %arg1 : (i32, i32) -> i32
    %or_result = emitc.bitwise_or %arg0, %arg1 : (i32, i32) -> i32
    %final_result = emitc.add %shifted, %or_result : (i32, i32) -> i32

    // Call the literal function and get its result
    %literal_result = call @emitc_literal(%arg2) : (f32) -> f32

    return %final_result, %literal_result : i32, f32
  }

  func.func @emitc_literal(%arg0: f32) -> f32 {
    %p0 = emitc.literal "M_PI" : f32
    %1 = "emitc.add" (%arg0, %p0) : (f32, f32) -> f32
    return %1 : f32
  }
}
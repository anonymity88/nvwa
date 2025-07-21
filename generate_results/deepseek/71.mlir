module {
  // Main function that orchestrates all operations
  func.func @main(%arg0: i32, %arg1: i32, %arg2: f32, %arg3: f32, %valarray1: !emitc.opaque<"std::valarray<float>">, %valarray2: !emitc.opaque<"std::valarray<float>">) -> (i32, f32, i32, i1, !emitc.opaque<"std::valarray<bool>">) {
    // Integer division
    %div_i32 = emitc.div %arg0, %arg1 : (i32, i32) -> i32
    
    // Float division
    %div_f32 = emitc.div %arg2, %arg3 : (f32, f32) -> f32
    
    // Unary plus operation
    %unary_plus = emitc.unary_plus %arg0 : (i32) -> i32
    
    // Call integer comparison function
    %cmp_result = call @compare_integers(%arg0, %arg1) : (i32, i32) -> i1
    
    // Call valarray comparison function
    %valarray_cmp = call @compare_valarrays(%valarray1, %valarray2) : (!emitc.opaque<"std::valarray<float>">, !emitc.opaque<"std::valarray<float>">) -> !emitc.opaque<"std::valarray<bool>">
    
    // Return all results
    return %div_i32, %div_f32, %unary_plus, %cmp_result, %valarray_cmp : i32, f32, i32, i1, !emitc.opaque<"std::valarray<bool>">
  }

  // Integer comparison function
  func.func @compare_integers(%arg0: i32, %arg1: i32) -> i1 {
    %0 = emitc.cmp eq, %arg0, %arg1 : (i32, i32) -> i1
    return %0 : i1
  }
  
  // Valarray comparison function
  func.func @compare_valarrays(%arg0: !emitc.opaque<"std::valarray<float>">, %arg1: !emitc.opaque<"std::valarray<float>">) -> !emitc.opaque<"std::valarray<bool>"> {
    %0 = emitc.cmp lt, %arg0, %arg1 : (!emitc.opaque<"std::valarray<float>">, !emitc.opaque<"std::valarray<float>">) -> !emitc.opaque<"std::valarray<bool>">
    return %0 : !emitc.opaque<"std::valarray<bool>">
  }
}
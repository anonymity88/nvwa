module {
  func.func @main(%arg0: i32, 
                  %arg1: i32, 
                  %arg2: f32, 
                  %arg3: f32, 
                  %valarray1: !emitc.opaque<"std::valarray<float>">, 
                  %valarray2: !emitc.opaque<"std::valarray<float>">,
                  %arg4: tensor<2xf64>) -> (i32, f32, i32, i1, !emitc.opaque<"std::valarray<bool>">, tensor<2xf32>) {
    // Integer division
    %div_i32 = emitc.div %arg0, %arg1 : (i32, i32) -> i32
    
    // Float division
    %div_f32 = emitc.div %arg2, %arg3 : (f32, f32) -> f32
    
    // Unary plus operation
    %unary_plus = emitc.unary_plus %arg0 : (i32) -> i32
    
    // Integer comparison
    %cmp_result = call @compare_integers(%arg0, %arg1) : (i32, i32) -> i1
    
    // Valarray comparison
    %valarray_cmp = call @compare_valarrays(%valarray1, %valarray2) : (!emitc.opaque<"std::valarray<float>">, !emitc.opaque<"std::valarray<float>">) -> !emitc.opaque<"std::valarray<bool>">
    
    // Mixed types tensor conversion
    %tensor_result = call @mixed_types(%arg4) : (tensor<2xf64>) -> tensor<2xf32>
    
    return %div_i32, %div_f32, %unary_plus, %cmp_result, %valarray_cmp, %tensor_result : i32, f32, i32, i1, !emitc.opaque<"std::valarray<bool>">, tensor<2xf32>
  }

  func.func @compare_integers(%arg0: i32, %arg1: i32) -> i1 {
    %0 = emitc.cmp eq, %arg0, %arg1 : (i32, i32) -> i1
    return %0 : i1
  }
  
  func.func @compare_valarrays(%arg0: !emitc.opaque<"std::valarray<float>">, %arg1: !emitc.opaque<"std::valarray<float>">) -> !emitc.opaque<"std::valarray<bool>"> {
    %0 = emitc.cmp lt, %arg0, %arg1 : (!emitc.opaque<"std::valarray<float>">, !emitc.opaque<"std::valarray<float>">) -> !emitc.opaque<"std::valarray<bool>">
    return %0 : !emitc.opaque<"std::valarray<bool>">
  }

  func.func @mixed_types(%arg0: tensor<2xf64>) -> tensor<2xf32> {
    %0 = emitc.call_opaque "foo::mixed_types"(%arg0) {args = [0 : index]} : (tensor<2xf64>) -> tensor<2xf32>
    return %0 : tensor<2xf32>
  }
}
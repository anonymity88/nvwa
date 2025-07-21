emitc.include "myheader.h" : () -> ()

module {
  func.func @bitwise_not_wrapper(%arg0: i32) -> i32 {
    %0 = emitc.bitwise_not %arg0 : (i32) -> i32
    return %0 : i32
  }

  func.func @mixed_types(%arg0: tensor<2xf64>) -> tensor<2xf32> {
    %0 = emitc.call_opaque "foo::mixed_types"(%arg0) {args = [0 : index]} : (tensor<2xf64>) -> tensor<2xf32>
    return %0 : tensor<2xf32>
  }

  func.func @main(%arg0: i32, %arg1: i32, %arg2: tensor<2xf64>) -> (i32, tensor<2xf32>) {
    // Integer comparison and conditional selection
    %cmp_result = emitc.cmp "gt", %arg0, %arg1 : (i32, i32) -> i1
    %c10 = arith.constant 10 : i32
    %c11 = arith.constant 11 : i32
    %selected = emitc.conditional %cmp_result, %c10, %c11 : i32

    // Call bitwise_not wrapper
    %bitwise_not_result = call @bitwise_not_wrapper(%selected) : (i32) -> i32

    // Call mixed_types function
    %mixed_result = call @mixed_types(%arg2) : (tensor<2xf64>) -> tensor<2xf32>

    // Return both results
    return %bitwise_not_result, %mixed_result : i32, tensor<2xf32>
  }
}
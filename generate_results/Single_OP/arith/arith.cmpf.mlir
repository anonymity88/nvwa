module {
  func.func @main(%arg0: f32, %arg1: f32, %arg2: tensor<3x3xf64>, %arg3: tensor<3x3xf64>, %arg4: f16, %arg5: f16) {
    %r1 = arith.cmpf oeq, %arg0, %arg1 : f32
    %r2 = arith.cmpf ult, %arg2, %arg3 : tensor<3x3xf64>
    // Changed from f8 to f16
    %r3 = arith.cmpf oeq, %arg4, %arg5 : f16
    // Return an empty tuple (unit) as the function result
    return
  }
}
module {
  func.func @main(%arg: memref<10xf32>, %i: index) -> f32 {
    // Atomic read-modify-write operation
    %result = memref.generic_atomic_rmw %arg[%i] : memref<10xf32> {
      ^bb0(%current_value: f32):
        %c1 = arith.constant 1.0 : f32
        %inc = arith.addf %current_value, %c1 : f32
        memref.atomic_yield %inc : f32
    }

    // The result is the last value written
    return %result : f32
  }
}